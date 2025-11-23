import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';
import '../core/values/api_constants.dart';

class AuthService extends GetxService {
  final ApiService _api = Get.find();
  final _storage = const FlutterSecureStorage();

  // Reactive variable untuk status login
  final isLoggedIn = false.obs;
  final userName = ''.obs;

  Future<AuthService> init() async {
    // Cek token saat aplikasi dimulai
    String? token = await _storage.read(key: 'auth_token');
    if (token != null) {
      isLoggedIn.value = true;
      // Opsional: Ambil data user profile di sini jika perlu
    }
    return this;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _api.post(ApiConstants.login, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data['data'];
        String token = data['token'];
        String name = data['user']['name'];

        // Simpan Token & Nama
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'user_name', value: name);

        isLoggedIn.value = true;
        userName.value = name;
        return true;
      }
      return false;
    } catch (e) {
      rethrow; // Lempar error ke Controller untuk ditampilkan di UI
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _api.post(ApiConstants.register, data: {
        'name': name,
        'email': email,
        'password': password,
      });

      return response.statusCode == 201;
    } catch (e) {
      rethrow; // <--- WAJIB ADA INI agar controller tau ada error
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    isLoggedIn.value = false;
    userName.value = '';
    Get.offAllNamed('/login');
  }
}