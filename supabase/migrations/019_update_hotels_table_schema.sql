-- Update hotels table to add missing columns

-- Add missing columns to hotels table
ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS email VARCHAR(255);

ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS website VARCHAR(255);

ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS postal_code VARCHAR(20);

ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS price_range_min DECIMAL(10, 2);

ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS price_range_max DECIMAL(10, 2);

ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 8);

ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS longitude DECIMAL(11, 8);

-- Add missing columns to room_types table
ALTER TABLE room_types 
ADD COLUMN IF NOT EXISTS room_size DECIMAL(6, 2);