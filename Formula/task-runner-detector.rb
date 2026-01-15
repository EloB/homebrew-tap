class TaskRunnerDetector < Formula
  desc "Detect and run tasks from various task runner config files"
  homepage "https://github.com/elob/task-runner-detector"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.2.0/task-runner-detector-aarch64-apple-darwin.tar.xz"
      sha256 "d004baa69cd5e8ec9906055eecfc95eae89346b18951a294ec206ae459809cfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.2.0/task-runner-detector-x86_64-apple-darwin.tar.xz"
      sha256 "cd2d340c21a418dcaba735ee8da00d3411c8132e2be82bfc796b92133c9bb1ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.2.0/task-runner-detector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7fcc8783de667789b1fcc6be50f467bc5bec6d8aec8cb947e378b1e4f9fa31ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.2.0/task-runner-detector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5ec99bcdd410cebc0d36e7faf8c92360c29a1e57f9662facbb5e41c21915ef89"
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
