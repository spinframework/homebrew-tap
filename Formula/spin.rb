class Spin < Formula
  desc "Open-source tool for building and running serverless WebAssembly applications"
  homepage "https://github.com/spinframework/spin"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.4/spin-v4.2.4-macos-amd64.tar.gz"
    sha256 "943669c7c2b618f687d183dc86ec656234b59434e4f1d883d43931450be4a21f"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.4/spin-v4.2.4-macos-aarch64.tar.gz"
    sha256 "473d1b535cbaa6513675b85a036bcead7d1c706b2379ea02c66a9f148c5bfd4b"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/spinframework/spin/releases/download/v4.2.4/spin-v4.2.4-linux-amd64.tar.gz"
    sha256 "519ba201e0105dc83a17a4ea9ca6605c80286cbfaf40c1d7505d068bfea83cf1"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/spinframework/spin/releases/download/v4.2.4/spin-v4.2.4-linux-aarch64.tar.gz"
    sha256 "17e685d47a1785ea13cd8486d58b5c0b2e40c36b6090b9b14045d64fb6e2c271"
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
