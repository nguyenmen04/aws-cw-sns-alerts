#!/bin/bash

# Script thực hiện Bài 1: CPU Alarm -> Email Alert via SNS
# Yêu cầu: Đã cài đặt và cấu hình AWS CLI, đã đăng nhập (aws configure)

echo "=== BƯỚC 1: TẠO SNS TOPIC & SUBSCRIPTION ==="
TOPIC_NAME="EC2-CPU-Alerts"
echo "Đang tạo SNS Topic với tên: $TOPIC_NAME..."
TOPIC_ARN=$(aws sns create-topic --name $TOPIC_NAME --output text --query 'TopicArn')
echo "✅ Đã tạo SNS Topic thành công. Topic ARN: $TOPIC_ARN"

echo ""
read -p "Nhập địa chỉ email của bạn để nhận cảnh báo (Email Subscription): " EMAIL
echo "Đang thêm Email Subscription..."
aws sns subscribe --topic-arn "$TOPIC_ARN" --protocol email --notification-endpoint "$EMAIL"
echo "✅ Đã gửi yêu cầu subscribe đến email: $EMAIL."
echo "⚠️ VUI LÒNG KIỂM TRA HỘP THƯ EMAIL (BAO GỒM CẢ THƯ MỤC SPAM) VÀ BẤM 'CONFIRM SUBSCRIPTION' ĐỂ XÁC NHẬN."

echo ""
echo "=== BƯỚC 2: TẠO CLOUDWATCH ALARM ==="
read -p "Nhập Instance ID của máy ảo EC2 cần giám sát (VD: i-0123456789abcdef0): " INSTANCE_ID

ALARM_NAME="CPU-Alarm-${INSTANCE_ID}"
echo "Đang tạo CloudWatch Alarm ($ALARM_NAME) giám sát CPU > 80% trong 5 phút..."

aws cloudwatch put-metric-alarm \
    --alarm-name "$ALARM_NAME" \
    --alarm-description "Cảnh báo khi CPU của máy ảo EC2 lớn hơn 80% trong 5 phút liên tục." \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
    --evaluation-periods 1 \
    --alarm-actions "$TOPIC_ARN" \
    --unit Percent

echo "✅ Đã tạo CloudWatch Alarm thành công!"
echo "Hoàn thành bài tập 1. Bạn có thể lên giao diện AWS Console để chụp ảnh làm minh chứng."
