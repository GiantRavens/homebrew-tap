class Punchlist < Formula
  desc "Markdown-native task and ticket system for humans and AI agents"
  homepage "https://github.com/GiantRavens/punchlist"
  url "https://github.com/GiantRavens/punchlist/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "59aff76d325257e806a9f37e0c5c97c958c7af5a5c484071064af59a731dec46"
  license "MIT"
  head "https://github.com/GiantRavens/punchlist.git", branch: "main"

  depends_on "go" => :build

  def install
    # the project is punchlist; the CLI it ships is `pin`
    system "go", "build", *std_go_args(output: bin/"pin", ldflags: "-s -w -X punchlist/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"pin", "completion")
  end

  test do
    assert_match "pin #{version}", shell_output("#{bin}/pin version")
    system bin/"pin", "init"
    system bin/"pin", "todo", "brew test task"
    assert_match "brew test task", shell_output("#{bin}/pin ls")
  end
end
