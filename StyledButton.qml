import QtQuick

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
    property int radii: (height + width )*0.2
    property string borderColor:bg
    property string text : ""
    property string font : "sans-serif"
    property int fontSize: 12
    property int dur: 300
    radius:radii
    border.color: borderColor
    color:mouse.pressed?activeBg:(mouse.containsMouse?hoveredBg:bg)
    Behavior on color{
        ColorAnimation{
            duration:dur
            easing.type: Easing.OutBack
        }
    }

    Text{
        id:styledText;anchors.centerIn: parent;text:styledButton.text
        color:mouse.pressed?activeFg:(mouse.containsMouse?hoveredFg:fg)
        Behavior on color{
            ColorAnimation{
                duration:dur
                easing.type: Easing.OutBack
            }
        }
        wrapMode: Text.Wrap;font.family: styledButton.font;font.pixelSize: styledButton.fontSize
    }
    signal clicked()
    MouseArea{id:mouse;anchors.fill: parent;hoverEnabled: true ;onClicked: styledButton.clicked() }
}
