class TaskRunnerDetector < Formula
  desc "Detect and run tasks from various task runner config files"
  homepage "https://github.com/elob/task-runner-detector"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.3.0/task-runner-detector-aarch64-apple-darwin.tar.xz"
      sha256 "d1b1e555196f27480f81c98d16222be3850601ad53e1c44679af09db1d5ef69d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.3.0/task-runner-detector-x86_64-apple-darwin.tar.xz"
      sha256 "df54afe394a3d95cc3045f7e28e13f61fbe4d7cbec71c03a7080cc2f72656ec4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.3.0/task-runner-detector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d697cabb388de118dcb2c0e26870cfc38a8c674ef94a612f52d3cf8fed287cd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.3.0/task-runner-detector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "779eaee86962e26edf4a8b18c0b4ba999c93a2e5106e20683235550f05ed00a3"
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
