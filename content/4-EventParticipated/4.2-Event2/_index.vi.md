---
title: "Sự kiện 2"
date: 2026-06-01
weight: 2
chapter: false
pre: " <b> 4.2. </b> "
---

# Báo cáo tóm tắt: FCAJ Agentic AI Build Week — Community Day

### Mục tiêu sự kiện

- Trình bày các hệ thống được các đội xây dựng trong hackathon Agentic AI
  Build Week
- Cho thấy các pattern agentic AI được lắp ráp từ các dịch vụ AWS trong thực
  tế như thế nào
- Chia sẻ trải nghiệm xây dựng một prototype end-to-end trong thời hạn 24
  giờ, bao gồm cả những gì đã diễn ra sai
- Cho những người tham gia lần đầu một cái nhìn thực tế về việc tham gia một
  hackathon là như thế nào

### Các đội trình bày

- **Plan V** — *Solution Architect Professional Native App*
  (Pham Tien Thuan Phat, Huynh Hoang Long, Le Minh Nghia, Tran Dai Vi, Nguyen An)
- **Signal Scout** — *Nền tảng phát hiện tín hiệu doanh nghiệp*
  (Le Tan Luc, Do Hoang Hieu, Trieu Quoc Hao, Nguyen Duy Khiem, Nguyen Cong Minh, Nguyen Tran Minh Quan)
- **One Team** — *KFC Bot Agent*, đội vô địch AABW Hackathon
  (Anh Duy, Tran Dong, Doan Trung, Minh Viet, Anshul Roy)
- **3KA** — *S.H.E.P.H.E.R.D* và hành trình hackathon
  (Huynh An Khuong, Nguyen Quoc Huy, Ngo Quang Khoi, Hoang Le Thanh Duc, Dang Nguyen Phuoc Loc, Dang Truong Hung)

---

### Điểm nổi bật chính

#### Plan V — Solution Architect Professional Native App

Vấn đề được đặt ra như một cuộc trò chuyện mà bất kỳ ai làm consulting cũng sẽ
nhận ra: một khách hàng yêu cầu thiết kế một hệ thống AI cho các tài liệu quy
trình vận hành chuẩn (standard operating procedure) của họ, muốn có nó vào thứ
Năm, rồi lại muốn có nó ngay lập tức. Trong khi đó, solution architect phải
trích xuất yêu cầu, phác thảo kiến trúc ban đầu, tạo ra sơ đồ, và ước tính chi
phí cloud.

Công cụ của họ giải quyết từng bước đó. Nó phân tích yêu cầu từ ngôn ngữ tự
nhiên và các tài liệu có cấu trúc, phác thảo các phương án kiến trúc nhận biết
được hybrid-cloud và phù hợp với chuẩn mực công ty, tạo ra các sơ đồ có thể
chỉnh sửa bằng các icon kiến trúc chính thức của AWS, tạo ra các ước tính chi
phí mang tính định hướng cho region `ap-southeast-1`, và tự nêu ra các giả
định của chính nó cũng như những khoảng trống nó tìm thấy trong yêu cầu. Việc
tinh chỉnh diễn ra qua một thanh chat bên cạnh (chat sidebar) với các chỉ dẫn
tùy chỉnh (custom instructions) theo từng dự án.

So sánh trước và sau là phần rõ ràng nhất của bài trình bày:

| Trước | Sau |
|---|---|
| Đọc tài liệu yêu cầu từng dòng, thủ công | Upload và chat tự nhiên — một catalogue yêu cầu trong vài phút |
| Bắt đầu từ trang giấy trắng mỗi lần | Một bản nháp đầu tiên có căn cứ để phản hồi lại |
| Viết infrastructure as code thủ công | Infrastructure as code được sinh tự động |
| Ước tính chi phí bằng cách đoán mò dựa vào kinh nghiệm | Một ước tính mang tính định hướng được tạo ra song song với kiến trúc |

