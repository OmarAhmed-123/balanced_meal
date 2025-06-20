-- supabase/migrations/20241216180000_balanced_meal_schema.sql
-- Balanced Meal Database Schema
-- Creates comprehensive database structure for the Balanced Meal application

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Custom types
CREATE TYPE public.gender_type AS ENUM ('male', 'female', 'other');
CREATE TYPE public.activity_level AS ENUM ('sedentary', 'light', 'moderate', 'active', 'very_active');
CREATE TYPE public.meal_category AS ENUM ('breakfast', 'lunch', 'dinner', 'snack');
CREATE TYPE public.ingredient_category AS ENUM ('protein', 'carbohydrates', 'vegetables', 'fruits', 'dairy', 'fats', 'spices', 'beverages');
CREATE TYPE public.order_status AS ENUM ('pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled');

-- 2. User profiles table (intermediary for auth relationships)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    age INTEGER,
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    gender public.gender_type,
    activity_level public.activity_level DEFAULT 'moderate'::public.activity_level,
    daily_calorie_goal INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Ingredients table
CREATE TABLE public.ingredients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    category public.ingredient_category NOT NULL,
    calories_per_100g DECIMAL(6,2) NOT NULL,
    protein_per_100g DECIMAL(5,2) DEFAULT 0,
    carbs_per_100g DECIMAL(5,2) DEFAULT 0,
    fat_per_100g DECIMAL(5,2) DEFAULT 0,
    fiber_per_100g DECIMAL(5,2) DEFAULT 0,
    sugar_per_100g DECIMAL(5,2) DEFAULT 0,
    sodium_per_100g DECIMAL(6,2) DEFAULT 0,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. BMR calculations table
CREATE TABLE public.bmr_calculations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    bmr_value DECIMAL(7,2) NOT NULL,
    tdee_value DECIMAL(7,2) NOT NULL,
    calculation_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    weight_at_calculation DECIMAL(5,2) NOT NULL,
    height_at_calculation DECIMAL(5,2) NOT NULL,
    age_at_calculation INTEGER NOT NULL,
    gender_at_calculation public.gender_type NOT NULL,
    activity_level_at_calculation public.activity_level NOT NULL
);

-- 5. Orders table
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    meal_category public.meal_category NOT NULL,
    total_calories DECIMAL(7,2) NOT NULL,
    total_protein DECIMAL(6,2) DEFAULT 0,
    total_carbs DECIMAL(6,2) DEFAULT 0,
    total_fat DECIMAL(6,2) DEFAULT 0,
    total_fiber DECIMAL(6,2) DEFAULT 0,
    order_status public.order_status DEFAULT 'pending'::public.order_status,
    notes TEXT,
    order_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    delivery_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Order items junction table
CREATE TABLE public.order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    ingredient_id UUID REFERENCES public.ingredients(id) ON DELETE CASCADE,
    quantity_grams DECIMAL(6,2) NOT NULL,
    calories DECIMAL(6,2) NOT NULL,
    protein DECIMAL(5,2) DEFAULT 0,
    carbs DECIMAL(5,2) DEFAULT 0,
    fat DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. User preferences table
CREATE TABLE public.user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    preferred_categories TEXT[] DEFAULT '{}',
    allergies TEXT[] DEFAULT '{}',
    dietary_restrictions TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. Essential indexes for performance
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_ingredients_category ON public.ingredients(category);
CREATE INDEX idx_ingredients_active ON public.ingredients(is_active);
CREATE INDEX idx_bmr_user_id ON public.bmr_calculations(user_id);
CREATE INDEX idx_bmr_calculation_date ON public.bmr_calculations(calculation_date);
CREATE INDEX idx_orders_user_id ON public.orders(user_id);
CREATE INDEX idx_orders_status ON public.orders(order_status);
CREATE INDEX idx_orders_date ON public.orders(order_date);
CREATE INDEX idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX idx_order_items_ingredient_id ON public.order_items(ingredient_id);
CREATE INDEX idx_user_preferences_user_id ON public.user_preferences(user_id);

-- 9. Enable Row Level Security
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bmr_calculations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;

