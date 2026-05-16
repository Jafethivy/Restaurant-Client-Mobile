#pragma once
#include <QObject>
#include <Qvariant>
#include <QJsonArray>
#include <QJsonObject>

class Waiter : public QObject{
    Q_OBJECT
    Q_PROPERTY(QVariantList menuGetter READ menuGetter NOTIFY menuChanged)
public:
    explicit Waiter(QObject *parent = nullptr);

public slots:
    QVariantList menuGetter() const;
    void menuSetter(QVariantList menu);

signals:
    void getMenu();
    void menuChanged();

    void tablesGetter(QVariantList tables);
    void orderSubmitted(int idTable, QVariantList order);

    void logout();

private:
    QVariantList m_menu;
};
