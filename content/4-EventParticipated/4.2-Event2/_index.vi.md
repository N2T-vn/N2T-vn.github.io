---
title: "Sự kiện 2"
date: 2026-06-01
weight: 2
chapter: false
pre: " <b> 4.2. </b> "
---

# Báo cáo tóm tắt: FCAJ Agentic AI Build Week — Community Day

### Mục tiêu sự kiện

- Cho bốn đội hackathon một sân khấu để trình bày lại chính xác những gì họ đã
  thực sự làm ra trong Agentic AI Build Week, kèm cả sơ đồ kiến trúc
- Cho thấy, bằng chính slide thật thay vì một bản tóm tắt, một hệ thống
  agentic được lắp ráp từ các khối xây dựng AWS thông thường như thế nào
- Thẳng thắn về một chu kỳ xây dựng 24 giờ: cả những khoảnh khắc thiếu ngủ và
  lỡ tay push file bí mật lên GitHub, song song với bản demo chạy được
- Cho một người chưa từng tham gia hackathon nào một hình dung cụ thể về việc
  hình thức này thực sự đòi hỏi những gì

### Các đội trình bày

- **Plan V** — *Solution Architect Professional Native App*
  (Pham Tien Thuan Phat, Huynh Hoang Long, Le Minh Nghia, Tran Dai Vi, Nguyen An)
- **Signal Scout** — *Nền tảng phát hiện tín hiệu tái cấu trúc doanh nghiệp*
  (Le Tan Luc, Do Hoang Hieu, Trieu Quoc Hao, Nguyen Van Duy Khiem, Nguyen Cong Minh, Nguyen Tran Minh Quan)
- **One Team** — *KFC Bot Agent*, đội vô địch AABW Hackathon
  (Anh Duy, Tran Dong, Doan Trung, Minh Viet, Anshul Roy)
- **3KA** — *S.H.E.P.H.E.R.D* và hành trình hackathon
  (Huynh An Khuong, Nguyen Quoc Huy, Ngo Quang Khoi, Hoang Le Thanh Duc, Dang Nguyen Phuoc Loc, Dang Truong Hung)

---

### Điểm nổi bật chính

#### Plan V — Solution Architect Professional Native App

Đội mở đầu bằng một tình huống mà bất kỳ consultant nào cũng nhận ra ngay:
khách hàng yêu cầu thiết kế một hệ thống AI cho tài liệu SOP của họ, muốn có
vào thứ Năm, rồi lại muốn có *ngay lập tức*. Đằng sau câu nói ngắn gọn đó là
khối lượng công việc thực sự mà một solution architect phải gánh — rút yêu
cầu ra từ một cuộc trò chuyện, phác thảo kiến trúc đầu tiên, vẽ sơ đồ, và ước
tính chi phí cloud, tất cả trước khi yêu cầu vừa được đưa ra đã kịp "khô mực."

Ứng dụng của họ gánh cả bốn công việc đó thay cho con người. Nó đọc đầu vào
bằng ngôn ngữ tự nhiên lẫn tài liệu dự án có cấu trúc, phác thảo các phương án
kiến trúc nhận biết được hybrid-cloud và đã tuân theo chuẩn mực riêng của công
ty, rồi tạo ra một sơ đồ có thể chỉnh sửa trong Draw.io bằng đúng bộ icon
chính thức của AWS. Một ước tính chi phí mang tính định hướng cho region
`ap-southeast-1` được tạo ra song song với kiến trúc chứ không phải là việc
làm thêm sau cùng, và công cụ này thẳng thắn nêu rõ các giả định của chính nó
cũng như những chỗ yêu cầu vẫn còn thiếu. Đây không phải là kiểu sinh ra một
lần rồi thôi — một thanh chat bên cạnh (chat sidebar) với các chỉ dẫn tùy
chỉnh theo từng dự án cho phép kiến trúc sư tiếp tục điều chỉnh nó.

