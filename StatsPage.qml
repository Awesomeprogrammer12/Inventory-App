import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt.labs.qmlmodels

Rectangle{
    id:statsPage
    z:appData.mode === "stats"?1:0
    visible: appData.mode === "stats"?true:false
    scale:appData.mode === "stats"?1:0
    width:parent.width;radius: 10
    border.color: appData.accent[1];border.width: 4
    color:appData.bg[0]
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
    Rectangle{
        id:sideBar;border.color: appData.accent[1]
        anchors.left:parent.left
        height: parent.height;border.width: 4
        width:parent.width*0.3;color:appData.bg[0];radius: 10
        property var buttons;
        ColumnLayout {
            width:parent.width*0.9
            height:parent.height*0.6
            anchors.centerIn: parent
            spacing: parent.width*0.1
            Repeater{
                model:["Daily","Weekly","Monthly","Yearly"]
                StyledButton{
                    text:modelData
                    bg: appData.bg[2];activeBg: appData.bg[1]
                    hoveredBg: appData.bg[3];fg:appData.fg[0]
                    Layout.fillWidth: true;radii:10;
                    Layout.fillHeight: true;borderColor: appData.accent[1]
                    onClicked: {
                        setUpModel(modelData)
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
                    bg: appData.bg[1];activeBg: appData.bg[3]
                    hoveredBg: appData.bg[2];fg:appData.fg[0]
                    Layout.fillWidth: true;radii:10;
                    Layout.fillHeight: true;borderColor: appData.accent[1]
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

            Rectangle{
                id:assist
                width:dailyList.width
                height:40
                color:appData.bg[0];border.color: appData.accent[0];border.width: 1
                z:6
                anchors.top: parent.top;radius: 5
                anchors.left: dailyList.left
                Text{anchors.fill: parent;font.bold: true ;font.pixelSize: 20;color:appData.fg[0]
                    text: "Product Name |    Opening Stock  |    Produced   |   BatchNO     |    Sales  |    Closing Stock   |"
                }
            }
            ListView {
                id: dailyList
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: assist.bottom
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
                        font.bold: true; color: appData.fg[0];font.pixelSize: 25;font.family: "consolas"
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
                                color:"transparent";border.width: 2;border.color: appData.accent[1]
                                Row {
                                    anchors.fill: parent;spacing:10;padding: 5
                                    Text {id:name; text: parts[1] || ""; width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[2] || "";font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[3] || "";font.family: "consolas"; width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[4] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[5] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[6] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                }
                            }
                        }
                    }
                }
            }
        }

    }

    Component {
        id: weeklyTable
        Item{
            id:weeklyContainer;anchors.fill: parent

            Rectangle{
                id:assets
                width:weeklyList.width
                height:40
                color:appData.bg[0];border.color: appData.accent[0];border.width: 1
                z:6
                anchors.top: parent.top;radius: 5
                anchors.left: weeklyList.left
                Text{anchors.fill: parent;font.bold: true ;font.pixelSize: 20;color:parent.fg[0]
                    text: "Product Name |    Opening Stock  |    Produced   |   BatchNO     |    Sales  |    Closing Stock   |"
                }
            }
            ListView {
                id: weeklyList
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: assets.bottom
                height:statsPage.height*0.95
                model: root.getWeekly()
                spacing: 10
                clip: true

                delegate: Item {
                    width: weeklyList.width
                    height: grd.height + day.height + 20

                    // modelData here is an array of strings (the items for that day)
                    readonly property var todayContent: modelData
                    Text {
                        id: day
                        text: (todayContent && todayContent.length > 0) ? "Date: " + todayContent[0].split("|")[0] : ""
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true; color: appData.fg[0];font.pixelSize: 25;font.family: "consolas"
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
                                color:"transparent";border.width: 2;border.color: appData.accent[1]
                                Row {
                                    anchors.fill: parent;spacing:10;padding: 5
                                    Text {id:name; text: parts[1] || ""; width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[2] || "";font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[3] || "";font.family: "consolas"; width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[4] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[5] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[6] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                }
                            }
                        }
                    }
                }
            }
        }

    }

    Component {
        id: monthlyTable
        Item{
            id:monthlyContainer;anchors.fill: parent

            Rectangle{
                id:assets
                width:monthlyList.width
                height:40
                color:appData.bg[0];border.color: appData.accent[0];border.width: 1
                z:6
                anchors.top: parent.top;radius: 5
                anchors.left: monthlyList.left
                Text{anchors.fill: parent;font.bold: true ;font.pixelSize: 20;color:appData.fg[0]
                    text: "Product Name |    Opening Stock  |    Produced   |   BatchNO     |    Sales  |    Closing Stock   |"
                }
            }
            ListView {
                id: monthlyList
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: assets.bottom
                height:statsPage.height*0.95
                model: root.getMonthly()
                spacing: 10
                clip: true

                delegate: Item {
                    width: monthlyList.width
                    height: grd.height + day.height + 20

                    // modelData here is an array of strings (the items for that day)
                    readonly property var todayContent: modelData
                    Text {
                        id: day
                        text: (todayContent && todayContent.length > 0) ? "Date: " + todayContent[0].split("|")[0] : ""
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true; color: appData.fg[0];font.pixelSize: 25;font.family: "consolas"
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
                                color:"transparent";border.width: 2;border.color: appData.accent[1]
                                Row {
                                    anchors.fill: parent;spacing:10;padding: 5
                                    Text {id:name; text: parts[1] || ""; width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[2] || "";font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[3] || "";font.family: "consolas"; width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[4] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[5] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[6] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                }
                            }
                        }
                    }
                }
            }
        }

    }

    Component {
        id: yearlyTable
        Item{
            id:yearlyContainer;anchors.fill: parent

            Rectangle{
                id:assets
                width:yearlyList.width
                height:40
                color:appData.bg[0];border.color: appData.accent[0];border.width: 1
                z:6
                anchors.top: parent.top;radius: 5
                anchors.left: yearlyList.left
                Text{anchors.fill: parent;font.bold: true ;font.pixelSize: 20;color:appData.fg[0]
                    text: "Product Name |    Opening Stock  |    Produced   |   BatchNO     |    Sales  |    Closing Stock   |"
                }
            }
            ListView {
                id: yearlyList
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: assets.bottom
                height:statsPage.height*0.95
                model: root.getYearly()
                spacing: 10
                clip: true

                delegate: Item {
                    width: yearlyList.width
                    height: grd.height + day.height + 20

                    // modelData here is an array of strings (the items for that day)
                    readonly property var todayContent: modelData
                    Text {
                        id: day
                        text: (todayContent && todayContent.length > 0) ? "Date: " + todayContent[0].split("|")[0] : ""
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true; color: appData.fg[0];font.pixelSize: 25;font.family: "consolas"
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
                                color:"transparent";border.width: 2;border.color: appData.accent[1]
                                Row {
                                    anchors.fill: parent;spacing:10;padding: 5
                                    Text {id:name; text: parts[1] || ""; width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[2] || "";font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[3] || "";font.family: "consolas"; width: parent.width/6; height: 50; color:appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[4] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[5] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                    Text { text: parts[6] || ""; font.family: "consolas";width: parent.width/6; height: 50; color: appData.fg[0];font.pixelSize: 15;verticalAlignment: Text.AlignVCenter;font.bold: true}
                                }
                            }
                        }
                    }
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
        color:appData.bg[0]
        Loader{
            anchors.fill: parent
            sourceComponent: currentComponent
        }
    }
    Component.onCompleted: {
        currentComponent=selectView
    }

    function setUpModel(model) {
        switch(model){
            case "Daily":
                currentComponent = dailyTable
                break;
            case "Weekly":
                currentComponent = weeklyTable
                break
            case "Monthly":
                currentComponent = monthlyTable
                break
            case "Yearly":
                currentComponent = yearlyTable
        }
    }
}
