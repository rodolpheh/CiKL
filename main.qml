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

    function createProductPage(isComparing, origfdcd, origfdcdComponent1) {
        var productComponent = Qt.createComponent("ProductTable.qml");
        var jsonData = JSON.parse(productData.getData(origfdcd));
        while (productComponent.status != Component.Ready) {}
        var productTable = productComponent.createObject(null, {"origfdcd": jsonData.origfdcd});

        if (isComparing) {
            var productDataComponent1 = Qt.createComponent("ProductData.qml");
            while (productDataComponent1.status != Component.Ready) {}
            var productDataObject1 = productDataComponent1.createObject(productTable.component1, JSON.parse(productData.getData(origfdcdComponent1)));
            var productDataComponent2 = Qt.createComponent("ProductData.qml");
            while (productDataComponent2.status != Component.Ready) {}
            var productDataObject2 = productDataComponent2.createObject(productTable.component2, JSON.parse(productData.getData(origfdcd)));
            productTable.component2.visible = true;
            productTable.component2.enabled = true;
        }
        else {
            var productDataComponent = Qt.createComponent("ProductData.qml");
            while (productDataComponent.status != Component.Ready) {}
            var productDataObject = productDataComponent.createObject(productTable.component1, JSON.parse(productData.getData(origfdcd)));
        }

        // Hide search field and search results before loading the new page
        searchField.focus = false;
        stack.push(productTable);
    }

    StackView {
        property var stackItems: [
            searchTableView.createObject(),
            componentsSearchComponent.createObject(),
            mainComponent.createObject(),
            parametersComponent.createObject(),
            componentsComponent.createObject(),
            groupsComponent.createObject(),
            groupsSearchComponent.createObject(),
            //advancedSearchActivityComponent.createObject(),
            //compareActivityComponent.createObject()
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

            if (stack.currentItem.objectName == "componentsSearch" || stack.currentItem.objectName == "groupsSearch") {
                stack.currentItem.pageTitle = stack.currentItem.name + " - Recherche : " + searchField.text;
                stack.currentItem.search = searchField.text;
                stack.currentItem.refresh();
            }
            else {
                if (searchField.text != "") {
                    globalSearchModel.setParameter(":searchString", "'%" + searchField.text + "%'");
                    globalSearchModel.refresh();
                    if (stack.currentItem.objectName != "searchTable") {
                        if (stack.depth > 2) {
                            stack.pop();
                        }
                        else {
                            stack.push(stack.stackItems[0]);
                        }
                    }
                }
                else {
                    if (stack.currentItem.objectName == "searchTable" && !stack.currentItem.isComparing) {
                        stack.pop(null);
                    }
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
                visible: (stack.currentItem.objectName == "searchTable" || focus) ? true : false
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
                    source: "res/icons/compare.png"
                }
                visible: stack.currentItem.objectName != "productView" ? false : true
                onClicked: {
                    var compareSearchComponent = Qt.createComponent("SearchTable.qml");
                    var compareSearchObject = compareSearchComponent.createObject(null, { "isComparing": true, "origfdcdComponent1": stack.currentItem.origfdcd });
                    stack.push(compareSearchObject);
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
                visible: (stack.currentItem.objectName == "componentsSearch" ||
                          stack.currentItem.objectName == "groupsSearch" ||
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

//    Component {
//        id: advancedSearchActivityComponent
//        AdvancedSearchActivity {
//            property string pageTitle: "Recherche avancée"
//            id: advancedSearchActivity
//        }
//    }

    Component {
        id: compareActivityComponent
        CompareActivity {
            property string pageTitle: "Comparaison"
            id: compareActivity
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
        ajr = JSON.parse(openFile("res/columns.json"));
        console.log("Pixel density: " + Screen.pixelDensity);
    }
}
