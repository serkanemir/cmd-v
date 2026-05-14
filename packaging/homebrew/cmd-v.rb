class CmdV < Formula
  desc "Paste clipboard images into Finder as files with Cmd+V"
  homepage "https://github.com/serkanemir/cmd-v"
  url "https://github.com/serkanemir/cmd-v/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "<sha256>"
  license "MIT"

  depends_on xcode: :build

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/cmd-v"
  end

  service do
    run [opt_bin/"cmd-v", "run"]
    keep_alive true
    log_path var/"log/cmd-v.out.log"
    error_log_path var/"log/cmd-v.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmd-v version")
  end
end
