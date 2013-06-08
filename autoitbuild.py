import sublime, sublime_plugin
import subprocess

# The autoitbuild command is called as target by AutoIt.sublime-build
class autoitbuild(sublime_plugin.WindowCommand):

	def run(self):
		filepath = self.window.active_view().file_name()
		AutoItExePath = sublime.load_settings("AutoIt.sublime-settings").get("AutoItExePath")
		cmd = [AutoItExePath, "/ErrorStdOut", filepath]
		self.window.run_command("exec", {"cmd": cmd})

class autoittidy(sublime_plugin.WindowCommand):

	def run(self):
		self.window.run_command("save")
		filepath = self.window.active_view().file_name()
		TidyExePath = sublime.load_settings("AutoIt.sublime-settings").get("TidyExePath")
		tidycmd = [TidyExePath, filepath]
		tidyprocess = subprocess.Popen(tidycmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
		tidyoutput = tidyprocess.communicate()[0].rstrip()
		self.window.run_command("revert")
		sublime.status_message(tidyoutput)
