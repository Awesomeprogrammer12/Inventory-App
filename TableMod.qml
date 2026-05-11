import QtQuick 2.15
import QtQuick.Controls
import Qt.labs.qmlmodels 1.0
TableModel {
    id: inventoryModel
    TableModelColumn { display: "Date"}
    TableModelColumn { display: "productName" }
    TableModelColumn { display: "openingStock" }
    TableModelColumn { display: "produced" }
    TableModelColumn { display: "bn" }
    TableModelColumn { display: "sales" }
    TableModelColumn { display: "closingStock" }
    rows: [
        {Date:"Date",productName : "Product Name", openingStock: "Opening Stock", produced: "Produced", bn:"Batch No.",sales: "Sales", closingStock: "Closing Stock"},
    ]
    onRowCountChanged: {
        for(var row = 1; row < rowCount; ++row){
            var currentRow = inventoryModel.getRow(row)
            names.push(currentRow.productName);
            console.log("productaname:",currentRow.productName)
        }
        storePage.reload();console.log("names:",names)
    }
}
