# EVIDENCE - AWS System Monitoring & Alerting Lab

File này dùng để lưu lại các minh chứng (hình ảnh, logs) trong quá trình thực hành các bài lab về giám sát và cảnh báo trên AWS.

## Phần 1: Cài đặt CloudWatch Agent trên EC2

### 1.1 IAM Role đã gán cho EC2
> *Yêu cầu: Chụp ảnh màn hình EC2 có gắn Role chứa `CloudWatchAgentServerPolicy`.*

![IAM Role Evidence]()

### 1.2 Trạng thái của CloudWatch Agent
> *Yêu cầu: Chụp ảnh màn hình Terminal/SSH hiển thị lệnh kiểm tra status của agent đang `running`.*

![Agent Status Evidence]()

---

## Phần 2: Cảnh báo CPU (CPU Alarm -> Email Alert via SNS)

### 2.1 SNS Topic và Email đã xác nhận (Confirmed)
> *Yêu cầu: Chụp ảnh màn hình giao diện SNS hiển thị Subscription trạng thái `Confirmed`.*

![SNS Confirmed Evidence]()

### 2.2 Đồ thị CloudWatch Alarm cấu hình CPU > 80%
> *Yêu cầu: Chụp ảnh màn hình cấu hình điều kiện của Alarm (Threshold = 80).*

![CPU Alarm Config Evidence]()

### 2.3 Email cảnh báo nhận được
> *Yêu cầu: Chụp ảnh hộp thư email của bạn nhận được tin nhắn cảnh báo (ALARM: "...") từ AWS.*

![Email Alert Evidence]()

---

## Phần 3: Cảnh báo Đăng nhập Root (Alert on AWS Root Account Login)

### 3.1 CloudTrail đẩy log lên CloudWatch
> *Yêu cầu: Chụp ảnh giao diện CloudTrail có cấu hình chuyển log về CloudWatch Logs.*

![CloudTrail Logs Evidence]()

### 3.2 Metric Filter cấu hình bắt sự kiện Root login
> *Yêu cầu: Chụp giao diện thiết lập Filter Pattern: `{ $.userIdentity.type = "Root" && $.eventType != "AwsServiceEvent" }`.*

![Metric Filter Evidence]()

### 3.3 CloudWatch Alarm kích hoạt khi có login
> *Yêu cầu: Chụp giao diện Alarm trạng thái `In alarm` khi cố tình đăng nhập bằng tài khoản root.*

![Root Login Alarm Evidence]()

---
*Lưu ý: Paste hình ảnh vào giữa các khoảng trống trên để hoàn thiện Evidence.*
