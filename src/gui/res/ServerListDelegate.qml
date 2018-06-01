import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants

Component {
    id: server_delegate

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 3

        width: parent.parent.serverDelegateWidth // constant so that expanding brings more into view
        height: parent.parent.height - parent.parent.server_scrollbar.height - anchors.topMargin
        radius: 4

        color: Qt.lighter(Constants.headerFooterColor, 1.7)

        IconLabel {
            id: server_icon
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 2

            text: (locked) ? MdiFont.Icon.lock : MdiFont.Icon.lockOpen

            clickable: false
            font.pixelSize: parent.parent.iconSize

            OverflowToolTip {
                showOnlyOnClip: false
                text: (locked) ? "Locked" : "Unlocked"
            }
        }

        CustomLabel {
            id: server_name
            anchors.left: server_icon.right
            anchors.top: parent.top
            anchors.topMargin: 1
            horizontalAlignment: Text.AlignLeft

            width: parent.width - server_icon.width

            elide: Text.ElideRight
            maximumLineCount: 1
            text: name

            OverflowToolTip {
                text: name
            }

        }

        CustomLabel {
            id: server_ip
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 2

            font.weight: Font.Normal
            font.pixelSize: 9

            visible: true

            text: ip
        }

        CustomLabel {
            id: server_people_count
            anchors.bottom: parent.bottom
            anchors.bottomMargin: server_ip.anchors.bottomMargin
            anchors.right: server_people_icon.left
            anchors.rightMargin: 3

            text: numUsers
            font.pixelSize: parent.parent.iconSize - 6
        }

        IconLabel {
            id: server_people_icon
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 5

            text: MdiFont.Icon.accountMultiple

            clickable: false
            font.pixelSize: parent.parent.iconSize
        }

        MouseArea {
            anchors.fill: parent

            onDoubleClicked: {
                console.log("Index: " + index)
                console.log(test.sizeToModel);
                test.privateModel.remove(index) // TODO: removes from wrong one right now
            }
        }
    }
}
