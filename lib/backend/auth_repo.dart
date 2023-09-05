import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/models/user.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class AuthRepo {
  late final File _file;
  late User _currentUser;

  Timer? _saveTimer;
  late StreamController<User> _userController;

  Stream<User> get streamUser => _userController.stream;

  User get currentUser => _currentUser;

  Stream<bool> get streamIsLoggedIn => _userController.stream //
      .map((user) => user != User.none);

  bool get isLoggedIn => _currentUser != User.none;

  // FIXME: this should come from storage
  String get token => '123';

  Future<AuthRepo> init() async {
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      _file = File(path.join(dir.path, 'user.json'));
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
    try {
      if (await _file.exists()) {
        _currentUser = User.fromJson(
          json.decode(await _file.readAsString()),
        );
      } else {
        _currentUser = User.none;
      }

      _userController = StreamController<User>.broadcast(
        onListen: () => _emitUser(_currentUser),
      );

      return this;
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      _file.delete();
      _currentUser = User.none;
      rethrow;
    }
  }

  void _emitUser(User value) {
    _currentUser = value;
    _userController.add(value);
    _saveUser();
  }

  Future<void> login(String username, String password) async {
    try {
      _emitUser(await di<ApiService>().login(username, password));
    } catch (error) {
      // FIXME: show user error, change state? rethrow?
    }
  }

  Future<void> logout() async {
    try {
      await di<ApiService>().logout();
    } catch (error) {
      // FIXME: failed to logout? report to server
    }
    _emitUser(User.none);
  }

  void retrieveUser() {
    // currentUser = apiService.fetchUser();
    // _saveUser();
  }

  void _saveUser() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      if (_currentUser == User.none) {
        await _file.delete();
      } else {
        await _file.writeAsString(json.encode(_currentUser.toJson()));
      }
    });
  }
}
