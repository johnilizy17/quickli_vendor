import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';  // Temporarily disabled
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../services/file_upload_service.dart';
import '../../../services/registration_api_service.dart';
import '../views/business_details_step_view.dart';
import '../views/business_logo_step_view.dart';
import '../views/business_location_step_view.dart';
import '../views/business_evidence_step_view.dart';

class BusinessInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _fileUploadService = FileUploadService();
  final _apiService = RegistrationApiService();

  // Controllers
  final businessNameController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessEmailController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final descriptionController = TextEditingController();
  final websiteController = TextEditingController();

  // Observable fields
  final businessType = ''.obs;
  final selectedBusinessType = ''.obs; // For the business type selection view
  final selectedBusinessCategory = ''.obs; // restaurant or grocery
  final businessId = ''.obs; // Store the business ID after creation
  final logoPath = ''.obs;
  final logoFile = Rxn<File>();
  final openTime = '09:00 AM'.obs;
  final closeTime = '09:00 PM'.obs;
  final isUploading = false.obs;
  final isSubmitting = false.obs;
  final isLoading = false.obs;
  
  // Form validation for business details
  final isBusinessDetailsValid = false.obs;
  
  // Location fields with map support
  final currentLat = 6.4281.obs;
  final currentLng = 3.4219.obs;
  final currentGPS = '6.4281° N, 3.4219° E'.obs;
  final registeredAddress = '14 Marina Road, Lekki Phase 1, Lagos'.obs;
  final distanceFromGPS = '~0.18km'.obs;
  final isLoadingLocation = false.obs;
  final Set<Marker> markers = <Marker>{}.obs;
  GoogleMapController? mapController;
  
  // Evidence collection photos
  final buildingExteriorPhoto = Rxn<File>();
  final storeSignagePhoto = Rxn<File>();
  final insideStorePhoto = Rxn<File>();
  final uploadedPhotosCount = 0.obs;
  
  // Evidence photo URLs (for loaded photos)
  final buildingExteriorUrl = ''.obs;
  final storeSignageUrl = ''.obs;
  final insideStoreUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
    _initializeLocation();
    
    // Add listeners for business details validation
    businessNameController.addListener(_validateBusinessDetails);
    descriptionController.addListener(_validateBusinessDetails);
  }
  
  void _validateBusinessDetails() {
    final isNameFilled = businessNameController.text.trim().isNotEmpty;
    final isDescriptionFilled = descriptionController.text.trim().isNotEmpty;
    
    isBusinessDetailsValid.value = isNameFilled && isDescriptionFilled;
  }

  Future<void> _initializeLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || 
          permission == LocationPermission.whileInUse) {
        await getCurrentLocation();
      }
    } catch (e) {
      // Use default location if permission denied
      _updateMarker();
    }
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessPhoneController.dispose();
    businessEmailController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    descriptionController.dispose();
    websiteController.dispose();
    mapController?.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    try {
      print('[LOAD] Fetching saved business data...');
      final response = await _apiService.getVendorBusiness();
      
      if (response == null) {
        print('[LOAD] ⚠️ No response from API');
        return;
      }
      
      // Handle different response formats
      Map<String, dynamic>? businessData;
      
      if (response['data'] != null) {
        businessData = response['data'];
      } else if (response['_id'] != null) {
        businessData = response;
      }
      
      if (businessData == null) {
        print('[LOAD] ⚠️ No business data in response');
        return;
      }
      
      print('[LOAD] ✅ Business data loaded: ${businessData['_id']}');
      
      // Store business ID
      if (businessData['_id'] != null) {
        businessId.value = businessData['_id'];
      }
      
      // Populate form fields
      if (businessData['name'] != null) {
        businessNameController.text = businessData['name'];
      }
      
      if (businessData['email'] != null) {
        businessEmailController.text = businessData['email'];
      }
      
      if (businessData['phone'] != null) {
        businessPhoneController.text = businessData['phone'];
      }
      
      if (businessData['description'] != null) {
        descriptionController.text = businessData['description'];
      }
      
      // Load website if available
      if (businessData['website'] != null && businessData['website'].toString().isNotEmpty) {
        websiteController.text = businessData['website'];
        print('[LOAD] ✅ Website loaded: ${businessData['website']}');
      }
      
      // Load business category
      if (businessData['businessCategory'] != null) {
        selectedBusinessCategory.value = businessData['businessCategory'];
        businessType.value = businessData['businessCategory'];
        selectedBusinessType.value = businessData['businessCategory']; // Sync to selectedBusinessType for UI
        print('[LOAD] ✅ Business category: ${businessData['businessCategory']}');
      } else if (businessData['category'] != null) {
        selectedBusinessCategory.value = businessData['category'];
        businessType.value = businessData['category'];
        selectedBusinessType.value = businessData['category']; // Sync to selectedBusinessType for UI
        print('[LOAD] ✅ Business category (from category field): ${businessData['category']}');
      }
      
      // Also load businessType field if it exists (for 'single' vs 'chain' distinction)
      // Note: Don't confuse with selectedBusinessType which is 'restaurant' or 'grocery'
      if (businessData['businessType'] != null) {
        print('[LOAD] ✅ Business type (single/chain): ${businessData['businessType']}');
      }
      
      // Load location data
      if (businessData['location'] != null) {
        final location = businessData['location'];
        
        if (location['lat'] != null) {
          currentLat.value = (location['lat'] as num).toDouble();
        }
        
        if (location['lng'] != null) {
          currentLng.value = (location['lng'] as num).toDouble();
        }
        
        if (location['address'] != null) {
          registeredAddress.value = location['address'];
        }
        
        if (location['city'] != null) {
          cityController.text = location['city'];
        }
        
        // Update GPS display
        currentGPS.value = '${currentLat.value.toStringAsFixed(4)}° N, ${currentLng.value.toStringAsFixed(4)}° E';
        
        // Update map marker
        _updateMarker();
      }
      
      // Load logo if available
      if (businessData['logoUrl'] != null && businessData['logoUrl'].toString().isNotEmpty) {
        final logoUrl = businessData['logoUrl'].toString();
        logoPath.value = logoUrl;
        print('[LOAD] ✅ Logo URL loaded: $logoUrl');
        // Note: We can't set logoFile from URL, user would need to re-upload
      }
      
      // Load evidence gallery photos if available
      if (businessData['evidenceGallery'] != null) {
        final gallery = businessData['evidenceGallery'];
        print('[LOAD] Loading evidence gallery...');
        
        if (gallery['buildingExterior'] != null && gallery['buildingExterior'].toString().isNotEmpty) {
          buildingExteriorUrl.value = gallery['buildingExterior'];
          print('[LOAD] ✅ Building exterior URL loaded');
        }
        
        if (gallery['storeSignage'] != null && gallery['storeSignage'].toString().isNotEmpty) {
          storeSignageUrl.value = gallery['storeSignage'];
          print('[LOAD] ✅ Store signage URL loaded');
        }
        
        if (gallery['insideStore'] != null && gallery['insideStore'].toString().isNotEmpty) {
          insideStoreUrl.value = gallery['insideStore'];
          print('[LOAD] ✅ Inside store URL loaded');
        }
        
        _updatePhotoCount();
      }
      
      print('[LOAD] ✅ Form fields populated with saved data');
    } catch (e) {
      print('[LOAD] ❌ Error loading saved data: $e');
      // Continue with empty form - not a critical error
    }
  }

  // Business type selection methods
  void selectBusinessType(String type) {
    selectedBusinessType.value = type;
    // Map to backend businessCategory (already correct format from view)
    selectedBusinessCategory.value = type; // 'restaurant' or 'grocery'
  }

  Future<void> saveBusinessTypeAndContinue() async {
    if (selectedBusinessType.value.isEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      // For now, just save locally and navigate
      // We'll send all data in the business details step
      businessType.value = selectedBusinessType.value;
      
      // Navigate to business details step
      Get.to(() => const BusinessDetailsStepView());
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation methods - store data locally and move to next step
  Future<void> saveBusinessDetailsAndContinue() async {
    // Validate required fields
    if (businessNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your business name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a business description',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedBusinessCategory.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a business type first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create or update the business with basic details BEFORE moving to logo step
    // This allows logo to be uploaded immediately in the next step
    if (businessId.value.isEmpty) {
      try {
        isLoading.value = true;
        
        print('[BUSINESS DETAILS] Creating business...');
        final businessPayload = {
          'name': businessNameController.text.trim(),
          'businessCategory': selectedBusinessCategory.value, // restaurant or grocery
          'businessType': 'single',
          'location': {
            'lat': currentLat.value,
            'lng': currentLng.value,
            'address': registeredAddress.value,
            'city': cityController.text.trim().isNotEmpty ? cityController.text.trim() : 'Lagos',
            'country': 'Nigeria',
          },
          'description': descriptionController.text.trim(),
          if (businessEmailController.text.trim().isNotEmpty)
            'email': businessEmailController.text.trim(),
          if (businessPhoneController.text.trim().isNotEmpty)
            'phone': businessPhoneController.text.trim(),
          if (websiteController.text.trim().isNotEmpty)
            'website': websiteController.text.trim(),
        };

        final businessResponse = await _apiService.setupBusinessInfo(businessPayload);
        
        if (businessResponse == null || businessResponse['data'] == null) {
          throw Exception('Failed to create business - no data in response');
        }

        // Get business ID from response
        final createdBusinessId = businessResponse['data']?['_id'] ?? 
                                  businessResponse['business']?['_id'];
        
        if (createdBusinessId == null || createdBusinessId.isEmpty) {
          throw Exception('No business ID in response');
        }

        businessId.value = createdBusinessId;
        print('[BUSINESS DETAILS] ✅ Business created with ID: ${businessId.value}');
        
      } catch (e) {
        isLoading.value = false;
        print('[BUSINESS DETAILS] ❌ Failed to create business: $e');
        Get.snackbar(
          'Error',
          'Failed to create business: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      } finally {
        isLoading.value = false;
      }
    }

    // Navigate to logo step
    Get.to(() => const BusinessLogoStepView());
  }

  Future<void> saveLogoAndContinue() async {
    // If logo is selected and business already exists, upload it now
    if (logoFile.value != null && businessId.value.isNotEmpty) {
      try {
        isLoading.value = true;
        
        print('[LOGO] Uploading logo for business ${businessId.value}...');
        final logoUrl = await _apiService.uploadFile(
          logoFile.value!,
          folder: 'business/logos',
        );
        
        if (logoUrl != null) {
          print('[LOGO] Logo uploaded: $logoUrl');
          print('[LOGO] Updating business with logo URL...');
          
          await _apiService.updateBusinessDetails(businessId.value, {
            'logoUrl': logoUrl,
          });
          
          logoPath.value = logoUrl;
          print('[LOGO] ✅ Logo updated successfully');
          
          Get.snackbar(
            'Success',
            'Business logo uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          print('[LOGO] ⚠️ Logo upload returned null');
        }
      } catch (e) {
        print('[LOGO] ❌ Failed to upload logo: $e');
        Get.snackbar(
          'Warning',
          'Failed to upload logo, but you can continue',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
    
    // Navigate to next step (logo stored locally if business doesn't exist yet)
    Get.to(() => const BusinessLocationStepView());
  }

  Future<void> saveLocationAndContinue() async {
    // Update location data if business exists
    if (businessId.value.isNotEmpty) {
      try {
        isLoading.value = true;
        
        print('[LOCATION] Updating business location...');
        await _apiService.updateBusinessDetails(businessId.value, {
          'location': {
            'lat': currentLat.value,
            'lng': currentLng.value,
            'address': registeredAddress.value,
            'city': cityController.text.trim().isNotEmpty ? cityController.text.trim() : 'Lagos',
            'country': 'Nigeria',
          },
        });
        
        print('[LOCATION] ✅ Location updated successfully');
      } catch (e) {
        print('[LOCATION] ⚠️ Failed to update location but continuing: $e');
      } finally {
        isLoading.value = false;
      }
    }
    
    // Navigate to evidence step
    Get.to(() => const BusinessEvidenceStepView());
  }

  // Location methods
  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      currentGPS.value = '${position.latitude.toStringAsFixed(4)}° N, ${position.longitude.toStringAsFixed(4)}° E';

      // Get address from coordinates
      await _getAddressFromCoordinates(position.latitude, position.longitude);
      
      // Update marker
      _updateMarker();

      // Move camera to current location
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16.0,
        ),
      );

      Get.snackbar(
        'Location Updated',
        'Current location detected successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Failed to get current location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      print('[ADDRESS] Getting address from API for: $lat, $lng');
      
      // Call the API to get address
      final response = await _apiService.getAddressByLatLng(lat: lat, lng: lng);
      
      if (response != null && response['data'] != null) {
        final addressData = response['data'];
        
        // Extract address from response
        // Adjust these fields based on your actual API response structure
        final String? fullAddress = addressData['address'];
        final String? city = addressData['city'];
        final String? state = addressData['state'];
        
        if (fullAddress != null && fullAddress.isNotEmpty) {
          registeredAddress.value = fullAddress;
          print('[ADDRESS] ✅ Address retrieved: $fullAddress');
          
          // Update city if available
          if (city != null && city.isNotEmpty) {
            cityController.text = city;
          }
          
          // Update state if available
          if (state != null && state.isNotEmpty) {
            stateController.text = state;
          }
        } else {
          // Fallback to coordinates if no address in response
          registeredAddress.value = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}';
          print('[ADDRESS] ⚠️ No address in response, using coordinates');
        }
      } else {
        // Fallback to coordinates if API fails
        registeredAddress.value = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}';
        print('[ADDRESS] ⚠️ API returned null, using coordinates');
      }
    } catch (e) {
      print('[ADDRESS] ❌ Error getting address: $e');
      // Fallback to coordinates on error
      registeredAddress.value = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}';
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onMapTap(LatLng position) {
    currentLat.value = position.latitude;
    currentLng.value = position.longitude;
    currentGPS.value = '${position.latitude.toStringAsFixed(4)}° N, ${position.longitude.toStringAsFixed(4)}° E';
    
    _getAddressFromCoordinates(position.latitude, position.longitude);
    _updateMarker();
  }

  void _updateMarker() {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('business_location'),
        position: LatLng(currentLat.value, currentLng.value),
        infoWindow: InfoWindow(
          title: 'Business Location',
          snippet: registeredAddress.value,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
  }

  // Simple navigation methods (for skipping steps)
  void moveToLogoStep() {
    Get.to(() => const BusinessLogoStepView());
  }

  void moveToLocationStep() {
    Get.to(() => const BusinessLocationStepView());
  }

  void moveToEvidenceStep() {
    Get.to(() => const BusinessEvidenceStepView());
  }

  // Logo methods
  Future<void> pickLogo() async {
    try {
      isUploading.value = true;
      final file = await _fileUploadService.pickImageWithOptions(crop: false); // Temporarily disable crop
      if (file != null) {
        // Validate file size (max 5MB for logo)
        if (_fileUploadService.validateFileSize(file, maxSizeMB: 5)) {
          logoFile.value = file;
          logoPath.value = file.path;
          Get.snackbar(
            'Success',
            'Logo selected successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick logo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> takePhotoForLogo() async {
    try {
      isUploading.value = true;
      final file = await _fileUploadService.takePhoto(crop: false); // Temporarily disable crop
      if (file != null) {
        if (_fileUploadService.validateFileSize(file, maxSizeMB: 5)) {
          logoFile.value = file;
          logoPath.value = file.path;
          Get.snackbar(
            'Success',
            'Logo captured successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  // Evidence collection methods
  Future<void> uploadBuildingExterior() async {
    try {
      isUploading.value = true;
      final file = await _fileUploadService.pickImageWithOptions();
      if (file != null) {
        if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
          buildingExteriorPhoto.value = file;
          _updatePhotoCount();
          Get.snackbar(
            'Success',
            'Building exterior photo added',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> uploadStoreSignage() async {
    try {
      isUploading.value = true;
      final file = await _fileUploadService.pickImageWithOptions();
      if (file != null) {
        if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
          storeSignagePhoto.value = file;
          _updatePhotoCount();
          Get.snackbar(
            'Success',
            'Store signage photo added',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> uploadInsideStore() async {
    try {
      isUploading.value = true;
      final file = await _fileUploadService.pickImageWithOptions();
      if (file != null) {
        if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
          insideStorePhoto.value = file;
          _updatePhotoCount();
          Get.snackbar(
            'Success',
            'Inside store photo added',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  void _updatePhotoCount() {
    int count = 0;
    if (buildingExteriorPhoto.value != null || buildingExteriorUrl.value.isNotEmpty) count++;
    if (storeSignagePhoto.value != null || storeSignageUrl.value.isNotEmpty) count++;
    if (insideStorePhoto.value != null || insideStoreUrl.value.isNotEmpty) count++;
    uploadedPhotosCount.value = count;
  }

  // Submit business information - FINAL STEP - Upload evidence photos
  Future<void> submitBusinessInformation() async {
    // Validate all photos are either uploaded or already exist
    final hasAllPhotos = 
        (buildingExteriorPhoto.value != null || buildingExteriorUrl.value.isNotEmpty) &&
        (storeSignagePhoto.value != null || storeSignageUrl.value.isNotEmpty) &&
        (insideStorePhoto.value != null || insideStoreUrl.value.isNotEmpty);
    
    if (!hasAllPhotos) {
      Get.snackbar(
        'Required Photos',
        'Please upload all 3 required photos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Business should already exist from earlier steps
    if (businessId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Business ID not found. Please go back and complete business details.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSubmitting.value = true;
      
      print('[EVIDENCE] Business ID: ${businessId.value}');

      // Upload evidence photos (only upload new files, keep existing URLs)
      List<String> uploadedUrls = [];
      try {
        print('[EVIDENCE] Processing evidence photos...');
        
        // Collect photos to upload (only new files)
        List<File> photosToUpload = [];
        List<String> existingUrls = [];
        
        // Building exterior
        if (buildingExteriorPhoto.value != null) {
          photosToUpload.add(buildingExteriorPhoto.value!);
          existingUrls.add(''); // Placeholder for new upload
        } else {
          existingUrls.add(buildingExteriorUrl.value);
        }
        
        // Store signage
        if (storeSignagePhoto.value != null) {
          photosToUpload.add(storeSignagePhoto.value!);
          existingUrls.add(''); // Placeholder for new upload
        } else {
          existingUrls.add(storeSignageUrl.value);
        }
        
        // Inside store
        if (insideStorePhoto.value != null) {
          photosToUpload.add(insideStorePhoto.value!);
          existingUrls.add(''); // Placeholder for new upload
        } else {
          existingUrls.add(insideStoreUrl.value);
        }

        // Upload new photos if any
        if (photosToUpload.isNotEmpty) {
          print('[EVIDENCE] Uploading ${photosToUpload.length} new photo(s)...');
          final urls = await _apiService.uploadMultipleFiles(
            photosToUpload,
            folder: 'business/evidence',
          );

          if (urls != null && urls.length == photosToUpload.length) {
            print('[EVIDENCE] ✅ New photos uploaded (${urls.length})');
            
            // Merge new URLs with existing URLs
            int newUrlIndex = 0;
            for (int i = 0; i < existingUrls.length; i++) {
              if (existingUrls[i].isEmpty) {
                uploadedUrls.add(urls[newUrlIndex]);
                newUrlIndex++;
              } else {
                uploadedUrls.add(existingUrls[i]);
              }
            }
          } else {
            throw Exception('Failed to upload new photos');
          }
        } else {
          // No new photos, use all existing URLs
          print('[EVIDENCE] ✅ Using existing photos (no new uploads)');
          uploadedUrls = existingUrls;
        }
        
        if (uploadedUrls.length < 3) {
          throw Exception('Not all photos are available');
        }
      } catch (e) {
        throw Exception('Evidence photo processing failed: $e');
      }

      // Update business with evidence gallery
      if (uploadedUrls.length == 3) {
        try {
          print('[EVIDENCE] Updating business with evidence gallery...');
          await _apiService.updateBusinessDetails(businessId.value, {
            'evidenceGallery': {
              'buildingExterior': uploadedUrls[0],
              'storeSignage': uploadedUrls[1],
              'insideStore': uploadedUrls[2],
            },
          });
          print('[EVIDENCE] ✅ Evidence gallery updated');
        } catch (e) {
          print('[EVIDENCE] ⚠️ Evidence gallery update failed: $e');
          throw Exception('Failed to save evidence photos: $e');
        }
      } else {
        throw Exception('Expected 3 photos but got ${uploadedUrls.length}');
      }

      // Mark step as complete
      try {
        print('[EVIDENCE] Marking verification step as complete...');
        await _apiService.updateVerificationStep({
          'businessId': businessId.value,
          'step': 'business-information',
        });
        print('[EVIDENCE] ✅ Verification step marked complete');
      } catch (e) {
        print('[EVIDENCE] ⚠️ Verification step update failed but continuing: $e');
      }

      isSubmitting.value = false;

      // Show success message
      Get.snackbar(
        'Success',
        'Business information submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // Navigate back to business docs view
      print('[NAVIGATION] Going back to business docs...');
      await Future.delayed(Duration(seconds: 2));
      
      // Close the last 5 pages (Evidence -> Location -> Logo -> Details -> Type)
      // This takes us back to BusinessDocsView
      print('[NAVIGATION] Closing 5 pages...');
      Get.close(5);
      
    } catch (e, stackTrace) {
      isSubmitting.value = false;
      print('❌ SUBMISSION FAILED:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      
      Get.snackbar(
        'Error',
        'Failed to submit: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }

  Future<void> selectOpenTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      openTime.value = picked.format(context);
    }
  }

  Future<void> selectCloseTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      closeTime.value = picked.format(context);
    }
  }
}
