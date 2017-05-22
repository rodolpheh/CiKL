import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {

    Component {
        id: componentsDelegate

        Item {
            height: componentsView.cellHeight
            width: componentsView.cellWidth

            Rectangle {
                id: componentElementBg
                anchors.fill: parent
                anchors {
                    topMargin: index < 3 ? 4 : 2
                    bottomMargin: index >= componentsView.model.count - 3 ? 4 : 2
                    leftMargin: index % 3 == 0 ? 4 : 2
                    rightMargin: (index + 1) % 3 == 0 ? 4 : 2
                }

                color: Qt.hsla((1 / 30) * (index % 30), 0.8, parameters.luminance)

                Rectangle {
                    id: componentFooter
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    height: 48
                    color: "black"
                    opacity: 0.45
                }

                Text {
                    x: test.x
                    y: test.y + 1

                    color: "black"
                    opacity: 0.8
                    text: letter ? letter : "/"
                    font.pixelSize: 48
                    font.bold: true
                }

                Text {
                    id: test
                    anchors.centerIn: parent
                    color: "white"
                    text: letter ? letter : "/"
                    font.pixelSize: 48
                    font.bold: true
                }

                Text {
                    text: name
                    anchors.centerIn: componentFooter
                    color: "white"
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    stack.stackItems[1].pageTitle = name;
                    stack.stackItems[1].column = column;
                    stack.stackItems[1].name = name;
                    stack.stackItems[1].unite = ajr[column]["unite"];
                    stack.stackItems[1].rdi = ajr[column]["ajr"];
                    stack.stackItems[1].refresh();
                    stack.push(stack.stackItems[1]);
                }
            }
        }
    }

    GridView {
        id: componentsView
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: root.horizontalCenter
        }
        width: root.width
        model: ComponentsModel {}
        delegate: componentsDelegate
        snapMode: ListView.SnapToItem
        clip: true
        contentWidth: width
        contentHeight: cellHeight * model.count
        cellWidth: width / 3
        cellHeight: cellWidth * 1.2

        onMovementStarted: {
            searchField.focus = false;
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
