# Quick Reference Card

## 🚀 Start Here

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run

# 3. Navigate to registration
Get.toNamed(Routes.BUSINESS_REGISTRATION);
```

## 📂 File Locations

### Views
```
lib/app/modules/auth/views/
├── business_registration_view.dart    # Main dashboard
├── business_info_view.dart           # Business form
├── owner_verification_view.dart      # ID verification
├── business_docs_view.dart           # Document uploads
├── bank_account_view.dart            # Bank details
└── tax_info_view.dart                # Tax info
```

### Controllers
```
lib/app/modules/auth/controllers/
├── business_registration_controller.dart
├── business_info_controller.dart
├── owner_verification_controller.dart
├── business_docs_controller.dart
├── bank_account_controller.dart
└── tax_info_controller.dart
```

### Services
```
lib/app/services/
├── file_upload_service.dart          # File picker & upload
└── registration_api_service.dart     # API integration
```

### Utilities
```
lib/app/utils/
├── validators.dart                   # Form validation
├── text_formatters.dart              # Input formatters
└── file_helpers.dart                 # File utilities
```

### Widgets
```
lib/app/widgets/
├── custom_text_field.dart            # Form input
├── custom_button.dart                # Button
└── loading_overlay.dart              # Loading indicator
```

## 🎯 Common Tasks

### Navigate to Registration
```dart
Get.toNamed(Routes.BUSINESS_REGISTRATION);
```

### Pick an Image
```dart
final file = await FileUploadService().pickImageWithOptions(crop: true);
```

### Pick a Document
```dart
final file = await FileUploadService().pickDocument();
```

### Validate Email
```dart
CustomTextField(
  validator: Validators.validateEmail,
)
```

### Validate Phone
```dart
CustomTextField(
  validator: Validators.validatePhone,
  inputFormatters: [PhoneNumberFormatter()],
)
```

### Validate Account Number
```dart
CustomTextField(
  validator: Validators.validateAccountNumber,
  inputFormatters: [AccountNumberFormatter()],
)
```

### Upload File to Server
```dart
final url = await RegistrationApiService().uploadFile(
  file,
  folder: 'documents',
);
```

### Check Registration Status
```dart
final isVerified = VendorUser.isFullyVerified.value;
final status = VendorUser.kycStatus.value;
final steps = VendorUser.verificationStepsCompleted;
```

## 🔧 Configuration

### API Base URL
`lib/app/services/registration_api_service.dart`
```dart
baseUrl: 'https://your-api-url.com',
```

### Brand Colors
`lib/app/constants/color_constant.dart`
```dart
static Color brandColor = fromHex('#5A5ED8');
```

## 📱 Routes

| Route | Path | Purpose |
|-------|------|---------|
| `BUSINESS_REGISTRATION` | `/business-registration` | Main dashboard |
| `BUSINESS_INFO` | `/business-info` | Business details |
| `OWNER_VERIFICATION` | `/owner-verification` | ID verification |
| `BUSINESS_DOCS` | `/business-docs` | Documents |
| `BANK_ACCOUNT` | `/bank-account` | Bank details |
| `TAX_INFO` | `/tax-info` | Tax information |

## 🛠️ Validators Available

```dart
Validators.validateEmail(value)
Validators.validatePhone(value)
Validators.validateRequired(value)
Validators.validateAccountNumber(value)
Validators.validateBVN(value)
Validators.validateTIN(value)
Validators.validatePostalCode(value)
Validators.validateBusinessName(value)
Validators.validateIDNumber(value)
Validators.validateCACNumber(value)
Validators.validatePassword(value)
Validators.validateURL(value)
Validators.validateAge(date, minAge)
```

## 🎨 Input Formatters

```dart
PhoneNumberFormatter()
AccountNumberFormatter()
BVNFormatter()
PostalCodeFormatter()
CACNumberFormatter()
NameFormatter()
UpperCaseTextFormatter()
CurrencyInputFormatter()
```

## 📦 Services

### FileUploadService Methods
```dart
pickImageFromGallery()
takePhoto()
pickImageWithOptions()
pickDocument()
pickMultipleDocuments()
validateFileSize(file, maxSizeMB: 10)
getFileSizeInMB(file)
isImageFile(file)
isPdfFile(file)
```

### RegistrationApiService Methods
```dart
uploadFile(file, folder: 'documents')
uploadMultipleFiles(files)
saveBusinessInfo(data)
saveOwnerVerification(data)
saveBusinessDocuments(data)
saveBankAccount(data)
saveTaxInfo(data)
submitRegistration()
getRegistrationStatus()
verifyBankAccount(accountNumber, bankCode)
getBanks()
```

## 🚨 Troubleshooting

### File picker not working?
- Check permissions in AndroidManifest.xml & Info.plist
- Test on real device, not simulator

### API calls failing?
- Verify baseUrl in `registration_api_service.dart`
- Check network connectivity
- Review console for error details

### Validation not working?
- Ensure formKey is set
- Call `formKey.currentState!.validate()`

### Images not displaying?
- Check file path is correct
- Verify file exists
- Use CachedNetworkImage for URLs

## 📚 Documentation

1. **PROFILE_COMPLETION_README.md** - Full technical docs
2. **USAGE_GUIDE.md** - Code examples & integration guide
3. **QUICK_REFERENCE.md** - This file (quick lookup)

## 🎯 Testing Checklist

- [ ] Navigate to business registration
- [ ] Fill business information form
- [ ] Upload business logo
- [ ] Complete owner verification
- [ ] Upload ID documents
- [ ] Upload business documents
- [ ] Enter bank account details
- [ ] Fill tax information
- [ ] Submit application
- [ ] Check all validations work
- [ ] Test file size limits
- [ ] Test error states
- [ ] Test loading states

## 💡 Quick Tips

1. All controllers have mock data for testing UI
2. File uploads return mock URLs until backend is ready
3. Validation works immediately without backend
4. Test on real device for camera/file picker
5. Check console for detailed error messages

## 🔗 Important Files to Review

1. `lib/app/services/registration_api_service.dart` - Update API URL
2. `android/app/src/main/AndroidManifest.xml` - Add permissions
3. `ios/Runner/Info.plist` - Add permission descriptions
4. `lib/app/constants/color_constant.dart` - Customize colors

## 📞 Support

Questions? Check these in order:
1. Console error messages
2. USAGE_GUIDE.md examples
3. PROFILE_COMPLETION_README.md details
4. Individual controller files

---

**Remember**: Run `flutter pub get` after cloning! 🚀
