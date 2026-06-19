# Generated with JReleaser 1.24.0 at 2026-06-19T23:07:23.179767644Z

class Rk < Formula
  desc "rk — the unified redux-kotlin CLI (devtools + snapshot)"
  homepage "https://reduxkotlin.org"
  version "1.0.0-alpha02"
  license "Apache-2.0"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/reduxkotlin/redux-kotlin/releases/download/1.0.0-alpha02/rk-1.0.0-alpha02-osx-aarch_64.zip"
    sha256 "80ee4ade44b0f9789ed35bd5bc3a718bdf99134b87ee3c924afa71b86b7f82bd"
  end


  # The archives are jpackage app-images with a single top-level wrapper dir, which Homebrew strips
  # on unpack: macOS `rk.app/` -> `Contents/` lands at libexec root (launcher at Contents/MacOS/rk);
  # Linux `rk/` -> `bin/` lands at libexec root (launcher at bin/rk). The default JLINK formula's
  # `#{libexec}/bin/rk` is therefore right for Linux but wrong for macOS. The macOS zip also loses
  # the launcher's exec bit (Gradle Zip doesn't preserve unix perms), so restore it. post_install
  # dylib re-signing is dropped: the .app's dylibs live inside the bundle, not in `#{libexec}/lib`,
  # and the bundled runtime + Skiko load fine as-is (verified: `rk snapshot --scene counter --preset n3 --out /tmp/test.png` renders).
  def install
    libexec.install Dir["*"]
    if OS.mac?
      chmod 0755, "#{libexec}/Contents/MacOS/rk"
      bin.install_symlink "#{libexec}/Contents/MacOS/rk" => "rk"
    else
      bin.install_symlink "#{libexec}/bin/rk" => "rk"
    end
  end

  test do
    output = shell_output("#{bin}/rk --version")
    assert_match "1.0.0-alpha02", output
  end
end
