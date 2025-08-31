-- Migration: Insert Sample Hotels Data
-- Created: 2024-01-20
-- Description: Insert sample hotel data including hotels, room types, amenities, images, and policies

DO $$
DECLARE
    hotel_ibis_id UUID;
    hotel_hilton_id UUID;
    hotel_sheraton_id UUID;
    hotel_center_id UUID;
BEGIN
    -- Insert Hotels
    
    -- Hotel Ibis Setif
    INSERT INTO hotels (
        name, description, address, city, wilaya, postal_code, phone, email, website,
        star_rating, price_range_min, price_range_max, rating, total_reviews,
        check_in_time, check_out_time, latitude, longitude, cover_image, is_active
    ) VALUES (
        'فندق إيبيس سطيف',
        'فندق عصري في قلب مدينة سطيف يوفر إقامة مريحة للمسافرين من رجال الأعمال والسياح',
        'شارع العربي بن مهيدي، سطيف 19000',
        'سطيف',
        'سطيف',
        '19000',
        '+213 36 92 50 00',
        'ibis.setif@accor.com',
        'https://www.accorhotels.com',
        3,
        8500.00,
        12000.00,
        4.2,
        156,
        '14:00',
        '12:00',
        36.1919,
        5.4138,
        'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        true
    ) RETURNING id INTO hotel_ibis_id;
    
    -- Hotel Hilton Algiers
    INSERT INTO hotels (
        name, description, address, city, wilaya, postal_code, phone, email, website,
        star_rating, price_range_min, price_range_max, rating, total_reviews,
        check_in_time, check_out_time, latitude, longitude, cover_image, is_active
    ) VALUES (
        'فندق الهيلتون الجزائر',
        'فندق عالمي فاخر يقع في موقع استراتيجي مطل على خليج الجزائر، يوفر أرقى الخدمات والمرافق',
        'شارع سويدان بوجمعة، الجزائر',
        'الجزائر',
        'الجزائر',
        '16000',
        '+213 21 21 96 96',
        'algiers@hilton.com',
        'https://www.hilton.com/algiers',
        5,
        22000.00,
        45000.00,
        4.6,
        456,
        '15:00',
        '12:00',
        36.7628,
        3.0426,
        'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
        true
    ) RETURNING id INTO hotel_hilton_id;
    
    -- Hotel Sheraton Algiers
    INSERT INTO hotels (
        name, description, address, city, wilaya, postal_code, phone, email, website,
        star_rating, price_range_min, price_range_max, rating, total_reviews,
        check_in_time, check_out_time, latitude, longitude, cover_image, is_active
    ) VALUES (
        'فندق الشيراتون الجزائر',
        'فندق دولي راقي يتميز بموقعه المتميز وخدماته الفاخرة، مثالي للإقامات التجارية والسياحية',
        'نادي الصنوبر، الجزائر',
        'الجزائر',
        'الجزائر',
        '16000',
        '+213 21 37 77 77',
        'reservations@sheraton-algiers.com',
        'https://www.marriott.com/sheraton-algiers',
        5,
        20000.00,
        40000.00,
        4.4,
        289,
        '15:00',
        '12:00',
        36.7456,
        3.0234,
        'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
        true
    ) RETURNING id INTO hotel_sheraton_id;
    
    -- Hotel Algiers Center
    INSERT INTO hotels (
        name, description, address, city, wilaya, postal_code, phone, email, website,
        star_rating, price_range_min, price_range_max, rating, total_reviews,
        check_in_time, check_out_time, latitude, longitude, is_active
    ) VALUES (
        'فندق الجزائر سنتر',
        'فندق متوسط الفئة في وسط العاصمة، يوفر إقامة مريحة بأسعار معقولة قريباً من المعالم السياحية',
        'شارع ديدوش مراد، وسط المدينة',
        'الجزائر',
        'الجزائر',
        '16000',
        '+213 21 64 25 25',
        'contact@algiers-center.dz',
        null,
        3,
        8000.00,
        15000.00,
        3.8,
        156,
        '14:00',
        '11:00',
        36.7694,
        3.0434,
        'https://images.unsplash.com/photo-1455587734955-081b22074882',
        true
    ) RETURNING id INTO hotel_center_id;
    
    -- Insert Room Types
    
    -- Ibis Setif Room Types
    INSERT INTO room_types (hotel_id, name, description, max_occupancy, bed_type, room_size_sqm, price_per_night, amenities, is_active) VALUES
    (hotel_ibis_id, 'غرفة قياسية', 'غرفة مريحة مع سرير مزدوج وحمام خاص', 2, 'سرير مزدوج', 20.0, 8500.00, '{"تكييف","تلفزيون","واي فاي مجاني","حمام خاص"}', true),
    (hotel_ibis_id, 'غرفة مزدوجة', 'غرفة واسعة مع سريرين منفصلين', 2, 'سريران منفصلان', 22.0, 9500.00, '{"تكييف","تلفزيون","واي فاي مجاني","حمام خاص","مكتب"}', true);
    
    -- Hilton Room Types
    INSERT INTO room_types (hotel_id, name, description, max_occupancy, bed_type, room_size_sqm, price_per_night, amenities, is_active) VALUES
    (hotel_hilton_id, 'غرفة هيلتون ديلوكس', 'غرفة فاخرة بمعايير هيلتون العالمية', 2, 'سرير كبير', 40.0, 28000.00, '{"تكييف","تلفزيون ذكي","واي فاي مجاني","حمام فاخر","ميني بار"}', true),
    (hotel_hilton_id, 'جناح هيلتون الملكي', 'جناح فاخر مع خدمات VIP', 4, 'سرير ملكي + غرفة معيشة', 90.0, 45000.00, '{"تكييف","تلفزيونان ذكيان","واي فاي مجاني","حمام فاخر","شرفة كبيرة","ميني بار","جاكوزي"}', true);
    
    -- Sheraton Room Types
    INSERT INTO room_types (hotel_id, name, description, max_occupancy, bed_type, room_size_sqm, price_per_night, amenities, is_active) VALUES
    (hotel_sheraton_id, 'غرفة شيراتون كلاسيك', 'غرفة أنيقة بتصميم شيراتون المميز', 2, 'سرير مزدوج', 32.0, 22000.00, '{"تكييف","تلفزيون","واي فاي مجاني","حمام خاص","مكتب"}', true),
    (hotel_sheraton_id, 'جناح شيراتون بريميوم', 'جناح فاخر مع مرافق متقدمة', 4, 'سرير ملكي + غرفة جلوس', 70.0, 40000.00, '{"تكييف","تلفزيونان","واي فاي مجاني","حمام فاخر","شرفة","ميني بار"}', true);
    
    -- Algiers Center Room Types
    INSERT INTO room_types (hotel_id, name, description, max_occupancy, bed_type, room_size_sqm, price_per_night, amenities, is_active) VALUES
    (hotel_center_id, 'غرفة قياسية', 'غرفة مريحة بأسعار معقولة', 2, 'سرير مزدوج', 22.0, 10000.00, '{"تلفزيون","حمام خاص"}', true),
    (hotel_center_id, 'غرفة عائلية', 'غرفة واسعة مناسبة للعائلات', 4, 'سريران مزدوجان', 35.0, 15000.00, '{"تلفزيون","حمام خاص","ثلاجة صغيرة"}', true);
    
    -- Insert Hotel Amenities
    
    -- Ibis Setif Amenities
    INSERT INTO hotel_amenities (hotel_id, amenity_name, amenity_type, is_free, additional_cost) VALUES
    (hotel_ibis_id, 'واي فاي مجاني', 'connectivity', true, 0.00),
    (hotel_ibis_id, 'مطعم', 'dining', true, 0.00),
    (hotel_ibis_id, 'موقف سيارات', 'parking', true, 0.00),
    (hotel_ibis_id, 'استقبال 24 ساعة', 'service', true, 0.00);
    
    -- Hilton Amenities
    INSERT INTO hotel_amenities (hotel_id, amenity_name, amenity_type, is_free, additional_cost) VALUES
    (hotel_hilton_id, 'واي فاي مجاني في جميع أنحاء الفندق', 'connectivity', true, 0.00),
    (hotel_hilton_id, 'مطاعم متعددة', 'dining', true, 0.00),
    (hotel_hilton_id, 'مسبح داخلي وخارجي', 'recreation', true, 0.00),
    (hotel_hilton_id, 'سبا هيلتون الفاخر', 'recreation', false, 4000.00),
    (hotel_hilton_id, 'مركز أعمال متطور', 'business', true, 0.00),
    (hotel_hilton_id, 'صالة تنفيذية', 'business', true, 0.00),
    (hotel_hilton_id, 'خدمة ليموزين', 'service', false, 8000.00);
    
    -- Sheraton Amenities
    INSERT INTO hotel_amenities (hotel_id, amenity_name, amenity_type, is_free, additional_cost) VALUES
    (hotel_sheraton_id, 'إنترنت عالي السرعة', 'connectivity', true, 0.00),
    (hotel_sheraton_id, 'مطاعم عالمية', 'dining', true, 0.00),
    (hotel_sheraton_id, 'نادي صحي متكامل', 'recreation', false, 2500.00),
    (hotel_sheraton_id, 'مسبح مع بار', 'recreation', true, 0.00),
    (hotel_sheraton_id, 'قاعات مؤتمرات', 'business', false, 6000.00);
    
    -- Algiers Center Amenities
    INSERT INTO hotel_amenities (hotel_id, amenity_name, amenity_type, is_free, additional_cost) VALUES
    (hotel_center_id, 'واي فاي مجاني', 'connectivity', true, 0.00),
    (hotel_center_id, 'مطعم محلي', 'dining', true, 0.00),
    (hotel_center_id, 'موقف سيارات', 'parking', false, 500.00);
    
    -- Insert Hotel Images
    
    -- Ibis Setif Images
    INSERT INTO hotel_images (hotel_id, image_url, image_type, alt_text, display_order) VALUES
    (hotel_ibis_id, 'https://images.unsplash.com/photo-1566073771259-6a8506099945', 'exterior', 'واجهة فندق إيبيس سطيف', 1),
    (hotel_ibis_id, 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304', 'room', 'غرفة قياسية في فندق إيبيس', 2),
    (hotel_ibis_id, 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461', 'amenity', 'لوبي فندق إيبيس سطيف', 3);
    
    -- Hilton Images
    INSERT INTO hotel_images (hotel_id, image_url, image_type, alt_text, display_order) VALUES
    (hotel_hilton_id, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', 'exterior', 'فندق الهيلتون الجزائر', 1),
    (hotel_hilton_id, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39', 'room', 'جناح هيلتون الملكي', 2),
    (hotel_hilton_id, 'https://images.unsplash.com/photo-1590490360182-c33d57733427', 'amenity', 'سبا هيلتون الفاخر', 3);
    
    -- Sheraton Images
    INSERT INTO hotel_images (hotel_id, image_url, image_type, alt_text, display_order) VALUES
    (hotel_sheraton_id, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791', 'exterior', 'فندق الشيراتون الأنيق', 1),
    (hotel_sheraton_id, 'https://images.unsplash.com/photo-1586611292717-f828b167408c', 'room', 'جناح شيراتون بريميوم', 2);
    
    -- Algiers Center Images
    INSERT INTO hotel_images (hotel_id, image_url, image_type, alt_text, display_order) VALUES
    (hotel_center_id, 'https://images.unsplash.com/photo-1455587734955-081b22074882', 'exterior', 'فندق الجزائر سنتر', 1),
    (hotel_center_id, 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000', 'room', 'غرفة عائلية مريحة', 2);
    
    -- Insert Hotel Policies
    
    -- Ibis Setif Policies
    INSERT INTO hotel_policies (hotel_id, policy_type, policy_title, policy_description) VALUES
    (hotel_ibis_id, 'cancellation', 'سياسة الإلغاء', 'يمكن إلغاء الحجز مجاناً حتى 24 ساعة قبل تاريخ الوصول. بعد ذلك سيتم تطبيق رسوم إلغاء بقيمة ليلة واحدة.'),
    (hotel_ibis_id, 'pets', 'سياسة الحيوانات الأليفة', 'غير مسموح بالحيوانات الأليفة في الفندق.'),
    (hotel_ibis_id, 'smoking', 'سياسة التدخين', 'الفندق خالٍ من التدخين. التدخين مسموح فقط في المناطق المخصصة خارج المبنى.');
    
    -- Hilton Policies
    INSERT INTO hotel_policies (hotel_id, policy_type, policy_title, policy_description) VALUES
    (hotel_hilton_id, 'cancellation', 'سياسة الإلغاء', 'إلغاء مجاني حتى 24 ساعة قبل الوصول للغرف العادية، و72 ساعة للأجنحة.'),
    (hotel_hilton_id, 'pets', 'سياسة الحيوانات الأليفة', 'مسموح بالحيوانات الأليفة الصغيرة مع رسوم إضافية 2000 دج/ليلة.'),
    (hotel_hilton_id, 'vip', 'خدمات VIP', 'خدمات VIP متاحة للأجنحة تشمل خدمة الكونسيرج الشخصي وخدمة الغرف على مدار الساعة.');
    
    -- Sheraton Policies
    INSERT INTO hotel_policies (hotel_id, policy_type, policy_title, policy_description) VALUES
    (hotel_sheraton_id, 'cancellation', 'سياسة الإلغاء', 'إلغاء مجاني حتى 48 ساعة قبل الوصول.'),
    (hotel_sheraton_id, 'business', 'خدمات الأعمال', 'مركز أعمال متاح 24/7 مع خدمات الطباعة والفاكس مجاناً.'),
    (hotel_sheraton_id, 'smoking', 'سياسة التدخين', 'فندق خالٍ من التدخين مع مناطق مخصصة للتدخين.');
    
    -- Algiers Center Policies
    INSERT INTO hotel_policies (hotel_id, policy_type, policy_title, policy_description) VALUES
    (hotel_center_id, 'cancellation', 'سياسة الإلغاء', 'إلغاء مجاني حتى 24 ساعة قبل الوصول.'),
    (hotel_center_id, 'children', 'سياسة الأطفال', 'الأطفال تحت سن 12 سنة يقيمون مجاناً مع الوالدين.');

END $$;