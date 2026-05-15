#pragma once
#include <QObject>
#include <Qvariant>

class Waiter : public QObject{
    Q_OBJECT
    Q_PROPERTY(QVariantList menuGetter READ menuGetter)
public:
    explicit Waiter(QObject *parent = nullptr);

public slots:
    QVariantList menuGetter() const;
    void menuSetter(QVariantList menu);
signals:
    void getMenu();
    void tablesGetter(QVariantList tables);
    void logout();

private:
    QVariantList m_menu;
};
