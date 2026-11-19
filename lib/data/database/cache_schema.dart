const cacheVersion = 2;

const cacheSchema = '''
  CREATE TABLE chat_conversation (
    id TEXT PRIMARY KEY,
    json TEXT NOT NULL
  );
  CREATE TABLE chat_message (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    json TEXT NOT NULL
  );
  CREATE INDEX chat_message_conversation
    ON chat_message (conversation_id, created_at, id);
  CREATE TABLE chat_message_in_progress (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    started_at TEXT NOT NULL,
    state TEXT NOT NULL,
    caption TEXT,
    reply_to_id TEXT,
    duration_seconds INTEGER
  );
  CREATE TABLE chat_file_in_progress (
    id TEXT PRIMARY KEY,
    message_id TEXT NOT NULL
      REFERENCES chat_message_in_progress ON DELETE CASCADE,
    position INTEGER NOT NULL,
    kind TEXT NOT NULL,
    source TEXT,
    path TEXT,
    original_bytes INTEGER,
    public_url TEXT,
    completed_at TEXT,
    UNIQUE (message_id, position)
  );
  CREATE TABLE chat_owner (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    json TEXT NOT NULL
  );
  CREATE TABLE chat_foreground (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    at TEXT NOT NULL
  );
''';
