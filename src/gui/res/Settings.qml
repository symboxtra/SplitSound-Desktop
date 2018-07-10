/**
 *  Created by Jack McKernan on 6/2/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.2
import "Constants.js" as Constants

Modal {

    width: parent.width
    height: parent.height

    CustomLabel {
        id: settings_label
        anchors.top: parent.top
        anchors.left: parent.left

        font.weight: Font.Bold
        font.pixelSize: 20

        text: "Settings"
    }

    Rectangle {
        id: settings_container
        anchors.top: settings_label.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 15

        width: parent.width
        height: parent.height - settings_label.height

        color: "transparent"

        Grid {
            id: grid
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 15

            width: 0.3 * parent.width
            height: parent.height

            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter

            columns: 1
            spacing: 2

            visible: false

            CustomLabel {
                text: "hello"
            }

            CustomLabel {
                text: "world"
            }

        }

        Column {
            id: label_column
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 15

            width: parent.width
            height: parent.height

            spacing: 2

            CustomLabel {
                font.weight: Font.DemiBold
                text: "General"
            }

            SettingsRow {

                CustomLabel {
                    font.weight: Font.Normal
                    text: "Scan for servers at startup:"
                }

                Switch {
                    checked: true
                }

                CustomLabel {
                    text: "newline"
                }
            }

        } // END label_column
    } // END settings_container
}
