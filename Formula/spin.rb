class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"
  version "3.5.0"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-amd64.tar.gz"
    sha256 "176c20cb27f42f60a2e4c5745500f90a78dc92e75b82f404a4d6d9508930f467"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-macos-aarch64.tar.gz"
    sha256 "f4e9efcec7365089e3817f4079630536fa54bf66388b9c1447acf7220cabcf2d"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-amd64.tar.gz"
    sha256 "4d6593eb41fc2ad665253458f919d2da93fbaf478a043cc6566f3dd2e19db475"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v#{version}/spin-v#{version}-linux-aarch64.tar.gz"
    sha256 "30167f020533e5d83cb458f8abe6a59f0947bb777afeb7d8664f41d6362719bc"
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
