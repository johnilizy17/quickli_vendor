# Testing Guide - Vendor Registration Flow

## 🧪 Testing Overview

This guide helps you test the complete vendor registration flow without a backend.

## ✅ Pre-Testing Checklist

- [x] Flutter dependencies installed (`flutter pub get`)
- [ ] App builds successfully (`flutter run`)
- [ ] Test on real device (for camera/file picker)
- [ ] Android/iOS permissions configured

## 📱 Testing on Device

### Android Testing
```bash
# Connect Android device via USB
flutter devices

# Run on Android
flutter run -d <device-id>
```

### iOS Testing
```bash
# Connect iPhone via USB
flutter devices

# Run on iOS  
flutter run -d <device-id>
```

## 🎯 Test Scenarios

### Scenario 1: Complete Registration Flow

#### Step 1: Navigate to Registration
1. Launch app
2. Navigate to business registration screen:
   ```dart
   Get.toNamed(Routes.BUSINESS_REGISTRATION);
   ```
3. ✅ Verify main dashboard appears
4. ✅ Verify progress shows "0 of 5 completed"
5. ✅ Verify warning banner appears

#### Step 2: Business Information
1. Tap "Business information" card
2. ✅ Verify form loads
3. Try to save without filling:
   - ✅ Validation errors should appear
4. Fill the form:
   - Tap logo upload
   - ✅ Verify camera/gallery options appear
   - Select an image
   - ✅ Verify image appears
   - Select business type
   - Enter business name
   - Enter phone: `08012345678`
   - Enter email: `test@example.com`
   - Enter address details
   - Select operating hours
5. Tap "Save & Continue"
6. ✅ Verify loading indicator appears
7. ✅ Verify success message
8. ✅ Verify returns to main dashboard
9. ✅ Verify business info shows "Completed"

#### Step 3: Owner Verification
1. Tap "Owner verification" card
2. Fill the form:
   - Enter full name
   - Select date of birth
   - ✅ Verify date picker works
   - ✅ Verify age validation (18+)
   - Select ID type
   - Enter ID number
   - Upload ID front
   - ✅ Verify file selection works
   - Upload ID back
   - Upload selfie
3. Try to save without all documents:
   - ✅ Verify error message appears
4. Complete all uploads and save
5. ✅ Verify success and return to dashboard

#### Step 4: Business Documents
1. Tap "Business documents" card
2. Upload required documents:
   - Business registration certificate
   - TIN document
3. ✅ Verify file picker works
4. ✅ Verify PDF/image selection works
5. Upload optional documents (if needed)
6. Add additional document:
   - Tap "Add Another Document"
   - ✅ Verify can select file
   - ✅ Verify file appears in list
   - ✅ Verify can remove file
7. Save documents
8. ✅ Verify success

#### Step 5: Bank Account
1. Tap "Bank account" card
2. Select bank from dropdown
3. ✅ Verify 18+ banks appear
4. Enter account number: `0123456789`
5. ✅ Verify account number format validation
6. ✅ Verify "Verifying account..." appears
7. ✅ Verify account name appears after 2 seconds
8. Enter BVN (optional): `12345678901`
9. ✅ Verify BVN format validation (11 digits)
10. Select account type (Savings/Current)
11. Save bank account
12. ✅ Verify success

#### Step 6: Tax Information
1. Tap "Tax information" card
2. Fill the form:
   - Enter TIN
   - Enter VAT number (optional)
   - Enter business registration number
   - Enter tax office
   - Toggle VAT registered switch
   - Upload tax certificate
3. Save tax information
4. ✅ Verify success

#### Step 7: Submit Application
1. Return to main dashboard
2. ✅ Verify progress shows "5 of 5 completed"
3. ✅ Verify all steps show "Completed"
4. ✅ Verify "Submit Application" button is enabled
5. Tap "Submit Application"
6. ✅ Verify confirmation dialog (if implemented)
7. ✅ Verify loading indicator
8. ✅ Verify success message
9. ✅ Verify navigation to verification pending screen

