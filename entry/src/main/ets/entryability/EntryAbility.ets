import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import relationalStore from '@ohos.data.relationalStore';
import util from '@ohos.util';
import { Constants } from '../constant/Constants';
import { EntityDTO } from '../model/EntityDTO';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    const CREATE_ENTITY_TABLE_SQL: string = "create table IF NOT EXISTS entity (     id text not null,     category text default '',   " +
      "  name text not null,     desc text default '',    " +
      " add_time text default '',    " +
      " update_time text default '',   " +
      "  deleted integer default 0,     PRIMARY KEY (id) );";
    const CREATE_ENTITY_RECORD_TABLE_SQL: string = "create table IF NOT EXISTS entity_record (     id text not null,    " +
      " entity_id text not null,     add_time datetime text default '',    " +
      " update_time text default '',    " +
      " deleted integer default 0,     PRIMARY KEY (id) );"

    // const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS employee (id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    //   'name TEXT NOT NULL, age INTEGER, salary REAL, codes BLOB)';

    const storeConfig: relationalStore.StoreConfig = {
      name: 'clock.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    relationalStore.getRdbStore(this.context, storeConfig, (err, store) => {
      if (err) {
        hilog.error(0x0000, Constants.dataLogTag, 'Failed to get RdbStore. Code: %{public}s, message: %{private}s', err.code, err.message,);
        return;
      }
      hilog.info(0x0000, Constants.dataLogTag, 'Succeeded in getting RdbStore.');
      store.executeSql(CREATE_ENTITY_TABLE_SQL); // 创建数据表
      store.executeSql(CREATE_ENTITY_RECORD_TABLE_SQL); // 创建数据表
      // store.executeSql(SQL_CREATE_TABLE); // 创建数据表
      // const employee = {
      //   'name': 'Lisa',
      //   'age': 18,
      //   'salary': 100.5,
      //   'codes': 'any codes'
      // };
      const entity1: relationalStore.ValuesBucket = {
        'id': '113',
        'name': '椭圆机',
      };
      const entityRecord = {
        'id': util.generateRandomUUID(true),
        'entity_id': '112',
      };
      // store.insert('employee', employee, (err, rowId) => {
      //   if (err) {
      //     console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
      //     return;
      //   }
      //   console.info(Constants.dataLogTag + ` Succeeded in inserting data. rowId:${rowId}`);
      // });

      store.insert('entity', entity1, (err, rowId) => {
        // console.info(`${Constants.dataLogTag}: ` + JSON.stringify(err));
        if (err) {
          console.error(`${Constants.dataLogTag} Failed to insert data. Code:${err.code}, message:${err.message}`);
          return;
        }
        hilog.info(0x0000, Constants.dataLogTag, 'Succeeded in inserting data. rowId:%{public}d', rowId);
      });


      // query
      let predicates = new relationalStore.RdbPredicates('entity');
      // predicates.equalTo('id', '111');
      store.query(predicates, ['id', 'name', 'add_time', 'update_time'], (err, resultSet) => {
        if (err) {
          hilog.error(0x0000, Constants.dataLogTag, 'Failed to query data. Code:%{public}d, message:%{public}s', err.code, err.message);
          return;
        }
        if (!resultSet) {
          hilog.error(0x0000, Constants.dataLogTag, 'Failed to query data. Code:%{public}d, message:%{public}s', err.code, err.message);
          return;
        }
        console.info(`ResultSet column names: ${resultSet.columnNames}`);
        hilog.info(0x0000, Constants.dataLogTag, 'ResultSet ROW count: %{public}d', resultSet.rowCount);
        if (resultSet) {
          while (resultSet.goToNextRow()) {
            const id: string = resultSet.getString(resultSet.getColumnIndex("id"));
            const name: string = resultSet.getString(resultSet.getColumnIndex("name"));
            const addTime: String = resultSet.getString(resultSet.getColumnIndex("add_time"));
            const updateTime: String = resultSet.getString(resultSet.getColumnIndex("update_time"));
            hilog.info(0x0000, Constants.dataLogTag, "query result: %{public}s, %{public}s, %{public}s, %{public}s", id, name,
              addTime, updateTime);
          }
          if (!resultSet.isClosed) {
            resultSet.close();
          }
        }

      });
    });

    windowStage.loadContent('pages/SplashPage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
