#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QDebug>
#include <QUrl>

class OrderService : public QObject
{
    Q_OBJECT
public:
    explicit OrderService(QObject *parent = nullptr);

    void setBaseUrl(const QString &baseUrl);
    void setToken(const QString &token);

    void createOrder(int id_table, const QVariantList &items);
    void getOrderByTable(int id_table);
    void updateOrder(int id_order, const QVariantList &items);
    void cancelOrder(int id_order);
    void completeOrder(int id_order);

signals:
    void orderCreated(QVariantMap order);
    void orderLoaded(QVariantMap order);
    void orderUpdated(QVariantMap result);
    void orderCancelled(int id_order);
    void orderCompleted(int id_order);
    void operationFailed(QString error);

private slots:
    void onCreateOrderFinished();
    void onGetOrderByTableFinished();
    void onUpdateOrderFinished();
    void onCancelOrderFinished();
    void onCompleteOrderFinished();

private:
    QNetworkAccessManager *m_networkManager;
    QString m_baseUrl;
    QString m_token;

    QNetworkReply* sendRequest(const QString &endpoint,
                               const QString &method = "GET",
                               const QJsonObject &body = QJsonObject());
    void handleNetworkError(QNetworkReply *reply);
    QVariantMap jsonObjectToVariantMap(const QJsonObject &obj);
};
