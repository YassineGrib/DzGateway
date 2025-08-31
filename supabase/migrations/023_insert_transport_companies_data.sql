-- إدراج بيانات شركات النقل من ولاية سطيف والجزائر العاصمة

-- شركات النقل من ولاية سطيف
INSERT INTO transport_companies (
  name,
  phone,
  transport_type,
  description,
  cover_image,
  price_range,
  rating,
  total_reviews,
  is_active
) VALUES
-- شركة النقل الحضري سطيف
(
  'شركة النقل الحضري سطيف',
  '+213-36-92-15-30',
  'public',
  'شركة نقل حضري تخدم مدينة سطيف وضواحيها بأسطول حديث ومريح',
  'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800',
  '40-60 دج',
  4.2,
  156,
  true
),
-- تاكسي سطيف الذهبي
(
  'تاكسي سطيف الذهبي',
  '+213-36-91-23-45',
  'private',
  'خدمة تاكسي موثوقة وسريعة في مدينة سطيف على مدار الساعة',
  'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
  '200-500 دج',
  4.0,
  234,
  true
),

-- شركات النقل من الجزائر العاصمة
-- شركة النقل الحضري للجزائر العاصمة (ETUSA)
(
  'المؤسسة العمومية للنقل الحضري وشبه الحضري للجزائر',
  '+213-21-74-15-20',
  'public',
  'الشركة الرائدة في النقل الحضري بالجزائر العاصمة تخدم جميع أحياء العاصمة',
  'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?w=800',
  '30-50 دج',
  3.8,
  1250,
  true
),
-- تاكسي العاصمة الأزرق
(
  'تاكسي العاصمة الأزرق',
  '+213-21-92-34-56',
  'private',
  'أكبر شبكة تاكسي في الجزائر العاصمة مع خدمة الحجز عبر التطبيق',
  'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
  '300-800 دج',
  4.4,
  567,
  true
);

-- إدراج خطوط النقل
INSERT INTO transport_routes (
  company_id,
  route_name,
  origin,
  destination,
  distance_km,
  estimated_duration_minutes,
  price,
  is_active
) VALUES
-- خطوط شركة النقل الحضري سطيف
(
  (SELECT id FROM transport_companies WHERE name = 'شركة النقل الحضري سطيف'),
  'خط وسط المدينة - الجامعة',
  'وسط المدينة سطيف',
  'جامعة فرحات عباس',
  12.0,
  25,
  50.00,
  true
),
(
  (SELECT id FROM transport_companies WHERE name = 'شركة النقل الحضري سطيف'),
  'خط المحطة - المستشفى',
  'محطة النقل البري',
  'المستشفى الجامعي',
  8.0,
  20,
  40.00,
  true
),
-- خطوط ETUSA
(
  (SELECT id FROM transport_companies WHERE name = 'المؤسسة العمومية للنقل الحضري وشبه الحضري للجزائر'),
  'خط الجزائر الوسطى - باب الزوار',
  'الجزائر الوسطى',
  'باب الزوار',
  15.0,
  35,
  30.00,
  true
),
(
  (SELECT id FROM transport_companies WHERE name = 'المؤسسة العمومية للنقل الحضري وشبه الحضري للجزائر'),
  'خط بئر مراد رايس - الحراش',
  'بئر مراد رايس',
  'الحراش',
  20.0,
  45,
  35.00,
  true
);

-- إدراج جداول المواعيد
INSERT INTO transport_schedules (
  route_id,
  departure_time,
  arrival_time,
  days_of_week,
  is_active
) VALUES
-- مواعيد خط وسط المدينة - الجامعة (سطيف)
(
  (SELECT id FROM transport_routes WHERE route_name = 'خط وسط المدينة - الجامعة'),
  '07:00:00',
  '07:25:00',
  '{1,2,3,4,5,6}',
  true
),
(
  (SELECT id FROM transport_routes WHERE route_name = 'خط وسط المدينة - الجامعة'),
  '17:00:00',
  '17:25:00',
  '{1,2,3,4,5,6}',
  true
),
-- مواعيد خط الجزائر الوسطى - باب الزوار
(
  (SELECT id FROM transport_routes WHERE route_name = 'خط الجزائر الوسطى - باب الزوار'),
  '06:30:00',
  '07:05:00',
  '{1,2,3,4,5,6}',
  true
),
(
  (SELECT id FROM transport_routes WHERE route_name = 'خط الجزائر الوسطى - باب الزوار'),
  '18:00:00',
  '18:35:00',
  '{1,2,3,4,5,6}',
  true
);

-- إدراج صور الشركات
INSERT INTO transport_company_images (
  company_id,
  image_url,
  alt_text,
  display_order
) VALUES
-- صور شركة النقل الحضري سطيف
(
  (SELECT id FROM transport_companies WHERE name = 'شركة النقل الحضري سطيف'),
  'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800',
  'حافلة شركة النقل الحضري سطيف',
  1
),
-- صور تاكسي سطيف الذهبي
(
  (SELECT id FROM transport_companies WHERE name = 'تاكسي سطيف الذهبي'),
  'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
  'تاكسي ذهبي في سطيف',
  1
),
-- صور ETUSA
(
  (SELECT id FROM transport_companies WHERE name = 'المؤسسة العمومية للنقل الحضري وشبه الحضري للجزائر'),
  'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?w=800',
  'حافلة ETUSA في الجزائر العاصمة',
  1
),
-- صور تاكسي العاصمة الأزرق
(
  (SELECT id FROM transport_companies WHERE name = 'تاكسي العاصمة الأزرق'),
  'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
  'تاكسي أزرق في الجزائر العاصمة',
  1
);