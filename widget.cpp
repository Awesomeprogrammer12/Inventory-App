#include "widget.h"

Widget::Widget(QWidget *parent)
    : QWidget(parent){
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
    this->setMinimumSize(500,500);
    this->setGeometry(20,20,800,600);
    setUpFile();
}
Widget::~Widget()
{
    delete ui;
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
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return {};
    }
    QMap<QString, QStringList> groups;
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList parts = line.split("|", Qt::SkipEmptyParts);

        if (parts.size() > 0) {
            QDate date = QDate::fromString(parts[0], "yyyy-MM-dd");
            if (date.isValid()) {
                int weekNum;
                int yearNum;
                weekNum = date.weekNumber(&yearNum);
                QString weekKey = QString("%1-%2")
                                      .arg(yearNum)
                                      .arg(weekNum, 2, 10, QChar('0'));

                groups[weekKey].append(line);
            }
        }
    }
    file.close();
    QList<QStringList> result = groups.values();
    std::reverse(result.begin(), result.end());

    return result;
}

QList<QStringList> Widget::getMonthly()
{

}

QList<QStringList> Widget::getYearly()
{

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
    QStringList lines = fullFile.split("/n",Qt::SkipEmptyParts);
    double openingStock = 0.0;
    for(QString line :lines){
        QStringList parts = line.split("|",Qt::SkipEmptyParts);
        if(parts[1] == name){
            openingStock = parts[2].toDouble();
            break;
        }
    }
    qInfo()<<"got opening stock of",openingStock;
    return openingStock;
}
