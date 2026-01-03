//@qmldir

import Quickshell
import QtQuick

ShellRoot {
    variants: [
        ShellVariant {
            anchors {
                top: true
                left: true
                right: true
            }
        }
    ]

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        height: 30
        color: "#222222"

        Text {
            anchors.centerIn: parent
            text: "Noctalia Bar (Placeholder)"
            color: "white"
        }
    }
}
