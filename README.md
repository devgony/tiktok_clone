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

# 4 Authentication

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

# 6. Tab Navigation

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

## 6.5. Custom NavigationBar

- column expand as much as possible by default => set `MainAxisSize.min`
- cover icons with container + expanded to better click ux

## 6.6. Stateful Navigation part One

- selection effect

```dart
isSelected ? selectedIcon : icon,
```

- should give separated global key to statefull widget to distinguish each
- but widget is disposed as sooon as move to other screen

## 6.7. Stateful Navigation part Two

- Offstage to stack and hide widget => To store each states
- But `i'm built` prints every render?

```dart
body: Stack(
      children: [
        Offstage(
          offstage: _selectedIndex != 0,
          child: const StfScreen(),
        ),
        Offstage(
          offstage: _selectedIndex != 1,
          child: const StfScreen(),
        ),
        Offstage(
          offstage: _selectedIndex != 3,
          child: const StfScreen(),
        ),
        Offstage(
          offstage: _selectedIndex != 4,
          child: const StfScreen(),
        )
      ],
    ),
```

## 6.8. Post Video Button

- Positioned widget

- clipBehavior: hiding

```dart
clipBehavior: Clip.none,
children: [
  Positioned(
    right: 20,
    ..
```

### Challenge: onTabDown animation on Post Video Button

- standBy
  ![standBy](/md_images/2023-02-08-16-04-16.png)
- onTabDown: scale up x1.2
  ![onTabDown](/md_images/2023-02-08-16-04-27.png)
- onTapUp => execute onTap to navigate to RecordVideoScreen

### Question

- Why scale should be set at `build`?

```dart
..
Widget build(BuildContext context) {
  _scale = 1 + _controller.value;
  return GestureDetector(
    onTapDown: _tapDown,
    onTapUp: _tapUp,
    child: Transform.scale(
..
```

# 7. Video timeline

## 7.1. Infinite Scrolling

- PageView
- pageSnapping(default: true)

  - snap the screen so that user don't need to swipe to end

- itemBuilder for PageView: add items dynamically

```dart
return PageView.builder(
  scrollDirection: Axis.vertical,
  onPageChanged: _onPageChanged,
  itemCount: _itemCount,
  itemBuilder: (context, index) => Container(
    color: colors[index],
    child: Center(
      child: Text(
        "Screen $index",
        style: const TextStyle(fontSize: 68),
      ),
    ),
  ),
);
```

## 7.2. PageController

- remove deacceleration animation

```dart
_pageController.animateToPage(
  page,
  duration: const Duration(milliseconds: 150),
  curve: Curves.linear,
);
```

## 7.3. Video Player

- install

```
mkdir -p assets/videos
mv *.mp4 assets/videos/
flutter pub add video_player
```

- Video Player

```dart
// lib/features/videos/widgets/video_post.dart
void _initVideoPlayer() async {
  await _videoPlayerController.initialize();
  _videoPlayerController.play();
  setState(() {});
  _videoPlayerController.addListener(_onVideoChange);
}

@override
void initState() {
  super.initState();
  _initVideoPlayer();
}

@override
void dispose() {
  _videoPlayerController.dispose();
  super.dispose();
}
..
child: _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : Container(
                  color: Colors.black,
                ),
```

- onFinished => nextPage

```dart
// lib/features/videos/widgets/video_post.dart
void _onVideoChange() {
  if (_videoPlayerController.value.isInitialized) {
    if (_videoPlayerController.value.duration ==
        _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }
}
..

// lib/features/videos/video_timeline_screen.dart
void _onVideoFinished() {
  _pageController.nextPage(
    duration: _scrollDuration,
    curve: _scrollCurve,
  );
}
```

- should we manually dispose even controller?

## 7.4. VisibilityDetector

- install

```
flutter pub add visibility_detector
```

- should play video 1 by 1 with visibility 100%

```dart
void _onVisibilityChanged(VisibilityInfo info) {
  if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
    _videoPlayerController.play();
  }
}
```

- toggle pause + animation + but ignore click

