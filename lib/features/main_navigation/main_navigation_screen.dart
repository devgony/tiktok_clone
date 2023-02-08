import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/features/main_navigation/stf_screen.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/post_video_button.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final screens = [
    StfScreen(key: GlobalKey()),
    StfScreen(key: GlobalKey()),
    Container(),
    StfScreen(key: GlobalKey()),
    StfScreen(key: GlobalKey()),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Record video')),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: "Home",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
                selectedIcon: FontAwesomeIcons.house,
              ),
              NavTab(
                  text: "Discover",
                  isSelected: _selectedIndex == 1,
                  icon: FontAwesomeIcons.magnifyingGlass,
                  onTap: () => _onTap(1),
                  selectedIcon: FontAwesomeIcons.solidCompass),
              Gaps.h24,
              GestureDetector(
                child: PostVideoButton(onTap: _onPostVideoButtonTap),
              ),
              Gaps.h24,
              NavTab(
                  text: "Inbox",
                  isSelected: _selectedIndex == 3,
                  icon: FontAwesomeIcons.message,
                  onTap: () => _onTap(3),
                  selectedIcon: FontAwesomeIcons.solidMessage),
              NavTab(
                  text: "Profile",
                  isSelected: _selectedIndex == 4,
                  icon: FontAwesomeIcons.user,
                  onTap: () => _onTap(4),
                  selectedIcon: FontAwesomeIcons.solidUser),
            ],
          ),
        ),
      ),
    );
  }
}