Điều tôi thấy đáng chú ý là cách họ định vị đầu ra là *một bản nháp đầu tiên để
phản hồi lại* thay vì một sản phẩm hoàn chỉnh. Công cụ này được định vị là loại
bỏ trang giấy trắng, chứ không phải loại bỏ vai trò của kiến trúc sư.

#### Signal Scout — phát hiện sớm thay đổi chiến lược của doanh nghiệp

Đội này xây dựng một nền tảng phát hiện sớm các tín hiệu tái cấu trúc và thay
đổi chiến lược ở các công ty, hướng đến các đội chiến lược doanh nghiệp, quản
lý rủi ro doanh nghiệp (enterprise risk management), tình báo cạnh tranh
(competitive intelligence), và quản lý tài khoản B2B.

Hệ thống này thực sự là multi-agent. Một hàm Lambda đứng trước một AgentCore
runtime điều phối hai subagent: một **crawler subagent** thu thập bằng chứng
từ các nguồn bên ngoài, và một **analysis subagent** diễn giải chúng, có áp
dụng Bedrock Guardrails. Bộ nhớ ngắn hạn được lưu trong AgentCore Memory,
session trong S3, và kết quả trong DynamoDB. Phía người dùng chạy qua Route
53, Amplify, API Gateway, WAF, và Cognito, với CloudWatch và CloudTrail cho
observability và Secrets Manager cùng IAM cho credential và access.

Các tuyên bố giá trị (value propositions) của họ khá kỷ luật: phân tích minh
bạch và có thể kiểm chứng, mọi kết luận đều được bằng chứng hỗ trợ, và hỗ trợ
ra quyết định một cách rõ ràng là *do con người kiểm soát*. Hệ thống được thiết
kế để hỗ trợ thông tin cho một quyết định Maintain, Adapt, hoặc Accelerate,
chứ không phải để tự đưa ra quyết định đó.

Phần tôi đánh giá cao nhất là **slide chi phí** — một bảng phân tách chi tiết
từng dòng (line-item breakdown) trên ba mức sử dụng tối thiểu, trung bình, và
tối đa, bao quát mọi dịch vụ bao gồm cả các phụ thuộc ngoài AWS:

| | Min | Mid | Max |
|---|---|---|---|
| Tổng dịch vụ AWS | ~ $17 | ~ $35 | ~ $130 |
| Crawling bên thứ ba | ~$35 | ~$30 | ~$200 |
| Công cụ observability | $0–29 | $29 | $29 |
| **Tổng** | **~ $81** | **~ $94** | **~ $359** |

Sau đó họ trình bày một kiến trúc đã được sửa lại, hiệu quả chi phí hơn — cho
thấy phân tích chi phí thực sự đã phản hồi ngược lại vào thiết kế, chứ không
phải được tạo ra sau đó chỉ để đáp ứng yêu cầu của một slide.

#### One Team — KFC Bot Agent (đội vô địch hackathon)

Đội vô địch mở đầu bằng một thất bại thực tế trong ngành thay vì ý tưởng của
riêng họ: McDonald's đã kết thúc một thử nghiệm AI drive-thru sau khi thử
nghiệm đặt hàng tự động tại hơn một trăm địa điểm tại Mỹ. Cách họ đọc hiểu sự
việc này rất chính xác — bài học không phải là AI đặt hàng là một ý tưởng tồi,
mà là **việc đặt hàng là một bài toán hệ thống**. Một agent đặt hàng phải xử
lý món ăn, số lượng, biến thể (variant), quy tắc voucher, trạng thái giỏ hàng,
và lỗi, trong khi ngôn ngữ tự nhiên thì lộn xộn, quy tắc kinh doanh thì chặt
chẽ, đơn hàng phải được xác minh, và sai sót thì biến thành tiền bạc ngay lập
tức.

Vấn đề họ nhắm đến là khoảnh khắc một thương hiệu mất một đơn hàng: khách hàng
đang đói và ý định xuất hiện giữa cuộc trò chuyện, nhưng việc đặt hàng lại buộc
họ phải chuyển sang app khác, tạo tài khoản, và điều hướng qua một menu — và
động lực đó biến mất. Hỗ trợ chat chỉ bằng con người thì không thể mở rộng
được trên nhiều kênh, nhiều ca làm việc, và các đợt tăng traffic đột biến.

