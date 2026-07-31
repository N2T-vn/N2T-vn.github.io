---
title: "Bản đề xuất"
date: 2026-06-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Caerus - Nền tảng đặt ghế xem phim
## Đảm bảo tính toàn vẹn của ghế ngồi dưới điều kiện concurrency với các dịch vụ AWS Managed Services

### 1. Tóm tắt tổng quan (Executive Summary)

Caerus là một ứng dụng web đặt ghế xem phim được xây dựng để trình diễn một
triển khai AWS hoàn chỉnh trải rộng trên các dịch vụ compute, storage,
database, networking và monitoring. Khách hàng duyệt các suất chiếu, chọn
ghế từ sơ đồ ghế trực tiếp (live seat map), đặt tối đa sáu ghế trong một
transaction duy nhất, xem lại các lượt đặt của mình, hủy đặt trước giờ chiếu,
và tải xuống vé PDF. Quản trị viên tạo suất chiếu và tải lên hình ảnh poster.

Yêu cầu kỹ thuật cốt lõi của dự án là **một ghế không bao giờ được bán hai
lần**, ngay cả khi hai khách hàng cùng chọn một ghế tại cùng một thời điểm.
Chính ràng buộc duy nhất này quyết định việc lựa chọn cơ sở dữ liệu quan hệ,
chiến lược row-level locking trong transaction đặt ghế, và kế hoạch kiểm thử.
Mọi thứ khác trong hệ thống đều tồn tại để phục vụ cho một lượt đặt ghế chính
xác.

Nền tảng chạy tại region `ap-southeast-1` và được xây dựng bởi một đội hai
người trong bảy tuần, với backend và frontend được phát triển song song dựa
trên một hợp đồng API (API contract) chung đã được thống nhất trước khi viết
bất kỳ dòng code nào. Tầng compute và tầng dữ liệu chạy phía sau hai ranh
giới load-balancing/failover độc lập - một Application Load Balancer trải
trên hai instance EC2, và một cơ sở dữ liệu RDS Multi-AZ - với cả hai
instance và cơ sở dữ liệu đều nằm trong các private subnet không có tuyến
đường trực tiếp ra internet.

### 2. Phát biểu vấn đề (Problem Statement)

#### Vấn đề là gì?

Việc bán ghế đã được giữ chỗ khó hơn nhiều so với vẻ ngoài của nó. Cách triển
khai ngây thơ - đọc trạng thái sẵn có của ghế, rồi ghi một lượt đặt - chứa
một race condition: hai request có thể cùng đọc trạng thái "còn trống" trước
khi cái nào ghi dữ liệu, và rạp chiếu phim bán cùng một chiếc ghế hai lần.
Lỗi này diễn ra âm thầm, không thường xuyên, và chỉ xuất hiện đúng vào những
điều kiện quan trọng nhất - khi một suất chiếu ăn khách mở bán và nhiều khách
hàng cùng đổ dồn vào một vài ghế đẹp.

Một đồ án sinh viên bỏ qua vấn đề này sẽ tạo ra một hệ thống đặt ghế trông có
vẻ hoạt động tốt trong demo nhưng lại hỏng hoàn toàn khi đưa vào sản xuất.
Một dự án giải quyết được vấn đề này buộc phải suy xét về transaction,
isolation, và locking - đây chính xác là loại vấn đề mà hạ tầng cloud được
sinh ra để hỗ trợ chứ không phải để tự giải quyết một mình.

Ngoài yếu tố chính xác, một đơn vị vận hành rạp chiếu nhỏ không có đội ngũ hạ
tầng riêng. Bất kỳ giải pháp nào cũng phải chịu được việc một instance đơn lẻ
gặp sự cố mà không gây gián đoạn dịch vụ, giữ cho cơ sở dữ liệu và các máy
chủ ứng dụng tách biệt khỏi internet công cộng, và vẫn đủ khả năng quan sát
(observable) để một sự cố được phát hiện trước khi khách hàng phải báo cáo.

#### Giải pháp

