---
title : "IAM Role cho việc tải ảnh lên"
date : 2026-06-01
weight : 3
chapter : false
pre : " <b> 5.6.3 </b> "
---

1. **IAM Console → Roles → Create role**, trusted entity **AWS service**,
   use case **EC2**. Đặt tên **`caerus-ec2-s3-role`** - permission boundary
   của tài khoản sẽ từ chối bất kỳ tên role nào không có tiền tố `caerus-`,
   nên đây không phải là một lựa chọn về phong cách, mà là một yêu cầu bắt
   buộc.

2. **Gắn một inline policy** giới hạn đúng ba bucket mà API cần, không hơn
   không kém:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "ReadDeployZip",
         "Effect": "Allow",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::caerus-backend/*"
       },
       {
         "Sid": "ReadWriteImages",
         "Effect": "Allow",
         "Action": ["s3:GetObject", "s3:PutObject"],
         "Resource": "arn:aws:s3:::caerus-images-dev/*"
       },
       {
         "Sid": "ReadWriteTickets",
         "Effect": "Allow",
         "Action": ["s3:GetObject", "s3:PutObject"],
         "Resource": "arn:aws:s3:::caerus-tickets-dev/*"
       }
     ]
   }
   ```

3. **Gắn role này vào EC2 instance** làm instance profile khi khởi tạo ở mục
   5.7.2 (hoặc sau đó, thông qua Actions → Security → Modify IAM role, trên
   một instance đang chạy sẵn).

**Vì sao dùng instance role thay vì một access key trong `.env`.** Một access
key được dán vào file môi trường là một secret tồn tại lâu dài, phải được
sinh ra, phân phát cho từng developer, xoay vòng (rotate) theo lịch, và giữ
ngoài version control chỉ nhờ vào kỷ luật cá nhân. Một instance role không có
gì trong số đó: AWS SDK trên instance gọi tới instance metadata service, nhận
được các thông tin xác thực tạm thời có thời hạn ngắn, giới hạn đúng theo
policy của role này, và tự động làm mới chúng trước khi hết hạn - không có
secret nào để rò rỉ, vì không hề tồn tại một secret tồn tại lâu dài nào cả. Lý
do duy nhất khiến `getSignedImageUrl()` (dùng để cấp một link tải xuống có
thời hạn cho một object private) hoạt động được mà bên gọi không bao giờ nhìn
thấy AWS credentials thô, là vì nó ký URL bằng chính các credentials của
instance role này, ngay trên instance, và chỉ URL đã ký kết quả mới rời khỏi
server.

<!-- ![Inline policy attached to caerus-ec2-s3-role](/images/5-Workshop/5.6-S3/5.6.3-iam-role/example.png) -->
