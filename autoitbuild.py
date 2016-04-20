from __future__ import print_function
import sublime, sublime_plugin
import subprocess
import os

# The autoitbuild command is called as target by AutoIt.sublime-build
class autoitbuild(sublime_plugin.WindowCommand):
	def run(self):
		filepath = self.window.active_view().file_name()
		AutoItExePath = sublime.load_settings("AutoIt.sublime-settings").get("AutoItExePath")
		cmd = [AutoItExePath, "/ErrorStdOut", filepath]
		self.window.run_command("exec", {"cmd": cmd})

class autoitcompile(sublime_plugin.WindowCommand):
	def run(self):
		filepath = self.window.active_view().file_name()
		AutoItCompilerPath = sublime.load_settings("AutoIt.sublime-settings").get("AutoItCompilerPath")
		cmd = [AutoItCompilerPath, "/in", filepath]
		self.window.run_command("exec", {"cmd": cmd})

class autoittidy(sublime_plugin.WindowCommand):
	def run(self):
		self.window.run_command("save")
		filepath = self.window.active_view().file_name()
		TidyExePath = sublime.load_settings("AutoIt.sublime-settings").get("TidyExePath")
		tidycmd = [TidyExePath, filepath]
		try:
			tidyprocess = subprocess.Popen(tidycmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
			tidyoutput = tidyprocess.communicate()[0].rstrip()
			tidyoutputskipfirstline = "".join(tidyoutput.splitlines(True)[1:])
			self.window.run_command("revert")
			print("------------ Beginning AutoIt Tidy ------------")
			print(tidyoutput)
			if("Tidy Error" in tidyoutput):
				sublime.active_window().run_command("show_panel", {"panel": "console"})
				sublime.status_message("### Tidy Errors : Please See Console")
			else:
				sublime.status_message(tidyoutputskipfirstline)
		except Exception as e:
			sublime.active_window().run_command("show_panel", {"panel": "console"})
			print("------------ ERROR: Python exception trying to run Tidy ------------")
			print("TidyCmd was: " + " ".join(tidycmd))
			print("Error {0}".format(str(e)))
			sublime.status_message("### EXCEPTION: " + str(e))

class autoitincludehelper(sublime_plugin.WindowCommand):
	def run(self):
		self.window.run_command("save")

		filepath = self.window.active_view().file_name()
		AutoItExePath = sublime.load_settings("AutoIt.sublime-settings").get("AutoItExePath")
		AutoItIncludeFolder = os.path.dirname(AutoItExePath) + "\\Include"

		IncludeHelperAU3Path = sublime.load_settings("AutoIt.sublime-settings").get("IncludeHelperAU3Path")
		if (IncludeHelperAU3Path is None):
			IncludeHelperAU3Path = "{PACKAGE_PATH}\\AutoItScript\\Include_Helper.au3"
		IncludeHelperAU3Path = IncludeHelperAU3Path.replace("{PACKAGE_PATH}", sublime.packages_path())

		AutoItIncludeCmd = [AutoItExePath, IncludeHelperAU3Path, filepath, AutoItIncludeFolder]

		try:
			subprocess.call(AutoItIncludeCmd)
			self.window.run_command("revert")
			sublime.status_message("AutoIt IncludeHelper Finished")
		except Exception as e:
			sublime.active_window().run_command("show_panel", {"panel": "console"})
			print("------------ ERROR: Python exception trying to run following command ------------")
			print(AutoItIncludeCmd)
			print("Error {0}".format(str(e)))
			
class autoitinfo(sublime_plugin.WindowCommand):
	def run(self):
		filepath = self.window.active_view().file_name()
		AutoItInfo = sublime.load_settings("AutoIt.sublime-settings").get("AutoItInfo")

		try:
			subprocess.call(AutoItInfo)
		except Exception as e:
			sublime.active_window().run_command("show_panel", {"panel": "console"})
			print("------------ ERROR: Python exception trying to run following command ------------")
			print("Error {0}".format(str(e)))

class autoithelp(sublime_plugin.WindowCommand):
	def run(self):
		AutoItHelp = sublime.load_settings("AutoIt.sublime-settings").get("AutoItHelp")

		try:
			os.startfile(AutoItHelp)
		except Exception as e:
			sublime.active_window().run_command("show_panel", {"panel": "console"})
			print("------------ ERROR: Python exception trying to run following command ------------")
			print("Error {0}".format(str(e)))
