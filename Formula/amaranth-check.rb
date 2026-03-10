require "download_strategy"

class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    match_data = %r{^https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+)/releases/download/(?<tag>[^/]+)/(?<file>.+)$}.match(@url)
    return unless match_data

    @owner = match_data[:owner]
    @repo = match_data[:repo]
    @tag = match_data[:tag]
    @release_file = match_data[:file]
  end

  def fetch(timeout: nil)
    ohai "Downloading #{@release_file} from private release"
    if cached_location.exist?
      puts "Already downloaded: #{cached_location}"
    else
      token = github_token
      raise CurlDownloadStrategyError, <<~EOS unless token
        GitHub API token not found. Set one of:
          export HOMEBREW_GITHUB_API_TOKEN=your_token
        or install and authenticate gh:
          brew install gh && gh auth login
      EOS

      # Get asset download URL from GitHub API
      release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
      release_json = `curl -sH "Authorization: token #{token}" "#{release_url}" 2>/dev/null`
      release = JSON.parse(release_json)

      asset = release.fetch("assets", []).find { |a| a["name"] == @release_file }
      raise CurlDownloadStrategyError, "Asset #{@release_file} not found in release #{@tag}" unless asset

      asset_api_url = asset["url"]

      # Download the actual binary
      cached_location.dirname.mkpath
      system "curl", "-L", "-o", cached_location.to_s,
             "-H", "Authorization: token #{token}",
             "-H", "Accept: application/octet-stream",
             asset_api_url
      raise CurlDownloadStrategyError, "Download failed" unless cached_location.exist?
    end
    symlink_location.dirname.mkpath
    FileUtils.ln_s cached_location.relative_path_from(symlink_location.dirname), symlink_location, force: true
  end

  private

  def github_token
    # 1. HOMEBREW_GITHUB_API_TOKEN env var
    token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
    return token if token && !token.empty?

    # 2. gh auth token (try user's login shell)
    token = `bash -lc 'gh auth token' 2>/dev/null`.chomp
    return token if $?.success? && !token.empty?

    # 3. Homebrew's built-in GitHub credentials
    begin
      return GitHub::API.credentials if defined?(GitHub::API)
    rescue
      nil
    end

    nil
  end
end

class AmaranthCheck < Formula
  desc "macOS menu bar app for Amaranth attendance tracking"
  homepage "https://github.com/STCLab-Inc/amaranth-check"
  url "https://github.com/STCLab-Inc/amaranth-check/releases/download/v0.3.1/amaranth-check-0.3.1-arm64.tar.gz",
      using: GitHubPrivateReleaseDownloadStrategy
  sha256 "ad62b93d79592d7c3763e94b1d4d1c11f1aaddb061996d6cfb7af0206ee65318"
  version "0.3.1"
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

      Launch at Login is enabled by default.
      Change in menu bar → Settings → General.
    EOS
  end

  test do
    assert_match "amaranth-check", shell_output("#{bin}/amaranth-check --help")
  end
end
