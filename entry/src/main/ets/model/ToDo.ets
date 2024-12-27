import util from '@ohos.util';

export class ToDo {
  key: string = util.generateRandomUUID(true);
  name: string;
  id: string;

  constructor(name: string, id: string) {
    this.name = name;
    this.id = id;
  }
}