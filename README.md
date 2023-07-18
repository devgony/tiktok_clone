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

## 13.1. AboutListTile

- manual showAboutDialog or AboutListTile
  - VIEW LICENSES: summarize

### Manual showAboutDialog

```dart
ListTile(
  onTap: () => showAboutDialog(
    context: context,
    applicationVersion: "1.0",
    applicationLegalese: "All rights reseverd. Please dont copy me.",
  ),
  title: const Text(
    "About",
    style: TextStyle(
      fontWeight: FontWeight.w600,
    ),
  ),
  subtitle: const Text("About this app....."),
),
```

### AboutListTile: showAboutDialog was already implemented

```dart
const AboutListTile(),
```

## 13.2. showDateRangePicker

- showDatePicker
- showTimePicker
- showDateRangePicker
  - default color can conflict with PrimaryTheme -> use builder to set foreground, background color

```dart
ListTile(
  onTap: () async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
    );
    print(date);
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    print(time);
    final booking = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              appBarTheme: const AppBarTheme(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black)),
          child: child!,
        );
      },
    );
    print(booking);
  },
  title: const Text("What is your birthday?"),
),
```

## 13.3. SwitchListTile

- Switch, CupertinoSwitch
  - Switch.adaptive
- SwitchListTile.adaptive
- Checkbox
- CheckboxListTile

```dart
SwitchListTile.adaptive(
  value: _notifications,
  onChanged: _onNotificationsChanged,
  title: const Text("Enable notifications"),
  subtitle: const Text("Enable notifications"),
),
CheckboxListTile(
  activeColor: Colors.black,
  value: _notifications,
  onChanged: _onNotificationsChanged,
  title: const Text("Enable notifications"),
),
```

## 13.4. CupertinoAlertDialog

- CupertinoAlertDialog: for ios
- AlertDialog: for andriod, customizable

```dart
ListTile(
  title: const Text("Log out (iOS)"),
  textColor: Colors.red,
  onTap: () {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Plx dont go"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            isDestructiveAction: true,
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  },
),
ListTile(
  title: const Text("Log out (Android)"),
  textColor: Colors.red,
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const FaIcon(FontAwesomeIcons.skull),
        title: const Text("Are you sure?"),
        content: const Text("Plx dont go"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const FaIcon(FontAwesomeIcons.car),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  },
),
```

## 13.5. CupertinoActionSheet

- showCupertinoModalPopup: dismissable to bottom
- isDefaultAction: bold
- isDestructiveAction: red

```dart
ListTile(
  title: const Text("Log out (iOS / Bottom)"),
  textColor: Colors.red,
  onTap: () {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Are you sure?"),
        message: const Text("Please dooooont gooooo"),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Not log out"),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Yes plz."),
          )
        ],
      ),
    );
  },
),
```

# 14. RESPONSIVE FLUTTER WEB

## 14.1. OrientationBuilder

- breakpoints from tailwind

```dart
class Breakpoints {
  static const sm = 640;
  static const md = 768;
  static const lg = 1024;
  static const xl = 1280;
  static const xxl = 1536;
}
```

- orientationBuilder

```dart
//! ../sign_up_screen.dart
@override
Widget build(BuildContext context) {
    return builder: (context, orientation) {
      return Scaffold(
        ..
```

- collection if + ...[widget1, widget2]
- box width infinity error => FractionallySizeBox? => wrap with Expanded

```dart
//! ../sign_up_screen.dart
Expanded(
  child: AuthButton(
    icon: const FaIcon(FontAwesomeIcons.user),
    text: "Use email & password",
    onTap: _onEmailTap,
  ),
),
```

- lock orientation.landscape with early return

```dart
//! ../sign_up_screen.dart
if (orientation == Orientation.landscape) {
  return const Scaffold(
    body: Center(
      child: Text("Please use portrait mode"),
    ),
  );
}
```

### Before runApp

1. make sure connection between widget and engine is initialized

```dart
WidgetsFlutterBinding.ensureInitialized();
```

2. SystemChrome
   - lock portrait
   - statusbar black or white => good for videos page

```dart
await SystemChrome.setPreferredOrientations(
  [
    DeviceOrientation.portraitUp,
  ],
);

SystemChrome.setSystemUIOverlayStyle(
  SystemUiOverlayStyle.dark,
);
```

## 14.2. kIsWeb

- `_selectedIndex: 0` => `_videoElement error` => if web, should be muted due to abuse
- constant k + isWeb

```dart
//! ../video_post.dart
void _initVideoPlayer() async {
  ..
  if (kIsWeb) {
    await _videoPlayerController.setVolume(0);
  }
```

### Challenge: implement mute button on video_post

- implemented result

1. mute

   ![mute](/md_images/2023-04-04-17-55-19.png)

2. unmute

   ![unmute](/md_images/2023-04-04-17-55-35.png)

## 14.3. MediaQuery

```dart
//! lib/features/discover/discover_screen.dart
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  ..
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > Breakpoints.lg ? 5 : 2,
```

## 14.4. LayoutBuilder

- MediaQuery: screen size
- LayoutBuilder: how big this container can be
- Usage: if there are cases which cannot be handled by only windows
  - photo size less than 300 can be in both of grid-col-2 and grid-col-5

## 14.5. ConstrainedBox

```dart
//! discover_screen.dart
title: ConstrainedBox(
  constraints: const BoxConstraints(
    maxWidth: Breakpoints.sm,
```

- `Container` also has maxWidth

## 14.6. Code Challenge

### Profile

- Render horizontal profile widgets(id, follow, youtube, following, description..)
- GridView pictures from grid-col-3 to 5

#### width =< 768

![profile_width_less_than_768](/md_images/2023-04-06-09-56-37.png)

#### width > 768

![profile_width_more_than_768](/md_images/2023-04-06-09-57-20.png)

### Setting

- ConstrainedBox
  ![setting_constrained](/md_images/2023-04-06-09-58-20.png)

### Video comments

- showModalBottomSheet.constraints
  ![video_comments_constrained](/md_images/2023-04-06-09-59-06.png)

# 15. DARK MODE

- toggle dark mode: shift + ⌘ + a

## 15.1. ThemeMode

### using default color => ThemeData

### highly customized

