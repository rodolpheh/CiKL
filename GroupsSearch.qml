import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property bool sorting: true
    property string column
    property string name
    property string search

    function interpret(number, factor, unit) {
        if (number == 0) {
            return "";
        }

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

    function refresh() {
        groupsFilterModel.setParameter(":group",  "'%" + column + "%'");
        groupsFilterModel.setParameter(":searchString", "'%" + search + "%'");
        groupsFilterModel.setParameter(":sorting", sorting ? "ASC" : "DESC");
        groupsFilterModel.refresh();
    }

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

                Text {
                    text: origfdnm
                    Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 1
                    elide: Text.ElideRight
                    Layout.maximumWidth: parent.width * 0.7
                    font.pixelSize: 13
                }

                Text {
                    text: origgpfr
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 0.535
                    font.pixelSize: 13
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    var productComponent = Qt.createComponent("ProductTable.qml");
                    console.log(productData.getData(origfdcd));
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
        model: groupsFilterModel
        delegate: resultsDelegate
        clip: true

        onMovementStarted: {
            searchField.focus = false;
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
