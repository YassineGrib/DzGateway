-- إدراج بيانات المناطق السياحية للجزائر العاصمة وسطيف

-- المناطق السياحية في الجزائر العاصمة
INSERT INTO tourist_areas (
  id, name, description, city, wilaya, area_type, latitude, longitude, 
  rating, total_reviews, is_active, created_at, updated_at
) VALUES 
(
  gen_random_uuid(),
  'القصبة',
  'القصبة هي المدينة القديمة للجزائر العاصمة، وهي موقع تراث عالمي لليونسكو. تتميز بشوارعها الضيقة المتعرجة، والمنازل التقليدية ذات الطراز العثماني والأندلسي، والمساجد التاريخية. تعتبر القصبة رمزاً للتاريخ الجزائري وتضم العديد من المعالم الأثرية والثقافية.',
  'الجزائر',
  'الجزائر',
  'تاريخي وثقافي',
  36.7833,
  3.0667,
  4.5,
  1250,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'مقام الشهيد',
  'مقام الشهيد هو نصب تذكاري مهيب يقع في العاصمة الجزائرية، ويُعرف أيضاً باسم "مقام المجاهد". يرتفع النصب 92 متراً ويتكون من ثلاثة أقواس خرسانية تلتقي في القمة. يضم متحفاً للمجاهدين ويوفر إطلالة بانورامية رائعة على المدينة والبحر الأبيض المتوسط.',
  'الجزائر',
  'الجزائر',
  'نصب تذكاري',
  36.7528,
  3.0417,
  4.3,
  890,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'الحديقة النباتية الحامة',
  'حديقة الحامة هي واحدة من أجمل الحدائق في شمال أفريقيا، تأسست عام 1832. تمتد على مساحة 32 هكتاراً وتضم أكثر من 1200 نوع من النباتات من جميع أنحاء العالم. تتميز بتصميمها الفرنسي الكلاسيكي ومناظرها الطبيعية الخلابة وإطلالتها على خليج الجزائر.',
  'الجزائر',
  'الجزائر',
  'حديقة طبيعية',
  36.7631,
  3.0431,
  4.2,
  675,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'المتحف الوطني للفنون الجميلة',
  'يعتبر من أهم المتاحف في الجزائر ويضم مجموعة رائعة من الأعمال الفنية الجزائرية والعربية والأوروبية. يقع في مبنى تاريخي جميل ويعرض لوحات ومنحوتات وقطع أثرية تحكي تاريخ الفن في الجزائر والمنطقة.',
  'الجزائر',
  'الجزائر',
  'متحف',
  36.7539,
  3.0583,
  4.1,
  420,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'جامع كتشاوة',
  'جامع كتشاوة هو من أهم المساجد التاريخية في الجزائر العاصمة، بُني في القرن السابع عشر خلال العهد العثماني. يتميز بعمارته الإسلامية الرائعة ومئذنته المميزة. يقع في قلب القصبة ويعتبر رمزاً دينياً وثقافياً مهماً.',
  'الجزائر',
  'الجزائر',
  'ديني وتاريخي',
  36.7847,
  3.0611,
  4.4,
  580,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'كورنيش الجزائر',
  'كورنيش الجزائر هو ممشى ساحلي جميل يمتد على طول الساحل الشمالي للعاصمة. يوفر إطلالات خلابة على البحر الأبيض المتوسط ويضم العديد من المقاهي والمطاعم والمرافق الترفيهية. يعتبر مكاناً مثالياً للتنزه والاستمتاع بغروب الشمس.',
  'الجزائر',
  'الجزائر',
  'ساحلي وترفيهي',
  36.7667,
  3.0333,
  4.0,
  950,
  true,
  NOW(),
  NOW()
);

