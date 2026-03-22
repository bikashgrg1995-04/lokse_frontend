import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/modules/learn/learn_model.dart';

import 'learn_controller.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LearnController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _LearnHeader(controller: controller)),

            // ── CATEGORY CHIPS ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: _CategoryChips(controller: controller),
              ),
            ),

            // ── POST SELECTOR slides in below chips ───────────
            SliverToBoxAdapter(
              child: Obx(() {
                final show = controller.isPostSpecificMode;
                return AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOut,
                  child: show
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: _PostSelector(controller: controller),
                        )
                      : const SizedBox.shrink(),
                );
              }),
            ),

            // ── UNIFIED SUBJECT GRID ──────────────────────────
            SliverToBoxAdapter(
              child: Obx(() {
                final all = controller.filteredSubjects;
                if (all.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Center(
                      child: Text(
                        'No subjects found.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: all.length,
                    itemBuilder: (_, i) {
                      final subject = all[i];
                      final isLocked = !subject.isFree && !subject.isUnlocked;
                      return isLocked
                          ? _LockedSubjectCard(
                              subject: subject,
                              onTap: () => controller.unlockSubject(subject),
                            )
                          : _UnlockedSubjectCard(
                              subject: subject,
                              onTap: () => controller.openSubject(subject),
                            );
                    },
                  ),
                );
              }),
            ),

            // ── EARN COINS ────────────────────────────────────
            const SliverToBoxAdapter(child: _EarnCoinsSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════
class _LearnHeader extends StatelessWidget {
  final LearnController controller;
  const _LearnHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3EBF), Color(0xFF4F6EF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learning Hub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Study materials for Loksewa',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Obx(() => _CoinBadge(coins: controller.userCoins.value)),
        ],
      ),
    );
  }
}

class _CoinBadge extends StatelessWidget {
  final int coins;
  const _CoinBadge({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            coins.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'coins',
            style: TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CATEGORY CHIPS
// ═══════════════════════════════════════════════════════════════
class _CategoryChips extends StatelessWidget {
  final LearnController controller;
  const _CategoryChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Obx(() {
        final selected = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final cat = controller.categories[i];
            final active = selected == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF1E3EBF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// POST SELECTOR — card, shown only under Post-Specific chip
// ═══════════════════════════════════════════════════════════════
class _PostSelector extends StatelessWidget {
  final LearnController controller;
  const _PostSelector({required this.controller});

  static final _posts = LoksewaPost.all.where((p) => p.id != 'all').toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 4,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3EBF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Select your post',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E3EBF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Wrap of post pills
          Obx(() {
            final selected = controller.selectedPostId.value;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _posts.map((post) {
                final active = selected == post.id;
                return GestureDetector(
                  onTap: () => controller.selectPost(post.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF1E3EBF)
                          : const Color(0xFFF4F6FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: active
                            ? const Color(0xFF1E3EBF)
                            : Colors.black.withOpacity(0.08),
                        width: active ? 1.5 : 0.5,
                      ),
                    ),
                    child: Text(
                      post.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// UNLOCKED SUBJECT CARD
// ═══════════════════════════════════════════════════════════════
class _UnlockedSubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;
  const _UnlockedSubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: subject.bgColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(subject.icon, color: subject.color, size: 16),
            ),
            const SizedBox(height: 6),
            Text(
              subject.name,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${subject.totalLessons} lessons',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: subject.progress,
                minHeight: 4,
                backgroundColor: const Color(0xFFEAEAEA),
                color: subject.color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${(subject.progress * 100).toInt()}% done',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// LOCKED SUBJECT CARD
// Icon + name always fully visible.
// Bottom amber strip shows coin cost + "Unlock →"
// ═══════════════════════════════════════════════════════════════
class _LockedSubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;
  const _LockedSubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top: icon + name fully visible ────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: subject.bgColor,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child:
                            Icon(subject.icon, color: subject.color, size: 16),
                      ),
                      const Spacer(),
                      // small lock badge top-right
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          size: 12,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    subject.name,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${subject.totalLessons} lessons',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ── Bottom strip: coin cost + Unlock ──────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBEB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${subject.coinCost} coins',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Unlock',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E3EBF),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 9,
                    color: Color(0xFF1E3EBF),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EARN COINS SECTION
// ═══════════════════════════════════════════════════════════════
class _EarnCoinsSection extends StatelessWidget {
  const _EarnCoinsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(
            'Ways to earn coins',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: EarnMethod.all.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _EarnMethodCard(method: EarnMethod.all[i]),
          ),
        ),
      ],
    );
  }
}

class _EarnMethodCard extends StatelessWidget {
  final EarnMethod method;
  const _EarnMethodCard({required this.method});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: handle earn action
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: method.bgColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(method.icon, color: method.color, size: 16),
            ),
            const SizedBox(height: 6),
            Text(
              method.title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              method.reward,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF059669),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
