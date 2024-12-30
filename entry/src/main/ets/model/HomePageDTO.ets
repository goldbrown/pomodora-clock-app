import {EntityDTO} from './EntityDTO'


export interface  HomePageDTO {
  title: string;
  entityAggregateList: EntityAggregateDTO[];
  randomCode: string;
}


export interface  EntityAggregateDTO {
  entityDTO: EntityDTO;
  todayNumber: number;
}

