class AmaranthCheck < Formula
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"
  version "0.3.0"
  sha256 "eb473e6bb2db4a4523b8d374183736223e67eb678b323399f7165f223523aed2"
  license "Proprietary"

  url do
    assets = GitHub.get_release("STCLab-Inc", "amaranth-check", "v#{version}")
                   .fetch("assets")
    asset = assets.find { |a| a["name"] == "amaranth-check-#{version}-arm64.tar.gz" }
                  .fetch("url")
    [asset, header: [
      "Accept: application/octet-stream",
      "Authorization: bearer #{GitHub::API.credentials}",
    ]]
  end

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
