import QtQuick 2.15
import QtQuick.Controls
Rectangle {
    id:topBar
    color:root.bg[1]
    radius:5
    width:root.width
    height:root.height*0.07
    property string mode: root.mode

    anchors{
        top:parent.top
        margins: 8
    }
    Row{
        id:navigationButtons
        width:parent.width*0.3
        height:parent.height*0.8
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 20
        spacing:5
        Button{
            id:homeButton
            width:parent.width/3
            height:parent.height*0.8
            text:"Home";font.bold: true;font.pixelSize: 10
            font.family: "arial";palette.buttonText:root.fg[0]
            Rectangle{id:homeFiller1;color:root.bg[1];anchors.fill: parent;}
            Rectangle{id:homeFiller2;color:homeButtonMouse.pressed?root.bg[3]:(homeButtonMouse.containsMouse?root.bg[1]:root.bg[2]);anchors.fill: parent;radius:10}
            MouseArea{id:homeButtonMouse;anchors.fill: parent;hoverEnabled: true;onClicked:{root.mode = "home"}}
        }
        Button{
            id:storeButton
            width:parent.width/3
            height:parent.height*0.8
            text:"Store";font.bold: true;font.pixelSize: 10
            font.family: "arial";palette.buttonText:root.fg[0]
            Rectangle{id:storeFiller1;color:root.bg[1];anchors.fill: parent;}
            Rectangle{id:storeFiller2;color:storeButtonMouse.pressed?root.bg[3]:(storeButtonMouse.containsMouse?root.bg[1]:root.bg[2]);anchors.fill: parent;radius:10}
            MouseArea{id:storeButtonMouse;anchors.fill: parent;hoverEnabled: true;onClicked:{root.mode = "store";}}
        }
        Button{
            id:statsButton
            width:parent.width/3
            height:parent.height*0.8
            text:"Stats";font.bold: true;font.pixelSize: 10
            font.family: "arial";palette.buttonText:root.fg[0]
            Rectangle{id:statsFiller1;color:root.bg[1];anchors.fill: parent;}
            Rectangle{id:statsFiller2;color:statsButtonMouse.pressed?root.bg[3]:(statsButtonMouse.containsMouse?root.bg[1]:root.bg[2]);anchors.fill: parent;radius:10}
            MouseArea{id:statsButtonMouse;anchors.fill: parent;hoverEnabled: true;onClicked:{ root.mode = "stats";}}
        }
    }

    Rectangle{
        id:indicator
        color:root.bg[2]
        y:homeButton.height-2
        height:homeButton.height*2
        x:{if(mode === "store"){indicator.width=storeButton.width
                return storeButton.x;}
            if(mode === "home"){indicator.width=homeButton.width
                return homeButton.x;}
            else{indicator.width=statsButton.width
                return statsButton.x;}}
        Behavior on x{NumberAnimation{duration:200;easing.type:Easing.OutQuad}}
    }
    Text{
        id:brandingText
        text:"Goldrich Records: "+mode.toUpperCase();
        font.pixelSize: 17
        font.bold: true
        font.family: "arial"
        color:root.fg[0]
        anchors.centerIn: parent
    }
    Text{
        color:root.fg[0]
        width:50
        height:parent.height
        text : Qt.formatDate(new Date(), "yyyy-MM-dd")
        font.bold: true
        font.pixelSize: 10
        font.family: "arial"
        anchors{
            right:parent.right
            margins:10
            top:parent.top
        }
    }
}