Sản phẩm của họ là một agent đặt hàng qua hội thoại đa kênh, chạy bên trong
Zalo và Messenger, không cần chuyển app, không cần tạo tài khoản mới, không
cần giải thích lặp lại.

Điểm về kiến trúc mà họ nêu ra là điều tôi nghĩ về nhiều nhất:

> **Một chatbot trả lời. Một agent hành động.**

Họ mô tả một vòng lặp năm bước — hiểu ý định đặt hàng, lên kế hoạch các bước
cần thiết, gọi tool để tra cứu dữ liệu kinh doanh đáng tin cậy, hành động bằng
cách cập nhật giỏ hàng và áp dụng khuyến mãi, sau đó xác minh dựa trên trạng
thái giỏ hàng thực tế. Tóm tắt của họ về điều này: *model hiểu, tool quyết
định điều gì là thật.* Language model không được tin tưởng để nắm giữ trạng
thái của đơn hàng; nó chỉ được tin tưởng để diễn giải yêu cầu.

#### 3KA — S.H.E.P.H.E.R.D và hành trình hackathon

Bài trình bày này được xây dựng như một câu chuyện thay vì một buổi demo sản
phẩm, gồm bốn giai đoạn: đăng ký và chọn track, xây dựng dưới áp lực, demo day
và chấm điểm, và những suy ngẫm cuối cùng.

Hệ thống, S.H.E.P.H.E.R.D — Smart Human-flow Evaluation, Prediction, Hazard
Detection, Response, and Dispatch — phân tích video camera trực tiếp tại các
địa điểm để phát hiện và theo dõi con người, đo mật độ đám đông, ước tính tình
trạng hàng đợi, nhận diện dấu hiệu sớm của tắc nghẽn, dự đoán tình trạng quá
tải, đưa ra cảnh báo chủ động, và đề xuất hành động cho nhân viên. Hệ thống
được xây dựng với YOLO và ByteTrack cho việc phát hiện và theo dõi, Amazon
SageMaker, Amazon Bedrock AgentCore với Strands Agent cho lớp agentic, và một
dashboard React.

Lớp agentic có hai vai trò riêng biệt: một **autonomous monitor** theo dõi các
chỉ số trực tiếp và đưa ra cảnh báo mà không cần được yêu cầu, và một
**operator copilot** cho phép nhân viên đặt câu hỏi bằng ngôn ngữ tự nhiên và
nhận câu trả lời được hỗ trợ bởi các chỉ số trực tiếp và các công cụ dự đoán.
Cách đặt vấn đề rất cụ thể — nhân viên tại địa điểm phải theo dõi lối vào,
hàng đợi, gian hàng, và chuyển động cùng lúc, và việc giám sát thủ công thì
chậm, bị động, khó mở rộng, và dễ bỏ sót sự cố.

Họ khá thẳng thắn về trải nghiệm của mình. Những nỗi sợ trước ngày đầu tiên
được liệt kê rõ ràng: không đủ kỹ năng, sợ thất bại, mù mờ không biết gì, quá
ít thời gian. Những thách thức lớn nhất của họ là không có nền tảng AI, lần
đầu làm việc với AWS, thời gian hạn hẹp, code không chạy, và thiếu ngủ. Diễn
biến cảm xúc họ mô tả đi từ choáng ngợp, qua việc tìm thấy trạng thái flow khi
ý tưởng khớp lại, đến niềm tự hào vì đã thực sự xây dựng được một thứ gì đó.

Lời khuyên của họ dành cho những người tham gia lần đầu:

- **Cứ đăng ký đi** — đừng đợi đến khi cảm thấy sẵn sàng
- **Tìm đội sớm** — các kỹ năng khác nhau tốt hơn là các kỹ năng giống nhau
- **Thu hẹp phạm vi thật nhỏ** — một tính năng, làm cho tốt
- **Nói chuyện với mọi người** — mentor và các đội khác chính là lý do bạn có
  mặt ở đó

