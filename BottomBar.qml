import QtQuick 2.15
import QtQuick.Controls
Rectangle{
    id:bottomBar
    height:parent.height*0.1
    width:parent.width
    color:appData.bg[1]
    radius:10
    border.width: 2
    border.color: appData.accent[1]
    anchors{
        bottom:parent.bottom
    }
    StyledButton{
        id:settingsButton
        width:bottomBar.height*0.8
        height:width
        icon.source: "qrc:/qml/settings.png"
        icon.width: settingsButton.width * 0.5
        icon.height: settingsButton.width * 0.5
        icon.color: "white"
        bg:appData.bg[0]
        activeBg: appData.bg[1]
        text:"Settings"
        font.bold: true
        font.pixelSize:10
        font.family: appData.fontFamily[1]
        display: Button.TextUnderIcon
        onClicked:{
            settingsPageContainer.visible = true
        }

        anchors{
            left:parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }
    }
}
