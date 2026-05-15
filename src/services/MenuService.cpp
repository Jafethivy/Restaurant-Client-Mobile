#include "MenuService.h"
#include <QDebug>
#include <QUrl>

MenuService::MenuService(QObject *parent)
    : QObject(parent), m_networkManager(new QNetworkAccessManager(this))
{
}

void MenuService::setBaseUrl(const QString &baseUrl)
{
    m_baseUrl = baseUrl;
    if (m_baseUrl.endsWith("/")) {
        m_baseUrl.chop(1);
    }
}

void MenuService::setToken(const QString &token)
{
    m_token = token;
}

void MenuService::getMenu()
{
    QNetworkReply *reply = sendRequest("/menu");
    connect(reply, &QNetworkReply::finished, this, &MenuService::onGetMenuFinished);
}

void MenuService::onGetMenuFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;

    reply->deleteLater();

    if (reply->error() != QNetworkReply::NoError) {
        handleNetworkError(reply);
        return;
    }

    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonArray categoriesArray = doc.array();

    QVariantList categoriesList;
    for (const QJsonValue &value : std::as_const(categoriesArray)) {
        QJsonObject categoryObj = value.toObject();
        QVariantMap categoryMap;
        categoryMap["name"] = categoryObj["name"].toString();

        QJsonArray dishesArray = categoryObj["dishes"].toArray();
        QVariantList dishesList;
        for (const QJsonValue &dishValue : std::as_const(dishesArray)) {
            dishesList.append(jsonObjectToVariantMap(dishValue.toObject()));
        }
        categoryMap["dishes"] = dishesList;

        categoriesList.append(categoryMap);
    }

    emit menuGetter(categoriesList);
}

QNetworkReply* MenuService::sendRequest(const QString &endpoint)
{
    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    if (!m_token.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_token).toUtf8());
    }

    return m_networkManager->get(request);
}

void MenuService::handleNetworkError(QNetworkReply *reply)
{
    QString errorMsg = reply->errorString();
    qDebug() << "[MenuService] Network error:" << errorMsg;
    emit operationFailed(errorMsg);
}

QVariantMap MenuService::jsonObjectToVariantMap(const QJsonObject &obj)
{
    QVariantMap map;
    for (auto it = obj.begin(); it != obj.end(); ++it) {
        map.insert(it.key(), it.value().toVariant());
    }
    return map;
}
