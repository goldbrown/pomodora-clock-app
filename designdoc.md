# 数据表
```sql
create table entity (
id text not null,
category text default '',
name text not null,
desc text default '',
add_time text default '',
update_time text default '',
deleted integer default 0,
PRIMARY KEY (id)
);
```

```sql
create table entity_record (
id text not null,
entity_id text not null,
add_time text default '',
update_time text default '',
deleted integer default 0,
PRIMARY KEY (id)
);
```
