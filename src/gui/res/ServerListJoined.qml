import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants

Rectangle {
    anchors.top: parent.top
    anchors.topMargin: 2
    anchors.bottom: parent.bottom

    width: (sizeToModel) ? Math.min(((privateModel.count === 0) ? 1 : privateModel.count) * serverDelegateWidth, 0.5 * parent.width) : 0.5 * parent.width
    height: parent.height

    color: parent.color
    clip: true

    CustomLabel {
        anchors.centerIn: parent
        width: parent.width - 5

        font.weight: Font.Normal
        font.pixelSize: 12
        text: "Double-click an entry to join."

        visible: privateModel.count === 0
    }

    property var privateModel: ServerListModel {}
    property bool sizeToModel: false
    property int serverDelegateWidth: 100
    property int iconSize: 15

    Component {
        id: joined_server_delegate

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 3

            width: serverDelegateWidth // constant so that expanding brings more into view
            height: parent.parent.height - joined_server_scrollbar.height - anchors.topMargin
            radius: 4

            color: Qt.lighter(Constants.headerFooterColor, 1.7)

            IconLabel {
                id: joined_server_icon
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
                id: joined_server_name
                anchors.left: joined_server_icon.right
                anchors.top: parent.top
                anchors.topMargin: 1
                horizontalAlignment: Text.AlignLeft

                width: parent.width - joined_server_icon.width

                elide: Text.ElideRight
                maximumLineCount: 1
                text: name

                OverflowToolTip {
                    text: name
                }

            }

            CustomLabel {
                id: joined_server_ip
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
                id: joined_server_people_count
                anchors.bottom: parent.bottom
                anchors.bottomMargin: joined_server_ip.anchors.bottomMargin
                anchors.right: joined_server_people_icon.left
                anchors.rightMargin: 3

                text: numUsers
                font.pixelSize: iconSize - 6
            }

            IconLabel {
                id: joined_server_people_icon
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 5

                text: MdiFont.Icon.accountMultiple

                clickable: false
                font.pixelSize: iconSize
            }

            MouseArea {
                anchors.fill: parent

                onDoubleClicked: {
                    var obj = joined_server_model.get(index)
                    console.log("Disconnected from server: " + obj["name"]);
                    available_server_model.append(obj)
                    joined_server_model.remove(index);
                }
            }
        }
    }

    ListView {
        id: currently_listening_list
        anchors.fill: parent

        model: privateModel

        delegate: joined_server_delegate

        orientation: ListView.Horizontal
        spacing: 3

        ScrollBar.horizontal: ScrollBar {
            id: joined_server_scrollbar
            policy: ScrollBar.AsNeeded
            height: 5
            stepSize: 0.025

            visible: privateModel.count !== 0
        }

        // Event handlers
        Keys.onLeftPressed: {
            joined_server_scrollbar.decrease(0.05)
        }
        Keys.onRightPressed: {
            joined_server_scrollbar.increase(0.05)
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
                    joined_server_scrollbar.decrease();
                else if (wheel.angleDelta.x < 0)
                    joined_server_scrollbar.increase();

                // Up down scrolling with shift
                if (wheel.modifiers & Qt.ShiftModifier) {
                    if (wheel.angleDelta.y > 0)
                        joined_server_scrollbar.decrease();
                    else if (wheel.angleDelta.y < 0)
                        joined_server_scrollbar.increase();
                }
            }
        }
    }
}
