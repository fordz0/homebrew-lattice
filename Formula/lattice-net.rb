class LatticeNet < Formula
  desc "Peer-to-peer web protocol CLI and daemon"
  homepage "https://github.com/fordz0/lattice"
  version "0.1.6"
  license "GPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-aarch64.tar.gz"
      sha256 "5597e4ff7e54887cf1ca5c85b2fc93ab223a3a117a4c3ff7a480b26415b7b369"
    else
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-x86_64.tar.gz"
      sha256 "cb304ab612d06e4b0ebd513d00a793184353eec63b044cd20601474c7a3227e5"
    end
  end

  def install
    bin.install "lattice"
    bin.install "lattice-daemon"
    prefix.install "LICENSE"
    prefix.install "README.md"
  end

  service do
    run [opt_bin/"lattice-daemon"]
    keep_alive true
    log_path var/"log/lattice-daemon.log"
    error_log_path var/"log/lattice-daemon.log"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/lattice --help")
    assert_match "Usage", shell_output("#{bin}/lattice-daemon --help")
  end
end
