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

## 4.8. Birthday Screen

- date => hint none, disabled but init with now()
- CupertinoDatePicker
- maximumDate: initialDate

```dart
child: CupertinoDatePicker(
  maximumDate: initialDate,
  initialDateTime: initialDate,
  mode: CupertinoDatePickerMode.date,
  onDateTimeChanged: _setTextFieldDate,
),
```

- [x] challenge: 12 years ago => age limitation

## 4.9. Login Form

### form

- form takes GlobalKey

```dart
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
..
void _onSubmitTap() {
  if (_formKey.currentState != null) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }
}
```

- handling null

  1. check null + `!`
  2. `?`

- validate

  - any of targets gets error => false  
    nothing gets error => true

```dart
validator: (value) {
  if (value != null && value.isEmpty) {
    return "Plase write your email";
  }
  return null;
},
```

- save: call onSaved()

```dart
onSaved: (newValue) {
  if (newValue != null) {
    formData['email'] = newValue;
  }
},
```

- [x] challenge: extend button to take `text` param

# 5. Onboarding

## 5.1. Interests Screen

- runSpacing: vertical gap
- spacing: horizontal gap

## 5.2. Scroll Animations

- CupertinoButton: better for quick prototyping
- Scrollbar

```dart
final ScrollController _scrollController = ScrollController();

bool _showTitle = false;

void _onScroll() {
  if (_scrollController.offset > 100) {
    if (_showTitle) return;
    setState(() {
      _showTitle = true;
    });
  } else {
    setState(() {
      _showTitle = false;
    });
  }
}
```

- AnimatedOpacity

```dart
 title: AnimatedOpacity(
  opacity: _showTitle ? 1 : 0,
  duration: const Duration(milliseconds: 300),
  child: const Text("Choose your interests"),
),
```

## 5.3. Tutorial Screen

- DefaultTabcontroller
  - TabBarView: gives swipable view
    - TabPageSelector

```dart
return DefaultTabController(
  length: 3,
  child: Scaffold(
    body: SafeArea(
      child: TabBarView(
        children: [
..
TabPageSelector(
  color: Colors.white,
  selectedColor: Colors.black38,
),
..
```

## 5.4. AnimatedCrossFade

- AnimatedCrossFade: cross-fades between two given children and animates itself between their sizes

```dart
child: AnimatedCrossFade(
  firstChild: Column(
  ..
  secondChild: Column(
  ..
  crossFadeState: _showingPage == Page.first
      ? CrossFadeState.showFirst
      : CrossFadeState.showSecond,
  duration: const Duration(milliseconds: 300),
```

- onPanUpdate(Drag)
  - Positive: right
  - Negative: left
  - onPanend
    - fire event after finger dettached

```dart
void _onPanUpdate(DragUpdateDetails details) {
  if (details.delta.dx > 0) {
    setState(() {
      _direction = Direction.right;
    });
  } else {
    setState(() {
      _direction = Direction.left;
    });
  }
}

void _onPanEnd(DragEndDetails detail) {
  if (_direction == Direction.left) {
    setState(() {
      _showingPage = Page.second;
    });
  } else {
    setState(() {
      _showingPage = Page.first;
    });
  }
}
```

## 6.1. pushAndRemoveUntil

- pushAndRemoveUntil: push and remove until predicate return false
  - usage: after creating account, we don't need to go back

## 6.2. BottomNavigationBar

- tooltip: hover explain
- if type is null && length >= 4, works as BottomNavigationBarType.shifting
- To shift with 2 navigations, set `type: BottomNavigationBarType.shifting` manually

```dart
int _selectedIndex = 0;

final screens = [
  const Center(
    child: Text('Home'),
  ),
  const Center(
    child: Text('Search'),
  ),
];

void _onTap(int index) {
  setState(() {
    _selectedIndex = index;
  });
}
..
bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.shifting,
  currentIndex: _selectedIndex,
  onTap: _onTap,
  selectedItemColor: Theme.of(context).primaryColor,
  items: const [
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.house),
      label: "Home",
      tooltip: "What are you?",
      backgroundColor: Colors.amber,
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
      label: "Search",
      tooltip: "What are you?",
      backgroundColor: Colors.blue,
    ),
  ],
),
```

## 6.3. NavigationBar

- material 3 => NavigationBar

```dart
bottomNavigationBar: NavigationBar(
  labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
  selectedIndex: _selectedIndex,
  onDestinationSelected: _onTap,
  destinations: const [
    NavigationDestination(
      icon: FaIcon(
        FontAwesomeIcons.house,
        color: Colors.white,
      ),
      label: 'Home',
    ),
    NavigationDestination(
      icon: FaIcon(
        FontAwesomeIcons.magnifyingGlass,
        color: Colors.white,
      ),
      label: 'Search',
    ),
  ],
),
```

## 6.4. CupertinoTabBar

- it does not look native?
- use `CupertinoIcons`
- should use `CupertinoApp` in `main.dart`

```dart
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: "Search",
          ),
        ],
      ),
      tabBuilder: (context, index) => screens[index],
    );
  }
}
```

## 6.5. Custom Bar

- column expand as much as possible by default => set `MainAxisSize.min`
- cover icons with container + expanded to better click ux
