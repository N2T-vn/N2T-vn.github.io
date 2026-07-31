---
title: "Sự kiện 1"
date: 2026-06-01
weight: 1
chapter: false
pre: " <b> 4.1. </b> "
---

# Báo cáo tóm tắt: Đêm thi đấu Cloud Architect

### Mục tiêu sự kiện

- Biến kiến thức kiểu chứng chỉ — Cloud Practitioner, Solutions Architect
  Associate, và Solutions Architect Professional — thành một hình thức thi
  đấu trực tiếp, thay vì chỉ làm đề thi thử một mình
- Kiểm tra cả bề rộng (công dụng của dịch vụ, kiến thức cơ bản về pricing) lẫn
  chiều sâu (các đánh đổi khi thiết kế kiến trúc multi-account) trong cùng một
  trận đấu
- Cho các bạn thực tập sinh ngoài nhóm của mình một lý do để lập đội và cùng
  nhau ôn tập dưới áp lực thời gian nhẹ nhàng
- Giữ không khí gần với một gameshow hơn là một bài kiểm tra viết, nhưng không
  hạ thấp yêu cầu về nội dung kiến thức bên dưới

### Thể lệ

- **Số đội:** 8 đội, mỗi đội đúng 5 thực tập sinh, được lập tự do giữa các
  nhóm — một đội không nhất thiết phải đến từ cùng một nhóm thực tập, và không
  ai được đăng ký ở hai đội trở lên. Các chuyên gia dày dặn kinh nghiệm bị loại
  khỏi diện tuyển thành viên, để giữ cuộc thi ở đúng đối tượng người học.
- **Cấu trúc:** hai đội đối đầu trong một trận, lần lượt trả lời các bộ câu
  hỏi tăng dần độ khó. Đội đạt điểm cao hơn sẽ tiến vào vòng sau; nếu hòa điểm
  đến cuối bộ đề, trận đấu sẽ được phân định bằng một câu hỏi sudden-death duy
  nhất — câu hỏi số 11 — trả lời dưới hình thức bấm chuông nghiêm ngặt, đội nào
  nhanh hơn sẽ thắng.
- **Nội dung câu hỏi:** tất cả câu hỏi được lấy cảm hứng từ cùng phạm vi kiến
  thức với các kỳ thi chứng chỉ AWS, sắp xếp gần đúng theo thứ tự Practitioner
  → Solutions Architect Associate → Solutions Architect Professional, để trận
  đấu khó dần lên theo thời gian thay vì giữ nguyên một mức độ.
- **Hai kỹ năng dùng một lần cho mỗi đội:**
  - **Rủi ro tối thiểu** — dùng cho câu hỏi đội không chắc chắn. Nếu trả lời
    sai sẽ không bị trừ điểm; nếu đúng thì chỉ được cộng một nửa số điểm của
    câu đó.
  - **Ngôi sao hi vọng** — dùng cho câu hỏi đội tự tin nhất. Nếu đúng sẽ được
    nhân đôi điểm, nếu sai sẽ bị trừ gấp đôi.
- **Cách chọn đội:** vì số lượng slot có hạn, các đội được duyệt bằng cách bốc
  thăm ngẫu nhiên từ danh sách đăng ký thay vì theo thứ tự đăng ký trước, với
  kết quả được công bố vào ngày 19/06/2026. Một khi đã được duyệt, đội phải cam
  kết tham gia đầy đủ — không được tham gia nửa chừng.

---

### Điểm nổi bật chính

#### Vòng 1 — Khởi động Practitioner

Bộ câu hỏi mở màn bám sát phạm vi Cloud Practitioner: một dịch vụ dùng để làm
gì, AWS tính phí cho nó như thế nào, và phần nào của shared responsibility
model thuộc về ai. Các câu hỏi tiêu biểu trong vòng này:

- *Dịch vụ AWS nào cho phép một tổ chức quản lý billing tập trung và áp dụng
  policy trên nhiều account cùng lúc mà vẫn không tước đi quyền tự chủ ở cấp
  account?*
- *Hình thức mua nào mang lại mức giảm giá lớn nhất cho compute capacity mà
  workload có thể chấp nhận bị thu hồi trong thời gian ngắn?*
- *Theo shared responsibility model, ai chịu trách nhiệm vá lỗi (patch) hệ
  điều hành khách trên một instance EC2?*

Vòng này diễn ra nhanh và chủ yếu kiểm tra khả năng ghi nhớ hơn là suy luận,
khoảng cách giữa các đội khá nhỏ — ai cũng rõ ràng đã ôn bài kỹ. Đội chúng tôi
mở màn thận trọng, dùng **Rủi ro tối thiểu** cho một câu hỏi về giới hạn free
tier chính xác của một dịch vụ mà không ai trong đội dùng hàng ngày, và hóa ra
đây là lựa chọn đúng đắn: câu trả lời sai, nhưng nhờ kỹ năng này chúng tôi
không bị mất điểm.

#### Vòng 2 — Solutions Architect Associate

Độ khó tăng lên từ "dịch vụ này dùng để làm gì" thành "tổ hợp dịch vụ nào thỏa
mãn ràng buộc này." Đây là lúc trận đấu thực sự bắt đầu phân hóa các đội:

- *Một workload phải tiếp tục phục vụ traffic ngay cả khi mất toàn bộ một
  Availability Zone, với công sức vận hành ít nhất có thể. Tổ hợp dịch vụ nào
  đáp ứng trực tiếp nhất yêu cầu này?*
- *Một ứng dụng đọc cùng vài bản ghi nhiều hơn hẳn số lần ghi, và độ trễ đọc
  đang là than phiền chính. Cache nên đặt ở đâu trong thiết kế này, và nó đưa
  vào failure mode nào?*
