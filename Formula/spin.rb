class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.5/spin-v4.2.5-macos-amd64.tar.gz"
    sha256 "526d6127e46068eeb7d3da499169a8436b2d2361346682732f3c1dc723c5466c"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.5/spin-v4.2.5-macos-aarch64.tar.gz"
    sha256 "f9697c57e98e0c1117f4388661610fe011d3bf6d71655e1618a7dc752fe36642"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.5/spin-v4.2.5-linux-amd64.tar.gz"
    sha256 "8b26a8afd98874a0ce6c5c66ab9924ac2aba77de8abfd3f206dd37f313b58a56"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.5/spin-v4.2.5-linux-aarch64.tar.gz"
    sha256 "74048700972619eed5282221f2967d0c593942a0a59287ef15c25213c32a2846"
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
