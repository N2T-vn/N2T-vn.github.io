---
title: "Blog 1"
date: 2026-06-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# AWS BUDGETS VÀ COST ANOMALY DETECTION

**Đăng ngày: 30-07-2026** <!-- ĐIỀN ngày -->

**Link: https://www.facebook.com/groups/awsstudygroupfcj/permalink/2229088634522763/** <!-- ĐIỀN URL bài đăng -->

### Vì sao tôi viết bài này

Một vấn đề tôi nghĩ hầu hết các bạn mới học đều gặp phải: bạn tạo resource để
thực hành, rồi quên xóa đi. Free Tier có giới hạn, và một khi vượt qua giới
hạn đó, chi phí bắt đầu phát sinh mà không có bất kỳ tín hiệu cảnh báo nào. Bạn
chỉ biết được khi mở hóa đơn vào cuối tháng.

Khi tìm hiểu, tôi phát hiện ra hai công cụ trong nhóm quản lý chi phí của AWS
giải quyết vấn đề này theo hai hướng khác nhau. **AWS Budgets** cho phép bạn
đặt một ngưỡng chi tiêu và được thông báo khi mức chi tiêu thực tế hoặc dự báo
vượt qua ngưỡng đó. **AWS Cost Anomaly Detection** sử dụng machine learning để
học thói quen chi tiêu của một tài khoản, sau đó cảnh báo khi mức chi tiêu đi
lệch khỏi thói quen đó.

Nói đơn giản, Budgets trả lời câu hỏi "tôi đã vượt ngưỡng mình đặt ra chưa",
còn Cost Anomaly Detection trả lời câu hỏi "có khoản chi nào trông bất thường
không". Hai công cụ này bổ trợ cho nhau.

### Các khái niệm chính

* **Budget** - một ngưỡng chi phí hoặc mức sử dụng do bạn định nghĩa. AWS
  Budgets hỗ trợ cost budget, usage budget, và budget theo dõi mức sử dụng
  (utilisation) và độ bao phủ (coverage) của Reserved Instances và Savings
  Plans.
* **Alert** - thông báo được gửi khi một ngưỡng bị vượt qua. Nó có thể được
  thiết lập dựa trên chi tiêu thực tế hoặc chi tiêu dự báo. Alert dựa trên dự
  báo (forecast alert) hữu ích hơn trong hai loại, vì nó kích hoạt khi AWS dự
  đoán bạn *sẽ* vượt ngưỡng, giúp bạn có thời gian để hành động trước.
* **Budget Action** - một phản ứng tự động khi một ngưỡng bị vượt qua. Một
  action có thể áp dụng một IAM policy, áp dụng một Service Control Policy,
  hoặc dừng các instance EC2 và RDS.
* **Cost Monitor** - đối tượng của Cost Anomaly Detection định nghĩa những gì
  đang được theo dõi.
* **Alert Subscription** - cấu hình về việc ai sẽ nhận cảnh báo, tần suất ra
  sao, và ở ngưỡng nào.

### Cost Anomaly Detection có thể theo dõi những gì

Chi tiêu có thể được phân đoạn theo bốn chiều: AWS Services, Linked Accounts,
Cost Allocation Tags, và Cost Categories.

Đối với một tài khoản cá nhân, một monitor theo AWS Services là lựa chọn phù
hợp. Loại monitor này tự động bao gồm các dịch vụ mới ngay khi bạn bắt đầu sử
dụng chúng, nên không cần phải cấu hình lại mỗi khi bạn thử một thứ mới. Giới
hạn là một AWS Service monitor và tối đa 500 custom monitor.

Alert subscription có ba tần suất. Thông báo DAILY và WEEKLY được gửi qua
email; IMMEDIATE được gửi qua SNS.

