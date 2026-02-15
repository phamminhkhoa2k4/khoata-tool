# 🚀 Ag-Khoata (Anti-Gravity Quota Monitor Tool)

**Ag-Khoata** là một công cụ dòng lệnh (CLI) mạnh mẽ giúp bạn theo dõi dung lượng sử dụng (quota) của các mô hình AI trong **Anti-Gravity (Google Cloud Code)** như Claude 3.5 Sonnet, Gemini Pro, và nhiều mô hình khác theo thời gian thực.

![Quota Screenshot](./image.png)

## ✨ Tính năng nổi bật

- **📊 Theo dõi Quota Real-time**: Xem phần trăm sử dụng và thời gian reset của từng model.
- **🔐 Bảo mật cao**: Sử dụng OAuth2 với PKCE, token được mã hóa và tự động làm mới (auto-refresh).
- **👥 Hỗ trợ đa tài khoản**: Đăng nhập và quản lý nhiều tài khoản Google cùng lúc.
- **⚡ Kiểm tra hàng loạt**: Xem quota của tất cả tài khoản chỉ với một lệnh (`--all`).
- **🎨 Giao diện đẹp mắt**: Hiển thị dạng bảng (Table) với màu sắc trực quan trên Terminal.
- **🛠️ Tùy biến**: Hỗ trợ xuất ra JSON để tích hợp với các tool khác.

## 🛠️ Yêu cầu hệ thống

- **Hệ điều hành**: Windows, macOS, hoặc Linux.
- **Go**: Phiên bản 1.20 trở lên (nếu tự build từ source).

## 📥 Cài đặt

### 🚀 Cài đặt nhanh (Khuyên dùng)

**Linux / macOS (Curl / Wget)**
```bash
curl -sL https://raw.githubusercontent.com/phamminhkhoa2k4/khoata-tool/master/scripts/install.sh | bash
# Hoặc dùng wget
wget -qO- https://raw.githubusercontent.com/phamminhkhoa2k4/khoata-tool/master/scripts/install.sh | bash

# Sau khi cài, bạn có thể gõ 'khoata' hoặc 'ag-khoata' ở bất cứ đâu.
```

### 📦 NPM (Node.js) (Khuyên dùng nếu đã có Node)
```bash
npm install -g ag-khoata
```

**Windows (Powershell)**
```powershell
iwr -useb https://raw.githubusercontent.com/phamminhkhoa2k4/khoata-tool/master/scripts/install.ps1 | iex

# Sau khi cài, bạn có thể gõ 'khoata' hoặc 'ag-khoata' ở bất cứ đâu.
```

### 🍺 Homebrew (macOS / Linux)
*(Yêu cầu bạn tự host tap hoặc PR vào homebrew-core)*
```bash
brew tap phamminhkhoa2k4/tap
brew install ag-khoata
```

### 🍫 Chocolatey (Windows)
*(Yêu cầu bạn publish gói lên chocolatey.org)*
```powershell
choco install ag-khoata
```

### 📦 Build từ source

1. **Clone repository:**
   ```bash
   git clone https://github.com/phamminhkhoa2k4/khoata-tool.git
   cd khoata-tool
   ```

2. **Cài đặt dependencies:**
   ```bash
   go mod download
   ```

3. **Cấu hình môi trường (Tùy chọn):**
   Nếu bạn có Client ID riêng, hãy tạo file `.env`:
   ```bash
   cp .env.example .env
   # Chỉnh sửa .env và điền OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET
   ```

