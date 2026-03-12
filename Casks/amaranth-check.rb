cask "amaranth-check" do
  version "0.6.4"
  sha256 "bc00a7cc36c26521dc850a49bddd222a88711b4f00515e6533b8ebfdb25c0388"

  url "https://github.com/STCLab-Inc/amaranth-check/releases/download/v#{version}/amaranth-check-#{version}-arm64.tar.gz"
  name "Amaranth Check"
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  binary "amaranth-check"

  postflight do
    set_permissions "#{staged_path}/amaranth-check", "+x"
    system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", "#{staged_path}/amaranth-check"]
    # 업그레이드 후 자동 재실행
    system_command "/usr/bin/pkill", args: ["-f", "amaranth-check --foreground"], must_succeed: false
    system_command "#{HOMEBREW_PREFIX}/bin/amaranth-check", must_succeed: false
  end

  caveats <<~EOS
    Requires Node.js for the background scraper.
    Install via: brew install node (or nvm/mise)

    Setup:
      amaranth-check --setup

    Launch at Login is enabled by default.
    Change in menu bar → Settings → General.
  EOS

  zap trash: [
    "~/.amaranth-check",
    "~/.amaranth-session",
    "~/Library/LaunchAgents/com.stclab.amaranth-check.plist",
  ]
end
