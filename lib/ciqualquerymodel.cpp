#include "ciqualquerymodel.h"
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlQuery>
#include <QDebug>

CiqualQueryModel::CiqualQueryModel(QObject *parent) : QSqlQueryModel(parent) { }

void CiqualQueryModel::refresh() {
    qDebug() << m_parameters;
    QList<QString> keys = m_parameters.keys();
    QString queryString = m_queryString;
    for (int i = 0; i < m_parameters.size(); i++) {
        queryString.replace(keys[i], m_parameters[keys[i]].toString());
    }
    qDebug() << queryString;
    m_query.prepare(queryString);
    m_query.exec();
    QSqlQueryModel::setQuery(m_query);
    qDebug() << "Refreshing :" << rowCount() << "item founds";
    generateRoleNames();
}

void CiqualQueryModel::setQuery(const QString &query) {
    m_queryString = query;
}

void CiqualQueryModel::addParameter(const QString placeholder, const QVariant val) {
    m_parameters[placeholder] = val;
}

bool CiqualQueryModel::setParameter(const QString placeholder, const QVariant val) {
    if (m_parameters.contains(placeholder)) {
        m_parameters[placeholder] = val;
        return true;
    }
    return false;
}

void CiqualQueryModel::generateRoleNames() {
    m_roleNames.clear();
    for( int i = 0; i < record().count(); i ++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}

QVariant CiqualQueryModel::data(const QModelIndex &index, int role) const {
    QVariant value;
    if(role < Qt::UserRole) {
        value = QSqlQueryModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}
