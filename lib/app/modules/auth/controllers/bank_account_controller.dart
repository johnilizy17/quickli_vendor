import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/registration_api_service.dart';
import '../../../constants/color_constant.dart';

class BankAccountController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _apiService = RegistrationApiService();

  // Store businessId
  final businessId = ''.obs;

  // Controllers
  final accountNumberController = TextEditingController();
  final bvnController = TextEditingController();

  // Observable fields
  final selectedBank = ''.obs;
  final accountName = ''.obs;
  final accountType = 'savings'.obs;
  final isVerifying = false.obs;
  final searchQuery = ''.obs;

  // Nigerian banks list with codes
  final Map<String, String> bankCodeMap = {
    'Access Bank': '044',
    'Access Bank (Diamond)': '063',
    'Citibank Nigeria': '023',
    'Ecobank Nigeria': '050',
    'Fidelity Bank': '070',
    'First Bank of Nigeria': '011',
    'First City Monument Bank (FCMB)': '214',
    'Globus Bank': '00103',
    'Guaranty Trust Bank (GTBank)': '058',
    'Heritage Bank': '030',
    'Jaiz Bank': '301',
    'Keystone Bank': '082',
    'Kuda Bank': '50211',
    'Moniepoint': '50515',
    'Opay': '999992',
    'PalmPay': '999991',
    'Parallex Bank': '526',
    'Polaris Bank': '076',
    'Providus Bank': '101',
    'Stanbic IBTC Bank': '221',
    'Standard Chartered Bank': '068',
    'Sterling Bank': '232',
    'SunTrust Bank': '100',
    'Titan Trust Bank': '102',
    'Union Bank of Nigeria': '032',
    'United Bank for Africa (UBA)': '033',
    'Unity Bank': '215',
    'Wema Bank': '035',
    'Zenith Bank': '057',
  };

  // Get bank list from map keys
  List<String> get banks => bankCodeMap.keys.toList()..sort();
  
  // Get filtered banks based on search
  List<String> get filteredBanks {
    if (searchQuery.value.isEmpty) {
      return banks;
    }
    return banks
        .where((bank) =>
            bank.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  @override
  void onClose() {
    accountNumberController.dispose();
    bvnController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    // Get vendor business
    try {
      print('[BankAccount] Loading saved bank data...');
      
      final response = await _apiService.getVendorBusiness();
      print('[BankAccount] API Response: $response');
      
      if (response != null) {
        // Handle both response formats
        final business = response['data'] ?? response;
        
        if (business['_id'] != null) {
          businessId.value = business['_id'];
          print('[BankAccount] Loaded businessId: ${businessId.value}');
        }
        
        // Pre-fill if bank info exists
        final bankInfo = business['bankInfo'];
        
        if (bankInfo != null && bankInfo is Map && bankInfo.isNotEmpty) {
          print('[BankAccount] 📝 Loading saved bank info...');
          
          if (bankInfo['accountNumber'] != null && bankInfo['accountNumber'].toString().isNotEmpty) {
            accountNumberController.text = bankInfo['accountNumber'].toString();
            print('[BankAccount] ✅ Loaded account number');
          }
          
          if (bankInfo['accountName'] != null && bankInfo['accountName'].toString().isNotEmpty) {
            accountName.value = bankInfo['accountName'].toString();
            print('[BankAccount] ✅ Loaded account name: ${accountName.value}');
          }
          
          if (bankInfo['bankName'] != null && bankInfo['bankName'].toString().isNotEmpty) {
            selectedBank.value = bankInfo['bankName'].toString();
            print('[BankAccount] ✅ Loaded bank name: ${selectedBank.value}');
          }
        } else {
          print('[BankAccount] ℹ️ No previous bank info - Starting fresh');
        }
      } else {
        print('[BankAccount] ⚠️ API returned null response');
      }
    } catch (e, stackTrace) {
      print('[BankAccount] ❌ Error loading business: $e');
      print('[BankAccount] Stack trace: $stackTrace');
    }
  }

  Future<void> verifyAccountNumber(String value) async {
    if (value.length == 10 && selectedBank.value.isNotEmpty) {
      isVerifying.value = true;
      accountName.value = '';

      try {
        // TODO: Call bank verification API
        await Future.delayed(const Duration(seconds: 2));
        
        // Mock response
        accountName.value = 'JOHN DOE ENTERPRISES LTD';
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to verify account number',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isVerifying.value = false;
      }
    } else {
      accountName.value = '';
    }
  }

  Future<void> saveBankAccount() async {
    print('[BankAccount] ========== SAVE STARTED ==========');
    
    if (!formKey.currentState!.validate()) {
      print('[BankAccount] ❌ Form validation failed');
      return;
    }

    if (selectedBank.value.isEmpty) {
      print('[BankAccount] ❌ No bank selected');
      Get.snackbar(
        'Error',
        'Please select a bank',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (accountName.value.isEmpty) {
      print('[BankAccount] ❌ Account not verified');
      Get.snackbar(
        'Error',
        'Please wait for account verification',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Ensure businessId is loaded
      if (businessId.value.isEmpty) {
        print('[BankAccount] Business ID empty, loading...');
        await loadSavedData();
        
        if (businessId.value.isEmpty) {
          Get.back();
          throw Exception('Business ID not found');
        }
      }

      // Prepare data for setupBankDetails
      final data = {
        'businessId': businessId.value,
        'accountName': accountName.value,
        'accountNumber': accountNumberController.text,
        'bankName': selectedBank.value,
        'bankCode': bankCodeMap[selectedBank.value] ?? '',
      };

      print('[BankAccount] Submitting data: $data');

      // Validate bank code exists
      if (data['bankCode']!.isEmpty) {
        Get.back(); // Close loading dialog
        print('[BankAccount] ❌ Bank code not found for: ${selectedBank.value}');
        Get.snackbar(
          'Error',
          'Bank code not found. Please contact support.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Save to API using setupBankDetails
      final response = await _apiService.setupBankDetails(data);
      print('[BankAccount] API Response: $response');

      Get.back(); // Close loading dialog

      if (response != null) {
        print('[BankAccount] ✅ Bank details saved successfully');
        
        // Mark step as complete
        try {
          print('[BankAccount] Marking verification step as complete...');
          await _apiService.updateVerificationStep({
            'businessId': businessId.value,
            'step': 'bank-info-setup',
          });
          print('[BankAccount] ✅ Verification step marked complete');
        } catch (stepError) {
          print('[BankAccount] ⚠️ Failed to mark step complete: $stepError');
        }

        Get.back(); // Go back to registration screen

        Get.snackbar(
          'Success',
          'Bank account saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        print('[BankAccount] ========== SAVE COMPLETED ==========');
      } else {
        print('[BankAccount] ❌ API returned null response');
        Get.snackbar(
          'Error',
          'Failed to save bank account',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      Get.back(); // Close loading dialog
      print('[BankAccount] ========== SAVE FAILED ==========');
      print('[BankAccount] ❌ Error: $e');
      print('[BankAccount] Stack trace: $stackTrace');
      
      Get.snackbar(
        'Error',
        'Failed to save bank account: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Show searchable bank selection dialog
  Future<void> showBankSelectionDialog() async {
    searchQuery.value = '';
    
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 600,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select your bank',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.samantic,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Search field
              TextField(
                onChanged: (value) => searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search for your bank...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: ColorConstant.greyCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Bank list
              Expanded(
                child: Obx(() {
                  final filtered = filteredBanks;
                  
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No banks found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final bank = filtered[index];
                      final isSelected = bank == selectedBank.value;
                      
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: ColorConstant.fadedPurpleAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            color: ColorConstant.brandColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          bank,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: ColorConstant.brandColor,
                              )
                            : null,
                        onTap: () {
                          selectedBank.value = bank;
                          Get.back();
                          
                          // Re-verify account if number already entered
                          if (accountNumberController.text.length == 10) {
                            verifyAccountNumber(accountNumberController.text);
                          }
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
