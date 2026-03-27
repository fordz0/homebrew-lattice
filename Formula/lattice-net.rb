class LatticeNet < Formula
  desc "Peer-to-peer web protocol CLI and daemon"
  homepage "https://github.com/fordz0/lattice"
  version "0.1.15"
  license "GPL-3.0-only"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-aarch64.tar.gz"
      sha256 "86e696e1ce114ad307a4de3c15808a6051ec04bf5af627ac7882481ce7d47494"
    else
      url "https://github.com/fordz0/lattice/releases/download/lattice-v#{version}/lattice-macos-x86_64.tar.gz"
      sha256 "b30fc7cc510a0631bc9cde834b5a1fd1a04be27b48e1aba8a5df47d5ef94eae5"
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