1. utils.dart.isDartMode => ternary

```dart
//! utils.dart
bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;
```

```dart
//! sign_up_screen.dart
bottomNavigationBar: BottomAppBar(
  color: isDarkMode(context) ? null : Colors.grey.shade50,
```

2. use black + opacity

```dart
//! sign_up_screen.dart
const Opacity(
  opacity: 0.7,
  child: Text(
    "Create a profile, follow other accounts, make your own videos, and more.",
    style: TextStyle(
      fontSize: Sizes.size16,
    ),
    textAlign: TextAlign.center,
  ),
),
```

## 15.2. TextTheme

- google font

```yaml
#! pubspec.yaml
dependencies:
  google_fonts: 4.0.1
```

- [material design font guide](https://m2.material.io/design/typography/the-type-system.html#type-scale)
- TextTheme

```dart
textTheme: TextTheme(
  displayLarge: GoogleFonts.openSans(
      fontSize: 95, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      ..
```

- copyWith: extends TextTheme

```dart
//! sign_up_screen.dart
Theme.of(context)
.textTheme
.headlineSmall!
.copyWith(color: Colors.red)
```

## 15.3. Google Fonts

- set textTheme from lib

```dart
//! main.dart
return MaterialApp(
  theme: ThemeData(
    textTheme: GoogleFonts.itimTextTheme(),
  ..
  darkTheme: ThemeData(
    textTheme: GoogleFonts.itimTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
```

- use specific font different with theme

```dart
//! sign_up_screen.dart
GoogleFonts.abrilFatface(
  textStyle: const TextStyle(
    fontSize: Sizes.size24,
    fontWeight: FontWeight.w700,
  ),
),
```

## 15.4. Typography

- typography: server colors and font without geometry like weight... => fit with our custom geometry codes

```dart
return MaterialApp(
  theme: ThemeData(
    textTheme: Typography.blackMountainView,
  ..
  darkTheme: ThemeData(
    textTheme: Typography.whiteMountainView,
```

## 15.5. Dark Mode part One

- upgrade to 3.7.1 to use TabBarTheme.indicatorColor

```
flutter upgrade
```

- TabBarTheme
  - lightTheme.tabBarTheme.indicatorColor => bug?

```dart
//! main.dart
theme: ThemeData(
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey.shade500,
    indicatorColor: Colors.black,
..
darkTheme: ThemeData(
  tabBarTheme: const TabBarTheme(indicatorColor: Colors.white),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFFE9435A),
  ),
```

## 15.6. Dark Mode part Two

- Scaffold, AppBar has custom background -> remove
- listTileTheme

```dart
//! main.dart
theme: ThemeData(
  listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
  ),
```

## 15.7. Dark Mode part Three

- create child Scafoold and set backgroundColor to sync with AppBar color

```dart
//! use_profile_screen.dart
return Scaffold(
  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
  body: SafeArea(
```

## 15.8. Material 3 Migration

- BottomAppBar not any more => use Container + more padding
- AppBar color -> sufaceTintColor: cOlors.white
- sync titleTextStyle to DarkTheme
- icon default purple(labelColor)
- text overflown

## 15.9. Conclusions

- minimized external lib but use [flex_color_scheme](https://pub.dev/packages/flex_color_scheme)
- [flex_color_scheme playground](https://rydmike.com/flexcolorscheme/themesplayground-v7/#/)

# 16. APP TRANSLATION

## 16.1. Localizations

### refactoring

- kDebugMode

```dart
//! settings_screen.dart
if (kDebugMode) {
  print(booking);
}
```

- check isMounted

```dart
//! settings_screen.dart
if (!mounted) return;

final time = await showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
);
```

### localization

- install intl

```yaml
#! pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter

  intl: any
```

```dart
//! main.dart
return MaterialApp(
  ..
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale("en"),
    Locale("ko"),
    Locale("es"),
  ],
```

- change language

```dart
return Localizations.override(
  context: context,
  locale: const Locale('ko'),
  child: Scaffold(
```

## 16.2. l10n

- install l10n

```yaml
#! touch l10n.yaml
arb-dir: lib/intl
template-arb-file: intl_en.arb
output-localization-file: intl_generated.dart

#! mkdir -p lib/intl/
#! touch lib/intl/intl_en.arb
{
    "signUpTitle":"Sign up for TikTok"
}

#! touch lib/intl/intl_ko.arb
{
    "signUpTitle":"TikTok에 가입하세요"
}

#! pubspec.yaml
flutter:
  generate: true
```

- add delegate

```dart
Widget build(BuildContext context) {
  return MaterialApp(
      ..
      AppLocalizations.delegate,
```

- `flutter gen-l10n`

  generate localizations at `.dart_tool/flutter_gen/gen_l10n/*`

## 16.3. AppLocalizations

- supportedLocales

```diff
- localizationsDelegates: const [
-   AppLocalizations.delegate,
-   GlobalMaterialLocalizations.delegate,
-   GlobalCupertinoLocalizations.delegate,
-   GlobalWidgetsLocalizations.delegate,
- ],
- supportedLocales: const [
-   Locale("en"),
-   Locale("ko"),
- ],
+ localizationsDelegates: AppLocalizations.localizationsDelegates,
+ supportedLocales: AppLocalizations.supportedLocales,
```

- placeholder `{}` + description

```
//! intl_en.arb
{
    "signUpTitle": "Sign up for {nameOfTheApp}",
    "@signUpTitle": {
        "description":"The title people see when they open the app for the first time.",
        "placeholders": {
            "nameOfTheApp": {
                "type":"String",
                "example":"TikTok"
            }
        }
    }
}
```

```dart
//! sign_up_screen.dart
Text(
  AppLocalizations.of(context)!.signUpTitle("TikTok"),
```

## 16.4. Flutter Intl

- rollback

```
rm l10n.yaml
```

- install flutter intl extension and..

```yaml
#! pubspec.yaml
flutter_intl:
  enabled: true
```

save -> lib/{generated, l10n} is created.

```
cat lib/intl/intl_en.arb > lib/l10n/intl_en.arb
```

- create arb file by extension

  > Command palette > Flutter Intl: Add locale

```
cat lib/intl/intl_ko.arb > lib/l10n/intl_ko.arb
rm -r lib/intl
```

- Use l10n with `S`

```diff
#! main.dart
+ import 'package:tiktok_clone/generated/l10n.dart';
return MaterialApp(
  ..
- localizationsDelegates: AppLocalizations.localizationsDelegates,
- supportedLocales: AppLocalizations.supportedLocales,
+ localizationsDelegates: const [
+   S.delegate,
+   GlobalWidgetsLocalizations.delegate,
+   GlobalCupertinoLocalizations.delegate,
+   GlobalMaterialLocalizations.delegate,
+ ],
+ supportedLocales: const [
+   Locale('en'),
+   Locale('ko'),
+ ],
```

- on String, code action => Extract ARB

```dart
//! sign_up_screen.dart
S.of(context).signUpTitle("TikTok"),
```

## 16.5. Pluralize and Select

- change language

```dart
//! main.dart
Widget build(BuildContext context) {
  S.load(const Locale("en"));
```

- plural

```
# intl_en.arb
"signUpSubtitle": "Create a profile, follow other accounts, make your own {videoCount, plural, =0{no videos} =1{video} other{videos}}, and more.",
```

```dart
//! sign_up_screen.dart
S.of(context).signUpSubtitle(11),
```

- select

```
# intl_en.arb
"logIn": "Log in {gender, select, male{sir} female{madam} other{human}}."
```

```dart
//! sign_up_screen.dart
S.of(context).logIn("female"),
```

## 16.6. Numbers l10n

- numbers

```json
//! intl_en.arb
"likeCount": "{potato}",
"@likeCount": {
  "description": "Anything you want",
  "placeholders": {
    "potato": {
      "type": "int",
      "format": "compact"
    }
  }
},

"commentTitle": "{value} {value2, plural, =1{comment} other{comments}}", // numbers + plural
```

## 16.7. Date l10n

- [DateFormat](https://api.flutter.dev/flutter/intl/DateFormat-class.html)

```json
//! lib/l10n/intl_en.arb
  "signUpTitle": "Sign up for {nameOfTheApp} {when}",
  "@signUpTitle": {
    "description": "The title people see when they open the app for the first time.",
    "placeholders": {
      "nameOfTheApp": {
        ..
      },
      "when": {
        "type":"DateTime",
        "format": "💖 LLLL 😱 Hm",
        "isCustomDateFormat":"true"
```

# 17. NAVIGATOR DEEP DIVE

## 17.1. await push()

- Usage: send to a page and comeback with result
- async push and await for result

```dart
void _onLoginTap(BuildContext context) async {
  final result = await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
  print(result);
}
```

- pop(go back) with result

```dart
void _onSignUpTap(BuildContext context) {
  Navigator.of(context).pop("Hello!");
}
```

## 17.2. PageRouteBuilder

: build custom animation

- transitionDuration
- FadeTransition
- ScaleTransition
  - alignment
- SlideTransition
  - offsetAnimation
  - opacityAnimation

```dart
void _onEmailTap(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(seconds: 1),
      reverseTransitionDuration: const Duration(seconds: 1),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const UsernameScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        final opacityAnimation = Tween(
          begin: 0.5,
          end: 1.0,
        ).animate(animation);
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: child,
          ),
        );
      },
    ),
  );
}
```

## 17.3. pushNamed

- define static routeName inside each widgets

```dart
//! main.dart
initialRoute: SignUpScreen.routeName,
routes: {
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  UsernameScreen.routeName: (context) => const UsernameScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
},
```

- push by route

```dart
//! sign_up_screen.dart
void _onEmailTap(BuildContext context) {
  Navigator.of(context).pushNamed(UsernameScreen.routeName);
}
```

## 17.4. pushNamed Args

1. legacy `MaterialPageRoute` version

- context as a 1st arg is possible instead of `Navigator.of(context).push..`

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const EmailScreen(username: _username),
  ),
);
```

2. `pushName` version

- define type EmailScreenParams

```dart
class EmailScreenArgs {
  final String username;

  EmailScreenArgs({required this.username});
}
```

- send arguments

```dart
//! username_screen.dart
Navigator.pushNamed(
  context,
  EmailScreen.routeName,
  arguments: EmailScreenArgs(username: _username),
);
```

- get args + type casting

```dart
//! email_screen.dart
final args = ModalRoute.of(context)!.settings.arguments as EmailScreenArgs;
..
Text(
  "What is your email, ${args.username}?",
```

# 18. NAVIGATOR 2

## 18.1. GoRouter

- pushName (named router) is good for flutter web, but it does not support re-forward
- => use GoRouter

```yaml
dependencies:
  ..
  go_router: 6.0.2
```

```dart
//! touch lib/router.dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: UsernameScreen.routeName,
      builder: (context, state) => const UsernameScreen(),
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) => const EmailScreen(),
    )
  ],
);
```

```dart
//! main.dart
return MaterialApp.router(
  routerConfig: router,
```

### context.push VS context.go:

1. push: stack
2. go:

- remove stack and it becomes root
- it does not have backward

```dart
//! sign_up_screen.dart
void _onLoginTap(BuildContext context) async {
  context.go(LoginScreen.routeName);
}
```

```dart
//! login_screen.dart
void _onSignUpTap(BuildContext context) {
  context.pop(); // what about pop result?
}
```

## 18.2. Parameters

```dart
//! lib/router.dart
GoRoute(
  path: "/users/:username",
  builder: (context, state) {
    final username = state.params['username'];

    return UserProfileScreen(username: username!);
  },
)
```

```dart
//! main_navigation_screen.dart
Offstage(
  offstage: _selectedIndex != 4,
  child: const UserProfileScreen(username: "henry"),
)
```

## 18.3. queryParams

- send query params by `endpoint/?query=value`

```dart
//! lib/router.dart
GoRoute(
  path: "/users/:username",
  builder: (context, state) {
    final username = state.params['username'];
    final tab = state.queryParams["show"];

    return UserProfileScreen(username: username!, tab: tab!);
  },
)
```

- go to `http://localhost:60553/#/users/henry?show=likes`

- extra param: like post, hide body

```dart
//! lib/router.dart
GoRoute(
  path: EmailScreen.routeName,
  builder: (context, state) {
    final args = state.extra as EmailScreenArgs;
    return EmailScreen(username: args.username);
  },
),
```

```dart
//! username_screen.dart
void _onNextTap() {
  if (_username.isEmpty) return;
  context.push(
    EmailScreen.routeName,
    extra: EmailScreenArgs(username: _username),
  );
}
```

## 18.4. CustomTransitionPage

- builder -> pageBuilder
  - fade
  - scale

```dart
//! lib/router.dart
GoRoute(
  name: "username_screen",
  path: UsernameScreen.routeName,
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: const UsernameScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  },
),
```

- namedRoute

  - assign nickname to route

  ```dart
  //! email_screen.dart
  class EmailScreen extends StatefulWidget {
    static String routeName = "email";
    static String routeURL = "email";
  ```

  - set name fild

  ```dart
  //! lib/router.dart
  GoRoute(
    name: EmailScreen.routeName,
    path: EmailScreen.routeURL,
  ```

  - use pushNamed(routeName) or goNamed(routeName) instead of routeURL

  ```dart
  //! email_screen.dart
  void _onEmailTap(BuildContext context) {
    context.pushNamed(UsernameScreen.routeName);
  }
  ```

- nestedRoute
  - `/`(signUp)
  - `/username`
  - `/username/email/`

```dart
GoRoute(
  name: SignUpScreen.routeName,
  path: SignUpScreen.routeURL,
  builder: (context, state) => const SignUpScreen(),
  routes: [
    GoRoute(
      path: UsernameScreen.routeURL,
      name: UsernameScreen.routeName,
      builder: (context, state) => const UsernameScreen(),
      routes: [
        GoRoute(
          name: EmailScreen.routeName,
          path: EmailScreen.routeURL,
          builder: (context, state) {
            final args = state.extra as EmailScreenArgs;

            return EmailScreen(username: args.username);
          },
        ),
      ],
    ),
  ],
),
```

# 19. VIDEO RECORDING

### Miscellaneous

- GoRouter only with /

```dart
final router = GoRouter(
  routes: [
    GoRoute(
        path: "/", builder: (context, state) => const VideoRecordingScreen())
  ],
);
```

## 19.1. Installation

- install camera & permission_handler

```yaml
#! pubspec.yaml
dependencies:
  ..
  camera: ^0.10.3

  permission_handler: ^10.2.0
```

### Android setup

```json
//! android/app/build.gradle

android {
  defaultConfig {
    ..
    minSdkVersion 21
  }
}
```

```
brew install --cask android-studio
```

- launch android studio app and install latest SDK
- Preferences > Appearance & behavior > System Settings > Android SDK > SDK Tools > Android SDK Command-line Tools (latest) check and apply

```
flutter doctor --android-licenses
flutter doctor
```

## 19.2. CameraController

- initPermissions

```dart
//! video_recording_screen.dart
Future<void> initPermissions() async {
  final cameraPermission = await Permission.camera.request();
  final micPermission = await Permission.microphone.request();

  final cameraDenied =
      cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

  final micDenied =
      micPermission.isDenied || micPermission.isPermanentlyDenied;

  if (!cameraDenied && !micDenied) {
    _hasPermission = true;
    await initCamera();
    setState(() {});
  }
}
```

- initCamera

```dart
Future<void> initCamera() async {
  final cameras = await availableCameras();

  if (cameras.isEmpty) {
    return;
  }

  _cameraController = CameraController(
    cameras[0],
    ResolutionPreset.ultraHigh,
  );

  await _cameraController.initialize();
}
```

- camera to center

### Challenge: show denied permissions

## 19.3. Selfie Mode

- available camera[1]

```dart
//! lib/features/videos/video_recording_screen.dart
_cameraController = CameraController(
  cameras[_isSelfieMode ? 1 : 0],
  ResolutionPreset.ultraHigh,
);
```

- initialize camera again

```dart
//! lib/features/videos/video_recording_screen.dart
Future<void> _toggleSelfieMode() async {
  _isSelfieMode = !_isSelfieMode;
  await initCamera();
  setState(() {});
}
```

## 19.4. Flash Mode

- flash mode can be tested on physical phone only

## 19.5. Recording Animation

- Two ticker provider + controller

```dart
//! lib/features/videos/video_recording_screen.dart
late final AnimationController _buttonAnimationController =
    AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 200),
);

late final AnimationController _progressAnimationController =
    AnimationController(
  vsync: this,
  duration: const Duration(seconds: 10),
  lowerBound: 0.0,
  upperBound: 1.0,
);
```

- addStatusListener: OnAnimationFinished

```dart
//! lib/features/videos/video_recording_screen.dart
void initState() {
  super.initState();
  initPermissions();
  _progressAnimationController.addListener(() {
    setState(() {});
  });
  _progressAnimationController.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      _stopRecording();
    }
  });
}
```

### Challenge: reusable flashMode widget

## 19.6. startVideoRecording

- prepareForVideoRecording for ios
- stop recording returns file

```dart
//! video_recording_screen.dart
final video = await _cameraController.stopVideoRecording();
```

- VideoPreviewScreen
- MediaRecorder is not working on emulator
  workaround
  ```dart
  //! video_recording_screen.dart
  Future<void> initCamera() async {
    ..
    enableAudio: false
  ```
- Navigator.push with async get's error???

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VideoPreviewScreen(
      video: video,
    ),
  ),
);
```

```
Don't use 'BuildContext's across async gaps.
Try rewriting the code to not reference the 'BuildContext'.
```

- solution: if !mounted return

## 19.7. GallerySaver

```yaml
#! pubspec.yaml
gallery_saver: 2.3.2
```

- set gallery permission

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.tiktok_clone">
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

- for dynamic asking, call `request()`

- save

```dart
//! lib/features/videos/video_preview_screen.dart
Future<void> _saveToGallery() async {
  if (_savedVideo) return;

  await GallerySaver.saveVideo(
    widget.video.path,
    albumName: "TikTok Clone!",
  );

  _savedVideo = true;

  setState(() {});
}
```

## 19.8. ImagePicker

```yaml
#! pubspec.yaml
image_picker: 0.8.6+1
```

- add state `isPicked` on `VideoPreviewScreen` to distinguish `first recorded` vs `picked video`

## 19.9. AppLifecycleState

- should control lifecycle manually => override `didChangeApplifecycleState` + with `WidgetsBindingObserver`
- inactive: dispose, resumed: initCamera

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (!_hasPermission) return;
  if (!_cameraController.value.isInitialized) return;
  if (state == AppLifecycleState.inactive) {
    _cameraController.dispose();
  } else if (state == AppLifecycleState.resumed) {
    initCamera();
  }
}
```

