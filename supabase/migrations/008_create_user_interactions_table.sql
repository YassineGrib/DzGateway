-- Create user favorites table
CREATE TABLE IF NOT EXISTS user_favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    entity_type VARCHAR(50) NOT NULL, -- 'restaurant', 'travel_agency', 'transport_company', 'delivery_company', 'hotel', 'tourist_area'
    entity_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, entity_type, entity_id) -- Prevent duplicate favorites
);

-- Create user reviews table (generic reviews for all entities)
CREATE TABLE IF NOT EXISTS user_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    entity_type VARCHAR(50) NOT NULL, -- 'restaurant', 'travel_agency', 'transport_company', 'delivery_company', 'hotel'
    entity_id UUID NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    is_verified BOOLEAN DEFAULT false,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, entity_type, entity_id) -- One review per user per entity
);

-- Create bookings table (for hotels and travel offers)
CREATE TABLE IF NOT EXISTS bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    booking_type VARCHAR(50) NOT NULL, -- 'hotel', 'travel_offer'
    entity_id UUID NOT NULL, -- hotel_id or travel_offer_id
    booking_reference VARCHAR(100) UNIQUE NOT NULL,
    booking_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'confirmed', 'cancelled', 'completed'
    check_in_date DATE,
    check_out_date DATE,
    guests_count INTEGER DEFAULT 1,
    total_amount DECIMAL(12, 2),
    payment_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'paid', 'refunded', 'failed'
    payment_method VARCHAR(100),
    special_requests TEXT,
    booking_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user notifications table
CREATE TABLE IF NOT EXISTS user_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(100), -- 'booking', 'promotion', 'system', 'review', 'favorite'
    entity_type VARCHAR(50), -- Related entity type if applicable
    entity_id UUID, -- Related entity ID if applicable
    is_read BOOLEAN DEFAULT false,
    action_url TEXT, -- Deep link or URL for action
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user search history table
CREATE TABLE IF NOT EXISTS user_search_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    search_query VARCHAR(500) NOT NULL,
    search_type VARCHAR(50), -- 'restaurant', 'hotel', 'travel', 'transport', 'delivery', 'tourist_area'
    search_filters JSONB, -- Store filter parameters as JSON
    results_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user sessions table (for analytics and security)
CREATE TABLE IF NOT EXISTS user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    device_info JSONB, -- Device type, OS, app version, etc.
    ip_address INET,
    location_info JSONB, -- City, country if available
    is_active BOOLEAN DEFAULT true,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- Create app feedback table
CREATE TABLE IF NOT EXISTS app_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    feedback_type VARCHAR(100), -- 'bug_report', 'feature_request', 'general', 'complaint'
    subject VARCHAR(255),
    message TEXT NOT NULL,
    app_version VARCHAR(50),
    device_info JSONB,
    status VARCHAR(50) DEFAULT 'open', -- 'open', 'in_progress', 'resolved', 'closed'
    admin_response TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create triggers for updated_at
CREATE TRIGGER update_user_reviews_updated_at BEFORE UPDATE ON user_reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_app_feedback_updated_at BEFORE UPDATE ON app_feedback
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable RLS
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_search_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_feedback ENABLE ROW LEVEL SECURITY;

-- Create policies for user favorites
CREATE POLICY "Users can manage their own favorites" ON user_favorites
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all favorites" ON user_favorites
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for user reviews
CREATE POLICY "Anyone can view user reviews" ON user_reviews
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own reviews" ON user_reviews
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reviews" ON user_reviews
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own reviews" ON user_reviews
    FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all reviews" ON user_reviews
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for bookings
CREATE POLICY "Users can manage their own bookings" ON bookings
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all bookings" ON bookings
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for user notifications
CREATE POLICY "Users can manage their own notifications" ON user_notifications
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all notifications" ON user_notifications
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for user search history
CREATE POLICY "Users can manage their own search history" ON user_search_history
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admins can view search analytics" ON user_search_history
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for user sessions
CREATE POLICY "Users can view their own sessions" ON user_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all sessions" ON user_sessions
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create policies for app feedback
CREATE POLICY "Users can insert their own feedback" ON app_feedback
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can select their own feedback" ON app_feedback
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own feedback" ON app_feedback
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Anonymous users can submit feedback" ON app_feedback
    FOR INSERT WITH CHECK (user_id IS NULL);

CREATE POLICY "Admins can manage all feedback" ON app_feedback
    FOR ALL USING (EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Create indexes for better performance
CREATE INDEX idx_user_favorites_user_id ON user_favorites(user_id);
CREATE INDEX idx_user_favorites_entity ON user_favorites(entity_type, entity_id);
CREATE INDEX idx_user_reviews_entity ON user_reviews(entity_type, entity_id);
CREATE INDEX idx_user_reviews_rating ON user_reviews(rating);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_status ON bookings(booking_status);
CREATE INDEX idx_bookings_dates ON bookings(check_in_date, check_out_date);
CREATE INDEX idx_user_notifications_user_id ON user_notifications(user_id);
CREATE INDEX idx_user_notifications_unread ON user_notifications(user_id, is_read);
CREATE INDEX idx_user_search_history_user_id ON user_search_history(user_id);
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_active ON user_sessions(is_active, expires_at);