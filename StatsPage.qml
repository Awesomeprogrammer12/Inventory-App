import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt.labs.qmlmodels

Rectangle{
    id:statsPage
    z:root.mode === "stats"?1:0
    visible: root.mode === "stats"?true:false
    scale:root.mode === "stats"?1:0
    width:parent.width;radius: 10
    border.color: root.accent[1];border.width: 4
    property var currentComponent
    Behavior on z{
        NumberAnimation{duration:200;easing.type: Easing.OutBounce}
    }
    Behavior on visible {
        NumberAnimation{
            duration:300;
            easing.type: Easing.OutQuad
        }
    }Behavior on scale{
        NumberAnimation{
            duration:300;
            easing.type: Easing.OutQuad
        }
    }
    anchors{
        top:topBar.bottom
        left:parent.left
        leftMargin: 4
        bottom: bottomBar.top
    }
    color:root.bg[0]
    Rectangle{
        id:sideBar;border.color: root.accent[1]
        anchors.left:parent.left
        height: parent.height;border.width: 4
        width:parent.width*0.3;color:root.bg[2];radius: 10
        property var buttons;
        ColumnLayout {
            width:parent.width*0.9
            height:parent.height*0.5
            anchors.centerIn: parent
            spacing: parent.width*0.1
            Repeater{
                model:["Daily","Weekly","Yearly"]
                StyledButton{
                    text:modelData
                    bg: root.bg[1];activeBg: root.bg[3]
                    hoveredBg: root.bg[2];fg:root.fg[0]
                    Layout.fillWidth: true;radii:10;
                    Layout.fillHeight: true;borderColor: root.accent[1]
                    onClicked: {
                        setUpMode(modelData)
                    }
                }
            }
        }
    }
    Component{
        id:selectView//table or graph
        RowLayout{
            anchors.fill: parent
            Repeater{
                model:["Table","Graph"]
                StyledButton{
                    text:modelData
                    bg: root.bg[1];activeBg: root.bg[3]
                    hoveredBg: root.bg[2];fg:root.fg[0]
                    Layout.fillWidth: true;radii:10;
                    Layout.fillHeight: true;borderColor: root.accent[1]
                    onClicked: {
                        setUpModel(modelData)
                    }
                }
            }
        }
    }
    //{productName : "Product Name", openingStock: "Opening Stock", produced: "Produced", bn:"Batch No.",sales: "Sales", closingStock: "Closing Stock"},
    Component {
        id: dailyTable
        Item{
            id:containter;anchors.fill: parent
            ListView {
                id: dailyList
                anchors.fill: parent
                height:statsPage.height*0.95
                model: root.getDaily()
                spacing: 10
                clip: true

                delegate: Item {
                    width: dailyList.width
                    height: grd.height + day.height + 20

                    // modelData here is an array of strings (the items for that day)
                    readonly property var todayContent: modelData

                    Text {
                        id: day
                        text: (todayContent && todayContent.length > 0) ? "Date: " + todayContent[0].split("|")[0] : ""
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true; color: root.fg[0];font.pixelSize: 25;font.family: "consolas"
                    }

                    Grid {
                        id: grd
                        y: day.height + 10
                        columns: 1
                        width: parent.width

                        Repeater {
                            model: todayContent
                            Rectangle {
                                width: grd.width
                                height: 50
                                readonly property var parts: modelData ? modelData.split("|") : []
                                color:"transparent";border.width: 2;border.color: root.accent[1]
                                Row {
                                    anchors.fill: parent;spacing:10;padding: 5
                                    Text {id:name; text: parts[1] || ""; width: parent.width/6; height: 50; color: root.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[2] || "";font.family: "consolas";width: parent.width/6; height: 50; color: root.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[3] || "";font.family: "consolas"; width: parent.width/6; height: 50; color: root.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[4] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: root.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[5] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: root.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[6] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: root.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                id:spacer
                width:dailyList.width
                height:100
                color:"transparent";
                anchors.bottom: dailyList.bottom
                anchors.left: dailyList.left
            }

            Rectangle{
                width:dailyList.width
                height:40
                color:"black";border.color: root.accent[0];border.width: 1
                z:6
                anchors.top: spacer.bottom
                anchors.left: dailyList.left
                Text{anchors.fill: parent;font.bold: true ;font.pixelSize: 20;color:root.fg[0]
                    text: "Product Name |    Opening Stock  |    Produced   |   BatchNO     |    Sales  |    Closing Stock   |"
                }
            }
        }

    }
    Rectangle{
        anchors{
            left:sideBar.right
            right:parent.right
            top:parent.top
            bottom: parent.bottom
            margins: 10
        }
        radius:5
        color:root.bg[1]
        Loader{
            anchors.fill: parent
            sourceComponent: currentComponent
        }
    }
    Component.onCompleted: {
        setUpMode("Daily")
    }

    function setUpMode(mode){
        currentComponent=selectView
    }
    function setUpModel(model) {
        currentComponent=dailyTable
    }
}
