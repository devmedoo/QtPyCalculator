from PySide2.QtCore import QObject, Slot, Property
from sympy import *
from re import sub, search
import xml.etree.ElementTree as ET
import requests

class Bridge(QObject):
	"""
		A bridge class to be used by the QML files to interact with Python
	"""

	root = str()
	
	@Property('QVariantList')
	def units(self):
		"""
			Units QVariantList property to be used by QML
		"""
		return self.m_units
	
	@units.setter
	def set_units(self, val):
		"""
			Units setter
		"""
		if self.m_units == val:
			return
		self.m_units = val[:]
	
	@Property('QVariant')
	def currency_data(self):
		"""
			Currency_Data QVariant property to be used by QML
		"""
		return self.m_currency
	
	@currency_data.setter
	def set_currency_data(self, val):
		"""
			Currency_Data setter
		"""
		self.m_currency = val

	def __init__(self, parent=None):
		# QMLObject REQUIRED Init
		QObject.__init__(self, parent)

		# Grab and parse units from data XML file
		tree = ET.parse('assets/data/units.xml')
		# Set root property to root object from the parsed units file
		self.root = tree.getroot()
		# Set list-typed units
		self.m_units = []
		# Set dict-typed currency_data
		self.m_currency = dict()

	# Angle mode ("DEGREE" or "RADIAN")
	angle_mode = "DEGREE"

	@Slot(result=str)
	def get_angle_mode(self):
		"""
			angle_mode getter
		"""
		return self.angle_mode
	
	@Slot(str)
	def set_angle_mode(self, new_mode):
		"""
			angle_mode setter
		"""
		self.angle_mode = new_mode

	@Slot(str, result=str)
	def calculate(self, user_input):
		"""
			Main calculation function that is triggered by return/enter and = buttons.
		"""
		if self.angle_mode == "DEGREE":
			# convert to radians for sympify if calculator angle mode was set to degree
			user_input = self.convert_trig_to_degrees(user_input)
		# Declare and initialize result as an empty string
		result = str()
		try:
			# Calculate the simple expression
			expr = sympify(user_input)
			result = str(float(expr.evalf()))
		except:
			try:
				# In case built-in functions (e.g: abs) were used, eval them
				result = str(float(eval(str(expr.evalf()))))
			except:
				# In case the result is a complex number
				try:
					result = str(eval(str(expr.evalf())))
				except TypeError and NameError:
					# Display error
					result = "MATH ERROR"
		return result
	
	@Slot(str, result=str)
	def convert_trig_to_degrees(self,user_input):
		"""
		A function to convert trignometric functions paramters from degrees to radians.
		Uses regular expressions (with look ahead and look behind) to convert degrees to radian during internal calculation.
		"""
		return sub("(?<=sin\(|tan\(|cos\()(\d+)(?=\))", r"(\1*(pi/180))", user_input)
	
	@Slot(str, str, result=str)
	def addfunction(self, user_input, func):
		"""
		A function to handle appending mathematical functions to user input.
		Uses regular expressions (with look ahead).
		"""
		if search(r"(?<=\()\w+(?![\+\-\*\^\/])$", user_input):
			# Use negative look ahead to detect if math function should be ended
			user_input += ")"
		else:
			if search(r"[^\(\+\-\/*\^\(]$", user_input):
				# Detect if last character is not an operand and append user input with * (multiply) before function if so
				user_input += "*"+func+"("
			else:
				# Otherwise, just append user input with the function with its opening bracket
				user_input += func+"("
		return user_input
	
	@Slot(str)
	def grab_unit_list(self, measure):
		"""
		A function to grab units list by measure from the loaded XML data to the property units to be used by QML
		"""
		units = []
		# Find all children tags (units) under specified parent tag (measure)
		for unit in self.root.findall(".//*[@name='"+measure+"']/unit"):
			name = unit.get('name')
			value = unit.text
			eq = unit.get('equation') or False
			units.append([name, value, eq])
		# Set units property to the extracted units
		self.units = units

	@Slot(result=bool)
	def grab_currency_list(self):
		"""
		A function to grab latest live currency exchange rates from the internet
		"""
		url = "https://api.exchangeratesapi.io/latest"
		try:
			response = requests.get(url=url)
			currency_data = response.json()
			units = []
			for key, value in currency_data['rates'].items():
				units.append([str(key),str("{:.2}".format(float(1/value))),False])
			self.units = units
			print(self.units)
			return response.ok
		except:
			return False

	@Slot(int, float, int, result=str)
	def convert(self, active_unit_index, active_unit_input, secondary_unit_index):
		"""
		A function to execute conversion equation using sympy library for precision
		"""
		active_unit = self.units[active_unit_index]
		active_unit_data = active_unit[1]
		active_unit_equation = active_unit[2]

		secondary_unit = self.units[secondary_unit_index]
		secondary_unit_data = secondary_unit[1]
		secondary_unit_equation = secondary_unit[2]


		if active_unit_equation is False and secondary_unit_equation is False:
			return sub("(\.|0)0+$", "", str(sympify(str(active_unit_data) + "*" + str(active_unit_input) + "/" + str(secondary_unit_data)).evalf()))
		else:
			x = symbols('x')
			try: 
				sympy_expression = sympify("Eq("+ str(active_unit_input) +", "+ active_unit_data +")")
				sympy_solve = solve(sympy_expression)
				if type(sympy_solve) == list:
					sympy_solve = sympy_solve[0]
				active_unit_inverse_data = sub("y", str(active_unit_input), str(sympy_solve))
				return sub("(\.|0)0+$", "", str(sympify(str(secondary_unit_data)).evalf(subs={x: active_unit_inverse_data})))
			except:
				print('Error')
				return "0"