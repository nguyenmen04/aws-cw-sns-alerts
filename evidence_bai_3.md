# Báo cáo Minh chứng Thực hành - Bài 3: Cảnh báo Đăng nhập Tài khoản Root

Tài liệu này dùng để lưu lại các hình ảnh minh chứng cho việc thiết lập cảnh báo tự động gửi email khi có người đăng nhập bằng tài khoản AWS Root (Best Practice bảo mật).

---

## 1. Bật CloudTrail & Gửi Log tới CloudWatch
**Các bước đã thực hiện:**
- Truy cập vào **CloudTrail** -> **Trails** -> **Create trail**.
- Bật tùy chọn **CloudWatch Logs** (Log file delivery to CloudWatch Logs group).
- Đặt tên cho Log group (ví dụ: `CloudTrail/DefaultLogGroup`).

**Hình ảnh minh chứng (Chụp màn hình chi tiết của Trail vừa tạo, hiển thị phần CloudWatch Logs đã được Enable):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="CloudTrail Config" /> -->

---

## 2. Tạo Bộ lọc Metric (Metric Filter) trên CloudWatch
**Các bước đã thực hiện:**
- Truy cập vào **CloudWatch** -> **Log groups**, chọn Log group vừa tạo ở trên.
- Chọn tab **Metric filters** -> **Create metric filter**.
- **Filter Pattern:** `{ $.userIdentity.type = "Root" && $.eventType != "AwsServiceEvent" }`
- **Metric Name:** `RootAccountLoginCount`
- **Metric Namespace:** `Security`
- **Metric Value:** `1`

**Hình ảnh minh chứng (Chụp màn hình Metric Filter đã được tạo thành công):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="Metric Filter Config" /> -->

---

## 3. Tạo CloudWatch Alarm & Nhận thông báo SNS
**Các bước đã thực hiện:**
- Chọn Metric Filter vừa tạo, bấm **Create alarm**.
- **Điều kiện (Condition):** Greater/Equal (Lớn hơn hoặc bằng) `1`.
- **Chu kỳ (Period):** 5 minutes.
- **Hành động (Action):** Chọn một SNS Topic (ví dụ `Security-Alerts`) để nhận email cảnh báo.

**Hình ảnh minh chứng (Chụp màn hình tổng quan cấu hình Alarm vừa tạo - trạng thái có thể là OK hoặc Insufficient data):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="Root Login Alarm" /> -->
