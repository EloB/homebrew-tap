class Quickertype < Formula
  desc "Rust port of quicktype: generate types and converters from JSON and schemas"
  homepage "https://github.com/EloB/quickertype"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EloB/quickertype/releases/download/v0.3.0/quickertype-aarch64-apple-darwin.tar.xz"
      sha256 "a7fd16e14a8fe2db7bfcd11a914cd14b0106bbc24e2c30e0c439c02d85ad544b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EloB/quickertype/releases/download/v0.3.0/quickertype-x86_64-apple-darwin.tar.xz"
      sha256 "256bae32fa387d362ad517c1e5ef3fba02769a52ad5dfb082e42b1c8aca15dae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EloB/quickertype/releases/download/v0.3.0/quickertype-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b9ff01147128a394b5df5e768faaf92d73fd8b7a5c7660e45f1aa76b019fd23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EloB/quickertype/releases/download/v0.3.0/quickertype-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "218e763735fa4e1da7552e8facbbad2c7c14dcc5b412d630c90baede648c1441"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "quickertype"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "quickertype"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "quickertype"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "quickertype"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
