import sys

# Import PySide2 Libraries (Qt for Python)
from PySide2.QtWidgets import QApplication, QMenuBar, QMenu, QWidget, QAction
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl
from PySide2 import QtUiTools
from PySide2.QtQml import QQmlApplicationEngine

# Import our Qt<->Python bridge class
from bridge import Bridge

# Our main application class
class Calculator():
	# Initiate instance
	def __init__(self, *args, **kwargs):
		super(Calculator, self).__init__(*args, **kwargs)
		# Create Qt Application
		self.app = QApplication([])
		# Create Engine instance and load UI file
		self.engine = QQmlApplicationEngine("UI/Calculator.ui.qml")

		# Create instance of Bridge class
		self.bridge = Bridge()
		# Grab QtContext
		self.context = self.engine.rootContext()
		# Allow bridge to be used inside QML
		self.context.setContextProperty("python", self.bridge)

		# Start UI loop and pass exit code to system when the application quits
		sys.exit(self.app.exec_())

# Create first instance upon main.py run
instance = Calculator()
