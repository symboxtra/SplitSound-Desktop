/**
 *  Created by Jack McKernan on 5/31/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants

Rectangle {
    anchors.top: parent.top
    anchors.topMargin: 2
    anchors.bottom: parent.bottom
    anchors.leftMargin: 4

    width: 0.5 * parent.width
    height: parent.height

    color: parent.color
    clip: true

    CustomLabel {
        anchors.centerIn: parent
        width: parent.width - 5

        font.weight: Font.Normal
        font.pixelSize: 12
        text: "No available servers."

        visible: privateModel.count === 0
    }

    property var privateModel: ServerListModel {}
    property int serverDelegateWidth: Constants.serverDelegateWidth
    property int iconSize: 15

    Component {
        id: available_server_delegate

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 3

            width: serverDelegateWidth // constant so that expanding brings more into view
            height: parent.parent.height - available_server_scrollbar.height - anchors.topMargin
            radius: 4

            color: Qt.lighter(Constants.headerFooterColor, 1.7)

            IconLabel {
                id: available_server_icon
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 2

                text: (locked) ? MdiFont.Icon.lock : MdiFont.Icon.lockOpen

                clickable: false
                font.pixelSize: iconSize

                OverflowToolTip {
                    showOnlyOnClip: false
                    text: (locked) ? "Locked" : "Unlocked"
                }
            }

            CustomLabel {
                id: available_server_name
                anchors.left: available_server_icon.right
                anchors.top: parent.top
                anchors.topMargin: 1
                horizontalAlignment: Text.AlignLeft

                width: parent.width - available_server_icon.width

                elide: Text.ElideRight
                maximumLineCount: 1
                text: name

                OverflowToolTip {
                    text: name
                }

            }

            CustomLabel {
                id: available_server_ip
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 2
                anchors.left: parent.left
                anchors.leftMargin: 2

                width: parent.width - available_server_people_container.width
                horizontalAlignment: Text.AlignLeft

                font.weight: Font.Normal
                font.pixelSize: 9

                visible: true
                elide: Text.ElideRight

                text: ip

                OverflowToolTip {
                    text: ip
                }
            }

            Rectangle {
                id: available_server_people_container
                anchors.top: available_server_name.bottom
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 5

                width: available_server_people_count.width + available_server_people_icon.width + 7

                color: parent.color

                CustomLabel {
                    id: available_server_people_count
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: available_server_ip.anchors.bottomMargin
                    anchors.right: available_server_people_icon.left
                    anchors.rightMargin: 3

                    text: numUsers
                    font.pixelSize: iconSize - 6
                }

                IconLabel {
                    id: available_server_people_icon
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    text: MdiFont.Icon.accountMultiple

                    clickable: false
                    font.pixelSize: iconSize
                }
            }

            MouseArea {
                anchors.fill: parent

                onDoubleClicked: {
                    var obj = available_server_model.get(index)
                    console.log("Connected to server: " + obj["name"])
                    joined_server_model.insert(0, obj);
                    available_server_model.remove(index)
                }
            }
        }
    }

    ListView {
        id: currently_listening_list
        anchors.fill: parent

        model: privateModel

        delegate: available_server_delegate

        orientation: ListView.Horizontal
        spacing: 3

        ScrollBar.horizontal: ScrollBar {
            id: available_server_scrollbar
            policy: ScrollBar.AsNeeded
            height: 5
            stepSize: 0.025

            visible: privateModel.count !== 0
        }

        // Event handlers
        Keys.onLeftPressed: {
            available_server_scrollbar.decrease(0.05)
        }
        Keys.onRightPressed: {
            available_server_scrollbar.increase(0.05)
        }

        // Shift scrolling
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true

            onClicked: {
                parent.focus = true
                mouse.accepted = false
            }

            onWheel: {

                // Left right scrolling (use trackpad to test)
                if (wheel.angleDelta.x > 0)
                    available_server_scrollbar.decrease();
                else if (wheel.angleDelta.x < 0)
                    available_server_scrollbar.increase();

                // Up down scrolling with shift
                if (wheel.modifiers & Qt.ShiftModifier) {
                    if (wheel.angleDelta.y > 0)
                        available_server_scrollbar.decrease();
                    else if (wheel.angleDelta.y < 0)
                        available_server_scrollbar.increase();
                }
            }
        }
    }
}
