import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final profile = controller.profile;
        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        String imageUrl = profile.profileImageUrl.isNotEmpty
            ? (profile.profileImageUrl.contains('?')
                ? "${profile.profileImageUrl}&t=${DateTime.now().millisecondsSinceEpoch}"
                : "${profile.profileImageUrl}?t=${DateTime.now().millisecondsSinceEpoch}")
            : "";

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // ---------- Gradient Header ----------
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2643C5), Color(0xFF4F6EF7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(24)),
                    ),
                  ),

                  // ---------- Profile Avatar ----------
                  Positioned(
                    top: 80,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Hero(
                          tag: 'profileHero',
                          child: GestureDetector(
                            onTap: imageUrl.isNotEmpty
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenProfileImage(
                                            imageUrl: imageUrl),
                                      ),
                                    );
                                  }
                                : null,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: Colors.grey[100],
                                backgroundImage: imageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(imageUrl)
                                    : null,
                                child: imageUrl.isEmpty
                                    ? const Icon(Icons.person,
                                        size: 46, color: Colors.grey)
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        // Camera button
                        Positioned(
                          bottom: 0,
                          right: -4,
                          child: GestureDetector(
                            onTap: controller.isUpdating.value
                                ? null
                                : controller.updateProfileImage,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.blue,
                              child: controller.isUpdating.value
                                  ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.camera_alt,
                                      size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ---------- Full Name ----------
              Text(
                profile.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ---------- Personal Info Card ----------
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Row(
                        children: [
                          const Text(
                            "Personal Information",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          profile.isVerified
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.verified,
                                          color: Colors.green, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "Verified",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    // TODO: Trigger verification flow
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  child: const Text("Verify Now"),
                                ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Phone
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined,
                              color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(profile.phoneNumber.isNotEmpty
                              ? profile.phoneNumber
                              : "Not set"),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Email
                      Row(
                        children: [
                          const Icon(Icons.email_outlined,
                              color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(profile.email ?? "Not set"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------- Settings Card ----------
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _SettingsTile(
                        icon: Icons.palette,
                        title: "Change Theme",
                        onTap: () {
                          // TODO: Implement theme change
                        }),
                    _SettingsTile(
                        icon: Icons.lock_outline,
                        title: "Change Password",
                        onTap: () {
                          // TODO: Navigate to change password page
                        }),
                    _SettingsTile(
                        icon: Icons.logout,
                        title: "Logout",
                        onTap: () {
                          // TODO: Implement logout
                        }),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}

// ---------- Settings Tile ----------
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

// ---------- Full-screen profile image ----------
class FullScreenProfileImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenProfileImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: 'profileHero',
            child: InteractiveViewer(
              maxScale: 5.0,
              minScale: 1.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(color: Colors.white),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
