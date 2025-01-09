import { Constants } from '../constant/Constants';
import { TabItem } from '../model/TabItem';
import { ToDo } from '../model/ToDo';
import { HomePageDTO, EntityAggregateDTO } from '../model/HomePageDTO';
import { EntityDTO } from '../model/EntityDTO';
import util from '@ohos.util';
import relationalStore from '@ohos.data.relationalStore';
import hilog from '@ohos.hilog';
import { RecordDTO } from '../model/RecordDTO';
import { DateUtil } from '../utils/DateUtil';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State selectedIndex: number = 0;
  @State toDoData: ToDo[] = [new ToDo('读书', "123"), new ToDo('运动', "sjkfjld")];
  private availableThings: string[] = ['读书', '运动', '旅游', '听音乐', '看电影', '唱歌'];
  @State homePageDTO: HomePageDTO = {
    title: '',
    entityAggregateList: [],
    randomCode: util.generateRandomUUID(true),
    recordList: []
  };
  @State inputName: string = '';



  private storeConfig: relationalStore.StoreConfig = {
    name: 'clock.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };

  aboutToAppear() {
    this.fetchHomeData();
  }

  fetchHomeData(): void {
    this.homePageDTO.title = '标题';
    // let entityAggregateDTO: EntityAggregateDTO = {
    //   entityDTO: new EntityDTO("椭圆机"),
    //   todayNumber: 1,
    // }
    // let entityAggregateDTO2: EntityAggregateDTO = {
    //   entityDTO: new EntityDTO("喝水"),
    //   todayNumber: 2,
    // }
    // let entityAggregateList: EntityAggregateDTO[] = [
    //   entityAggregateDTO, entityAggregateDTO2
    // ];
    // this.homePageDTO.entityAggregateList = entityAggregateList;
    relationalStore.getRdbStore(getContext(this), this.storeConfig, (err, store) => {
      if (err) {
        hilog.error(0x0000, Constants.dataLogTag, 'Failed to get RdbStore. Code: %{public}s, message: %{private}s', err.code, err.message,);
        return;
      }
      hilog.info(0x0000, Constants.dataLogTag, 'Succeeded in getting RdbStore.');
      // store.insert('entity', entity1, (err, rowId) => {
      //   // console.info(`${Constants.dataLogTag}: ` + JSON.stringify(err));
      //   if (err) {
      //     console.error(`${Constants.dataLogTag} Failed to insert data. Code:${err.code}, message:${err.message}`);
      //     return;
      //   }
      //   hilog.info(0x0000, Constants.dataLogTag, 'Succeeded in inserting data. rowId:%{public}d', rowId);
      // });

      let recordList: Array<RecordDTO> = [];
      // query
      let predicates = new relationalStore.RdbPredicates('entity_record');
      predicates.equalTo('deleted', '0');
      store.query(predicates, ['entity_id', 'add_time', 'update_time'], (err, resultSet) => {
        if (err) {
          hilog.error(0x0000, Constants.dataLogTag, 'Failed to query record data. Code:%{public}d, message:%{public}s', err.code, err.message);
          return;
        }
        if (!resultSet) {
          hilog.error(0x0000, Constants.dataLogTag, 'Failed to query record data. Code:%{public}d, message:%{public}s', err.code, err.message);
          return;
        }
        // console.info(`ResultSet column names: ${resultSet.columnNames}`);
        hilog.info(0x0000, Constants.dataLogTag, 'ResultSet record row count: %{public}d', resultSet.rowCount);
        if (resultSet) {
          while (resultSet.goToNextRow()) {
            const id: string = resultSet.getString(resultSet.getColumnIndex("id"));
            const entityId: string = resultSet.getString(resultSet.getColumnIndex("entity_id"));
            const addTime: string = resultSet.getString(resultSet.getColumnIndex("add_time"));
            const updateTime: string = resultSet.getString(resultSet.getColumnIndex("update_time"));
            hilog.info(0x0000, Constants.dataLogTag, "query result: %{public}s, %{public}s, %{public}s", entityId,
              addTime, updateTime);

            recordList.push({
              "id": id,
              "entityId": entityId,
              "addTime": DateUtil.strToDate(addTime),
              "updateTime": DateUtil.strToDate(updateTime),
            });
          }
          if (!resultSet.isClosed) {
            resultSet.close();
          }
        }

      });
      // entity
      let entityCondition = new relationalStore.RdbPredicates('entity');
      let entityIdList: Array<string> = recordList.map(item => item.entityId)
      let entityIdListUnique = Array.from(new Set(entityIdList));
      let entityId2NameMap: Map<string, string> = new Map();
      entityCondition.in('id', entityIdListUnique);
      store.query(entityCondition, ['id', 'name'], (err, resultSet) => {
        if (err) {
          hilog.error(0x0000, Constants.dataLogTag, 'Failed to query entity data. Code:%{public}d, message:%{public}s', err.code, err.message);
          return;
        }
        if (!resultSet) {
          hilog.error(0x0000, Constants.dataLogTag, 'Failed to query entity data. Code:%{public}d, message:%{public}s', err.code, err.message);
          return;
        }
        // console.info(`ResultSet column names: ${resultSet.columnNames}`);
        hilog.info(0x0000, Constants.dataLogTag, 'ResultSet entity row count: %{public}d', resultSet.rowCount);
        if (resultSet) {
          while (resultSet.goToNextRow()) {
            const id: string = resultSet.getString(resultSet.getColumnIndex("id"));
            const name: string = resultSet.getString(resultSet.getColumnIndex("name"));
            hilog.info(0x0000, Constants.dataLogTag, "query result: %{public}s, %{public}s", id,
              name);
            entityId2NameMap.set(id, name);
          }
          if (!resultSet.isClosed) {
            resultSet.close();
          }
        }
      });
    });

  }

  build() {
    Column() {
      Tabs({
        index: this.selectedIndex,
        barPosition: BarPosition.End,
      }) {
        TabContent() {
          Column() {
            Row() {
              TextInput({ placeholder: 'input your name', text: this.inputName}).width('100%');
              Button('添加').fontSize(15).width(100).onClick(event => {
                console.info("添加内容：" + this.inputName);
              });
            }.width('100%');
            Row() {
              Text(this.homePageDTO.title).fontSize(30);
              List() {
                ForEach(this.homePageDTO.recordList, (item: RecordDTO, index: number) => {
                  ListItem() {
                    Row() {
                      // Text('北京').fontSize(20);
                      Column() {
                        Text(item.entityId).fontSize(10);
                      }.border({ width: 1 })
                      .padding(10).width('20%').height(50);

                      Column() {
                        // Text('今日完成' + item.todayNumber).fontSize(10);
                        Text('添加时间:' + DateUtil.dateToStr(item.addTime)).fontSize(10);
                      }.border({ width: 1 })
                      .padding(10)
                      .width('50%').height(50);

                      Column() {
                        Button('增加', {
                          type: ButtonType.Normal,
                          stateEffect: true
                        }).fontSize(10)
                          .onClick(event => {
                            console.log("任务：" + item.entityId + " 增加1");
                            // item.todayNumber = item.todayNumber + 1;
                            // 用于触发UI更新
                            // this.homePageDTO.randomCode = util.generateRandomUUID(true);
                            // 插入数据库记录

                            // AlertDialog.show({
                            //   title: '提示',
                            //   message: '成功增加1',
                            //   autoCancel: true,
                            //   alignment: DialogAlignment.Center,
                            // });
                          });
                      }.border({ width: 1 })
                      .padding(0).width('30%').height(50);
                    }
                  }
                }, item => JSON.stringify(item));
              }
            }.width('100%')

          }.width('100%')
        }
        .tabBar(this.TabBottom(Constants.tabTitle[0], 0));

        TabContent() {
          Button("hello world2").width(200).height(120);
        }
        .tabBar(this.TabBottom(Constants.tabTitle[1], 1));

        TabContent() {
          Button("hello world3").width(200).height(120);
        }
        .tabBar(this.TabBottom(Constants.tabTitle[2], 2));
      }.onChange((index: number) => {
        this.selectedIndex = index;
      })
    }.width('100%');
  }

  @Builder
  TabBottom(item: TabItem, index: number) {
    Column() {
      Image(this.selectedIndex == index ? item.imageActivated : item.imageOriginal)
        .height($r('app.float.tab_image_size'))
        .width($r('app.float.tab_image_size'))
        .margin({
          top: $r('app.float.tab_margin_top'),
          bottom: $r('app.float.tab_margin_bottom')
        })
      Text(item.title)
        .width('100%')
        .height($r('app.float.tab_text_height'))
        .fontSize($r('app.float.tab_text_font_size'))
        .fontWeight(500)
        .fontColor(this.selectedIndex === index ? $r('app.color.color_red') : Color.Gray)
        .textAlign(TextAlign.Center)
        .margin({
          bottom: $r('app.float.tab_text_margin_bottom')
        })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.color_f5f5f5"))
  }
}

