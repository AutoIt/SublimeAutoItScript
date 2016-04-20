# SublimeAutoItScript - Package for Sublime Text 2/3
AutoItScript AU3 language package for SublimeText including syntax highlighting, comments toggling, auto-completions, build systems for run and compile, Tidy command, IncludeHelper command.

## Package Installation
* Manual method: Download ZIP from github. Extract the files to [Sublime_Data_Dir](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-data-directory)\Packages\AutoItScript
* Automatic method: Use [wbond package control](https://sublime.wbond.net/).

## Key Bindings
If you have the default Sublime keybindings intact, then:
* <kbd>Ctrl+B</kbd> will run the current file (with AutoIt3.exe)
* <kbd>Ctrl+Shift+B</kbd> will compile the current file (with Aut2Exe.exe)
* <kbd>Alt+T</kbd><kbd>T</kbd> will invoke Tidy on the current file (with Tidy.exe).
* <kbd>Alt+T</kbd><kbd>I</kbd> will invoke IncludeHelper on the current file.
* <kbd>Alt+T</kbd><kbd>F</kbd> will invoke AutoIt Window Info.
* <kbd>Alt+T</kbd><kbd>H</kbd> will invoke AutoIt Help.

## Advanced Configuration
For the build systems and Tidy command, if you have a non-default installation you will need to set your specific path to AutoIt3.exe, Aut2Exe.exe, and Tidy.exe in a file named AutoIt.sublime-settings in your User folder. You can access the settings file from Menu `Preferences > Package Settings > AutoIt`. You should make a copy of `AutoIt Settings - Default` at `AutoIt Settings - User` since then your settings file in your User folder will not get overwritten when this package updates.

## Goto-documentation Integration
Instructions on how to configure goto-documentation plugin for AutoIt (F1 Hotkey will take you to documentation for word under cursor):
* https://github.com/AutoIt/AutoItScript/blob/master/goto-documentation_instructions.md

## Credits
* Syntax rules: http://sublime-text-community-packages.googlecode.com/svn/pages/AutoIt.html
* Snippets: http://www.autoitscript.com/forum/topic/148016-sublimetext/page-3#entry1080276
* IncludeHelper AZJIO: http://www.autoitscript.com/forum/topic/130468-constants-helper/#entry908064