Caerus lưu trữ ghế, lượt đặt, và người dùng trong Amazon RDS for PostgreSQL
và thực hiện việc đặt ghế bên trong một transaction cơ sở dữ liệu duy nhất,
khóa các dòng ghế được yêu cầu bằng `SELECT ... FOR UPDATE` trước khi kiểm
tra tình trạng còn trống. Hai request đồng thời cho cùng một ghế không thể
cùng thành công: một request giành được row lock, request còn lại bị chặn
(block), và khi bên thắng commit, bên thua nhìn thấy trạng thái đã được cập
nhật, rollback, và nhận về phản hồi `409 SEAT_ALREADY_BOOKED` nêu rõ tên các
ghế xung đột để giao diện có thể tô sáng chúng. Hoặc là mọi ghế được yêu cầu
đều được đặt thành công, hoặc không ghế nào được đặt cả.

Các thành phần còn lại được lựa chọn vì những đảm bảo thực sự mang tính chất
production chứ không phải vì phương án demo rẻ nhất có thể. Frontend React là
một static build được phục vụ qua Amazon CloudFront từ một private S3
bucket. API Express chạy trên hai instance Amazon EC2, trong các private
subnet phía sau một Application Load Balancer, để mất một instance bất kỳ
cũng không gây gián đoạn dịch vụ; việc cài đặt package và vá lỗi hệ điều hành
ra ngoài internet đi qua một NAT gateway, và các instance được quản trị qua
AWS Systems Manager Session Manager thay vì SSH, nên không có cổng inbound
nào mở ra internet cả. RDS chạy Multi-AZ, cũng nằm trong một private subnet
không có tuyến đường ra internet. Hình ảnh poster và vé PDF được sinh ra sống
trong S3, được render bởi chính API và phục vụ qua các presigned URL có thời
hạn ngắn. CloudFront cũng đứng trước API thông qua load balancer, nên toàn bộ
ứng dụng - cả site lẫn API - đều có thể truy cập qua HTTPS trên một domain
duy nhất, với AWS WAF kiểm tra traffic tại edge trước khi nó chạm tới load
balancer. Amazon CloudWatch thu thập metrics và application logs, và các
alarm gửi thông báo tới Amazon SNS khi một target trở nên unhealthy hoặc cơ
sở dữ liệu tiến gần đến giới hạn tài nguyên.

#### Lợi ích và tỷ suất đầu tư (Return on Investment)

Hệ thống thay thế việc phân bổ ghế thủ công hoặc dựa trên spreadsheet bằng
một giao diện mà khách hàng tự thao tác, và làm được điều đó với một đảm bảo
về tính chính xác có thể được chứng minh chứ không chỉ khẳng định suông. Đối
với đơn vị vận hành, kiến trúc được xây dựng có chủ đích theo đúng hình mẫu
mà một triển khai production sẽ dùng chứ không phải hình mẫu rẻ nhất chỉ đủ
để vượt qua một buổi demo: không có sự cố instance đơn lẻ nào làm sập trang
web, cơ sở dữ liệu tự động failover, và cả tầng compute lẫn tầng dữ liệu đều
không thể truy cập trực tiếp từ internet. Mọi tài nguyên đều được gắn tag
theo chủ sở hữu và theo dõi qua một billing alarm, nên chi phí vận hành thực
tế là một con số đã biết, được giám sát chứ không phải một bất ngờ.

Đối với đội dự án, dự án tạo ra bằng chứng năng lực có thể chuyển giao trên
tám dịch vụ AWS, một minh chứng cụ thể cho kiến trúc mạng phòng thủ theo
chiều sâu (defense-in-depth) (private subnet ở cả tầng compute và tầng dữ
liệu, một NAT gateway chỉ cho truy cập outbound, một load balancer và một CDN
với WAF là các điểm vào công cộng duy nhất), và một lập luận cụ thể cho việc
chọn lưu trữ quan hệ thay vì NoSQL, dựa trên một bất biến (invariant) thực sự
chứ không phải một ví dụ trong sách giáo khoa.

### 3. Kiến trúc giải pháp (Solution Architecture)

Kiến trúc tách biệt hai mối quan tâm: phân phối nội dung tĩnh và compute
mang tính giao dịch (transactional), cả hai đều có thể truy cập qua cùng một
CDN edge. Trình duyệt tải ứng dụng React và gọi API Express qua cùng một
Amazon CloudFront distribution, distribution này định tuyến theo path -
`/api/*` tới Application Load Balancer, mọi thứ khác tới private S3 site
bucket. API tự xử lý mọi thao tác, bao gồm cả việc render vé PDF, và ghi vào
S3 và RDS từ bên trong VPC.

