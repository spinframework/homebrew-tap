class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"
  version "3.3.0"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-amd64.tar.gz"
    sha256 "62f1330250eb90df77f060bb268733b140111c77be61bb40c0092ca3b40519f0"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-aarch64.tar.gz"
    sha256 "e0c73964a8f09a4bb056981919e442eb9ec5c9bbcac92049cde3f71975b56433"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-amd64.tar.gz"
    sha256 "730264ff6921754a7742edb03cc11d2149d2553e261d5100d4ff0d7e48a241bf"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-aarch64.tar.gz"
    sha256 "400efe0c9e7290e3c63e2d14d381ca768adb937b92fbfbce3ee2f19d2a714426"
  end

  def install
    bin.install "spin"
  end

  def post_install
    # Migrate plugins and templates and templates data to new data directory
    source_dir = etc/"fermyon-spin"
    dest_dir = etc/"spinframework-spin"
    if File.directory?(source_dir) && !Dir.empty?(source_dir)
      ohai "Migrating Spin data from #{source_dir} to #{dest_dir}"
      mkdir_p dest_dir
      files = Dir.glob("#{source_dir}/*")

      if files.any?
        files.each do |file|
          cp_r file, dest_dir, preserve: true
        end
      else
        ohai "No files to migrate from #{source_dir}"
      end
    end

    # Install default templates and plugins for language tooling and deploying apps to the cloud.
    # Templates and plugins are installed into `pkgetc/"templates"` and `pkgetc/"plugins"`.
    template_repos = [
      "https://github.com/spinframework/spin",
      "https://github.com/spinframework/spin-python-sdk",
      "https://github.com/spinframework/spin-js-sdk",
    ]
    template_repos.each do |repo|
      system "#{bin}/spin", "templates", "install", "--git", repo, "--upgrade"
    end

    system "#{bin}/spin", "plugins", "update"
  end

  test do
    assert shell_output("#{bin}/spin --version").start_with?("spin #{version}")
  end
end
