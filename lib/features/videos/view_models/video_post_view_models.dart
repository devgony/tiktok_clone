import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<bool, String> {
  late final VideosRepository _repository;
  late final String _videoId;
  bool _isLiked = false;

  @override
  FutureOr<bool> build(String arg) async {
    _videoId = arg;
    _repository = ref.read(videosRepo);
    final user = ref.read(authRepo).user;
    _isLiked = await _repository.isLiked(_videoId, user!.uid);

    return _isLiked;
  }

  Future<void> likeVideo() async {
    final user = ref.read(authRepo).user;
    await _repository.likeVideo(_videoId, user!.uid);
    _isLiked = !_isLiked;

    state = AsyncValue.data(_isLiked);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, bool, String>(
  () => VideoPostViewModel(),
);
