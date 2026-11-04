# Vendor Registration Flow - Usage Guide

## Quick Start

### 1. Navigate to Registration
From anywhere in your app:
```dart
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

// Navigate to registration
Get.toNamed(Routes.BUSINESS_REGISTRATION);
```

### 2. Check Registration Status
```dart
import 'app/models/vendor_user.dart';

// Check if user has completed registration
final isFullyVerified = VendorUser.isFullyVerified.value;
final kycStatus = VendorUser.kycStatus.value;
final completedSteps = VendorUser.verificationStepsCompleted;

// Status values:
// 'pending' - Registration not started
// 'unverified' - Started but not complete
// 'requested' - Submitted for review
// 'verified' - Approved
// 'rejected' - Rejected
```

## Installation & Setup

### Step 1: Install Dependencies
Run in your terminal:
```bash
flutter pub get
```

All required dependencies are already added to `pubspec.yaml`:
- `image_picker` - For selecting images
- `file_picker` - For selecting documents
- `image_cropper` - For cropping images
- `intl` - For date formatting
- `dio` - For API calls

### Step 2: Configure Permissions

#### Android (`android/app/src/main/AndroidManifest.xml`)
Add these permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

#### iOS (`ios/Runner/Info.plist`)
Add these keys:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos of your documents</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to upload documents</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for video verification</string>
```

### Step 3: Update API Base URL
In `lib/app/services/registration_api_service.dart`:
```dart
baseUrl: 'https://your-api-url.com', // Replace with your actual API URL
```

## Using the Services

### File Upload Service

```dart
import 'package:quickli_vendor/app/services/file_upload_service.dart';

final fileUploadService = FileUploadService();

// Pick image with camera/gallery options
final imageFile = await fileUploadService.pickImageWithOptions(crop: true);

// Pick document (PDF, DOC, etc.)
final docFile = await fileUploadService.pickDocument();

// Validate file size
if (fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
  // File is valid
}

// Get file info
final sizeMB = fileUploadService.getFileSizeInMB(file);
final isImage = fileUploadService.isImageFile(file);
```

### Registration API Service

```dart
import 'package:quickli_vendor/app/services/registration_api_service.dart';

final apiService = RegistrationApiService();

// Upload a file
final url = await apiService.uploadFile(file, folder: 'documents');

// Save business info
final response = await apiService.saveBusinessInfo(data);

// Verify bank account
final accountInfo = await apiService.verifyBankAccount(
  accountNumber: '0123456789',
  bankCode: '058', // GTBank code
);

// Get registration status
final status = await apiService.getRegistrationStatus();
```

## Form Validation Examples

### Using Built-in Validators

```dart
import 'package:quickli_vendor/app/utils/validators.dart';

// In your form fields
CustomTextField(
  controller: emailController,
  label: 'Email',
  validator: Validators.validateEmail,
)

CustomTextField(
  controller: phoneController,
  label: 'Phone',
  validator: Validators.validatePhone,
)

CustomTextField(
  controller: accountController,
  label: 'Account Number',
  validator: Validators.validateAccountNumber,
)
```

### Using Text Formatters

```dart
import 'package:quickli_vendor/app/utils/text_formatters.dart';

CustomTextField(
  controller: accountNumberController,
  label: 'Account Number',
  inputFormatters: [AccountNumberFormatter()],
  keyboardType: TextInputType.number,
)

CustomTextField(
  controller: bvnController,
  label: 'BVN',
  inputFormatters: [BVNFormatter()],
  keyboardType: TextInputType.number,
)

CustomTextField(
  controller: cacNumberController,
  label: 'CAC Number',
  inputFormatters: [CACNumberFormatter()],
)
```

## Complete Example: Creating a Custom Form

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickli_vendor/app/widgets/custom_text_field.dart';
import 'package:quickli_vendor/app/widgets/custom_button.dart';
import 'package:quickli_vendor/app/utils/validators.dart';
import 'package:quickli_vendor/app/utils/text_formatters.dart';

class MyCustomFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void submit() {
    if (formKey.currentState!.validate()) {
      // Form is valid, proceed
      print('Name: ${nameController.text}');
      print('Email: ${emailController.text}');
      print('Phone: ${phoneController.text}');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

class MyCustomFormView extends GetView<MyCustomFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Form')),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            CustomTextField(
              controller: controller.nameController,
              label: 'Full Name',
              hint: 'Enter your name',
              validator: (value) => Validators.validateRequired(
                value,
                fieldName: 'Name',
              ),
              inputFormatters: [NameFormatter()],
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: controller.emailController,
              label: 'Email',
              hint: 'Enter your email',
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: controller.phoneController,
              label: 'Phone',
              hint: 'Enter your phone',
              validator: Validators.validatePhone,
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneNumberFormatter()],
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Submit',
              onPressed: controller.submit,
            ),
          ],
        ),
      ),
    );
  }
}
```

