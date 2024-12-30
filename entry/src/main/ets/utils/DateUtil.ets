
export class DateUtil {
  static strToDate(str: string):Date {
    if (str) {
      return new Date(str);
    }
    return undefined;
  }

  /**
   * 将 Date 或时间戳 转化为指定格式的String
   *
   * 年(y)可以用 1-4 个占位符
   *
   * 月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符
   *
   * 周(E)可以用 1-3 个占位符
   *
   * 毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
   *
   * eg:
   *
   * dateFormat(new Date(), "yyyy-MM-dd hh:mm:ss.S") ==> 2024-07-29 08:09:04.423
   *
   * dateFormat(new Date(), "yyyy-MM-dd E HH:mm:ss") ==> 2024-07-29 四 20:09:04
   *
   * dateFormat(new Date(), "yyyy-MM-dd EE hh:mm:ss") ==> 2024-07-29 周四 08:09:04
   *
   * dateFormat(new Date(), "yyyy-MM-dd EEE hh:mm:ss") ==> 2024-08-29 星期四 08:09:04
   *
   * dateFormat(new Date(), "yyyy-M-d h:m:s.S") ==> 2024-8-29 8:9:4.18
   */
  static dateToStr(date?: number | Date, fmt?: string): string {
    let _date = new Date();
    // 日期空处理
    if (date == undefined || date == null) {
      _date = new Date();
    } else if (typeof (date) == "number") {// 如果是时间戳
      _date = new Date(date);
    }
    // 格式化空处理
    if (fmt == undefined || fmt == null || fmt.length <= 0) {
      fmt = "yyyy-MM-dd HH:mm:ss.S";
    }
    let map = new Map<String, Number>();
    map.set("M+", _date.getMonth() + 1); // 月份
    map.set("d+", _date.getDate()); // 日
    map.set("h+", _date.getHours() % 12 == 0 ? 12 : _date.getHours() % 12); // 12小时
    map.set("H+", _date.getHours()); // 24小时
    map.set("m+", _date.getMinutes()); // 分
    map.set("s+", _date.getSeconds()); // 秒
    map.set("q+", Math.floor((_date.getMonth() + 3) / 3)); // 季度
    map.set("S", _date.getMilliseconds()); // 毫秒

    let week = new Map<string, string>();
    week.set("0", "日");
    week.set("1", "一");
    week.set("2", "二");
    week.set("3", "三");
    week.set("4", "四");
    week.set("5", "五");
    week.set("6", "六");
    // 处理年
    if (/(y+)/.test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (_date.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    // 处理周
    if (/(E+)/.test(fmt)) {
      fmt = fmt.replace(RegExp.$1,
        ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "星期" : "周") : "") + week.get(_date.getDay() + ""));
    }
    // 处理指定的格式规则
    map.forEach((value, key) => {
      if (new RegExp(`(${key})`).test(fmt!)) {
        let replaceValue = '';
        if ((RegExp.$1.length == 1)) {
          replaceValue = `${value}`;
        } else {
          replaceValue = (("00" + value).substr(("" + value).length))
        }
        fmt = fmt!.replace(RegExp.$1, replaceValue);
      }
    });
    return fmt;
  }
}