![Caerus architecture](/images/2-Proposal/architecture.png)

<!-- GHI CHÚ cho tác giả báo cáo: thay bằng sơ đồ cuối cùng đã được rà soát,
thể hiện ALB + hai instance EC2 trong private subnet + NAT gateway, RDS
Multi-AZ trong một private subnet, và CloudFront (kèm WAF) đứng trước cả ALB
và S3 site bucket. -->

#### Các dịch vụ AWS được sử dụng

- **Amazon EC2**: Lưu trữ máy chủ API Express dưới `pm2`, hai instance trải
  trên hai Availability Zone trong các private subnet, xử lý authentication,
  liệt kê sự kiện, sơ đồ ghế, đặt ghế, hủy đặt, và sinh vé PDF.
- **Application Load Balancer**: Đường vào duy nhất tới các instance EC2,
  phân phối traffic đều trên cả hai và liên tục health-check từng instance.
- **NAT Gateway**: Cho phép các instance EC2 trong private subnet truy cập
  internet chỉ theo hướng outbound để cài đặt package và vá lỗi hệ điều hành,
  mà không bao giờ chấp nhận kết nối inbound từ internet.
- **Amazon RDS for PostgreSQL**: Lưu trữ năm bảng cốt lõi - `users`,
  `events`, `seats`, `bookings`, và `booking_seats`. Được chọn vì các
  transaction ACID và row-level locking; triển khai Multi-AZ trong một
  private subnet với failover tự động sang standby.
- **Amazon S3**: Bốn bucket private - trang React đã build (chỉ được đọc bởi
  CloudFront, không bao giờ được phục vụ trực tiếp), lưu trữ poster sự kiện,
  lưu trữ vé PDF được sinh ra, và một staging bucket cho gói triển khai
  backend.
- **Amazon CloudFront**: Một distribution, một domain HTTPS, định tuyến theo
  path giữa S3 site bucket và load balancer, với Origin Access Control giữ
  cho site bucket ở chế độ riêng tư.
- **AWS WAF**: Gắn với CloudFront distribution, kiểm tra mọi request tại edge
  theo các managed rule group trước khi nó chạm tới load balancer hoặc S3
  origin.
- **Amazon CloudWatch**: Dashboard cho EC2 CPU, RDS connections/storage/CPU,
  và số lượng request cùng tình trạng target của load balancer; log group
  cho application log của Express; alarm về tình trạng target và áp lực tài
  nguyên cơ sở dữ liệu.
- **Amazon SNS**: Gửi thông báo alarm qua email.
- **AWS IAM**: Hai người dùng developer trong một group chung, một EC2
  instance role cấp quyền truy cập S3 có phạm vi giới hạn và quản lý Systems
  Manager, không có credential nào được nhúng ở bất kỳ đâu.
- **AWS Systems Manager**: Session Manager cấp quyền truy cập shell tới cả
  hai instance EC2 để triển khai và debug, hoàn toàn qua cùng đường outbound
  mà NAT gateway đã cung cấp sẵn - không có cổng SSH nào được mở.
- **Amazon VPC**: Một cặp public subnet cho load balancer và NAT gateway,
  một cặp private subnet cho hai instance EC2, một cặp private subnet riêng
  cho RDS, và một gateway endpoint để traffic EC2-đến-S3 không bao giờ rời
  khỏi mạng AWS.

#### Thiết kế thành phần (Component Design)

- **Frontend**: Một single-page application dùng Vite và React, được build
  thành các tài nguyên tĩnh và đồng bộ vào site bucket. Mọi lời gọi API đều
  đi qua một module client duy nhất, nên việc chuyển hướng ứng dụng từ dữ
  liệu giả (mock data) sang API local rồi sang API đã triển khai chỉ là một
  thay đổi duy nhất.
- **Tầng API**: Express với các route, controller mỏng, và service chứa
  logic thực sự. Authentication là JSON Web Token không trạng thái
  (stateless); mật khẩu được hash bằng bcrypt. Transaction đặt ghế nằm trong
  một hàm service duy nhất.
