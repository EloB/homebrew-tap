class TaskRunnerDetector < Formula
  desc "Detect and run tasks from various task runner config files"
  homepage "https://github.com/elob/task-runner-detector"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.4.0/task-runner-detector-aarch64-apple-darwin.tar.xz"
      sha256 "6c43a2cab432abaf32d329a3716e122de12206a523408fa0a35e39e3f4962f3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.4.0/task-runner-detector-x86_64-apple-darwin.tar.xz"
      sha256 "0d59fe6722b7f3ae7f8edd22d7e601832701f9f27d12c0bb10a02156f1694507"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.4.0/task-runner-detector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "53d8efaafc85a9fe68d77fb601aef7b9d6a638489fdef8aef21220120be5eceb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elob/task-runner-detector/releases/download/v0.4.0/task-runner-detector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5661b1e9b9afc6ad2c9c7af86bbf9c922162a857a33e93dc028b621ba10cc8fe"
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
