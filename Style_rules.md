استخدم Flutter لبناء التطبيق (Android \أولاً،).

اعتمد هيكل مشروع نظيف (Clean Architecture / MVVM أو Bloc).

افصل البيانات (JSON/DB) عن الكود (Separation of Concerns).

أنشئ ملف constants.dart أو app_config.dart لتجميع:

الألوان (Color Palette).
الخطوط (Typography).
الحجوم (Spacing).
النصوص العامة (App Strings).
روابط API.

استخدام خطين أساسيين:
•	Amiri (للنصوص العربية الكلاسيكية).
•	Tajawal (لواجهات بسيطة وعصرية).
•	•  Muted Colors Palette (ألوان هادئة: رمادي/أزرق باهت/أخضر فاتح).
•	•  لا تستخدم ألوان صارخة أو مشبعة جدًا.or gradient colors
•  
•	استخدام Icons واضحة (يفضل من [Lucide Icons] أو [Material Icons]).
•	•  •  دعم RTL (من اليمين لليسار).
•	•  إضافة Animations بسيطة (Transitions بين الصفحات، FadeIn للصور).
•	نفس Style Guide (خطوط + ألوان + UI نظيف) في كل الصفحات 

titlebar موحد 
اسلبو موحد 
integration with supabase 
