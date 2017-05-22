#ifndef PRODUCTTABLE_H
#define PRODUCTTABLE_H

#include <QObject>
#include <QSqlQuery>

class ProductTable : public QObject {
    Q_OBJECT

public:
    explicit ProductTable(QObject *parent = 0);
    Q_INVOKABLE QString getData(const QString number);

private:
    QSqlQuery _query;
    QString m_queryString = QString("SELECT * FROM CiKL WHERE origfdcd = ':number'");
};

#endif // PRODUCTTABLE_H
