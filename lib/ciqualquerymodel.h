#ifndef CIQUALQUERYMODEL_H
#define CIQUALQUERYMODEL_H

#include <QSqlQueryModel>
#include <QSqlQuery>


class CiqualQueryModel : public QSqlQueryModel {
    Q_OBJECT

public:
    explicit CiqualQueryModel(QObject *parent = 0);
    Q_INVOKABLE void refresh();
    void setQuery(const QString &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const {	return m_roleNames;	}
    void addParameter(const QString placeholder, const QVariant val);
    Q_INVOKABLE bool setParameter(const QString placeholder, const QVariant val);

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
    QHash<QString, QVariant> m_parameters;
    QSqlQuery m_query;
    QString m_queryString = QString("");
};

#endif
