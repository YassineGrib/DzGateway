-- Create restaurants table
CREATE TABLE IF NOT EXISTS restaurants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    phone VARCHAR(20),
    description TEXT,
    cover_image TEXT,
    rating DECIMAL(2, 1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create menu items table
CREATE TABLE IF NOT EXISTS menu_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100),
    image TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create restaurant images table
CREATE TABLE IF NOT EXISTS restaurant_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create triggers for updated_at
CREATE TRIGGER update_restaurants_updated_at BEFORE UPDATE ON restaurants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_items_updated_at BEFORE UPDATE ON menu_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurant_images ENABLE ROW LEVEL SECURITY;

-- Create policies for restaurants
CREATE POLICY "Anyone can view active restaurants" ON restaurants
    FOR SELECT USING (is_active = true);

CREATE POLICY "Owners can manage their restaurants" ON restaurants
    FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Admins can manage all restaurants" ON restaurants
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for menu items
CREATE POLICY "Anyone can view menu items" ON menu_items
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM restaurants WHERE id = menu_items.restaurant_id AND is_active = true
    ));

CREATE POLICY "Restaurant owners can manage menu items" ON menu_items
    FOR ALL USING (EXISTS (
        SELECT 1 FROM restaurants WHERE id = menu_items.restaurant_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all menu items" ON menu_items
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for restaurant images
CREATE POLICY "Anyone can view restaurant images" ON restaurant_images
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM restaurants WHERE id = restaurant_images.restaurant_id AND is_active = true
    ));

CREATE POLICY "Restaurant owners can manage images" ON restaurant_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM restaurants WHERE id = restaurant_images.restaurant_id AND owner_id = auth.uid()
    ));

CREATE POLICY "Admins can manage all restaurant images" ON restaurant_images
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));