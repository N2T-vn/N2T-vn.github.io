---
title: "Blog 3"
date: 2026-06-01
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---

# AWS CONFIG VÀ CONFORMANCE PACKS

**Đăng ngày: 30-07-2026** <!-- ĐIỀN ngày -->

**Link: https://www.facebook.com/groups/awsstudygroupfcj/permalink/2228770524554574/** <!-- ĐIỀN URL bài đăng -->

### Vì sao tôi viết bài này

Một vấn đề khác tôi nghĩ hầu hết những người mới học AWS đều gặp phải: khi tạo
resource trên console, bạn có xu hướng click qua thật nhanh và bỏ qua rất
nhiều tùy chọn. Sau một thời gian, bạn không còn nhớ bucket nào đang public,
instance RDS nào bị tắt encryption, hay security group nào có một port mở ra
internet.

Điều đó dẫn tôi đến **AWS Config**, dịch vụ ghi lại trạng thái cấu hình của các
resource trong một tài khoản và đánh giá chúng dựa trên các rule đã định
nghĩa sẵn. Đi kèm với nó là **Conformance Pack**, mà tài liệu AWS mô tả là một
tập hợp các AWS Config rule và các remediation action được đóng gói để triển
khai như một thực thể duy nhất trong một tài khoản và một region, hoặc trên
toàn bộ một organization trong AWS Organizations.

Nói đơn giản: thay vì bật từng check một cách riêng lẻ, bạn có thể triển khai
cả một tập hợp rule cùng một lúc.

### Các khái niệm chính

* **Configuration Item** - một bản ghi trạng thái cấu hình của một resource
  tại một thời điểm. Mỗi khi một resource được tạo, sửa đổi, hoặc xóa, AWS
  Config tạo ra một bản ghi mới. Đó chính là thứ tạo nên lịch sử thay đổi cho
  resource đó.
* **Config Rule** - một rule đánh giá xem một resource là COMPLIANT hay
  NON_COMPLIANT. AWS cung cấp một danh sách dài các managed rule, ví dụ như
  kiểm tra xem một S3 bucket có chặn truy cập public hay không, hoặc một
  instance RDS có bật encryption hay không.
* **Remediation Action** - hành động khắc phục được thực hiện khi một resource
  không đạt yêu cầu. Nó có thể chạy tự động, hoặc thủ công sau khi được xem
  xét.

Một conformance pack là một file YAML gom các rule và remediation action này
lại với nhau.

### Có những template nào

AWS cung cấp một số mẫu template có sẵn để sử dụng ngay, có thể chọn trên
console hoặc tải về từ GitHub. Chúng thuộc về một vài nhóm chính:

* Operational Best Practices cho từng dịch vụ riêng lẻ như S3, RDS, IAM, EC2.
* Operational Best Practices theo các trụ cột (pillars) của AWS
  Well-Architected Framework.
* Các template ánh xạ theo các tiêu chuẩn quen thuộc như CIS AWS Foundations
  Benchmark, NIST 800-53, HIPAA, và PCI DSS.

Một điểm AWS nêu rất rõ trong tài liệu, và tôi nghĩ điều này quan trọng: các
mẫu template này **không được thiết kế để đảm bảo tuân thủ một tiêu chuẩn quản
trị cụ thể nào**. Chúng không thay thế cho các quy trình nội bộ và không đảm
bảo vượt qua một đợt đánh giá tuân thủ (compliance assessment). Chúng là một
công cụ hỗ trợ rà soát, không phải một chứng nhận.

### Các bước triển khai

1. Bật AWS Config trong region bạn muốn sử dụng, chọn các loại resource cần
   ghi lại, và tạo một IAM role cấp quyền cho Config đọc thông tin cấu hình.
2. Mở AWS Config Console, chọn **Conformance packs**, sau đó chọn **Deploy
   conformance pack**.
3. Chọn nguồn template. *Use sample template* lấy một template từ danh sách có
   sẵn. *Template is ready* dành cho một template của riêng bạn, có thể đến từ
   S3, từ một SSM document, hoặc được upload trực tiếp. Lưu ý rằng một template
   lớn hơn 50 KB phải được lưu trong S3.
4. Đặt tên cho conformance pack. Tên phải là duy nhất, tối đa 256 ký tự chữ và
   số, và có thể chứa dấu gạch ngang nhưng không được chứa khoảng trắng.
5. Cung cấp các tham số (parameters) nếu cần. Nhiều template chấp nhận tham số
   để điều chỉnh ngưỡng, ví dụ như tuổi tối đa của một access key. Đây là một
   cách tốt để tùy chỉnh một template mà không cần sửa trực tiếp nó.
6. Triển khai, sau đó xem lại dashboard, nơi hiển thị tỷ lệ tuân thủ
   (compliance ratio), các rule bị fail, và chính xác resource nào đang vi
   phạm.

