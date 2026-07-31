---
title : "Chạy Migration, Seed, và Kiểm Chứng Toàn Bộ Triển Khai"
date : 2026-06-01
weight : 7
chapter : false
pre : " <b> 5.7.7 </b> "
---

`caerus-db` (mục 5.5) đã tồn tại từ trước cả khi hai instance có mặt, nhưng
chưa có gì từng chạy trên nó - schema chưa được tạo, và cũng chưa có tài
khoản admin nào để đăng nhập. Đây cũng là điểm đầu tiên mà các bucket S3 ở
mục 5.6 làm được điều gì đó có thể quan sát được - chưa có gì ghi vào
`caerus-images-dev` cả, vì chưa có gì đang chạy để ghi vào đó.

#### Chạy migration và seed đúng một lần

1. **Từ bên trong phiên Session Manager của một trong hai instance** (cả hai
   đều trỏ tới cùng `caerus-db`, nên thao tác này chạy đúng một lần, không
   phải một lần cho mỗi instance):

   ```bash
   psql "$(grep DATABASE_URL .env | cut -d '=' -f2-)" -f db/migrations/001_init.sql
   psql "$(grep DATABASE_URL .env | cut -d '=' -f2-)" -f db/seed.sql
   ```

   `db/seed.sql` đã có sẵn một bcrypt hash thật cho `admin@caerus.local` /
   `password123` - không có bước "tạo admin đầu tiên" riêng biệt nào cả.

2. **Đăng nhập tại domain CloudFront** với thông tin đăng nhập đó. Nếu thất
   bại ở đây, nghĩa là migration chưa chạm tới `DATABASE_URL` của instance
   đang phục vụ request - kiểm tra xem cả hai file `.env` có trỏ cùng một
   RDS endpoint trước khi nghi ngờ code ứng dụng có vấn đề.

#### Kiểm chứng luồng upload poster end-to-end

Vì `caerus-images-dev` là private (mục 5.6.1), luồng xử lý poster không đơn
giản là "upload một file, lưu URL của nó, xong" - mà là upload file, lưu lại
**key** của object, và ký một URL mới, có thời hạn, mỗi lần poster thực sự
được render.

3. **Mở Create screening**, điền các thông tin của suất chiếu và đính kèm
   một ảnh poster khổ dọc 2:3 (`image/jpeg` hoặc `image/png`, tối đa 5 MB,
   được `multer` kiểm tra khi nhận vào).

4. **Theo dõi request**: `POST /events/:id/banner` nhận ảnh dưới dạng
   multipart form data, upload buffer lên `caerus-images-dev` với một key
   dạng `events/{id}/banner.jpg`, và lưu **key** đó - không phải một URL -
   vào cột `banner_url` của sự kiện.

5. **Xác nhận object đã lên S3**: mở `caerus-images-dev` trong Console và tìm
   object đã upload tại đúng key mong đợi - object đầu tiên mà bucket này
   từng chứa.

6. **Tải lại trang danh sách sự kiện hoặc trang chi tiết sự kiện** và xác
   nhận poster hiển thị đúng. Điều thực sự xảy ra trên mỗi request
   `GET /events` là API lấy key đã lưu và gọi `getSignedImageUrl()`, tạo ra
   một presigned URL có hiệu lực trong một giờ trước khi trả response về cho
   trình duyệt - bản thân bucket không bao giờ trở thành public, và URL mà
   trình duyệt nhìn thấy sẽ ngừng hoạt động sau một giờ đó.

{{% notice note %}}
Mở tab network của trình duyệt và kiểm tra trường `bannerUrl` trong response
của `GET /events`: đó là một URL đầy đủ dạng
`https://caerus-images-dev.s3...` mang theo `X-Amz-Signature`,
`X-Amz-Expires`, và các tham số query liên quan - bằng chứng rõ ràng rằng URL
đã được ký và có thời hạn, không phải một link public thông thường.
{{% /notice %}}

<!-- ![Admin logged in via CloudFront, and a created event rendering its uploaded poster through a signed URL](/images/5-Workshop/5.7-EC2/5.7.7-run-and-verify/example.png) -->
