import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_ai_controller.dart';
import '../../../../core/theme/app_colors.dart';

class ChatAiView extends GetView<ChatAiController> {
  const ChatAiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Warna background input field sesuai mode
    final inputBgColor = isDark ? Colors.grey[800] : const Color(0xFFF0F1F4);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.textSecondaryLight),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Investa AI Assistant",
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textSecondaryLight,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.bgDark : Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
        ),
      ),
      body: Column(
        children: [
          // --- Chat List Area ---
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                // +1 item jika sedang typing
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  // Jika ini index terakhir dan sedang typing, tampilkan indikator
                  if (controller.isTyping.value && index == controller.messages.length) {
                    return _buildTypingIndicator(isDark);
                  }

                  final msg = controller.messages[index];
                  return _buildMessageRow(
                      context,
                      msg.text,
                      isUser: msg.isUser,
                      isDark: isDark
                  );
                },
              );
            }),
          ),

          // --- Input Area ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgDark : Colors.white,
              border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: inputBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Tanya sesuatu...",
                        hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[500]),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Tombol Kirim (Accent Color)
                GestureDetector(
                  onTap: controller.sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent, // Teal sesuai desain
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan satu baris pesan (Avatar + Bubble)
  Widget _buildMessageRow(BuildContext context, String message, {required bool isUser, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0), // Jarak antar pesan
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // Avatar sejajar bawah bubble
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar Kiri (AI)
          if (!isUser) _buildAvatar(isUser: false),
          if (!isUser) const SizedBox(width: 12),

          // Column untuk Nama + Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Nama Pengirim
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    isUser ? "You" : "Investa AI",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),

                // Bubble Chat
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary // Navy Blue (#09305B)
                        : (isDark ? Colors.grey[800] : const Color(0xFFF0F1F4)), // Light Gray
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser ? const Radius.circular(16) : Radius.zero, // Lancip kiri bawah (AI)
                      bottomRight: isUser ? Radius.zero : const Radius.circular(16), // Lancip kanan bawah (User)
                    ),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : (isDark ? Colors.grey[200] : AppColors.textPrimaryLight),
                      fontSize: 15,
                      height: 1.4, // Line height agar enak dibaca
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Avatar Kanan (User)
          if (isUser) const SizedBox(width: 12),
          if (isUser) _buildAvatar(isUser: true),
        ],
      ),
    );
  }

  // Widget Indikator Typing (3 Titik Bouncing)
  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(isUser: false),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  "Investa AI",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : const Color(0xFFF0F1F4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: SizedBox(
                  width: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) => _buildDot(index)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper untuk Avatar
  Widget _buildAvatar({required bool isUser}) {
    if (isUser) {
      // Avatar User (Placeholder Gradient/Image)
      return Container(
        width: 36, height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 20),
      );
    } else {
      // Avatar AI (Robot Image)
      return Container(
        width: 36, height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage("https://img.freepik.com/free-vector/graident-ai-robot-vectorart_78370-4114.jpg"), // Placeholder Robot
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  // Helper untuk Dot Animasi
  Widget _buildDot(int index) {
    // Animasi sederhana menggunakan TweenAnimationBuilder bisa ditambahkan di sini
    // Untuk sekarang statis dot abu-abu
    return Container(
      width: 8, height: 8,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}