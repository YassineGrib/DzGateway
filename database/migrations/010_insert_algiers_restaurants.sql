-- Insert sample restaurants data for Algiers (الجزائر العاصمة)

-- Insert restaurants in Algiers
INSERT INTO restaurants (id, name, address, latitude, longitude, phone, description, cover_image, rating, total_reviews, is_active, created_at, updated_at) VALUES
(
    gen_random_uuid(),
    'مطعم القصبة',
    'القصبة العتيقة، الجزائر العاصمة، الجزائر',
    36.7833,
    3.0500,
    '+213 21 73 45 67',
    'مطعم تراثي في قلب القصبة العتيقة يقدم أشهى الأطباق الجزائرية التقليدية',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    4.8,
    312,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الأوراسي',
    'شارع ديدوش مراد، الجزائر العاصمة، الجزائر',
    36.7528,
    3.0420,
    '+213 21 64 89 23',
    'مطعم راقي يجمع بين الأصالة والحداثة في قلب العاصمة',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    4.6,
    245,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم البحر الأبيض',
    'كورنيش الجزائر، الجزائر العاصمة، الجزائر',
    36.7372,
    3.0865,
    '+213 21 91 56 78',
    'مطعم مأكولات بحرية بإطلالة رائعة على البحر الأبيض المتوسط',
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
    4.7,
    189,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الحمراء',
    'حيدرة، الجزائر العاصمة، الجزائر',
    36.7167,
    3.0167,
    '+213 21 82 34 91',
    'مطعم عائلي يقدم أطباق مغاربية أصيلة في جو دافئ ومريح',
    'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
    4.4,
    167,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الأندلسي',
    'باب الوادي، الجزائر العاصمة، الجزائر',
    36.7694,
    3.0711,
    '+213 21 75 67 45',
    'مطعم بديكور أندلسي أنيق يقدم تشكيلة واسعة من الأطباق العربية',
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
    4.5,
    198,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الجزائر الحديثة',
    'الأبيار، الجزائر العاصمة، الجزائر',
    36.7000,
    3.1833,
    '+213 21 93 78 12',
    'مطعم عصري يقدم المأكولات العالمية والمحلية بأسلوب حديث',
    'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800',
    4.3,
    134,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الشهداء',
    'ساحة الشهداء، الجزائر العاصمة، الجزائر',
    36.7750,
    3.0583,
    '+213 21 86 45 23',
    'مطعم في موقع تاريخي مميز يقدم أفضل الأطباق الجزائرية',
    'https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?w=800',
    4.6,
    221,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الرياض',
    'الرياض، الجزائر العاصمة، الجزائر',
    36.7361,
    3.0833,
    '+213 21 79 12 56',
    'مطعم فاخر بحديقة جميلة يقدم تجربة طعام لا تُنسى',
    'https://images.unsplash.com/photo-1578474846511-04ba529f0b88?w=800',
    4.2,
    156,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم المقام',
    'مقام الشهيد، الجزائر العاصمة، الجزائر',
    36.7472,
    3.0889,
    '+213 21 84 67 89',
    'مطعم بإطلالة بانورامية على العاصمة من أعلى نقطة',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    4.9,
    278,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الصومعة',
    'بئر مراد رايس، الجزائر العاصمة، الجزائر',
    36.7583,
    3.0250,
    '+213 21 88 34 67',
    'مطعم هادئ بديكور عربي كلاسيكي يقدم أطباق شهية',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    4.1,
    89,
    true,
    NOW(),
    NOW()
);

-- Insert sample menu items for some restaurants in Algiers
-- Get restaurant IDs first (we'll use the first few restaurants)
WITH restaurant_ids AS (
    SELECT id, name FROM restaurants WHERE address LIKE '%الجزائر العاصمة%' LIMIT 4
)

-- Menu items for مطعم القصبة
INSERT INTO menu_items (id, restaurant_id, name, description, price, category, image, is_available, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    r.id,
    'كسكس الجمعة',
    'كسكس تقليدي بسبعة خضار واللحم الطري',
    950.00,
    'أطباق رئيسية',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم القصبة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'الشخشوخة',
    'طبق تقليدي جزائري بالخضار والرقاق',
    680.00,
    'أطباق رئيسية',
    'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم القصبة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'البوراك',
    'معجنات محشوة باللحم والخضار',
    420.00,
    'مقبلات',
    'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم القصبة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'قلب اللوز',
    'حلوى جزائرية تقليدية باللوز والعسل',
    250.00,
    'حلويات',
    'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم القصبة'

-- Menu items for مطعم الأوراسي
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'لحم الخروف المشوي',
    'لحم خروف طري مشوي على الفحم مع الأرز',
    1350.00,
    'مشاوي',
    'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأوراسي'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'دجاج محمر',
    'دجاج كامل محمر بالتوابل الجزائرية',
    890.00,
    'أطباق رئيسية',
    'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأوراسي'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'سلطة الفلفل المشوي',
    'سلطة الفلفل الأحمر المشوي بزيت الزيتون',
    380.00,
    'سلطات',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأوراسي'

-- Menu items for مطعم البحر الأبيض
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'سمك الدنيس المشوي',
    'سمك دنيس طازج مشوي مع الخضار',
    1150.00,
    'مأكولات بحرية',
    'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم البحر الأبيض'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'طاجين الروبيان',
    'طاجين روبيان بالخضار والتوابل البحرية',
    980.00,
    'مأكولات بحرية',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم البحر الأبيض'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'شوربة السمك',
    'شوربة سمك غنية بالخضار البحرية',
    450.00,
    'مقبلات',
    'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم البحر الأبيض'

-- Menu items for مطعم الحمراء
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'الرشتة',
    'معكرونة تقليدية جزائرية بالدجاج والخضار',
    720.00,
    'أطباق رئيسية',
    'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الحمراء'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'المحاجب',
    'فطائر محشوة بالطماطم والبصل',
    320.00,
    'مقبلات',
    'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الحمراء'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'الزلابية',
    'حلوى مقلية بالعسل والسمسم',
    280.00,
    'حلويات',
    'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الحمراء';

-- Insert sample restaurant images for Algiers restaurants
WITH restaurant_ids AS (
    SELECT id, name FROM restaurants WHERE address LIKE '%الجزائر العاصمة%' LIMIT 4
)
INSERT INTO restaurant_images (id, restaurant_id, image_url, alt_text, display_order, created_at)
SELECT 
    gen_random_uuid(),
    r.id,
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    'منظر داخلي للمطعم',
    1,
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم القصبة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
    'قاعة الطعام الرئيسية',
    1,
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأوراسي'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    'إطلالة على البحر',
    1,
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم البحر الأبيض'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
    'الديكور التقليدي',
    1,
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الحمراء';