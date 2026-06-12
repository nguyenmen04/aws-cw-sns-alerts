# Hướng dẫn Lab: AWS System Monitoring & Alerting

Dự án này kết hợp 3 bài thực hành về giám sát (Monitoring) và cảnh báo (Alerting) trên AWS, bao gồm việc cài đặt CloudWatch Agent, thiết lập cảnh báo tài nguyên (CPU) và cảnh báo bảo mật (Root login).

---

## Phần 1: Cài đặt CloudWatch Agent trên EC2 (Installing the CloudWatch Agent on EC2)

Mục tiêu: Đưa các metrics và log từ bên trong hệ điều hành EC2 lên CloudWatch.

### Điều kiện tiên quyết (Prerequisite)
EC2 Instance của bạn phải được gán một **IAM Role** có chứa policy `CloudWatchAgentServerPolicy`. Việc này cho phép agent trên EC2 có quyền gửi dữ liệu lên CloudWatch.

### Các bước thực hiện:

1. **Cài đặt gói Agent (Install the Agent Package)**
   Kết nối SSH (hoặc Session Manager) vào EC2 và chạy lệnh cài đặt:
   - Đối với Amazon Linux / RHEL:
     ```bash
     sudo yum install amazon-cloudwatch-agent -y
     ```
   - Đối với Ubuntu:
     ```bash
     sudo apt-get install amazon-cloudwatch-agent
     ```

2. **Chạy trình hướng dẫn cấu hình (Run Configuration Wizard)**
   Khởi chạy wizard để tạo file cấu hình cho agent:
   ```bash
   sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
   ```
   *(Trả lời các câu hỏi tùy thuộc vào nhu cầu lấy log/metric của bạn, có thể chọn mặc định).*

3. **Khởi động Agent (Start the Agent)**
   Kích hoạt agent tự bật khi khởi động lại máy và chạy agent:
   ```bash
   sudo systemctl enable amazon-cloudwatch-agent
   sudo systemctl start amazon-cloudwatch-agent
   ```

4. **Kiểm tra trạng thái (Verify & Check Status)**
   Đảm bảo agent đang chạy (running):
   ```bash
   sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
   ```

---

## Phần 2: Thực hành: Cảnh báo CPU -> Gửi Email qua SNS (Hands-On: CPU Alarm -> Email Alert via SNS)

Kịch bản (Scenario): Gửi một email cảnh báo khi CPU của EC2 vượt quá 80% trong 5 phút liên tục.

### Các bước thực hiện:

1. **Tạo SNS Topic & Đăng ký nhận thông báo (Create SNS Topic & Subscription)**
   - Truy cập: **SNS** -> **Create Topic** (Chọn loại **Standard**).
   - Đặt tên topic (VD: `EC2-CPU-Alerts`).
   - Thêm **Email Subscription**: Nhập địa chỉ email của bạn.
   - Kiểm tra hộp thư email và bấm vào link để **Confirm subscription** (Xác nhận đăng ký).

2. **Tạo CloudWatch Alarm (Create CloudWatch Alarm)**
   - Truy cập: **CloudWatch** -> **Alarms** -> **Create Alarm**.
   - Chọn Metric: **EC2** -> **Per-Instance Metrics** -> Chọn **CPUUtilization** của Instance bạn vừa tạo.

3. **Cấu hình điều kiện cảnh báo (Configure Alarm Conditions)**
   - **Condition (Điều kiện):** Greater than 80% (Lớn hơn 80%).
   - **Period (Chu kỳ):** 5 minutes.
   - **Evaluation (Đánh giá):** 1 out of 1 datapoints (1 trong 1 điểm dữ liệu).

4. **Thiết lập hành động gửi thông báo (Set SNS Notification Action)**
   - Mục **In Alarm state**: Chọn **Add notification**.
   - Chọn **SNS Topic** bạn đã tạo ở bước 1.
   - *(Tùy chọn)*: Có thể thêm thông báo cho trạng thái **OK state** (để báo hiệu CPU đã trở lại bình thường).

---

## Phần 3: Thực hành: Cảnh báo khi tài khoản Root của AWS đăng nhập (Hands-On: Alert on AWS Root Account Login)

Best Practice Bảo mật: Tài khoản Root gần như KHÔNG BAO GIỜ được sử dụng. Phải cảnh báo ngay lập tức nếu có người dùng nó!

### Các bước thực hiện:

1. **Bật CloudTrail & Gửi Log tới CloudWatch (Enable CloudTrail & Send Logs to CloudWatch)**
   - Truy cập: **CloudTrail** -> **Trails** -> **Create Trail**.
   - Bật tùy chọn: **Log file delivery to CloudWatch Logs group** (Gửi log sự kiện tới nhóm log của CloudWatch).

2. **Tạo Bộ lọc Metric trên CloudWatch (Create CloudWatch Metric Filter)**
   - Mở CloudWatch Logs Group vừa được tạo từ CloudTrail.
   - Tạo một **Metric Filter** với cấu hình sau:
     - **Filter Pattern:** `{ $.userIdentity.type = "Root" && $.eventType != "AwsServiceEvent" }`
     - **Metric Name:** `RootAccountLoginCount`
     - **Namespace:** `Security`
     - **Value:** `1`

3. **Tạo Cảnh báo CloudWatch (Create CloudWatch Alarm)**
   - Tạo Alarm dựa trên Metric vừa cấu hình ở trên.
   - Điều kiện: Cảnh báo nếu `RootAccountLoginCount >= 1` trong bất kỳ chu kỳ 5 phút nào (any 5-minute period).
   - Ý nghĩa: BẤT KỲ một lần đăng nhập bằng Root nào cũng sẽ ngay lập tức kích hoạt cảnh báo này.

4. **Nhận thông báo qua SNS (Notify via SNS)**
   - Thêm hành động SNS (Add SNS action).
   - Chọn topic thông báo ngay cho Đội Bảo mật (Security Team) qua **Email** (hoặc SMS).
   - *(Tùy chọn nâng cao)*: Có thể kích hoạt AWS Lambda để tự động vô hiệu hóa thông tin đăng nhập của root (auto-disable root credentials).
