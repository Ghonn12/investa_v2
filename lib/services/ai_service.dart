import 'package:get/get.dart';
import 'api_service.dart';
import '../core/values/api_constants.dart';

class AiService extends GetxService {
  final ApiService _api = Get.find();

  Future<String> sendMessage(String message) async {
    try {
      final response = await _api.post(ApiConstants.chat, data: {
        'message': message,
      });

      if (response.statusCode == 200) {
        return response.data['data']['reply'];
      }
      return "Maaf, saya sedang tidak bisa menjawab saat ini.";
    } catch (e) {
      return "Terjadi kesalahan koneksi.";
    }
  }
}