-- Create hotels table
CREATE TABLE IF NOT EXISTS hotels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    wilaya VARCHAR(100), -- Algerian provinces
    description TEXT,
    cover_image TEXT,
    star_rating INTEGER CHECK (star_rating >= 1 AND star_rating <= 5),
    price_range VARCHAR(50), -- e.g., "5000-15000 DZD/night"
    rating DECIMAL(2, 1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    check_in_time TIME DEFAULT '14:00',
    check_out_time TIME DEFAULT '12:00',
    is_active BOOLEAN DEFAULT true,
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create room types table
CREATE TABLE IF NOT EXISTS room_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL, -- e.g., "غرفة مفردة", "جناح ملكي"
    description TEXT,
    max_occupancy INTEGER NOT NULL,
    bed_type VARCHAR(100), -- e.g., "سرير مفرد", "سرير مزدوج", "أسرة منفصلة"
    room_size_sqm DECIMAL(6, 2),
    price_per_night DECIMAL(10, 2) NOT NULL,
    total_rooms INTEGER DEFAULT 1,
    amenities TEXT[], -- Array of amenities
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create hotel amenities table
CREATE TABLE IF NOT EXISTS hotel_amenities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
    amenity_name VARCHAR(255) NOT NULL, -- e.g., "واي فاي مجاني", "مسبح", "مطعم", "موقف سيارات"
    amenity_type VARCHAR(100), -- e.g., "connectivity", "recreation", "dining", "parking"
    is_free BOOLEAN DEFAULT true,
    additional_cost DECIMAL(10, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create hotel images table
CREATE TABLE IF NOT EXISTS hotel_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
    room_type_id UUID REFERENCES room_types(id) ON DELETE CASCADE, -- NULL for hotel general images
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    image_type VARCHAR(50) DEFAULT 'general', -- 'general', 'room', 'amenity', 'exterior', 'interior'
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create hotel policies table
CREATE TABLE IF NOT EXISTS hotel_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hotel_id UUID REFERENCES hotels(id) ON DELETE CASCADE,
    policy_type VARCHAR(100) NOT NULL, -- e.g., "cancellation", "pet", "smoking", "children"
    policy_title VARCHAR(255),
    policy_description TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create triggers for updated_at
CREATE TRIGGER update_hotels_updated_at BEFORE UPDATE ON hotels
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_room_types_updated_at BEFORE UPDATE ON room_types
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE hotels ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE hotel_amenities ENABLE ROW LEVEL SECURITY;
ALTER TABLE hotel_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE hotel_policies ENABLE ROW LEVEL SECURITY;

-- Create policies for hotels
CREATE POLICY "Anyone can view active hotels" ON hotels
    FOR SELECT USING (is_active = true);

CREATE POLICY "Owners can manage their hotels" ON hotels
    FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Admins can manage all hotels" ON hotels
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for room types
CREATE POLICY "Anyone can view active room types" ON room_types
    FOR SELECT USING (is_active = true AND EXISTS (
        SELECT 1 FROM hotels WHERE id = room_types.hotel_id AND is_active = true
    ));

CREATE POLICY "Hotel owners can manage room types" ON room_types
    FOR ALL USING (EXISTS (
        SELECT 1 FROM hotels WHERE id = room_types.hotel_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all room types" ON room_types
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for hotel amenities
CREATE POLICY "Anyone can view hotel amenities" ON hotel_amenities
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM hotels WHERE id = hotel_amenities.hotel_id AND is_active = true
    ));

CREATE POLICY "Hotel owners can manage amenities" ON hotel_amenities
    FOR ALL USING (EXISTS (
        SELECT 1 FROM hotels WHERE id = hotel_amenities.hotel_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all hotel amenities" ON hotel_amenities
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for hotel images
CREATE POLICY "Anyone can view hotel images" ON hotel_images
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM hotels WHERE id = hotel_images.hotel_id AND is_active = true
    ));

CREATE POLICY "Hotel owners can manage images" ON hotel_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM hotels WHERE id = hotel_images.hotel_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all hotel images" ON hotel_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for hotel policies
CREATE POLICY "Anyone can view active hotel policies" ON hotel_policies
    FOR SELECT USING (is_active = true AND EXISTS (
        SELECT 1 FROM hotels WHERE id = hotel_policies.hotel_id AND is_active = true
    ));

CREATE POLICY "Hotel owners can manage policies" ON hotel_policies
    FOR ALL USING (EXISTS (
        SELECT 1 FROM hotels WHERE id = hotel_policies.hotel_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all hotel policies" ON hotel_policies
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));