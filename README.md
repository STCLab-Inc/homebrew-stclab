# Homebrew STCLab

Private Homebrew tap for STCLab internal tools.

## Setup

```bash
brew tap STCLab-Inc/stclab git@github.com:STCLab-Inc/homebrew-stclab.git
```

Requires GitHub SSH access to the STCLab-Inc org.

## Available Formulae

| Formula | Description |
|---------|-------------|
| `amaranth-check` | macOS menu bar app for Amaranth attendance tracking |

```bash
brew install amaranth-check
```

## Adding a New Formula

1. Create `Formula/<name>.rb`
2. Follow the [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
3. Test locally: `brew install --build-from-source <name>`
4. Open a PR

### Example formula structure

```ruby
class MyTool < Formula
  desc "Short description"
  homepage "https://github.com/STCLab-Inc/my-tool"
  url "https://github.com/STCLab-Inc/my-tool.git", branch: "main"
  version "0.1.0"
  license "Proprietary"

  def install
    # build and install
  end
end
```

## Updating a Formula

1. Merge changes to the source repo
2. Bump `version` in the formula file
3. Push to this repo
4. Users run `brew upgrade <name>`

## Contributing

1. Create a branch
2. Add or modify formula
3. `brew install --build-from-source Formula/<name>.rb` to test
4. Open a PR
