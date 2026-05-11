import QtQuick 2.15
import QtQuick.Controls
Rectangle{
    id:homePage
    color:root.bg[0]
    radius:10
    border.width: 2
    border.color: root.accent[1]
    width:parent.width-8
    visible: topBar.mode === "home"?true:false
    scale: visible === true?1:0
    Behavior on visible {
        NumberAnimation{
            duration:500;
            easing.type: Easing.OutBack
        }
    }Behavior on scale{
        NumberAnimation{
            duration:300;
            easing.type: Easing.OutBack
        }
    }
    anchors{
        top:topBar.bottom
        left:parent.left
        leftMargin: 4
        bottom: bottomBar.top
    }
    Text{
        id:welcome
        text:"Welcome to Goldrich Records ..."
        anchors{
            top:parent.top
            left:parent.left
            margins:10
        }
        scale:parent.scale
        visible:parent.visible
        color:root.fg[0]
        font.pixelSize: 24
        width: parent.width * 0.9
        height:parent.height*0.15
    }
    Text{
        id:homeStatus
        text:storePage.recentText
        visible:parent.visible
        scale:parent.scale
        color:root.fg[0]
        anchors{
            top:parent.top
            topMargin: parent.height*0.35
            horizontalCenter: parent.horizontalCenter
        }

    }
    Button{
        id:addBtn
        text: "Add"
        palette.buttonText: root.fg[0]
        width:parent.width*0.14
        height:parent.height *0.12
        Rectangle{id:addFiller1;color:homePage.color;anchors.fill: parent;}
        Rectangle{id:addFiller2;color:addBtnMouse.pressed?root.bg[3]:(addBtnMouse.containsMouse?root.bg[1]:root.bg[2]);anchors.fill: parent;radius:10}
        MouseArea{id:addBtnMouse;anchors.fill: parent;hoverEnabled: true;onClicked:{root.mode= "store"}}
        anchors{
            centerIn: parent
        }
    }
}
