import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import "fonts/Icon.js" as MdiFont

Text {
    font.family: "Material Design Icons"
    font.pixelSize: Math.min(0.1 * main_window.height, 0.3 * main_window.width)

    color: "white"
    opacity: 0.75
}
