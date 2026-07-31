---
title : "Run the Migration, Seed, and Verify the Deployment"
date : 2026-06-01
weight : 7
chapter : false
pre : " <b> 5.7.7 </b> "
---

`caerus-db` (section 5.5) has existed since before either instance did, but
nothing has run against it - the schema was never created, and there is no
admin account to log in with. This is also the first point where the S3
buckets from section 5.6 do anything observable: nothing has written to
`caerus-images-dev` yet, because nothing has been running to write to it.

#### Run the migration and seed once

1. **From inside either instance's Session Manager session** (both point at
   the same `caerus-db`, so this runs exactly once, not once per instance):

   ```bash
   psql "$(grep DATABASE_URL .env | cut -d '=' -f2-)" -f db/migrations/001_init.sql
   psql "$(grep DATABASE_URL .env | cut -d '=' -f2-)" -f db/seed.sql
   ```

   `db/seed.sql` already carries a real bcrypt hash for `admin@caerus.local` /
   `password123` - there is no separate "create the first admin" step.

2. **Log in at the CloudFront domain** with those credentials. A failure here
   means the migration didn't reach this instance's `DATABASE_URL` - check
   that both instances' `.env` files point at the same RDS endpoint before
   assuming anything about the application code is wrong.

#### Verify the poster upload flow end to end

Because `caerus-images-dev` is private (section 5.6.1), the poster flow is
not "upload a file, store its URL, done" - it is upload the file, store the
object's **key**, and sign a fresh, time-limited URL every time the poster is
actually rendered.

3. **Open Create screening**, filling in the screening details and attaching
   a portrait 2:3 poster image (`image/jpeg` or `image/png`, up to 5 MB,
   enforced by `multer` on the way in).

4. **Trace the request**: `POST /events/:id/banner` receives the image as
   multipart form data, uploads the buffer to `caerus-images-dev` under a key
   like `events/{id}/banner.jpg`, and stores that **key** - not a URL - in
   the event's `banner_url` column.

5. **Confirm the object landed in S3**: open `caerus-images-dev` in the
   Console and find the uploaded object at the expected key - the first
   object either bucket has ever held.

6. **Reload the event list or event detail page** and confirm the poster
   renders. What actually happens on every `GET /events` request is that the
   API takes the stored key and calls `getSignedImageUrl()`, producing a
   presigned URL valid for one hour before handing the response to the
   browser - the bucket itself never becomes public, and the URL a browser
   ever sees stops working after that hour.

{{% notice note %}}
Open the browser's network tab and inspect the `bannerUrl` field in the
`GET /events` response: it is a full `https://caerus-images-dev.s3...` URL
carrying `X-Amz-Signature`, `X-Amz-Expires`, and related query parameters -
visible proof that the URL is signed and temporary, not a plain public link.
{{% /notice %}}

<!-- ![Admin logged in via CloudFront, and a created event rendering its uploaded poster through a signed URL](/images/5-Workshop/5.7-EC2/5.7.7-run-and-verify/example.png) -->
