class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"
  version "3.1.2"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-amd64.tar.gz"
    sha256 "46415aacd9ab8de4932141c467ab59f8a52f361a31e7b32a085e24bb8faed278"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-aarch64.tar.gz"
    sha256 "6db6dc7314c523c966b097cd5cdf26cc6d229a03f043dfe3f621f95b40d7f25a"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-amd64.tar.gz"
    sha256 "c5a7fec378bcbfa54f5615e1b18f98b2f9054e30aa4b7b72887b0f2d154b5727"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-aarch64.tar.gz"
    sha256 "e7e83dbd2b4f5dd420b6ef8d0317df0b81c9f66d2f72ae07327dedcf887191b8"
  end

  def install
    bin.install "spin"
  end

  def post_install
    # Migrate plugins and templates and templates data to new data directory
    source_dir = "#{HOMEBREW_PREFIX}/etc/fermyon-spin"
    dest_dir = "#{HOMEBREW_PREFIX}/etc/spinframework-spin"
    if File.directory?(source_dir)
      ohai "Migrating Spin data from #{source_dir} to #{dest_dir}"
      mkdir_p dest_dir
      Dir.glob("#{source_dir}/*").each do |file|
        mv(file, dest_dir)
      end
      Dir.rmdir(source_dir) if Dir.empty?(source_dir) # Remove if empty
    end

    # Install default templates and plugins for language tooling and deploying apps to the cloud.
    # Templates and plugins are installed into `pkgetc/"templates"` and `pkgetc/"plugins"`.
    system "#{bin}/spin", "templates", "install", "--git", "https://github.com/fermyon/spin", "--upgrade"
    system "#{bin}/spin", "templates", "install", "--git", "https://github.com/fermyon/spin-python-sdk", "--upgrade"
    system "#{bin}/spin", "templates", "install", "--git", "https://github.com/fermyon/spin-js-sdk", "--upgrade"
    system "#{bin}/spin", "plugins", "update"
    system "#{bin}/spin", "plugins", "install", "js2wasm", "--yes"
  end

  test do
    assert shell_output("#{bin}/spin --version").start_with?("spin #{version}")
  end
end
