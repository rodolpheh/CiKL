import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.2

ApplicationWindow {
//    property var db: LocalStorage.openDatabaseSync("CiKL", "1.0", "Table Ciqual", 2502656)
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
                    globalSearchModel.setParameter(":searchString", "'%" + searchField.text + "%'");
                    globalSearchModel.refresh();
                    if (stack.currentItem != stack.stackItems[0]) {
                        if (stack.depth > 2) {
                            stack.pop();
                        }
                        else {
                            stack.push(stack.stackItems[0]);
                        }
                    }
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
                placeholderText: "Rechercher..."

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
                visible: searchField.visible && stack.currentItem.objectName != "groupsActivity" ? false : true
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
                visible: (stack.currentItem == stack.stackItems[1] ||
                          stack.currentItem == stack.stackItems[6] ||
                          stack.currentItem.objectName == "groupsActivity") ? true : false
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
//        db.readTransaction(function(tx) {
//            var results = tx.executeSql('SELECT * FROM AJR');
//            ajr = {};
//            for (var index = 0; index < results.rows.length; index++) {
//                console.log(results.rows.item(index));
//                ajr[results.rows.item(index)["composant"]] = {"ajr" : results.rows.item(index)["ajr"], "unite" : results.rows.item(index)["unite"]};
//            }
//        });
        ajr = JSON.parse(openFile("res/columns.json"));
        console.log(Screen.pixelDensity);
    }
}
