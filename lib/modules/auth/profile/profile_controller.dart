import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import 'package:lokse/core/utils/api_config.dart';
import 'package:lokse/core/utils/dio_client.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/modules/auth/profile/profile_model.dart';

class ProfileController extends GetxController {
  // ================= STATE =================
  final rxProfile = Rxn<ProfileModel>();

  final isLoading = false.obs;
  final isUpdating = false.obs;

  // ================= FORM =================
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();

    // Sync form fields
    ever(rxProfile, (ProfileModel? p) {
      if (p != null) {
        fullNameController.text = p.fullName;
        phoneController.text = p.phoneNumber;
      }
    });
  }

  // ================= FETCH =================
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final res = await DioClient.client.get(ApiConfig.profile);

      rxProfile.value = ProfileModel.fromJson({
        ...res.data,
        "profile_image_url":
            "${res.data['profile_image_url']}?t=${DateTime.now().millisecondsSinceEpoch}",
      });
    } catch (e) {
      StatusMessage.error("Failed to load profile");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPDATE INFO =================
  Future<void> updateProfile() async {
    if (rxProfile.value == null) return;

    isUpdating.value = true;
    try {
      final res = await DioClient.client.patch(
        ApiConfig.profile,
        data: {
          "full_name": fullNameController.text.trim(),
          "phone_number": phoneController.text.trim(),
        },
      );

      rxProfile.value = rxProfile.value!.copyWith(
        fullName: res.data['full_name'],
        phoneNumber: res.data['phone_number'],
        profileImageUrl:
            "${res.data['profile_image_url']}?t=${DateTime.now().millisecondsSinceEpoch}",
        isVerified: res.data['is_verified'],
      );

      StatusMessage.success("Profile updated");
    } catch (e) {
      StatusMessage.error("Failed to update profile");
    } finally {
      isUpdating.value = false;
    }
  }

  // ================= UPDATE IMAGE =================
  Future<void> updateProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    isUpdating.value = true;
    try {
      final file = File(picked.path);

      final formData = dio.FormData.fromMap({
        "profile_image": await dio.MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final res = await DioClient.client.patch(
        ApiConfig.profile,
        data: formData,
        options: dio.Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      rxProfile.value = rxProfile.value!.copyWith(
        profileImageUrl:
            "${res.data['profile_image_url']}?t=${DateTime.now().millisecondsSinceEpoch}",
        isVerified: res.data['is_verified'],
      );

      StatusMessage.success("Profile photo updated");
    } catch (e) {
      StatusMessage.error("Failed to update photo");
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