-- المناطق السياحية في سطيف
INSERT INTO tourist_areas (
  id, name, description, city, wilaya, area_type, latitude, longitude, 
  rating, total_reviews, is_active, created_at, updated_at
) VALUES 
(
  gen_random_uuid(),
  'جميلة (كويكول)',
  'جميلة هي مدينة أثرية رومانية تقع بالقرب من سطيف، وهي موقع تراث عالمي لليونسكو. تضم آثاراً رومانية محفوظة بشكل استثنائي تشمل المسرح الروماني، والمعابد، والحمامات، والفيلات المزينة بالفسيفساء. تعتبر من أهم المواقع الأثرية في شمال أفريقيا.',
  'سطيف',
  'سطيف',
  'أثري وتاريخي',
  36.3219,
  5.7347,
  4.6,
  780,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'عين الفوارة',
  'عين الفوارة هي نافورة شهيرة تقع في وسط مدينة سطيف، وهي رمز المدينة ومعلم سياحي مهم. تتميز بتصميمها الجميل وإضاءتها الليلية الرائعة. تحيط بها حديقة جميلة ومقاهي شعبية، وتعتبر نقطة التقاء للسكان المحليين والزوار.',
  'سطيف',
  'سطيف',
  'معلم حضري',
  36.1900,
  5.4100,
  4.2,
  650,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'متحف سطيف الأثري',
  'يضم المتحف مجموعة غنية من القطع الأثرية المكتشفة في المنطقة، خاصة من موقع جميلة الأثري. يعرض فسيفساء رومانية نادرة، وتماثيل، وقطع نقدية، وأدوات من مختلف العصور التاريخية. يوفر نظرة شاملة على تاريخ المنطقة الغني.',
  'سطيف',
  'سطيف',
  'متحف',
  36.1917,
  5.4083,
  4.3,
  320,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'حديقة التسلية والترفيه',
  'حديقة كبيرة تضم ألعاباً ترفيهية متنوعة للأطفال والكبار، ومساحات خضراء واسعة للتنزه. تحتوي على بحيرة صناعية صغيرة وممرات للمشي وأماكن للجلوس. تعتبر وجهة مثالية للعائلات والأطفال.',
  'سطيف',
  'سطيف',
  'ترفيهي وعائلي',
  36.1850,
  5.4200,
  3.9,
  480,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'مسجد أبو بكر الصديق',
  'من أكبر وأجمل المساجد في سطيف، يتميز بعمارته الإسلامية الحديثة ومئذنته الشاهقة. يتسع لآلاف المصلين ويضم مركزاً إسلامياً ومكتبة. يعتبر معلماً دينياً وثقافياً مهماً في المدينة.',
  'سطيف',
  'سطيف',
  'ديني',
  36.1933,
  5.4067,
  4.1,
  290,
  true,
  NOW(),
  NOW()
),
(
  gen_random_uuid(),
  'جبل مقرس',
  'جبل مقرس يقع بالقرب من سطيف ويوفر إطلالات بانورامية رائعة على المدينة والمناطق المحيطة. يعتبر مكاناً مثالياً للمشي لمسافات طويلة والتخييم والاستمتاع بالطبيعة. يضم مسارات للمشي ومناطق للنزهات.',
  'سطيف',
  'سطيف',
  'طبيعي وجبلي',
  36.2100,
  5.3800,
  4.0,
  380,
  true,
  NOW(),
  NOW()
);

-- إدراج ميزات المناطق السياحية

-- ميزات القصبة
INSERT INTO tourist_area_features (id, area_id, feature_name, description, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  feature_name,
  feature_desc,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('مواقع تراث عالمي', 'مدرجة في قائمة اليونسكو للتراث العالمي'),
    ('عمارة تقليدية', 'منازل بالطراز العثماني والأندلسي'),
    ('أسواق تقليدية', 'أسواق شعبية تبيع الحرف اليدوية'),
    ('مساجد تاريخية', 'مساجد أثرية من العهد العثماني'),
    ('متاحف', 'متاحف تحكي تاريخ المدينة')
) AS features(feature_name, feature_desc)
WHERE ta.name = 'القصبة';

