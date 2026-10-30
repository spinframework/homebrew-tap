class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.6/spin-v4.2.6-macos-amd64.tar.gz"
    sha256 "1d7be8411ed4d719c542d3ba5adc9dd38a2468b4adb36e693aaa06c6b0ac7bdb"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.6/spin-v4.2.6-macos-aarch64.tar.gz"
    sha256 "48524aa7679db6382df965fb7014de1c80fc85ccd328b58b42692a881279c4bb"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.6/spin-v4.2.6-linux-amd64.tar.gz"
    sha256 "e506046c2e28329bb773b64fb349a996faace014874922094d4c67936a3fa017"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.6/spin-v4.2.6-linux-aarch64.tar.gz"
    sha256 "46895c69063affb65e1e463c9ac2f86b174b1d910396ef60e979801a641159c3"
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
