import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
Rectangle{
    id:root
    property list<string> bg : ["#1f1f1f","#2f2f2f","#3f3f3f","6f6f6f"]
    property list<string> fg : ["white","black"]
    property list<string> accent: ["gold","purple"]
    property string mode :"stats"
    property string lineContent;
    property string filePath: cpp.filePath
    property string content :cpp.readFile();
    property string yesterdaysHeader : ""
    property int rowCount : inventoryModel.rowCount
    property list<string> names
    property list<string> primaryNames
    onFilePathChanged: {
        if (filePath !== "") {
            console.log("File path received:", filePath)
            content = cpp.readFile();
            console.log("file content recieved:", content)
            parseFiletoTable(content)
        }
    }
    color:bg[0]
    anchors.fill: parent
    TopBar{id:topBar}
    HomePage{id:homePage}
    StorePage{id:storePage}
    StatsPage{id:statsPage}
    BottomBar{id:bottomBar}
    TableMod{id:inventoryModel}

    function parseFiletoTable(fileContent){
        console.log("the file: "+fileContent);
        if(fileContent === "")return;
        var todayHeader = Qt.formatDate(new Date(),"yyyy-MM-dd")
        var tempRows = []
        var rowLines = fileContent.split("\n").filter(line => line.trim() !== "");//every new line is a new row
        var today = false;
        yesterdaysHeader = ""
        for (var i = 0; i < rowLines.length; i++) {
            //split every row into 7 parts |Date|product|Opening Stock|Produced|Batch No|Sales|Closing Stock|
            var line = rowLines[i].trim();
            var parts = line.split('|');
            console.log("in for loop split files int o"+line)
            console.log(parts)
            console.log(todayHeader)
            if (parts[0] === todayHeader && parts.length >= 7 ){
                console.log("today stuff ->",parts)
                tempRows.push({
                    "Date"       :  parts[0].trim(),
                    "productName":  parts[1].trim(),
                    "openingStock": parseInt(parts[2]),
                    "produced":     parseInt(parts[3]),
                    "bn":           parts[4].trim(),
                    "sales":        parseInt(parts[5]),
                    "closingStock": parseInt((parseInt(parts[2])+parseInt(parts[3]))- parseInt(parts[5]))
                })
                today = true;
            }
            else if(!today){
                yesterdaysHeader = parts[0]
                console.log("yesterdsays header:"+yesterdaysHeader)
                if(yesterdaysHeader !== todayHeader)break;
            }
        }
        if(yesterdaysHeader !== ""){
            console.log("finding yesterdays header content")
            for (i = 0; i < rowLines.length; ++i){
                line = rowLines[i];
                parts = line.split("|")
                console.log("yesterday",parts)
                if(parts[0] === yesterdaysHeader && parts.length >= 7){
                    tempRows.push({
                        Date       :  todayHeader,
                        "productName":  parts[1],
                        "openingStock": parseInt(parts[6]),
                        "produced":    0,
                        "bn":           parts[4].trim(),
                        "sales":        0,
                        "closingStock": parseInt((parseInt(parts[6])+0)- parseInt(parts[5]))
                    })
                    cpp.rowtoFile(todayHeader,parts[1],parseInt(parts[6]),0,parts[4].trim(),0)
                }
            }
        }
        var header = inventoryModel.getRow(0);
        inventoryModel.rows = [header].concat(tempRows);
    }
    function parseTabletoFile(){
        for(var row = 1; row<inventoryModel.rowCount();++row){
            var lineContent = inventoryModel.getRow(row)
            // Inside parseTabletoFile
            cpp.rowtoFile(lineContent.Date,
                          lineContent.productName,
                          lineContent.openingStock,
                          lineContent.produced,
                          lineContent.bn,
                          lineContent.sales)
        }
    }
    function getOpeningStock(name){
        return cpp.getOpeningStock(name);
    }
    function rowToFile(date, productName, openingStock,produced, batchNo, sold){
        cpp.rowtoFile(date, productName, openingStock,produced, batchNo, sold)
    }
    function updateContent(){
        root.content = cpp.readFile();
    }
    function getDaily(){
        return cpp.getDaily();
    }
}



