-- ميزات مقام الشهيد
INSERT INTO tourist_area_features (id, area_id, feature_name, description, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  feature_name,
  feature_desc,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('إطلالة بانورامية', 'منظر رائع على المدينة والبحر'),
    ('متحف المجاهدين', 'متحف يحكي تاريخ الثورة الجزائرية'),
    ('عمارة حديثة', 'تصميم معماري مميز وحديث'),
    ('مصعد سياحي', 'مصعد للوصول إلى القمة'),
    ('إضاءة ليلية', 'إضاءة جميلة في المساء')
) AS features(feature_name, feature_desc)
WHERE ta.name = 'مقام الشهيد';

-- ميزات حديقة التجارب
INSERT INTO tourist_area_features (id, area_id, feature_name, description, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  feature_name,
  feature_desc,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('تنوع نباتي', 'أكثر من 1200 نوع من النباتات'),
    ('تصميم فرنسي', 'حديقة بالطراز الفرنسي الكلاسيكي'),
    ('إطلالة على البحر', 'منظر جميل على خليج الجزائر'),
    ('مسارات للمشي', 'ممرات مظللة للتنزه'),
    ('مقاعد للراحة', 'أماكن للجلوس والاستراحة')
) AS features(feature_name, feature_desc)
WHERE ta.name = 'الحديقة النباتية الحامة';

-- ميزات جميلة
INSERT INTO tourist_area_features (id, area_id, feature_name, description, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  feature_name,
  feature_desc,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('آثار رومانية', 'مدينة رومانية محفوظة بشكل استثنائي'),
    ('مسرح روماني', 'مسرح أثري يتسع لـ 3000 متفرج'),
    ('فسيفساء نادرة', 'أرضيات مزينة بالفسيفساء الرومانية'),
    ('معابد أثرية', 'معابد رومانية قديمة'),
    ('متحف الموقع', 'متحف يعرض المكتشفات الأثرية')
) AS features(feature_name, feature_desc)
WHERE ta.name = 'جميلة (كويكول)';

-- ميزات عين الفوارة
INSERT INTO tourist_area_features (id, area_id, feature_name, description, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  feature_name,
  feature_desc,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('نافورة مميزة', 'نافورة جميلة في وسط المدينة'),
    ('إضاءة ليلية', 'إضاءة ملونة رائعة في المساء'),
    ('حديقة محيطة', 'مساحة خضراء حول النافورة'),
    ('مقاهي قريبة', 'مقاهي شعبية في المنطقة'),
    ('موقع مركزي', 'في قلب المدينة وسهل الوصول')
) AS features(feature_name, feature_desc)
WHERE ta.name = 'عين الفوارة';

-- إدراج صور المناطق السياحية

-- صور القصبة
INSERT INTO tourist_area_images (id, area_id, image_url, alt_text, display_order, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  image_data.url,
  image_data.alt,
  image_data.order_num,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 'منظر عام للقصبة', 1),
    ('https://images.unsplash.com/photo-1571049813738-0d0de9c6b4c6?w=800', 'شوارع القصبة الضيقة', 2),
    ('https://images.unsplash.com/photo-1590736969955-71cc94901144?w=800', 'العمارة التقليدية', 3)
) AS image_data(url, alt, order_num)
WHERE ta.name = 'القصبة';

-- صور مقام الشهيد
INSERT INTO tourist_area_images (id, area_id, image_url, alt_text, display_order, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  image_data.url,
  image_data.alt,
  image_data.order_num,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 'مقام الشهيد من الخارج', 1),
    ('https://images.unsplash.com/photo-1571049813738-0d0de9c6b4c6?w=800', 'إطلالة من المقام', 2)
) AS image_data(url, alt, order_num)
WHERE ta.name = 'مقام الشهيد';