### Scenario 2: Form Validation Testing

#### Email Validation
Test these inputs in email field:
- ❌ Empty: Should show error
- ❌ `test`: Should show "invalid email"
- ❌ `test@`: Should show "invalid email"
- ❌ `test@example`: Should show "invalid email"
- ✅ `test@example.com`: Should accept

#### Phone Validation
Test these inputs in phone field:
- ❌ Empty: Should show error
- ❌ `123`: Should show "invalid phone"
- ❌ `08012345`: Should show "invalid phone"
- ✅ `08012345678`: Should accept
- ✅ `+2348012345678`: Should accept

#### Account Number Validation
Test these inputs:
- ❌ Empty: Should show error
- ❌ `123456789` (9 digits): Should show error
- ❌ `12345678901` (11 digits): Should block input
- ✅ `0123456789` (10 digits): Should accept

#### Required Field Validation
- ❌ Leave field empty: Should show "Field is required"
- ✅ Enter text: Should clear error

### Scenario 3: File Upload Testing

#### Image Upload
1. Tap any image upload button
2. ✅ Verify bottom sheet appears
3. ✅ Verify "Camera" and "Gallery" options
4. Test Camera:
   - Tap "Camera"
   - ✅ Verify camera opens
   - Take photo
   - ✅ Verify photo appears
5. Test Gallery:
   - Tap "Gallery"
   - ✅ Verify gallery opens
   - Select image
   - ✅ Verify image appears
6. Test Cropping (logo):
   - Select image
   - ✅ Verify crop screen appears
   - Crop image
   - ✅ Verify cropped image appears

#### Document Upload
1. Tap document upload button
2. ✅ Verify file picker opens
3. ✅ Verify can select PDF
4. ✅ Verify can select DOC
5. ✅ Verify can select image
6. Test file size:
   - Select file > 10MB
   - ✅ Verify error message appears

### Scenario 4: Navigation Testing

#### Forward Navigation
1. From main dashboard
2. Open any form
3. ✅ Verify back button works
4. ✅ Verify returns to dashboard

#### Save and Return
1. Open any form
2. Fill and save
3. ✅ Verify returns to dashboard
4. ✅ Verify status updated

#### Cancel Without Saving
1. Open any form
2. Fill some fields
3. Tap back button
4. ✅ Verify can exit without saving
5. ✅ Verify data not saved

### Scenario 5: Progress Tracking

#### Initial State
- ✅ Progress: 0%
- ✅ Completed: 0 of 5
- ✅ All steps: "Not started"
- ✅ Submit button: Disabled

#### After Each Step
- ✅ Progress increases by 20%
- ✅ Completed count increases
- ✅ Step status changes to "Completed"

#### Final State
- ✅ Progress: 100%
- ✅ Completed: 5 of 5
- ✅ All steps: "Completed"
- ✅ Submit button: Enabled
- ✅ Warning banner: Hidden

### Scenario 6: Error Handling

#### Network Errors
1. Disable internet
2. Try to save any form
3. ✅ Verify timeout error message
4. ✅ Verify form not submitted
5. Enable internet and retry
6. ✅ Verify success

#### Invalid Data
1. Enter invalid email
2. Try to save
3. ✅ Verify inline error
4. ✅ Verify form not submitted
5. Fix error and retry
6. ✅ Verify success

#### Missing Required Fields
1. Skip required field
2. Try to save
3. ✅ Verify error for that field
4. ✅ Verify form not submitted

### Scenario 7: Edge Cases

#### Very Long Text
1. Enter 1000 characters in business name
2. ✅ Verify validation error
3. ✅ Verify max length enforced

#### Special Characters
1. Test business name with:
   - Spaces: ✅ Should accept
   - Numbers: ✅ Should accept
   - Special chars: Test behavior
   - Emoji: Test behavior

