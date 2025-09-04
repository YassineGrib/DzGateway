-- Create storage policies for buckets and objects
-- This migration adds Row Level Security policies for Supabase Storage

-- Enable RLS on storage.buckets and storage.objects (if not already enabled)
-- Note: These tables are managed by Supabase, but we can add policies

-- Policy to allow authenticated users to create buckets
CREATE POLICY "Authenticated users can create buckets" ON storage.buckets
    FOR INSERT TO authenticated
    WITH CHECK (true);

-- Policy to allow authenticated users to view buckets
CREATE POLICY "Authenticated users can view buckets" ON storage.buckets
    FOR SELECT TO authenticated
    USING (true);

-- Policy to allow authenticated users to upload objects to restaurant-images bucket
CREATE POLICY "Authenticated users can upload to restaurant-images" ON storage.objects
    FOR INSERT TO authenticated
    WITH CHECK (bucket_id = 'restaurant-images');

-- Policy to allow authenticated users to view objects in restaurant-images bucket
CREATE POLICY "Anyone can view restaurant-images objects" ON storage.objects
    FOR SELECT
    USING (bucket_id = 'restaurant-images');

-- Policy to allow authenticated users to update objects in restaurant-images bucket
CREATE POLICY "Authenticated users can update restaurant-images" ON storage.objects
    FOR UPDATE TO authenticated
    USING (bucket_id = 'restaurant-images')
    WITH CHECK (bucket_id = 'restaurant-images');

-- Policy to allow authenticated users to delete objects in restaurant-images bucket
CREATE POLICY "Authenticated users can delete restaurant-images" ON storage.objects
    FOR DELETE TO authenticated
    USING (bucket_id = 'restaurant-images');

-- Create the restaurant-images bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'restaurant-images',
    'restaurant-images',
    true,
    5242880, -- 5MB in bytes
    ARRAY['image/jpeg', 'image/png', 'image/webp']
) ON CONFLICT (id) DO NOTHING;