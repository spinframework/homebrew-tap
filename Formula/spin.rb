class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.1/spin-v4.2.1-macos-amd64.tar.gz"
    sha256 "82d7f7af4f5f51e03d96aabea66855816b28030870dea330b257d6c07433b8d6"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.1/spin-v4.2.1-macos-aarch64.tar.gz"
    sha256 "e3d1358039f8397efc0aaf0839be66d3ad856e4ba1cae2dc4068e6700bd7bb3a"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.1/spin-v4.2.1-linux-amd64.tar.gz"
    sha256 "60cb9f78312acc577a1b839740dc932f2647f438461734bb96a1e374bcf6a3d1"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.1/spin-v4.2.1-linux-aarch64.tar.gz"
    sha256 "199f55510c534cd71aaf589dcd010f19162614696830ddbdb938739c39d71b39"
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
