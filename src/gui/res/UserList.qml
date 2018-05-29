import QtQuick 2.7
import QtQuick.Controls 2.3
import "fonts/Icon.js" as MdiFont


Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: currently_listening_label.bottom
    anchors.bottom: parent.bottom

    width: parent.width
    z: 0 // below currently_listening_label

    ListModel {
        id: userModel
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
        id: userDelegate

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

                elide: Text.ElideRight
                maximumLineCount: 1
                text: name
            }

            CustomLabel {
                id: user_device
                anchors.top: user_name.bottom
                anchors.left: user_icon.right
                anchors.leftMargin: user_name.anchors.leftMargin

                font.weight: Font.Normal
                font.pixelSize: 12

                text: device
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

        model: userModel
        delegate: userDelegate

        spacing: 3

        ScrollBar.vertical: ScrollBar { id: user_scrollbar }
    }
}
