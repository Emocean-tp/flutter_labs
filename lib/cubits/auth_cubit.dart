import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';

class AuthState {
  const AuthState({
    required this.isLoggedIn,
    this.username = 'Aquarium owner',
    this.email = 'No email',
    this.message,
  });

  final bool isLoggedIn;
  final String username;
  final String email;
  final String? message;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(isLoggedIn: false));

  Future<void> checkSession() async {
    final bool isLoggedIn = await StorageService.isLoggedIn();
    final String? username = await StorageService.getUsername();
    final String? email = await StorageService.getEmail();

    emit(
      AuthState(
        isLoggedIn: isLoggedIn,
        username: username ?? 'Aquarium owner',
        email: email ?? 'No email',
      ),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    if (username.isEmpty) {
      emit(AuthState(isLoggedIn: state.isLoggedIn, message: 'Username required'));
      return;
    }

    if (!email.contains('@')) {
      emit(AuthState(isLoggedIn: state.isLoggedIn, message: 'Invalid email'));
      return;
    }

    if (password.length < 6) {
      emit(AuthState(isLoggedIn: state.isLoggedIn, message: 'Password too short'));
      return;
    }

    await StorageService.saveUser(
      username: username,
      email: email,
      password: password,
    );

    emit(
      AuthState(
        isLoggedIn: false,
        username: username,
        email: email,
        message: 'Registration successful',
      ),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final String? savedEmail = await StorageService.getEmail();
    final String? savedPassword = await StorageService.getPassword();

    if (email == savedEmail && password == savedPassword) {
      await StorageService.setLoggedIn(true);
      await checkSession();
      return;
    }

    emit(AuthState(isLoggedIn: false, message: 'Invalid email or password'));
  }

  Future<void> logout() async {
    await StorageService.clearUserSession();

    emit(const AuthState(isLoggedIn: false, message: 'Logged out'));
  }
}
