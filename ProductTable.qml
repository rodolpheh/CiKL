import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property var origgpcd
    property var origgpfr
    property var origfdcd
    property var origfdnm
    property var energie_ue_kj
    property var energie_ue_kcal
    property var energie_jones_kj
    property var energie_jones_kcal
    property var eau
    property var proteines
    property var proteines_brutes
    property var glucides
    property var lipides
    property var sucres
    property var amidon
    property var fibres
    property var polyols
    property var cendres
    property var alcool
    property var acides_organiques
    property var acides_gras_satures
    property var acides_gras_mono
    property var acides_gras_poly
    property var acides_gras_butyrique
    property var acides_gras_caproique
    property var acides_gras_caprylique
    property var acides_gras_caprique
    property var acides_gras_laurique
    property var acides_gras_myristique
    property var acides_gras_palmitique
    property var acides_gras_stearique
    property var acides_gras_oleique
    property var acides_gras_linoleique
    property var acides_gras_alpha
    property var acides_gras_arachidonique
    property var acides_gras_epa
    property var acides_gras_dha
    property var cholesterol
    property var sel
    property var calcium
    property var chlorure
    property var cuivre
    property var fer
    property var iode
    property var magnesium
    property var manganese
    property var phosphore
    property var potassium
    property var selenium
    property var sodium
    property var zinc
    property var retinol
    property var betacarotene
    property var vitamine_d
    property var vitamine_e
    property var vitamine_k1
    property var vitamine_k2
    property var vitamine_c
    property var vitamine_b1
    property var vitamine_b2
    property var vitamine_b3
    property var vitamine_b5
    property var vitamine_b6
    property var vitamine_b9
    property var vitamine_b12

    property var factor

    id: productView

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Text {
                text: qsTr("Qtité/unité")
            }

            TextField {
                id: quantity
                placeholderText: "100"
                horizontalAlignment: TextInput.AlignHCenter

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
            Layout.fillWidth: true
            Layout.fillHeight: true

            Page {
                id: firstPage

                Flickable {
                    id: generalFlickable
                    clip: true
                    contentWidth: width
                    contentHeight: 40 * generalView.model.count
                    anchors.fill: parent

                    Component {
                        id: generalDelegate

                        GeneralDelegate {}
                    }

                    ListModel {
                        id: generalModel

                        Component.onCompleted: {
                            append({name: "Calories", number: energie_ue_kcal, unit: "kcal", rdi: 2000});
                            append({name: "Lipides", number: lipides, unit: "g", rdi: 70});
                            append({name: "- a.g.saturés", number: acides_gras_satures, unit: "g", rdi: 20});
                            append({name: "- a.g.mono", number: acides_gras_mono, unit: "g", rdi: 0});
                            append({name: "- a.g.poly", number: acides_gras_poly, unit: "g", rdi: 0});
                            append({name: "Glucides", number: glucides, unit: "g", rdi: 260});
                            append({name: "- Sucres", number: sucres, unit: "g", rdi: 90});
                            append({name: "- Polyols", number: polyols, unit: "g", rdi: 0});
                            append({name: "- Amidon", number: amidon, unit: "g", rdi: 0});
                            append({name: "Fibres", number: fibres, unit: "g", rdi: 0});
                            append({name: "Protéines", number: proteines, unit: "g", rdi: 50});
                            append({name: "Sodium", number: sodium, unit: "mg", rdi: 6000});
                            append({name: "Cholestérol", number: cholesterol, unit: "mg", rdi: 0});
                            append({name: "Eau", number: eau, unit: "g", rdi: 0});
                            append({name: "Alcool", number: alcool, unit: "g", rdi: 0});
                        }
                    }

                    ListView {
                        id: generalView
                        anchors.fill: parent
                        model: generalModel
                        delegate: generalDelegate
                        snapMode: ListView.SnapToItem
                    }

                    ScrollBar.vertical: ScrollBar {}
                }
            }

            Page {
                id: secondPage

                Flickable {
                    id: vitaminFlickable
                    clip: true
                    contentWidth: width
                    contentHeight: 40 * vitaminView.model.count
                    anchors.fill: parent

                    Component {
                        id: vitaminDelegate

                        GeneralDelegate {}
                    }

                    ListModel {
                        id: vitaminModel

                        Component.onCompleted: {
                            append({name: "Vitamine A", number: retinol, unit: "µg", rdi: 800});
                            append({name: "B-carotène", number: betacarotene, unit: "µg", rdi: 0});
                            append({name: "Vitamine B1", number: vitamine_b1, unit: "mg", rdi: 1.1});
                            append({name: "Vitamine B2", number: vitamine_b2, unit: "mg", rdi: 1.4});
                            append({name: "Vitamine B3", number: vitamine_b3, unit: "mg", rdi: 16});
                            append({name: "Vitamine B5", number: vitamine_b5, unit: "mg", rdi: 6});
                            append({name: "Vitamine B6", number: vitamine_b6, unit: "mg", rdi: 1.4});
                            append({name: "Vitamine B9", number: vitamine_b9, unit: "µg", rdi: 200});
                            append({name: "Vitamine B12", number: vitamine_b12, unit: "µg", rdi: 2.5});
                            append({name: "Vitamine C", number: vitamine_c, unit: "mg", rdi: 80});
                            append({name: "Vitamine D", number: vitamine_d, unit: "µg", rdi: 5});
                            append({name: "Vitamine E", number: vitamine_e, unit: "mg", rdi: 12});
                        }
                    }

                    ListView {
                        id: vitaminView
                        anchors.fill: parent
                        model: vitaminModel
                        delegate: vitaminDelegate
                        snapMode: ListView.SnapToItem
                    }

                    ScrollBar.vertical: ScrollBar {}
                }
            }

            Page {
                id: thirdPage

                Flickable {
                    id: mineralFlickable
                    clip: true
                    contentWidth: width
                    contentHeight: 40 * mineralView.model.count
                    anchors.fill: parent

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
                    }

                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }
    }
}
