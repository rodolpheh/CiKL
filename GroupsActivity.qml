import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {

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
                    text: section
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#607D8B"
                }
            }

//            Rectangle {
//                color: "#E5E5E5"
//                anchors.fill: parent
//            }
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
                text: name
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    stack.stackItems[6].pageTitle = name;
                    stack.stackItems[6].column = number;
                    stack.stackItems[6].name = name;
                    stack.stackItems[6].refresh();
                    stack.push(stack.stackItems[6]);
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: GroupsModel {}
        delegate: groupsDelegate
        contentWidth: width
        contentHeight: 40 * model.count

        section.property: "categoryName"
        section.criteria: ViewSection.FullString
        section.delegate: groupsHeading

        ScrollBar.vertical: ScrollBar {}
    }
}
