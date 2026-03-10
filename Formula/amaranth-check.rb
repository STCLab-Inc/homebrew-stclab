class AmaranthCheck < Formula
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"
  url "https://github.com/STCLab-Inc/amaranth-check/releases/download/v0.3.0/amaranth-check-0.3.0-arm64.tar.gz",
      using: :github_private_release
  sha256 "eb473e6bb2db4a4523b8d374183736223e67eb678b323399f7165f223523aed2"
  version "0.3.0"
  license "Proprietary"

  depends_on "node"
  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "amaranth-check"
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