-- صور الحديقة النباتية
INSERT INTO tourist_area_images (id, area_id, image_url, alt_text, display_order, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  image_data.url,
  image_data.alt,
  image_data.order_num,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800', 'منظر عام للحديقة', 1),
    ('https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800', 'النباتات المتنوعة', 2),
    ('https://images.unsplash.com/photo-1574263867128-a3d5c1b1deac?w=800', 'مسارات المشي', 3)
) AS image_data(url, alt, order_num)
WHERE ta.name = 'الحديقة النباتية الحامة';

-- صور جميلة
INSERT INTO tourist_area_images (id, area_id, image_url, alt_text, display_order, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  image_data.url,
  image_data.alt,
  image_data.order_num,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?w=800', 'المسرح الروماني', 1),
    ('https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 'الآثار الرومانية', 2),
    ('https://images.unsplash.com/photo-1571049813738-0d0de9c6b4c6?w=800', 'الفسيفساء الرومانية', 3)
) AS image_data(url, alt, order_num)
WHERE ta.name = 'جميلة (كويكول)';

-- صور عين الفوارة
INSERT INTO tourist_area_images (id, area_id, image_url, alt_text, display_order, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  image_data.url,
  image_data.alt,
  image_data.order_num,
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 'عين الفوارة نهاراً', 1),
    ('https://images.unsplash.com/photo-1571049813738-0d0de9c6b4c6?w=800', 'النافورة مع الإضاءة الليلية', 2)
) AS image_data(url, alt, order_num)
WHERE ta.name = 'عين الفوارة';

-- إدراج نصائح للزيارة

-- نصائح القصبة
INSERT INTO tourist_area_tips (id, area_id, tip_content, tip_type, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  tip_content,
  'عام',
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('يُنصح بزيارة القصبة في الصباح الباكر أو بعد العصر لتجنب الحر'),
    ('ارتدِ أحذية مريحة للمشي على الأرصفة الحجرية'),
    ('احترم التقاليد المحلية عند زيارة المساجد'),
    ('لا تنس التفاوض على الأسعار في الأسواق التقليدية'),
    ('احمل كاميرا لتصوير العمارة التقليدية الجميلة')
) AS tips(tip_content)
WHERE ta.name = 'القصبة';

-- نصائح مقام الشهيد
INSERT INTO tourist_area_tips (id, area_id, tip_content, tip_type, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  tip_content,
  'عام',
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('أفضل وقت للزيارة هو قبل الغروب للاستمتاع بالمنظر'),
    ('يمكن الوصول بالمصعد أو بالسلالم حسب الرغبة'),
    ('لا تنس زيارة متحف المجاهدين داخل المقام'),
    ('احمل معك ماء خاصة في الصيف')
) AS tips(tip_content)
WHERE ta.name = 'مقام الشهيد';

-- نصائح جميلة
INSERT INTO tourist_area_tips (id, area_id, tip_content, tip_type, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  tip_content,
  'عام',
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('احجز جولة مع مرشد سياحي لفهم تاريخ الموقع بشكل أفضل'),
    ('ارتدِ قبعة وواقي شمس لأن الموقع مكشوف'),
    ('أفضل وقت للزيارة هو الربيع والخريف'),
    ('لا تنس زيارة متحف الموقع لرؤية القطع الأثرية'),
    ('احمل كاميرا جيدة لتصوير الفسيفساء والآثار')
) AS tips(tip_content)
WHERE ta.name = 'جميلة (كويكول)';

-- نصائح عين الفوارة
INSERT INTO tourist_area_tips (id, area_id, tip_content, tip_type, created_at)
SELECT 
  gen_random_uuid(),
  ta.id,
  tip_content,
  'عام',
  NOW()
FROM tourist_areas ta,
(
  VALUES 
    ('زر المكان في المساء للاستمتاع بالإضاءة الجميلة'),
    ('جرب القهوة في أحد المقاهي المحيطة'),
    ('المكان مناسب للتصوير في جميع أوقات اليوم'),
    ('يمكن الوصول بسهولة سيراً على الأقدام من وسط المدينة')
) AS tips(tip_content)
WHERE ta.name = 'عين الفوارة';