- permission Asking => also inactive => handle early return in `didChangeAppLifecycleState`

- setState inside `initCamera` => `didChangeAppLifecycleState` don't need return Future

## 19.10. Code Challenge

### Challenge: zoom in on dragUp & zoom out on dragDown

- hint

```dart
onVerticalDragUpdate:
or
onPanUpdate: (DragUpdateDetails details) => {}
```

- initCamera
- getMaxZoomLevel()
- setZoomLevel()
- camerawesome 1.2.1 is recomanded on production

# 20. STATE MANAGEMENT

## 20.1. \_noCamera

- handle noCamera
  > if noCamera just set `_hasPermission = true;`?
- add IOS privilege
  > already has?
- dispose videoController

## 20.2. Router part One

- use goRouter => change url
- not use goRouter => not change url
- common/widget/
- pushNamed: which is different with `push`?
- pushReplacedmentNamed: no way to go back, substitute for `pushAndRemoveUntil`
- move files to common

```sh
mkdir -p lib/common/widgets/main_navigation/widgets
mv lib/features/main_navigation/main_navigation_screen.dart lib/common/widgets/main_navigation/main_navigation_screen.dart
mv lib/features/main_navigation/widgets/nav_tab.dart lib/common/widgets/main_navigation/widgets/nav_tab.dart
mv lib/features/main_navigation/widgets/post_video_button.dart lib/common/widgets/main_navigation/widgets/post_video_button.dart
```

