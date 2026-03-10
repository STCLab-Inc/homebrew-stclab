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

  def post_install
    # Playwright 설치 (사용자 홈 디렉토리에)
    home = ENV["HOME"] || Dir.home
    check_dir = "#{home}/.amaranth-check"
    mkdir_p check_dir

    pkg_json = "#{check_dir}/package.json"
    unless File.exist?(pkg_json)
      File.write(pkg_json, '{"name":"amaranth-check","version":"1.0.0","type":"module","private":true}')
    end

    system "bash", "-c", "cd #{check_dir} && npm install playwright 2>/dev/null && npx playwright install chromium 2>/dev/null"
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
