-- Create delivery companies table
CREATE TABLE IF NOT EXISTS delivery_companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    description TEXT,
    cover_image TEXT,
    delivery_time VARCHAR(100), -- e.g., "2-4 hours", "same day", "1-3 days"
    price_range VARCHAR(50), -- e.g., "200-500 DZD"
    rating DECIMAL(2, 1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create coverage areas table
CREATE TABLE IF NOT EXISTS delivery_coverage_areas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES delivery_companies(id) ON DELETE CASCADE,
    area_name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    wilaya VARCHAR(100), -- Algerian provinces
    postal_code VARCHAR(10),
    delivery_fee DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create payment methods table
CREATE TABLE IF NOT EXISTS delivery_payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES delivery_companies(id) ON DELETE CASCADE,
    method_name VARCHAR(100) NOT NULL, -- e.g., "نقدي", "بطاقة ائتمان", "تحويل بنكي"
    method_type VARCHAR(50), -- e.g., "cash", "card", "bank_transfer", "mobile_payment"
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create delivery company images table
CREATE TABLE IF NOT EXISTS delivery_company_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES delivery_companies(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create triggers for updated_at
CREATE TRIGGER update_delivery_companies_updated_at BEFORE UPDATE ON delivery_companies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE delivery_companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE delivery_coverage_areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE delivery_payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE delivery_company_images ENABLE ROW LEVEL SECURITY;

-- Create policies for delivery companies
CREATE POLICY "Anyone can view active delivery companies" ON delivery_companies
    FOR SELECT USING (is_active = true);

CREATE POLICY "Owners can manage their delivery companies" ON delivery_companies
    FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Admins can manage all delivery companies" ON delivery_companies
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for coverage areas
CREATE POLICY "Anyone can view active coverage areas" ON delivery_coverage_areas
    FOR SELECT USING (is_active = true AND EXISTS (
        SELECT 1 FROM delivery_companies WHERE id = delivery_coverage_areas.company_id AND is_active = true
    ));

CREATE POLICY "Company owners can manage coverage areas" ON delivery_coverage_areas
    FOR ALL USING (EXISTS (
        SELECT 1 FROM delivery_companies WHERE id = delivery_coverage_areas.company_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all coverage areas" ON delivery_coverage_areas
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for payment methods
CREATE POLICY "Anyone can view active payment methods" ON delivery_payment_methods
    FOR SELECT USING (is_active = true AND EXISTS (
        SELECT 1 FROM delivery_companies WHERE id = delivery_payment_methods.company_id AND is_active = true
    ));

CREATE POLICY "Company owners can manage payment methods" ON delivery_payment_methods
    FOR ALL USING (EXISTS (
        SELECT 1 FROM delivery_companies WHERE id = delivery_payment_methods.company_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all payment methods" ON delivery_payment_methods
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for delivery company images
CREATE POLICY "Anyone can view delivery company images" ON delivery_company_images
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM delivery_companies WHERE id = delivery_company_images.company_id AND is_active = true
    ));

CREATE POLICY "Company owners can manage images" ON delivery_company_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM delivery_companies WHERE id = delivery_company_images.company_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all delivery company images" ON delivery_company_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));