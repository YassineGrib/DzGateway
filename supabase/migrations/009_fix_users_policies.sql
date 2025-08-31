-- Fix infinite recursion in users table policies
-- Drop existing problematic policies
DROP POLICY IF EXISTS "Admins can view all users" ON users;
DROP POLICY IF EXISTS "Admins can update all users" ON users;

-- Create new policies without recursion
-- Allow users to insert their own profile (for registration)
CREATE POLICY "Users can insert own profile" ON users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Simple admin policies using auth.jwt() instead of recursive queries
CREATE POLICY "Admins can view all users" ON users
    FOR SELECT USING (
        auth.jwt() ->> 'role' = 'admin' OR auth.uid() = id
    );

CREATE POLICY "Admins can update all users" ON users
    FOR UPDATE USING (
        auth.jwt() ->> 'role' = 'admin' OR auth.uid() = id
    );

-- Allow service role to insert users (for registration process)
CREATE POLICY "Service role can insert users" ON users
    FOR INSERT WITH CHECK (true);

-- Grant necessary permissions
GRANT SELECT, INSERT, UPDATE ON users TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO service_role;