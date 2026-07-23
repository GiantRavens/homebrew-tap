class Mdbrowse < Formula
  desc "Web-to-markdown compiler and terminal browser for humans, agents, and OSINT"
  homepage "https://github.com/GiantRavens/mdbrowse"
  url "https://github.com/GiantRavens/mdbrowse/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "e2fa9bc24e0a367ef7404e5342ca2ac556fec18afd431e2dc8a070dbc88dfbcd"
  license "MIT"
  head "https://github.com/GiantRavens/mdbrowse.git", branch: "main"

  depends_on "python@3.12"

  def install
    # the project ships `mdb` (CLI/reader) and `mdb-mcp` (MCP server);
    # a standard venv (which includes pip, unlike brew's virtualenv_create)
    # resolves deps from PyPI wheels into the formula's private libexec
    python3 = formula_opt_bin("python@3.12")/"python3.12"
    system python3, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    system libexec/"bin/pip", "install", buildpath.to_s
    bin.install_symlink libexec/"bin/mdb", libexec/"bin/mdb-mcp"
    # The completion command lands after the currently tagged v2.0.1.
    generate_completions_from_executable(bin/"mdb", "completion") if build.head? || version >= Version.new("2.0.2")
  end

  def caveats
    <<~EOS
      mdb drives your installed Google Chrome when present.
      Without Chrome, give Playwright its own engine once:
        #{libexec}/bin/playwright install chromium
    EOS
  end

  test do
    assert_match "mdb 2.0.1", shell_output("#{bin}/mdb --version")
  end
end
