import QtQuick 2.7
import QtQuick.Controls 2.2
import "fonts/Icon.js" as MdiFont
import "Constants.js" as Constants

Modal {
    id: input_selector_modal

    x: 0.9 * main_container.width - width
    y: footer.x - height - 1 // bottom margin of 1

    width: 0.4 * main_container.width
    height: 0.5 * main_container.height

    //color: Constants.modalColor
    //radius: 4

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
