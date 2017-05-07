import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias searchResults: searchResults
    property bool sorting: false
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
        searchResults.clear();
        db.readTransaction(function(tx) {
            var request = "SELECT origgpcd, origgpfr, origfdcd, origfdnm " +
                    "FROM CiKL WHERE origgpcd LIKE '" + column + "' " + (search != "" ? "AND origfdnm LIKE '%" + search + "%' " : "") +
                    "ORDER BY origfdnm " + (sorting ? "ASC" : "DESC");

            console.log(request);
            var results = tx.executeSql(request);
            for(var i = 0; i < results.rows.length; i++) {
                console.log(JSON.stringify(results.rows.item(i)));
                searchResults.append({ "number" : results.rows.item(i)["origfdcd"], "name" : results.rows.item(i)["origfdnm"], "value" : "0", "unite": "", "rdi": "", "group": results.rows.item(i)["origgpfr"] });
            }
        });
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
                    text: name
                    Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 1
                    elide: Text.ElideRight
                    Layout.maximumWidth: parent.width * 0.7
                    font.pixelSize: 13
                }

                Text {
                    text: group
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 0.535
                    font.pixelSize: 13
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    console.log(number + " - " + name);
                    db.readTransaction(function(tx) {
                        var results = tx.executeSql("SELECT * FROM CiKL WHERE origfdcd = '" + number + "';");
                        var productComponent = Qt.createComponent("ProductTable.qml");
                        console.log(results.rows.length);
                        console.log(JSON.stringify(results.rows.item(0)));

                        var productTable = productComponent.createObject(null, results.rows.item(0));

                        // Hide search field and search results before loading the new page
                        searchField.focus = false;
                        stack.push(productTable);
                    });
                }
            }
        }
    }

    ListModel {
        id: searchResults
    }

    ListView {
        id: resultsView
        anchors.fill: parent
        model: searchResults
        delegate: resultsDelegate
        snapMode: ListView.SnapToItem
        clip: true
        contentWidth: width
        contentHeight: 40 * searchResults.count

        onMovementStarted: {
            searchField.focus = false;
        }

        ScrollBar.vertical: ScrollBar {}
    }
}
