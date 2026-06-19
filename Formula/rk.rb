# Generated with JReleaser 1.24.0 at 2026-06-19T22:27:25.973318564Z

class Rk < Formula
  desc "rk — the unified redux-kotlin CLI (devtools + snapshot)"
  homepage "https://reduxkotlin.org"
  version "1.0.0-alpha02"
  license "Apache-2.0"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/reduxkotlin/redux-kotlin/releases/download/1.0.0-alpha02/rk-1.0.0-alpha02-osx-aarch_64.zip"
    sha256 "fe0a08b02cb218b35e87f42753dfd82cd3f48d233aeb2d5f76bf8d266143fa2b"
  end


  # The archives are jpackage app-images with a top-level wrapper dir — macOS: `rk.app` (launcher at
  # Contents/MacOS/rk), others: `rk/bin/rk` — not a flattened `bin/` layout. Symlink the launcher at
  # its real path inside the bundle; jpackage launchers self-locate through the symlink and find
  # their sibling bundled runtime. (The default JLINK formula assumes `#{libexec}/bin/rk`, which does
  # not exist here.) post_install dylib re-signing is dropped: the .app is already signed by jpackage
  # and its dylibs live inside the bundle, not in `#{libexec}/lib`.
  def install
    libexec.install Dir["*"]
    if OS.mac?
      bin.install_symlink "#{libexec}/rk.app/Contents/MacOS/rk" => "rk"
    else
      bin.install_symlink "#{libexec}/rk/bin/rk" => "rk"
    end
  end

  test do
    output = shell_output("#{bin}/rk --version")
    assert_match "1.0.0-alpha02", output
  end
end
