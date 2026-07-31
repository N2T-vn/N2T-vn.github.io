---
title: "Các blog đã đăng"
date: 2026-06-01
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

Trong quá trình thực tập, tôi đã viết và đăng ba bài blog lên cộng đồng
[AWS Study Group](https://www.facebook.com/groups/awsstudygroupfcj). Cả ba bài
đều được viết bằng tiếng Việt cho cộng đồng đó; phần tóm tắt bên dưới được viết
bằng tiếng Việt.

Hai trong số các bài viết xuất phát từ những vấn đề tôi gặp phải trực tiếp
trong quá trình học: mất dấu những gì mình đã provision, và lo lắng về chi phí
trên một tài khoản cá nhân. Bài thứ ba là bản tóm tắt một case study trên AWS
Architecture Blog, giúp trả lời một câu hỏi tôi đang gặp phải khi thiết kế API
của riêng mình.

### [Blog 1 - AWS Budgets và Cost Anomaly Detection](3.1-Blog1/)

Hai công cụ quản lý chi phí trả lời hai câu hỏi khác nhau. AWS Budgets cảnh báo
khi mức chi tiêu vượt qua ngưỡng bạn tự định nghĩa, bao gồm cả cảnh báo dựa trên
dự báo (forecast-based alert) được kích hoạt trước khi bạn thực sự vượt ngưỡng.
Cost Anomaly Detection học mô hình chi tiêu bình thường của một tài khoản và
gắn cờ những sai lệch so với mô hình đó mà không cần thiết lập bất kỳ ngưỡng
nào. Bài viết trình bày các khái niệm, các bước thực hiện trên console cho cả
hai công cụ, mức giá hiện tại (việc giám sát và cảnh báo là miễn phí; chỉ có
Budget Actions và báo cáo theo lịch là tính phí), và những giới hạn thực tế:
cả hai công cụ đều không hoạt động theo thời gian thực (real-time), và anomaly
detection cần khoảng mười ngày lịch sử dữ liệu cho mỗi dịch vụ trước khi nó
hoạt động hiệu quả.

### [Blog 2 - SeatGeek kiểm soát Authorization và Rate Limiting cho một SaaS đa tenant như thế nào](3.2-Blog2/)

Bản tóm tắt một case study trên AWS Architecture Blog về vấn đề "noisy
neighbour" (hàng xóm ồn ào): ngăn một tenant chiếm dụng năng lực dùng chung
(shared capacity) gây thiệt hại cho các tenant khác. SeatGeek đã đưa việc
authorization ra khỏi từng service riêng lẻ và tập trung vào một Lambda
authorizer duy nhất tại API Gateway, ánh xạ các tenant tới API key thông qua
DynamoDB, và sử dụng các usage plan phân cấp (tiered usage plans) để áp đặt
giới hạn request theo từng tenant. Bài viết theo dõi một request từ đầu đến
cuối và làm nổi bật cơ chế caching nhiều tầng (multi-level caching) giúp thiết
kế này vừa nhanh vừa tiết kiệm chi phí.

### [Blog 3 - AWS Config và Conformance Packs](3.3-Blog3/)

Một cái nhìn về cách tìm hiểu xem thực sự bạn đã cấu hình những gì. AWS Config
ghi lại trạng thái cấu hình của mọi resource và đánh giá chúng dựa trên các
rule; một conformance pack triển khai cả một tập hợp các rule đó như một đơn
vị duy nhất. Bài viết trình bày các khái niệm cốt lõi, các mẫu template có sẵn
(sample templates), sáu bước triển khai, và hai lưu ý đáng đọc trước khi bật
tính năng này: việc đánh giá rule không nằm trong free tier, và một điểm số
tuân thủ (compliance score) cao chỉ có nghĩa là các rule trong pack đó đã vượt
qua, chứ không có nghĩa là môi trường đã an toàn.
