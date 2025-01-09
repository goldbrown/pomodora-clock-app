import {EntityDTO} from './EntityDTO'
import { RecordDTO } from './RecordDTO';


export interface  HomePageDTO {
  title: string;
  entityAggregateList: EntityAggregateDTO[];
  randomCode: string;
  recordList: RecordDTO[];
}


export interface  EntityAggregateDTO {
  entityDTO: EntityDTO;
  todayNumber: number;
}