Một lưu ý khác từ tài liệu: kiểm tra danh sách các rule có sẵn trong region bạn
định triển khai, vì không phải rule nào cũng tồn tại ở mọi region. Nếu một
template chứa một rule không được hỗ trợ, nó có thể cần được chỉnh sửa trước
khi triển khai.

### Ưu điểm

* Cả một tập hợp rule có thể được triển khai cùng một lúc, thay vì phải bật
  từng cái một bằng tay.
* Đã có sẵn các template cho từng dịch vụ riêng lẻ và cho các tiêu chuẩn quen
  thuộc, nên bạn không cần phải tự nghĩ ra checklist.
* Template ở dạng YAML, nên có thể commit lên Git và quản lý như code.
* Có thể triển khai trên nhiều tài khoản trong AWS Organizations để tạo ra một
  baseline dùng chung.
* Lịch sử cấu hình được lưu giữ, hữu ích khi bạn cần biết một thiết lập đã bị
  thay đổi vào lúc nào.

### Những điểm đáng lưu ý

**Về chi phí.** Đây là phần tôi nghĩ các bạn học viên nên đọc kỹ trước khi bật
tính năng này. AWS Config tính phí trên ba thành phần: configuration item được
ghi lại, rule evaluation, và conformance pack evaluation.

Theo trang giá, một configuration item tốn 0.003 USD cho mỗi bản ghi khi bật
continuous recording. Rule evaluation và conformance pack evaluation tốn
0.001 USD cho 100,000 lượt đầu tiên mỗi region mỗi tháng, với mức giảm theo
bậc (tiered) sau đó.

Điều đáng lưu ý là các evaluation **không nằm trong free tier**, nghĩa là
chúng bị tính phí ngay từ lượt đầu tiên. Một conformance pack chứa vài chục
rule, chạy trên nhiều resource, có thể tạo ra số lượng evaluation nhiều hơn
bạn tưởng lúc đầu rất nhiều. Nếu bạn chỉ dùng để học, tôi khuyên nên giới hạn
các loại resource được ghi lại và nhớ xóa conformance pack sau khi thử nghiệm
xong.

**Về remediation tự động.** Tôi sẽ không bật remediation tự động ngay từ đầu.
Một hành động khắc phục chạy nhầm mục tiêu có thể ảnh hưởng đến các resource
đang được sử dụng. Chạy ở chế độ thủ công trước sẽ an toàn hơn.

**Về việc đọc kết quả.** Một tỷ lệ tuân thủ (compliance ratio) 100 phần trăm
chỉ có nghĩa là các rule trong pack đó đều đã vượt qua. Nó không có nghĩa là
hệ thống đã an toàn. Ngược lại, một rule bị fail không nhất thiết là một vấn
đề, vì điều đó còn phụ thuộc vào bối cảnh sử dụng. Điều quan trọng là hiểu
được từng rule thực sự đang kiểm tra cái gì.

### Khi nào nên dùng

* Thiết lập một baseline cấu hình dùng chung trên nhiều tài khoản hoặc nhiều
  thành viên trong team.
* Nhanh chóng rà soát xem môi trường hiện tại đã lệch khỏi best practice ở đâu.
* Cần lịch sử thay đổi cấu hình để phục vụ audit hoặc điều tra sự cố.
* Muốn tự động khắc phục một loại lỗi cấu hình thường xuyên xảy ra.

Đối với một tài khoản cá nhân chỉ có vài resource, tôi sẽ bắt đầu với một hoặc
hai Config rule riêng lẻ để làm quen, rồi sau đó mới chuyển sang một
conformance pack.

### Kết luận

AWS Config trả lời hai câu hỏi mà trước đây tôi vốn khá mơ hồ: các resource
của tôi hiện đang được cấu hình như thế nào, và cấu hình đó đã thay đổi ra sao
theo thời gian.

Conformance pack có nghĩa là tôi không phải tự nghĩ ra danh sách những thứ cần
kiểm tra, và có thể bắt đầu từ một tập hợp rule mà AWS đã tổng hợp sẵn.

### Tài liệu tham khảo

* AWS Config - Conformance Packs:
  https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html
* AWS Config - Deploying Conformance Packs:
  https://docs.aws.amazon.com/config/latest/developerguide/conformance-pack-deploy.html
* AWS Config - Conformance Pack Sample Templates:
  https://docs.aws.amazon.com/config/latest/developerguide/conformancepack-sample-templates.html
* AWS Config - List of AWS Config Managed Rules:
  https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
* AWS Config Pricing:
  https://aws.amazon.com/config/pricing/

<!-- Ảnh chụp màn hình bài đăng đã publish được đặt tại
     static/images/3-BlogsPosted/3.3-Blog3/ và được tham chiếu như sau:
-->

![Bài đăng đã publish trên trang cộng đồng AWS Study Group](/images/3-BlogsPosted/3.3-Blog3/post.png)
