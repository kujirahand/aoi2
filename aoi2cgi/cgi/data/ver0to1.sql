/* 安全のためトランザクションを宣言します */
BEGIN TRANSACTION;
 
/* TEMPORARYエリアに保存用のテーブルを作成 */
CREATE TEMPORARY TABLE tmp (
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

/* 変更前のデータを保存 */
INSERT INTO tmp SELECT *,'unknown' AS user_name FROM files;
 
 
/* テーブルの作り直し */
DROP TABLE files;
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

/* TEMPORARYデータをもとに復旧 */
INSERT INTO files SELECT * FROM tmp;
 
/* 途中エラーがあればROLLBACK */
COMMIT;
 
SELECT * FROM files;
