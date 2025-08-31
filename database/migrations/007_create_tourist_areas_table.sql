-- Create tourist areas table
CREATE TABLE IF NOT EXISTS tourist_areas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address TEXT,
    city VARCHAR(100),
    wilaya VARCHAR(100), -- Algerian provinces
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    area_type VARCHAR(100), -- e.g., "historical", "natural", "cultural", "recreational", "religious"
    cover_image TEXT,
    entry_fee DECIMAL(10, 2) DEFAULT 0,
    opening_hours VARCHAR(255), -- e.g., "8:00 AM - 6:00 PM"
    best_visit_season VARCHAR(100), -- e.g., "spring", "summer", "autumn", "winter", "all_year"
    difficulty_level VARCHAR(50), -- e.g., "easy", "moderate", "difficult"
    estimated_visit_duration VARCHAR(100), -- e.g., "2-3 hours", "half day", "full day"
    rating DECIMAL(2, 1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tourist area features table
CREATE TABLE IF NOT EXISTS tourist_area_features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    area_id UUID REFERENCES tourist_areas(id) ON DELETE CASCADE,
    feature_name VARCHAR(255) NOT NULL, -- e.g., "مرشد سياحي", "مطعم", "موقف سيارات", "دورات مياه"
    feature_type VARCHAR(100), -- e.g., "service", "facility", "activity", "amenity"
    is_available BOOLEAN DEFAULT true,
    additional_cost DECIMAL(10, 2) DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tourist area images table
CREATE TABLE IF NOT EXISTS tourist_area_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    area_id UUID REFERENCES tourist_areas(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    image_type VARCHAR(50) DEFAULT 'general', -- 'general', 'landscape', 'activity', 'facility'
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tourist area reviews table
CREATE TABLE IF NOT EXISTS tourist_area_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    area_id UUID REFERENCES tourist_areas(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    visit_date DATE,
    is_verified BOOLEAN DEFAULT false,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(area_id, user_id) -- One review per user per area
);

-- Create tourist area tips table
CREATE TABLE IF NOT EXISTS tourist_area_tips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    area_id UUID REFERENCES tourist_areas(id) ON DELETE CASCADE,
    tip_title VARCHAR(255),
    tip_content TEXT NOT NULL,
    tip_type VARCHAR(100), -- e.g., "safety", "transportation", "best_time", "what_to_bring"
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create nearby attractions table
CREATE TABLE IF NOT EXISTS nearby_attractions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    area_id UUID REFERENCES tourist_areas(id) ON DELETE CASCADE,
    nearby_area_id UUID REFERENCES tourist_areas(id) ON DELETE CASCADE,
    distance_km DECIMAL(8, 2),
    travel_time_minutes INTEGER,
    transportation_method VARCHAR(100), -- e.g., "walking", "car", "public_transport"
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CHECK (area_id != nearby_area_id) -- Prevent self-reference
);

-- Create triggers for updated_at
CREATE TRIGGER update_tourist_areas_updated_at BEFORE UPDATE ON tourist_areas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tourist_area_reviews_updated_at BEFORE UPDATE ON tourist_area_reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE tourist_areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE tourist_area_features ENABLE ROW LEVEL SECURITY;
ALTER TABLE tourist_area_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE tourist_area_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE tourist_area_tips ENABLE ROW LEVEL SECURITY;
ALTER TABLE nearby_attractions ENABLE ROW LEVEL SECURITY;

-- Create policies for tourist areas
CREATE POLICY "Anyone can view active tourist areas" ON tourist_areas
    FOR SELECT USING (is_active = true);

CREATE POLICY "Admins can manage all tourist areas" ON tourist_areas
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for tourist area features
CREATE POLICY "Anyone can view tourist area features" ON tourist_area_features
    FOR SELECT USING (is_available = true AND EXISTS (
        SELECT 1 FROM tourist_areas WHERE id = tourist_area_features.area_id AND is_active = true
    ));

CREATE POLICY "Admins can manage tourist area features" ON tourist_area_features
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for tourist area images
CREATE POLICY "Anyone can view tourist area images" ON tourist_area_images
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM tourist_areas WHERE id = tourist_area_images.area_id AND is_active = true
    ));

CREATE POLICY "Admins can manage tourist area images" ON tourist_area_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for tourist area reviews
CREATE POLICY "Anyone can view tourist area reviews" ON tourist_area_reviews
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM tourist_areas WHERE id = tourist_area_reviews.area_id AND is_active = true
    ));

CREATE POLICY "Users can manage their own reviews" ON tourist_area_reviews
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all reviews" ON tourist_area_reviews
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for tourist area tips
CREATE POLICY "Anyone can view active tourist area tips" ON tourist_area_tips
    FOR SELECT USING (is_active = true AND EXISTS (
        SELECT 1 FROM tourist_areas WHERE id = tourist_area_tips.area_id AND is_active = true
    ));

CREATE POLICY "Admins can manage tourist area tips" ON tourist_area_tips
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for nearby attractions
CREATE POLICY "Anyone can view nearby attractions" ON nearby_attractions
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM tourist_areas WHERE id = nearby_attractions.area_id AND is_active = true
    ) AND EXISTS (
        SELECT 1 FROM tourist_areas WHERE id = nearby_attractions.nearby_area_id AND is_active = true
    ));

CREATE POLICY "Admins can manage nearby attractions" ON nearby_attractions
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));