## 20.3. Router part Two

- push: stack history
- go: replace
- it works on web as well
- enum-like path

```dart
//! lib/router.dart
GoRoute(
  path: "/:tab(home|discover|inbox|profile)",
  name: MainNavigationScreen.routeName,
  builder: (context, state) {
    final tab = state.params["tab"]!;
    return MainNavigationScreen(tab: tab);
  },
)
```

## 20.4. Router part Three

```dart
//! lib/router.dart
GoRoute(
  name: ChatsScreen.routeName,
  path: ChatsScreen.routeURL,
  builder: (context, state) => const ChatsScreen(),
  routes: [
    GoRoute(
      name: ChatDetailScreen.routeName,
      path: ChatDetailScreen.routeURL,
      builder: (context, state) {
        final chatId = state.params["chatId"]!;
        return ChatDetailScreen(
          chatId: chatId,
        );
      },
    )
  ],
),
```

## 20.5. Router part Four

- solve camera dispose issue
- custom transition from bottom to top

```dart
//! lib/router.dart
pageBuilder: (context, state) => CustomTransitionPage(
  transitionDuration: const Duration(milliseconds: 200),
  child: const VideoRecordingScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    final position = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(animation);
    return SlideTransition(
      position: position,
      child: child,
    );
  },
),
```

