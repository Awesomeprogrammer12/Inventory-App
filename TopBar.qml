import QtQuick 2.15
import QtQuick.Controls
Rectangle {
    id:topBar
    color:appData.bg[1]
    radius:5
    width:parent.width
    height:parent.height*0.07
    property string mode: appData.mode

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
        StyledButton{
            id:homeButton
            width:parent.width/3
            height:parent.height*0.8
            text:"Home";font.bold: true;font.pixelSize: 10
            font.family: "arial";fg:appData.fg[0]
            bg:appData.bg[2]
            activeBg:appData.bg[3]
            radii:10
            hoveredBg:appData.bg[1]
            onClicked:appData.mode = "home"
        }
        StyledButton{
            id:storeButton
            width:parent.width/3
            height:parent.height*0.8
            text:"Store";font.bold: true;font.pixelSize: 10
            font.family: "arial";fg:appData.fg[0]
            activeBg:appData.bg[3]
            radii:10
            bg:appData.bg[2]
            hoveredBg:appData.bg[1]
            onClicked:appData.mode = "store";
        }
        StyledButton{
            id:statsButton
            width:parent.width/3
            height:parent.height*0.8
            text:"Stats";font.bold: true;font.pixelSize: 10
            font.family: "arial";
            fg:appData.fg[0]
            bg:appData.bg[2]
            activeBg:appData.bg[3]
            radii:10
            hoveredBg:appData.bg[1]
            onClicked:appData.mode = "stats"
        }
    }

    Rectangle{
        id:indicator
        property Item curButton:{
            switch(mode){
            case "store":
                indicator.width=storeButton.width
                return storeButton;
            case "home":
                indicator.width=homeButton.width
                return homeButton;
           default:
                indicator.width=statsButton.width
                return statsButton;
            }
        }
        color:curButton.color
        y:homeButton.height-2
        height:homeButton.height
        radius: 2
        x:curButton.x
        border.color: curButton.bg
    }
    Text{
        id:brandingText
        text:appData.companyName+" Records: "+mode.toUpperCase();
        font.pixelSize: 17
        font.bold: true
        font.family: "arial"
        color:appData.fg[0]
        anchors.centerIn: parent
    }
    Text{
        color:appData.fg[0]
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
