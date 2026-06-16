import QtQuick 2.15
import QtQuick.Controls
Rectangle{
    id:homePage
    color:appData.bg[0]
    radius:10
    border.width: 2
    border.color: appData.accent[1]
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
    Label{
        id:welcome
        text:"Welcome to "+appData.companyName+" Records ..."
        anchors{
            top:parent.top
            left:parent.left
            margins:10
        }

        scale:parent.scale
        visible:parent.visible
        color:appData.fg[0]
        font.pixelSize: 24
        font.bold: true
        font.family: appData.fontFamily[0]
        width: appData.width * 0.9
        height:appData.height*0.15
    }
    Label{
        id:homeStatus
        text:storePage.recentText
        visible:parent.visible
        scale:parent.scale
        color:appData.fg[0]
        anchors{
            verticalCenter: parent.verticalCenter
            right:parent.right
            rightMargin: 60
        }
        background: Rectangle {
            scale:1.2
            color: "transparent"
            border.color: appData.accent[1]
            border.width: 2
            radius: 4
        }
    }
    StyledButton{
        id:addBtn
        text:"Add"
        fg:appData.fg[0]
        width:parent.width*0.24
        height:parent.height*0.21
        bg:appData.bg[2]
        hoveredBg:appData.bg[1]
        activeBg: appData.bg[3]
        onClicked: appData.mode = "store"
        radius:10
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 30
        }
    }
}
