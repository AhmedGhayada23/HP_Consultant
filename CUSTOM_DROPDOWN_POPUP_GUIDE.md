# CustomDropdownPopup - دليل الاستخدام

## 🎯 ما هو الفرق؟

### قبل (CustomDropdown)

```
┌─────────────────┐
│ +972       ▼    │  ← يفتح أسفل الـ button
└─────────────────┘
  ┌──────────────┐
  │ +970         │
  │ +972         │
  │ +973         │  ← dropdown عادي
  │ +974         │
  │ +975         │
  └──────────────┘
```

### بعد (CustomDropdownPopup)

```
┌─────────────────┐
│ +972       ▼    │ ← يفتح كـ popup في أي مكان
└─────────────────┘

           ┌──────────────┐
           │ +970         │
           │ +972         │
           │ +973         │ ← popup جميل مع ظل
           │ +974         │
           │ +975         │
           └──────────────┘
```

## ✨ المميزات الجديدة

✅ **Popup محسّن** - يظهر في أفضل موضع على الشاشة
✅ **تصميم جميل** - ظل، حدود، border radius
✅ **ذكي** - يتجنب خروجه من الشاشة
✅ **سلس** - إغلاق بضغطة على الخلفية
✅ **RTL جاهز** - يدعم النصوص العربية

## 📋 الاستخدام

```dart
import 'package:hb/core/widgets/custom_dropdown_popup.dart';

CustomDropdownPopup(
  hint: '+972',
  items: ['+970', '+972', '+973', '+974', '+975'],
  onChanged: (value) {
    print('Selected: $value');
  },
)
```

## 🎨 التصميم

```dart
// الحدود والألوان
decoration: BoxDecoration(
  color: AppColor.whiteColor,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: AppColor.borderColor, width: 1),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ],
),
```

## 🔍 المعاملات

| المعامل         | النوع        | الوصف                  |
| --------------- | ------------ | ---------------------- |
| `hint`          | String       | النص الافتراضي         |
| `items`         | List<String> | قائمة الخيارات         |
| `onChanged`     | Function     | الدالة عند اختيار عنصر |
| `color`         | Color        | لون الخلفية            |
| `selectedValue` | String?      | القيمة المختارة        |

## 📍 الموقع الذكي

الـ popup يحسب موضعه تلقائياً:

```dart
// 1. يفتح تحت الـ button عادة
top = offset.dy + size.height + 8

// 2. إذا كان سيخرج من الشاشة، يفتح فوقه
if (top + maxPopupHeight > screenSize.height) {
  top = offset.dy - maxPopupHeight - 8
}

// 3. نفس الشيء للـ width
if (left + maxPopupWidth > screenSize.width) {
  left = screenSize.width - maxPopupWidth - 16
}
```

## 🎯 أمثلة الاستخدام

### مثال 1: بسيط

```dart
CustomDropdownPopup(
  hint: '+966',
  items: ['+966', '+967', '+968'],
  onChanged: (value) {
    countryCode = value;
  },
)
```

### مثال 2: مع قيمة مختارة

```dart
CustomDropdownPopup(
  hint: 'Select Country',
  items: ['Saudi Arabia', 'UAE', 'Egypt'],
  selectedValue: 'Saudi Arabia',
  onChanged: (value) {
    setState(() {
      selectedCountry = value;
    });
  },
)
```

### مثال 3: في Row

```dart
Row(
  children: [
    SizedBox(
      width: 90.w,
      child: CustomDropdownPopup(
        hint: '+972',
        items: ['+970', '+972', '+973'],
      ),
    ),
    SizedBox(width: 8.w),
    Expanded(
      child: TextField(...),
    ),
  ],
)
```

## 🚀 الملفات المعدلة

| الملف                        | التغييرات                   |
| ---------------------------- | --------------------------- |
| `custom_dropdown_popup.dart` | ✨ ملف جديد                 |
| `auth_sign_up_view.dart`     | ✅ استخدام الـ popup الجديد |

## ⚙️ التكوين

للتحكم في حجم الـ popup:

```dart
// في PopupMenu
final maxPopupWidth = 250.w;    // عرض الـ popup
final maxPopupHeight = 300.h;   // ارتفاع الـ popup
```

## 🐛 حل المشاكل

### الـ popup لا يظهر

- تأكد من أن الـ button لديه GlobalKey
- تأكد من استخدام showDialog

### الـ popup يخرج من الشاشة

- تم حله تلقائياً بالحسابات الذكية

### الـ popup ما يغلق

- اضغط على الخلفية الشفافة

## 📊 المقارنة

| الميزة               | CustomDropdown | CustomDropdownPopup |
| -------------------- | -------------- | ------------------- |
| Dropdown             | ✅             | ✅                  |
| Popup                | ❌             | ✅                  |
| Intelligent Position | ❌             | ✅                  |
| Shadow               | ❌             | ✅                  |
| RTL Support          | ✅             | ✅                  |
| Close on Tap Outside | ❌             | ✅                  |

---

**تم التحديث:** 24 يناير 2026
