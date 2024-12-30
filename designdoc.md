# 数据表
```sql
create table entity (
id varchar(50) not null,
category varchar(50) default '',
name varchar(100) not null,
desc varchar(255) default '',
add_time datetime default current_timestamp,
update_time datetime default current_timestamp on update current_timestamp,
deleted int(1) default 0,
PRIMARY KEY (id)
);
```

```sql
create table entity_record (
id varchar(50) not null,
entity_id varchar(50) not null,
add_time datetime default current_timestamp,
update_time datetime default current_timestamp on update current_timestamp,
deleted int(1) default 0,
PRIMARY KEY (id)
);
```
