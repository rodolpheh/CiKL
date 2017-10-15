import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0

Item {
    property var origgpcd
    property var origgpfr
    property var origfdcd
    //property var origfdnm

    property alias component1: component1
    property alias component2: component2

    property string pageTitle: component2.visible ? "Comparaison" : "Produit"

    id: productView
    objectName: component2.visible ? "compareView" : "productView"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: component1
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: "#CECECE"
            visible: component2.visible
        }

        Item {
            id: component2
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: false
        }
    }

    RoundButton {
        id: linkScrolls
        text: checked ? "-" : "x"
        anchors.horizontalCenter: parent.horizontalCenter
        visible: component2.visible
        checkable: true

        onToggled: {
            if (checked) {
                component1.children[0].syncList = component2.visible ? component2.children[0] : null;
                component2.children[0].syncList = component1.children[0];
            }
            else {
                component1.children[0].syncList = null;
                component2.children[0].syncList = null;
            }
        }
    }
}
