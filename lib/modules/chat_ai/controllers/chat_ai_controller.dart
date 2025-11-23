import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/chat_message_model.dart';
import '../../../../services/ai_service.dart';

class ChatAiController extends GetxController {
  final AiService _aiService = Get.find();

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  var messages = <ChatMessageModel>[].obs;
  var isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pesan pembuka default dari AI
    messages.add(ChatMessageModel(
      text: "Hello! How can I help you with your investments today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // 1. Tambahkan pesan User ke list
    messages.add(ChatMessageModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    messageController.clear();
    scrollToBottom();

    // 2. Set status typing (muncul animasi titik-titik)
    isTyping.value = true;
    scrollToBottom(); // Scroll lagi biar indikator kelihatan

    // 3. Kirim ke API (Simulasi delay agar terasa natural)
    // final reply = await _aiService.sendMessage(text);
    // Note: Jika API belum siap, gunakan mock reply di bawah ini untuk tes UI
    await Future.delayed(const Duration(seconds: 2));
    final reply = await _aiService.sendMessage(text);

    // 4. Hapus status typing & Tambahkan balasan AI
    isTyping.value = false;
    messages.add(ChatMessageModel(
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
    ));

    scrollToBottom();
  }

  void scrollToBottom() {
    // Delay sedikit agar widget selesai dirender sebelum scroll
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}