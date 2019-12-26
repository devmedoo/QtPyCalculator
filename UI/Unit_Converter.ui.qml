import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.3

ApplicationWindow {
	id: unit_converter_window
	visible: true
	color: "#0d1d1a"
	width: 600
	height: 430
	
	menuBar: MenuBar {
		Menu {
			title: qsTr("&File")
			Action { 
				text: qsTr("&New Window...") 
				onTriggered: {
					// Create new object out of this file and show it
					var component = Qt.createComponent("Unit_Converter.ui.qml")
					var window    = component.createObject(window)
					window.show()
				}
			}
			MenuSeparator { }
			Action {
				id: quit
				text: qsTr("&Quit")
				onTriggered: {
					window.close()
				}
			}
		}
		Menu {
			title: qsTr("&Help")
			Action { 
				text: qsTr("&About")
				onTriggered: {
					// Create new object out of About UI file and show it
					var component = Qt.createComponent("About.ui.qml")
					var about_window   = component.createObject(window)
					about_window.show()
				}
			}
		}
	}

	function selectCurrencyMeasure(){
		let request_currency_list = python.grab_currency_list()
		if (request_currency_list != false) {
			// Yay
			measure_text.text = "currency";
			measure_image.source = "../assets/images/currency.svg";
			let unit_names = python.units.map(function(tuple){
				return tuple[0];
			});
			first_unit.model = unit_names;
			second_unit.model = unit_names;
			main_units_grid.visible = false;
			unit_background.visible = true;
			
		} else {
			// Nay
			internetDialog.visible = true
		}
	}

	function selectMeasure(measure) {
		if (measure == "currency") {
			selectCurrencyMeasure()
			return;
		}
		python.grab_unit_list(measure);
		measure_text.text = measure;
		measure_image.source = "../assets/images/"+measure+'.svg';
		let unit_names = python.units.map(function(tuple){
			return tuple[0];
		});
		first_unit.model = unit_names;
		second_unit.model = unit_names;
		main_units_grid.visible = false;
		unit_background.visible = true;
	}

	function convert_units(unitChanged){
		let first_unit_data = python.units[first_unit.currentIndex];
		let second_unit_data = python.units[second_unit.currentIndex];
		if (unitChanged == 1) {
			if(measure_text.text == "currency"){
				second_edit.text = (parseFloat(python.convert(first_unit.currentIndex, first_edit.text, second_unit.currentIndex)).toFixed(2)).toString()
			} else {
				second_edit.text = python.convert(first_unit.currentIndex, first_edit.text, second_unit.currentIndex)
			}
		} else if (unitChanged == 2) {
			if(measure_text.text == "currency"){
				first_edit.text =  (parseFloat(python.convert(second_unit.currentIndex, second_edit.text, first_unit.currentIndex)).toFixed(2)).toString()
			} else {
				first_edit.text =  python.convert(second_unit.currentIndex, second_edit.text, first_unit.currentIndex)
			}
		}
		
	}

	
	MessageDialog {
        id: internetDialog
        title: "Error"
        text: "You need to have a functioning internet connection in order to use the currency converter!"
		icon: StandardIcon.Critical
    }

	Rectangle {
		id: background
		width: 600
		height: 430
		color: "#0d1d1a"

		Rectangle {
			id: unit_background
			width: 600
			height: 430
			color: "#0d1d1a"
			visible: false
			
			ComboBox {
				id: first_unit
				x: 113
				y: 127
				width: 375
				height: 48
				editable: false
				onActivated: {
					convert_units(1)
				}
			}
			
			TextInput {
				id: first_edit
				x: 113
				y: 197
				width: 375
				height: 36
				color: "#87dcc9"
				text: "0"
				font.pointSize: 15
				horizontalAlignment: Text.AlignHCenter
				selectByMouse: true
				wrapMode: TextEdit.WordWrap
				clip: true
				onTextEdited: {
					convert_units(1)
				}
			}
			
			Rectangle {
				id: rectangle
				x: 565
				y: 0
				width: 35
				height: 35
				color: "#36808080"
				
				MouseArea {
					anchors.fill: parent
					onClicked: {
						unit_background.visible = false
						first_edit.text = "0"
						second_edit.text = "0"
						main_units_grid.visible = true
					}
				}

				Text {
					id: element
					x: 0
					y: 0
					width: 35
					height: 35
					color: "#c5d2be"
					text: qsTr("X")
					verticalAlignment: Text.AlignVCenter
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}
			}
			
			ComboBox {
				id: second_unit
				x: 113
				y: 272
				width: 375
				height: 48
				editable: false
				onActivated: {
					convert_units(1)
				}
			}
			
			TextInput {
				id: second_edit
				x: 113
				y: 342
				width: 375
				height: 36
				color: "#87dcc9"
				text: "0"
				font.pointSize: 15
				horizontalAlignment: Text.AlignHCenter
				selectByMouse: true
				wrapMode: TextEdit.WordWrap
				clip: true
				onTextEdited: {
					convert_units(2)
				}
			}
			
			Text {
				id: measure_text
				x: 213
				y: 0
				width: 174
				height: 42
				color: "#87dcc9"
				text: qsTr("LENGTH")
				font.bold: true
				font.pointSize: 13
				font.family: "Tahoma"
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignHCenter
				
				Image {
					id: measure_image
					x: 53
					y: 42
					width: 69
					height: 56
					source: "../assets/images/length.svg"
					fillMode: Image.PreserveAspectFit
				}
				ColorOverlay {
					anchors.fill: measure_image
					source: measure_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}
		}


		Grid {
			id: main_units_grid
			x: 16
			y: 16
			width: 576
			height: 406
			spacing: 40

			Rectangle {
				id: length_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("length")
					}
				}

				Text {
					id: length_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Length")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: length_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/length.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: length_image
					source: length_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}

			Rectangle {
				id: area_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("area")
					}
				}

				Text {
					id: area_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Area")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: area_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/area.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: area_image
					source: area_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}

			Rectangle {
				id: volume_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("volume")
					}
				}

				Text {
					id: volume_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Volume")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: volume_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/volume.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: volume_image
					source: volume_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}

			Rectangle {
				id: weight_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("weight")
					}
				}

				Text {
					id: weight_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Weight")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: weight_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/weight.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: weight_image
					source: weight_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}

			Rectangle {
				id: speed_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("speed")
					}
				}

				Text {
					id: speed_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Speed")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: speed_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/speed.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: speed_image
					source: speed_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}

			Rectangle {
				id: temperature_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("temperature")
					}
				}

				Text {
					id: temperature_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Temperature")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: temperature_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/temperature.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: temperature_image
					source: temperature_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}

			Rectangle {
				id: currency_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("currency")
					}
				}

				Text {
					id: currency_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Currency")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: currency_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/currency.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: currency_image
					source: currency_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}

			Rectangle {
				id: fuel_rectangle
				width: 111
				height: 99
				color: "#1d342e"
				radius: 5

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selectMeasure("fuel")
					}
				}

				Text {
					id: fuel_text
					x: 0
					y: 80
					width: 111
					height: 19
					color: "#87dcc9"
					text: qsTr("Fuel-Milage")
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}

				Image {
					id: fuel_image
					x: 0
					y: 8
					width: 111
					height: 66
					source: "../assets/images/fuel.svg"
					anchors.centerIn: parent
					fillMode: Image.PreserveAspectFit
					antialiasing: true
					visible: false
				}

				ColorOverlay {
					anchors.fill: fuel_image
					source: fuel_image
					color: "#87dcc9"
					anchors.rightMargin: 0
					anchors.bottomMargin: 10
					anchors.leftMargin: 0
					anchors.topMargin: -10
					transform: rotation
					antialiasing: true
				}
			}
		}
	}
}