## 20.6. InheritedWidget

- like primary color
  - so many dependencies
- video config
- extends InheritedWidget
- get child
- update should notify

## 20.7. InheritedWidget part Two

- Theme.of and MediaQuery.of are also InheritedWidget
- Combine InheritedWidget and StatefulWidget

```dart
//! lib/common/widgets/video_config/video_config.dart
import 'package:flutter/widgets.dart';

class VideoConfigData extends InheritedWidget {
  final bool autoMute;

  final void Function() toggleMuted;

  const VideoConfigData({
    super.key,
    required this.toggleMuted,
    required this.autoMute,
    required super.child,
  });

  static VideoConfigData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class VideoConfig extends StatefulWidget {
  final Widget child;

  const VideoConfig({
    super.key,
    required this.child,
  });

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = false;

  void toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      toggleMuted: toggleMuted,
      autoMute: autoMute,
      child: widget.child,
    );
  }
}
```

## 20.9. ChangeNotifier

- Encapsulate InheritedWidget + StatefulWidget
- expose method
- notifyListeners
- To use, wrap with AnimatedBuilder or set videoConfig.addListener
- it rebuild only AnimatedBuilder part => performance efficiency

```dart
//! lib/common/widgets/video_config/video_config.dart
import 'package:flutter/widgets.dart';

class VideoConfig extends ChangeNotifier {
  bool autoMute = false;

  void toggleAutoMute() {
    autoMute = !autoMute;
    notifyListeners();
  }
}

final videoConfig = VideoConfig();
```

## 20.10. ValueNotifier

- if just one value? use ValueNotifier
- ValueListenableBuilder

```dart
//! lib/common/widgets/video_config/video_config.dart
import 'package:flutter/widgets.dart';

final videoConfig = ValueNotifier(false);
```

```dart
//! lib/features/videos/widgets/video_post.dart
bool _autoMute = videoConfig.value;

@override
  void initState() {
    ..

    videoConfig.addListener(() {
      setState(() {
        _autoMute = videoConfig.value;
      });
    });
  }
```

## 20.11. Provider

- Provider is a wrapper around `InheritedWidget`
- install

```dart
dependencies:
  provider: 6.0.5
```

- wrap main with `ChangeNotifierProvider`
- value: context.watch<VideoConfig> => get?
- onChanged: context.read<VideoConfig> => set?

# 21. MVVM WITH PROVIDER

## 21.0. Introduction

### MVVM architecture

- separation of concern

## 21.2. VideoPlaybackConfigRepository

- move files to views

```
mkdir -p lib/features/videos/views
mv lib/features/videos/video_preview_screen.dart lib/features/videos/views/video_preview_screen.dart
mv lib/features/videos/video_recording_screen.dart lib/features/videos/views/video_recording_screen.dart
mv lib/features/videos/video_timeline_screen.dart lib/features/videos/views/video_timeline_screen.dart
mv lib/features/videos/widgets/video_button.dart lib/features/videos/views/widgets/video_button.dart
mv lib/features/videos/widgets/video_comments.dart lib/features/videos/views/widgets/video_comments.dart
mv lib/features/videos/widgets/video_post.dart lib/features/videos/views/widgets/video_post.dart
mv lib/features/videos/widgets/video_flash_button.dart lib/features/videos/views/widgets/video_flash_button.dart
```

