import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants

Rectangle {
    anchors.top: parent.top
    anchors.topMargin: 2
    anchors.bottom: parent.bottom

    width: (sizeToModel) ? Math.min(((server_model.count === 0) ? 1 : server_model.count) * serverDelegateWidth, 0.5 * parent.width) : 0.5 * parent.width
    height: parent.height

    CustomLabel {
        anchors.centerIn: parent
        width: parent.width - 5

        font.weight: Font.Normal
        font.pixelSize: 12
        text: "Double-click an entry to join."

        visible: server_model.count === 0
    }

    color: parent.color

    property bool sizeToModel: false
    property int serverDelegateWidth: 100
    property int iconSize: 15



    Component {
        id: server_delegate

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 3

            width: serverDelegateWidth // constant so that expanding brings more into view
            height: parent.parent.height - server_scrollbar.height - anchors.topMargin
            radius: 4

            color: Qt.lighter(Constants.headerFooterColor, 1.7)

            IconLabel {
                id: server_icon
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
                font.pixelSize: iconSize - 6
            }

            IconLabel {
                id: server_people_icon
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
                    console.log("Index: " + index)
                    server_model.remove(index) // TODO: removes from wrong one right now
                }
            }
        }
    }

    ListView {
        id: currently_listening_list
        anchors.fill: parent

        model: ServerListModel {
            id: server_model
        }

        delegate: server_delegate

        orientation: ListView.Horizontal
        spacing: 3

        ScrollBar.horizontal: ScrollBar {
            id: server_scrollbar
            policy: ScrollBar.AlwaysOn
            height: 8
            stepSize: 0.025

            visible: server_model.count !== 0
        }

        // Event handlers
        Keys.onLeftPressed: {
            server_scrollbar.decrease(0.05)
        }
        Keys.onRightPressed: {
            server_scrollbar.increase(0.05)
        }

        Keys.onEscapePressed: {
            server_model.clear()
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

                console.log(server_model.count)
                console.log(server_delegate.width)

                // Left right scrolling (use trackpad to test)
                if (wheel.angleDelta.x > 0)
                    server_scrollbar.decrease();
                else if (wheel.angleDelta.x < 0)
                    server_scrollbar.increase();

                // Up down scrolling with shift
                if (wheel.modifiers & Qt.ShiftModifier) {
                    if (wheel.angleDelta.y > 0)
                        server_scrollbar.decrease();
                    else if (wheel.angleDelta.y < 0)
                        server_scrollbar.increase();
                }
            }
        }
    }
}
