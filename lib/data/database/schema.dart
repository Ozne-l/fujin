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
  '''
  CREATE TABLE goals (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    kilocalories REAL NOT NULL CHECK (kilocalories > 0),
    protein REAL CHECK (protein > 0),
    carbohydrates REAL CHECK (carbohydrates > 0),
    fat REAL CHECK (fat > 0),
    fiber REAL CHECK (fiber > 0)
  );
  ''',
  '''
  CREATE TABLE unattended_item (
    mfp_entry_id TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    ekklo_meal_name TEXT NOT NULL,
    ekklo_food_id TEXT NOT NULL,
    quantity REAL NOT NULL,
    quantity_type TEXT NOT NULL
  );
  CREATE INDEX unattended_item_date ON unattended_item (date);
  ''',
  '''
  CREATE TABLE recent_food (
    mfp_food_id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    brand_name TEXT,
    serving_value REAL NOT NULL,
    serving_unit TEXT NOT NULL,
    servings REAL NOT NULL,
    kilocalories REAL,
    added_at TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE memory_barcode (
    barcode TEXT PRIMARY KEY,
    mfp_food_id TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE food (
    id TEXT PRIMARY KEY,
    name TEXT,
    brand TEXT,
    energy_value REAL,
    energy_unit TEXT CHECK (energy_unit IN ('calories', 'kilojoules')),
    protein REAL,
    carbohydrates REAL,
    net_carbs REAL,
    fiber REAL,
    sugar REAL,
    added_sugars REAL,
    sugar_alcohols REAL,
    fat REAL,
    saturated_fat REAL,
    monounsaturated_fat REAL,
    polyunsaturated_fat REAL,
    trans_fat REAL,
    cholesterol_milligrams REAL,
    sodium_milligrams REAL,
    potassium_milligrams REAL,
    vitamin_a REAL,
    vitamin_c REAL,
    vitamin_d REAL,
    calcium REAL,
    iron REAL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE TABLE food_serving (
    id TEXT PRIMARY KEY,
    food_id TEXT NOT NULL REFERENCES food ON DELETE CASCADE,
    position INTEGER NOT NULL,
    value REAL NOT NULL,
    unit TEXT NOT NULL,
    nutrition_multiplier REAL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE UNIQUE INDEX food_serving_position
    ON food_serving (food_id, position) WHERE deleted_at IS NULL;
  CREATE TABLE food_unit (
    id TEXT PRIMARY KEY,
    food_id TEXT NOT NULL REFERENCES food ON DELETE CASCADE,
    unit TEXT NOT NULL,
    grams REAL NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE UNIQUE INDEX food_unit_unit
    ON food_unit (food_id, unit) WHERE deleted_at IS NULL;
  CREATE TABLE food_reference (
    id TEXT PRIMARY KEY,
    food_id TEXT NOT NULL REFERENCES food ON DELETE CASCADE,
    kind TEXT NOT NULL CHECK (kind IN ('mfp', 'ekklo', 'own_copy')),
    external_id TEXT NOT NULL,
    version TEXT,
    name TEXT,
    unit TEXT,
    updated_at TEXT NOT NULL,
    deleted_at TEXT,
    CHECK ((kind = 'mfp') = (name IS NULL)),
    CHECK ((kind = 'own_copy') = (unit IS NOT NULL)),
    CHECK (kind <> 'ekklo' OR version IS NULL)
  );
  CREATE UNIQUE INDEX food_reference_mfp_food
    ON food_reference (external_id) WHERE kind = 'mfp' AND deleted_at IS NULL;
  CREATE UNIQUE INDEX food_reference_mfp
    ON food_reference (food_id) WHERE kind = 'mfp' AND deleted_at IS NULL;
  CREATE UNIQUE INDEX food_reference_ekklo
    ON food_reference (food_id) WHERE kind = 'ekklo' AND deleted_at IS NULL;
  CREATE UNIQUE INDEX food_reference_own_copy
    ON food_reference (food_id, unit)
    WHERE kind = 'own_copy' AND deleted_at IS NULL;
  CREATE TABLE barcode_link (
    id TEXT PRIMARY KEY,
    barcode TEXT NOT NULL,
    food_id TEXT NOT NULL REFERENCES food ON DELETE CASCADE,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE UNIQUE INDEX barcode_link_barcode
    ON barcode_link (barcode) WHERE deleted_at IS NULL;
  CREATE TABLE meal (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    position INTEGER NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE TABLE meal_mapping (
    id TEXT PRIMARY KEY,
    meal_id TEXT NOT NULL REFERENCES meal ON DELETE CASCADE,
    connector TEXT NOT NULL CHECK (connector IN ('mfp', 'ekklo')),
    name TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE UNIQUE INDEX meal_mapping_meal
    ON meal_mapping (meal_id, connector) WHERE deleted_at IS NULL;
  CREATE UNIQUE INDEX meal_mapping_mfp_name
    ON meal_mapping (name) WHERE connector = 'mfp' AND deleted_at IS NULL;
  CREATE TABLE entry (
    id TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    meal_id TEXT NOT NULL REFERENCES meal ON DELETE CASCADE,
    food_id TEXT NOT NULL REFERENCES food ON DELETE CASCADE,
    serving_value REAL NOT NULL,
    serving_unit TEXT NOT NULL,
    nutrition_multiplier REAL,
    servings REAL NOT NULL,
    energy_value REAL,
    energy_unit TEXT CHECK (energy_unit IN ('calories', 'kilojoules')),
    protein REAL,
    carbohydrates REAL,
    net_carbs REAL,
    fiber REAL,
    sugar REAL,
    added_sugars REAL,
    sugar_alcohols REAL,
    fat REAL,
    saturated_fat REAL,
    monounsaturated_fat REAL,
    polyunsaturated_fat REAL,
    trans_fat REAL,
    cholesterol_milligrams REAL,
    sodium_milligrams REAL,
    potassium_milligrams REAL,
    vitamin_a REAL,
    vitamin_c REAL,
    vitamin_d REAL,
    calcium REAL,
    iron REAL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE INDEX entry_date ON entry (date);
  CREATE TABLE mfp_link (
    id TEXT PRIMARY KEY,
    entry_id TEXT NOT NULL REFERENCES entry ON DELETE CASCADE,
    mfp_entry_id TEXT NOT NULL,
    date TEXT NOT NULL,
    meal_name TEXT NOT NULL,
    food_id TEXT NOT NULL,
    food_version TEXT,
    servings REAL NOT NULL,
    serving_value REAL NOT NULL,
    serving_unit TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  );
  CREATE UNIQUE INDEX mfp_link_entry
    ON mfp_link (entry_id) WHERE deleted_at IS NULL;
  CREATE UNIQUE INDEX mfp_link_mfp_entry
    ON mfp_link (mfp_entry_id) WHERE deleted_at IS NULL;
  CREATE TABLE ekklo_link (
    id TEXT PRIMARY KEY,
    entry_id TEXT NOT NULL REFERENCES entry ON DELETE CASCADE,
    ekklo_meal_id TEXT,
    ekklo_item_id TEXT,
    meal_id TEXT,
    food_id TEXT,
    servings REAL,
    serving_value REAL,
    serving_unit TEXT,
    sent_at TEXT,
    unattended_meal_name TEXT,
    unattended_food_id TEXT,
    unattended_quantity REAL,
    unattended_quantity_type TEXT,
    updated_at TEXT NOT NULL,
    deleted_at TEXT,
    CHECK (
      (ekklo_meal_id IS NULL) + (ekklo_item_id IS NULL) + (meal_id IS NULL)
        + (food_id IS NULL) + (servings IS NULL) + (serving_value IS NULL)
        + (serving_unit IS NULL) + (sent_at IS NULL) IN (0, 8)
    ),
    CHECK (
      (unattended_meal_name IS NULL) + (unattended_food_id IS NULL)
        + (unattended_quantity IS NULL)
        + (unattended_quantity_type IS NULL) IN (0, 4)
    ),
    CHECK (ekklo_item_id IS NOT NULL OR unattended_meal_name IS NOT NULL)
  );
  CREATE UNIQUE INDEX ekklo_link_entry
    ON ekklo_link (entry_id) WHERE deleted_at IS NULL;
  CREATE UNIQUE INDEX ekklo_link_item
    ON ekklo_link (ekklo_item_id)
    WHERE ekklo_item_id IS NOT NULL AND deleted_at IS NULL;

  CREATE TEMP TABLE migration_time AS
    SELECT strftime('%Y-%m-%dT%H:%M:%fZ', 'now') AS at;
  CREATE TEMP TABLE migrated_food AS
    SELECT
      fujin_id() AS id,
      known.mfp_food_id,
      coalesce(
        recent.description,
        matched.mfp_description,
        (
          SELECT copy.mfp_description FROM memory_own_copy copy
          WHERE copy.mfp_food_id = known.mfp_food_id
          ORDER BY copy.mfp_unit LIMIT 1
        )
      ) AS name,
      recent.brand_name AS brand
    FROM (
      SELECT mfp_food_id FROM memory_food
      UNION SELECT mfp_food_id FROM memory_own_copy
      UNION SELECT mfp_food_id FROM memory_barcode
      UNION SELECT mfp_food_id FROM recent_food
    ) known
    LEFT JOIN recent_food recent USING (mfp_food_id)
    LEFT JOIN memory_food matched USING (mfp_food_id);

  INSERT INTO food (id, name, brand, updated_at)
    SELECT id, name, brand, (SELECT at FROM migration_time)
    FROM migrated_food;
  INSERT INTO food_reference (id, food_id, kind, external_id, updated_at)
    SELECT fujin_id(), id, 'mfp', mfp_food_id, (SELECT at FROM migration_time)
    FROM migrated_food;
  INSERT INTO food_reference (
    id, food_id, kind, external_id, name, updated_at
  )
    SELECT
      fujin_id(), food.id, 'ekklo', matched.ekklo_food_id,
      matched.ekklo_food_name, (SELECT at FROM migration_time)
    FROM memory_food matched JOIN migrated_food food USING (mfp_food_id)
    WHERE matched.kind = 'ekklo';
  INSERT INTO food_reference (
    id, food_id, kind, external_id, version, name, unit, updated_at
  )
    SELECT
      fujin_id(), food.id, 'own_copy', copy.ekklo_food_id,
      copy.mfp_food_version, copy.ekklo_food_name, copy.mfp_unit,
      (SELECT at FROM migration_time)
    FROM memory_own_copy copy JOIN migrated_food food USING (mfp_food_id);
  INSERT INTO food_unit (id, food_id, unit, grams, updated_at)
    SELECT
      fujin_id(), food.id, unit.mfp_unit, unit.grams,
      (SELECT at FROM migration_time)
    FROM memory_unit unit JOIN migrated_food food USING (mfp_food_id);
  INSERT INTO barcode_link (id, barcode, food_id, updated_at)
    SELECT
      fujin_id(), link.barcode, food.id, (SELECT at FROM migration_time)
    FROM memory_barcode link JOIN migrated_food food USING (mfp_food_id);

  INSERT INTO meal (id, name, position, updated_at)
    SELECT
      fujin_id(), mfp_meal_name,
      row_number() OVER (ORDER BY mfp_meal_name) - 1,
      (SELECT at FROM migration_time)
    FROM memory_meal;
  INSERT INTO meal_mapping (id, meal_id, connector, name, updated_at)
    SELECT fujin_id(), id, 'mfp', name, (SELECT at FROM migration_time)
    FROM meal;
  INSERT INTO meal_mapping (id, meal_id, connector, name, updated_at)
    SELECT
      fujin_id(), meal.id, 'ekklo', mapping.ekklo_meal_name,
      (SELECT at FROM migration_time)
    FROM meal JOIN memory_meal mapping ON mapping.mfp_meal_name = meal.name;

  CREATE TABLE recent_food_by_food (
    food_id TEXT PRIMARY KEY REFERENCES food ON DELETE CASCADE,
    serving_value REAL NOT NULL,
    serving_unit TEXT NOT NULL,
    servings REAL NOT NULL,
    kilocalories REAL,
    added_at TEXT NOT NULL
  );
  INSERT INTO recent_food_by_food (
    food_id, serving_value, serving_unit, servings, kilocalories, added_at
  )
    SELECT
      food.id, recent.serving_value, recent.serving_unit, recent.servings,
      recent.kilocalories, recent.added_at
    FROM recent_food recent JOIN migrated_food food USING (mfp_food_id);
  DROP TABLE recent_food;
  ALTER TABLE recent_food_by_food RENAME TO recent_food;

  CREATE TABLE goals_stamped (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    kilocalories REAL NOT NULL CHECK (kilocalories > 0),
    protein REAL CHECK (protein > 0),
    carbohydrates REAL CHECK (carbohydrates > 0),
    fat REAL CHECK (fat > 0),
    fiber REAL CHECK (fiber > 0),
    updated_at TEXT NOT NULL
  );
  INSERT INTO goals_stamped (
    id, kilocalories, protein, carbohydrates, fat, fiber, updated_at
  )
    SELECT
      id, kilocalories, protein, carbohydrates, fat, fiber,
      (SELECT at FROM migration_time)
    FROM goals;
  DROP TABLE goals;
  ALTER TABLE goals_stamped RENAME TO goals;

  DROP TABLE memory_unit;
  DROP TABLE memory_food;
  DROP TABLE memory_own_copy;
  DROP TABLE memory_meal;
  DROP TABLE memory_barcode;
  DROP TABLE migrated_food;
  DROP TABLE migration_time;
  ''',
];
