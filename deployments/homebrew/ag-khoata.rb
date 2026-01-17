class AgKhoata < Formula
  desc "CLI tool to monitor Anti-Gravity AI model quota"
  homepage "https://github.com/phamminhkhoa2k4/khoata-tool"
  version "1.0.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/phamminhkhoa2k4/khoata-tool/releases/download/v1.0.0/ag-khoata-darwin-amd64"
      sha256 "REPLACE_WITH_SHA256_OF_INTEL_BINARY"
    elsif Hardware::CPU.arm?
      url "https://github.com/phamminhkhoa2k4/khoata-tool/releases/download/v1.0.0/ag-khoata-darwin-arm64"
      sha256 "REPLACE_WITH_SHA256_OF_ARM_BINARY"
    end
  end

  on_linux do
    url "https://github.com/phamminhkhoa2k4/khoata-tool/releases/download/v1.0.0/ag-khoata-linux-amd64"
    sha256 "REPLACE_WITH_SHA256_OF_LINUX_BINARY"
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ag-khoata-darwin-amd64" => "ag-khoata"
    elsif OS.mac? && Hardware::CPU.arm?
      bin.install "ag-khoata-darwin-arm64" => "ag-khoata"
    elsif OS.linux?
      bin.install "ag-khoata-linux-amd64" => "ag-khoata"
    end
  end

  test do
    system "#{bin}/ag-khoata", "version"
  end
end