- create PlaybacConfigModel

```
mkdir -p lib/features/videos/models/
touch lib/features/videos/models/playback_config_model.dart
```

- create PlaybackConfigViewModel extending ChangeNotifier

```
mkdir -p lib/features/videos/view_models/
touch lib/features/videos/view_models/playback_config_vm.dart
```

- install shared_preferences

```sh
flutter pub add shared_preferences
```

- create repos for methods of PlaybacConfigModel

```
mkdir -p lib/features/videos/repos/
touch lib/features/videos/repos/playback_config_repo.dart
```

## 21.3. PlaybackConfigViewModel

- persist on the disk
- modify data
- notifyListeners
- remove provider dependency for now
- should access shared preferences first
- should watch not read

## 21.4. Views

- addListener for `_onPlaybackConfigChanged` => context.read<PlaybackConfigViewModel>().muted;
- `_onVisibilityChanged` => context.read<PlaybackConfigViewModel>().autoplay;

## 21.5. Code Challenge: local mute

- onMute => mute only local state for a single video
- talk to controller
- inital value should come from settings

### caching

- If API takes longer, it would be better to cache to local state

```dart
//! playback_config_vm.dart
bool get muted => _model.muted;
// bool get muted => _repository.isMuted();

bool get autoplay => _model.autoplay;
// bool get autoplay => _repository.isAutoplay();
```

# 22. RIVERPOD

## 22.0. Introduction

- anagram of Provider
- but breacking change
- fixed listening from multiple provider?

```yaml
#! pubspec.yaml
flutter_riverpod: ^2.1.3
```

## 22.1. NotifierProvider

- to separate business logic from view
- replace context::{read, watch} with false just for now
- replace ChangeNotifier -> Notifier
- to mutate state: re-create Model

```dart
void setMuted(bool value) {
  _repository.setMuted(value);
  state = PlaybackConfigModel(
    muted: value,
    autoplay: state.autoplay,
  );
}
```

- to await and access to shared-preferences, unimplementedError first and overide
  - is it defined at global level?
  - ViewModel with Unimplemented -> shared preferences loded -> override ViewModel with Repository(preferences)

```dart
//! playback_config_vm.dart
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
```

- Replace MultiProvdier -> ProviderScope

```dart
//! main.dart
runApp(
  ProviderScope(
    overrides: [
      playbackConfigProvider
          .overrideWith(() => PlaybackConfigViewModel(repository))
    ],
    child: const TikTokApp(),
  ),
);
```

## 22.2. ConsumerWidget

- should move the setState logics at `lib/features/settings/settings_screen.dart` (remove for now)
- ConsumerWidget
  - widgetRef::{watch, read}
- NotifierProviderImpl.notifier: listen state chagnes
- install extension: Flutter Riverpod Snippets

```
usage:
stl => stlessConsumer
```

## 22.3. Recap

- In ConsumerStatefulWidget, we can access to ref anywhere like context of StatefulWidget

## 22.4. AsyncNotifierProvider

- Async for API
  - FutureOr
  - AsyncValue.loading
  - AsyncValue.data

```
touch lib/features/videos/models/video_model.dart
touch lib/features/videos/view_models/timeline_view_model.dart
```

```dart
//! lib/features/videos/view_models/timeline_view_model.dart
class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];

  Future<void> uploadVideo() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 2));
    final newVideo = VideoModel(title: "${DateTime.now()}");
    _list = [..._list, newVideo];
    state = AsyncValue.data(_list);
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 5));
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
```

- ref.watch.when
  - loading, error, data

```dart
//! lib/features/videos/views/video_timeline_screen.dart
Widget build(BuildContext context) {
  return ref.watch(timelineProvider).when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Could not load videos: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (videos) => RefreshIndicator(
          ..
        ),
      );
}
```

## 22.5. Conclusions

- refactor later: ViewModel should be separated with each screen

# 23. FIREBASE SETUP

## 23.0. Introduction

- Good for prototype
- champagne problem => should find out custom solution with delight

## 23.1. Installation

