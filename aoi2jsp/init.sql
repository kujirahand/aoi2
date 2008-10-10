
/* aoi2source */
create table aoi2source
(
    id          BIGINT  not null primary key auto_increment,
    source      BLOB    not null,
    ir          BLOB,
    name        VARCHAR(64)     not null,
    title       VARCHAR(64)     not null,
    comment     VARCHAR(256)    not null,
    password    VARCHAR(64)     not null,
    ext         VARCHAR(8)      not null default ".aoi2"
)
default character set = utf8;


