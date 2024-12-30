import util from '@ohos.util';
import relationalStore from '@ohos.data.relationalStore';


export class  EntityDTO {
  id: string = util.generateRandomUUID(true);
  name: string;
  desc?: string;
  addTime?: Date = new Date();
  updateTime?: Date = new Date();
  deleted?: boolean = false;

  constructor(name: string, desc?: string, updateTime?: Date, deleted?: boolean) {
    this.name = name;
    this.desc = desc;
    if (updateTime) {
      this.updateTime = updateTime;
    }
    this.deleted = deleted;
  }
}