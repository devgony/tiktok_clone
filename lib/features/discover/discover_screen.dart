import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/utils.dart';

import '../../constants/breakpoints.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "Today's top");
  bool _writing = true;

  void _onSearchChanged(String value) {
    print("Searching form $value");
    setState(() {
      _writing = value.isNotEmpty;
    });
  }

  void _onSearchSubmitted(String value) {
    print("Submitted $value");
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onTabBarTap(int _) {
    FocusScope.of(context).unfocus();
  }

  void _onXmarkTap() {
    _textEditingController.clear();
    setState(() {
      _writing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = isDarkMode(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            child: TextField(
              controller: _textEditingController,
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
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
                suffixIcon: _writing
                    ? GestureDetector(
                        onTap: _onXmarkTap,
                        child: Icon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          bottom: TabBar(
            onTap: _onTabBarTap,
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: const EdgeInsets.all(
                Sizes.size10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.lg ? 5 : 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 20,
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size4),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpg",
                          image:
                              "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                        ),
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      "${constraints.maxWidth} This is a very long caption for my tiktok that im upload just now currently.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Gaps.v8,
                    // if (constraints.maxWidth < 200 ||
                    // constraints.maxWidth > 250)
                    DefaultTextStyle(
                      style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                              "https://avatars.githubusercontent.com/u/51254761?v=4",
                            ),
                          ),
                          Gaps.h4,
                          const Expanded(
                            child: Text(
                              "My avatar is going to be very long",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gaps.h4,
                          FaIcon(
                            FontAwesomeIcons.heart,
                            size: Sizes.size16,
                            color: Colors.grey.shade600,
                          ),
                          Gaps.h2,
                          const Text(
                            "2.5M",
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