- **Tầng dữ liệu**: Ghế thuộc về một suất chiếu chứ không phải một phòng vật
  lý, nên tình trạng còn trống là rõ ràng, không mơ hồ cho từng suất chiếu.
  Mỗi suất chiếu sinh ra một sơ đồ cố định gồm sáu hàng mười ghế. Tình trạng
  còn trống của ghế được lưu dưới dạng một cột để có một dòng cụ thể để khóa;
  tổng số ghế và số ghế còn trống được tính toán tại thời điểm truy vấn để
  không bao giờ bị lệch (drift).
- **Sinh vé**: API render PDF ngay trong tiến trình (in-process), ghi nó vào
  bucket vé, và trả về một pre-signed URL có thời hạn ngắn thay vì công khai
  đối tượng đó.
- **Tiền tệ và thời gian**: Giá được lưu dưới dạng số nguyên bằng đồng Việt
  Nam, không bao giờ dùng số thực (float). Tổng tiền của lượt đặt được chụp
  ảnh nhanh (snapshot) tại thời điểm mua để một thay đổi giá sau đó không thể
  viết lại lịch sử. Các timestamp được lưu trữ và truyền tải theo giờ UTC
  nhưng biểu diễn giờ chiếu theo múi giờ `Asia/Ho_Chi_Minh`, và việc lọc theo
  ngày được thực hiện dựa trên ngày theo lịch Việt Nam.

### 4. Triển khai kỹ thuật (Technical Implementation)

#### Các giai đoạn triển khai

**Giai đoạn 1 - Thiết kế hợp đồng (contract) (2 ngày).** Thống nhất đặc tả
API và schema cơ sở dữ liệu trong một phiên làm việc duy nhất trước khi viết
bất kỳ dòng code nào, và đóng băng cả hai như các tài liệu mà không bên phát
triển nào tự ý thay đổi. Đây chính là điều cho phép backend và frontend được
xây dựng đồng thời thay vì tuần tự.

**Giai đoạn 2 - Phát triển song song ở local (5 ngày).** Backend triển khai
API Express dựa trên một container PostgreSQL đóng gói bằng Docker, bao gồm
cả transaction đặt ghế và render vé PDF. Frontend xây dựng màn hình danh
sách sự kiện, chọn ghế, và các lượt đặt dựa trên các file JSON giả (mock)
được định dạng giống hệt các response đã thống nhất. Sau đó là tích hợp, kết
nối giao diện với API thực và giải quyết các điểm không khớp.

**Giai đoạn 3 - Di chuyển sang các dịch vụ AWS managed (7 ngày).** Cùng các
file SQL migration và seed được chạy trên một instance RDS Multi-AZ trong
một private subnet. Cả bốn S3 bucket được tạo. API được triển khai lên hai
instance EC2 trong các private subnet phía sau một Application Load
Balancer, chỉ có thể truy cập outbound qua một NAT gateway và được quản trị
qua Systems Manager Session Manager thay vì SSH; các security group được thu
hẹp lại sao cho cơ sở dữ liệu chỉ chấp nhận traffic từ tầng ứng dụng và tầng
ứng dụng chỉ chấp nhận traffic từ load balancer.

**Giai đoạn 4 - CDN, giám sát, và kiểm chứng (7 ngày).** Amazon CloudFront
được đặt phía trước cả load balancer và S3 site bucket để có một domain
HTTPS duy nhất, với AWS WAF được bật tại edge. Các dashboard CloudWatch, việc
chuyển tiếp log, và các alarm về sức khỏe/tài nguyên được cấu hình. Bài kiểm
thử concurrency được thực hiện trên hệ thống đã triển khai, tiếp theo là
kiểm thử các trường hợp biên (edge-case) và hoàn thiện.

#### Yêu cầu kỹ thuật

- **Phát triển local**: Node.js 20 trở lên, Docker Desktop chạy PostgreSQL
  16, và AWS CLI. Các cổng local được cố định ở 5173 cho development server,
  3000 cho API, và 5433 cho container cơ sở dữ liệu.
- **Runtime**: Amazon Linux trên EC2, Node.js được quản lý bởi `pm2` để tự
  khởi động lại khi restart-on-boot, được quản trị hoàn toàn qua Systems
  Manager Session Manager (không SSH), và một instance RDS Multi-AZ chạy
  PostgreSQL trong một private subnet.
