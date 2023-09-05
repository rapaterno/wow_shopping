import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

class LoginScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  const LoginScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const LoginScreen._(),
        );
      },
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final _logic;
  @override
  void initState() {
    _logic = di.registerSingleton<LoginLogic>(LoginLogic(di<AuthRepo>()));
    super.initState();
  }

  @override
  void dispose() {
    di.unregister<LoginLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = watchStream<LoginLogic, LoginState>(
            (LoginLogic p0) => p0.streamState,
            initialValue: _logic.currentState)
        .data!;

    return Material(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            onPressed: state.isLoading ? null : _logic.onLoginPressed,
            label: 'Login',
          ),
          verticalMargin16,
          if (state.isLoading) //
            const CircularProgressIndicator(),
          if (state.hasError) //
            Text(state.lastError),
        ],
      )),
    );
  }
}

class LoginLogic {
  LoginLogic(this._authRepo) {
    _stateController = StreamController<LoginState>.broadcast(
      onListen: () => _emitState(_state),
    );
  }

  final AuthRepo _authRepo;
  late StreamController<LoginState> _stateController;
  var _state = LoginState.initial();

  LoginState get currentState => _state;

  Stream<LoginState> get streamState => _stateController.stream;

  void _emitState(LoginState value) {
    _state = value;
    _stateController.add(value);
  }

  Future<void> onLoginPressed() async {
    _emitState(LoginState.loading());
    try {
      await _authRepo.login('username', 'password');
    } catch (error) {
      _emitState(LoginState.error(error));
    }
  }
}

class LoginState {
  LoginState.initial()
      : isLoading = false,
        lastError = '';

  LoginState.loading()
      : isLoading = true,
        lastError = '';

  LoginState.error(dynamic error)
      : isLoading = false,
        lastError = error.toString();

  final bool isLoading;
  final String lastError;

  bool get hasError => lastError.isNotEmpty;
}
