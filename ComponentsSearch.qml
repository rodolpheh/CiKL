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
            var request = "SELECT origgpfr, origfdcd, origfdnm, " + column + ", " +
                    "(CASE " +
                    "WHEN SUBSTR(" + column + ", 1, 1) = \"<\" THEN SUBSTR(" + column + ", 3) " +
                    "WHEN " + column + " LIKE 'traces' THEN '0' " +
                    "WHEN " + column + " LIKE '-' THEN '-2' " +
                    "WHEN " + column + " LIKE '0' THEN '-1' " +
                    "ELSE " + column + " END) as newValue " +
                    "FROM CiKL " + (search != "" ? "WHERE origfdnm LIKE '%" + search + "%' OR origgpfr LIKE '%" + search + "%' " : "") +
                    "ORDER BY newValue + 0 " + (sorting ? "ASC" : "DESC");

            console.log(request);
            var results = tx.executeSql(request);
            for(var i = 0; i < results.rows.length; i++) {
                console.log(JSON.stringify(results.rows.item(i)));
                searchResults.append({ "number" : results.rows.item(i)["origfdcd"], "name" : results.rows.item(i)["origfdnm"], "value" : results.rows.item(i)[column].toString(), "unite": ajr[column]["unite"], "rdi": ajr[column]["ajr"], "group": results.rows.item(i)["origgpfr"] });
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

            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                //color: colors[index >= 10 ? 8 - (index % 10) : index]
                color: Qt.hsla(index >= 20 ? (1/20) * (18 - (index % 20)) : (1 / 20) * (index % 20), 0.4, 0.82)
                width: sizeBg(value, 1, rdi) * parent.width
            }

            GridLayout {
                anchors.fill: parent

                Text {
                    text: name
                    Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 1
                    elide: Text.ElideRight
                    Layout.maximumWidth: parent.width * 0.7
                    font.pixelSize: 13
                    Layout.row: 0
                    Layout.column: 0
                }

                //Item { Layout.fillWidth: true }

                Text {
                    text: qsTr(interpret(value, 1, unite))
                    Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                    Layout.rightMargin: 16
                    opacity: 1
                    font.pixelSize: 13
                    Layout.row: 0
                    Layout.column: 1
                }

                Text {
                    text: group
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.leftMargin: 16
                    opacity: 0.535
                    font.pixelSize: 13
                    Layout.row: 1
                    Layout.column: 0
                }

                Text {
                    text: sizeBg(value, 1, rdi) ? (Math.round((sizeBg(value, 1, rdi) * 100) * 10) / 10) + " %" : ""
                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                    Layout.rightMargin: 16
                    opacity: 0.535
                    font.pixelSize: 13
                    Layout.row: 1
                    Layout.column: 1
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
