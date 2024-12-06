// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addTask": MessageLookupByLibrary.simpleMessage("Add task"),
        "confirmedPassword":
            MessageLookupByLibrary.simpleMessage("Confirmed password"),
        "connexionErrorMessage": MessageLookupByLibrary.simpleMessage(
            "Connection failed. Please check your Wi-Fi settings."),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "deadline": MessageLookupByLibrary.simpleMessage("Deadline"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "elapsedTime": MessageLookupByLibrary.simpleMessage("Elapsed time"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordNotConfirmed":
            MessageLookupByLibrary.simpleMessage("Password doesn\'t match"),
        "passwordTooShort":
            MessageLookupByLibrary.simpleMessage("Password too short"),
        "progress": MessageLookupByLibrary.simpleMessage("Progress"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign out"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
        "signUpErrorMessage": MessageLookupByLibrary.simpleMessage(
            "User not found. Please enter an existing user"),
        "task": MessageLookupByLibrary.simpleMessage("Task"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "usernameAlreadyTaken":
            MessageLookupByLibrary.simpleMessage("Username already taken"),
        "usernameTooShort":
            MessageLookupByLibrary.simpleMessage("Username too short")
      };
}
