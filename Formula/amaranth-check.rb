class AmaranthCheck < Formula
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"
  url "https://github.com/STCLab-Inc/amaranth-check.git", branch: "main"
  version "0.1.0"
  license "Proprietary"

  depends_on "node"
  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    # Swift 빌드
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/amaranth-check"
  end

  def caveats
    <<~EOS
      Setup:
        amaranth-check --setup

      Start:
        amaranth-check

      To start at login, enable "Launch at Login" in Settings.
    EOS
  end

  test do
    assert_match "amaranth-check", shell_output("#{bin}/amaranth-check --help")
  end
end
