#ifndef WIDGET_H
#define WIDGET_H
#include <QWidget>
#include <QQuickView>
#include <QQmlContext>
#include <QVBoxLayout>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDate>
#include <QJsonObject>
#include <QList>
QT_BEGIN_NAMESPACE
namespace Ui {
class Widget;
}
QT_END_NAMESPACE

class Widget : public QWidget
{
    Q_OBJECT

public:
    Widget(QWidget *parent = nullptr);
    ~Widget();
    QQuickView *view;
    QWidget *container;
    QVBoxLayout *layout;
    QString m_filePath;
    Q_PROPERTY(QString filePath READ filePath WRITE setfilePath NOTIFY filePathChanged)
    QString title;
    Q_INVOKABLE void setTitle(QString titl);
    QString Daily;
    Q_INVOKABLE QString filePath() const { return m_filePath; }
    Q_INVOKABLE void setfilePath(const QString &newPath) {
        if (m_filePath == newPath) return;
        m_filePath = newPath;
        emit filePathChanged();
    }
    Q_INVOKABLE QString readFile() {
        QFile file(m_filePath);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return "";
        QString content = file.readAll();
        file.close();
        return content;
    }
    Q_INVOKABLE QList<QStringList> getDaily();
    Q_INVOKABLE QList<QStringList> getWeekly();
    Q_INVOKABLE QList<QStringList> getMonthly();
    Q_INVOKABLE QList<QStringList> getYearly();

    QString fileName;
    QString folderName;
    QString fullPath;
    QString documentPath;
    QString fullFile;
    QStringList lines;
    QString content;
    QStringList parts;
    QString olderCopy;
    Q_INVOKABLE void rowtoFile(QString Date, QString ProductName, double OpeningStock, double Produced, QString BatchNo, double Sold);//table +date
    Q_INVOKABLE double getOpeningStock(QString name);
    void setUpFile();
signals:
    void filePathChanged();
private:
    Ui::Widget *ui;
};
#endif // WIDGET_H
