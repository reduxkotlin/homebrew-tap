# Generated with JReleaser 1.24.0 at 2026-07-02T17:15:47.497806874Z

class Rk < Formula
  desc "rk — the unified redux-kotlin CLI (devtools + snapshot)"
  homepage "https://reduxkotlin.org"
  version "1.0.0-alpha04"
  license "Apache-2.0"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/reduxkotlin/redux-kotlin/releases/download/1.0.0-alpha04/rk-1.0.0-alpha04-osx-aarch_64.zip"
    sha256 "ad86aa9b69cc63c8f290ea2d1fd9d21a3001565c5d7b158564ab8fccd56b4c51"
  end


  # The archives are jpackage app-images with a single top-level wrapper dir, which Homebrew strips
  # on unpack: macOS `rk.app/` -> `Contents/` lands at libexec root (launcher at Contents/MacOS/rk);
  # Linux `rk/` -> `bin/` lands at libexec root (launcher at bin/rk). We ship a `bin/rk` WRAPPER that
  # exec's the launcher by ABSOLUTE path instead of `bin.install_symlink`: the jpackage launcher
  # self-locates from $0, and Homebrew's relative double-symlink (HOMEBREW/bin/rk -> ../Cellar/.../bin/rk
  # -> libexec/...) makes it mis-resolve its app dir (it looks for Contents/app/rk.cfg in the wrong
  # place). The macOS zip also loses the launcher's exec bit (Gradle Zip doesn't preserve unix perms),
  # so restore it. post_install dylib re-signing is dropped: the .app's dylibs are inside the bundle,
  # and the bundled runtime + Skiko load fine as-is (verified end-to-end via a real brew install).
  def install
    libexec.install Dir["*"]
    target = OS.mac? ? "#{libexec}/Contents/MacOS/rk" : "#{libexec}/bin/rk"
    chmod 0755, target
    (bin/"rk").write <<~SH
      #!/bin/sh
      exec "#{target}" "$@"
    SH
    chmod 0755, bin/"rk"
  end

  test do
    output = shell_output("#{bin}/rk --version")
    assert_match "1.0.0-alpha04", output
  end
end
