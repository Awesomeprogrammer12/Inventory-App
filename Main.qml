import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
/**
 * @component Main
 * @brief The root component of the Goldrich Inventory Management Application.
 * * This file acts as the main orchestrator, managing the application's themes,
 * loading and parsing backing file data via C++ context properties, and
 * handling secure dialog flows like password registration.
 */
Rectangle {
    id: root
    color: appData.bg[0]
    anchors.fill: parent

    // ==========================================
    // AppData and Models Section
    // ==========================================

    /**
     * @brief Holds global application states, styling themes, and data configurations.
     * this will be changed to Settings in future versions
     */
    Item{
        id: appData
        // category: "ApplicationData"
        // Theme Colors
        property var bg
        property var darkBg: ["#1f1f1f","#282828","#3f3f3f","#6f6f6f"]
        property var lightBg: ["#9F9F9F","#dfdfdf","#bfbfbf","#999999"]
        property var monoBg: ["#1f1f2f","#224467","navyblue","#6f6f7f"]
        property var neonBg: ["#1f1f1f","#1f4f1f","#224422","#679967"]

        property var fg
        property var lightFg: ["black","#1f1f1f"]
        property var darkFg: ["#FFFFFF","#FFFFFF"]
        property var monoFg: ["#FFFFFF","#9f9f9f"]
        property var neonFg: ["#FFFFFF","#999999"]

        property var accent
        property var darkAccent: ["gold","#504050"]
        property var lightAccent: ["#706070","#605060"]
        property var monoAccent: ["#4400FF","#505070"]
        property var neonAccent: ["#00FF00","#507050"]

        property var tableAccent
        property var darkTableAccent: ["#1f1f1f","#373737","#474747"]
        property var lightTableAccent: ["#f2f2f2","#eeeeee","#cccccc"]
        property var monoTableAccent: ["#0f0f1f","#4400FF","#505070"]
        property var neonTableAccent: ["#0f1f0f","#608860","#609960"]

        // Application States
        property var themes: ["Light", "Dark", "Monokai", "Neon"]
        property int theme: permanentStorage.savedTheme
        property string mode: permanentStorage.savedMode
        Settings{
            id:permanentStorage
            property int savedTheme: 0
            property string savedMode:"home"
        }

        //Others..
        property string lineContent
        property string filePath: cpp.filePath
        property string content: cpp.readFile()
        property string yesterdaysHeader: ""
        property int rowCount: inventoryModel.rowCount
        property list<string> names
        property list<string> primaryNames
        property var fontFamily: ["Comic Sans MS", "Consolas"]
        property string companyName: "Goldrich"
        property bool pass: false
        property string passWord

        onCompanyNameChanged: {
            root.updateCompanyName(companyName)
        }
        onThemeChanged: {
            root.updateTheme(theme)
            permanentStorage.savedTheme = theme
        }
        onModeChanged: {
            permanentStorage.savedMode = mode
        }

        onFilePathChanged: {
            if (filePath !== "") {
                console.log("File path received:", filePath)
                content = cpp.readFile();
                console.log("file content received:", content)
                parseFileToTable(content)
            }
        }
    }

    TableMod { id: inventoryModel }

    // UI Views
    TopBar { id: topBar }
    HomePage { id: homePage }
    StorePage { id: storePage }
    StatsPage { id: statsPage }
    BottomBar { id: bottomBar }

    // ==========================================
    // Popups and Dialogs Section
    // ==========================================

    /**
      *@component settingsPageContainer
      *this holds the settings page in a popup Dialog
    */
    Popup {
       id: settingsPageContainer
       anchors.centerIn: parent
       height: parent.height * 0.8
       width: parent.width * 0.8
       modal: true
       background: Rectangle {
           color: appData.bg[2]
           border.color: appData.accent[0]
           border.width: 2
           radius: 5
       }
       SettingsPage { id: settingsPage }
    }

    Dialog {
        id: customDialog
        font.bold: true
        font.pixelSize: 15
        font.family: appData.fontFamily[0]
        title: "Add Password 🔒"
        property bool vis: true
        anchors.centerIn: parent
        modal: true
        closePolicy: Dialog.NoAutoClose
        width: parent.height * 0.7
        height: parent.width * 0.5

        background: Rectangle {
            gradient: Gradient {
                GradientStop { position: 0; color: appData.bg[0] }
                GradientStop { position: 1; color: appData.bg[1] }
            }
            radius: 3
        }

        contentItem: Loader {
            id: contentLoader
            sourceComponent: page1
        }

        Component {
            id: page1
            Label {
                text: "Are you sure you want to continue"
                color: appData.fg[1]
            }
        }

        Component {
            id: page2
            ColumnLayout {
                anchors.fill: parent
                spacing: 10
                property bool done: false

                Label {
                    text: "Enter Your Password"
                    width: parent.width
                    height: parent.height * 0.3
                    background: Rectangle { color: appData.accent[0] }
                    color: appData.fg[1]
                    Layout.fillHeight: true
                }

                Row {
                    id: passField1
                    height: 70
                    Layout.fillWidth: true

                    TextField {
                        id: passwordField1
                        font.pointSize: 20
                        text: ""
                        property var t: passwordField1.text
                        width: parent.width * 0.8
                        height: parent.height
                        leftPadding: 12
                        rightPadding: 48
                        topPadding: 18
                        bottomPadding: 8
                        echoMode: toggleVisible.checked ? TextInput.Password : TextInput.Normal
                        passwordCharacter: "•"

                        background: Rectangle {
                            radius: 5
                            border.color: appData.accent[0]
                            color: appData.bg[0]
                        }

                        onTextChanged: {
                            t = passwordField1.text
                            done = (t.length >= 3);

                            // Enforce max-length of 7 characters gracefully
                            if (t.length > 7) {
                                passwordField1.text = t.substring(0, 7)
                            }
                        }
                    }

                    StyledButton {
                        id: toggleVisible
                        width: parent.width * 0.19
                        height: parent.height
                        property bool checked: true
                        text: "👁️"
                        font.bold: true
                        font.pixelSize: 20
                        onCheckedChanged: { text = !checked ? "🙈" : "👁️" }
                        onClicked: checked = !checked
                    }
                }

                Label {
                    id: recheck
                    text: "Re-Enter your password"
                    color: appData.fg[0]
                    Layout.fillHeight: true
                    visible: done
                }

                TextField {
                    id: passwordField2
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: done
                    enabled: done
                    font.pointSize: 20
                    text: ""
                    property var t2: passwordField2.text
                    leftPadding: 12
                    rightPadding: 12
                    topPadding: 18
                    bottomPadding: 8
                    echoMode: TextInput.Password
                    passwordCharacter: "•"

                    background: Rectangle {
                        radius: 5
                        border.color: appData.accent[0]
                        color: appData.bg[0]
                    }

                    onTextChanged: {
                        t2 = passwordField2.text
                        if (t2.length > 7) {
                            passwordField2.text = t2.substring(0, 7)
                        }

                        if (passwordField1.text === passwordField2.text) {
                            confirmAction.visible = true
                            confirmAction.text = 'Register as "permanent" password'
                            appData.passWord = passwordField1.text
                        } else {
                            confirmAction.visible = false
                            confirmAction.text = "Confirm"
                            appData.passWord = ""
                        }
                    }
                }
            }
        }

        footer: Item {
            height: 100
            width: parent.width
            scale: 0.95

            StyledButton {
                id: confirmAction
                width: parent.width * 0.7
                height: parent.height
                text: "Confirm"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors {
                    bottom: parent.bottom
                    right: exitDialog.left
                    rightMargin: 10
                }
                bg: appData.bg[2]
                activeBg: appData.bg[1]
                hoveredBg: appData.bg[3]
                visible: true
                font.bold: true
                font.pixelSize: 13
                fg: appData.fg[1]

                onClicked: {
                    switch(contentLoader.sourceComponent) {
                        case page1:
                            contentLoader.sourceComponent = page2
                            confirmAction.visible = false
                            return;
                        case page2:
                            root.parsePassword(appData.passWord)
                            settingsPageContainer.close()
                            customDialog.close()
                    }
                }
                scale: 0.95
            }

            StyledButton {
                id: exitDialog
                width: parent.width * 0.2
                height: parent.height
                text: "❌"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                font.pixelSize: 20
                fg: appData.fg[1]
                activeBg: "red"
                bg: appData.bg[3]
                hoveredBg: "lightred"
                onClicked: { settingsPageContainer.close(); customDialog.close() }
            }
        }
        padding: 10
    }

    // ==========================================
    // JavaScript Core Logic Functions
    // ==========================================

    /**
     * @brief Parses raw inventory file content and populates the Table model.
     * @param fileContent The raw string chunk read directly from the C++ file system layer.
     */
    function parseFileToTable(fileContent) {
        console.log("the file: " + fileContent);
        if (fileContent === "") return;

        var todayHeader = Qt.formatDate(new Date(), "yyyy-MM-dd")
        var tempRows = []
        var rowLines = fileContent.split("\n").filter(line => line.trim() !== "");
        var today = false;

        appData.yesterdaysHeader = ""

        for (var i = 0; i < rowLines.length; i++) {
            var line = rowLines[i].trim();
            var parts = line.split('|');

            if (parts[0] === todayHeader && parts.length >= 7 ) {
                tempRows.push({
                    "Date": parts[0].trim(),
                    "productName": parts[1].trim(),
                    "openingStock": parseInt(parts[2]),
                    "produced": parseInt(parts[3]),
                    "bn": parts[4].trim(),
                    "sales": parseInt(parts[5]),
                    "closingStock": parseInt((parseInt(parts[2]) + parseInt(parts[3])) - parseInt(parts[5]))
                })
                today = true;
            }
            else if (!today) {
                appData.yesterdaysHeader = parts[0]
                if (appData.yesterdaysHeader !== todayHeader) break;
            }
        }

        if (appData.yesterdaysHeader !== "") {
            for (i = 0; i < rowLines.length; ++i) {
                line = rowLines[i];
                parts = line.split("|")
                if (parts[0] === appData.yesterdaysHeader && parts.length >= 7) {
                    tempRows.push({
                        "Date": todayHeader,
                        "productName": parts[1],
                        "openingStock": parseInt(parts[6]),
                        "produced": 0,
                        "bn": parts[4].trim(),
                        "sales": 0,
                        "closingStock": parseInt((parseInt(parts[6]) + 0) - parseInt(parts[5]))
                    })
                    cpp.rowtoFile(todayHeader, parts[1], parseInt(parts[6]), 0, parts[4].trim(), 0)
                }
            }
        }
        var header = inventoryModel.getRow(0);
        inventoryModel.rows = [header].concat(tempRows);
    }

    /**
     * @brief Iterates through the active visual UI inventory model and exports the modifications back to the file system.
     */
    function parseTableToFile() {
        for (var row = 1; row < inventoryModel.rowCount(); ++row) {
            var lineContent = inventoryModel.getRow(row)
            cpp.rowtoFile(lineContent.Date,
                          lineContent.productName,
                          lineContent.openingStock,
                          lineContent.produced,
                          lineContent.bn,
                          lineContent.sales)
        }
    }

    /**
     * @brief Fetches initial data values for a specific item item.
     * @param name The product name identifier.
     * @return int The quantity of starting stock.
     */
    function getOpeningStock(name) {
        return cpp.getOpeningStock(name);
    }

    /**
     * @brief Directly interfaces with C++ to save a single row entry.
     */
    function rowToFile(date, productName, openingStock, produced, batchNo, sold) {
        cpp.rowtoFile(date, productName, openingStock, produced, batchNo, sold)
    }

    /** @brief Triggers a hard reload from the C++ file buffer. */
    function updateContent() { appData.content = cpp.readFile(); }

    // Analytics Fetches
    function getDaily() { return cpp.getDaily(); }
    function getWeekly() { return cpp.getWeekly(); }
    function getMonthly() { return cpp.getMonthly(); }
    function getYearly() { return cpp.getYearly(); }

    /** @brief Opens up the administrative credentials dialogue view. */
    function addPassword() { customDialog.open() }

    /**
     * @brief Handles password validation.
     * @param passkey The text password string to secure.
     */
    function parsePassword(passkey) {}

    /**
     * @brief Sets corporate branding properties natively.
     * @param name Name of the enterprise.
     */
    function updateCompanyName(name) {
        cpp.setTitle(appData.companyName)
    }

    /**
     * @brief Switches systemic UI themes dynamically.
     * @param theme Index integer mapping to (0: Light, 1: Dark, 2: Monokai, 3: Neon)
     */
    function updateTheme(theme) {
        if (theme === 0) { appData.bg = appData.lightBg; appData.fg = appData.lightFg; appData.accent = appData.lightAccent; appData.tableAccent = appData.lightTableAccent }
        if (theme === 1) { appData.bg = appData.darkBg;  appData.fg = appData.darkFg;  appData.accent = appData.darkAccent;  appData.tableAccent = appData.darkTableAccent }
        if (theme === 2) { appData.bg = appData.monoBg;  appData.fg = appData.monoFg;  appData.accent = appData.monoAccent;  appData.tableAccent = appData.monoTableAccent }
        if (theme === 3) { appData.bg = appData.neonBg;  appData.fg = appData.neonFg;  appData.accent = appData.neonAccent;  appData.tableAccent = appData.neonTableAccent }
    }
}
