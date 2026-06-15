# Báo cáo Minh chứng Thực hành - Bài 1: CPU Alarm -> Email Alert via SNS

Tài liệu này dùng để lưu lại các hình ảnh minh chứng cho việc thiết lập cảnh báo CloudWatch Alarm giám sát chỉ số sử dụng CPU của máy ảo EC2 và tự động gửi thông báo qua email thông qua Amazon SNS.

## Kịch bản (Scenario)
Gửi một email cảnh báo khi mức sử dụng CPU của máy ảo EC2 vượt quá 80% trong 5 phút liên tiếp (for 5 consecutive minutes).

---

## 1. Khởi tạo SNS Topic & Đăng ký Email (Subscription)
**Các bước đã thực hiện:**
- Tạo một SNS Topic chuẩn (Standard) để xử lý thông báo.
- Đăng ký một địa chỉ email vào Topic này để nhận thông báo.
- Xác nhận (Confirm) đăng ký qua đường link gửi tới email.

**Hình ảnh minh chứng (Chụp màn hình Subscription ở trạng thái Confirmed trên Console AWS SNS):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="SNS Subscription Confirmed" /> -->

---

## 2. Tạo CloudWatch Alarm
**Các bước đã thực hiện:**
- Điều hướng tới **CloudWatch** -> **Alarms** -> **Create Alarm**.
- Chọn Metric: `EC2` -> `Per-Instance Metrics` -> `CPUUtilization`.
- Cấu hình điều kiện Alarm:
  - **Condition (Điều kiện):** Greater than 80%
  - **Period (Chu kỳ):** 5 minutes
  - **Evaluation (Đánh giá):** 1 out of 1 datapoints (Trong chu kỳ 5 phút).
- Liên kết với hành động: Chọn SNS Topic đã tạo ở phần 1 để gửi thông báo khi Alarm ở trạng thái `In Alarm`.

**Hình ảnh minh chứng (Chụp màn hình chi tiết cấu hình Alarm đang theo dõi CPU máy ảo EC2):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="CloudWatch Alarm Config" /> -->

---

## 3. Kiểm thử gửi cảnh báo Email (Tùy chọn)
**Các bước thực hiện:**
- Kéo tải CPU của máy ảo EC2 lên trên 80% (có thể dùng tool `stress` trên Linux).
- Đợi khoảng 5 phút để CloudWatch ghi nhận dữ liệu và Alarm chuyển sang trạng thái `In alarm`.
- Kiểm tra hòm thư email để xem thông báo nhận được từ AWS SNS.

**Hình ảnh minh chứng (Chụp màn hình Alarm chuyển sang trạng thái "In alarm" HOẶC Email cảnh báo nhận được từ AWS SNS):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="Email Alert Received" /> -->
