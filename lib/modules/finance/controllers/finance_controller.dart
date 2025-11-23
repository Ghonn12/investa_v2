import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/finance_service.dart';
import '../../../../models/transaction_model.dart';
import '../../../../widgets/error_snackbar.dart';
// 1. Import DashboardController agar bisa dipanggil
import '../../dashboard/controllers/dashboard_controller.dart';

class FinanceController extends GetxController {
  final FinanceService _financeService = Get.find();

  var transactions = <TransactionModel>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;

  // Form Controllers
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  var selectedType = 'EXPENSE'.obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void fetchTransactions() async {
    try {
      isLoading.value = true;
      final data = await _financeService.getTransactions();
      transactions.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void addTransaction() async {
    if (titleController.text.isEmpty || amountController.text.isEmpty) {
      AppSnackbars.showError("Mohon isi Judul dan Nominal");
      return;
    }

    isSubmitting.value = true;
    try {
      double amount = double.tryParse(amountController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0;

      final success = await _financeService.addTransaction(
        title: titleController.text,
        amount: amount,
        type: selectedType.value,
        category: categoryController.text.isEmpty ? "Umum" : categoryController.text,
        date: selectedDate.value.toIso8601String(),
      );

      if (success) {
        AppSnackbars.showSuccess("Transaksi berhasil disimpan");
        Get.back(); // Tutup BottomSheet

        // Refresh list di halaman ini
        fetchTransactions();
        _resetForm();

        // 2. UPDATE DASHBOARD (Agar saldo berubah real-time)
        // Kita cek apakah DashboardController sedang aktif di memori
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().fetchDashboardData();
        }

      } else {
        AppSnackbars.showError("Gagal menyimpan transaksi");
      }
    } catch (e) {
      AppSnackbars.showError("Terjadi kesalahan: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  void _resetForm() {
    titleController.clear();
    amountController.clear();
    categoryController.clear();
    selectedType.value = 'EXPENSE';
    selectedDate.value = DateTime.now();
  }
}