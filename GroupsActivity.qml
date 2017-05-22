import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {
    objectName: "groupsActivity"

    Component {
        id: groupsHeading

        Item {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: 40

            Item {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: 16
                    rightMargin: 16
                }

                Text {
                    text: origgpcdglob
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#607D8B"
                }
            }
        }
    }

    Component {
        id: groupsDelegate

        Item {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: 40

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    leftMargin: 16
                    left: parent.left
                }
                font.pixelSize: 13
                text: origgpfr
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    stack.stackItems[6].pageTitle = origgpfr;
                    stack.stackItems[6].column = origgpcd;
                    stack.stackItems[6].name = origgpfr;
                    stack.stackItems[6].refresh();
                    stack.push(stack.stackItems[6]);
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: groupsListModel
        delegate: groupsDelegate

        section.property: "categoryName"
        section.criteria: ViewSection.FullString
        section.delegate: groupsHeading

        ScrollBar.vertical: ScrollBar {}
    }
}
