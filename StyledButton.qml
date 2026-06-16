import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl

Rectangle {
    id:styledButton
    //width/height
    property list<int> dimensions : [60,100]
    width:dimensions[0];height:dimensions[1]
    property list<int> coords : [0,0]
    x:coords[0];y:coords[1]
    property string bg: "#1f1f2f"
    property string fg : "#dfdfcd"
    property string hoveredBg : bg
    property string hoveredFg : fg
    property string activeBg : bg
    property string activeFg : fg
    property int radii: (height + width )*0.1
    property string borderColor:bg
    property string text : ""
    property string fontName : "sans-serif"
    property int fontSize: 12
    property int dur: 300

    property alias icon: label.icon
    property alias font: label.font
    property int display: IconLabel.TextBesideIcon
    property real spacing: 8

    radius:radii
    border.color: borderColor
    color:mouse.pressed?activeBg:(mouse.containsMouse?hoveredBg:bg)
    Behavior on color{
        ColorAnimation{
            duration:dur
            easing.type: Easing.OutBack
        }
    }
    IconLabel {
            id: label
            anchors.centerIn: parent
            anchors.margins: 4
            text: styledButton.text
            display: styledButton.display
            spacing: styledButton.spacing
            font.family: styledButton.fontName
            font.pixelSize: styledButton.fontSize
            font.bold: true//default
            color: mouse.pressed ? activeFg : (mouse.containsMouse ? hoveredFg : fg)

            Behavior on color {
                ColorAnimation {
                    duration: dur
                    easing.type: Easing.OutBack
                }
            }
        }

    signal clicked()
    MouseArea{id:mouse;anchors.fill: parent;hoverEnabled: true ;onClicked: styledButton.clicked() }
    function resetBg(newbg){
        bg = newbg
        hoveredBg = newbg
        activeBg = newbg
    }
}
