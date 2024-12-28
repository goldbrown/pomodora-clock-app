import util from '@ohos.util';

export class RecordDTO {
  id: string = util.generateRandomUUID(true);
  entityId: string;
  addTime: Date = new Date();
  updateTime: Date = new Date();
  deleted: boolean;

  constructor(entityId: string, updateTime: Date, deleted: boolean) {
    this.entityId = entityId;
    if (updateTime) {
      this.updateTime = updateTime;
    }
    this.deleted = deleted;
  }

}