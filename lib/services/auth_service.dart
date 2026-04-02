import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

/// Mock authentication service that mirrors Firebase Auth API.
/// Uses SharedPreferences to persist auth state locally.
/// Can be swapped with real Firebase Auth later.
class AuthService {
  static const _uuid = Uuid();

  /// Sign up a new user with email and password.
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if user exists
    final existingUsers = prefs.getString('ecotrack_users') ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(existingUsers));

    if (users.containsKey(email)) {
      throw Exception('An account with this email already exists.');
    }

    // Create new user
    final user = UserModel(
      id: _uuid.v4(),
      name: name,
      email: email,
      totalPoints: 0,
      streakDays: 0,
      joinDate: DateTime.now(),
    );

    // Store user data
    users[email] = {
      'password': password,
      'user': user.toJson(),
    };
    await prefs.setString('ecotrack_users', jsonEncode(users));

    // Set current session
    await prefs.setString('ecotrack_current_user', jsonEncode(user.toJson()));
    await prefs.setBool('ecotrack_is_logged_in', true);

    return user;
  }

  /// Log in with email and password.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final existingUsers = prefs.getString('ecotrack_users') ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(existingUsers));

    if (!users.containsKey(email)) {
      throw Exception('No account found with this email.');
    }

    final userData = users[email] as Map<String, dynamic>;
    if (userData['password'] != password) {
      throw Exception('Incorrect password.');
    }

    final user = UserModel.fromJson(
      Map<String, dynamic>.from(userData['user']),
    );

    // Set current session
    await prefs.setString('ecotrack_current_user', jsonEncode(user.toJson()));
    await prefs.setBool('ecotrack_is_logged_in', true);

    return user;
  }

  /// Get the currently logged-in user.
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('ecotrack_is_logged_in') ?? false;

    if (!isLoggedIn) return null;

    final userData = prefs.getString('ecotrack_current_user');
    if (userData == null) return null;

    return UserModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(userData)),
    );
  }

  /// Log out the current user.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ecotrack_is_logged_in', false);
    await prefs.remove('ecotrack_current_user');
  }

  /// Update user data.
  Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    // Update current session
    await prefs.setString('ecotrack_current_user', jsonEncode(user.toJson()));

    // Update in users database
    final existingUsers = prefs.getString('ecotrack_users') ?? '{}';
    final users = Map<String, dynamic>.from(jsonDecode(existingUsers));

    if (users.containsKey(user.email)) {
      final userData = users[user.email] as Map<String, dynamic>;
      userData['user'] = user.toJson();
      users[user.email] = userData;
      await prefs.setString('ecotrack_users', jsonEncode(users));
    }
  }

  /// Check if user is logged in.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('ecotrack_is_logged_in') ?? false;
  }
}
