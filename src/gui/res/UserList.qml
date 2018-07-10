/**
 *  Created by Jack McKernan on 5/28/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.3
import "fonts/Icon.js" as MdiFont


Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: currently_listening_label.bottom
    anchors.bottom: parent.bottom

    width: parent.width
    clip: true

    ListModel {
        id: user_model
        ListElement {
            name: "Neel"
            device: "Nexus 6P"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Emanuel"
            device: "OnePlus 69"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Charlene"
            device: "Char *'s iPhone"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Davis"
            device: "MacOS"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Jack"
            device: "Pixel"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Aneesh"
            device: "Eclipse"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Neel"
            device: "Nexus 6P"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Emanuel"
            device: "OnePlus 69"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Charlene"
            device: "Char *'s iPhone"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Davis"
            device: "MacOS"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Jack"
            device: "Pixel"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Aneesh"
            device: "Eclipse"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Neel"
            device: "Nexus 6P"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Emanuel"
            device: "OnePlus 69"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Charlene"
            device: "Char *'s iPhone"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Davis"
            device: "MacOS"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Jack"
            device: "Pixel"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Aneesh"
            device: "Eclipse"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Neel"
            device: "Nexus 6P"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Emanuel"
            device: "OnePlus 69"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Charlene"
            device: "Char *'s iPhone"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Davis"
            device: "MacOS"
            muted: false
            isAdmin: true
        }
        ListElement {
            name: "Jack"
            device: "Pixel"
            muted: true
            isAdmin: true
        }
        ListElement {
            name: "Aneesh"
            device: "Eclipse"
            muted: false
            isAdmin: true
        }
    }

    Component {
        id: user_delegate

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10

            width: parent.parent.width
            height: 0.12 * parent.parent.height

            color: "transparent"

            IconLabel {
                id: user_icon
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 2

                text: (muted) ? MdiFont.Icon.volumeOff : MdiFont.Icon.volumeHigh

                clickable: false
            }

            CustomLabel {
                id: user_name
                anchors.left: user_icon.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft

                width: parent.width - user_icon.width - user_triple_dot.width - user_scrollbar.width

                elide: Text.ElideRight
                maximumLineCount: 1
                text: name

                OverflowToolTip {
                    text: name
                }
            }

            CustomLabel {
                id: user_device
                anchors.top: user_name.bottom
                anchors.left: user_icon.right
                anchors.leftMargin: user_name.anchors.leftMargin
                horizontalAlignment: Text.AlignLeft

                width: parent.width - user_icon.width - user_triple_dot.width - user_scrollbar.width

                font.weight: Font.Normal
                font.pixelSize: 12
                elide: Text.ElideRight
                maximumLineCount: 1

                text: device

                OverflowToolTip {
                    text: device
                }
            }

            IconLabel {
                id: user_triple_dot
                anchors.right: parent.right
                anchors.rightMargin: user_scrollbar.width
                anchors.verticalCenter: parent.verticalCenter

                text: MdiFont.Icon.dotsVertical
            }
        }
    }

    ListView {
        id: currently_listening_list
        anchors.fill: parent

        model: user_model
        delegate: user_delegate

        spacing: 4

        ScrollBar.vertical: ScrollBar {
            id: user_scrollbar
            width: 10
            stepSize: 0.025
        }

        Keys.onUpPressed: {
            user_scrollbar.decrease(0.05);
        }
        Keys.onDownPressed: {
            user_scrollbar.increase(0.05);
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                parent.focus = true;
            }
        }
    }
}