Bên dưới, một app server đứng giữa người dùng và bốn dịch vụ hậu thuẫn: một
knowledge base được xây từ các tài liệu nội bộ và tài liệu tham khảo kiến trúc
đã nạp vào, một model Amazon Bedrock cho phần suy luận, một server Draw.io MCP
để sinh sơ đồ, và một server AWS Pricing MCP cho các con số chi phí — mỗi thứ
đều được gọi như một tool riêng biệt thay vì bị gộp cứng vào một prompt duy
nhất.

Cách họ trình bày trước/sau là slide tôi ghi chú kỹ nhất:

| Trước | Sau |
|---|---|
| Đọc tài liệu BRD/PRD từng dòng, thủ công | Upload và chat tự nhiên — một catalogue yêu cầu trong vài phút |
| Bắt đầu từ trang giấy trắng mỗi lần | Một bản nháp đầu tiên có căn cứ để phản hồi lại, chứ không phải làm từ đầu |
| Viết infrastructure as code bằng tay | Infrastructure as code được sinh tự động |
| Ước tính chi phí bằng cách đoán mò dựa vào kinh nghiệm | Một ước tính mang tính định hướng được tạo ra song song với kiến trúc |

Cách chọn từ ở đây rất đáng chú ý: đầu ra là *một bản nháp để phản hồi lại*,
chứ không phải một sản phẩm hoàn chỉnh. Công cụ này được định vị là loại bỏ
trang giấy trắng, chứ không phải loại bỏ vai trò của kiến trúc sư — người vẫn
phải là người ký duyệt cuối cùng cho thiết kế.

#### Signal Scout — bắt được tín hiệu tái cấu trúc doanh nghiệp trước khi nó được công bố

Người dùng mục tiêu của Signal Scout không phải là developer, mà là một đội
chiến lược doanh nghiệp, quản lý rủi ro, tình báo cạnh tranh, hoặc quản lý tài
khoản B2B, những người cần được cảnh báo sớm về việc một đối tác đang tái cấu
trúc — trước khi điều đó trở thành một thông cáo báo chí.

Hệ thống này thực sự là một pipeline multi-agent, chứ không phải một model duy
nhất với một prompt lớn. Một **Crawler Subagent**, được xây trên AgentCore
Runtime với một Strands Agent, thu thập bằng chứng từ các nguồn bên ngoài
thông qua TinyFish và Apify. Kết quả của nó được chuyển qua một lệnh gọi
agent-to-agent (A2A) sang một **Analysis Subagent** — cùng mô hình AgentCore
Runtime và Strands Agent, nhưng có áp thêm Bedrock Guardrails ở trên — biến
bằng chứng thô thành các tín hiệu và kịch bản đã được chấm điểm. Bộ nhớ ngắn
hạn nằm trong AgentCore Memory, trạng thái session trong DynamoDB, và các
artefact bằng chứng trong S3. Phía tiếp xúc người dùng chạy qua Route 53,
Amplify, và API Gateway phía sau WAF và Cognito, với CloudWatch và CloudTrail
lo phần observability, còn Secrets Manager cùng IAM lo mọi thứ cần đến
credential.

Tuyên bố giá trị (value proposition) của họ được phát biểu với một sự kỷ luật
khác thường: phân tích minh bạch, có thể trích dẫn, mọi kết luận đều có bằng
chứng hỗ trợ, và — được nói rõ ràng, hai lần — **hỗ trợ ra quyết định do con
người kiểm soát**. Sản phẩm đưa ra một nhận định Maintain, Adapt, hay
Accelerate cho một tình huống; nó không tự đưa ra quyết định đó.

Slide tôi quay lại xem hai lần là bảng phân tích chi phí, vì nó không dừng lại
ở hóa đơn AWS:

| | Min | Mid | Max |
|---|---|---|---|
| Dịch vụ AWS (Bedrock, AgentCore, WAF, Amplify, CloudWatch, v.v.) | ≈ $17 | ≈ $35 | ≈ $130 |
| Apify / TinyFish (crawling bên ngoài) | ~$35 | ~$30 | ~$200 |
| Langfuse (observability) | $0–29 | $29 | $29 |
| **Tổng** | **≈ $81** | **≈ $94** | **≈ $359** |

