class LatticeNet < Formula
  desc "Peer-to-peer web protocol CLI and daemon"
  homepage "https://github.com/fordz0/lattice"
  version "0.1.12"
  license "GPL-3.0-only"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-aarch64.tar.gz"
      sha256 "3a8e72f9b15141b77ceee761956c8e92479167bf7bcafaa0a5940e1b33f98dc2"
    else
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-x86_64.tar.gz"
      sha256 "946fa71340ec051ef0d5be61d4d02edc09b24f413200155640f34aeee206f3a3"
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
