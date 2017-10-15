import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {

    property bool isComparing: false
    property string origfdcdComponent1
    property string pageTitle: "Recherche..."

    objectName: "searchTable"

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
                    createProductPage(isComparing, origfdcd, origfdcdComponent1);
//                    var productComponent = Qt.createComponent("ProductTable.qml");
//                    var jsonData = JSON.parse(productData.getData(origfdcd));
//                    while (productComponent.status != Component.Ready) {}
//                    var productTable = productComponent.createObject(null, {"origfdcd": jsonData.origfdcd});

//                    if (isComparing) {
//                        var productDataComponent1 = Qt.createComponent("ProductData.qml");
//                        while (productDataComponent1.status != Component.Ready) {}
//                        var productDataObject1 = productDataComponent1.createObject(productTable.component1, JSON.parse(productData.getData(origfdcdComponent1)));
//                        var productDataComponent2 = Qt.createComponent("ProductData.qml");
//                        while (productDataComponent2.status != Component.Ready) {}
//                        var productDataObject2 = productDataComponent2.createObject(productTable.component2, JSON.parse(productData.getData(origfdcd)));
//                        productTable.component2.visible = true;
//                        productTable.component2.enabled = true;
//                    }
//                    else {
//                        var productDataComponent = Qt.createComponent("ProductData.qml");
//                        while (productDataComponent.status != Component.Ready) {}
//                        var productDataObject = productDataComponent.createObject(productTable.component1, JSON.parse(productData.getData(origfdcd)));
//                    }

//                    // Hide search field and search results before loading the new page
//                    searchField.focus = false;
//                    stack.push(productTable);
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
