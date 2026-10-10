const schemaMigrations = [
  '''
  CREATE TABLE memory_food (
    mfp_food_id TEXT PRIMARY KEY,
    mfp_description TEXT NOT NULL,
    kind TEXT NOT NULL CHECK (kind IN ('ekklo', 'own_copy')),
    ekklo_food_id TEXT NOT NULL,
    ekklo_food_name TEXT NOT NULL,
    mfp_food_version TEXT
  );
  CREATE TABLE memory_unit (
    mfp_food_id TEXT NOT NULL REFERENCES memory_food ON DELETE CASCADE,
    mfp_unit TEXT NOT NULL,
    grams REAL NOT NULL,
    PRIMARY KEY (mfp_food_id, mfp_unit)
  );
  CREATE TABLE memory_meal (
    mfp_meal_name TEXT PRIMARY KEY,
    ekklo_meal_name TEXT NOT NULL
  );
  CREATE TABLE sent_link (
    mfp_entry_id TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    mfp_food_id TEXT NOT NULL,
    mfp_meal_name TEXT NOT NULL,
    mfp_servings REAL NOT NULL,
    mfp_serving_value REAL NOT NULL,
    mfp_serving_unit TEXT NOT NULL,
    ekklo_meal_id TEXT NOT NULL,
    ekklo_item_id TEXT NOT NULL UNIQUE,
    sent_at TEXT NOT NULL
  );
  CREATE INDEX sent_link_date ON sent_link (date);
  ''',
  '''
  ALTER TABLE memory_food ADD COLUMN mfp_unit TEXT;
  ''',
  '''
  CREATE TABLE memory_own_copy (
    mfp_food_id TEXT NOT NULL,
    mfp_unit TEXT NOT NULL,
    mfp_description TEXT NOT NULL,
    kind TEXT NOT NULL CHECK (kind = 'own_copy'),
    ekklo_food_id TEXT NOT NULL,
    ekklo_food_name TEXT NOT NULL,
    mfp_food_version TEXT,
    PRIMARY KEY (mfp_food_id, mfp_unit)
  );
  INSERT INTO memory_own_copy (
    mfp_food_id,
    mfp_unit,
    mfp_description,
    kind,
    ekklo_food_id,
    ekklo_food_name,
    mfp_food_version
  )
  SELECT
    mfp_food_id,
    mfp_unit,
    mfp_description,
    kind,
    ekklo_food_id,
    ekklo_food_name,
    mfp_food_version
  FROM memory_food
  WHERE kind = 'own_copy' AND mfp_unit IS NOT NULL;
  DELETE FROM memory_food WHERE kind = 'own_copy';
  ALTER TABLE memory_food DROP COLUMN mfp_unit;
  ALTER TABLE memory_food DROP COLUMN mfp_food_version;
  ''',
];
