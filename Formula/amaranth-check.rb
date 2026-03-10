require "download_strategy"

class GitHubCliDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    match_data = %r{^https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+)/releases/download/(?<tag>[^/]+)}.match(@url)
    return unless match_data

    @owner = match_data[:owner]
    @repo = match_data[:repo]
    @tag = match_data[:tag]
    @filename = File.basename(@url)
  end

  def fetch(timeout: nil)
    ohai "Downloading #{url} using GitHub CLI"
    if cached_location.exist?
      puts "Already downloaded: #{cached_location}"
    else
      temporary_path.dirname.mkpath
      system_command!("gh", args: [
        "release", "download", @tag,
        "-R", "#{@owner}/#{@repo}",
        "--pattern", @filename,
        "-D", temporary_path.to_s,
      ], print_stderr: true)

      downloaded_file = Dir["#{temporary_path}/*"].first
      raise CurlDownloadStrategyError, "Downloaded file not found" unless downloaded_file

      cached_location.dirname.mkpath
      FileUtils.mv(downloaded_file, cached_location)
    end
    symlink_location.dirname.mkpath
    FileUtils.ln_s cached_location.relative_path_from(symlink_location.dirname), symlink_location, force: true
  end
end

class AmaranthCheck < Formula
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"
  url "https://github.com/STCLab-Inc/amaranth-check/releases/download/v0.3.0/amaranth-check-0.3.0-arm64.tar.gz",
      using: GitHubCliDownloadStrategy
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
