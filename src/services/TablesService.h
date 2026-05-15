#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QUrl>
#include <QJsonArray>

class TablesService : public QObject
{
    Q_OBJECT
public:
    explicit TablesService(QObject *parent = nullptr);

    void setBaseUrl(const QString& baseUrl);
    void setToken(const QString& token);

    void getAllTables();


signals:
    void tablesGetter(QVariantList tables);

private slots:
    void onGetAllTablesFinished();


private:
    QNetworkAccessManager* m_networkManager;
    QString m_token;
    QString m_baseUrl = "http://192.168.1.254:8080/api";

    QNetworkReply* sendRequest(const QString& endpoint,
                               const QString& method = "GET",
                               const QJsonObject& body = QJsonObject());

    void handleNetworkError(QNetworkReply* reply);
    QVariantMap jsonObjectToVariantMap(const QJsonObject& obj);
};
