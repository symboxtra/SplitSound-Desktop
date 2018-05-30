import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants


Rectangle {
    id: main_container
    anchors.fill: parent

    color: "transparent"
    Material.theme: Material.Dark
    Material.accent: Constants.accentColor

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
                closeModals()
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
            z: 2

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
                closeModals()
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

        ServerList {
            id: joined_servers
            anchors.left: parent.left
            sizeToModel: true
            z: 1
        }

        Rectangle {
            id: server_divider
            anchors.top: parent.top
            anchors.left: joined_servers.right

            height: parent.height

            color: "transparent"
            z: 2

            Rectangle {
                anchors.centerIn: parent

                width: 3
                height: parent.height
                radius: 4
            }
        }

        ServerList {
            id: available_servers
            anchors.left: server_divider.right
            width: parent.width - joined_servers.width

            z: 0
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
                    text: MdiFont.Icon.cellphoneLinkOff
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

        Modal {
            id: input_selector_modal
            anchors.centerIn: undefined // Override default centering
            anchors.right: footer.right
            anchors.rightMargin: volume_slider.width - 25
            anchors.bottom: footer.top
            anchors.bottomMargin: 1

            width: 0.4 * main_container.width
            height: 0.5 * main_container.height

            message: "" // Override warning message
            showCloseButton: false

            // Must be before other clickable elements (z-index lower)
            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true // Allow clicks to propogate
            }

            CustomLabel {
                id: input_selector_combo_label
                anchors.left: input_selector_modal.left
                anchors.leftMargin: 5
                anchors.verticalCenter: input_selector_combo.verticalCenter

                text: "Input: "
            }

            ComboBox {
                id: input_selector_combo
                anchors.left: input_selector_combo_label.right

                width: parent.width - input_selector_combo_label.width - 10

                HoverToolTip {
                    text: "Select the device you would like to share"
                }
            }

            CustomLabel {
                id: input_selector_muted_label
                anchors.left: input_selector_modal.left
                anchors.leftMargin: 5
                anchors.verticalCenter: input_selector_muted_check.verticalCenter

                text: "Transmit: "
            }

            CheckBox {
                id: input_selector_muted_check
                anchors.left: input_selector_muted_label.right
                anchors.top: input_selector_combo.bottom

                HoverToolTip {
                    text: "Enable transmission to other devices"
                }
            }

            Button {
                id: input_add_stream_button
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 5

                background: IconLabel {
                    text: MdiFont.Icon.plusCircle
                }

                HoverToolTip {
                    text: "Share an additional audio stream"
                }

                onClicked: {
                    console.log("add stream")
                }
            }

        } // END input_selector_modal

        // input_selector_modal drop shadow
        DropShadow {
            anchors.fill: input_selector_modal
            horizontalOffset: 1
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: input_selector_modal

            visible: input_selector_modal.visible
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
                    console.log("Settings opened")
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
        customDialog(title, message, button1, button2, -1, true)
    }

    function customDialog(title, message, button1, button2, time, allowClose) {
        var dialog = Qt.createQmlObject("DefaultDialog {}", main_container)

        if (dialog == null) {
            console.log("Dialog creation failed!")
            return
        }

        dialog.dynamic = true
        dialog.visible = true
        dialog.focus = true
        dialog.time = time
        dialog.title = title
        dialog.message = message
        dialog.allowClose = allowClose
        dialog.button1Text = button1
        dialog.button2Text = button2

        if (time !== -1)
            dialog.closeSelf() // Trigger timer
    }

    // Close any modal windows
    function closeModals() {
        // Check if clickToClose is disabled
        if (!Constants.enableClickToClose)
            return

        input_selector_modal.visible = false
        input_selector_modal.focus = false
    }

} // END main_container


