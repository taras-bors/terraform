resource "aws_lb" "web_app_lb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elastic_load_balancer_security_group]
  subnets            = var.public_subnet_id

  tags = {
    Name = "web_app-alb"
  }
}

resource "aws_lb_target_group" "web_app_tg" {
  name        = "web-app-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "web_app_target_group"
  }
}

resource "aws_lb_target_group_attachment" "web_app_tg_attachment" {
  target_group_arn = aws_lb_target_group.web_app_tg.arn
  target_id        = var.web_app_server_id
  port             = 8080
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.self_signed_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }
}

resource "aws_acm_certificate" "self_signed_cert" {
  private_key       = <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDW88+yCslZaInb
+Ec70X+Sg4Fc/AQqXxDHMV4wXDsQ0toZnskaE72Lky3QbYLV4WqloU3E92v2BGpk
qC8kXtSCPLqfcvFICEFG5YqViCgHOzXM5AUJLOAHVXsf97MwkJ/kZcNkvGFrnQhN
Kd2V4QEoHYWaHAeVniFWy/Jnf4NGe52kbhsX2Kz3bcmeCFfz26QPfP/x/Y2fvIWc
ebylDOvmLX85GySkiQb3M+jmQXPyUIvApWpZ59Jq1PEP8WN65XCMScUtF8Bo+4mz
mfYws5RoOQgrn2WaaZ4FS2cp8MPSfj5pLHacyPnZbSsSxkYBryE7bsH20jWU+N5z
Rju+kK8xAgMBAAECggEAA3DY98ZsSNYIoJ5wBgt3G9Fdy/hRoi4AZIosH7x7XLVd
ool/g1GQSmUJF6L1tERV+cSfdW2gNEqZ8j+KGjeViIx0vk/0NvHBK3XcL2ffVwSU
Q61LBMWnDUJuQA5AN46VrTbsqW2lr5M8Sm0QNTGhEwoZ8HZgi0ZdhK89gVTEIvor
D8YYgrK4GH9o40NSUaUEeQrIPl8DDOFjm3z6dexu2U/Ow19BjIQifnloL+HgqaUp
Qaf8JCAx2aGeDOMxs447tH9nYaACRpaOrB+lcPcQwWvEOuTZt1HuQS+uIZTZ1l7F
dCR4rALTgVpoiKD5k3XLSkHoIvjtz4alHRD3KxzBIQKBgQD8l7UU4k3EVEmwsy/h
HkxYklmByZIqlpetJCCr2mapv/crs/SOVkKrXEL3T7ANMokbPdjtzi88mGjVVPT0
xEHCqrHJwozVKc9NI8azEfYg6s+1ro48eVcCpoo59mzxWpEMkAHyW47+IAEgEY5D
ID5PoKe2gjsMCPrgFqSD5jX/+QKBgQDZ2h5qx8wUNm0omPEA7Qsk2TsX8Y5WJWVb
wDW6sShGXCfpFMowxu93A5mUAOmSF8sN3VxEUr8Oy+BcB6eqDiNuvoyqGK53XQT9
UKq891QMTitxP7W6mK3S23wgiQPrnmvRLtrM7SSOsDjygYoGBDqDrZ+/ZrwZEZbk
ys6qhtnm+QKBgQDaatycqGuSn0fxUaDPSwG9fR+EySZpSTry7tCJihtIIcS7t6p7
AkA4KVmGvROA9ff05HAWgjn6bdgI0KPYm3Q5vpxp2J8rHDIzhAInihqIsELX2Y8I
3+vLUPMp19qwgR33/PaR+XYWbNpMPqIDjXgUJtmfSdGBQKqe5zVvELwVEQKBgBDL
9X5sKzr/u0jfCe31WN+ddCXzdPMFbRw25K2hTSanolghRzmdjQcTGvtDWr7t4LUP
9TY7XwnIBGN0H6RH9MlsHbJbts/zNxhE6PUq6KsON+FCdUOO1BAm5hooFkpLa6q0
PyB/xErQIYPpIvg1yUEv2NpMFIKmTYkUbfzN6u0ZAoGBANwbLWqSc7uOGHzjMwnr
/A9Akf6Pdt3Y/Ln1GjNsqkrtkkNgzl2NfeeN9ArgBASdIFk4fGK/4JfAafFF0NUp
/GMsYpEQzszDefgXVJ2HuHg3gX6FjeRvLQBWVzksLoLYuz7b3BcbgV8nBmoeHmOY
NMe/qxl3+m3FT15erKea8QXj
-----END PRIVATE KEY-----
EOF

  certificate_body  = <<EOF
-----BEGIN CERTIFICATE-----
MIIDDTCCAfWgAwIBAgIUTyFGFldfFJqeDvuj/KINyC8nlkMwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAwwLZXhhbXBsZS5jb20wHhcNMjUwMzA2MTUzNDI2WhcNMjYw
MzA2MTUzNDI2WjAWMRQwEgYDVQQDDAtleGFtcGxlLmNvbTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBANbzz7IKyVloidv4RzvRf5KDgVz8BCpfEMcxXjBc
OxDS2hmeyRoTvYuTLdBtgtXhaqWhTcT3a/YEamSoLyRe1II8up9y8UgIQUblipWI
KAc7NczkBQks4AdVex/3szCQn+Rlw2S8YWudCE0p3ZXhASgdhZocB5WeIVbL8md/
g0Z7naRuGxfYrPdtyZ4IV/PbpA98//H9jZ+8hZx5vKUM6+YtfzkbJKSJBvcz6OZB
c/JQi8Clalnn0mrU8Q/xY3rlcIxJxS0XwGj7ibOZ9jCzlGg5CCufZZppngVLZynw
w9J+PmksdpzI+dltKxLGRgGvITtuwfbSNZT43nNGO76QrzECAwEAAaNTMFEwHQYD
VR0OBBYEFBZREwJA4S/U6kBnFLAyx0QaXV/aMB8GA1UdIwQYMBaAFBZREwJA4S/U
6kBnFLAyx0QaXV/aMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEB
AEhOBVcL+Zp42udShFy+drWp4Trgsv4x+rBz0xQZKi+vFyxaG2F08tABK0q0JKkE
X3+s+60yyoxy2DCEKQKjRAc/SIQLz542XgmiuOzH7gfSqwgNbZ96dw0fEu/xF8as
ofDIS0jyn+oETMECC2hmJAQfjxmekBgb63QWTBif2UScmuj7tpfrzoIBO4DuSRK0
UYUVjSM9fXyBgje4Ow8eBdUjoAIqB/Ay2fXuKhqedRTg32ccQ3XQPcON0kkroYhX
/PkTBXLT+WPlrwMruRNV8CkqNNHBpXdsCvyDlh+KWgkxolN6Txs14WPl5R0TPw6f
HQFZa7adANqk+bFHIPyfUYc=
-----END CERTIFICATE-----
EOF

  tags = {
    Name = "self-signed-cert"
  }
}


