# Báo cáo Minh chứng Thực hành (Lab Evidence) - CloudWatch & SNS

Tài liệu này tổng hợp hình ảnh minh chứng kết quả cài đặt CloudWatch Agent trên máy ảo EC2 và thiết lập cảnh báo CPU Alarm gửi email thông qua Amazon SNS.

---

## 1. Cài đặt CloudWatch Agent trên EC2
Để thu thập các chỉ số chi tiết từ hệ điều hành của máy ảo EC2 (như bộ nhớ RAM, dung lượng đĩa cứng, CPU chi tiết), CloudWatch Agent đã được cài đặt và cấu hình thành công trên máy ảo.

### Thông tin máy ảo EC2 thực tế:
* **Tên Instance:** `men-monitored-instance`
* **Instance ID:** `i-0f415451e70d216c6`
* **Địa chỉ Public IP:** `13.215.224.242`
* **Địa chỉ Private IP:** `10.0.1.54`

### Kiểm tra trạng thái hoạt động của Agent:
Trạng thái hoạt động của CloudWatch Agent được kiểm tra bằng lệnh:
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

**Kết quả đầu ra:**
```json
{
  "status": "running",
  "starttime": "2026-06-12T10:03:50+00:00",
  "configstatus": "configured",
  "version": "1.300066.2"
}
```

### Hình ảnh minh chứng:
**Trạng thái CloudWatch Agent**

<img width="1215" height="618" alt="image" src="https://github.com/user-attachments/assets/a22f4751-2219-4f9c-8c1d-7f5791b51e8b" />


---

## 2. Cấu hình CPU Alarm gửi Email Alert qua SNS
Thiết lập cảnh báo CloudWatch Alarm giám sát chỉ số sử dụng CPU (`CPUUtilization`) của máy ảo EC2, tự động gửi thông báo qua email khi CPU vượt ngưỡng cấu hình thông qua Amazon SNS (Simple Notification Service) về hòm thư **`nguyenthimen190504@gmail.com`**.

### Chi tiết cấu hình Alarm thực tế:
* **Tên Alarm:** `ec2-i-0f415451e70d216c6-high-cpu-alarm`
* **Namespace:** `AWS/EC2`
* **Chỉ số giám sát (Metric name):** `CPUUtilization`
* **Instance ID:** `i-0f415451e70d216c6`
* **Ngưỡng cảnh báo (Threshold):** `CPUUtilization > 80` trong vòng 1 điểm dữ liệu liên tiếp 5 phút (for 1 datapoints within 5 minutes).
* **Hành động (Actions):** Đã kích hoạt (Actions enabled), liên kết với SNS Topic `arn:aws:sns:ap-southeast-1:945125812908:ec2-cpu-alerts-topic` để gửi email tới **`nguyenthimen190504@gmail.com`**.
* **Trạng thái hiện tại:** `Insufficient data` / `OK` (Đang thu thập dữ liệu ban đầu).
* **Alarm ARN:** `arn:aws:cloudwatch:ap-southeast-1:945125812908:alarm:ec2-i-0f415451e70d216c6-high-cpu-alarm`

### Hình ảnh minh chứng:
**Cấu hình CPU Alarm trên CloudWatch**

<img width="1550" height="694" alt="image" src="https://github.com/user-attachments/assets/234adec0-cdbd-44f3-b307-b9dbb3a84eed" />


---

## 3. Cấu hình Cảnh báo Đăng nhập Tài khoản Root (Root Account Login Alert)
Thiết lập cảnh báo tự động gửi email ngay lập tức khi có hoạt động đăng nhập bằng tài khoản AWS Root Account. Đây là một biện pháp bảo mật quan trọng (Security Best Practice) vì tài khoản Root có toàn quyền kiểm soát tài nguyên.

### Chi tiết cấu hình Alarm thực tế:
* **Tên Alarm:** `root-account-login-alarm`
* **Namespace:** `Security`
* **Chỉ số giám sát (Metric name):** `RootAccountLoginCount` (được lọc từ CloudTrail logs thông qua CloudWatch Logs Group `/aws/cloudtrail/root-login-trail`)
* **Filter Pattern:** `{ $.userIdentity.type = "Root" && $.eventType != "AwsServiceEvent" }`
* **Ngưỡng cảnh báo (Threshold):** `RootAccountLoginCount >= 1` trong vòng 1 điểm dữ liệu liên tiếp 5 phút.
* **Hành động (Actions):** Đã kích hoạt (Actions enabled), liên kết với SNS Topic `security-alerts-topic` để gửi email tới **`nguyenthimen190504@gmail.com`**.
* **Trạng thái hiện tại:** `OK` / `Insufficient data`.

### Hình ảnh minh chứng:
**Cấu hình Alert AWS Root Account Login trên CloudWatch**

<img width="821" height="689" alt="image" src="https://github.com/user-attachments/assets/070e83a3-bcc9-4ca6-af44-a0031b54b479" />
<img width="1249" height="673" alt="image" src="https://github.com/user-attachments/assets/0fdd6cb4-2ca0-4b1f-b4f8-935f80fdb4f4" />
<img width="1237" height="253" alt="image" src="https://github.com/user-attachments/assets/715ffd2c-0917-47cd-afd4-7e49b2535024" />