Các nhà cung cấp crawling bên ngoài, chứ không phải AWS, mới là khoản mục lớn
nhất ở mọi mức sử dụng — và đây chính xác là điều đã thúc đẩy đội thiết kế một
kiến trúc thứ hai, gọn nhẹ hơn. Trong phiên bản sửa lại đó, TinyFish và Apify
được thay bằng một AgentCore Gateway gọi trực tiếp một WebSearch tool và một
Browser tool, còn CloudFront/DynamoDB/Route 53 vẫn giữ nguyên bên dưới. Slide
chi phí không chỉ báo cáo một con số — nó đã thay đổi cả kiến trúc ở slide kế
tiếp.

#### One Team — KFC Bot Agent (đội vô địch hackathon)

Đội vô địch không mở đầu bằng ý tưởng của chính họ — họ mở đầu bằng thất bại
của người khác. McDonald's đã dừng thử nghiệm AI drive-thru sau khi thử
nghiệm đặt hàng tự động tại hơn một trăm địa điểm tại Mỹ. Cách họ đọc hiểu lý
do rất sắc bén: bài học rút ra không phải là "AI đặt hàng không hoạt động,"
mà là **việc đặt hàng là một bài toán hệ thống** — một agent đặt hàng phải
theo dõi món ăn, số lượng, biến thể, quy tắc voucher, và trạng thái giỏ hàng,
trong khi ngôn ngữ tự nhiên vẫn lộn xộn, quy tắc kinh doanh vẫn chặt chẽ, đơn
hàng vẫn cần được xác minh, và một sai sót thì biến thành một khoản hoàn tiền
thật.

Khoảnh khắc họ chọn để tấn công cụ thể hơn nhiều so với "đặt hàng thì khó":
khách hàng đang giữa cuộc trò chuyện, cơn đói tạo ra ý định ngay lúc đó, nhưng
luồng đặt hàng hiện có lại buộc họ phải rời hẳn khỏi cuộc chat — chuyển sang
app khác, tạo tài khoản, điều hướng qua một menu — và đến lúc đó thì động lực
vốn đã khởi phát đơn hàng đã biến mất. Nhân viên con người một mình không thể
mở rộng đều trên nhiều kênh, nhiều ca làm việc, và các đợt tăng traffic đột
biến.

KFC Bot Agent giải quyết điều đó bằng cách ở lại ngay trong cuộc trò chuyện mà
khách hàng đã đang có, hiện tại trên Zalo với Messenger và các kênh tương lai
theo thiết kế: không cần chuyển app, không cần tài khoản mới, không cần giải
thích lại từ đầu, và giảm bớt tải cho nhân viên con người.

Tuyên bố trọng tâm của họ là điều tôi cứ quay lại nghĩ về:

> **Một chatbot trả lời. Một agent hành động.**

Họ chia vòng lặp thành năm bước — Goal (hiểu ý định đặt hàng), Plan (xác định
các bước cần thiết), Tools (tra cứu dữ liệu kinh doanh đáng tin cậy), Act (cập
nhật giỏ hàng, áp đúng khuyến mãi), Verify (kiểm tra kết quả so với trạng thái
giỏ hàng thực tế) — và tóm gọn lại là *model hiểu, tool quyết định điều gì là
thật*. Language model không bao giờ được tin tưởng để tự nắm giữ trạng thái
đơn hàng; chỉ có lớp tool mới được tin tưởng điều đó.

Kiến trúc đứng sau bản demo cho tin nhắn đi qua WAF, API Gateway, và một
Lambda webhook handler vào SQS, rồi vào AgentCore Runtime để xử lý vòng lặp
suy luận và sử dụng tool, với trạng thái session trong DynamoDB, một vector
store trong OpenSearch, và dữ liệu sản phẩm/đơn hàng được chia trên S3,
DynamoDB, ElastiCache, và storage mã hóa bằng KMS — với các hệ thống thanh
toán, loyalty, giao hàng, và SMS/email nằm phía sau như các tích hợp bên
ngoài.

