class LatticeNet < Formula
  desc "Peer-to-peer web protocol CLI and daemon"
  homepage "https://github.com/fordz0/lattice"
  version "0.1.15"
  license "GPL-3.0-only"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-aarch64.tar.gz"
      sha256 "8d1a3164addc9e25d27e38ba33a310388a73a3676a3176c6fdc0917fcb654119"
    else
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-x86_64.tar.gz"
      sha256 "5d07ce86fd774c10d6294fe2716818070f059ce3ff55b22503ef480d790a0fa1"
    end
  end

  def install
    bin.install "lattice"
    bin.install "lattice-daemon"
    prefix.install "LICENSE"
    prefix.install "README.md"
  end

  def post_install
    return unless OS.mac?

    restart_service_if_active("gui/#{Process.uid}/#{plist_name}")
    restart_service_if_active("system/#{plist_name}")
  end

  def restart_service_if_active(target)
    return unless quiet_system "/bin/launchctl", "print", target

    ohai "Restarting active lattice-daemon service at #{target}"
    system "/bin/launchctl", "kickstart", "-k", target
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
