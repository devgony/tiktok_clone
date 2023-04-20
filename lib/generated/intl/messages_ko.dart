// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko';

  static String m1(nameOfTheApp) => "${nameOfTheApp}에 가입하세요";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("계정이 있으신가요?"),
        "appleButton": MessageLookupByLibrary.simpleMessage("Apple로 계속하기"),
        "emailPasswordButton":
            MessageLookupByLibrary.simpleMessage("이메일 또는 비밀번호로 가입하기"),
        "logIn": MessageLookupByLibrary.simpleMessage("로그인"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "프로필을 생성하고, 다른 계정을 팔로우하고 자신의 비디오를 만들어보세요."),
        "signUpTitle": m1
      };
}