```dart
void _onTogglePause() {
  if (_videoPlayerController.value.isPlaying) {
    _videoPlayerController.pause();
  } else {
    _videoPlayerController.play();
  }
}
..
child: IgnorePointer(
  child: Center(
    child: FaIcon(
      FontAwesomeIcons.play,
      color: Colors.white,
      size: Sizes.size52,
    ),
  ),
),
```

## 7.5. AnimationController

- Animation controller
  - reverse & forward

```dart
void _onTogglePause() {
  if (_videoPlayerController.value.isPlaying) {
    _videoPlayerController.pause();
    _animationController.reverse();
  } else {
    _videoPlayerController.play();
    _animationController.forward();
  }
  setState(() {
    _isPaused = !_isPaused;
  });
}
```

- call `build` on every transition? => add event listener + setState
  - does it render all the component again or juse button?

```dart
_animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }
```

## 7.6. AnimatedBuilder

- AnimationBuilder widget
- Wrapper of manual Animation Controller

```dart
child: AnimatedBuilder(
  animation: _animationController,
  builder: (context, child) {
    return Transform.scale(
      scale: _animationController.value,
      child: child,
    );
  },
  child: AnimatedOpacity(
    opacity: _isPaused ? 1 : 0,
    duration: _animationDuration,
    child: const FaIcon(
      FontAwesomeIcons.play,
      color: Colors.white,
      size: Sizes.size52,
    ),
  ),
),
```

## 7.7. SingleTickerProviderStateMixin

- with => copy from extend
- prevent unnecessary animation
- Ticker class: calls its callback once per animation frame
  - if need Multiple tickers => TickerProviderStateMixin

## 7.8. Video UI

- onFinished just return to stop
- setLooping => replay forever
- hashtags => code challenge later
- CircleAvatar

```dart
CircleAvatar(
  radius: 25,
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  foregroundImage: NetworkImage(
    "https://avatars.githubusercontent.com/u/51254761?v=4",
  ),
  child: Text("henry"),
),
```

- Custom widget for icons: VideoButton

### Challenge: click more => show details

- more  
  ![more](/md_images/2023-02-17-16-30-46.png)
- less  
  ![less](/md_images/2023-02-17-16-31-06.png)

## 7.9. RefreshIndicator

- user pulls => refresh => should return future
- edgeOffset like top: 0 (default)
- displacement like margin-top: 0 (default)
- background color => inherited from Scaffold

```dart
// lib/features/videos/video_timeline_screen.dart
return RefreshIndicator(
  onRefresh: _onRefresh,
  displacement: 50,
  edgeOffset: 20,
  color: Theme.of(context).primaryColor,
  child: PageView.builder(
    controller: _pageController,
    scrollDirection: Axis.vertical,
    onPageChanged: _onPageChanged,
    itemCount: _itemCount,
    itemBuilder: (context, index) => VideoPost(
      onVideoFinished: _onVideoFinished,
      index: index,
    ),
  ),
);
```

# 8. Comments Section

## 8.0. showModalBottomSheet

- prev bug: after refreshing it should not play again affected by visibility

```dart
// lib/features/videos/widgets/video_post.dart
if (info.visibleFraction == 1 &&
      !_isPaused &&
      !_videoPlayerController.value.isPlaying) {
```

- showModalBottomSheet
- remove back button

```dart
// lib/features/videos/widgets/video_comments.dart
child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          automaticallyImplyLeading: false,
          title: const Text("22796 comments"),
          actions: [
            IconButton(
              onPressed: _onClosePressed,
              icon: const FaIcon(FontAwesomeIcons.xmark),
            ),
          ],
```

- border-radius

```dart
// lib/features/videos/widgets/video_post.dart
showModalBottomSheet.backgroundColor: Colors.transparent,

// lib/features/videos/widgets/video_comments.dart
Container.decoration.borderRadius: BorderRadius.circular(Sizes.size14),
```

## 8.1. Comments

- ListView.builder() => separated()

```dart
body: ListView.separated(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size10,
            horizontal: Sizes.size16,
          ),
          separatorBuilder: (context, index) => Gaps.v20,
```

- BottomNavigationBar

## 8.2. Add Comment

- should set width => put inside SizedBox or `Expanded` widget
- move input to top
- open keyboard => video squashed

