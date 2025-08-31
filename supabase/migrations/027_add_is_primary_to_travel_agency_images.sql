-- Add is_primary column to travel_agency_images table
ALTER TABLE travel_agency_images ADD COLUMN IF NOT EXISTS is_primary BOOLEAN DEFAULT false;

-- Update existing records to set one image as primary for each agency
UPDATE travel_agency_images 
SET is_primary = true 
WHERE id IN (
    SELECT DISTINCT ON (agency_id) id 
    FROM travel_agency_images 
    ORDER BY agency_id, display_order, created_at
);