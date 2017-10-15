import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property var origgpcd: ""
    property var origgpfr: ""
    property var origfdcd: ""
    property var origfdnm: ""
    property var energie_ue_kj: ""
    property var energie_ue_kcal: ""
    property var energie_jones_kj: ""
    property var energie_jones_kcal: ""
    property var eau: ""
    property var proteines: ""
    property var proteines_brutes: ""
    property var glucides: ""
    property var lipides: ""
    property var sucres: ""
    property var amidon: ""
    property var fibres: ""
    property var polyols: ""
    property var cendres: ""
    property var alcool: ""
    property var acides_organiques: ""
    property var acides_gras_satures: ""
    property var acides_gras_mono: ""
    property var acides_gras_poly: ""
    property var acides_gras_butyrique: ""
    property var acides_gras_caproique: ""
    property var acides_gras_caprylique: ""
    property var acides_gras_caprique: ""
    property var acides_gras_laurique: ""
    property var acides_gras_myristique: ""
    property var acides_gras_palmitique: ""
    property var acides_gras_stearique: ""
    property var acides_gras_oleique: ""
    property var acides_gras_linoleique: ""
    property var acides_gras_alpha: ""
    property var acides_gras_arachidonique: ""
    property var acides_gras_epa: ""
    property var acides_gras_dha: ""
    property var cholesterol: ""
    property var sel: ""
    property var calcium: ""
    property var chlorure: ""
    property var cuivre: ""
    property var fer: ""
    property var iode: ""
    property var magnesium: ""
    property var manganese: ""
    property var phosphore: ""
    property var potassium: ""
    property var selenium: ""
    property var sodium: ""
    property var zinc: ""
    property var retinol: ""
    property var betacarotene: ""
    property var vitamine_d: ""
    property var vitamine_e: ""
    property var vitamine_k1: ""
    property var vitamine_k2: ""
    property var vitamine_c: ""
    property var vitamine_b1: ""
    property var vitamine_b2: ""
    property var vitamine_b3: ""
    property var vitamine_b5: ""
    property var vitamine_b6: ""
    property var vitamine_b9: ""
    property var vitamine_b12: ""

    property var factor

    property alias swipeView: swipeView
    property alias generalView: generalView
    property alias vitaminView: vitaminView
    property alias mineralView: mineralView

    property var syncList

    anchors.fill: parent

    id: productData

    ColumnLayout {
        anchors.fill: parent
        clip: true

//        Item {
//            Layout.alignment: Qt.AlignHCenter
//            Layout.fillWidth: true

            Text {
                text: origfdnm
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
//                anchors {
//                    top: parent.top
//                    bottom: parent.bottom
//                    left: parent.left
//                    right: parent.right
//                    rightMargin: 12
//                    leftMargin: 12
//                }

                Layout.fillWidth: true
                Layout.maximumWidth: root.width * (2/3)
                Layout.alignment: Qt.AlignHCenter
                Layout.rightMargin: 12
                Layout.leftMargin: 12
                Layout.topMargin: 12
            }
//        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Text {
                text: qsTr("Qtité:")
            }

            TextField {
                id: quantity
                placeholderText: "100"
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhNoPredictiveText

                onTextChanged: {
                    factor = parseFloat(text == "" ? placeholderText : text) / 100;
                }
            }

            Text {
                text: qsTr("g")
            }
        }

        TabBar {
            id: tabBar
            currentIndex: swipeView.currentIndex
            Layout.fillWidth: true

            TabButton {
                text: qsTr("Général")
            }
            TabButton {
                text: qsTr("Vitamines")
            }
            TabButton {
                text: qsTr("Sels min.");
            }
        }

        SwipeView {
            id: swipeView
            currentIndex: tabBar.currentIndex
            Layout.fillHeight: true
            Layout.fillWidth: true

            onCurrentIndexChanged: {
                if (syncList != null) {
                    syncList.swipeView.setCurrentIndex(currentIndex);
                }
            }

            Page {
                id: firstPage

                Component {
                    id: generalDelegate

                    GeneralDelegate {}
                }

                ListModel {
                    id: generalModel

                    Component.onCompleted: {
                        append({name: "Calories", number: energie_ue_kcal, unit: ajr["energie_ue_kcal"]["unite"], rdi: ajr["energie_ue_kcal"]["ajr"]});
                        append({name: "Lipides", number: lipides, unit: ajr["lipides"]["unite"], rdi: ajr["lipides"]["ajr"]});
                        append({name: "- a.g.saturés", number: acides_gras_satures, unit: ajr["acides_gras_satures"]["unite"], rdi: ajr["acides_gras_satures"]["ajr"]});
                        append({name: "- a.g.mono", number: acides_gras_mono, unit: ajr["acides_gras_mono"]["unite"], rdi: ajr["acides_gras_mono"]["ajr"]});
                        append({name: "- a.g.poly", number: acides_gras_poly, unit: ajr["acides_gras_poly"]["unite"], rdi: ajr["acides_gras_poly"]["ajr"]});
                        append({name: "Glucides", number: glucides, unit: ajr["glucides"]["unite"], rdi: ajr["glucides"]["ajr"]});
                        append({name: "- Sucres", number: sucres, unit: ajr["sucres"]["unite"], rdi: ajr["sucres"]["ajr"]});
                        append({name: "- Polyols", number: polyols, unit: ajr["polyols"]["unite"], rdi: ajr["polyols"]["ajr"]});
                        append({name: "- Amidon", number: amidon, unit: ajr["amidon"]["unite"], rdi: ajr["amidon"]["ajr"]});
                        append({name: "Fibres", number: fibres, unit: ajr["fibres"]["unite"], rdi: ajr["fibres"]["ajr"]});
                        append({name: "Protéines", number: proteines, unit: ajr["proteines"]["unite"], rdi: ajr["proteines"]["ajr"]});
                        append({name: "Sodium", number: sodium, unit: ajr["sodium"]["unite"], rdi: ajr["sodium"]["ajr"]});
                        append({name: "Cholestérol", number: cholesterol, unit: ajr["cholesterol"]["unite"], rdi: ajr["cholesterol"]["ajr"]});
                        append({name: "Eau", number: eau, unit: ajr["eau"]["unite"], rdi: ajr["eau"]["ajr"]});
                        append({name: "Alcool", number: alcool, unit: ajr["alcool"]["unite"], rdi: ajr["alcool"]["ajr"]});
                    }
                }

                ListView {
                    id: generalView
                    anchors.fill: parent
                    model: generalModel
                    delegate: generalDelegate
                    snapMode: ListView.NoSnap

                    clip: true
                    contentWidth: width
                    contentHeight: 40 * generalView.model.count

                    ScrollBar.vertical: ScrollBar {}

                    onContentYChanged: {
                        if (syncList != null) {
                            syncList.generalView.contentY = contentY;
                        }
                    }

                    onMovementStarted: {
                        if (syncList != null) {
                            syncList.syncList = null;
                        }
                    }

                    onMovementEnded: {
                        if (syncList != null) {
                            syncList.syncList = productData;
                        }
                    }
                }
            }

            Page {
                id: secondPage

                Component {
                    id: vitaminDelegate

                    GeneralDelegate {}
                }

                ListModel {
                    id: vitaminModel

                    Component.onCompleted: {
                        append({name: "Vitamine A", number: retinol, unit: ajr["retinol"]["unite"], rdi: ajr["retinol"]["ajr"]});
                        append({name: "B-carotène", number: betacarotene, unit: ajr["betacarotene"]["unite"], rdi: ajr["betacarotene"]["ajr"]});
                        append({name: "Vitamine B1", number: vitamine_b1, unit: ajr["vitamine_b1"]["unite"], rdi: ajr["vitamine_b1"]["ajr"]});
                        append({name: "Vitamine B2", number: vitamine_b2, unit: ajr["vitamine_b2"]["unite"], rdi: ajr["vitamine_b2"]["ajr"]});
                        append({name: "Vitamine B3", number: vitamine_b3, unit: ajr["vitamine_b3"]["unite"], rdi: ajr["vitamine_b3"]["ajr"]});
                        append({name: "Vitamine B5", number: vitamine_b5, unit: ajr["vitamine_b5"]["unite"], rdi: ajr["vitamine_b5"]["ajr"]});
                        append({name: "Vitamine B6", number: vitamine_b6, unit: ajr["vitamine_b6"]["unite"], rdi: ajr["vitamine_b6"]["ajr"]});
                        append({name: "Vitamine B9", number: vitamine_b9, unit: ajr["vitamine_b9"]["unite"], rdi: ajr["vitamine_b9"]["ajr"]});
                        append({name: "Vitamine B12", number: vitamine_b12, unit: ajr["vitamine_b12"]["unite"], rdi: ajr["vitamine_b12"]["ajr"]});
                        append({name: "Vitamine C", number: vitamine_c, unit: ajr["vitamine_c"]["unite"], rdi: ajr["vitamine_c"]["ajr"]});
                        append({name: "Vitamine D", number: vitamine_d, unit: ajr["vitamine_d"]["unite"], rdi: ajr["vitamine_d"]["ajr"]});
                        append({name: "Vitamine E", number: vitamine_e, unit: ajr["vitamine_e"]["unite"], rdi: ajr["vitamine_b1"]["ajr"]});
                    }
                }

                ListView {
                    id: vitaminView
                    anchors.fill: parent
                    model: vitaminModel
                    delegate: vitaminDelegate
                    snapMode: ListView.NoSnap

                    clip: true
                    contentWidth: width
                    contentHeight: 40 * vitaminView.model.count

                    ScrollBar.vertical: ScrollBar {}

                    onContentYChanged: {
                        if (typeof syncList != "undefined") {
                            syncList.vitaminView.contentY = contentY;
                        }
                    }
                }

            }

            Page {
                id: thirdPage

                Component {
                    id: mineralDelegate

                    GeneralDelegate {}
                }

                ListModel {
                    id: mineralModel

                    Component.onCompleted: {
                        append({name: "Calcium", number: calcium, unit: ajr["calcium"]["unite"], rdi: ajr["calcium"]["ajr"]});
                        append({name: "Cuivre", number: cuivre, unit: ajr["cuivre"]["unite"], rdi: ajr["cuivre"]["ajr"]});
                        append({name: "Fer", number: fer, unit: ajr["fer"]["unite"], rdi: ajr["fer"]["ajr"]});
                        append({name: "Iode", number: iode, unit: ajr["iode"]["unite"], rdi: ajr["iode"]["ajr"]});
                        append({name: "Magnésium", number: magnesium, unit: ajr["magnesium"]["unite"], rdi: ajr["magnesium"]["ajr"]});
                        append({name: "Manganèse", number: manganese, unit: ajr["manganese"]["unite"], rdi: ajr["manganese"]["ajr"]});
                        append({name: "Phosphore", number: phosphore, unit: ajr["phosphore"]["unite"], rdi: ajr["phosphore"]["ajr"]});
                        append({name: "Potassium", number: potassium, unit: ajr["potassium"]["unite"], rdi: ajr["potassium"]["ajr"]});
                        append({name: "Sélénium", number: selenium, unit: ajr["selenium"]["unite"], rdi: ajr["selenium"]["ajr"]});
                        append({name: "Zinc", number: zinc, unit: ajr["zinc"]["unite"], rdi: ajr["zinc"]["ajr"]});
                    }
                }

                ListView {
                    id: mineralView
                    anchors.fill: parent
                    model: mineralModel
                    delegate: mineralDelegate
                    snapMode: ListView.SnapToItem

                    clip: true
                    contentWidth: width
                    contentHeight: 40 * mineralView.model.count

                    ScrollBar.vertical: ScrollBar {}

                    onContentYChanged: {
                        if (typeof syncList != "undefined") {
                            syncList.mineralView.contentY = contentY;
                        }
                    }
                }
            }
        }
    }
}
