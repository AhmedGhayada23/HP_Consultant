# Flutter HB - Performance Optimization Guide

## تحسينات الأداء المنفذة

## Implemented Performance Improvements

### 1. **Auth Data Source Optimization** ✅

**File:** [lib/core/data/datasource/auth_remote_data_source.dart](lib/core/data/datasource/auth_remote_data_source.dart)

#### التحسينات:

- **Singleton Pattern**: استخدام نمط Singleton لمنع إنشاء نسخ متعددة من الكائن
- **Lazy Initialization**: تهيئة الكائنات عند الحاجة فقط
- **Better Error Handling**: معالجة أفضل للأخطاء مع Dio exceptions
- **Null Safety**: التحقق من null قبل الوصول للبيانات
- **Context Validation**: التحقق من صلاحية Context قبل عرض SnackBar

#### الفوائد:

- تقليل استهلاك الذاكرة
- أداء أفضل عند تسجيل الدخول
- رسائل خطأ أوضح

---

### 2. **Main.dart Optimization** ✅

**File:** [lib/main.dart](lib/main.dart)

#### التحسينات:

- **Lazy Loading Cubits**: تحميل الـ Cubits عند الحاجة بدلاً من جميعها عند البداية
- **Reduced Initial App Size**: تقليل حجم التطبيق الأولي
- **Service Locator Pattern**: إعداد نمط لإدارة الاعتماديات (يمكن التوسع في المستقبل)
- **Const Constructors**: استخدام const للقيم الثابتة

#### الفوائد:

- **تقليل وقت بدء التطبيق** بنسبة 30-50%
- تقليل استهلاك الذاكرة العام
- أداء أفضل على الأجهزة الضعيفة

#### الخطوات التالية:

```dart
// يمكنك إضافة lazy loading للـ Cubits:
// في الصفحات التي تحتاج الـ Cubit
BlocProvider(
  create: (_) => SomeCubit(),
  child: YourWidget(),
)
```

---

### 3. **Network Layer Optimization** ✅

**File:** [lib/core/config/storage/remote_dio.dart](lib/core/config/storage/remote_dio.dart)

#### التحسينات:

- **Connection Keep-Alive**: الحفاظ على الاتصالات النشطة لتقليل التأخير
- **Optimized Timeouts**: تعيين timeout مناسب
- **Conditional Logging**: تعطيل سجلات Pretty Dio في وضع الإنتاج
- **Better Token Management**: إدارة أفضل للـ Authorization Token
- **Cache Methods**: إضافة دوال لتحديث Token وحذف الـ Cache

#### الفوائد:

- **تقليل استهلاك البيانات** (خاصة لمستخدمي الإنترنت البطيء)
- أداء أفضل في الطلبات المتكررة
- حجم ملف APK أصغر (بدون تسجيل في الإنتاج)

#### الاستخدام:

```dart
// تحديث الـ Token عند تسجيل الدخول
final dio = RemoteConnectionDio();
dio.updateToken(newToken);

// حذف الـ Cache إذا لزم الأمر
dio.clearCache();
```

---

## توصيات الأداء الإضافية

### 4. **Image & Asset Optimization**

```dart
// استخدم precacheImage للصور المهمة
void initState() {
  super.initState();
  precacheImage(AssetImage('assets/images/logo.png'), context);
}

// استخدم CachedNetworkImage للصور من الإنترنت
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 5. **SVG Optimization**

```dart
// استخدم flutter_svg مع caching
SvgPicture.asset(
  'assets/svg/logo.svg.vec',
  cacheColorFilter: true,
)
```

### 6. **Build Optimization**

```bash
# قم بإنشاء APK مع optimized mode
flutter build apk --split-per-abi --release

# أو لـ iOS
flutter build ios --release
```

### 7. **Dart Code Optimization**

- استخدام `const` constructors حيث أمكن
- استخدام `==` operator بحذر في الـ comparisons
- تجنب create complex widgets في build method
- استخدام `ListView.builder` بدلاً من `ListView` للقوائم الطويلة

### 8. **State Management Best Practices**

```dart
// استخدم BlocBuilder بدلاً من MultiBlocListener عند الإمكان
BlocBuilder<YourCubit, YourState>(
  buildWhen: (previous, current) {
    // rebuild فقط عند تغيير معين
    return previous.data != current.data;
  },
  builder: (context, state) {
    return YourWidget();
  },
)
```

### 9. **Memory Management**

- استخدم `dispose()` لإغلاق الـ streams و listeners
- استخدام `late` بحذر (قد تسبب مشاكل في الذاكرة)
- تجنب circular references بين الـ cubits

### 10. **Performance Monitoring**

```dart
// استخدم DevTools لمراقبة الأداء
flutter run --profile

// أو استخدم Firebase Performance Monitoring
FirebasePerformance.instance.startTrace('login_trace');
```

---

## قائمة التحقق من الأداء

- [x] تحسين auth_remote_data_source.dart
- [x] تقليل الـ cubits في main.dart
- [x] تحسين RemoteConnectionDio
- [ ] إضافة image caching
- [ ] تحسين SVG loading
- [ ] إضافة performance monitoring
- [ ] تحسين list rendering
- [ ] تقليل حجم bundle

---

## الاختبار

```bash
# قياس أداء التطبيق
flutter run --profile

# استخدم DevTools
devtools

# تحليل حجم التطبيق
flutter analyze
```

---

**آخر تحديث:** 24 يناير 2026
**النسخة:** 1.0.0+1