Bốn con số từ slide kết của họ đáng để ghi nhớ:

| Chỉ số | Giá trị |
|---|---|
| Chi phí mỗi đơn hàng | $0.006 (500 đơn/ngày) |
| Chi phí hạ tầng mỗi tháng | $88 — Bedrock chiếm ~75% trong đó |
| Độ trễ đầu-cuối | 3–5 giây, từ lúc gửi tin nhắn đến lúc nhận phản hồi |
| Giảm code hạ tầng | −60%, nhờ để AgentCore đảm nhiệm lớp hạ tầng |

#### 3KA — S.H.E.P.H.E.R.D và hành trình hackathon

Trong khi ba đội còn lại trình bày một sản phẩm, 3KA trình bày một trải
nghiệm, được cấu trúc quanh bốn giai đoạn thẳng thắn: đăng ký và chọn track,
xây dựng dưới áp lực, demo day và chấm điểm, và những điều họ muốn nói với
chính mình của quá khứ.

Bản thân hệ thống, S.H.E.P.H.E.R.D — *Smart Human-flow Evaluation, Prediction,
Hazard Detection, Response, and Dispatch* — ban đầu được lên kế hoạch làm dự
án Capstone; họ chọn làm prototype nó trong tuần build 24 giờ này thay vào đó,
cụ thể là để kiểm chứng ý tưởng với thứ gì đó gần với thực tế hơn trước khi
dồn toàn bộ Capstone vào nó. Hệ thống theo dõi video camera trực tiếp để phát
hiện và theo dõi con người, đo mật độ đám đông, đọc tình trạng hàng đợi, bắt
được dấu hiệu sớm của tắc nghẽn, dự báo tình trạng quá tải, và đưa cho operator
một cảnh báo chủ động kèm hành động đề xuất, được xây trên YOLO và ByteTrack
để phát hiện, một endpoint Amazon SageMaker để inference, Amazon Bedrock
AgentCore với một Strands Agent cho lớp suy luận, và một dashboard React cho
những người theo dõi nó.

Hai vai trò agent chia nhau công việc: một **Autonomous Monitor** theo dõi các
chỉ số liên tục và đưa ra cảnh báo mà không cần yêu cầu, và một **Operator
Copilot** cho phép nhân viên đặt một câu hỏi bằng ngôn ngữ thường và nhận câu
trả lời dựa trên các chỉ số trực tiếp cùng công cụ dự đoán, thay vì một câu
trả lời dựng sẵn.

Điều khiến bài trình bày này nổi bật là việc họ đánh bóng rất ít cho những
phần khó khăn. Nỗi sợ của họ trước khi bắt đầu, được đọc thẳng ra, chính xác
là những nỗi sợ mà ai cũng sẽ nhận ra: không đủ kỹ năng, quá ít thời gian, sợ
thất bại, mù mờ không biết bắt đầu từ đâu. Trở ngại lớn nhất thực tế của họ
đến cuối cùng: không có nền tảng AI khi bắt đầu, lần đầu tiếp xúc với AWS,
trần 24 giờ khắc nghiệt, code nhất định không chạy, và mức độ thiếu ngủ trở
thành trò đùa xuyên suốt của cả đội. Diễn biến cảm xúc trong ngày hôm đó, theo
lời chính họ, đi theo trình tự Doubt → Flow → Pride — choáng ngợp, rồi ý tưởng
khớp lại đúng chỗ, rồi bất ngờ vì đã thực sự xây được thứ đó.

Lời khuyên của họ dành cho người lần đầu tham gia, rút gọn còn bốn dòng:

- **Cứ đăng ký đi** — đừng đợi đến khi cảm thấy sẵn sàng
- **Tìm đội sớm** — các kỹ năng khác nhau tốt hơn các kỹ năng giống nhau
- **Thu hẹp phạm vi thật nhỏ** — một tính năng làm cho tốt còn hơn năm tính
  năng làm dở
- **Nói chuyện với mọi người** — mentor và các đội khác là một nửa lý do để
  có mặt ở đó

---