Một điểm dễ hiểu nhầm: ngưỡng alert chỉ quyết định *khi nào một thông báo được
gửi đi*, chứ không ảnh hưởng đến cách thuật toán phát hiện hoạt động. Các
anomaly dưới ngưỡng vẫn được ghi nhận và hiển thị trên console - chúng chỉ đơn
giản là không kích hoạt một cảnh báo.

### Tạo một budget

1. Mở AWS Billing and Cost Management Console và chọn **Budgets**, sau đó tạo
   một budget mới.
2. Chọn loại budget. Để theo dõi hóa đơn cơ bản, cost budget là thứ bạn cần.
3. Đặt tên, kỳ hạn (period, thường là hàng tháng), và số tiền ngưỡng. Bạn có
   thể giới hạn phạm vi budget theo các dịch vụ cụ thể ở đây nếu chỉ muốn theo
   dõi EC2 hoặc RDS thay vì toàn bộ tài khoản.
4. Cấu hình alert. Nhập ngưỡng dưới dạng phần trăm hoặc một số tiền tuyệt đối,
   chọn chi tiêu thực tế hay chi tiêu dự báo, và nhập email nhận thông báo. Tôi
   sẽ đặt vài mức, ví dụ 50, 80, và 100 phần trăm, để phát hiện sớm thay vì chỉ
   biết khi đã vượt ngưỡng.
5. Review và tạo. Một email xác nhận sẽ được gửi tới mỗi địa chỉ bạn đã nhập,
   và nó phải được xác nhận trước khi thông báo có thể được gửi đi.

### Tạo một cost monitor

1. Trong cùng console, chọn **Cost Anomaly Detection** và tạo một monitor mới.
2. Chọn loại monitor - AWS Services đối với một tài khoản cá nhân.
3. Tạo một alert subscription, chọn tần suất và nhập một địa chỉ email hoặc
   SNS topic.
4. Nhập ngưỡng alert, dưới dạng một số tiền tuyệt đối hoặc dưới dạng phần trăm
   cao hơn mức chi tiêu dự kiến.
5. Tạo monitor, sau đó chờ. Một monitor mới có thể mất đến 24 giờ để bắt đầu
   phát hiện, và mô hình cần khoảng 10 ngày dữ liệu chi tiêu lịch sử cho một
   dịch vụ trước khi có thể phát hiện anomaly trong dịch vụ đó.

### Ưu điểm

* Bạn biết được vấn đề về chi phí trong vòng vài giờ đến một ngày, thay vì
  phải đợi đến cuối tháng.
* Alert dựa trên dự báo cho bạn thời gian để hành động trước khi thực sự vượt
  ngưỡng.
* Cost Anomaly Detection không yêu cầu một ngưỡng cho từng dịch vụ, vì nó tự
  học xem điều gì là bình thường.
* Alert đi kèm với phân tích nguyên nhân gốc rễ (root cause analysis), xác
  định dịch vụ hoặc loại sử dụng nào gây ra mức chi tiêu bất thường.
* Budget Actions cho phép can thiệp tự động thay vì chỉ dừng lại ở thông báo.
* Theo dõi theo tag hoặc cost category giúp có thể tách riêng chi phí theo
  từng dự án.

### Những điểm đáng lưu ý

**Về chi phí.** Đây là phần tôi thấy dễ hiểu sai nhất, vì nhiều bài viết trên
mạng mang thông tin đã lỗi thời. Theo trang giá hiện tại của AWS, việc theo
dõi một budget và nhận thông báo là **miễn phí**. Thứ bị tính phí là Budget
Actions: hai budget đầu tiên có bật action mỗi tháng là miễn phí, sau đó mỗi
budget có bật action tốn 0.10 USD mỗi ngày. AWS Budgets Reports, tức là các
báo cáo theo lịch được gửi qua email, tốn 0.01 USD cho mỗi báo cáo được gửi.
Cost Anomaly Detection là miễn phí, bao gồm cả việc tạo monitor, phát hiện, và
gửi cảnh báo. Vậy nên, đối với việc theo dõi hóa đơn cá nhân, gần như không
tốn chi phí gì.

