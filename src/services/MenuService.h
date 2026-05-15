#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

class MenuService : public QObject
{
    Q_OBJECT
public:
    explicit MenuService(QObject *parent = nullptr);

    void setBaseUrl(const QString &baseUrl);
    void setToken(const QString &token);

    void getMenu();

signals:
    void menuGetter(QVariantList categories);
    void operationFailed(QString error);

private slots:
    void onGetMenuFinished();

private:
    QNetworkAccessManager *m_networkManager;
    QString m_baseUrl;
    QString m_token;

    QNetworkReply* sendRequest(const QString &endpoint);
    void handleNetworkError(QNetworkReply *reply);
    QVariantMap jsonObjectToVariantMap(const QJsonObject &obj);
};
