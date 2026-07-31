---
title : "CloudWatch và SNS"
date : 2026-06-01
weight : 8
chapter : false
pre : " <b> 5.8. </b> "
---

#### Tổng quan

Khả năng quan sát (observability) cho mọi dịch vụ trong kiến trúc cuối cùng -
EC2, RDS, và Application Load Balancer - được xây dựng hoàn toàn từ các
metric mặc định, miễn phí, cộng với các alarm đã được chứng minh là thực sự
gửi thông báo đến ai đó, chứ không chỉ nằm im ở trạng thái OK mà chưa từng
được kiểm chứng. Bản thân phần này không làm phát sinh thêm chi phí nào: EC2
Detailed Monitoring và CloudWatch Logs Insights vượt quá hạn mức miễn phí
hàng tháng đều được chủ động bỏ qua - chi phí thực sự của kiến trúc này đến
từ load balancer, các NAT gateway, và RDS Multi-AZ (xem [Quản lý chi phí và
tài nguyên](/5-Workshop/5.10-Cost/)), chứ không phải từ việc giám sát nó.
Việc ghi log ở tầng ứng dụng (đẩy log của chính `pm2` vào CloudWatch Logs)
nằm ngoài phạm vi của dự án này hoàn toàn, thay vì làm dở dang - dashboard và
alarm bên dưới chỉ được xây dựng từ các metric mà AWS đã thu thập sẵn miễn
phí trên mọi EC2 instance, RDS instance, và load balancer, không có gì ở
phía ứng dụng cần đẩy đi hay cấu hình thêm.

#### Nội dung

- [Xây dựng dashboard](5.8.1-dashboard/)
- [Cảnh báo và thông báo](5.8.2-alarms/)
