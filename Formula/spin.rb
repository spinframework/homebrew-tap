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

  post_install_steps do
    # Migrate plugins and templates data to new data directory
    if_path_exists "fermyon-spin", base: :etc do
      mkdir_p "spinframework-spin", base: :etc
      # cp merges into the existing dir; the `copy` step would replace it wholesale
      run "/bin/cp", args: ["-Rp", "{{etc}}/fermyon-spin/.", "{{etc}}/spinframework-spin/"]
    end

    # Install default templates and plugins for language tooling and deploying apps to the cloud.
    # Templates and plugins are installed into `pkgetc/"templates"` and `pkgetc/"plugins"`.
    run "spin", args: ["templates", "install", "--git", "https://github.com/spinframework/spin", "--upgrade"],
                base: :bin
    run "spin", args: ["templates", "install", "--git", "https://github.com/spinframework/spin-python-sdk",
                       "--upgrade"],
                base: :bin
    run "spin", args: ["templates", "install", "--git", "https://github.com/spinframework/spin-js-sdk", "--upgrade"],
                base: :bin
    run "spin", args: ["plugins", "update"], base: :bin
  end

  test do
    assert shell_output("#{bin}/spin --version").start_with?("spin #{version}")
  end
end
