# Báo cáo Minh chứng Thực hành - Bài 2: Cài đặt CloudWatch Agent trên EC2

Tài liệu này dùng để lưu lại hình ảnh minh chứng kết quả cài đặt và chạy CloudWatch Agent trên máy ảo EC2.

## Điều kiện tiên quyết (Prerequisite)
Đảm bảo máy ảo EC2 của bạn đã được gắn (attach) một **IAM Role** có chứa quyền `CloudWatchAgentServerPolicy`. (Nếu không có quyền này, Agent cài xong sẽ không gửi được dữ liệu lên AWS).

---

## 1. Cài đặt và Khởi động Agent
**Các bước đã thực hiện bên trong máy ảo EC2:**
- Cài đặt gói `amazon-cloudwatch-agent` (bằng lệnh `yum` hoặc `apt`).
- Chạy file `amazon-cloudwatch-agent-config-wizard` để thiết lập cấu hình.
- Bật dịch vụ bằng lệnh `systemctl enable` và `systemctl start`.

**Hình ảnh minh chứng (Chụp màn hình lúc bạn chạy các lệnh cài đặt trên Terminal):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="Agent Installation" /> -->

---

## 2. Kiểm tra trạng thái hoạt động (Verify Status)
**Lệnh đã kiểm tra:**
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

**Hình ảnh minh chứng (Chụp màn hình kết quả của lệnh trên, phải có chữ `"status": "running"` để chứng minh Agent đang hoạt động):**

> *(Hãy thay thế đoạn text này bằng hình ảnh chụp màn hình của bạn)*
<!-- Ví dụ: <img src="link_anh" alt="Agent Status Running" /> -->
