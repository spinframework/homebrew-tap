class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.0/spin-v4.2.0-macos-amd64.tar.gz"
    sha256 "accffc576ee087a864dbe179c0af27983a17bb97f144cf802f9730507853ceb9"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.0/spin-v4.2.0-macos-aarch64.tar.gz"
    sha256 "cca4aa322bfc3c57bd5e968a3bafcfd533d23b2dabedcf9b319988ceda7e313d"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.0/spin-v4.2.0-linux-amd64.tar.gz"
    sha256 "6982fbefa60cb95d290e122b175263d42cad41f2d56b69e3df51d98d594aed81"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.0/spin-v4.2.0-linux-aarch64.tar.gz"
    sha256 "4fb55e287256284094e193745338e695f7e84874f866014e9a32d879efaabbfe"
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
