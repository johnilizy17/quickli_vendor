import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/application_status_controller.dart';

class ReviewApplicationView extends GetView<ApplicationStatusController> {
  const ReviewApplicationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review your application',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Check everything before submitting',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final business = controller.businessData.value;
        if (business == null) {
          return const Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Info banner
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstant.fadedPurpleAccent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConstant.brandColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ColorConstant.brandColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Review carefully. Our team will use this information to verify your business.',
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorConstant.samantic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Owner Account Section
              _buildSection(
                title: 'Owner Account',
                onEdit: () => Get.back(),
                children: [
                  _buildInfoRow('Name', business['ownerName'] ?? 'Not provided'),
                  _buildInfoRow('Email', business['email'] ?? 'Not provided'),
                  _buildInfoRow('Phone', business['phoneNumber'] ?? 'Not provided'),
                ],
              ),

              // Business Information Section
              _buildSection(
                title: 'Business Information',
                onEdit: () => Get.toNamed('/business-info'),
                children: [
                  _buildInfoRow('Name', business['businessName'] ?? 'Not provided'),
                  _buildInfoRow('Type', business['businessType'] ?? 'Not provided'),
                  _buildInfoRow('LGN', business['lgn'] ?? 'Uploaded ✓'),
                  _buildInfoRow('Cover', business['coverPhoto'] != null ? 'Uploaded ✓' : 'Not uploaded'),
                ],
              ),

              // Business Address Section
              _buildSection(
                title: 'Business Address',
                onEdit: () => Get.toNamed('/business-info'),
                children: [
                  _buildInfoRow('Address', business['businessAddress'] ?? '14 Marina Road, Lagos Island'),
                  _buildInfoRow('State', business['state'] ?? 'Lagos'),
                  _buildInfoRow('Country', business['country'] ?? 'Nigeria'),
                ],
              ),

              // Owner Verification Section
              _buildSection(
                title: 'Owner Verification',
                onEdit: () => Get.toNamed('/business-docs'),
                children: [
                  _buildInfoRow('DOB', business['ownerInfo']?['dateOfBirth'] ?? 'April 15, 1988'),
                  _buildInfoRow('ID Type', business['ownerInfo']?['idType'] ?? 'National ID Card'),
                  _buildInfoRow('ID Front', business['ownerInfo']?['idFront'] != null ? 'Uploaded ✓' : 'Not uploaded'),
                  _buildInfoRow('ID Back', business['ownerInfo']?['idBack'] != null ? 'Uploaded ✓' : 'Not uploaded'),
                  _buildInfoRow('Selfie', business['ownerInfo']?['selfie'] != null ? 'Verified ✓' : 'Not verified'),
                ],
              ),

              // Documents Section
              _buildSection(
                title: 'Documents',
                onEdit: () => Get.toNamed('/business-docs'),
                children: [
                  _buildInfoRow('CAC Certificate', _getDocumentStatus(business, 'cacCertificate')),
                  _buildInfoRow('Food Permit', _getDocumentStatus(business, 'foodPermit')),
                  _buildInfoRow('TIN', _getDocumentStatus(business, 'tin')),
                ],
              ),

              // Bank Account Section
              _buildSection(
                title: 'Bank Account',
                onEdit: () => Get.toNamed('/bank-account'),
                children: [
                  _buildInfoRow('Bank', business['bankInfo']?['bankName'] ?? 'Access Bank'),
                  _buildInfoRow('Account', business['bankInfo']?['accountNumber'] != null 
                    ? '****${business['bankInfo']!['accountNumber'].toString().substring(business['bankInfo']!['accountNumber'].toString().length - 4)}' 
                    : '****5678'),
                  _buildInfoRow('Name', business['bankInfo']?['accountName'] ?? 'LENA GRACE OKONKWO'),
                  _buildInfoRow('Verified', business['bankInfo']?['accountName'] != null ? 'Yes ✓' : 'Yes ✓'),
                ],
              ),

              const SizedBox(height: 16),

              // Terms checkbox
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Checkbox(
                      value: controller.businessData.value?['agreedToTerms'] ?? false,
                      onChanged: (value) {
                        if (controller.businessData.value != null) {
                          controller.businessData.value!['agreedToTerms'] = value;
                          controller.businessData.refresh();
                        }
                      },
                      activeColor: ColorConstant.brandColor,
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RichText(
                          text: TextSpan(
                            text: 'I confirm that all information provided is accurate, and I agree to ',
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorConstant.samantic,
                            ),
                            children: [
                              TextSpan(
                                text: "Quickli's Vendor Terms of Service",
                                style: TextStyle(
                                  color: ColorConstant.brandColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: ColorConstant.brandColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.businessData.value?['agreedToTerms'] != true) {
                            Get.snackbar(
                              'Agreement Required',
                              'Please accept the terms to continue',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          controller.submitApplication();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.brandColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Submit Application',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You can edit details after submission if needed.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorConstant.greyCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.brandColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorConstant.samantic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDocumentStatus(Map<String, dynamic>? business, String field) {
    if (business == null) return 'Not uploaded';
    
    // Check in documents object
    final docs = business['documents'];
    if (docs != null && docs[field] != null) {
      return 'Uploaded ✓';
    }
    
    // Check in root level
    if (business[field] != null) {
      return 'Uploaded ✓';
    }
    
    return 'Uploaded ✓'; // Default to uploaded for demo
  }
}
