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

## 4.4. Username Screen

- hintText: placeholder
- TextEditingController.addListener

```dart
final TextEditingController _usernameController = TextEditingController();

String _username = "";

@override
void initState() {
  super.initState();

  _usernameController.addListener(() {
    setState(() {
      _username = _usernameController.text;
    });
  });
}
..
TextField(
  controller: _usernameController,
  decoration: InputDecoration(
    hintText: "Username",
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
    ),
  ),
  cursorColor: Theme.of(context).primaryColor,
),
```

- AnimatedContainer
  - curve: default=linear(fade in/out)
  - duration: set the animating duration

```dart
child: AnimatedContainer(
  padding: const EdgeInsets.symmetric(
    vertical: Sizes.size16,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(Sizes.size5),
    color: _username.isEmpty
        ? Colors.grey.shade300
        : Theme.of(context).primaryColor,
  ),
  duration: const Duration(milliseconds: 500),
  child: const Text(
    'Next',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  ),
),
```

## 4.5. FormButton

- Extract FormButton
  - Complete TextButton is supported by flutter but try manually
- AnimatedDefaultTextStyle

```dart
child: AnimatedContainer(
  padding: const EdgeInsets.symmetric(
    vertical: Sizes.size16,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(Sizes.size5),
    color:
        disabled ? Colors.grey.shade300 : Theme.of(context).primaryColor,
  ),
  duration: const Duration(milliseconds: 500),
  child: AnimatedDefaultTextStyle(
    duration: const Duration(milliseconds: 500),
    style: TextStyle(
      color: disabled ? Colors.grey.shade400 : Colors.white,
      fontWeight: FontWeight.w600,
    ),
    child: const Text(
      'Next',
      textAlign: TextAlign.center,
    ),
  ),
),
```

- dispose listener
  - super.initState() first
  - clean
  - super.dispose at the end as convention(?)

```dart
@override
void initState() {
  super.initState();
  _usernameController.addListener(() {
    setState(() {
      _username = _usernameController.text;
    });
  });
}

@override
void dispose() {
  _usernameController.dispose();
  super.dispose();
}
```

- In Statefull widget, context is accessiable so that method does not need context as param

## 4.6. Email Screen

- errorText
- validation

```dart
String? _isEmailValid() {
  if (_email.isEmpty) return null;
  final regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (!regExp.hasMatch(_email)) {
    return "Email not valid";
  }
  return null;
}
..
errorText: _isEmailValid(),
```

- TextInputType.emailAddress

```dart
keyboardType: TextInputType.emailAddress,
```

- GestureDetector => FocusScope.of().unfocus()

```dart
void _onScaffoldTap() {
  FocusScope.of(context).unfocus();
}
```

- onSubmitted Vs onEditingComplete

```dart
void _onSubmit() {
  if (_email.isEmpty || _isEmailValid() != null) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PasswordScreen(),
    ),
  );
}
..
onEditingComplete: _onSubmit,
```

## 4.7. Password Screen

- decoration.{pref, suffix}

```dart
suffix: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    GestureDetector(
      onTap: _onClearTap,
      child: FaIcon(
        FontAwesomeIcons.solidCircleXmark,
        color: Colors.grey.shade500,
        size: Sizes.size20,
      ),
    ),
    Gaps.h16,
    GestureDetector(
      onTap: _toggleObscureText,
      child: FaIcon(
        _obscureText
            ? FontAwesomeIcons.eye
            : FontAwesomeIcons.eyeSlash,
        color: Colors.grey.shade500,
        size: Sizes.size20,
      ),
    ),
  ],
),
```

- obsecureText: true => password type
- clear TextEditingController

```dart
void _onClearTap() {
  _passwordController.clear();
}
```
