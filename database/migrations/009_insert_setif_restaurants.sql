-- Insert sample restaurants data for Setif (سطيف)

-- Insert restaurants in Setif
INSERT INTO restaurants (id, name, address, latitude, longitude, phone, description, cover_image, rating, total_reviews, is_active, created_at, updated_at) VALUES
(
    gen_random_uuid(),
    'مطعم الأصالة',
    'شارع العربي بن مهيدي، سطيف، الجزائر',
    36.1900,
    5.4133,
    '+213 36 92 15 47',
    'مطعم تقليدي يقدم أشهى الأطباق الجزائرية الأصيلة في أجواء عائلية مميزة',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    4.5,
    127,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الزيتونة',
    'حي 8 مايو 1945، سطيف، الجزائر',
    36.1856,
    5.4089,
    '+213 36 84 22 33',
    'مطعم عصري يجمع بين النكهات المحلية والعالمية مع خدمة راقية',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    4.3,
    89,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم النخيل',
    'شارع الاستقلال، وسط المدينة، سطيف، الجزائر',
    36.1911,
    5.4144,
    '+213 36 91 78 56',
    'مطعم فاخر متخصص في المأكولات الشرقية والمتوسطية',
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
    4.7,
    203,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الجبل الأخضر',
    'طريق عين ولمان، سطيف، الجزائر',
    36.2045,
    5.3987,
    '+213 36 87 45 12',
    'مطعم بإطلالة رائعة على الجبال يقدم أطباق مشوية لذيذة',
    'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
    4.2,
    156,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الواحة',
    'حي الهضاب، سطيف، الجزائر',
    36.1789,
    5.4201,
    '+213 36 93 67 89',
    'مطعم عائلي يقدم أطباق تقليدية بوصفات أصيلة منذ عقود',
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
    4.4,
    174,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الفردوس',
    'شارع محمد خيضر، سطيف، الجزائر',
    36.1923,
    5.4167,
    '+213 36 88 34 21',
    'مطعم حديث يقدم تشكيلة واسعة من الأطباق العربية والعالمية',
    'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=800',
    4.1,
    98,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم الأندلس',
    'حي الزهور، سطيف، الجزائر',
    36.1834,
    5.4078,
    '+213 36 95 12 67',
    'مطعم أنيق بديكور أندلسي يقدم أفضل الأطباق المغاربية',
    'https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?w=800',
    4.6,
    145,
    true,
    NOW(),
    NOW()
),
(
    gen_random_uuid(),
    'مطعم البستان',
    'طريق الجزائر، سطيف، الجزائر',
    36.1967,
    5.4289,
    '+213 36 82 56 43',
    'مطعم في الهواء الطلق محاط بالحدائق الخضراء',
    'https://images.unsplash.com/photo-1578474846511-04ba529f0b88?w=800',
    4.0,
    67,
    true,
    NOW(),
    NOW()
);

-- Insert sample menu items for some restaurants
-- Get restaurant IDs first (we'll use the first few restaurants)
WITH restaurant_ids AS (
    SELECT id, name FROM restaurants WHERE address LIKE '%سطيف%' LIMIT 3
)

-- Menu items for مطعم الأصالة
INSERT INTO menu_items (id, restaurant_id, name, description, price, category, image, is_available, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    r.id,
    'كسكس بالخضار',
    'كسكس تقليدي بالخضار الطازجة واللحم',
    850.00,
    'أطباق رئيسية',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأصالة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'طاجين الدجاج',
    'طاجين دجاج بالزيتون والليمون المحفوظ',
    750.00,
    'أطباق رئيسية',
    'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأصالة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'شوربة الحريرة',
    'شوربة تقليدية غنية بالطماطم والعدس',
    320.00,
    'مقبلات',
    'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأصالة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'بقلاوة',
    'حلوى شرقية بالعسل والمكسرات',
    180.00,
    'حلويات',
    'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأصالة'

-- Menu items for مطعم الزيتونة
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'برغر الزيتونة الخاص',
    'برغر لحم بقري مع الجبن والخضار الطازجة',
    650.00,
    'وجبات سريعة',
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الزيتونة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'سلطة قيصر',
    'سلطة خضراء مع الدجاج المشوي وصلصة قيصر',
    480.00,
    'سلطات',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الزيتونة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'بيتزا مارغريتا',
    'بيتزا كلاسيكية بالطماطم والجبن والريحان',
    720.00,
    'بيتزا',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الزيتونة'

-- Menu items for مطعم النخيل
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'مشاوي مشكلة',
    'تشكيلة من اللحوم المشوية مع الأرز والسلطة',
    1200.00,
    'مشاوي',
    'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم النخيل'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'سمك مشوي',
    'سمك طازج مشوي مع الخضار والأرز',
    950.00,
    'مأكولات بحرية',
    'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم النخيل'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'حمص بالطحينة',
    'حمص كريمي مع الطحينة وزيت الزيتون',
    280.00,
    'مقبلات',
    'https://images.unsplash.com/photo-1571197119282-7c4d9e3e8b8e?w=400',
    true,
    NOW(),
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم النخيل';

-- Insert sample restaurant images
WITH restaurant_ids AS (
    SELECT id, name FROM restaurants WHERE address LIKE '%سطيف%' LIMIT 3
)
INSERT INTO restaurant_images (id, restaurant_id, image_url, alt_text, display_order, created_at)
SELECT 
    gen_random_uuid(),
    r.id,
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    'صورة داخلية للمطعم',
    1,
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الأصالة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    'منطقة الجلوس الخارجية',
    1,
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم الزيتونة'
UNION ALL
SELECT 
    gen_random_uuid(),
    r.id,
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
    'قاعة الطعام الرئيسية',
    1,
    NOW()
FROM restaurant_ids r WHERE r.name = 'مطعم النخيل';