-- 10. Helper functions for RLS policies
CREATE OR REPLACE FUNCTION public.is_owner(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT auth.uid() = user_uuid
$$;

CREATE OR REPLACE FUNCTION public.can_access_order(order_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.orders o
    WHERE o.id = order_uuid AND o.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_order_item(item_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.order_items oi
    JOIN public.orders o ON oi.order_id = o.id
    WHERE oi.id = item_uuid AND o.user_id = auth.uid()
)
$$;

-- 11. Automatic profile creation trigger
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 12. RLS Policies
-- User profiles: users can only access their own profile
CREATE POLICY "users_own_profile" ON public.user_profiles
FOR ALL TO authenticated
USING (public.is_owner(id))
WITH CHECK (public.is_owner(id));

-- Ingredients: public read access, authenticated users can view all
CREATE POLICY "public_ingredients_read" ON public.ingredients
FOR SELECT TO public
USING (is_active = true);

CREATE POLICY "authenticated_ingredients_read" ON public.ingredients
FOR SELECT TO authenticated
USING (true);

-- BMR calculations: users can only access their own calculations
CREATE POLICY "users_own_bmr" ON public.bmr_calculations
FOR ALL TO authenticated
USING (public.is_owner(user_id))
WITH CHECK (public.is_owner(user_id));

-- Orders: users can only access their own orders
CREATE POLICY "users_own_orders" ON public.orders
FOR ALL TO authenticated
USING (public.is_owner(user_id))
WITH CHECK (public.is_owner(user_id));

-- Order items: users can only access items from their own orders
CREATE POLICY "users_own_order_items" ON public.order_items
FOR ALL TO authenticated
USING (public.can_access_order_item(id))
WITH CHECK (public.can_access_order_item(id));

-- User preferences: users can only access their own preferences
CREATE POLICY "users_own_preferences" ON public.user_preferences
FOR ALL TO authenticated
USING (public.is_owner(user_id))
WITH CHECK (public.is_owner(user_id));

-- 13. Sample data for testing
DO $$
DECLARE
    user1_id UUID := gen_random_uuid();
    user2_id UUID := gen_random_uuid();
    ingredient1_id UUID := gen_random_uuid();
    ingredient2_id UUID := gen_random_uuid();
    ingredient3_id UUID := gen_random_uuid();
    order1_id UUID := gen_random_uuid();
BEGIN
    -- Create auth users with complete field structure
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (user1_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@balancedmeal.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin User"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user2_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'user@balancedmeal.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Regular User"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Update user profiles with complete data
    UPDATE public.user_profiles SET
        age = 28,
        weight = 70.5,
        height = 175.0,
        gender = 'male'::public.gender_type,
        activity_level = 'moderate'::public.activity_level,
        daily_calorie_goal = 2200
    WHERE id = user1_id;

    UPDATE public.user_profiles SET
        age = 25,
        weight = 62.0,
        height = 165.0,
        gender = 'female'::public.gender_type,
        activity_level = 'light'::public.activity_level,
        daily_calorie_goal = 1800
    WHERE id = user2_id;

    -- Insert sample ingredients
    INSERT INTO public.ingredients (id, name, category, calories_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g, fiber_per_100g, description) VALUES
        (ingredient1_id, 'Chicken Breast', 'protein'::public.ingredient_category, 165.0, 31.0, 0.0, 3.6, 0.0, 'Lean chicken breast, skinless and boneless'),
        (ingredient2_id, 'Brown Rice', 'carbohydrates'::public.ingredient_category, 111.0, 2.6, 23.0, 0.9, 1.8, 'Whole grain brown rice, cooked'),
        (ingredient3_id, 'Broccoli', 'vegetables'::public.ingredient_category, 34.0, 2.8, 7.0, 0.4, 2.6, 'Fresh broccoli florets');

    -- Insert sample order
    INSERT INTO public.orders (id, user_id, meal_category, total_calories, total_protein, total_carbs, total_fat) VALUES
        (order1_id, user1_id, 'lunch'::public.meal_category, 450.0, 38.0, 35.0, 8.0);

    -- Insert sample order items
    INSERT INTO public.order_items (order_id, ingredient_id, quantity_grams, calories, protein, carbs, fat) VALUES
        (order1_id, ingredient1_id, 150.0, 247.5, 46.5, 0.0, 5.4),
        (order1_id, ingredient2_id, 100.0, 111.0, 2.6, 23.0, 0.9),
        (order1_id, ingredient3_id, 200.0, 68.0, 5.6, 14.0, 0.8);

    -- Insert BMR calculation
    INSERT INTO public.bmr_calculations (user_id, bmr_value, tdee_value, weight_at_calculation, height_at_calculation, age_at_calculation, gender_at_calculation, activity_level_at_calculation) VALUES
        (user1_id, 1750.0, 2275.0, 70.5, 175.0, 28, 'male'::public.gender_type, 'moderate'::public.activity_level);

    -- Insert user preferences
    INSERT INTO public.user_preferences (user_id, preferred_categories, allergies, dietary_restrictions) VALUES
        (user1_id, '{"protein", "vegetables"}', '{}', '{"low_sodium"}');

    RAISE NOTICE 'Balanced Meal database schema created successfully!';
    RAISE NOTICE 'Test login: admin@balancedmeal.com / password123';
    RAISE NOTICE 'Test login: user@balancedmeal.com / password123';

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;