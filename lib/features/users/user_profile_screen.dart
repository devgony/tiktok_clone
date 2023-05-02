import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tab_bar.dart';

import '../settings/settings_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen(
      {super.key, required this.username, required this.tab});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: widget.tab == "likes" ? 1 : 0,
          length: 2,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Breakpoints.lg,
              ),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      title: Text(widget.username),
                      actions: [
                        IconButton(
                          onPressed: _onGearPressed,
                          icon: const FaIcon(
                            FontAwesomeIcons.gear,
                            size: Sizes.size20,
                          ),
                        )
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: width < Breakpoints.md
                            ? [
                                const CircleAvatar(
                                  radius: 50,
                                  foregroundImage: NetworkImage(
                                    "https://avatars.githubusercontent.com/u/51254761?v=4",
                                  ),
                                  child: Text("henry"),
                                ),
                                Gaps.v20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "@${widget.username}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Sizes.size18,
                                      ),
                                    ),
                                    Gaps.h5,
                                    FaIcon(
                                      FontAwesomeIcons.solidCircleCheck,
                                      size: Sizes.size16,
                                      color: Colors.blue.shade500,
                                    )
                                  ],
                                ),
                                Gaps.v24,
                                SizedBox(
                                  height: Sizes.size48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            "97",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Sizes.size18,
                                            ),
                                          ),
                                          Gaps.v1,
                                          Text("Following",
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                              ))
                                        ],
                                      ),
                                      VerticalDivider(
                                        width: Sizes.size32,
                                        thickness: Sizes.size1,
                                        color: Colors.grey.shade400,
                                        indent: Sizes.size14,
                                        endIndent: Sizes.size14,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "10M",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Sizes.size18,
                                            ),
                                          ),
                                          Gaps.v1,
                                          Text(
                                            "Followers",
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                            ),
                                          )
                                        ],
                                      ),
                                      VerticalDivider(
                                        width: Sizes.size32,
                                        thickness: Sizes.size1,
                                        color: Colors.grey.shade400,
                                        indent: Sizes.size14,
                                        endIndent: Sizes.size14,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "194.3M",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Sizes.size18,
                                            ),
                                          ),
                                          Gaps.v1,
                                          Text(
                                            "Likes",
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Gaps.v14,
                                SizedBox(
                                  height: Sizes.size40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: FractionallySizedBox(
                                          widthFactor: 0.33,
                                          heightFactor: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(Sizes.size4),
                                              ),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Follow',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gaps.h2,
                                      Container(
                                        height: double.infinity,
                                        width: Sizes.size40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: Sizes.size1,
                                        )),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: FaIcon(
                                            FontAwesomeIcons.youtube,
                                            size: Sizes.size20,
                                          ),
                                        ),
                                      ),
                                      Gaps.h2,
                                      Container(
                                        height: double.infinity,
                                        width: Sizes.size40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: Sizes.size1,
                                        )),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: FaIcon(
                                            FontAwesomeIcons.caretDown,
                                            size: Sizes.size20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gaps.v14,
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.size32,
                                  ),
                                  child: Text(
                                    "All highlights and where to watch live matches on FIFA+ I wonder how it would loook",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Gaps.v14,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    FaIcon(
                                      FontAwesomeIcons.link,
                                      size: Sizes.size12,
                                    ),
                                    Gaps.h4,
                                    Text(
                                      "https://nomadcoders.co",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v20,
                              ]
                            : [
                                Row(
                                  children: [
                                    Gaps.h48,
                                    const CircleAvatar(
                                      radius: 50,
                                      foregroundImage: NetworkImage(
                                        "https://avatars.githubusercontent.com/u/51254761?v=4",
                                      ),
                                      child: Text("henry"),
                                    ),
                                    Gaps.h48,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gaps.v24,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "@${widget.username}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: Sizes.size18,
                                              ),
                                            ),
                                            Gaps.h5,
                                            FaIcon(
                                              FontAwesomeIcons.solidCircleCheck,
                                              size: Sizes.size16,
                                              color: Colors.blue.shade500,
                                            ),
                                            Gaps.h48,
                                            SizedBox(
                                              height: Sizes.size40,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: Sizes.size150,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                            Sizes.size4),
                                                      ),
                                                    ),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Follow',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Gaps.h2,
                                                  Container(
                                                    height: double.infinity,
                                                    width: Sizes.size40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: Sizes.size1,
                                                    )),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .youtube,
                                                        size: Sizes.size20,
                                                      ),
                                                    ),
                                                  ),
                                                  Gaps.h2,
                                                  Container(
                                                    height: double.infinity,
                                                    width: Sizes.size40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: Sizes.size1,
                                                    )),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .caretDown,
                                                        size: Sizes.size20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gaps.v10,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  "97",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Sizes.size18,
                                                  ),
                                                ),
                                                Gaps.v1,
                                                Text("Following",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                    ))
                                              ],
                                            ),
                                            VerticalDivider(
                                              width: Sizes.size32,
                                              thickness: Sizes.size1,
                                              color: Colors.grey.shade400,
                                              indent: Sizes.size14,
                                              endIndent: Sizes.size14,
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  "10M",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Sizes.size18,
                                                  ),
                                                ),
                                                Gaps.v1,
                                                Text(
                                                  "Followers",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                  ),
                                                )
                                              ],
                                            ),
                                            VerticalDivider(
                                              width: Sizes.size32,
                                              thickness: Sizes.size1,
                                              color: Colors.grey.shade400,
                                              indent: Sizes.size14,
                                              endIndent: Sizes.size14,
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  "194.3M",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Sizes.size18,
                                                  ),
                                                ),
                                                Gaps.v1,
                                                Text(
                                                  "Likes",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Gaps.v10,
                                        const Text(
                                          "All highlights and where to watch live matches on FIFA+ I wonder how it would loook",
                                          textAlign: TextAlign.center,
                                        ),
                                        Gaps.v14,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            FaIcon(
                                              FontAwesomeIcons.link,
                                              size: Sizes.size12,
                                            ),
                                            Gaps.h4,
                                            Text(
                                              "https://nomadcoders.co",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Gaps.v24,
                              ],
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: PersistentTabBar(),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    GridView.builder(
                      itemCount: 20,
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: width < Breakpoints.md ? 3 : 5,
                        crossAxisSpacing: Sizes.size2,
                        mainAxisSpacing: Sizes.size2,
                        childAspectRatio: 9 / 14,
                      ),
                      itemBuilder: (context, index) => Column(
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 9 / 14,
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: "assets/images/placeholder.jpg",
                                  image:
                                      "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                                ),
                              ),
                              index == 0
                                  ? Positioned(
                                      top: Sizes.size4,
                                      left: Sizes.size4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Sizes.size4,
                                          vertical: Sizes.size2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(Sizes.size3),
                                          ),
                                        ),
                                        child: const Text("Pinned",
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                      ),
                                    )
                                  : Container(),
                              Positioned(
                                  bottom: Sizes.size4,
                                  left: Sizes.size4,
                                  child: Row(
                                    children: const [
                                      FaIcon(
                                        FontAwesomeIcons.circlePlay,
                                        size: Sizes.size20,
                                        color: Colors.white,
                                      ),
                                      Gaps.h8,
                                      Text(
                                        "4.1M",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Center(
                      child: Text('Page two'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