- *Một công ty cần object storage tự động chuyển dữ liệu ít được truy cập sang
  tier rẻ hơn mà không cần ai phải quyết định thời điểm chuyển.*

Đây là vòng cho thấy rõ mục đích thiết kế của thể lệ: nó thưởng cho việc hiểu
một đánh đổi (trade-off), chứ không phải học thuộc tên dịch vụ. Chúng tôi dùng
**Ngôi sao hi vọng** cho câu hỏi về Multi-AZ, tự tin vì nó gần như trùng khớp
với một quyết định tôi đã đưa ra và viết trong báo cáo của chính dự án mình —
và điều đó đã đem lại kết quả, nhân đôi điểm số cho câu đó.

#### Vòng 3 — Solutions Architect Professional, và câu hỏi phân định

Bộ câu hỏi cuối cùng bước vào phạm vi thực sự ở cấp độ chuyên nghiệp: quản trị
multi-account, thứ tự thực hiện migration, và kết nối hybrid, nơi hiếm khi có
một câu trả lời sạch sẽ duy nhất mà câu hỏi thực chất là tổ chức có thể chấp
nhận sống chung với đánh đổi nào.

- *Một tổ chức vận hành 20 account AWS dưới AWS Organizations và muốn áp đặt
  các guardrail tập trung, không thể thương lượng, trong khi vẫn để chủ account
  tự quản lý các tài nguyên không quan trọng của họ. Cơ chế nào phù hợp nhất?*
- *Một công ty đang migrate một database on-premises lớn lên AWS với cửa sổ
  cutover được tính bằng phút chứ không phải giờ. Pattern dịch vụ nào giúp
  giảm thiểu cửa sổ đó?*
- *Hai VPC ở hai account khác nhau cần kết nối riêng tư mà không để việc trùng
  dải CIDR trở thành ràng buộc dài hạn cho sự phát triển sau này.*

Không đội nào có lợi thế rõ ràng trước câu hỏi cuối của bộ đề, nghĩa là trận
đấu được quyết định ở câu hỏi số 11 — sudden-death, ai bấm chuông đúng trước sẽ
thắng. Câu hỏi liên quan đến Service Control Policies so với Identity and
Access Management policy, và đánh đổi giữa blast radius và sự linh hoạt.
Chúng tôi bấm chuông trước và trả lời đúng, qua đó định đoạt trận đấu; biên độ
thắng thua của cả đêm hôm đó rút cuộc chỉ tính bằng giây chứ không phải bằng
điểm số.

---

### Những điều rút ra chính

**Kiến thức chứng chỉ và khả năng phán đoán thiết kế không phải là cùng một kỹ
năng, và thể lệ cuộc thi đã cho thấy rõ điều đó.** Vòng 1 thưởng cho khả năng
ghi nhớ; vòng 3 thưởng cho việc cân nhắc đánh đổi khi không có lựa chọn hoàn
hảo. Những đội nhanh ở vòng 1 không đương nhiên là những đội dẫn đầu ở vòng 3.

**Một cơ chế đặt cược (wager) làm lộ ra điều một đội thực sự tin, chứ không
chỉ điều họ biết.** Việc quyết định khi nào dùng Rủi ro tối thiểu, khi nào
dùng Ngôi sao hi vọng buộc chúng tôi phải có một cuộc trò chuyện thành thật,
nói to và dưới áp lực đồng hồ, về việc câu trả lời nào là đoán mò và câu nào
chúng tôi sẵn sàng bảo vệ. Cuộc trò chuyện đó hữu ích hơn cả từng câu trả lời
riêng lẻ.

**Dưới áp lực thời gian, đội nào thống nhất được câu trả lời nhanh nhất sẽ
thắng, chứ không nhất thiết là đội đúng nhất khi xét riêng lẻ.** Vòng
sudden-death thưởng cho tốc độ đồng thuận cũng nhiều như thưởng cho kiến thức,
và đó là hai kỹ năng khác nhau.

---

### Áp dụng vào công việc

Câu hỏi về Multi-AZ ở vòng 2 ánh xạ trực tiếp lên một quyết định đã được đưa
ra cho Caerus: chấp nhận một instance EC2 duy nhất trong một Availability Zone
duy nhất như một đánh đổi đã được ghi nhận rõ ràng, thay vì giả vờ rằng high
availability nằm ngoài phạm vi. Việc nghe cùng câu hỏi thiết kế đó được hỏi
một cách khách quan, không gắn với bối cảnh dự án của riêng tôi, là một cách
kiểm chứng hữu ích rằng lập luận đằng sau quyết định đó vẫn đứng vững một cách
độc lập.

Câu hỏi về SCP so với IAM policy ở vòng sudden-death liên quan trực tiếp đến
cách Caerus tách quyền của ứng dụng booking khỏi bất cứ điều gì một operator
có thể chạm vào thủ công — một guardrail được áp đặt ở cấp account không nên
phụ thuộc vào việc ứng dụng hành xử đúng đắn, đúng nguyên tắc mà câu hỏi đó
đang kiểm tra.

Thói quen phát biểu mức độ tự tin trước khi trả lời — điều mà cơ chế Rủi ro
tối thiểu và Ngôi sao hi vọng buộc phải bộc lộ ra bên ngoài — là điều tôi giờ
áp dụng khi xem lại các quyết định kiến trúc của chính mình: nêu rõ hai hoặc
ba điểm tôi kém chắc chắn nhất, thay vì trình bày toàn bộ thiết kế với cùng
một mức độ tự tin.

<!-- Thêm ảnh vào static/images/4-EventParticipated/4.1-Event1/ và tham chiếu chúng ở đây, ví dụ:

-->
#### Ảnh sự kiện

![](/images/4-EventParticipated/event1.jpg)
