/**
 *  Created by Jack McKernan on 5/8/2018.
 */

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants

Rectangle {
    id: main_container
    anchors.fill: parent
    clip: true

    color: "transparent"
    Material.theme: Material.Dark
    Material.accent: Constants.accentColor

    // TODO: remove; initial model will usually be empty
    Component.onCompleted: {
        joined_server_model.clear();
    }

    Settings {
        id: settings_modal
        visible: false
    }

    ServerSearch {
        id: server_search
        visible: false
    }

    Rectangle {
        id: left_panel
        anchors.top: header.bottom
        anchors.left: parent.left

        width: 0.3 * parent.width
        height: parent.height - header.height - footer.height

        color: Constants.leftPanelColor

        MouseArea {
            id: left_panel_mouse_area
            anchors.fill: parent

            onClicked: {
                parent.focus = true // Switch focus for key events
                console.log("left panel clicked")
            }
        }

        Rectangle {
            id: currently_listening_label
            anchors.top: parent.top
            anchors.left: parent.left

            width: parent.width
            height: 0.08 * parent.height

            color: Constants.leftPanelColor

            CustomLabel {
                id: currently_listening_text
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                height: parent.height

                horizontalAlignment: Text.AlignLeft
                text: "Currently Listening:"
            }

            IconLabel {
                id: currently_listening_icon
                anchors.top: parent.top
                anchors.topMargin: 3
                anchors.right: parent.right
                anchors.rightMargin: 5
                text: MdiFont.Icon.accountMultiple
                clickable: false

                visible: parent.width > (currently_listening_text.width + width + anchors.rightMargin + 2)
            }
        }

        UserList {
            id: active_users
        }

    } // END left_panel

    Rectangle {
        id: right_panel
        anchors.top: header.bottom
        anchors.left: left_panel.right

        width: parent.width - left_panel.width
        height: parent.height - header.height - footer.height

        color: Constants.rightPanelColor

        Button {
            id: center_circle
            anchors.centerIn: parent

            antialiasing: true

            background: Rectangle {
                implicitWidth: Math.min(0.23 * main_container.width, 0.5 * main_container.height)
                implicitHeight: implicitWidth
                radius: implicitWidth * 0.5
                color: Constants.accentColor
            }

            Image {
                id: headphones
                width: center_circle.width - 0.2 * center_circle.width
                height: center_circle.height - 0.2 * center_circle.height
                anchors.verticalCenterOffset: -9

                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                source: "qrc:/images/headphones.svg"

                antialiasing: true
            }

            HoverToolTip {
                text: "Mute"
            }

        } // END center_circle

        // Must come after center_circle
        DropShadow {
            anchors.fill: center_circle
            horizontalOffset: 0
            verticalOffset: 4
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: center_circle
        }

        MouseArea {
            id: right_panel_mouse_area
            anchors.fill: parent

            onClicked: {
                parent.focus = true // Switch focus for key events
                console.log("right panel clicked")
            }
        }

    } // END right_panel

    Rectangle {
        id: header
        anchors.top: parent.top

        width: main_container.width
        height: 55

        color: Constants.headerFooterColor

        ServerListJoined {
            id: joined_server
            anchors.left: parent.left
            sizeToModel: true

            privateModel: ServerListModel {
                id: joined_server_model
            }
        }

        Rectangle {
            id: server_divider
            anchors.top: parent.top
            anchors.left: joined_server.right

            height: parent.height

            color: "transparent"
            z: 2

            Rectangle {
                anchors.centerIn: parent

                width: 3
                height: parent.height - 5
                radius: 4

                color: Qt.lighter(Constants.scrollBarColor, 1.3)
            }

            MouseArea {
                anchors.centerIn: parent
                propagateComposedEvents: true

                // Extend outside parent
                width: parent.width + 5
                height: parent.height + 5

                cursorShape: Qt.SizeHorCursor

                onClicked: {
                    mouse.accepted = false
                }

                onDoubleClicked: {
                    joined_server.width = 0.5 * joined_server.parent.width
                }

                drag{ target: parent; axis: Drag.XAxis }
                onMouseXChanged: {
                    if (drag.active){
                        // Only need to resize joined because available depends on joined
                        joined_server.width = joined_server.width + mouseX / 2

                        var margin = 10
                        // Lock min at 1 delegate
                        if (joined_server.width < joined_server.serverDelegateWidth + margin)
                            joined_server.width = joined_server.serverDelegateWidth + margin

                        // Lock max at 1 delegate
                        if (joined_server.width > joined_server.parent.width - joined_server.serverDelegateWidth - margin)
                            joined_server.width = joined_server.parent.width - joined_server.serverDelegateWidth - margin
                    }
                }
            }
        } // END server_divider

        ServerListAvailable {
            id: available_server
            anchors.left: server_divider.right
            width: parent.width - joined_server.width

            privateModel: ServerListModel {
                id: available_server_model
            }
        }
    }

    Rectangle {
        id: footer
        anchors.bottom: parent.bottom

        width: parent.width
        height: Math.min(0.13 * main_container.height, 0.33 * main_container.width)
        color: Constants.headerFooterColor

        Rectangle {
            id: footer_left_container
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 10

            height: parent.height

            property string currentConnection: "Jack's server"

            CustomLabel {
                id: connected_label
                anchors.left: parent.left

                width: 0.15 * footer.width
                height: parent.height

                property bool hovered: false

                elide: Text.ElideRight
                maximumLineCount: 3
                font.weight: Font.ExtraLight
                horizontalAlignment: Text.AlignLeft
                opacity: 0.85

                text: "<b>Connected to:</b> " + footer_left_container.currentConnection

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        parent.hovered = true
                    }

                    onExited: {
                        parent.hovered = false
                    }
                }

                // Display full name in case of ellipsis
                OverflowToolTip {
                    text: "Connected to:<br>" + footer_left_container.currentConnection
                }
            }

            Button {
                id: footer_disconnect_button
                anchors.left: connected_label.right
                anchors.leftMargin: 3
                anchors.verticalCenter: parent.verticalCenter

                background: IconLabel {
                    //text: MdiFont.Icon.cellphoneLinkOff
                    text: MdiFont.Icon.lanDisconnect
                    hoverColor: Material.color(Material.Red)
                }

                HoverToolTip {
                    text: "Disconnect"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        displayDialog("Woah there...", "Are you sure you want to disconnect?", "Yes", "No");
                    }
                }
            }

        } // END footer_left_container

        Rectangle {
            id: media_controls_container
            anchors.centerIn: parent

            Button {
                id: play_button
                anchors.centerIn: parent

                background: IconLabel {
                    text: MdiFont.Icon.play
                    font.pixelSize: Math.min(0.1 * main_container.height, 0.1 * main_container.width)
                }
            }

            Button {
                id: pause_button
                anchors.centerIn: parent

                visible: false

                background: IconLabel {
                    text: MdiFont.Icon.pause
                    font.pixelSize: Math.min(0.1 * main_container.height, 0.1 * main_container.width)
                }
            }

            Button {
                id: prev_button
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: play_button.left
                anchors.rightMargin: 15

                background: IconLabel {
                    text: MdiFont.Icon.skipPrevious
                    font.pixelSize: Math.min(0.1 * main_container.height, 0.1 * main_container.width)
                }
            }

            Button {
                id: next_button
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: play_button.right
                anchors.leftMargin: 15

                background: IconLabel {
                    text: MdiFont.Icon.skipNext
                    font.pixelSize: Math.min(0.1 * main_container.height, 0.1 * main_container.width)
                }
            }
        } // END media_controls_container

        InputSettings {
            id: input_selector_modal
            parent: parent

            modal: false
            showCloseButton: false
            customDim: false
            blockClicks: false
            z: 0 // level with other elements
        }

        // Modal trigger and volume slider
        Rectangle {
            id: footer_right_container
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 10

            Button {
                id: settings_trigger
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: input_selector_trigger.left
                anchors.rightMargin: 10

                background: IconLabel {
                    text: MdiFont.Icon.settings
                }

                onClicked: {
                    settingsBridge.test()
                    settings_modal.visible = !settings_modal.visible
                }

                HoverToolTip {
                    text: "Settings"
                }
            }

            Button {
                id: input_selector_trigger
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: volume_slider.left
                anchors.rightMargin: 10

                background: IconLabel {
                    text: MdiFont.Icon.microphone
                }

                onClicked: {
                    input_selector_modal.focus = true
                    input_selector_modal.visible = !input_selector_modal.visible
                }

                HoverToolTip {
                    text: "Transmission Settings"
                }
            }

            Slider {
                id: volume_slider
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                width: 0.1 * footer.width

                value: 1.0

                ToolTip {
                    parent: volume_slider.handle
                    visible: volume_slider.pressed
                    text: Math.round(volume_slider.value * 100)
                }
            }

        } // END footer_right_container

    } // END footer

    function displayInfo(message) {
        displayDialog("", message, "OK", "")
    }

    function displayDialog(title, message, button1, button2) {
        customDialog(title, message, button1, button2, Popup.CloseOnEscape | Popup.CloseOnPressOutside)
    }

    function customDialog(title, message, button1, button2, closePolicy) {
        var dialog = Qt.createQmlObject("DefaultDialog {}", main_container)

        if (dialog == null) {
            console.log("Dialog creation failed!")
            return
        }

        dialog.dynamic = true
        dialog.visible = true
        dialog.focus = true
        dialog.title = title
        dialog.message = message
        dialog.closePolicy = closePolicy
        dialog.button1Text = button1
        dialog.button2Text = button2
    }

} // END main_container


