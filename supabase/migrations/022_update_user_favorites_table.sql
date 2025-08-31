-- Update user_favorites table to support both restaurants and hotels

-- Drop existing constraints and indexes
DROP INDEX IF EXISTS idx_user_favorites_restaurant_id;

-- Add new columns
ALTER TABLE user_favorites 
ADD COLUMN IF NOT EXISTS item_type VARCHAR(20) CHECK (item_type IN ('restaurant', 'hotel'));

ALTER TABLE user_favorites 
ADD COLUMN IF NOT EXISTS item_id UUID;

-- Update existing data to use new structure (only if restaurant_id column exists)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'user_favorites' AND column_name = 'restaurant_id') THEN
        UPDATE user_favorites 
        SET item_type = 'restaurant', item_id = restaurant_id 
        WHERE item_type IS NULL AND restaurant_id IS NOT NULL;
    END IF;
END $$;

-- Make new columns NOT NULL after data migration
ALTER TABLE user_favorites 
ALTER COLUMN item_type SET NOT NULL;

ALTER TABLE user_favorites 
ALTER COLUMN item_id SET NOT NULL;

-- Drop old column and constraint (only if they exist)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'user_favorites' AND column_name = 'restaurant_id') THEN
        ALTER TABLE user_favorites DROP COLUMN restaurant_id;
    END IF;
END $$;

-- Update unique constraint
ALTER TABLE user_favorites 
DROP CONSTRAINT IF EXISTS user_favorites_user_id_restaurant_id_key;

ALTER TABLE user_favorites 
ADD CONSTRAINT user_favorites_user_id_item_type_item_id_key 
UNIQUE (user_id, item_type, item_id);

-- Create new indexes
CREATE INDEX IF NOT EXISTS idx_user_favorites_item_type ON user_favorites(item_type);
CREATE INDEX IF NOT EXISTS idx_user_favorites_item_id ON user_favorites(item_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_composite ON user_favorites(user_id, item_type, item_id);