import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.1


ApplicationWindow {
    id: window
    Material.theme: Material.Dark
    visible: true
    color: "#0d1d1a"
    width: 600
    height: 430
    

    // Function to handle appending numbers
    function append_number(num){
        if (input.text.slice(input.text.length-1).match(/[^\(\+\-\/*\^\d]/g)) {
            // If last character is not an operand or a digit, add * (multiply) before number
            input.text += "*"+num;
        } else {
            input.text += num;
        }
    }

    // Function to handle appending constants
    function append_constant(constant){
        if (input.text.slice(input.text.length-1).match(/[^\(\+\-\/*\^]/g)) {
            // If last character is not an operand, add * (multiply) before number
            input.text += "*"+constant;
        } else {
            input.text += constant;
        }
    }
    
    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { 
                text: qsTr("&New Window...") 
                onTriggered: {
                    // Create new object out of this file and show it
                    var component = Qt.createComponent("Calculator.ui.qml")
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

    Rectangle {
        id: background
        width: 600
        height: 430
        color: "#0d1d1a"

        // Main calculator text input area
        TextInput {
            id: input
            x: 8
            y: 8
            width: 584
            height: 54
            focus: true
            color: "#85ebd3"
            text: ""
            //textFormat: Text.PlainText
            selectByMouse: true
            clip: true
            enabled: true
            transformOrigin: Item.Left
            antialiasing: true
            cursorVisible: false
            font.pointSize: 32
            font.family: "Arial"
            wrapMode: TextEdit.WordWrap
            maximumLength: 100
            onAccepted: {
                // Trigger calculate, replacing e constant with big E and % with /100 for the parser
                input.text = python.calculate(input.text.replace(/e/g, "E").replace(/%/g, "/100"))
            }
        }

        Row {
            id: first_row
            x: 8
            y: 80
            width: 584
            height: 56
            spacing: 26

            Rectangle {
                id: abs_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.addfunction(input.text, "abs");
                    }
                }

                Text {
                    id: abs_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("| |")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: factorial_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("!");
                    }
                }

                Text {
                    id: factorial_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("!")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: convert_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var component = Qt.createComponent("Unit_Converter.ui.qml")
                        var unit_converter_window   = component.createObject(window)
                        unit_converter_window.show()
                    }
                }

                Image {
                    id: convert_image
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    antialiasing: true
                    fillMode: Image.PreserveAspectFit
                    source: "../assets/images/convert.png"
                }
            }

            Rectangle {
                id: seven_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("7");
                    }
                }

                Text {
                    id: seven_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("7")
                    font.pointSize: 21
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: eight_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("8");
                    }
                }

                Text {
                    id: eight_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("8")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: nine_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("9");
                    }
                }

                Text {
                    id: nine_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("9")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: remove_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text = input.text.slice(0, -1)
                    }
                }

                Image {
                    id: remove_image
                    x: 4
                    y: 4
                    width: 53
                    height: 48
                    fillMode: Image.PreserveAspectFit
                    source: "../assets/images/remove.png"
                }
            }
        }

        Row {
            id: second_row
            x: 8
            y: 150
            width: 584
            height: 56
            spacing: 26

            Rectangle {
                id: power_two_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text += "^2"
                    }
                }

                Text {
                    id: power_two_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("x²")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: square_root_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.addfunction(input.text, "sqrt");
                    }
                }
                
                Text {
                    id: square_root_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("√")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: sin_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.addfunction(input.text, "sin");
                    }
                }

                Text {
                    id: sin_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("sin")
                    font.bold: true
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: four_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("4");
                    }
                }

                Text {
                    id: four_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("4")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: five_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("5");
                    }
                }

                Text {
                    id: five_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("5")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: six_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("6");
                    }
                }

                Text {
                    id: six_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("6")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: plus_rectangle
                width: 61
                height: 56
                color: "#ac047e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text += "+"
                    }
                }

                Text {
                    id: plus_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("+")
                    font.bold: true
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Row {
            id: third_row
            x: 8
            y: 220
            width: 584
            height: 56
            spacing: 26

            Rectangle {
                id: pi_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_constant("pi");
                    }
                }

                Text {
                    id: pi_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("π")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: percentage_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text += "%"
                    }
                }

                Text {
                    id: percentage_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("%")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: cos_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.addfunction(input.text, "cos");
                    }
                }

                Text {
                    id: cos_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("cos")
                    font.bold: true
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: one_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("1");
                    }
                }

                Text {
                    id: one_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("1")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: two_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("2");
                    }
                }

                Text {
                    id: two_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("2")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: three_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("3");
                    }
                }

                Text {
                    id: three_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("3")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: minus_rectangle
                width: 61
                height: 56
                color: "#ac047e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text += "-"
                    }
                }

                Text {
                    id: minus_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("-")
                    font.bold: true
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Row {
            id: fourth_row
            x: 8
            y: 290
            width: 584
            height: 56
            spacing: 26

            Rectangle {
                id: log_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.addfunction(input.text, "log");
                    }
                }

                Text {
                    id: log_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("log")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: ln_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.addfunction(input.text, "ln");
                    }
                }

                Text {
                    id: ln_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("ln")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: tan_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.addfunction(input.text, "tan");
                    }
                }

                Text {
                    id: tan_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("tan")
                    font.bold: true
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: dot_rectangle
                width: 61
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text += "."
                    }
                }

                Text {
                    id: dot_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: qsTr(".")
                    font.pointSize: 21
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: zero_rectangle
                width: 148
                height: 56
                color: "#1d342e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_number("0")
                    }
                }

                Text {
                    id: zero_text
                    x: 0
                    y: 0
                    width: 148
                    height: 56
                    color: "#87dcc9"
                    text: qsTr("0")
                    font.pointSize: 21
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: multiply_rectangle
                width: 61
                height: 56
                color: "#ac047e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text += "*"
                    }
                }
                Text {
                    id: multiply_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: "\u00d7"
                    font.bold: true
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Row {
            id: fifth_row
            x: 8
            y: 360
            width: 584
            height: 56
            spacing: 26

            Rectangle {
                id: e_power_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_constant("e^");
                    }
                }

                Text {
                    id: e_power_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("ℯ<sup>x</sup>")
                    textFormat: Text.RichText
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: e_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        append_constant("e");
                    }
                }

                Text {
                    id: e_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("ℯ")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 14
                }
            }

            Rectangle {
                id: angle_mode_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (angle_mode_text.text == "DEGREE") {
                            angle_mode_text.text = "RADIAN"
                            python.set_angle_mode("RADIAN")
                        } else {
                            angle_mode_text.text = "DEGREE"
                            python.set_angle_mode("DEGREE")
                        }
                    }
                }

                Text {
                    id: angle_mode_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: "DEGREE"
                    font.bold: true
                    font.pointSize: 8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: clear_rectangle
                width: 61
                height: 56
                color: "#a8b2b1"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text = ""
                    }
                }

                Text {
                    id: clear_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    text: qsTr("C")
                    font.pointSize: 21
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: equal_rectangle
                width: 148
                height: 56
                color: "#ac047e"
                radius: 5
                border.color: "#00000000"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        input.text = python.calculate(input.text.replace(/e/g, "E").replace(/%/g, "/100"))
                    }
                }

                Text {
                    id: equal_text
                    x: 0
                    y: -1
                    width: 148
                    height: 56
                    color: "#87dcc9"
                    text: "="
                    font.pointSize: 21
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: divide_rectangle
                width: 61
                height: 56
                color: "#ac047e"
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { 
                        input.text += "/"
                    }
                }

                Text {
                    id: divide_text
                    x: 0
                    y: 0
                    width: 61
                    height: 56
                    color: "#87dcc9"
                    text: "\u00f7"
                    font.bold: true
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}