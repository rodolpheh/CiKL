#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickItem>
#include <QQmlProperty>
#include <QQmlContext>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QFileInfo>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QtGlobal>
#include <QScreen>
#include <QCryptographicHash>
#include "lib/ciqualquerymodel.h"
#include "lib/producttable.h"

//#define DB_MD5_SUM "a1c6a9f6a718c47c4c3f5d297dd89c44"
#define DB_MD5_SUM "6850263c90fba3765fb5808a7b5fb2c3"

void importDB(QFile *dbAssetUrl, QString folder) {
    QDir* dir = new QDir(folder + "/data");
    if (!dir->exists()) {
        qDebug() << "INFO: Creating data folder";
        dir->mkpath(".");
    }
    else {
        qDebug() << "INFO: data folder already exists";
    }
    qDebug() << "INFO: Copying file :" << (dbAssetUrl->copy(folder + "/data/CiKL.sqlite") ? " success" : " failed!");
    QFile::setPermissions(folder + "/data/CiKL.sqlite", QFile::WriteOwner | QFile::ReadOwner);
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QScreen *srn = QGuiApplication::screens().at(0);
    qDebug() << (qreal)srn->logicalDotsPerInch();

    QString folder = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
    qDebug() << "INFO: data folder : " << folder;

    QString dbAssetUrl;

#ifdef Q_OS_ANDROID
    dbAssetUrl = "assets:/data/CiKL.sqlite";
#else
    dbAssetUrl = "data/CiKL.sqlite";
#endif

    QFile efile(dbAssetUrl);

    // Check the existence of the DB file in the package
    if (efile.exists()) {
        qDebug() << "INFO: Found database file in assets";
        qDebug() << "INFO: Database size : " << efile.size() << " bytes";
    }
    else {
        qDebug() << "ERROR: No database found in assets !";
        return 0;
    }

    QFile dfile(folder + "/data/CiKL.sqlite");

    // Check the existence of the DB file in the local files
    if (!dfile.exists()) {
        importDB(&efile, folder);
    }
    else {
        if (dfile.open(QFile::ReadOnly)) {
            QCryptographicHash hash(QCryptographicHash::Md5);
            // If it exists, we compare the md5 sum with the DB in the package so we can find out if a new version has been distributed
            if (hash.addData(&dfile)) {
                qDebug() << "INFO: Md5sum: " << hash.result().toHex();
                if (hash.result().toHex() == DB_MD5_SUM) {
                    qDebug() << "INFO: Hey that's a good DB man !";
                }
                else {
                    qDebug() << "ERROR: Wrong md5 sum, will replace the database";
                    // We replace the local DB with DB from the package
                    dfile.remove();
                    importDB(&efile, folder);
                }
            }
        }
    }

    // Now we can open the local DB
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(folder + "/data/CiKL.sqlite");
    db.open();

    // We create the model that will be used by the ListView objects
    CiqualQueryModel searchModel;
    CiqualQueryModel componentModel;
    CiqualQueryModel groupModel;
    CiqualQueryModel groupFilterModel;

    // Setting the query for the search and the parameters
    searchModel.setQuery("SELECT * FROM CiKL "
                         "WHERE blandfdnm LIKE :searchString "
                         "OR blandgpfr LIKE :searchString "
                         "OR origfdnm LIKE :searchString"
                         "OR origgpfr LIKE :searchString"
                         "ORDER BY origfdnm :sorting");
    searchModel.addParameter(":searchString", "'%'");
    searchModel.addParameter(":sorting", "ASC");
    searchModel.refresh();

    // Setting the query for the component sorting and the parameters
    componentModel.setQuery("SELECT origgpfr, origfdcd, origfdnm, :column as value, "
                            "(CASE "
                            "WHEN SUBSTR(:column, 1, 1) = \"<\" THEN SUBSTR(:column, 3) "
                            "WHEN :column LIKE 'traces' THEN '0' "
                            "WHEN :column LIKE '-' THEN '-2' "
                            "WHEN :column LIKE '0' THEN '-1' "
                            "ELSE :column END) as newValue "
                            "FROM CiKL WHERE blandfdnm LIKE :searchString "
                            "OR blandgpfr LIKE :searchString "
                            "OR origfdnm LIKE :searchString"
                            "OR origgpfr LIKE :searchString"
                            "ORDER BY newValue + 0 :sorting");
    componentModel.addParameter(":searchString", "'%'");
    componentModel.addParameter(":column", "energie_ue_kcal");
    componentModel.addParameter(":sorting", "DESC");
    componentModel.refresh();

    // Setting the query for the group list and the parameter
    groupModel.setQuery("SELECT DISTINCT origgpcd, origgpfr "
                        "FROM CiKL ORDER BY origgpfr :sorting");
    groupModel.addParameter(":sorting", "ASC");
    groupModel.refresh();

    groupFilterModel.setQuery("SELECT origgpcd, origgpfr, origfdcd, origfdnm "
                              "FROM CiKL WHERE origgpcd LIKE :group "
                              "AND (blandfdnm LIKE :searchString "
                              "OR origfdnm LIKE :searchString) "
                              "ORDER BY origfdnm :sorting");
    groupFilterModel.addParameter(":group", "0");
    groupFilterModel.addParameter(":searchString", "'%'");
    groupFilterModel.addParameter(":sorting", "ASC");
    groupFilterModel.refresh();

    QQmlApplicationEngine engine;
    // We register the models that will be used by the ListView objects
    engine.rootContext()->setContextProperty("globalSearchModel", &searchModel);
    engine.rootContext()->setContextProperty("componentSearchModel", &componentModel);
    engine.rootContext()->setContextProperty("groupsListModel", &groupModel);
    engine.rootContext()->setContextProperty("groupsFilterModel", &groupFilterModel);

    ProductTable productTable;
    engine.rootContext()->setContextProperty("productData", &productTable);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
