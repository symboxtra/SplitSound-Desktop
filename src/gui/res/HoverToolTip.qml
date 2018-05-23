import QtQuick 2.0
import QtQuick.Controls 2.2

ToolTip {
    parent: parent
    visible: main_container.m_showToolTips && parent.hovered

    delay: 1000
    timeout: 5000
}
