---
title: "Blog 2"
date: 2026-06-01
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

# SEATGEEK KIỂM SOÁT AUTHORIZATION, AUTHENTICATION VÀ RATE LIMITING TRONG MỘT ỨNG DỤNG SAAS ĐA TENANT NHƯ THẾ NÀO

**Đăng ngày: 23-07-2026**

**Link: https://www.facebook.com/groups/awsstudygroupfcj/permalink/2222000205231606/**

### Vì sao tôi viết bài này

Một trong những vấn đề khó hơn khi xây dựng một hệ thống SaaS phục vụ nhiều
khách hàng cùng lúc là: làm sao đảm bảo khách hàng A không thể vô tình, hoặc cố
tình, chiếm dụng toàn bộ năng lực dùng chung (shared capacity) và làm giảm chất
lượng dịch vụ cho khách hàng B?

Đây chính xác là vấn đề mà SeatGeek gặp phải. Họ là một nền tảng bán vé phục vụ
hàng chục triệu vé mỗi ngày, và cách họ giải quyết vấn đề này bằng các dịch vụ
serverless của AWS đã dạy cho tôi vài điều đáng chia sẻ lại.

### Bối cảnh: khi mỗi service tự xử lý authentication của riêng mình

Trước đây, các đối tác B2B truy vấn dữ liệu kinh doanh của SeatGeek - có thể
lên đến hàng terabyte - thông qua một số công cụ identity và access khác nhau.
Vấn đề là mỗi ứng dụng nội bộ tự triển khai logic authorization của riêng mình.
Điều đó đồng nghĩa với công sức bị trùng lặp, không có sự chuẩn hóa, và ngày
càng khó kiểm soát khi số lượng tenant tăng lên.

SeatGeek đặt ra ba tiêu chí khi tìm kiếm giải pháp:

1. Tiếp tục sử dụng Auth0, identity provider đã có sẵn.
2. Tránh tăng thêm gánh nặng vận hành hạ tầng, ưu tiên ghép nối các dịch vụ
   serverless được quản lý sẵn (managed).
3. Mở rộng quy mô mượt mà theo nhu cầu, mà không phải trả tiền cho năng lực
   nhàn rỗi hoặc bị over-provisioned.

### Các điểm chính

**API Gateway là cửa ngõ duy nhất, không có logic auth trong từng service
riêng lẻ.** Mọi API của SeatGeek đều đi qua một gateway duy nhất, nơi một
Lambda authorizer tùy chỉnh xác thực token, thay vì từng backend service tự
làm việc này một cách độc lập.

**Usage plan phân cấp để ngăn vấn đề noisy neighbour.** SeatGeek tạo ra các
plan phân cấp - bronze, silver, gold - mỗi plan có giới hạn requests-per-second
riêng. Mỗi tenant nhận một API key gắn với một usage plan cụ thể, nên không
tenant nào có thể chiếm dụng năng lực dùng chung mà các tenant khác đang phụ
thuộc vào.

**DynamoDB là cầu nối vô hình giữa Auth0 và API Gateway.** Thay vì để tenant tự
quản lý API key của mình, DynamoDB lưu giữ một bảng ánh xạ giữa tenant ID, do
Auth0 quản lý, và API key, do API Gateway quản lý. Việc quản lý key trở nên
hoàn toàn trong suốt (transparent) đối với tenant.

**Tự động hóa việc onboarding tenant bằng Terraform.** Khi một tenant mới xuất
hiện, hệ thống tự động tạo tenant ID trong Auth0, tạo một API key mới trong API
Gateway, và lưu liên kết đó trong DynamoDB. Không có bước thủ công nào.

### Theo dõi một request

Một đối tác B2B muốn truy vấn dữ liệu bán vé trong mười hai tháng. Luồng xử lý
diễn ra như sau:

```
Tenant
  -> Auth0 (machine-to-machine authentication)
  -> JWT token
  -> API Gateway
  -> Lambda authorizer
  -> DynamoDB (tra cứu API key theo tenant ID)
  -> API Gateway kiểm tra rate limit dựa trên usage plan
  -> Backend xử lý request
```

**Bước authentication.** Tenant xác thực theo cơ chế machine-to-machine và
nhận về một JWT chứa các claim cần thiết cho bước authorization tiếp theo:
tenant ID, thời hạn (expiry), scope, và chữ ký (signature).

**Bước authorization.** API Gateway trích xuất token từ request và chuyển cho
Lambda authorizer. Authorizer lấy về key xác thực token từ Auth0 - và chi tiết
thú vị ở đây là key này được **cache ngay trong bộ nhớ của chính authorizer**,
nên Auth0 chỉ được gọi một lần cho mỗi lần khởi động execution environment của
Lambda. Điều đó giảm độ trễ và tránh gây quá tải cho identity provider.

**Bước rate limiting.** Sau khi authorizer đã xác thực token và trả về API key
tương ứng từ DynamoDB, API Gateway kiểm tra xem tenant đó đã vượt quá rate
limit của usage plan hay chưa. Nếu có, API Gateway trả về ngay HTTP 429 Too
Many Requests - request không bao giờ đến được backend.

Một chi tiết khác tôi rất thích: API Gateway có thể cache kết quả của
authorizer trong tối đa năm phút, nên cùng một token sẽ không bị xác thực lại
nhiều lần trong khoảng thời gian đó. Điều này giảm tải đáng kể cho cả Lambda và
DynamoDB.

### Kết luận

Điều khiến tôi ấn tượng nhất về kiến trúc của SeatGeek là cách họ tách hoàn
toàn logic authorization ra khỏi từng business service riêng lẻ, biến nó thành
một lớp dùng chung tại API Gateway. Điều đó giải quyết cùng lúc hai vấn đề: nó
chuẩn hóa việc authentication trên toàn hệ thống, và loại bỏ nhu cầu mỗi team
phải tự phát minh lại cùng một thứ.

Tôi cũng học được rằng caching ở đây không chỉ là một tối ưu về hiệu năng. Nó
còn đóng vai trò kiểm soát chi phí và bảo vệ cho một identity provider bên
ngoài. Việc cache key xác thực token bên trong Lambda, kết hợp với việc cache
kết quả của authorizer ở tầng API Gateway, là một pattern caching nhiều tầng
(multi-level caching) đáng áp dụng cho bất kỳ hệ thống nào cần xác thực với
tần suất cao.

Đối với bất kỳ ai đang tìm hiểu cách xây dựng một SaaS đa tenant đúng cách,
đây là một case study có giá trị: bạn không cần phải tự xây dựng một identity
service phức tạp. Việc kết hợp cẩn thận API Gateway, một Lambda authorizer, và
DynamoDB là đủ để tạo ra một lớp bảo vệ vừa chuẩn hóa vừa rẻ để vận hành.

### Tài liệu tham khảo

* How SeatGeek uses AWS Serverless to control authorization, authentication, and
  rate-limiting in a multi-tenant SaaS application - AWS Architecture Blog:
  https://aws.amazon.com/blogs/architecture/how-seatgeek-uses-aws-to-control-authorization-authentication-and-rate-limiting-in-a-multi-tenant-saas-application/

<!-- Ảnh chụp màn hình bài đăng đã publish được đặt tại
     static/images/3-BlogsPosted/3.2-Blog2/ và được tham chiếu như sau:

-->
![Bài đăng đã publish trên trang cộng đồng AWS Study Group](/images/3-BlogsPosted/3.2-Blog2/post.png)
