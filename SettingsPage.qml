import QtQuick 2.15
import QtQuick.Controls 2.15
/**
  *@component settingsPage
  *@brief The settings page component works with the Main Component
  *to edit Application States Themes and Colors
*/
Rectangle {
    anchors.fill: parent
    color: appData.accent[1]
    // Hold a reference to the active button item
    property Item settingsMode: null
    Row{
        anchors.fill: parent
        spacing:1
        Rectangle {
            id: sideBar
            height: parent.height
            width: parent.width * 0.2
            radius: 5
            color: appData.bg[1]

            Column {
                id: buttonColumn
                anchors.fill: parent
                spacing: 10
                anchors.margins: 10

                Repeater {
                    id: optionsRepeater
                    model: ["Theme", "Security", "About"]

                    StyledButton {
                        // REMOVED: Component.onCompleted from here
                        text: modelData
                        height: parent.height * 0.1
                        width: parent.width * 0.9
                        radii: 5
                        bg: appData.bg[0]
                        hoveredBg: appData.bg[2]
                        activeBg: appData.bg[1]
                        font.bold: true
                        font.pixelSize: 13
                        fg:appData.fg[1]
                        onClicked: {
                            // Reset the old active button background
                            if (settingsMode) {
                                settingsMode.bg = appData.bg[0]
                            }
                            // Set this clicked button as active
                            settingsMode = this
                            settingsMode.bg = appData.bg[3]
                        }
                    }
                }
                Component.onCompleted: {
                    if (optionsRepeater.count > 0) {
                        var firstButton = optionsRepeater.itemAt(0)
                        settingsMode = firstButton
                        settingsMode.bg = appData.bg[3]
                    }
                }
            }
            Rectangle {
                id: follower
                color: appData.accent[0]
                height: settingsMode ? settingsMode.height * 0.56 : 0
                width: 4
                z: 1
                x: 5
                radius: 2
                // Added a safety check (settingsMode ? ... : 0) to prevent errors before initialization
                y: settingsMode ? sideBar.mapFromItem(settingsMode, 0, 0).y + (settingsMode.height / 2 - height / 2) : 0
                Behavior on y {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }
        }
        Loader{
            id:view
            height:parent.height
            width:parent.width*0.8
            sourceComponent: {
                if(settingsMode.text === "Theme")return themeSettings
                else if(settingsMode.text === "Security")return securitySetting
                else{return aboutSettings}
            }
        }
        Component{
            id:themeSettings
            Flickable{
                id:themeScroll
                StyledButton{
                    id:option
                    text:appData.themes[appData.theme+1]+" Theme 🌓"
                    height:70
                    width:parent.width*0.9
                    bg:appData.bg[0]
                    activeBg: appData.bg[1]
                    hoveredBg: appData.bg[2]
                    fg:appData.fg[1]
                    fontName: appData.fontFamily[0]
                    fontSize: 20
                    y:30;
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:{
                        var themes = appData.themes
                        for(var i = 0; i < themes.length; i++ ){
                            if(appData.theme === i){
                                if(i+1 < themes.length)appData.theme = i+1
                                else{appData.theme = 0}
                                break
                            }
                        }

                    }
                }
            }
        }
        Component{
            id:securitySetting
            Flickable{
                id:securityScroll
                StyledButton{
                    id:option
                    text:"Add Password 🔒"
                    height:70
                    width:parent.width*0.9
                    bg:appData.bg[0]
                    activeBg: appData.bg[1]
                    hoveredBg: appData.bg[2]
                    fg:appData.fg[1]
                    fontName: appData.fontFamily[0]
                    fontSize: 20
                    y:30;
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:root.addPassword()
                }
            }
        }
        Component{
            id:aboutSettings
            Flickable{
                id:aboutScroll
                TextArea{
                    id:about
                    font.bold: true;font.family: appData.fontFamily[0];font.pixelSize: 15;color:appData.fg[0];
                    background: Rectangle{color:appData.bg[0];radius: 5;border.color: appData.accent[1]}
                    anchors.horizontalCenter: parent.horizontalCenter;
                    width:parent.width
                    implicitHeight:parent.height*0.4
                    horizontalAlignment: Text.AlignVCenter
                    text:"This app was made by Awesome Effiong  using the qt library the UI is made in qml\n and backend is made in C++ this app is for recording production in a bussiness"
                    onTextChanged: {
                        text="This app was made by Awesome Effiong \n using the qt library the UI is made in qml\n and backend is made in C++ this app is\n for recording production in a bussiness"
                    }
                }
                Rectangle{
                    id:changeCompanyName
                    anchors.top:about.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    height:200;width:parent.width;
                    color:appData.bg[0]
                    Column{
                     anchors.fill: parent
                     spacing: 10
                        Label{
                            id:changeCompanyNamePrompt
                            text:"Enter new Company Name";font.underline: true
                            font.bold: true;font.family: appData.fontFamily[1];
                            font.pixelSize: 20;verticalAlignment: Text.AlignVCenter
                            background:Rectangle{color:appData.bg[0]}
                            color:appData.fg[0]
                            anchors.horizontalCenter:parent.horizontalCenter
                        }
                        TextField{
                            id:newCompanyName
                            placeholderText: "Enter your Company Name"
                            font.bold: true;font.family: appData.fontFamily[1];font.pixelSize: 20
                            width:parent.width;background:Rectangle{color:appData.bg[0];border.color: appData.fg[1];radius:7}
                            horizontalAlignment: Text.AlignHCenter;color:appData.fg[0]
                        }
                        StyledButton{
                            id:saveNewNameButton
                            text:'Save Company Name'
                            width:parent.width
                            height:70;fg:appData.fg[0]
                            bg:appData.bg[1]
                            hoveredBg: appData.bg[2]
                            activeBg: appData.bg[0]
                            onClicked: {
                                appData.companyName = newCompanyName.text
                                console.log(appData.companyName)
                                console.log(newCompanyName.text)
                            }
                        }
                    }
                }
            }
        }
    }
}
