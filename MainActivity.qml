import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {

    Component {
        id: actionDelegate

        Item {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: cardContent.height

            Item {
                id: cardContent

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 8
                    rightMargin: 8
                }
                height: itemRectangle.height

                Rectangle {
                    id: itemRectangle
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: itemContent.height
                    color: "white"
                    radius: 2

                    ColumnLayout {
                        id: itemContent
                        anchors {
                            left: parent.left
                            right: parent.right
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 160

                            Image {
                                id: cardImage
                                visible: false
                                anchors.fill: parent
                                source: imageSrc
                                fillMode: Image.PreserveAspectCrop
                                verticalAlignment: Image.AlignTop
                                smooth: true

                                Text {
                                    text: name
                                    font.pixelSize: 24
                                    font.bold: true
                                    color: "white"
                                    anchors {
                                        bottom: parent.bottom
                                        left: parent.left
                                        margins: 8
                                    }
                                }
                            }

                            Rectangle {
                                id: mask
                                anchors {
                                    top: parent.top
                                    left: parent.left
                                    right: parent.right
                                }
                                height: parent.height + 2
                                visible: false
                                radius: 2
                                smooth: true

                                Rectangle {
                                    anchors {
                                        top: parent.verticalCenter
                                        left: parent.left
                                        right: parent.right
                                        bottom: parent.bottom
                                    }
                                    height: 150
                                }
                            }

                            OpacityMask {
                                anchors.fill: cardImage
                                source: cardImage
                                maskSource: mask
                            }
                        }

                        RowLayout {
//                            anchors.fill: parent
//                            anchors.topMargin: 16
//                            anchors.bottomMargin: 16
//                            anchors.rightMargin: 16
//                            anchors.leftMargin: 16
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            Layout.rightMargin: 8
                            Layout.leftMargin: 8
                            Layout.preferredHeight: 40

                            Text {
                                text: number
                                color: "black"
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: ">"
                                color: "black"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            }
                        }
                    }
                }

                DropShadow {
                    anchors.fill: source
                    height: source.height
                    width: source.width
//                    horizontalOffset: 0
                    verticalOffset: 2
//                    radius: 8
//                    samples: 17
//                    color: "#80000000"
                    cached: true
                    radius: 8.0
                    samples: 16
                    color: "#80000000"
                    smooth: true
                    source: itemRectangle
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (activity != -1) {
                            stack.push(stack.stackItems[activity]);
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: actionModel

        ListElement {
            name: "Groupes"
            number: "Chercher un aliment par groupe"
            activity: 5
            imageSrc: "res/groupes.jpg"
        }
        ListElement {
            name: "Composants"
            number: "Chercher un aliment par composant"
            activity: 4
            imageSrc: "res/composants.png"
        }
//        ListElement {
//            name: "Recherche avancée"
//            number: "Rechercher un aliment"
//            activity: 7
//        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#E5E5E5"
    }

    ListView {
        id: actionListView
        anchors.fill: parent
        model: actionModel
        delegate: actionDelegate
        spacing: 8
        topMargin: 8
    }

    Component.onCompleted: {
        parameters.luminance = 0.6;
    }
}
