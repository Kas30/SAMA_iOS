# تطبيق سماء (Samaa) لنظام iOS (Swift & SwiftUI)

تطبيق «سماء» مبني بأحدث تقنيات أبل الرسمية **Swift 5.9+** و **SwiftUI** بتصميم نجدي ملكي فاخر، ويدعم نظام iOS 16.0 فما فوق لأجهزة iPhone و iPad.

---

## بنية المشروع والهيكلية المعمارية (Architecture)

```text
ios_swift_project/
├── SamaaApp.swift                   # نقطة انطلاق التطبيق ونظام التنقل
├── Theme/
│   ├── Color+SamaaTheme.swift      # الألوان النجدية الملكية (البردي، القرمزي، الذهب)
│   └── Font+SamaaTypography.swift # الخطوط والأحجام المنسقة
├── Models/
│   ├── DhikrItem.swift             # نموذج بطاقة الذكر ومحرك إزالة التشكيل
│   ├── PrayerTimeModel.swift       # نموذج أوقات الصلاة والعد التنازلي
│   └── WeatherModel.swift          # نموذج بيانات الطقس
├── Data/
│   ├── MorningAdhkarData.swift     # أذكار الصباح (19 بطاقة)
│   ├── EveningAdhkarData.swift     # أذكار المساء (19 بطاقة)
│   ├── SleepAdhkarData.swift       # أذكار النوم والاستيقاظ (15 بطاقة)
│   └── AfterPrayerAdhkarData.swift # أذكار بعد الصلاة (10 بطاقات)
├── Views/
│   ├── MainTabView.swift           # شريط التنقل السفلي الملكي
│   ├── Home/
│   │   ├── HomeScreenView.swift    # الشاشة الرئيسية، المحراب، والعد التنازلي
│   │   └── Components/             # بطاقات الصلوات، توقعات الطقس والمواعيد
│   ├── Adhkar/
│   │   ├── AdhkarHomeView.swift    # أقسام الأذكار الأربعة
│   │   ├── AdhkarDetailView.swift  # قائمة بطاقات الذكر في القسم
│   │   └── DhikrCardView.swift     # البطاقة الإسلامية الفاخرة مع زر التسبيح وشريط التقدم
│   ├── Qibla/
│   │   └── QiblaCompassView.swift  # بوصلة القبلة التفاعلية بمستشعرات CoreLocation
│   └── Calendar/
│       └── HijriCalendarView.swift # التقويم الهجري والمواعيد
└── Services/
    ├── AdhanAudioService.swift     # مشغل صوت الأذان والتنبيهات
    └── HapticFeedbackService.swift # محرك الاهتزاز اللمسي الذكي
```

---

## كيفية تشغيل المشروع على جهاز Mac

1. افتح تطبيق **Xcode** على جهازك الماك.
2. اختر **Create New Project** ◄ ثم **iOS App** ◄ ثم **SwiftUI**.
3. قم بسحب مجلد `ios_swift_project` وضعه داخل المشروع في Xcode.
4. اختر المحاكي (مثل iPhone 15 Pro أو جهازك المتصل) واضغط على زر **Play (Run)** أو `Cmd + R`.
