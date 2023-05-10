import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/users/user_profile_screen.dart';

import 'features/videos/video_recording_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: "/", builder: (context, state) => const VideoRecordingScreen())
  ],
);
