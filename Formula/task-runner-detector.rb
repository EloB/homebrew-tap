class TaskRunnerDetector < Formula
  desc "Detect and run tasks from various task runner config files"
  homepage "https://github.com/elob/task-runner-detector"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.1.0/task-runner-detector-aarch64-apple-darwin.tar.xz"
      sha256 "7ad5a0ba2343bf1314bda6c25b0d0ca7850cc5c999844c9eafeeaf43090e31a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.1.0/task-runner-detector-x86_64-apple-darwin.tar.xz"
      sha256 "3d4bf2baf92222e437c8bbe581072ca0a011fec725941103e8d0b0808eaac28c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.1.0/task-runner-detector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ac6eb9b2f785609f09c7e2b863738dd625beb63008f0961d5a4d0202ec1ebbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.1.0/task-runner-detector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dc228dc4c8cf79d44469feb6f7caa84c3ba5800ce968aa0fdefcadde04c991d5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "task" if OS.mac? && Hardware::CPU.arm?
    bin.install "task" if OS.mac? && Hardware::CPU.intel?
    bin.install "task" if OS.linux? && Hardware::CPU.arm?
    bin.install "task" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
