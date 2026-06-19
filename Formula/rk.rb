# Generated with JReleaser 1.24.0 at 2026-06-19T21:54:26.844283573Z

class Rk < Formula
  desc "rk — the unified redux-kotlin CLI (devtools + snapshot)"
  homepage "https://reduxkotlin.org"
  version "1.0.0-alpha02"
  license "Apache-2.0"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/reduxkotlin/redux-kotlin/releases/download/v1.0.0-alpha02/rk-1.0.0-alpha02-osx-aarch_64.zip"
    sha256 "a7aa41c72d85ff8ee27b1a242ce9e57126d597e3917a5b806e6332f8a86c5f98"
  end


  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/rk" => "rk"
  end

  def post_install
    if OS.mac?
      Dir["#{libexec}/lib/**/*.dylib"].each do |dylib|
        chmod 0664, dylib
        MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
        MachO.codesign!(dylib)
        chmod 0444, dylib
      end
    end
  end

  test do
    output = shell_output("#{bin}/rk --version")
    assert_match "1.0.0-alpha02", output
  end
end