#### Multiple File Uploads
1. Add 10 additional documents
2. ✅ Verify all appear in list
3. ✅ Verify can remove any
4. ✅ Verify can save all

## 🐛 Known Issues to Test

### Issue 1: Image Picker on Simulator
- **Symptom**: Camera not available on iOS simulator
- **Expected**: Gallery should still work
- **Test**: Use gallery option

### Issue 2: Large File Upload
- **Symptom**: App may slow down with large files
- **Expected**: Show loading indicator
- **Test**: Upload 5MB+ file

### Issue 3: Multiple Rapid Clicks
- **Symptom**: Multiple submissions if button tapped rapidly
- **Expected**: Button should disable after first tap
- **Test**: Rapidly tap "Save & Continue"

## 📊 Test Results Template

```
Test Date: ___________
Device: ___________
OS Version: ___________

[ ] Scenario 1: Complete Registration Flow
[ ] Scenario 2: Form Validation
[ ] Scenario 3: File Upload
[ ] Scenario 4: Navigation
[ ] Scenario 5: Progress Tracking
[ ] Scenario 6: Error Handling
[ ] Scenario 7: Edge Cases

Issues Found:
1. _____________________
2. _____________________
3. _____________________

Overall Status: [ ] Pass [ ] Fail
```

## 🎬 Demo Script

Use this script to demonstrate the feature:

```
1. "This is the vendor registration dashboard"
2. "We have 5 steps to complete"
3. "Let's start with business information"
4. [Fill form, show image picker]
5. "Notice the validation on each field"
6. [Save and show success]
7. "Progress automatically updates"
8. [Repeat for other sections]
9. "When all steps are complete, we can submit"
10. [Show submit button enabled]
```

## 🔧 Debugging Tips

### View Console Logs
All errors are logged. Check for:
```
flutter: Error: Failed to upload file
flutter: DioException: Connection timeout
```

### Check Network Calls
Mock delays simulate API calls:
```dart
await Future.delayed(const Duration(seconds: 2));
```

### Verify File Paths
Print file paths in console:
```dart
print('Selected file: ${file.path}');
```

### Check Form Validation
Print form state:
```dart
print('Form valid: ${formKey.currentState!.validate()}');
```

## ✨ Best Practices for Testing

1. **Test on Real Device**: File picker and camera need real hardware
2. **Test Both Platforms**: iOS and Android may behave differently
3. **Test Edge Cases**: Large files, special characters, etc.
4. **Test Error States**: Disable network, enter invalid data
5. **Test User Flow**: Complete full registration without skipping steps
6. **Test Performance**: Large file uploads, multiple documents
7. **Test Persistence**: Kill app and reopen (when implemented)

## 🎯 Acceptance Criteria

The feature is ready for production when:

- [ ] All 7 scenarios pass
- [ ] No crashes or freezes
- [ ] All validations work correctly
- [ ] File uploads work on both platforms
- [ ] Progress tracking is accurate
- [ ] Error messages are clear
- [ ] Loading states appear correctly
- [ ] UI is responsive
- [ ] Navigation works smoothly
- [ ] Can complete full registration flow

## 📝 Reporting Issues

When reporting issues, include:

1. **Device**: iPhone 12, Android Galaxy S21, etc.
2. **OS Version**: iOS 16, Android 13, etc.
3. **Steps to Reproduce**: Exact steps to trigger issue
4. **Expected Result**: What should happen
5. **Actual Result**: What actually happened
6. **Screenshots**: Visual evidence
7. **Console Logs**: Any error messages

## 🚀 Next Steps After Testing

1. Fix any issues found
2. Implement backend integration
3. Test with real API
4. Add automated tests
5. Deploy to staging
6. User acceptance testing
7. Deploy to production

---

**Happy Testing! 🎉**

Remember: Thorough testing now means fewer bugs later!
