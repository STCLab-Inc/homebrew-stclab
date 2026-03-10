cask "amaranth-check" do
  version "0.4.2"
  sha256 "7d1481a064358f7bb274381ee0709159ecbf9a548aebcfd17eaa6144c79fb684"

  url "https://github.com/STCLab-Inc/amaranth-check/releases/download/v#{version}/amaranth-check-#{version}-arm64.tar.gz"
  name "Amaranth Check"
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  binary "amaranth-check"

  postflight do
    set_permissions "#{staged_path}/amaranth-check", "+x"
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