- **Kiểm soát truy cập**: Mọi IAM role được tạo cho dự án đều mang tiền tố
  tên `caerus-`, được thực thi bởi permission boundary của account. Mọi tài
  nguyên đều được gắn tag với giá trị `Owner` xác định developer nào đã tạo
  ra nó, để chi phí có thể được quy về đúng người trong Cost Explorer.
- **Truy cập cross-origin**: Trong môi trường production, frontend và API
  được phục vụ từ cùng một domain CloudFront, nên không có request
  cross-origin nào rời khỏi trình duyệt. CORS chỉ cần cho phép local Vite dev
  server giao tiếp với một API local hoặc đã triển khai trong quá trình phát
  triển.

### 5. Lộ trình & Các mốc quan trọng (Timeline & Milestones)

Dự án chạy trong bảy tuần, từ 15/06/2026 đến 31/07/2026, nằm trong khoảng
thời gian thực tập rộng hơn.

- **Tuần 1 - Ý tưởng, API spec, và database schema.** Chọn dự án và định
  nghĩa rõ bài toán cốt lõi; danh sách API endpoint và database schema được
  thống nhất và chốt cùng nhau, trước khi tìm hiểu sâu bất kỳ dịch vụ AWS nào
  hay viết bất kỳ dòng code nào.
  *Mốc quan trọng: hợp đồng (contract) đã được chốt.*
- **Tuần 2 - Nền tảng account và Identity and Access Management.** Thiết lập
  account AWS, MFA, billing alarm, và các khái niệm nền tảng của IAM.
- **Tuần 3 - Compute, storage, và managed database.** Nền tảng EC2, S3, và
  RDS, cùng các khái niệm transaction và locking mà hệ thống đặt ghế cần đến.
- **Tuần 4 - Các endpoint cơ bản, chỉ chạy local.** Backend và frontend được
  xây dựng song song dựa trên hợp đồng đã chốt, trên một database Docker
  cục bộ. Hai endpoint cần hạ tầng AWS thật (upload poster, generate ticket)
  được cố tình hoãn lại.
  *Mốc quan trọng: ứng dụng hoàn chỉnh chạy trên localhost.*
- **Tuần 5 - Triển khai lên AWS.** RDS, S3, và EC2 được triển khai; điểm lỗi
  đơn (single point of failure) ở cả tầng compute lẫn tầng dữ liệu sau đó
  được cố tình loại bỏ bằng một EC2 instance thứ hai phía sau load balancer
  và một database Multi-AZ.
  *Mốc quan trọng: chạy trực tiếp trên AWS.*
- **Tuần 6 - Các tính năng cần AWS, CDN, network hardening, và monitoring.**
  Các endpoint đã hoãn được triển khai; CloudFront và WAF đưa toàn bộ ứng
  dụng về một domain HTTPS duy nhất; tầng compute chuyển ra sau một NAT
  gateway, không còn public IP hay SSH inbound; dashboard và alarm CloudWatch
  được cấu hình.
  *Mốc quan trọng: hoàn thiện tính năng và được kiểm chứng.*
- **Tuần 7 - Kiểm thử, viết báo cáo, và nộp bài.** Bài kiểm thử concurrency
  và các trường hợp biên được chứng minh trên hệ thống đã triển khai; báo cáo
  được viết và nộp.
  *Mốc quan trọng: đã nộp.*

Thời gian đệm được dồn vào tuần 5 và tuần 6 - hai tuần có khối lượng công
việc hạ tầng nặng nhất và khó đoán định nhất (load balancing, Multi-AZ
failover, CDN, private networking) - thay vì trải đều trên cả bảy tuần.

### 6. Dự toán ngân sách (Budget Estimation)

<!-- TODO: tạo một dự toán chính xác tại https://calculator.aws cho các
     loại/kích cỡ instance cuối cùng được chọn và dán link chia sẻ vào dòng
     dưới đây, thay cho comment này. -->

