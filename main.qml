import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    property var db: LocalStorage.openDatabaseSync("CiKL", "1.0", "Table Ciqual", 2502656)
    property var colors: ["#d0bd7b", "#d1cb7c", "#ccd27e", "#c0d37f", "#b5d481", "#a9d582", "#9ed684", "#93d785", "#89d887", "#88d992"]
    property bool searchIntent: false

    id: root
    visible: true
    width: 480
    height: 800
    title: qsTr("CiKL")

    //property var db
    property var csv
    property int nbColumns: 65
    property var ajr: []
    property var parameters: Object

    function openFile(fileUrl) {
        var request = new XMLHttpRequest();
        request.open("GET", fileUrl, false);
        request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded;')
        request.send(null);
        //console.debug(request.responseText);
        return request.responseText;
    }

    StackView {
        property var stackItems: [
            searchTableView.createObject(),
            componentsSearchComponent.createObject(),
            mainComponent.createObject(),
            parametersComponent.createObject(),
            componentsComponent.createObject(),
            groupsComponent.createObject(),
            groupsSearchComponent.createObject()
        ]

        id: stack
        initialItem: mainComponent
        anchors {
            top: toolbar.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }
    }

    Timer {
        id: searchTimer
        interval: 500;
        repeat: false;

        onTriggered: {

            if (stack.currentItem == stack.stackItems[1] || stack.currentItem == stack.stackItems[6]) {
                stack.currentItem.pageTitle = stack.currentItem.name + " - Recherche : " + searchField.text;
                stack.currentItem.search = searchField.text;
                stack.currentItem.refresh();
            }
            else {
                if (searchField.text != "") {
                    stack.stackItems[0].searchResults.clear();
                    stack.stackItems[0].pageTitle = "Recherche : " + searchField.text
                    db.readTransaction(function(tx) {
                        var results = tx.executeSql("SELECT origgpfr, origfdcd, origfdnm FROM CiKL WHERE origfdnm LIKE '%" + searchField.text + "%' OR origgpfr LIKE '%" + searchField.text + "%' ORDER BY origfdnm ASC;");
                        console.log(results.rows.length);
                        for(var i = 0; i < results.rows.length; i++) {
                            console.log(JSON.stringify(results.rows.item(i)));
                            stack.stackItems[0].searchResults.append({ "number" : results.rows.item(i)["origfdcd"], "name" : results.rows.item(i)["origfdnm"], "value": "", "group": results.rows.item(i)["origgpfr"], "unite": "", "rdi": 0 });
                        }
                        console.debug(stack.stackItems[0].searchResults.count);
                        if (stack.currentItem == stack.stackItems[0]) {
                            console.log("yaaaay");
                        }
                        else if (stack.depth > 2) {
                            stack.pop();
                        }
                        else {
                            stack.push(stack.stackItems[0]);
                        }
                    });
                }
                else {
                    stack.pop(null);
                }
            }
        }
    }

    header: ToolBar {
        id: toolbar
        height: root.width > root.height ? 48 : 56

        RowLayout {
            anchors.fill: parent

            ToolButton {
                id: backButton
                contentItem: Image {
                    anchors {
                        fill: parent
                        margins: (parent.width - 24) / 2
                    }
                    source: "res/icons/back.png"
                }

                onClicked: {
                    if (stack.depth == 2) {
                        searchField.clear();
                    }
                    stack.pop();
                }
                opacity: stack.depth > 1 ? true : false
            }

            ToolButton {
                contentItem: Image {
                    anchors {
                        fill: parent
                        margins: (parent.width - 24) / 2
                    }
                    source: "res/icons/home.png"
                }
                onClicked: {
                    searchField.clear();
                    stack.pop(null);
                }
                visible: stack.depth > 2 ? true : false
            }

            Label {
                text: stack.depth > 1 && stack.currentItem.origfdnm ? stack.currentItem.origfdnm : stack.currentItem.pageTitle
                visible: !searchField.visible
                Layout.fillWidth: true
                font.pixelSize: 20
                Layout.preferredWidth: parent.width * 0.4
                elide: Text.ElideRight
            }

            TextField {
                id: searchField
                visible: (stack.currentItem == stack.stackItems[0] || focus) ? true : false
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhNoPredictiveText

                onTextChanged: {
                    searchTimer.stop();
                    searchTimer.start();
                }
            }

            ToolButton {
                contentItem: Image {
                    anchors {
                        fill: parent
                        margins: (parent.width - 24) / 2
                    }
                    source: "res/icons/search.png"
                }
                visible: searchField.visible ? false : true
                onClicked: {
                    searchField.focus = true;
                }
            }

            ToolButton {
                contentItem: Image {
                    anchors {
                        fill: parent
                        margins: (parent.width - 24) / 2
                    }
                    source: "res/icons/clear.png"
                }
                visible: searchField.visible ? true : false
                onClicked: {
                    searchField.focus = true;
                    searchField.clear();
                }
            }

            ToolButton {
                contentItem: Image {
                    anchors {
                        fill: parent
                        margins: (parent.width - 24) / 2
                    }
                    source: "res/icons/sort.png"
                }
                visible: (stack.currentItem == stack.stackItems[1] || stack.currentItem == stack.stackItems[6]) ? true : false
                onClicked: {
                    stack.currentItem.sorting = !stack.currentItem.sorting;
                    stack.currentItem.refresh();
                }
            }

            ToolButton {
                id: menuButton
                contentItem: Image {
                    anchors {
                        fill: parent
                        margins: (parent.width - 24) / 2
                    }
                    source: root.width > root.height ? "res/icons/more_horiz.png" : "res/icons/more_vert.png"
                }

                onClicked: menu.open()

                Menu {
                    id: menu
                    y: menuButton.height

                    MenuItem {
                        text: "Paramètres"

                        onClicked: {
                            console.log("Paramètres");
                            stack.push(stack.stackItems[3]);
                        }
                    }

                    MenuItem {
                        text: "Synchroniser"

                        onClicked: {
                            console.debug("Synchronisation des données");
                            //csv = openFile("https://pro.anses.fr/tableciqual/Documents/Table_Ciqual_2016.csv");
                            csv = openFile("res/Table_Ciqual_2016_converted.csv");
                            csv = csv.split(/\n/);
                            db.transaction(function(tx) {
                                var columns = openFile("res/columns.csv").split(/\n/);
                                var columns_string = "";
                                var insert_positional = "";

                                // Create the AJR database if it doesn't already exist (otherwise, drop it and create a new one)
                                tx.executeSql('DROP TABLE IF EXISTS AJR');
                                tx.executeSql('CREATE TABLE IF NOT EXISTS AJR(composant TEXT, ajr FLOAT, unite TEXT)')

                                for (var cIndex = 0; cIndex < columns.length - 1; cIndex++) {
                                    var cLine = columns[cIndex].split(",");
                                    console.log(cLine);
                                    tx.executeSql('INSERT INTO AJR VALUES(?, ?, ?)', cLine);
                                    columns_string += cLine[0] + " TEXT" + (cIndex == columns.length - 2 ? "" : ", ");
                                    insert_positional += "?" + (cIndex == columns.length - 2 ? "" : ", ");
                                }

                                // Create the database if it doesn't already exist
                                tx.executeSql('DROP TABLE IF EXISTS CiKL');
                                tx.executeSql('CREATE TABLE IF NOT EXISTS CiKL(' + columns_string + ')');

                                for (var index = 1; index < csv.length - 1; index++) {
                                    var line = csv[index].split(";");
                                    for (var lIndex = 0; lIndex < line.length; lIndex++) {
                                        line[lIndex] = line[lIndex].trim();
                                    }
                                    // Add (another) food row
                                    tx.executeSql('INSERT INTO CiKL VALUES(' + insert_positional + ')', line);
                                }

                                var results = tx.executeSql('SELECT * FROM AJR');
                                ajr = {};
                                for (var index = 0; index < results.rows.length; index++) {
                                    ajr[results.rows.item(index)["composant"]] = {"ajr" : results.rows.item(index)["ajr"], "unite" : results.rows.item(index)["unite"]};
                                }
                                console.log(JSON.stringify(results));
                            });
                        }
                    }
                }
            }
        }
    }

    Component {
        id: mainComponent
        MainActivity {
            property string pageTitle: "Accueil"
            id: mainActivity
        }
    }

    Component {
        id: searchTableView
        SearchTable {
            property string pageTitle: "Recherche :"
            id: searchTable
        }
    }

    Component {
        id: groupsSearchComponent
        GroupsSearch {
            property string pageTitle: "Composant"
            id: groupsSearch
        }
    }

    Component {
        id: parametersComponent
        ParametersActivity {
            property string pageTitle: "Paramètres"
            id: parametersActivity
        }
    }

    Component {
        id: componentsComponent
        ComponentsActivity {
            property string pageTitle: "Composants"
            id: componentsActivity
        }
    }

    Component {
        id: componentsSearchComponent
        ComponentsSearch {
            property string pageTitle: "Composant"
            id: componentsSearch
        }
    }

    Component {
        id: groupsComponent
        GroupsActivity {
            property string pageTitle: "Groupes"
            id: groupsActivity
        }
    }

    onClosing: {
            if (stack.depth > 1) {
                backButton.clicked();
                close.accepted = false;
            }
            else {
                close.accepted = true;
            }
    }

    Component.onCompleted: {
        db.readTransaction(function(tx) {
            var results = tx.executeSql('SELECT * FROM AJR');
            ajr = {};
            for (var index = 0; index < results.rows.length; index++) {
                ajr[results.rows.item(index)["composant"]] = {"ajr" : results.rows.item(index)["ajr"], "unite" : results.rows.item(index)["unite"]};
            }
        });
        //console.log(JSON.stringify(ajr));
    }
}
