#include "widget.h"

Widget::Widget(QWidget *parent)
    : QWidget(parent){
    QCoreApplication::setOrganizationName("MyCompany");
    QCoreApplication::setOrganizationDomain("mycompany.com"); // Good practice to add
    QCoreApplication::setApplicationName("ProductionRecordsApp");

    view = new QQuickView();
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->rootContext()->setContextProperty("cpp",this);
    container = QWidget::createWindowContainer(view, this);
    container->setMinimumSize(400,300);
    view->setSource(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    layout = new QVBoxLayout(this);
    layout->setContentsMargins(0, 0, 0, 0);
    layout->addWidget(container);
    this->setLayout(layout);
    this->setMinimumSize(700,700);
    this->setGeometry(50,50,800,600);
    setWindowTitle(title);
    setUpFile();
}
Widget::~Widget()
{
}

void Widget::setTitle(QString titl)
{
    this->setWindowTitle(titl+" Production Records");
    title = titl;
}

 QList<QStringList> Widget::getDaily()
{
    QFile file(filePath());
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return {};
    }

    // Use a Map to group lines by their date (parts[0])
    // QMap is automatically sorted by key (date)
    QMap<QString, QStringList> groups;

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList parts = line.split("|", Qt::SkipEmptyParts);
        if (parts.size() > 0) {
            groups[parts[0]].append(line);
        }
    }

    // Return just the lists of lines
    QList<QStringList> result = groups.values();
    std::reverse(result.begin(), result.end());
    return result;
}


QList<QStringList> Widget::getWeekly()
{
    QFile file(filePath());
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) return {};

    QMap<QString, QStringList> groups;
    // Map each week identifier to a list of product names already processed for that week
    QMap<QString, QStringList> seenProductsPerWeek;

    QTextStream in(&file);
    while(!in.atEnd()){
        QString line = in.readLine();
        QStringList parts = line.split("|", Qt::SkipEmptyParts);

        // Ensure we have a valid line format (Date|Name|...)
        if(parts.size() >= 2){
            QDate date = QDate::fromString(parts[0], "yyyy-MM-dd");
            if(date.isValid()){
                int weekNum, yearNum;
                weekNum = date.weekNumber(&yearNum);
                QString weekKey = QString("%1-%2").arg(yearNum)
                                      .arg(weekNum, 2, 10, QChar('0'));

                QString productName = parts[1];

                // If this product hasn't been added to this specific week yet
                if(!seenProductsPerWeek[weekKey].contains(productName)) {
                    groups[weekKey].append(line);
                    seenProductsPerWeek[weekKey].append(productName);
                }
            }
        }
    }
    file.close();

    // Convert map to a list and reverse it to get latest weeks first
    QList<QStringList> result = groups.values();
    std::reverse(result.begin(), result.end());
    return result;
}
/* returns this list of latest weekly entries
 * {
 * "date|name.....,
 * "date|name.....,
 * "date|name.....,
 *}
 */


QList<QStringList> Widget::getMonthly()
{
    QFile file(filePath());
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) return {};
    QMap<QString, QStringList> groups;
    // Map each week identifier to a list of product names already processed for that week
    QMap<QString, QStringList> seenProductsPerMonth;
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList parts = line.split("|",Qt::SkipEmptyParts);
        if(parts.size() >= 2){
            QDate date = QDate::fromString(parts[0], "yyyy-MM-dd");
            if(!date.isValid())continue;
            QString monthKey = date.toString("yyyy-MM");
            QString productName = parts[1];
            if(!seenProductsPerMonth[monthKey].contains(productName)){
                groups[monthKey].append(line);
                seenProductsPerMonth[monthKey].append(productName);
            }
        }
    }
    file.close();
    QList<QStringList> result = groups.values();
    std::reverse(result.begin(),result.end());
    return result;
}

QList<QStringList> Widget::getYearly()
{
    QFile file(filePath());
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) return {};

    QMap<QString, QStringList> groups;
    QMap<QString, QStringList> seenProductsPerYearly;
    QTextStream in(&file);

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty()) continue; // Safely skip blank lines

        QStringList parts = line.split("|", Qt::SkipEmptyParts);
        if(parts.size() >= 2){
            // FIX 1: Explicitly target parts[0] for the date string
            QDate date = QDate::fromString(parts[0], "yyyy-MM-dd");

            if(!date.isValid()) {
                qWarning() << "Skipping corrupted date line:" << line;
                continue; // Skip line, don't crash or exit early
            }

            QString yearlyKey = date.toString("yyyy");
            // FIX 2: Explicitly target parts[1] for the product name
            QString productName = parts[1];

            if(!seenProductsPerYearly[yearlyKey].contains(productName)){
                groups[yearlyKey].append(line);
                seenProductsPerYearly[yearlyKey].append(productName);
            }
        }
    }
    file.close();

    // FIX 3: Clean up sorting behavior
    QList<QStringList> result = groups.values();
    std::reverse(result.begin(), result.end()); // Puts the newest year container first
    return result;
}


void Widget::setUpFile(){
    folderName = "/Production Records app/";
    documentPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    fileName = "data.records";
    fullPath = documentPath + folderName;
    setfilePath(fullPath + fileName);
    this->setWindowFilePath(fullPath);
    // After filePath = fullPath + fileName;
    QDir dir(fullPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    emit filePathChanged();
}//row -> file and checks for previous version of it and replaces it

void Widget::rowtoFile(QString Date, QString ProductName, double OpeningStock,
                       double Produced, QString BatchNo, double Sold)
{
    QFile file(filePath());
    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)){
        qInfo()<<"file not opening :"<<filePath();
        return;
    }
    QString fullFile = file.readAll();
    QStringList lines = fullFile.split('\n', Qt::SkipEmptyParts);
    double ClosingStock = (OpeningStock + Produced) - Sold;
    QString newLine = QString("%1|%2|%3|%4|%5|%6|%7")
                          .arg(Date, ProductName,
                               QString::number(OpeningStock),
                               QString::number(Produced),
                               BatchNo,
                               QString::number(Sold),
                               QString::number(ClosingStock));
    bool updated = false;
    for (int i = 0; i < lines.size(); ++i) {
        // Check if this line is for the same date and same product
        if (lines[i].startsWith(Date + "|") && lines[i].contains("|" + ProductName + "|")) {
            lines[i] = newLine;
            updated = true;
            break;
        }
    }
    if (!updated) {
        lines.prepend(newLine);   // Add new record at the top
    }
    file.resize(0);               // Clear file
    QTextStream out(&file);
    out << lines.join("\n") << "\n";
    file.close();
}
double Widget::getOpeningStock(QString name) {
    QFile file(filePath());
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return 0;
    QString fullFile = file.readAll();
    QStringList lines = fullFile.split("\n",Qt::SkipEmptyParts);
    double openingStock = 0.0;
    for(const QString &line : lines){
        QStringList parts = line.split("|", Qt::SkipEmptyParts);
        // Ensure there are enough tokens present to safely read index 1 and 2
        if(parts.size() >= 3){
            if(parts[1] == name){
                openingStock = parts[2].toDouble();
                break;
            }
        }
    }
    qInfo()<<"got opening stock of",openingStock;
    return openingStock;
}
