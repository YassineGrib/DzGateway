-- Create transport companies table
CREATE TABLE IF NOT EXISTS transport_companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    transport_type VARCHAR(20) CHECK (transport_type IN ('public', 'private')), -- عام / خاص
    description TEXT,
    cover_image TEXT,
    price_range VARCHAR(50), -- e.g., "10-50 DZD", "متوسط"
    rating DECIMAL(2, 1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create routes table
CREATE TABLE IF NOT EXISTS transport_routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES transport_companies(id) ON DELETE CASCADE,
    route_name VARCHAR(255) NOT NULL,
    origin VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    distance_km DECIMAL(8, 2),
    estimated_duration_minutes INTEGER,
    price DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create schedules table
CREATE TABLE IF NOT EXISTS transport_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID REFERENCES transport_routes(id) ON DELETE CASCADE,
    departure_time TIME NOT NULL,
    arrival_time TIME,
    days_of_week INTEGER[] DEFAULT '{1,2,3,4,5,6,7}', -- 1=Monday, 7=Sunday
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create transport company images table
CREATE TABLE IF NOT EXISTS transport_company_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES transport_companies(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create triggers for updated_at
CREATE TRIGGER update_transport_companies_updated_at BEFORE UPDATE ON transport_companies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transport_routes_updated_at BEFORE UPDATE ON transport_routes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE transport_companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE transport_routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE transport_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE transport_company_images ENABLE ROW LEVEL SECURITY;

-- Create policies for transport companies
CREATE POLICY "Anyone can view active transport companies" ON transport_companies
    FOR SELECT USING (is_active = true);

CREATE POLICY "Owners can manage their transport companies" ON transport_companies
    FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Admins can manage all transport companies" ON transport_companies
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for transport routes
CREATE POLICY "Anyone can view active routes" ON transport_routes
    FOR SELECT USING (is_active = true AND EXISTS (
        SELECT 1 FROM transport_companies WHERE id = transport_routes.company_id AND is_active = true
    ));

CREATE POLICY "Company owners can manage routes" ON transport_routes
    FOR ALL USING (EXISTS (
        SELECT 1 FROM transport_companies WHERE id = transport_routes.company_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all routes" ON transport_routes
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for transport schedules
CREATE POLICY "Anyone can view active schedules" ON transport_schedules
    FOR SELECT USING (is_active = true AND EXISTS (
        SELECT 1 FROM transport_routes tr 
        JOIN transport_companies tc ON tr.company_id = tc.id 
        WHERE tr.id = transport_schedules.route_id AND tc.is_active = true AND tr.is_active = true
    ));

CREATE POLICY "Company owners can manage schedules" ON transport_schedules
    FOR ALL USING (EXISTS (
        SELECT 1 FROM transport_routes tr 
        JOIN transport_companies tc ON tr.company_id = tc.id 
        WHERE tr.id = transport_schedules.route_id AND tc.owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all schedules" ON transport_schedules
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for transport company images
CREATE POLICY "Anyone can view transport company images" ON transport_company_images
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM transport_companies WHERE id = transport_company_images.company_id AND is_active = true
    ));

CREATE POLICY "Company owners can manage images" ON transport_company_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM transport_companies WHERE id = transport_company_images.company_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all transport company images" ON transport_company_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));