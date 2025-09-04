-- Insert admin account
-- This migration creates a default admin user for the DzGateway application

INSERT INTO users (
    id,
    email,
    full_name,
    phone,
    role,
    is_active,
    created_at,
    updated_at
) VALUES (
    gen_random_uuid(),
    'admin@dzgateway.com',
    'System Administrator',
    '+213555000000',
    'admin',
    true,
    NOW(),
    NOW()
) ON CONFLICT (email) DO NOTHING;

-- Note: This creates an admin user in the users table.
-- For authentication, you'll need to create the corresponding auth user
-- in Supabase Auth dashboard or through the Supabase client.
-- The email 'admin@dzgateway.com' should be used to create the auth user
-- with a secure password.