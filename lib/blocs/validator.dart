import 'dart:async';

class Validator {
  final validateUserName = StreamTransformer<String, String>.fromHandlers(
    handleData: (String userName, EventSink<String> sink) {
      if (userName.isNotEmpty) {
        sink.add(userName);
      } else {
        sink.addError('Please enter username');
      }
    },
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (String password, EventSink<String> sink) {
      if (password.isNotEmpty) {
        sink.add(password);
      } else {
        sink.addError('Please enter password');
      }
    },
  );
}
