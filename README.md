> # _Tiktok Clone_

# 3. Project Setup

## 3.0. Initialization

```
flutter create tiktok_clone
```

## 3.1. Constants

- fixed atomic styles like tailwind

```dart
class Sizes {
  static const size1 = 1.0;
  static const size2 = 2.0
..
```

```dart
class Gaps {
  // Vertical Gaps
  static const v1 = SizedBox(height: Sizes.size1);
  static const v2 = SizedBox(height: Sizes.size2);
..
  // Horizontal Gaps
  static const h1 = SizedBox(width: Sizes.size1);
  static const h2 = SizedBox(width: Sizes.size2);
..
```

## 4.0. Sign Up Screen

- Scafold makes contents configurable like font size, color ..
- SafeArea
- BottomAppBar

## 4.1. Logint Screen

- feature driven architecture(not by page)
- BoxDecoration
- FractionallySizedBox: relative to parent

## 4.2. AuthButton

- Stack: items on top of another => align each items

```dart
child: Stack(
  alignment: Alignment.center,
  children: [
    Align(
      alignment: Alignment.centerLeft,
      child: icon,
    ),
    Text(
      text,
      style: const TextStyle(
        fontSize: Sizes.size16,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    ),
  ],
),
```

- install font awesome with fixed version

```yaml
# pubspec.yaml
dependencies:
  font_awesome_flutter: 10.3.0
```

## 4.3. Sign Up Form

- [x] Challenge: GestureDetector inside AuthButton
- prefix `_`
  - private convention eg) lifecycle method of widget
  - Dart doesn't have access modifier
- central control by AppBarTheme
  - also can ovewrite at child

```dart
scaffoldBackgroundColor: Colors.white, // for what?
appBarTheme: const AppBarTheme(
  foregroundColor: Colors.black,
  backgroundColor: Colors.white,
  elevation: 0,
  titleTextStyle: TextStyle(
    color: Colors.black,
    fontSize: Sizes.size16 + Sizes.size2,
    fontWeight: FontWeight.w600,
  ),
)
```
