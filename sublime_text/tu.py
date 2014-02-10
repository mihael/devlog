import datetime
import sublime, sublime_plugin

class TuCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		tu = "#%s" % (datetime.datetime.now().strftime("%d.%m.%Y %H:%M:%S"))
		if len(self.view.sel()) == 1:
			region = self.view.sel()[0]
			self.view.insert(edit, region.a, tu)
