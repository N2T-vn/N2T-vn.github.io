---
title : "CloudFront cho Frontend"
date : 2026-06-01
weight : 2
chapter : false
pre : " <b> 5.6.2 </b> "
---

`caerus-frontend-web` giữ nguyên trạng thái private trong suốt vòng đời của
nó. Amazon CloudFront, được thiết lập ở đây, là thứ duy nhất từng đọc được
bucket này - ngay từ bản build đầu tiên được deploy trở đi. Không có giai
đoạn trung gian nào mà site được phục vụ trực tiếp từ một S3 website endpoint
rồi sau đó mới bị khóa lại: tại thời điểm này origin duy nhất phía sau
distribution chính là bucket này; một khi API được deploy, mục 5.7.6 sẽ thêm
một origin thứ hai và một routing rule vào *cùng* distribution đó, nhưng
không có gì trong thiết lập bên dưới thay đổi khi điều đó xảy ra.

1. **Tạo một Origin Access Control** (CloudFront Console → Origin access →
   Create control setting), signing behaviour chọn **Sign requests
   (recommended)**, origin type **S3**. Đây là thứ cho phép bucket giữ được
   trạng thái hoàn toàn private trong khi vẫn có thể đọc được bởi đúng
   distribution này.

2. **Tạo distribution**, với **REST endpoint** của `caerus-frontend-web`
   (`caerus-frontend-web.s3.ap-southeast-1.amazonaws.com`) làm origin -
   không phải website endpoint, vì static website hosting không bao giờ được
   bật cho bucket này, và Origin Access Control dù sao cũng chỉ hoạt động với
   REST endpoint. Gắn OAC đã tạo ở bước 1. Đặt **Default root object:
   `index.html`**.

3. **Gắn bucket policy mà CloudFront tự tạo ra**, giới hạn phạm vi ở
   CloudFront service principal và ARN của đúng distribution này:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [{
       "Sid": "AllowCloudFrontServicePrincipal",
       "Effect": "Allow",
       "Principal": { "Service": "cloudfront.amazonaws.com" },
       "Action": "s3:GetObject",
       "Resource": "arn:aws:s3:::caerus-frontend-web/*",
       "Condition": {
         "StringEquals": {
           "AWS:SourceArn": "arn:aws:cloudfront::<account-id>:distribution/<distribution-id>"
         }
       }
     }]
   }
   ```

4. **Thêm hai custom error response**, ánh xạ cả `403` và `404` về
   `/index.html` với HTTP response code `200`. Đây là cơ chế fallback cho
   single-page-application: React Router xử lý một route như `/events/3`
   hoàn toàn ở phía client, nên khi hard refresh trên URL đó vẫn phải trả về
   `index.html` thay vì một lỗi thực sự từ S3 - vốn không hề biết route đó
   tồn tại.

5. **Build và upload site**:

   ```bash
   cd frontend && npm run build
   ```

   Upload *nội dung bên trong* của `frontend/dist/` lên gốc bucket - không
   phải bản thân thư mục `dist`. Kéo thả cả thư mục vào sẽ tạo ra
   `caerus-frontend-web/dist/index.html` thay vì
   `caerus-frontend-web/index.html`, và distribution sẽ chỉ phục vụ một
   trang trắng.

6. **Chờ distribution deploy xong**, sau đó mở domain của nó
   (`dxxxxxxxxxxxxx.cloudfront.net`) và xác nhận application load được. Các
   lệnh gọi API sẽ chưa hoạt động - vì chưa có backend nào được deploy ở
   thời điểm này trong workshop - nhưng bản thân static application phải
   render được.

{{% notice note %}}
Mỗi lần rebuild frontend sau này đều cần một **CloudFront cache
invalidation** (hoặc chờ bản cache hết hạn) trước khi thay đổi hiển thị được
- việc upload một bản `dist/` mới lên bucket không tự động khiến CloudFront
lấy lại nội dung đó. Điều này áp dụng cho mọi lần redeploy frontend còn lại
trong workshop này (mục 5.7.4, 5.7.5, và 5.7.6).
{{% /notice %}}

#### Một điều dễ gặp lỗi ở đây, nên biết trước

**Các bảo vệ WAF đi kèm của CloudFront cần những quyền IAM mà account có thể
chưa được cấp.** Việc bật các bảo vệ bảo mật Free-tier trong lúc tạo
distribution sẽ gọi `wafv2:CreateWebACL` thay mặt người dùng, nhắm vào một
tài nguyên WAF cụ thể ở **`us-east-1`** - WAF cho CloudFront luôn nằm ở đó bất
kể phần còn lại của kiến trúc dùng region nào. Nếu IAM user thiếu quyền này,
việc tạo distribution sẽ thất bại với lỗi `AccessDenied` nêu rõ action và
resource. Cách khắc phục là thêm một inline policy cấp `wafv2:CreateWebACL`
cùng các quyền đi kèm thường thấy (`UpdateWebACL`, `DeleteWebACL`,
`GetWebACL`, `TagResource`) - và, ít rõ ràng hơn, một statement *thứ hai* cho
resource type `managedruleset`, vì các bảo vệ mặc định của CloudFront tham
chiếu tới AWS Managed Rule Groups và WAF kiểm tra quyền trên cả Web ACL đang
được tạo lẫn từng managed rule group mà nó tham chiếu tới.

<!-- ![CloudFront distribution với S3 origin, OAC được gắn, và site load được tại domain của distribution](/images/5-Workshop/5.6-S3/5.6.2-cloudfront-for-frontend/example.png) -->
