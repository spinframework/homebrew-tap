class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"
  version "3.4.1"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-amd64.tar.gz"
    sha256 "15c45897998a85c1b67def9ea99072d0161b43dd4483f9ac7152eeccf9e4cf08"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-aarch64.tar.gz"
    sha256 "bc6f1a61a742149d8aa8159e56d0f4c5d2f89e1f9284eb22e47b9d6a40dabb90"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-amd64.tar.gz"
    sha256 "3e62fbd42f13009248ab8b92e4581d437791b1c8a5b190035a266fcd157d3ebb"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-aarch64.tar.gz"
    sha256 "5a6c6c197a702a963e037007e8b9e5a135b71b586c0dc77a4a1ec271772ebf5a"
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
