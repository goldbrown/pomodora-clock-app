import util from '@ohos.util';

export class ToDo {
  key: string = util.generateRandomUUID(true);
  name: string;

  constructor(name: string) {
    this.name = name;
  }
}