---

### Những điều rút ra chính

**Agent được định nghĩa bởi tool của nó, không phải bởi model.** Mọi đội đều
vẽ ra cùng một ranh giới: language model diễn giải ý định, còn tool thực hiện
và xác minh hành động dựa trên trạng thái thực tế. Cách diễn đạt của One Team
— model hiểu, tool quyết định điều gì là thật — là phát biểu rõ ràng nhất về
điều này mà tôi từng nghe, và về bản chất đây là một luận điểm về tính đúng
đắn (correctness) hơn là một luận điểm về AI.

**Chi phí thuộc về thiết kế, không phải là thứ đến sau thiết kế.** Signal
Scout tạo ra một ước tính chi tiết từng dòng trên ba mức sử dụng *rồi sau đó
thiết kế lại* để tối ưu hiệu quả. Đó là một kỷ luật mà tôi từng nghĩ là mối
quan tâm về vận hành hơn là một đầu vào cho thiết kế.

**Một bản nháp có căn cứ tốt hơn một trang giấy trắng.** Cách Plan V định vị
công cụ của họ là tạo ra thứ gì đó để phản hồi lại thay vì thứ gì đó để chấp
nhận là một mô tả trung thực hơn về việc các hệ thống này thực sự tốt cho điều
gì, so với hầu hết các tuyên bố sản phẩm khác.

**Ràng buộc tạo ra phạm vi tốt hơn là tham vọng.** "Thu hẹp phạm vi thật nhỏ —
một tính năng, làm cho tốt" đến từ một đội chỉ có 24 giờ; nó cũng áp dụng tốt
không kém cho một dự án có bảy tuần.

---

### Áp dụng vào công việc

Ý tưởng dễ chuyển giao nhất là ranh giới xác minh bằng tool (tool-verification
boundary). Trong dự án của riêng tôi, điều tương đương là lớp application đề
xuất một booking, nhưng transaction của database mới quyết định nó có thật
hay không — các hàng ghế được khóa (locked) và kiểm tra lại trước khi bất cứ
điều gì được commit, và không có bất kỳ mức độ tự tin nào ở lớp application có
thể ghi đè lên trạng thái trong database. Việc nghe bốn đội cùng đi đến cùng
một nguyên tắc trong bốn lĩnh vực khác nhau khiến tôi tự tin hơn rằng việc đặt
sự đảm bảo ở lớp dữ liệu là lựa chọn đúng đắn, chứ không phải là một lựa chọn
gượng ép.

Bảng chi phí của Signal Scout đã thay đổi cách tôi tiếp cận phần chi phí trong
báo cáo của riêng mình. Thay vì khẳng định dự án nằm gọn trong Free Tier, tôi
đã cấu trúc lại nó thành các dòng chi tiết với các thành phần sẽ chiếm phần
lớn hóa đơn được xác định rõ ràng — đây cũng là điều khiến ước tính trở nên
hữu ích với bất kỳ ai đọc nó.

Region `ap-southeast-1` xuất hiện trong ước tính chi phí của Plan V là một chi
tiết nhỏ nhưng đáng yên tâm: cùng một lựa chọn region mà tôi đã đưa ra vì lý do
độ trễ, được một đội khác đưa ra một cách độc lập vì lý do tối ưu chi phí.

Cuối cùng, danh sách nỗi sợ của 3KA — không đủ kỹ năng, mù mờ không biết gì,
quá ít thời gian — gần như chính xác là những gì tôi cảm thấy vào lúc bắt đầu
chương trình. Việc thấy một đội nói ra điều đó trên sân khấu, rồi sau đó đã
xây dựng và trình diễn một hệ thống hoạt động được, có lẽ là điều hữu ích nhất
tôi rút ra được từ ngày hôm đó.

<!-- Thêm ảnh vào static/images/4-EventParticipated/4.2-Event2/ và tham chiếu chúng ở đây, ví dụ:

-->
#### Ảnh sự kiện
![Tôi tại Agentic AI Build Week Community Day](/images/4-EventParticipated/4.2-Event2/selfie.jpg)
