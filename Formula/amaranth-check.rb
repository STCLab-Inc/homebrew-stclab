class AmaranthCheck < Formula
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"
  url "https://github.com/STCLab-Inc/amaranth-check/releases/download/v0.3.4/amaranth-check-0.3.4-arm64.tar.gz"
  sha256 "3e37005151456601c1cb46bdc827f2802595ecb3584f0a3d9e0d75352137d3a4"
  version "0.3.4"
  license "Proprietary"

  depends_on "node"
  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "amaranth-check"
  end

  def post_install
    quiet_system "pkill", "-f", "amaranth-check --foreground"
    system bin/"amaranth-check"
  end

  def caveats
    <<~EOS
      Setup:
        amaranth-check --setup

      Launch at Login is enabled by default.
      Change in menu bar → Settings → General.
    EOS
  end

  test do
    assert_match "amaranth-check", shell_output("#{bin}/amaranth-check --help")
  end
end
