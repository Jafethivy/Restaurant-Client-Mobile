#include "OrderService.h"

OrderService::OrderService(QObject *parent)
    : QObject(parent), m_networkManager(new QNetworkAccessManager(this))
{
}

void OrderService::setBaseUrl(const QString &baseUrl)
{
    m_baseUrl = baseUrl;
    if (m_baseUrl.endsWith("/")) {
        m_baseUrl.chop(1);
    }
}

void OrderService::setToken(const QString &token)
{
    m_token = token;
}

// ============================================
// POST /api/orders
// ============================================
void OrderService::createOrder(int id_table, const QVariantList &items){
    QJsonObject body;
    body["id_table"] = id_table;

    QJsonArray itemsArray;
    for (const QVariant &itemVar : items) {
        QVariantMap item = itemVar.toMap();
        QJsonObject itemObj;
        itemObj["dishId"] = item["dishId"].toInt();
        itemObj["quantity"] = item["quantity"].toInt();
        itemsArray.append(itemObj);
    }
    body["items"] = itemsArray;

    QNetworkReply *reply = sendRequest("/orders", "POST", body);
    connect(reply, &QNetworkReply::finished, this, &OrderService::onCreateOrderFinished);
}

void OrderService::onCreateOrderFinished(){
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;
    reply->deleteLater();

    if (reply->error() != QNetworkReply::NoError) {
        handleNetworkError(reply);
        return;
    }

    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject result = doc.object();

    if (result["success"].toBool()) {
        emit orderCreated(jsonObjectToVariantMap(result));
    } else {
        emit operationFailed(result["error"].toString());
    }
}

// ============================================
// GET /api/orders/table/:id_order
// ============================================
void OrderService::getOrder(int id_order){
    QNetworkReply *reply = sendRequest(QString("/orders/order/%1").arg(id_order));
    connect(reply, &QNetworkReply::finished, this, &OrderService::onGetOrderFinished);
}

void OrderService::onGetOrderFinished(){
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;
    reply->deleteLater();

    if (reply->error() != QNetworkReply::NoError) {
        handleNetworkError(reply);
        return;
    }

    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject result = doc.object();

    if (result["success"].toBool()) {
        QJsonObject orderObj = result["order"].toObject();
        emit orderLoaded(jsonObjectToList(orderObj));
    } else {
        emit operationFailed(result["error"].toString());
    }
}

// ============================================
// PUT /api/orders/:id
// ============================================
void OrderService::updateOrder(int id_order, const QVariantList &items)
{
    QJsonObject body;
    QJsonArray itemsArray;
    for (const QVariant &itemVar : items) {
        QVariantMap item = itemVar.toMap();
        QJsonObject itemObj;
        itemObj["id_menu"] = item["id_menu"].toInt();
        itemObj["quantity"] = item["quantity"].toInt();
        itemsArray.append(itemObj);
    }
    body["items"] = itemsArray;

    QNetworkReply *reply = sendRequest(QString("/orders/%1").arg(id_order), "PUT", body);
    connect(reply, &QNetworkReply::finished, this, &OrderService::onUpdateOrderFinished);
}

void OrderService::onUpdateOrderFinished()
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
    QJsonObject result = doc.object();

    if (result["success"].toBool()) {
        emit orderUpdated(jsonObjectToVariantMap(result));
    } else {
        emit operationFailed(result["error"].toString());
    }
}

// ============================================
// DELETE /api/orders/:id — Cancelar
// ============================================
void OrderService::cancelOrder(int id_order)
{
    QNetworkReply *reply = sendRequest(QString("/orders/%1").arg(id_order), "DELETE");
    connect(reply, &QNetworkReply::finished, this, &OrderService::onCancelOrderFinished);
}

void OrderService::onCancelOrderFinished()
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
    QJsonObject result = doc.object();

    if (result["success"].toBool()) {
        emit orderCancelled(result["id_order"].toInt());
    } else {
        emit operationFailed(result["error"].toString());
    }
}

// ============================================
// PUT /api/orders/:id/complete — Completar
// ============================================
void OrderService::completeOrder(int id_order)
{
    QNetworkReply *reply = sendRequest(QString("/orders/%1/complete").arg(id_order), "PUT");
    connect(reply, &QNetworkReply::finished, this, &OrderService::onCompleteOrderFinished);
}

void OrderService::onCompleteOrderFinished()
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
    QJsonObject result = doc.object();

    if (result["success"].toBool()) {
        emit orderCompleted(result["id_order"].toInt());
    } else {
        emit operationFailed(result["error"].toString());
    }
}

// ============================================
// Helpers
// ============================================
QNetworkReply* OrderService::sendRequest(const QString &endpoint,
                                         const QString &method,
                                         const QJsonObject &body)
{
    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    if (!m_token.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_token).toUtf8());
    }

    QNetworkReply *reply = nullptr;
    QJsonDocument doc(body);

    if (method == "GET") {
        reply = m_networkManager->get(request);
    } else if (method == "POST") {
        reply = m_networkManager->post(request, doc.toJson());
    } else if (method == "PUT") {
        reply = m_networkManager->put(request, doc.toJson());
    } else if (method == "DELETE") {
        reply = m_networkManager->deleteResource(request);
    }

    return reply;
}

void OrderService::handleNetworkError(QNetworkReply *reply)
{
    QString errorMsg = reply->errorString();
    qDebug() << "[OrderService] Network error:" << errorMsg;
    emit operationFailed(errorMsg);
}

QVariantMap OrderService::jsonObjectToVariantMap(const QJsonObject &obj){
    QVariantMap map;
    for (auto it = obj.begin(); it != obj.end(); ++it) {
        map.insert(it.key(), it.value().toVariant());
    }
    return map;
}

QVariantList OrderService::jsonObjectToList(const QJsonObject &obj)
{
    QVariantList list;

    // Extraer el array bajo la clave "items"
    if (!obj.contains("items") || !obj["items"].isArray()) {
        qWarning() << "jsonObjectToList: no se encontró 'items' o no es un array";
        return list;
    }

    QJsonArray itemsArray = obj["items"].toArray();

    for (const QJsonValue &val : std::as_const(itemsArray)) {
        if (!val.isObject()) continue;

        QJsonObject itemObj = val.toObject();
        QVariantMap itemMap;

        // Normalizar id_menu a int (evita qlonglong en QML)
        if (itemObj.contains("id_menu")) {
            itemMap.insert("id_menu", itemObj["id_menu"].toVariant().toInt());
        }

        // Normalizar quantity a int
        if (itemObj.contains("quantity")) {
            itemMap.insert("quantity", itemObj["quantity"].toVariant().toInt());
        }

        // Si hay más campos en el futuro, los copiamos automáticamente
        for (const QString &key : itemObj.keys()) {
            if (!itemMap.contains(key)) {
                itemMap.insert(key, itemObj[key].toVariant());
            }
        }

        list.append(itemMap);
    }
    qDebug() << list;
    return list;
}
