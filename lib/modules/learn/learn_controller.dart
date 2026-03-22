import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/modules/learn/learn_model.dart';

class LearnController extends GetxController {
  // ── State ──────────────────────────────────────────────────
  final selectedPostId = 'kharidar'.obs;
  final selectedCategory = 'All'.obs;
  final userCoins = 1240.obs;
  final subjects = <SubjectModel>[].obs;

  final categories = ['All', 'General', 'Post-Specific'];

  @override
  void onInit() {
    super.onInit();
    subjects.assignAll(SubjectModel.defaults);
  }

  // ── True when post selector should be visible ──────────────
  bool get isPostSpecificMode => selectedCategory.value == 'Post-Specific';

  // ── Filtered subjects ──────────────────────────────────────
  List<SubjectModel> get filteredSubjects {
    final cat = selectedCategory.value;
    final post = selectedPostId.value;

    return subjects.where((s) {
      // Category filter
      if (cat == 'General') {
        // Only subjects with no post restriction
        if (s.applicablePosts.isNotEmpty) return false;
      } else if (cat == 'Post-Specific') {
        // Only subjects tied to specific posts, AND matching selected post
        if (s.applicablePosts.isEmpty) return false;
        if (post != 'all' && !s.applicablePosts.contains(post)) return false;
      } else {
        // 'All' — show everything, but post-specific only if post matches
        if (s.applicablePosts.isNotEmpty &&
            post != 'all' &&
            !s.applicablePosts.contains(post)) return false;
      }
      return true;
    }).toList();
  }

  List<SubjectModel> get freeSubjects =>
      filteredSubjects.where((s) => s.isFree || s.isUnlocked).toList();

  List<SubjectModel> get lockedSubjects =>
      filteredSubjects.where((s) => !s.isFree && !s.isUnlocked).toList();

  // ── Select post ────────────────────────────────────────────
  void selectPost(String postId) => selectedPostId.value = postId;

  // ── Select category chip ───────────────────────────────────
  void selectCategory(String cat) {
    selectedCategory.value = cat;
    // When switching away from Post-Specific, reset to 'all'
    // so 'All' tab shows everything correctly
    if (cat != 'Post-Specific') selectedPostId.value = 'all';
    // When entering Post-Specific, default to kharidar
    if (cat == 'Post-Specific') selectedPostId.value = 'kharidar';
  }

  // ── Unlock subject ─────────────────────────────────────────
  Future<void> unlockSubject(SubjectModel subject) async {
    if (subject.isUnlocked || subject.isFree) return;

    if (userCoins.value < subject.coinCost) {
      _showInsufficientCoinsDialog(subject);
      return;
    }

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Unlock Subject'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: subject.bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(subject.icon, color: subject.color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              subject.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This will cost ${subject.coinCost} coins. You have ${userCoins.value} coins.',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3EBF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.toll_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  'Unlock for ${subject.coinCost}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    userCoins.value -= subject.coinCost;
    final idx = subjects.indexWhere((s) => s.id == subject.id);
    if (idx != -1) {
      subjects[idx] = subjects[idx].copyWith(isUnlocked: true);
      subjects.refresh();
    }

    StatusMessage.success('${subject.name} unlocked!');
  }

  void _showInsufficientCoinsDialog(SubjectModel subject) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Not enough coins'),
        content: Text(
          'You need ${subject.coinCost} coins to unlock ${subject.name}. '
          'You currently have ${userCoins.value} coins.\n\n'
          'Earn more coins through daily rewards, quiz scores, or watching ads.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // TODO: navigate to earn coins screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child:
                const Text('Earn Coins', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Navigate into subject ──────────────────────────────────
  void openSubject(SubjectModel subject) {
    if (!subject.isFree && !subject.isUnlocked) {
      unlockSubject(subject);
      return;
    }
    // TODO: Get.toNamed(AppRoutes.subjectDetail, arguments: subject)
    StatusMessage.info('Opening ${subject.name}…');
  }
}
