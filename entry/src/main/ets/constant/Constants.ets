export class Constants {

  static readonly tabTitle = [
    {
      index: 0,
      title: "首页",
      imageActivated: $r('app.media.icon_sel_home'),
      imageOriginal: $r('app.media.icon_unsel_home')
    },
    {
      index: 1,
      title: "统计",
      imageActivated: $r('app.media.icon_sel_find'),
      imageOriginal: $r('app.media.icon_unsel_find')
    },
    {
      index: 2,
      title: "我的",
      imageActivated: $r('app.media.icon_sel_mine'),
      imageOriginal: $r('app.media.icon_unsel_mine')
    }
  ]

  static dataLogTag: string = "clockData";
}

let constants = new Constants();

export default constants as Constants;