```dart
Scaffold.resizeToAvoidBottomInset: false
```

```dart
// lib/features/main_navigation/main_navigation_screen.dart
showModalBottomSheet has new scaffold so that we can use BottomNavigationBar
```

- replace bottomNavigationBar => wrap ListView with Stack + Positioned.bottom: 0
  - get width from MediaQuery

```dart
// lib/features/videos/widgets/video_comments.dart
final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.75,
```

- isScrollControlled: true => mutable height of showModalBottomSheet

```dart
// lib/features/videos/widgets/video_post.dart
await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
```

## 8.3. Text Input Actions

- contentPadding.vertical does not work at separated => wrap text with SizedBox

```diff
+child: SizedBox(
+  height: Sizes.size44,
..
contentPadding: const EdgeInsets.symmetric(
-   vertical: Sizes.size10,
```

- textAction
  - newline => enter button
  - expands: true => can expand text input with new line
- `_isWriting` state => activate send button

## 8.4. Conclusions

- positioned inside stack => give margine at the bottom

```dart
padding: const EdgeInsets.only(
  top: Sizes.size10,
  bottom: Sizes.size96 + Sizes.size20,
  left: Sizes.size16,
  right: Sizes.size16,
```

- scrollController => show scroll bar

```dart
Scrollbar(
  controller: _scrollController,
  child: ListView.separated(
    controller: _scrollController,
```

# 9. Discover

## 9.0. Introduction

- moving to discover should pause video
  - but unmounted case should be handled?

```dart
void _onTogglePause() {
if (!mounted) return;
```

## 9.1. Light Navigation

- convert color of NavTab on clicking Discover

## 9.2. TabBar

- bottom: PreferredSizeWidget => TabBar => needs TabController
- scrollable
- remove splash effect

```dart
return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('Discover'),
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
```

## 9.3. GridView

- skip(1)
- Sliver
- childAspectRatio 9/16

```dart
GridView.builder(
  itemCount: 20,
  padding: const EdgeInsets.all(
    Sizes.size6,
  ),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: Sizes.size10,
    mainAxisSpacing: Sizes.size10,
    childAspectRatio: 9 / 16,
  ),
  itemBuilder: (context, index) => Container(
    color: Colors.teal,
    child: Center(
      child: Text("$index"),
    ),
  ),
),
```

## 9.4. Grid Item

- register image at `pubspec.yaml` => restart
- FadeInImage: fade in from placeholer to image
- AspectRatio + BoxFit.cover
- ellipsis: Text.maxLines + `overflow: TextOverflow.ellipsis`
- DefaultTextStyle: adjust TextStyle to children

```dart
// lib/features/discover/discover_screen.dart
AspectRatio(
  aspectRatio: 9 / 16,
  child: FadeInImage.assetNetwork(
    fit: BoxFit.cover,
    placeholder: "assets/images/placeholder.jpg",
    image: ".."
),
Gaps.v10,
const Text(
  "This is a very long caption for my tiktok that im upload just now currently.",
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
  style: TextStyle(
    fontSize: Sizes.size16 + Sizes.size2,
    fontWeight: FontWeight.bold,
  ),
),
```

## 9.5. CupertinoSearchTextField

- border radius

```dart
Container(
  clipBehavior: Clip.hardEdge,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(Sizes.size4),
  ),
```

- CupertinoSearchTextField: One liner text input
- init text => controller => dispose
- textSelectionTheme from main
- dismiss keyboard onDrag
- resizeToAvoidBottomInset: false to keep image size

### Challenge

1. dismiss keyboard on change tab

```dart
void _onTabBarTap(int _) {
  FocusScope.of(context).unfocus();
}
```

2. manual search bar instead of CupertinoSearchTextField

- show Xmark if only search text is not empty

```dart
setState(() {
  _writing = value.isNotEmpty;
});
```

- `_textEditingController.clear()` was usefull to implement `onXmarkTap`

