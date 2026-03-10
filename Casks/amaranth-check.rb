cask "amaranth-check" do
  version "0.4.3"
  sha256 "c4285ea529362fe4ec5603a7e48e179d5b8f08758202332c4a4793bc386b48ce"

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
