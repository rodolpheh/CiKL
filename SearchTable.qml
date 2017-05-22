import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {

    Component {
        id: resultsDelegate

        Item {
            anchors {
                right: parent.right
                left: parent.left
            }
            height: 60

            ColumnLayout {
                anchors.fill: parent
                z: 10

                Text {
                    text: origfdnm
                    Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 1
                    elide: Text.ElideRight
                    Layout.maximumWidth: parent.width * 0.7
                    font.pixelSize: 13
                    Layout.row: 0
                    Layout.column: 0
                }

                Text {
                    text: origgpfr
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 0.535
                    font.pixelSize: 13
                    Layout.row: 1
                    Layout.column: 0
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    var productComponent = Qt.createComponent("ProductTable.qml");
                    var productTable = productComponent.createObject(null, JSON.parse(productData.getData(origfdcd)));

                    // Hide search field and search results before loading the new page
                    searchField.focus = false;
                    stack.push(productTable);
                }
            }
        }
    }

    ListView {
        id: resultsView
        anchors.fill: parent
        model: globalSearchModel
        delegate: resultsDelegate
        clip: true

        onMovementStarted: {
            searchField.focus = false;
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