```dart
TextField(
  controller: _textEditingController,
  onChanged: _onSearchChanged,
  onSubmitted: _onSearchSubmitted,
  decoration: InputDecoration(
    hintText: "Search",
    hintStyle: const TextStyle(color: Colors.grey),
    filled: true,
    fillColor: Colors.grey.shade200,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: Sizes.size12,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        Sizes.size12,
      ),
      borderSide: BorderSide.none,
    ),
    prefixIcon: const Icon(
      FontAwesomeIcons.magnifyingGlass,
      color: Colors.grey,
      size: 20,
    ),
    suffixIcon: GestureDetector(
      onTap: _onXmarkTap,
      child: const Icon(
        FontAwesomeIcons.solidCircleXmark,
        color: Colors.grey,
        size: 20,
      ),
    ),
  ),
)
```

- CupertinoSearchTextField
  ![prev_search_bar](/md_images/2023-03-02-10-53-16.png)
- my manual search bar
  ![my_search_bar](/md_images/2023-03-02-14-05-40.png)

# 10. Inbox

## 10.0. ListTile

- elevation like z-index
- ListTile supports..
  - leading, title, subtitle, trailing

```dart
ListTile(
  leading: Container(
    width: Sizes.size52,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
    child: const Center(
      child: FaIcon(
        FontAwesomeIcons.users,
        color: Colors.white,
      ),
    ),
  ),
  title: const Text(
    'New followers',
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Sizes.size16,
    ),
  ),
  subtitle: const Text(
    'Messages from followers will appear here',
    style: TextStyle(
      fontSize: Sizes.size14,
    ),
  ),
  trailing: const FaIcon(
    FontAwesomeIcons.chevronRight,
    size: Sizes.size14,
    color: Colors.black,
  ),
)
```

## 10.1. RichText

- onTap action splash => transparent at main

```dart
// lib/main.dart
ThemeData.splashColor: Colors.transparent,
```

- RichText: TextStyle within other Text

```dart
RichText(
  text: TextSpan(
    text: "Account updates:",
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontSize: Sizes.size16,
    ),
    children: [
      const TextSpan(
        text: " Upload longer videos",
        style: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      TextSpan(
        text: " 1h",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade500,
        ),
      ),
    ],
  ),
)
```

## 10.2. Dismissible

- Dismissable widget
  - background: exposed when dragged down or to the right
  - secondaryBackground: exposed when dragged up or to the left

```dart
Dismissible(
  key: const Key("x"),
  background: Container(
    alignment: Alignment.centerLeft,
    color: Colors.green,
    child: const Padding(
      padding: EdgeInsets.only(
        left: Sizes.size10,
      ),
      child: FaIcon(
        FontAwesomeIcons.checkDouble,
        color: Colors.white,
        size: Sizes.size32,
      ),
    ),
  ),
  secondaryBackground: Container(
    alignment: Alignment.centerRight,
    color: Colors.red,
    child: const Padding(
      padding: EdgeInsets.only(
        right: Sizes.size10,
      ),
      child: FaIcon(
        FontAwesomeIcons.trashCan,
        color: Colors.white,
        size: Sizes.size32,
      ),
    ),
  ),
  child: ListTile(
    ..
```

## 10.3. onDismissed

- onDismissed => remove not only render but also real data

```dart
final List<String> _notifications = List.generate(20, (index) => "${index}h");

void _onDismissed(String notification) {
  _notifications.remove(notification);
  setState(() {});
}
..
for (var notification in _notifications)
  Dismissible(
    ..
```

## 10.4. RotationTransition

- animation
  1. setState
  2. animationBuilder + listener
  3. Animation + RotationTransition

```dart
late final AnimationController _animationController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 200),
);

late final Animation<double> _animation =
    Tween(begin: 0.0, end: 0.5).animate(_animationController);

void _onDismissed(String notification) {
  _notifications.remove(notification);
  setState(() {});
}

void _onTitleTap() {
  if (_animationController.isCompleted) {
    _animationController.reverse();
  } else {
    _animationController.forward();
  }
}
..
RotationTransition(
  turns: _animation,
  child: const FaIcon(
    FontAwesomeIcons.chevronDown,
    size: Sizes.size14,
  ),
)
..
```

## 10.5. SlideTransition

- still use same controller

