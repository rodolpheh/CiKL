#include "producttable.h"
#include <QSqlQuery>
#include <QDebug>
#include <QSqlRecord>
#include <QSqlField>

ProductTable::ProductTable(QObject *parent) : QObject(parent) { }

QString ProductTable::getData(const QString number) {
    QString returnString;
    QString queryString = m_queryString;
    queryString.replace(":number", number);
    _query.prepare(queryString);
    _query.exec();
    returnString = "{\n";
    while(_query.next()) {
        for (int i = 0; i < _query.record().count(); i++) {
            returnString += "\"" + _query.record().fieldName(i) + "\": \"" + _query.value(i).toString() + "\"";
            if (i != _query.record().count() - 1) {
                returnString += ",";
            }
            returnString += "\n";
        }
    }
    returnString += "}";
    return returnString;
}