Kiến trúc này chủ đích không được tối ưu để nằm trong Free Tier - một load
balancer, một NAT gateway, và một cơ sở dữ liệu Multi-AZ đều là các chi phí
thực, tính theo giờ bất kể lượng traffic, được chấp nhận có chủ đích để đổi
lấy các đảm bảo mang tính chất production được mô tả ở Mục 3.

#### Chi phí hạ tầng

| Thành phần | Vì sao tốn chi phí | Chi phí ước tính |
|---|---|---|
| Application Load Balancer | Tính phí theo giờ bất kể traffic, cộng thêm LCU-hours khi có tải | ~US$16/tháng cơ bản |
| NAT Gateway | Tính phí theo giờ cộng với xử lý dữ liệu theo GB | ~US$32-35/tháng cơ bản |
| RDS Multi-AZ | Instance standby được tính phí giống hệt instance primary | gấp khoảng đôi so với một instance single-AZ cùng loại |
| Amazon EC2 (×2) | Hai instance chạy liên tục; tổng số giờ vượt quá hạn mức 750 giờ của Free Tier khi cả hai chạy đủ một tháng | mức vừa phải, tùy thuộc loại instance |
| Amazon CloudFront + WAF | Tính theo mức sử dụng (theo GB, theo mỗi 10.000 HTTPS request, theo mỗi rule WAF được đánh giá) | vài đô la ở mức traffic demo |
| Amazon S3 | Thấp hơn nhiều so với hạn mức Free Tier ở mức dữ liệu này | không đáng kể |
| Truyền dữ liệu | Không đáng kể ở mức traffic demo | không đáng kể |

**Tổng ước tính: khoảng US$90-110 mỗi tháng** ở mức traffic demo, chủ yếu do
chi phí theo giờ của NAT gateway và load balancer chứ không phải do mức sử
dụng thực tế - cả hai đều tiếp tục tính phí ở cùng mức bất kể ứng dụng phục
vụ một request mỗi ngày hay một nghìn request. Thay con số này bằng link
AWS Pricing Calculator đã nêu ở trên một khi được tạo dựa trên đúng loại
instance đã chọn.

Billing alarm được đặt cao hơn hẳn mức chi phí vận hành dự kiến này (khoảng
US$150) thay vì đặt ở một giá trị canh gác mang tính tượng trưng - với hồ sơ
chi phí của kiến trúc này, một ngưỡng thấp sẽ kích hoạt ngay cả khi vận hành
bình thường thay vì chỉ khi có sai sót thực sự. Mọi tài nguyên vẫn mang tag
`Owner`, nên Cost Explorer khi nhóm theo chủ sở hữu sẽ quy bất kỳ đợt tăng
vọt nào về đúng developer trong vài giây, bất kể ngưỡng alarm được đặt là
bao nhiêu.

### 7. Đánh giá rủi ro (Risk Assessment)

#### Ma trận rủi ro

| Rủi ro | Tác động | Xác suất |
|---|---|---|
| Ghế bị đặt trùng dưới các request đồng thời | Cao | Trung bình |
| Lỗi request cross-origin trong quá trình phát triển local | Thấp | Trung bình |
| Chi phí hàng tháng vượt quá ước tính (giờ NAT/ALB không hoạt động vẫn cộng dồn kể cả khi không có traffic) | Trung bình | Trung bình |
| Một rule edge cấu hình sai (cache policy của CDN, managed rule của WAF) âm thầm làm hỏng một request hợp lệ | Trung bình | Trung bình |
| Mất quyền quản trị tới một instance EC2 trong private subnet | Trung bình | Thấp |
| Việc triển khai tiêu tốn thời gian dành cho các giai đoạn sau | Trung bình | Trung bình |

#### Chiến lược giảm thiểu

- **Concurrency**: Khóa các dòng ghế bằng `SELECT ... FOR UPDATE` theo thứ
  tự khóa chính (primary key), để mọi transaction đồng thời giành khóa theo
  cùng một trình tự và không thể deadlock. Xác minh bằng conditional update
  và kiểm tra số dòng bị ảnh hưởng (affected row count), để một luồng code
  bỏ qua khóa sẽ bị phát hiện thay vì âm thầm được bỏ qua.
- **Request cross-origin**: Coi CORS là mối quan tâm chỉ dành cho môi trường
  phát triển local, vì traffic production là same-origin qua CloudFront;
  cấu hình rõ ràng các origin local được phép trên API thay vì tìm cách né
  tránh trình duyệt.