### Những điều rút ra chính

**Một agent được định nghĩa bởi những gì tool của nó được phép chạm vào, chứ
không phải bởi model nào đứng sau nó.** Cả bốn đội đều đi đến cùng một ranh
giới từ những hướng khác nhau: model diễn giải, tool hành động và xác minh.
Cách diễn đạt của One Team — *model hiểu, tool quyết định điều gì là thật* —
là phát biểu rõ ràng nhất về điều này, và về bản chất đó là một luận điểm về
tính đúng đắn được khoác lên vỏ bọc của một luận điểm về AI.

**Ước tính chi phí là một đầu vào cho thiết kế, không phải một bản báo cáo
viết sau đó.** Signal Scout không chỉ tính chi phí cho kiến trúc của họ — con
số đó đã khiến họ quay lại thiết kế lại, thay thế phần phụ thuộc đắt nhất
ngay trước khi hackathon kết thúc.

**Một bản nháp mà bạn có thể phản biện lại luôn tốt hơn một trang giấy trắng.**
Toàn bộ phần trình bày của Plan V đứng trên sự phân biệt đó, và đó là một mô
tả trung thực hơn về công dụng thực sự của các công cụ này, so với hầu hết các
lời quảng cáo sản phẩm khác.

**Ràng buộc chặt tạo ra quyết định phạm vi tốt hơn tham vọng mở.** "Một tính
năng, làm cho tốt" là câu nói của 3KA từ một lần xây dựng 24 giờ, nhưng nó vẫn
đúng y hệt ở tuần thứ ba của một dự án bảy tuần.

---

### Áp dụng vào công việc

Ý tưởng chuyển giao trực tiếp nhất là ranh giới xác minh bằng tool. Trong
Caerus, sự phân chia tương đương là lớp application *đề xuất* một booking,
nhưng transaction của database — khóa hàng, kiểm tra lại tình trạng còn chỗ,
rồi mới commit — mới quyết định liệu nó có thực sự xảy ra hay không. Không có
mức độ tự tin nào trong code application có thể ghi đè lên điều mà transaction
đã xác nhận. Việc chứng kiến bốn đội không liên quan đến nhau cùng đi đến cùng
một sự tách biệt đó một cách độc lập khiến lựa chọn này bớt giống một điều
riêng biệt của thiết kế của tôi, mà giống một pattern đáng tin cậy hơn.

Bảng chi phí của Signal Scout đã thay đổi cách tôi viết phần chi phí trong báo
cáo của chính mình. Thay vì một khẳng định duy nhất rằng dự án nằm gọn trong
Free Tier, tôi đã chia nó thành các dòng chi tiết và nêu rõ thành phần nào
thực sự sẽ làm hóa đơn tăng lên nếu lượng dùng tăng — đây cũng chính là điều
khiến một ước tính trở nên hữu ích cho bất kỳ ai đọc nó sau này, thay vì nghe
yên tâm trên bề mặt nhưng vô dụng trong thực tế.

Việc thấy `ap-southeast-1` xuất hiện trong ước tính chi phí của Plan V là một
xác nhận nhỏ nhưng đáng yên tâm một cách kỳ lạ: cùng một region tôi chọn vì lý
do độ trễ lại xuất hiện độc lập ở một đội đang tối ưu vì lý do chi phí, vì
những lý do hoàn toàn riêng của họ.

Và danh sách nỗi sợ của 3KA — không đủ kỹ năng, mù mờ không biết gì, quá ít
thời gian — gần giống với những gì tôi cảm thấy vào lúc bắt đầu kỳ thực tập
này, đến mức việc nghe một đội nói ra điều đó trên sân khấu, sau khi đã xây
được thứ gì đó thực sự chạy được, có lẽ là điều hữu ích nhất tôi rút ra được
từ cả ngày hôm đó.

<!-- Thêm ảnh vào static/images/4-EventParticipated/4.2-Event2/ và tham chiếu chúng ở đây, ví dụ:

-->
#### Ảnh sự kiện
![](/images/4-EventParticipated/event2.jpg)