## API Integration Checklist

### 1. Backend Endpoints to Implement

Create these endpoints on your backend:

```
POST   /api/upload                        - Upload files
POST   /api/vendor/business-info          - Save business info
POST   /api/vendor/owner-verification     - Save owner verification
POST   /api/vendor/business-documents     - Save business documents
POST   /api/vendor/bank-account           - Save bank account
POST   /api/vendor/tax-info               - Save tax info
POST   /api/vendor/submit-registration    - Submit complete application
GET    /api/vendor/registration-status    - Get registration status
POST   /api/vendor/verify-bank-account    - Verify bank account
GET    /api/vendor/banks                  - Get list of banks
```

### 2. Request/Response Examples

#### Business Info Request
```json
{
  "businessType": "Restaurant",
  "businessName": "John's Restaurant",
  "businessPhone": "+2348012345678",
  "businessEmail": "contact@johnsrestaurant.com",
  "address": {
    "street": "123 Main Street",
    "city": "Lagos",
    "state": "Lagos",
    "postalCode": "100001"
  },
  "description": "Best restaurant in town",
  "operatingHours": {
    "open": "09:00 AM",
    "close": "10:00 PM"
  },
  "logo": "https://storage.com/logos/logo.jpg"
}
```

#### Bank Verification Request
```json
{
  "accountNumber": "0123456789",
  "bankCode": "058"
}
```

#### Bank Verification Response
```json
{
  "accountNumber": "0123456789",
  "accountName": "JOHN DOE ENTERPRISES LTD",
  "bankName": "Guaranty Trust Bank"
}
```

#### Registration Status Response
```json
{
  "kycStatus": "requested",
  "isFullyVerified": false,
  "verificationStepsCompleted": [
    "business_info",
    "owner_verification",
    "business_docs"
  ],
  "stepsStatus": {
    "business_info": "completed",
    "owner_verification": "pending_review",
    "business_docs": "completed",
    "bank_account": "not_started",
    "tax_info": "not_started"
  }
}
```

## Testing

### Test the Complete Flow

1. **Start Registration**
   ```dart
   Get.toNamed(Routes.BUSINESS_REGISTRATION);
   ```

2. **Complete Each Step**
   - Fill Business Information
   - Upload Owner Verification Documents
   - Upload Business Documents
   - Enter Bank Account Details
   - Provide Tax Information

3. **Submit Application**
   - Click "Submit Application"
   - App navigates to verification pending screen

### Mock Testing (Without Backend)

The controllers already have mock delays and success messages. You can test the entire UI flow without a backend:

```dart
// In each controller, look for:
await Future.delayed(const Duration(seconds: 2));
// This simulates API calls
```

## Customization

### Change Colors
Edit `lib/app/constants/color_constant.dart`:
```dart
static Color brandColor = fromHex('#YourColor');
```

### Change Form Fields
Add/remove fields in view files and corresponding controllers.

### Change Validation Rules
Modify `lib/app/utils/validators.dart` to match your requirements.

### Add More Document Types
In `business_docs_view.dart`, add more document upload cards:
```dart
_DocumentUploadCard(
  title: 'Your Document',
  subtitle: 'Description',
  iconData: Icons.your_icon,
  imagePath: controller.yourDocPath,
  onTap: controller.uploadYourDoc,
  isRequired: true,
),
```

## Common Issues & Solutions

### Issue: File picker not working
**Solution**: Check permissions in AndroidManifest.xml and Info.plist

### Issue: Image cropper crashes
**Solution**: Ensure you're testing on a real device, not simulator

### Issue: API calls failing
**Solution**: 
- Check baseUrl in `registration_api_service.dart`
- Verify network connectivity
- Check backend API is running
- Review error messages in console

### Issue: Form validation not working
**Solution**: Ensure form key is properly set and `validate()` is called

### Issue: File upload too slow
**Solution**: 
- Reduce image quality in ImagePicker settings
- Compress images before upload
- Use multipart upload for large files

## Support

For issues or questions:
1. Check the console for error messages
2. Review the PROFILE_COMPLETION_README.md
3. Check individual controller files for implementation details

## Next Steps

1. ✅ Install dependencies (`flutter pub get`)
2. ✅ Configure permissions (Android & iOS)
3. ⏳ Update API base URL
4. ⏳ Test file uploads
5. ⏳ Implement backend endpoints
6. ⏳ Connect to actual APIs
7. ⏳ Test complete flow
8. ⏳ Deploy to production

---

**Good Luck! 🚀**
