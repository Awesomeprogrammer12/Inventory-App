import QtQuick 2.15
import QtQuick.Controls
Rectangle{
    id:bottomBar
    height:root.height/8.5
    width:root.width
    color:root.bg[1]
    radius:10
    border.width: 2
    border.color: root.accent[1]
    anchors{
        bottom:root.bottom
    }
}
