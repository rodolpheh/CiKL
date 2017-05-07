import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property var nbLines

    anchors {
        right: parent.right
        left: parent.left
    }

    height: 40

    function interpret(number, factor, unit) {
        factor = typeof factor !== 'undefined' ? factor : 1;
        if (isNaN(number)) {
            if (number[0] == '<') {
                number = number[0] + " " + (parseFloat(number.slice(1, number.length)) * factor).toLocaleString(Qt.locale()) + " " + unit;
            }
            return number;
        }
        else {
            return (parseFloat(number) * factor).toLocaleString(Qt.locale()) + " " + unit;
        }
    }

    function sizeBg(number, factor, rdi) {
        if (rdi == 0) {
            return 0;
        }
        factor = typeof factor !== 'undefined' ? factor : 1;
        if (isNaN(number)) {
            if (number[0] == '<') {
                number = (parseFloat(number.slice(1, number.length)) * factor) / rdi;
                return number;
            }
            return 0;
        }
        else {
            return (parseFloat(number) * factor) / rdi;
        }
    }

    Rectangle {
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent
            z: 10

            Text {
                text: name
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 16
                opacity: 0.535
                font.pixelSize: 13
            }

            Item { Layout.fillWidth: true }

            Text {
                text: qsTr(interpret(number, factor, unit))
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 16
                opacity: 0.535
                font.pixelSize: 13
            }
        }

        Rectangle {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            //color: colors[index >= 10 ? 8 - (index % 10) : index]
            color: Qt.hsla((1 / 10) * (index % 10), 0.4, 0.82)
            width: sizeBg(number, factor, rdi) * parent.width
        }

        Text {
            text: sizeBg(number, factor, rdi) > 0 ? (Math.round((sizeBg(number, factor, rdi) * 100) * 10) / 10) + " %" : ""
            anchors.centerIn: parent
            opacity: 0.535
            font.pixelSize: 12
        }
    }
}
