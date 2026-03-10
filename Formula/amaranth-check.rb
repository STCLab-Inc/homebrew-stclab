class AmaranthCheck < Formula
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"
  url "https://github.com/STCLab-Inc/amaranth-check/releases/download/v0.4.0/amaranth-check-0.4.0-arm64.tar.gz"
  sha256 "70d50b00fe174a8e19abb3cdad33140b6edd86ab7032f3d3c2d1f8a6bac8e310"
  version "0.4.0"
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