- [install firebase](https://firebase.google.com/docs/flutter/setup?platform=ios)

```sh
curl -sL https://firebase.tools | bash # looks like find with brew install firebase-cli
```

- create project with unique name on web console
- [install flutterfire and configure](https://firebase.google.com/docs/flutter/setup?platform=ios)

```sh
firebase login
dart pub global activate flutterfire_cli
flutterfire configure # put project name
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add firebase_storage
flutterfire configure
```

- init firebase on main

```dart
void main() async {
  ..
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
```

## 23.2. AuthenticationRepository

- create AuthenticationRepository
  - getter looks like property

```dart
// mkdir -p lib/features/authentication/repos/
// touch lib/features/authentication/repos/authentication_repo.dart
class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;
}

final authRepo = Provider((ref) => AuthenticationRepository());
```

- replace StatefulWidget to ComsumerStatefulWidget at `main.dart`
- wrap GoRouter with Provider and expose routerProvider

```dart
//! lib/router.dart
final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/home",
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.subloc != SignUpScreen.routeURL &&
            state.subloc != LoginScreen.routeURL) {
          return SignUpScreen.routeURL;
        }
      }
      return null;
    },
```

# 24. FIREBASE AUTHENTICATION

## 24.0. createUserWithEmailAndPassword

- it supports social providers like github, but we will use email/password

```
mkdir -p lib/features/authentication/view_models/
touch lib/features/authentication/view_models/signup_view_model.dart
```

- replace {emailScreen, BirthdayScreen, PasswordScreen} to ConsumerStatefulWidget
- impl signUp to {SignUpViewModel, AuthenticationRepository}
- guard catches any error

```dart
//! signup_view_model.dart
Future<void> signUp() async {
  state = const AsyncValue.loading();
  final form = ref.read(signUpForm);
  state = await AsyncValue.guard(
    () async => await _authRepo.signUp(
      form["email"],
      form["password"],
    ),
  );
}
```

```dart
//! guard
static Future<AsyncValue<T>> guard<T>(Future<T> Function() future) async {
  try {
    return AsyncValue.data(await future());
  } catch (err, stack) {
    return AsyncValue.error(err, stack);
  }
}
```

## 24.1. signOut

- Stream: connection between client and server
- expose with StreamProvider
- AuthenticationRepository: break rule cuz it is so small. Access directly to repository without viewModel

## 24.2. signInWithEmailAndPassword

- SnackBar: display message at the bottom (needs context)

```dart
//! utils.dart
void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? "Something wen't wrong.",
      ),
    ),
  );
}
```

## 24.3. Social Auth Config

### Connect github and Firebase

- https://github.com/settings/applications/new
- https://console.firebase.google.com/u/0/project/tiktok-devgony/authentication/providers
  - github > set ClientID and Client secret

### Install

- https://firebase.google.com/docs/auth/flutter/federated-auth

#### IOS

- `open ~/Dart/tiktok_clone/ios/Runner.xcworkspace` (with xcode)
  - Runner > Info > URL Types
    1. first way
    - name: `REVERSED_CLIENT_ID`
    - value: copy from `Runner > GoogleService-info`
    2. second way
    - name: ``
    - value: copy from `firebase console > Project settings > General > ios > Encoded App ID`
      - https://console.firebase.google.com/u/0/project/tiktok-devgony/settings/general/ios:com.example.<projectName>

#### Android

- startup Android debug mode at least once

```
cd android
./gradlew signinReport
```

- copy SHA1 signature (only for debugging)
  - https://console.firebase.google.com/u/0/project/tiktok-devgony/settings/general/android:com.example.<projectName>

## 24.4 Github Login

- impl SocialAuthViewModel and githubSignIn

```
touch lib/features/authentication/view_models/social_auth_view_model.dart
```

- extract common method `githubSignIn` at `utils.dart`
  - but flutter web gets error?

```dart
Future<void> githubSignIn(BuildContext context, WidgetRef ref) async {
  await ref.read(socialAuthProvider.notifier).githubSignIn(context);
}
```

# 25. USER PROFILE

## 25.0. Introduction

- create firestore
  - console > Cloud Firestore > Create database > Start in test mode > Cloud Firestore location: Seoul > Enable
- enable storage
  - build > storage > Get started > Start in test mode > sample location with firestore

## 25.1. FireStore Intro

- Start collection: users > Document ID: Auto-ID > Field: {bio: string, link: string, name: string}
  - Start collection: likes > Document ID: Auto-ID > Field: {video: ref(`/videos/abc`)}

## 25.2. UserProfileModel

- create profile
- get profile

```
mkdir -p lib/features/users/models/
touch lib/features/users/models/user_profile_model.dart
mkdir -p lib/features/users/repos/
touch lib/features/users/repos/user_repo.dart
mkdir -p lib/features/users/view_models/
touch lib/features/users/view_models/users_view_model.dart
```

```
mkdir -p lib/features/authentication/views
mv lib/features/authentication/*.dart lib/features/authentication/views
mv lib/features/authentication/widgets lib/features/authentication/views

mkdir -p lib/features/users/views
mv lib/features/users/user_profile_screen.dart lib/features/users/views
mv lib/features/users/widgets lib/features/users/views
```

### Included in upcoming lecture

- update avatar

### Challenge at the end of lecture

- update bio
- update link

## 25.3. createProfile

- if privilege error > firestore console > Rules > Edit rules > `allow read, write // remove if condition`

## 25.4. findProfile

- impl fromJson at `lib/features/users/models/user_profile_model.dart`
- impl findProfile at `lib/features/users/repos/user_repo.dart`
- add findProfile logic at `lib/features/users/view_models/users_view_model.dart`

## Challenge: save username and birthday on createProfile

- add `name` to state on Submit at `email_screen`
- add `birthday` to state onNextTap at `birthday_screen`
- createProfile takes name andn birthday at `users_view_model`

## 25.5. AvatarViewModel

- impl uploadAvatar at `lib/features/users/repos/user_repo.dart`
- separate avatarViewModel

```
touch lib/features/users/view_models/avatar_view_model.dart
touch lib/features/users/views/widgets/avatar.dart
```

- replace widget.username to data.name at `user_profile_screen`

## 25.6. onAvatarUpload

- add hasAvatar at `lib/features/users/models/user_profile_model.dart`
- impl updateUser at `user_repo`
- impl onAvatarUpload at `users_view_model`
- call onAvatarUpload after upload at `avatar_view_model`
- get image from firebase storage at `lib/features/users/views/widgets/avatar.dart`

## 25.7. Code Challenge

### fix: remove image caching

- how not to cache image by workaround: put DateTime at the end of url

### Challenge: edit bio and link

- [x] implement UserProfileEditScreen
- [x] implement updateProfile at users_view_model

![profile](/md_images/2023-06-24-21-02-23.png)
![edit-profile](/md_images/2023-06-24-21-03-30.png)
![edited-profile](/md_images/2023-06-24-21-04-26.png)

# 26. VIDEO UPLOAD

## 26.0. Introduction

- upload video => firebase function keeps listening and set only thumbnail

### purchase

- Get Started => Continue => set $1

## 26.1. VideosRepository

- challenge: form on preview video

### VideoModel

- add more fields at `lib/features/videos/models/video_model.dart`
- impl videos_repo, upload_video_view_model

```
touch lib/features/videos/repos/videos_repo.dart
touch lib/features/videos/view_models/upload_video_view_model.dart
```

## 26.2. uploadVideoProvider

- impl Serde at viddoe_model.dart
- impl saveVideo at videos_repo.dart
- if uploadVideoFile completed, saveVideo in db at upload_video_view_model.dart

## 26.3 Cloud Functions

- install cloud function
  - prerequisite: latest nodeJs

```
flutter pub add cloud_functions
flutterfire configure
  all platforms
  override? => yes
firebase init functions
  Use an existing project
  Typescript
  ESLint? => n
  dependencies with npm => Y
```

- impl listening
  - snapshot: video which just created

```ts
// functions/src/index.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    await snapshot.ref.update({ hello: "from functions" });
  });
```

- deploy

```
firebase deploy --only functions
```

- fix ios/cocodpod error

```
cd ios
rm Podfile.lock
pod install --repo-update
cd ../
flutter clean
flutter run
```

- try to upload video > cloud function update {hello: "from functions"}

## 26.4. ffmpeg

- extract thumbnail
- system packages included in cloud function

  - ffmpeg: handle video and audio
  - spawn subprocess

  ```
  cd functions
  npm i child-process-promise
  ```

- it can access to temporary file storage

```ts
export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss",
      "00:00:00.001",
      "-vframes",
      "1",
      "-vf",
      "scale=150:-1",
      `/tmp/${snapshot.id}.jpg`,
    ]);
    const storage = admin.storage();
    await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
  });
```

```
firebase deploy --only functions
```

## ffmpeg does not work

- to extract thumbnail with more than node 18, should try [sharp](https://firebase.google.com/docs/functions/gcp-storage-events?gen%253D2nd) way
- to keep using ffmpeg, downgrade node 18 to 16

```json
"engines": {
  "node": "16"
},
```

- `rm -rf node_modules/ package-lock.json` and re-deploy made it works!
- thumbnail should be early enough like `00:00:00.001`
  - how to handle error from client side? => listener with `StreamProvider`?

## 26.5. publicUrl

- save it to video
- show their post on profile
  - need only video id

## 26.6. Conclusions

- replace ` push to home` to `pop() + pop()`
  - context.pop() 1: back to camera screen
  - context.pop() 2: back to main tab nav

```diff
- context.pushReplacement("/home");
+ context.pop();
+ context.pop();
```

- use Cloud function > View logs > Stream logs

## Challenge: implement TextForm for title and description of video

![text-form-title-and-description](<md_images/Simulator Screen Shot - iPhone 13 - 2023-07-09 at 15.52.42.png>)

## 27. VIDEO TIMELINE

## 27.1. VideoPost

- impl fromJson in lib/features/videos/models/video_model.dart
- impl fetchVideos in lib/features/videos/repos/videos_repo.dart
- call fetchVideos at build in lib/features/videos/view_models/timeline_view_model.dart
- render VideoPost with real data in lib/features/videos/views/video_timeline_screen.dart

### In lib/features/videos/views/widgets/video_post.dart

- replace VideoPlayerController.asset("../local.mp4") to network(widget.videoData.fileUrl);
- BoxFit.cover => strech to fill background

## 27.2. Infinite Firebase

- impl fetchNextPage in `lib/features/videos/view_models/timeline_view_model.dart`
- startAfter: order by + startAfter n-th (exclusive) in `lib/features/videos/repos/videos_repo.dart`

### lib/features/videos/views/video_timeline_screen.dart

- Quick fix > convert to block body
- itemCount => request next page

## 27.3. FamilyAsyncNotifier

- impl refresh in `lib/features/videos/view_models/timeline_view_model.dart`
- add `id` in `lib/features/videos/models/video_model.dart`
- provider with args => `FamilyAsyncNotifier`

  - args on build method

  ```dart
  // touch lib/features/videos/view_models/video_post_view_models.dart
  class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
    late final VideosRepository _repository;
    late final String _videoId;

    @override
    FutureOr<void> build(String arg) {
      _videoId = arg;
      _repository = ref.read(videosRepo);
    }

    Future<void> likeVideo() async {
      final user = ref.read(authRepo).user;
      await _repository.likeVideo(_videoId, user!.uid);
    }
  }

  final videoPostProvider =
      AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
    () => VideoPostViewModel(),
  );
  ```

## 27.4. likeVideo

- should check if already checked
- create ownId and access by it for higher performance and saving money
  - use path to access: If no [path] is provided, an auto-generated ID is used.

```dart
Future<void> likeVideo(String videoId, String userId) async {
  final query = _db.collection("likes").doc("${videoId}000$userId");
  final like = await query.get();

  if (!like.exists) {
    await query.set(
      {
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

- another way: keep likes in user

## 27.5. dislikeVideo

- likeVideo handles `dislike case` in `lib/features/videos/repos/videos_repo.dart`
- impl onLikedCreated, onLikedRemoved in `functions/src/index.ts`
- looks like there is bug: `like` first video and fetchNextPage => `like`second video sets `-1`
- Challenge: onLikedCreated => put liked video in profile by cloud function

## 28.6. Challenge: color heart with red when liked video

- hint: video_post_view_models.dart
- consider: can't we watch likes as well? not by local state but by prodiver

![challenge-28.6](<md_images/Simulator Screen Shot - iPhone 13 - 2023-07-13 at 00.09.02.png>)

# 28 DIRECT MESSAGES

## 28.1. Send Message

- create collection

```
/chat_rooms
  autoID
  personA string uid
  personB string xxx
```

- impl MVVM for messages

```
mkdir -p lib/features/inbox/models/
touch lib/features/inbox/models/message.dart
mkdir -p lib/features/inbox/repos/
touch lib/features/inbox/repos/messages_repo.dart
mkdir -p lib/features/inbox/view_models/
touch lib/features/inbox/view_models/messages_view_model.dart

mkdir -p lib/features/inbox/views/
mv lib/features/inbox/*.dart lib/features/inbox/views/
lib/features/inbox/views/activity_screen.dart
```

## 28.2. StreamProvider

- add createdAt
- orderBy().snapshots(): return stream

## 28.3 autoDispose

### lib/features/inbox/view_models/messages_view_model.dart

- StreamProvider.autoDispose
  - release resource
  - when user exits chat => dispose

### lib/features/inbox/views/chat_detail_screen.dart

- watch().when()
- fake data to real data

  - length
  - text
  - isMine

- reverse ui
- reverse order
- MediaQuery for cross-platform

# 29. PUSH NOTIFICATIONS

## 29.0. Introduction

```
flutter pub add firebase_messaging
flutterfire configure
```

## 29.1. getToken

- Use Android simulator otherwise pay for apple developer
- push for specific user > need token

```
mkdir -p lib/features/notifications/
touch lib/features/notifications/notifications_provider.dart
```

- event listen

```dart
// lib/features/notifications/notifications_provider.dart
_messaging.onTokenRefresh.listen((newToken) async {
  await updateToken(newToken);
});
```

- Messaging > Create your first campaign > Firebase Notification messages > Send test message > put token from Firestore
