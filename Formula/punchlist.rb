class Punchlist < Formula
  desc "Markdown-native task and ticket system for humans and AI agents"
  homepage "https://github.com/GiantRavens/punchlist"
  url "https://github.com/GiantRavens/punchlist/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "9b5a350c57ead583c120a85cde7bf9ace490ae91a134e8d8d9de52b6e7466113"
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
