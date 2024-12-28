import {EntityDTO} from './EntityDTO'


export interface  HomePageDTO {
  title: string;
  entityAggregateList: EntityAggregateDTO[];
  code: string;
}


export interface  EntityAggregateDTO {
  entityDTO: EntityDTO;
  todayNumber: number;
}