```dart
late final Animation<Offset> _panelAnimation = Tween(
  begin: const Offset(0, -1),
  end: Offset.zero,
).animate(_animationController);
..
SlideTransition(
  position: _panelAnimation,
  child: Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(
          Sizes.size5,
        ),
        bottomRight: Radius.circular(
          Sizes.size5,
        ),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var tab in _tabs)
          ListTile(
            title: Row(
              children: [
                FaIcon(
                  tab["icon"],
                  color: Colors.black,
                  size: Sizes.size16,
                ),
                Gaps.h20,
                Text(
                  tab["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  ),
)
```

## 10.6. AnimatedModalBarrier

- AnimatedModalBarrier

```dart
if (_showBarrier)
  AnimatedModalBarrier(
    color: _barrierAnimation,
    dismissible: true,
    onDismiss: _toggleAnimations,
  ),
```

- await
  - onForward: expose barrier directly
  - onReverse: await till animation is completed then, expose barrier

```dart
void _toggleAnimations() async {
  if (_animationController.isCompleted) {
    await _animationController.reverse();
  } else {
    _animationController.forward();
  }

  setState(() {
    _showBarrier = !_showBarrier;
  });
}
```

# 11. CHATS

## 11.1. Direct Messages

- stateless: onSth hook should get context by args
- statefull: context is served from state
- mainAxisSize: MainAxisSize.min => min size not to be affected by other button => certralized

```diff
# activity_screen.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: GestureDetector(
        onTap: _toggleAnimations,
        child: Row(
+         mainAxisSize: MainAxisSize.min,
```

## 11.2. AnimatedList

- AnimatedList: ListViewBuilder + Animation
- GlobalKey for AnimatedListState

```dart
// chats_screen.dart
final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

final List<int> _items = [];

void _addItem() {
  if (_key.currentState != null) {
    _key.currentState!.insertItem(
      _items.length,
      duration: const Duration(milliseconds: 500),
    );
    _items.add(_items.length);
  }
}
```

- set UniqueKey not to confused
- FaceTransition & SizedTransition

```dart
// chats_screen.dart
itemBuilder: (context, index, animation) {
  return FadeTransition(
    key: UniqueKey(),
    opacity: animation,
    child: SizeTransition(
      sizeFactor: animation,
      child: ListTile(
```

## 11.3. AnimatedList part Two

- deleteOnLongPress

```dart
// chats_screen.dart
void _deleteItem(int index) {
  if (_key.currentState != null) {
    _key.currentState!.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: Container(
          color: Colors.red,
          child: _makeTile(index),
        ),
      ),
      duration: _duration,
    );
    _items.removeAt(index);
  }
}
```

## 11.4. Chat Detail

- isMine with modulo by 2
- message container with BorderRaduis

```dart
// chat_detail_screen.dart
final isMine = index % 2 == 0;
return Row(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment:
      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
  children: [
    Container(
      padding: const EdgeInsets.all(Sizes.size14),
      decoration: BoxDecoration(
        color:
            isMine ? Colors.blue : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(
            Sizes.size20,
          ),
          topRight: const Radius.circular(
            Sizes.size20,
          ),
          bottomLeft: Radius.circular(
            isMine ? Sizes.size20 : Sizes.size5,
          ),
          bottomRight: Radius.circular(
            !isMine ? Sizes.size20 : Sizes.size5,
```

- should give width to solve error

```dart
Positioned(
  bottom: 0,
  width: MediaQuery.of(context).size.width,
```

### Challenge: status circle & message input bar

1. status circle

- Goal  
  ![goal_status_circle](/md_images/2023-03-14-18-08-59.png)
- Mine  
  ![my_status_circle](/md_images/2023-03-15-13-02-38.png)

2. message input bar

- Goal  
  ![goal_input_bar](/md_images/2023-03-14-18-12-59.png)
- Mine  
  ![my_input_bar_normal](/md_images/2023-03-15-13-03-55.png)  
  ![my_input_bar_insert](/md_images/2023-03-15-13-04-48.png)

# 12. USER PROFILE

## 12.1. CustomScrollView

- slivers: elements inside scroll view
- collapsedHeight
- flexibleSpace
  - title
- stretch mode

