import QtQuick 2.15
import QtQuick.Controls
import Qt.labs.qmlmodels 1.0
Rectangle {
    color:appData.accent[1]
    width:parent.width
    visible: appData.mode === "store"?true:false
    scale: visible?1:0
    radius:10
    border.color:appData.accent[0]
    border.width: 2
    property string recentText : "Haven't Added Anything yet, Pls Add a Record!!"
    property double closingStock: 0
    property double openingStock:0
    property double produced:0
    property double  sales:0
    z:visible?2:-1//overlap the top bar navigation butons indicator
    anchors{
        top:topBar.bottom
        bottom: bottomBar.top
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
    Rectangle{
        id:inputFields
        anchors.left:parent.left
        height: parent.height
        width:250
        color:appData.bg[2]
        border.color:appData.accent[0]
        border.width: 2
        Text{id:prompt;text:"  Fill the following information: ";font.bold: true;font.family: "Comic Sans MS";font.pixelSize: 19;color:appData.fg[0];x:0;y:10}
        Column{
            id:productNamePrompt
            width:parent.width*0.8
            height:parent.height*0.1
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.left: parent.left
            anchors.top:prompt.bottom
            anchors.topMargin: 20
            anchors.leftMargin: 20
            spacing :5
            Text{id:productName; text:"Enter product name: ";font.pixelSize: 20;font.bold: true;color:appData.fg[0]}
            TextField{id:productEdit;placeholderText: qsTr(productName.text);font.pixelSize: 16;font.bold: true;mouseSelectionMode: Qt.PointingHandCursor;width:parent.width
                background: Rectangle{color:appData.bg[3];border.color: appData.fg[0];radius:7}
                onTextChanged: {
                    var txt = productEdit.text
                    var matches = false
                    for(var i = 0 ;i< appData.names.length; ++i){
                        if(appData.names[i]  === txt){
                            matches = true
                        }
                    }if(matches){
                        append.text = "Update"
                        prompt.text = "Edit the Following Info:"
                        producedName.text = "Add to Quantity produced (pcks):"
                        batchNo.text = "Update Batch No:"
                        salesNO.text = "Update No of Sales:"
                    }else{
                        append.text = "Add"
                        prompt.text = "Fill in the Following Info:"
                        producedName.text = "Enter Quantity produce (pcks):"
                        batchNo.text = "Enter Batch No:"
                        salesNO.text = "Enter Quantity sold:"
                    }
                }
            }
        }
        Column{
            id:producedPrompt
            width:parent.width*0.8
            height:parent.height*0.1
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.left: parent.left
            anchors.top:productNamePrompt.bottom
            anchors.topMargin: 20
            anchors.leftMargin: 20
            spacing :5
            Text{id:producedName; text:"Enter Quantity produce (pcks): ";font.pixelSize: 20;font.bold: true;color:appData.fg[1]}
            TextField{id:producedEdit;placeholderText: qsTr(producedName.text);font.pixelSize: 18;color:appData.fg[1];font.bold: true;mouseSelectionMode: Qt.PointingHandCursor;width:parent.width;validator: DoubleValidator { bottom: 0; top: 1000000 }
            background: Rectangle{color:appData.bg[3];border.color: appData.fg[0];radius:7}}
        }
        Column{
            id:batchNoPrompt
            width:parent.width*0.8
            height:parent.height*0.1
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.left: parent.left
            anchors.top:producedPrompt.bottom
            anchors.topMargin: 20
            anchors.leftMargin: 20
            spacing :5
            Text{id:batchNo; text:"Enter Batch No: ";font.pixelSize: 20;font.bold: true}
            TextField{id:batchEdit;placeholderText: qsTr(batchNo.text);font.pixelSize: 18;color:appData.fg[1];font.bold: true;mouseSelectionMode: Qt.PointingHandCursor;width:parent.width
            background: Rectangle{color:appData.bg[3];border.color: appData.fg[0];radius:7}
            }
        }
        Column{
            id:salesPrompt
            width:parent.width*0.8
            height:parent.height*0.1
            anchors.top: batchNoPrompt.bottom
            anchors.topMargin: 10
            spacing :5
            anchors.left:parent.left
            anchors.leftMargin: 20
            Text{id:salesNO; text:"Enter Quantity sold: ";font.pixelSize:20;font.bold: true;color:appData.fg[1]}
            TextField{id:salesEdit;placeholderText: qsTr(salesNO.text);font.pixelSize: 18;font.bold: true;mouseSelectionMode: Qt.PointingHandCursor;
                background: Rectangle{color:appData.bg[3];border.color: appData.fg[0];radius:7;}
                width:parent.width;color:appData.fg[1];validator: DoubleValidator { bottom: 0; top: 1000000 }
            }
        }
        Button{
            id:append
            text:"Add"
            anchors{
                bottom:parent.bottom
                bottomMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            palette.buttonText: appData.fg[0]
            width:parent.width*0.8
            height:parent.height*0.2
            Rectangle{id:appendColor;color:inputFields.color;anchors.fill: parent;}
            Rectangle{id:appendFiller2;color:appendButtonMouse.pressed?appData.bg[3]:(appendButtonMouse.containsMouse?appData.bg[2]:appData.bg[1]);anchors.fill: parent;radius:20;border.color: appData.bg[1]}
            MouseArea{id:appendButtonMouse;anchors.fill: parent;hoverEnabled: true;
                onClicked:{
                    console.log("**Searching text Fields***")
                    var date = Qt.formatDate(new Date(),"yyyy-MM-dd");
                    var product = productEdit.text;
                    produced = Number(producedEdit.text) || 0; // Ensure it's a number
                    var BN = batchEdit.text;
                    sales = Number(salesEdit.text) || 0;
                    console.log(`Date ${date}\n product ${product} \n produced ${produced} \n Bn ${BN} \n Sales:${sales}`)
                    openingStock = root.getOpeningStock(product);
                    closingStock = openingStock + produced - sales;
                    if(date === "" || product === "" || BN === ""){
                        console.warn("Missing Fields");
                        return;
                    }
                    if(append.text === "Add"){
                        root.rowToFile(date, product, openingStock, produced, BN, sales);
                    }else{
                        var i = 0
                        for(i; i < inventoryModel.rowCount; ++i){
                            if(inventoryModel.getRow(i).productName === product){
                                console.log(inventoryModel.getRow(i).productName)
                                break;
                            }
                            console.log("not found",inventoryModel.getRow(i).productName)
                        }
                        var prvProduced = parseInt(inventoryModel.getRow(i).produced)
                        var prvSales = parseInt(inventoryModel.getRow(i).sales)
                        var curProduced = prvProduced + produced
                        var curSales = prvSales + sales
                        root.rowToFile(date, product, openingStock, curProduced, BN, curSales);
                    }
                    appData.rowCount = inventoryModel.rowCount;
                    updateContent()
                    root.parseFileToTable(appData.content)
                }
            }
        }
    }
    function reload(){
        tableView.model = inventoryModel
    }

    TableView {
        id: tableView
        anchors{
            left: inputFields.right
            top:parent.top
            bottom: parent.bottom
            right: parent.right
            leftMargin: 3
            topMargin: 3
        }
        clip: true
        model: inventoryModel

        columnWidthProvider: function (column) {
            if(column=== 0){return Math.max(50,tableView.width / 7)-30}
            return Math.max(50,tableView.width / 7)+4
        }
        rowHeightProvider: function (row) {
            if(row === 0){return 60}
            return Math.max(60, (tableView.height / (appData.rowCount-1))-35)
        }
        delegate: Rectangle {
            border.color: appData.bg[1]
            color: model.row === 0 ? appData.tableAccent[0] :(model.row % 2 === 1?appData.tableAccent[1]:appData.tableAccent[2])
            radius:8
            Flickable{
                width:parent.width;height:parent.height
                contentWidth:tField.width; contentHeight:tField.height
                clip:true
                TextField {id:tField
                    color:appData.fg[0]
                    verticalAlignment: TextInput.AlignVCenter
                    horizontalAlignment: TextInput.AlignHCenter
                    font.bold: true
                    background: Rectangle{color:"transparent"}
                    font.pixelSize: 15
                    font.family: "Consolas"
                    readOnly:true
                    text: display
                    selectByMouse: true
                    onAccepted: {
                        inventoryModel.setRow(model.row, { [model.columnName]: text })
                    }
                }
            }
        }
        onWidthChanged: forceLayout()
        onHeightChanged: forceLayout()
    }
}