- **Chi phí**: Một billing alarm được đặt dựa trên mức chi phí vận hành thực
  tế (không phải một giá trị mang tính tượng trưng), một tag chủ sở hữu trên
  mọi tài nguyên, và quyền truy cập billing chỉ đọc cho các người dùng
  developer để cấu hình alarm không thể bị vô tình tắt đi.
- **Cấu hình sai ở edge**: Coi cache policy của CDN và WAF là những thứ có
  thể âm thầm làm hỏng một request hợp lệ chứ không chỉ luôn luôn chặn kẻ tấn
  công - xác minh một vòng request/response thực sự qua edge cho mọi loại
  nội dung (response API JSON, tải tệp lên) trước khi coi tầng đó là hoàn
  thành, chứ không chỉ với các tài nguyên tĩnh.
- **Truy cập quản trị**: Systems Manager Session Manager phụ thuộc vào việc
  instance kết nối outbound tới các endpoint SSM của AWS, điều này lại phụ
  thuộc vào NAT gateway; nếu đường kết nối đó bị gián đoạn, phương án dự
  phòng là một bastion host tạm thời trong một public subnet thay vì mở lại
  SSH trên các instance private.
- **Lịch trình**: Các ngày đệm ở cuối hai tuần bận rộn nhất, và một frontend
  hoạt động dựa trên dữ liệu giả (mock data) để không bao giờ bị chặn chờ
  backend.

#### Kế hoạch dự phòng

- Nếu môi trường đã triển khai gặp sự cố trong buổi trình diễn, trình bày
  dựa trên môi trường Docker local, môi trường này chạy cùng schema và code
  giống hệt.
- Nếu việc cấu hình CloudFront/WAF chưa hoàn thành kịp thời, endpoint HTTP
  riêng của Application Load Balancer vẫn có thể truy cập trực tiếp như một
  phương án dự phòng, vì hành vi của API không phụ thuộc vào tầng nào đứng
  phía trước nó.
- Ghi hình trước một video trình diễn để một sự cố trực tiếp không ngăn cản
  việc trình bày công sức đã bỏ ra.

### 8. Kết quả kỳ vọng (Expected Outcomes)

#### Cải tiến kỹ thuật

Một ứng dụng đặt ghế có thể truy cập công khai, trong đó tình trạng còn
trống của ghế chính xác dưới tải đồng thời, được xác minh bằng một cuộc đua
(race) có chủ đích giữa hai client cho cùng một ghế, tạo ra đúng một lượt đặt
thành công và một phản hồi xung đột. Khả năng quan sát vận hành thông qua các
dashboard bao phủ mọi hạng mục dịch vụ, với một alarm được chứng minh là kích
hoạt và gửi thông báo thực sự chứ không chỉ được cấu hình suông, và một tầng
compute cùng tầng dữ liệu đều không thể truy cập từ internet nhờ thiết kế
mạng chứ không chỉ nhờ kỷ luật security-group.

#### Giá trị lâu dài

Dự án tạo ra một minh chứng hoạt động cho thiết kế hạ tầng phòng thủ theo
chiều sâu (defense-in-depth): một edge công khai (CDN cộng WAF) là điểm vào
duy nhất, một tầng compute private được cân bằng tải mà không gì có thể tiếp
cận ngoài edge đó, và một tầng dữ liệu private, Multi-AZ mà không gì có thể
tiếp cận ngoài tầng compute - mỗi tầng đều fail closed (đóng lại an toàn khi
lỗi) thay vì fail open nếu một tầng phía trên bị cấu hình sai. Nó cũng tạo ra
một lập luận dựa trên bằng chứng cho việc lưu trữ quan hệ: bất biến của việc
đặt ghế không thể được biểu diễn với chi phí thấp nếu thiếu transaction,
trong khi một tính năng phụ trợ như các sự kiện đã xem gần đây lại phù hợp
một cách tự nhiên với một kho lưu trữ key-value. Cả hai lập luận đều bắt
nguồn từ chính hệ thống này chứ không phải từ một so sánh chung chung, và cả
hai đều có thể tái sử dụng cho công việc thiết kế trong tương lai.
