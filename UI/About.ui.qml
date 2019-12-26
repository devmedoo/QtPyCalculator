import QtQuick 2.12
import QtQuick.Controls 2.3


ApplicationWindow {
    id: about_window
    visible: true
    color: "#0d1d1a"
    width: 400
    height: 200
    Rectangle {
        width: 400
        height: 200
        color: "#2d2b2b"

        Text {
            id: kawaii_emoji
            x: 163
            y: 9
            color: "#f0d4d4"
            text: qsTr("(づ｡◕‿‿◕｡)づ")
            font.pixelSize: 12
        }

        Text {
            id: application_name
            x: 155
            y: 36
            color: "#f1f1e1"
            text: qsTr("QtPyCalculator")
            font.pixelSize: 12
        }

        Text {
            id: application_description
            x: 8
            y: 63
            width: 384
            height: 37
            color: "#f1f1e1"
            text: qsTr("A cutie pie calculator made using Qt and Python as a school project.")
            wrapMode: Text.WordWrap
            font.pixelSize: 12
        }

        Text {
            id: application_date
            x: 324
            y: 173
            width: 68
            height: 19
            color: "#f1f1e1"
            text: qsTr("2019")
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 12
        }

        Text {
            id: application_author
            x: 288
            y: 157
            color: "#f1f1e1"
            text: qsTr("Mohamed Wageh")
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 12
        }

        Text {
            id: application_license
            x: 8
            y: 130
            width: 384
            height: 21
            color: "#f1f1e1"
            text: qsTr("It's open source and licensed under GPLv3.")
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 12
        }

        Rectangle {
            id: close_rectangle
            x: 371
            y: 0
            width: 29
            height: 29
            color: "#73646464"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    about_window.close()
                }
            }

            Text {
                id: close_text
                x: 0
                y: 0
                width: 29
                height: 29
                color: "#dfcfcf"
                text: qsTr("X")
                font.family: "Arial"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
            }
        }
    }
}