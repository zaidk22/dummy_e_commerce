import 'package:dummy_e_commerce/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false; 
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signUp(String name, String email, String password) async {
    _user = await _authService.signUp(name, email, password);
    _isLoggedIn = true;
    await _secureStorage.write(key: 'userToken', value: _user!.uid); 
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _user = await _authService.login(email, password);
    _isLoggedIn = true;
    await _secureStorage.write(key: 'userToken', value: _user!.uid); 
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    _user = null;
    _isLoggedIn = false;
    await _secureStorage.delete(key: 'userToken'); 
     Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,  // Removes all previous routes
    );
    notifyListeners();
  }

  Future<bool> checkLoggedIn() async {
    String? userToken = await _secureStorage.read(key: 'userToken');
    _isLoggedIn = userToken != null;

    if (_isLoggedIn) {
   
      notifyListeners();
    }
    return _isLoggedIn;
  }
}
