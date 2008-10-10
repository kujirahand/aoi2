/*
 * ---------------------------------------------------------------------
 * filedb.sql (for aoi2 server) -- euc-jp
 * ---------------------------------------------------------------------
 */
CREATE TABLE info (
  key         TEXT NOT NULL PRIMARY KEY UNIQUE,
  v_str       TEXT NOT NULL DEFAULT '',
  v_int       INTEGER DEFAULT 0
);

/* IDを管理するために使う */
INSERT INTO info (key, v_int) VALUES ('last_file_id', 0);
INSERT INTO info (key, v_int) VALUES ('last_user_id', 0);

CREATE TABLE files (
  file_id     INTEGER PRIMARY KEY UNIQUE,
  filename    TEXT NOT NULL DEFAULT '',
  source      TEXT NOT NULL DEFAULT '',
  lang        TEXT NOT NULL DEFAULT '.aoi',
  ircode      TEXT NOT NULL DEFAULT '',
  password    TEXT NOT NULL DEFAULT '', /* ログインを使わない時 */
  update_time INTEGER DEFAULT 0,        /* UNIX TIME */
  create_time INTEGER DEFAULT 0,
  user_id     INTEGER DEFAULT 0,
  public_attr INTEGER DEFAULT 0,        /* 0:非公開 1:公開 */
  user_name   TEXT NOT NULL DEFAULT 'unknown'
);

CREATE TABLE users (
  user_id     INTEGER PRIMARY KEY UNIQUE,
  email       TEXT NOT NULL UNIQUE DEFAULT '', /* login id */
  password    TEXT NOT NULL DEFAULT '',
  name        TEXT NOT NULL DEFAULT '',
  comment     TEXT NOT NULL DEFAULT '',
  update_time INTEGER NOT NULL DEFAULT 0,
  create_time INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE counter (
  file_id     INTEGER PRIMARY KEY UNIQUE,
  count       INTEGER DEFAULT 0,
  update_time INTEGER DEFAULT 0
);