**Về độ trễ.** Cả hai công cụ đều không hoạt động theo thời gian thực. Dữ liệu
budget được làm mới khoảng ba lần một ngày, và Cost Anomaly Detection đánh giá
một lần mỗi ngày. Đây là điều đáng chấp nhận hơn là khó chịu: cả hai đều phát
hiện vấn đề sớm hơn nhiều so với việc chờ hóa đơn, nhưng không công cụ nào
ngăn được chi phí phát sinh ngay tại thời điểm đó.

**Về tài khoản mới.** Vì mô hình cần dữ liệu lịch sử, Cost Anomaly Detection
sẽ không hiệu quả trên một tài khoản vừa mở hoặc một dịch vụ bạn mới bắt đầu sử
dụng. Trong giai đoạn đầu đó, AWS Budgets với ngưỡng được thiết lập thủ công là
thứ nên dựa vào.

**Về Budget Actions.** Cân nhắc kỹ trước khi bật các action tự động. Việc tự
động dừng các instance EC2 hoặc áp dụng một IAM policy có thể ảnh hưởng đến các
resource đang được sử dụng. Nếu tài khoản chỉ dùng để học, một email cảnh báo
là đủ.

**Về việc đặt ngưỡng.** Một ngưỡng đặt quá thấp sẽ tạo ra những thông báo bạn
không cần, và sau một thời gian bạn bắt đầu bỏ qua chúng. Đặt quá cao, cảnh báo
sẽ đến quá muộn để còn có ý nghĩa.

### Khi nào nên dùng

* Dùng một tài khoản cá nhân để học và muốn tránh các khoản chi phí bất ngờ.
* Cần giới hạn chi tiêu cho một môi trường cụ thể, chẳng hạn như môi trường
  development.
* Muốn phát hiện các resource bị bỏ quên chạy do sơ ý.
* Cần tách riêng và theo dõi chi phí theo từng dự án hoặc từng team.
* Muốn can thiệp tự động khi chi tiêu vượt ngưỡng, thay vì chỉ dừng lại ở
  thông báo.

Đối với một tài khoản cá nhân, tôi sẽ bắt đầu với một cost budget đơn giản
theo toàn tài khoản với vài mức cảnh báo, sau đó bật Cost Anomaly Detection
khi đã có vài tuần dữ liệu chi tiêu.

### Kết luận

Hai công cụ trả lời hai câu hỏi khác nhau. AWS Budgets hoạt động dựa trên một
ngưỡng bạn tự đặt ra, nên phù hợp khi bạn đã biết mình muốn chi bao nhiêu. Cost
Anomaly Detection tự học mức chi tiêu bình thường, nên nó bắt được những mức
tăng bất thường mà bạn sẽ không bao giờ nghĩ đến việc đặt một ngưỡng cho nó.

Điều tôi thấy đáng nói nhất là việc giám sát và cảnh báo ở cả hai công cụ đều
miễn phí, vậy mà đây lại chính xác là thứ thường bị bỏ qua khi mới bắt đầu học
AWS.

### Tài liệu tham khảo

* AWS Budgets - Managing your costs with AWS Budgets:
  https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html
* AWS Budgets Pricing:
  https://aws.amazon.com/aws-cost-management/aws-budgets/pricing/
* AWS Cost Anomaly Detection - Detecting unusual spend:
  https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
* AWS Cost Anomaly Detection - FAQs:
  https://aws.amazon.com/aws-cost-management/aws-cost-anomaly-detection/faqs/
* AWS Cost Management API - AnomalySubscription:
  https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_AnomalySubscription.html

<!-- Ảnh chụp màn hình bài đăng đã publish được đặt tại
     static/images/3-BlogsPosted/3.1-Blog1/ và được tham chiếu như sau:
-->
![Bài đăng đã publish trên trang cộng đồng AWS Study Group](/images/3-BlogsPosted/3.1-Blog1/post.png)