```dart
return CustomScrollView(
  slivers: [
    SliverAppBar(
      floating: true,
      stretch: true,
      pinned: true,
      backgroundColor: Colors.teal,
      collapsedHeight: 80,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        background: Image.asset(
          "assets/images/placeholder.jpg",
          fit: BoxFit.cover,
        ),
        title: const Text("Hello!"),
      ),
    )
  ],
);
```

## 12.2. SliverAppBar

- floating: true -> As soon as goes up, whole Bar shows up slowly
- pinned: true -> background color + FlexibleSpaceBar
- snap + floating: true -> faster than floating, just snap at once
- stretch: true -> ZoomIn or fade Bar

## 12.3. SliverGrid

```dart
SliverGrid(
  delegate: SliverChildBuilderDelegate(
    childCount: 50,
    (context, index) => Container(
      color: Colors.blue[100 * (index % 9)],
      child: Align(
        alignment: Alignment.center,
        child: Text("Item $index"),
      ),
    ),
  ),
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 100,
    mainAxisSpacing: Sizes.size20,
    crossAxisSpacing: Sizes.size20,
    childAspectRatio: 1,
  ),
)
```

## 12.4. SliverPersistentHeader

- can pin silvers like header
- pull down => maxExtent
- pull up => minExtent

```dart
..
SliverPersistentHeader(
  delegate: CustomDelegate(),
  floating: true,
),
..
class CustomDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo,
      child: const FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Text(
            'Title!!!!!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
```

- [bonus]SliverToBoxAdapter: To put any widget, it should be wrapped with SilverToBoxAdapter

## 12.5. VerticalDivider

- VerticalDivider should have hight => use sizeBox

```dart
// user_profile_screen.dart
VerticalDivider(
  width: Sizes.size32,
  thickness: Sizes.size1,
  color: Colors.grey.shade400,
  indent: Sizes.size14,
  endIndent: Sizes.size14,
),
```

## 12.6. TabBar

- FractionallySizedBox: width/height of parents \* fraction
- Cannot use SlivGrid in Another slive -> use GridView builder
- Can only scroll slivers but not grid view builder -> NeverScrollableScrollPhysic -> Nested scroll view(?)

## 12.7. PersistentTabBar

- Replace CustomScrollView to NestedScrollView
- SliverPersistentHeader to pin
- SafeArea

### Challenge: youtube button & view numbers + pinned on image

1. Youtube and dropdown button

- FractionallySizedBox should be wrapped with Flexible to be in Row
- To use HeightFactor of FractionallySizedBox, parent should have physical height like `SizedBox`
- To set vertical & horizontal align center of Text, wrap with `Align` and `alignment: Alignment.center`

- Goal

![youtube-and-dropdown](/md_images/2023-03-23-09-23-11.png)

- Mine

![my-youtube-and-dropdown](/md_images/2023-03-23-10-21-16.png)

2. Play icon and view numbers + pinned on image

   - Stack > aspectRatio > image > positioned > Row

- Goal

![play-and-viewNumber](/md_images/2023-03-23-09-24-09.png)

- Mine

![my-play-and-viewNumber](/md_images/2023-03-27-10-02-46.png)

## 12.8. Conclusions

### fix Home - scrolling video crash bug

- `_onVisibilityChanged`
  - all statefull widget has `mount`
  - check if not mounted => return

```dart
//! ../video_post.dart
void _onVisibilityChanged(VisibilityInfo info) {
  if (!mounted) return;
..
```

# 13. SETTINGS

## 13.0. ListWheelScrollView

- ListWheelScrollView
  - diameterRatio: diameter of wheel
  - useMagnifier & magnification: zoom in
  - offAxisFraction: left of right
- CupertinoActivityIndicator: ios
- CircularProgressIndicator.adaptive(): adaptive to divice(ios or android)

```dart
//! settings_screen.dart
body: ListWheelScrollView(
  diameterRatio: 1.5,
  offAxisFraction: 1.5,
  itemExtent: 200,
  children: [
    for (var x in [1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1])
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          color: Colors.teal,
          alignment: Alignment.center,
          child: const Text(
            'Pick me',
            style: TextStyle(
              color: Colors.white,
              fontSize: 39,
            ),
          ),
        ),
      )
  ],
));
```
