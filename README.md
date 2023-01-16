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
