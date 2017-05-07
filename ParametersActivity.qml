import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    //property alias luminanceSlider: luminanceSlider

    Component {
        id: parametersHeading

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
        }
    }

    Component {
        id: parametersDelegate

        Item {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: 68

            GridLayout {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: 16
                    rightMargin: 16
                }

                rows: 2
                columns: 2

                Image {
                    //visible: icon != "" ? true: false
                    source: iconSrc
                    Layout.row: 0
                    Layout.column: 0
                    Layout.rowSpan: 2
                    Layout.alignment: Qt.AlignCenter
                }

                Text {
                    text: name
                    Layout.row: 0
                    Layout.column: 1
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    color: "#767676"
                }

                Slider {
                    visible: category == 1 ? true : false
                    from: 0
                    to: 1
                    stepSize: 0.1
                    snapMode: Slider.SnapAlways
                    Layout.row: 1
                    Layout.column: 1
                    Layout.fillWidth: true

                    onValueChanged: {
                        parameters[paramProperty] = value;
                        parameters = parameters;
                    }

                    Component.onCompleted: {
                        value = parameters[paramProperty];
                    }
                }
            }
        }
    }

    ListModel {
        id: parametersModel

        ListElement {
            name: "Luminance"
            //number: parameters.luminance
            category: 1
            iconSrc: "res/icons/sort.png"
            paramProperty: "luminance"
            categoryName: "Colors"
        }
    }

    ListView {
        anchors.fill: parent
        model: parametersModel
        delegate: parametersDelegate

        section.property: "categoryName"
        section.criteria: ViewSection.FullString
        section.delegate: parametersHeading
    }

    Component.onCompleted: {
        //Object.defineProperty(DB, 'yo', {writable: true, value: 'yooooo'});
        parameters.luminance = 0.6;    }
}
