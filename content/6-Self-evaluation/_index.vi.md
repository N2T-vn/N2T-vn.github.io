---
title: "Tự đánh giá"
date: 2026-06-01
weight: 6
chapter: false
pre: " <b> 6. </b> "
includeInReport: false
---

Trong thời gian thực tập tại **Amazon Web Services Viet Nam Company Limited**
từ **15/06/2026** đến **31/07/2026**, trong khuôn khổ chương trình Workforce
Bootcamp - First Cloud Journey, tôi đã có cơ hội chuyển từ việc học lý thuyết
về cloud computing sang thiết kế, xây dựng, và vận hành một hệ thống hoàn
chỉnh trên AWS.

Dự án - **Caerus**, một nền tảng đặt ghế xem phim được xây dựng bởi một đội
hai người - được lựa chọn ngay từ tuần đầu tiên, không để đến sau: đặc tả API
và schema cơ sở dữ liệu đã được thống nhất và đóng băng trước khi bất kỳ dịch
vụ AWS nào được tìm hiểu sâu. Hai tuần sau đó bao phủ các kiến thức nền tảng
cốt lõi của AWS cần thiết để xây dựng dự án; bốn tuần còn lại dùng để xây
dựng ứng dụng, triển khai nó, loại bỏ các điểm lỗi đơn (single points of
failure), và thiết lập hệ thống giám sát. Kiến trúc cuối cùng chạy trên
Amazon EC2 (hai instance, private subnet, phía sau một Application Load
Balancer và một NAT gateway), Amazon RDS for PostgreSQL (Multi-AZ, private
subnet), Amazon S3, Amazon CloudFront kèm AWS WAF, AWS Systems Manager, và
Amazon CloudWatch kèm SNS - sau khi đã thử nghiệm, rồi chủ động loại bỏ, AWS
Lambda và API Gateway cho việc sinh vé trong quá trình thực hiện, một khi
bằng chứng cho thấy một server thường trực phù hợp hơn.

Qua quá trình này, tôi đã cải thiện kỹ năng của mình về kiến trúc cloud và
lựa chọn dịch vụ, thiết kế cơ sở dữ liệu quan hệ, lập trình transaction và
kiểm soát concurrency, thiết kế API, triển khai và cấu hình bảo mật mạng,
observability, quản lý chi phí, và tài liệu kỹ thuật. Làm việc theo cặp cũng
dạy tôi giá trị của việc thống nhất một hợp đồng giao diện (interface
contract) trước khi viết code, đó chính là điều cho phép hai người xây dựng
đồng thời thay vì người này phải chờ người kia.

Về mặt đạo đức làm việc, tôi đã tuân thủ lịch trình đã thống nhất từ đầu dự
án, duy trì các thói quen hàng ngày mà cả đội đã cam kết - dừng các tài
nguyên thực hành ngay trong ngày và gắn tag chủ sở hữu cho mọi tài nguyên -
và chủ động nêu vấn đề với đồng đội sớm thay vì tự mình tìm cách né tránh.

Để nhìn lại một cách khách quan về giai đoạn thực tập, tôi tự đánh giá bản
thân theo các tiêu chí sau:

| STT | Tiêu chí | Mô tả | Tốt | Khá | Trung bình |
| --- | --- | --- | --- | --- | --- |
| 1 | **Kiến thức & kỹ năng chuyên môn** | Hiểu biết về lĩnh vực, áp dụng kiến thức vào thực tế, thành thạo công cụ, chất lượng công việc | ✅ | ☐ | ☐ |
| 2 | **Khả năng học hỏi** | Khả năng tiếp thu kiến thức mới và học hỏi nhanh | ✅ | ☐ | ☐ |
| 3 | **Tính chủ động** | Chủ động, tìm kiếm công việc mà không cần chờ chỉ dẫn | ☐ | ✅ | ☐ |
| 4 | **Tinh thần trách nhiệm** | Hoàn thành công việc đúng hạn và đảm bảo chất lượng | ✅ | ☐ | ☐ |
| 5 | **Tính kỷ luật** | Tuân thủ lịch trình, quy định, và quy trình làm việc | ✅ | ☐ | ☐ |
| 6 | **Tinh thần cầu tiến** | Sẵn sàng tiếp nhận phản hồi và tự hoàn thiện bản thân | ✅ | ☐ | ☐ |
| 7 | **Giao tiếp** | Trình bày ý tưởng và báo cáo công việc rõ ràng | ☐ | ✅ | ☐ |
| 8 | **Làm việc nhóm** | Làm việc hiệu quả với đồng nghiệp và tham gia vào tập thể | ✅ | ☐ | ☐ |
| 9 | **Tác phong chuyên nghiệp** | Tôn trọng đồng nghiệp, đối tác, và môi trường làm việc | ✅ | ☐ | ☐ |
| 10 | **Kỹ năng giải quyết vấn đề** | Nhận diện vấn đề, đề xuất giải pháp, và thể hiện sự sáng tạo | ✅ | ☐ | ☐ |
| 11 | **Đóng góp cho dự án/nhóm** | Hiệu quả công việc, ý tưởng sáng tạo, sự công nhận từ đội nhóm | ✅ | ☐ | ☐ |
| 12 | **Đánh giá tổng thể** | Đánh giá chung về toàn bộ giai đoạn thực tập | ✅ | ☐ | ☐ |

### Những điều làm tốt

* **Bề rộng kiến thức học được.** Tôi bắt đầu chương trình mà không có kinh
  nghiệm thực tế nào về AWS và kết thúc chương trình với khả năng thiết kế
  một kiến trúc đa dịch vụ và biện minh cho từng lựa chọn dịch vụ so với các
  phương án thay thế, thay vì chọn theo mặc định.

