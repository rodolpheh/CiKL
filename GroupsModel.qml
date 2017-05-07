import QtQuick 2.7

ListModel {

    Component.onCompleted: {
        console.log("Loading groups");
        db.transaction(function(tx) {
            var request = "SELECT DISTINCT origgpcd, origgpfr, " +
                    "(CASE " +
                    "WHEN INSTR(origgpcd, '.') > 0 THEN SUBSTR(origgpcd, 0, INSTR(origgpcd, '.')) " +
                    "ELSE origgpcd END) as origgpcdglob " +
                    "FROM CiKL ORDER BY origgpcdglob ASC, origgpfr ASC";
            console.log(request);
            var results = tx.executeSql(request);
            for(var i = 0; i < results.rows.length; i++) {
                console.log(JSON.stringify(results.rows.item(i)));
                append({name: results.rows.item(i).origgpfr, number: results.rows.item(i).origgpcd, categoryName: results.rows.item(i).origgpcdglob});
            }
        });
    }
}
