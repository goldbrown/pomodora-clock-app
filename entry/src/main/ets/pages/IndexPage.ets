import { Constants } from '../constant/Constants';
import { TabItem } from '../model/TabItem';
import { ToDo } from '../model/ToDo';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State selectedIndex: number = 0;

  @State toDoData: ToDo[] = [new ToDo('读书', "123"), new ToDo('运动', "sjkfjld")];
  private availableThings: string[] = ['读书', '运动', '旅游', '听音乐', '看电影', '唱歌'];


  build() {
    Column() {
      Tabs({
        index: this.selectedIndex,
        barPosition: BarPosition.End,
      }) {
        TabContent() {
          // Button("hello world").width(200).height(120);
          List({ space: 10 }) {
            ForEach(this.toDoData, (toDoItem: ToDo) => {
              ListItem() {
                Row() {
                  // Text('北京').fontSize(20);
                  Column() {
                    Text(toDoItem.name).fontSize(20);
                  }.border({ width: 1 })
                  .padding(10).width('20%').height(50);

                  Column() {
                    Text('今日完成2/4次').fontSize(20);
                  }.border({ width: 1 })
                  .padding(10)
                  .width('50%').height(50);

                  Column() {
                    Button('增加',{
                      type: ButtonType.Normal,
                      stateEffect: true
                    }).fontSize(20).id(toDoItem.id)
                      .onClick(event => {
                      console.log("任务：" + toDoItem.id + " 增加1");
                        AlertDialog.show({
                          title: '提示',
                          message: '成功增加1',
                          autoCancel: true,
                          alignment: DialogAlignment.Center,
                        });
                    });
                  }.border({ width: 1 })
                  .padding(0).width('30%').height(50);
                }
              }
            }, toDoItem => toDoItem.key)
          }
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

  @Builder TabBottom(item: TabItem, index: number) {
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