4. **Build ứng dụng:**
   
   **Cách A: Build thường (Cần file .env)**
   ```bash
   go build -o ag-khoata.exe ./cmd/ag-khoata
   # Yêu cầu phải có file .env chứa OAUTH_CLIENT_ID và OAUTH_CLIENT_SECRET
   ```

   **Cách B: Build an toàn (Secure Build - Không cần .env)**
   Phương pháp này "tiêm" secret trực tiếp vào file .exe, giúp người dùng cuối không cần cấu hình gì thêm.

   *Sử dụng Makefile (Powershell/Linux):*
   ```bash
   # Thiết lập biến môi trường
   $env:OAUTH_CLIENT_ID="your_client_id"
   $env:OAUTH_CLIENT_SECRET="your_client_secret"
   
   # Chạy make build
   make build
   ```

   *Hoặc chạy lệnh thủ công:*
   ```bash
   go build -ldflags "-X 'github.com/phamminhkhoa2k4/khoata-tool/internal/auth.embeddedClientID=YOUR_ID' -X 'github.com/phamminhkhoa2k4/khoata-tool/internal/auth.embeddedClientSecret=YOUR_SECRET'" -o ag-khoata.exe ./cmd/ag-khoata
   ```

   **Cách C: Build Release đa nền tảng (Cross-compile)**
   Để tạo file chạy cho Windows, Linux, và macOS cùng lúc:

   ```bash
   # Yêu cầu cài đặt Make
   make release
   ```
   Kết quả sẽ nằm trong thư mục `release/`:
   - `ag-khoata-windows-amd64.exe`
   - `ag-khoata-linux-amd64`
   - `ag-khoata-darwin-amd64` (Intel Mac)
   - `ag-khoata-darwin-arm64` (Apple Silicon)

   **Cách D: Tự động Build trên GitHub (GitHub Actions)**
   
   Dự án đã tích hợp sẵn workflow để tự động build khi bạn tạo Release mới trên GitHub.
   
   1. Vào Settings của Repository trên GitHub -> **Secrets and variables** -> **Actions**.
   2. Tạo 2 Secret mới:
      - `OAUTH_CLIENT_ID`: Giá trị Client ID của bạn.
      - `OAUTH_CLIENT_SECRET`: Giá trị Client Secret của bạn.
   3. Tạo một **Release** mới (vào mục Releases -> Draft a new release).
   4. GitHub Actions sẽ tự động chạy, build file và đính kèm vào Release đó.

## 📖 Hướng dẫn sử dụng

### 1. Đăng nhập (Login)
Lệnh này sẽ mở trình duyệt để bạn đăng nhập tài khoản Google.
```bash
.\ag-khoata.exe login
# Hoặc nếu đã cài qua script:
khoata login
```

### 2. Xem Quota (Quota Check)
Xem dung lượng của tài khoản mặc định hiện tại:
```bash
.\ag-khoata.exe quota
```

Xem dung lượng của **tất cả** tài khoản đã lưu:
```bash
.\ag-khoata.exe quota --all
```

Xuất kết quả ra định dạng JSON:
```bash
.\ag-khoata.exe quota --json
```

### 3. Quản lý tài khoản (Account Management)

**Liệt kê các tài khoản đã lưu:**
```bash
.\ag-khoata.exe accounts list
```

**Chuyển đổi tài khoản mặc định:**
```bash
.\ag-khoata.exe accounts switch user@example.com
```

**Xóa một tài khoản:**
```bash
.\ag-khoata.exe accounts remove user@example.com
```

### 4. Kiểm tra trạng thái
```bash
.\ag-khoata.exe status
```

### 5. Trợ giúp
```bash
.\ag-khoata.exe --help
```

## ❓ Troubleshooting

### Lỗi "Access blocked" khi Login trên Windows?
Tool đã được fix lỗi này bằng cách xử lý URL đặc biệt cho Windows `cmd`. Nếu vẫn gặp lỗi, hãy thử copy link URL hiển thị trong terminal và dán thủ công vào trình duyệt.

### Lỗi 403 "Permission Denied" với tài khoản tổ chức/trường học?
Một số tài khoản Edu/Enterprise bị admin chặn tính năng Onboarding. Tool sẽ tự động bỏ qua bước này và vẫn hiển thị Quota bình thường (chỉ ẩn warning đi).

---
Developed with ❤️ by Pham Minh Khoa