* **Làm việc dựa trên một hợp đồng (contract).** Việc thống nhất đặc tả API
  và schema cơ sở dữ liệu trước khi viết bất kỳ dòng code nào là quyết định
  duy nhất giữ cho dự án đúng tiến độ. Điều đó có nghĩa là frontend không bao
  giờ bị chặn chờ backend, và biến việc tích hợp thành việc sửa các điểm
  không khớp nhỏ thay vì phải dung hòa hai thiết kế không tương thích.

* **Giải quyết đúng vấn đề mà dự án thực sự hướng tới.** Đặt ghế dưới điều
  kiện concurrency không phải là vấn đề giao diện người dùng hay vấn đề hạ
  tầng; đó là vấn đề transaction. Tôi đã học cách khóa tường minh các dòng
  đang tranh chấp, sắp xếp thứ tự khóa nhất quán để tránh deadlock, và sau đó
  chứng minh đảm bảo đó bằng một cuộc đua (race) có chủ đích giữa hai client
  thay vì chỉ giả định rằng nó đúng.

* **Sửa đổi quyết định dựa trên bằng chứng.** Chúng tôi đã chuyển việc hủy
  đặt ghế sang một hàm Lambda, rồi chuyển nó về lại sau khi nhận ra việc hủy
  đặt chia sẻ logic transaction với việc đặt ghế và không thu được lợi ích gì
  khi tách riêng ra. Việc sinh vé còn đi xa hơn: chúng tôi đã xây dựng nó như
  một hàm Lambda, triển khai nó, xác nhận nó hoạt động đúng, rồi vẫn loại bỏ
  nó sau khi nhận ra khối lượng công việc quá nhỏ và không thường xuyên để
  biện minh cho một thành phần triển khai riêng với IAM role và bước deploy
  riêng của nó. Việc ghi lại lý do đó thay vì âm thầm hoàn tác mới là thói
  quen đáng giữ lại, chứ không phải bản thân việc đảo ngược quyết định.

* **Kỷ luật về chi phí.** Việc thiết lập một billing alarm trước khi cấp phát
  bất kỳ tài nguyên nào, gắn tag chủ sở hữu cho mọi tài nguyên, và sau đó
  nâng ngưỡng alarm để phù hợp với mức chi phí vận hành thực tế của kiến trúc
  một khi load balancer, NAT gateway, và cơ sở dữ liệu Multi-AZ khiến ước
  tính Free Tier ban đầu không còn chính xác, đã giúp chi phí luôn là một con
  số đã biết, được giám sát trong suốt quá trình thay vì một bất ngờ được
  dựng lại sau khi sự việc đã xảy ra.

### Những điều cần cải thiện

* **Tính chủ động vượt ra ngoài kế hoạch.** Tôi thực hiện lịch trình đã thống
  nhất một cách đáng tin cậy, nhưng tôi có xu hướng làm theo danh sách công
  việc thay vì nhìn xa hơn và đề xuất cải tiến trước khi chúng trở nên cần
  thiết. Một vài vấn đề chúng tôi gặp phải trong quá trình triển khai là có
  thể lường trước được, và lẽ ra tôi nên nêu ra chúng ngay từ giai đoạn thiết
  kế thay vì phát hiện ra chúng dưới áp lực thời gian.

* **Giao tiếp và trình bày.** Tôi cảm thấy thoải mái khi giải thích các quyết
  định kỹ thuật bằng văn bản, nhưng kém tự tin hơn khi trình bày chúng bằng
  lời trước một khán giả chưa đọc tài liệu. Đây là kỹ năng tôi muốn phát
  triển nhất tiếp theo.

* **Xác minh tầng edge cho mọi hình dạng request, không chỉ đường đi thuận
  lợi (happy path).** Khi CloudFront cùng WAF đi kèm được đặt phía trước API,
  việc kiểm thử bao phủ các lượt tải trang và các lời gọi JSON thông thường,
  nhưng không bao phủ một lượt tải lên file multipart lớn đi qua cùng đường
  đó. Việc tải poster lên đã âm thầm thất bại trong môi trường đã triển khai
  - bị chặn bởi một rule mặc định của WAF về kích thước body, sau đó bị ngụy
  trang thành một thành công giả bởi chính response lỗi SPA-fallback của
  distribution - và phải mất công debug thực sự sau đó mới tìm ra. Giờ đây
  tôi coi "tầng này hoạt động" có nghĩa là nó hoạt động cho mọi hình dạng
  request mà ứng dụng thực sự gửi đi, chứ không chỉ request đầu tiên mà tôi
  tình cờ thử.

* **Chiều sâu vượt ra ngoài đường đi hoạt động được.** Hệ thống hoạt động và
  đã được kiểm chứng theo đúng đảm bảo cốt lõi của nó, nhưng phần kỹ thuật
  xung quanh nó còn mỏng hơn tôi mong muốn: việc triển khai là thủ công thay
  vì tự động (không có pipeline CI/CD), và hạ tầng được tạo qua console thay
  vì được định nghĩa dưới dạng code, điều này khiến môi trường khó tái tạo
  chính xác hơn mức lẽ ra phải có.

* **Ước lượng thời gian.** Các ước tính ban đầu của tôi cho việc triển khai và
  cấu hình cross-origin là quá lạc quan. Các ngày đệm được đưa vào kế hoạch
  đã hấp thụ phần vượt tiến độ đó, nhưng bản thân các ước tính vẫn cần được
  cải thiện.
