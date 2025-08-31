-- Create travel agencies table
CREATE TABLE IF NOT EXISTS travel_agencies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    description TEXT,
    cover_image TEXT,
    price_range VARCHAR(50), -- e.g., "$100-$500", "متوسط", "مرتفع"
    rating DECIMAL(2, 1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create travel offers table
CREATE TABLE IF NOT EXISTS travel_offers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agency_id UUID REFERENCES travel_agencies(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2),
    duration_days INTEGER,
    offer_type VARCHAR(50), -- e.g., "رحلة", "باقة سياحية", "عمرة", "حج"
    image TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create destinations table
CREATE TABLE IF NOT EXISTS destinations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agency_id UUID REFERENCES travel_agencies(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    destination_type VARCHAR(20) CHECK (destination_type IN ('domestic', 'international')), -- داخلية/خارجية
    description TEXT,
    image TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create travel agency images table
CREATE TABLE IF NOT EXISTS travel_agency_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agency_id UUID REFERENCES travel_agencies(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create triggers for updated_at
CREATE TRIGGER update_travel_agencies_updated_at BEFORE UPDATE ON travel_agencies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_travel_offers_updated_at BEFORE UPDATE ON travel_offers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE travel_agencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE travel_offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE destinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE travel_agency_images ENABLE ROW LEVEL SECURITY;

-- Create policies for travel agencies
CREATE POLICY "Anyone can view active travel agencies" ON travel_agencies
    FOR SELECT USING (is_active = true);

CREATE POLICY "Owners can manage their travel agencies" ON travel_agencies
    FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Admins can manage all travel agencies" ON travel_agencies
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for travel offers
CREATE POLICY "Anyone can view available travel offers" ON travel_offers
    FOR SELECT USING (is_available = true AND EXISTS (
        SELECT 1 FROM travel_agencies WHERE id = travel_offers.agency_id AND is_active = true
    ));

CREATE POLICY "Agency owners can manage their offers" ON travel_offers
    FOR ALL USING (EXISTS (
        SELECT 1 FROM travel_agencies WHERE id = travel_offers.agency_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all travel offers" ON travel_offers
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for destinations
CREATE POLICY "Anyone can view destinations" ON destinations
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM travel_agencies WHERE id = destinations.agency_id AND is_active = true
    ));

CREATE POLICY "Agency owners can manage destinations" ON destinations
    FOR ALL USING (EXISTS (
        SELECT 1 FROM travel_agencies WHERE id = destinations.agency_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all destinations" ON destinations
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for travel agency images
CREATE POLICY "Anyone can view travel agency images" ON travel_agency_images
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM travel_agencies WHERE id = travel_agency_images.agency_id AND is_active = true
    ));

CREATE POLICY "Agency owners can manage images" ON travel_agency_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM travel_agencies WHERE id = travel_agency_images.agency_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all travel agency images" ON travel_agency_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));