import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/constants/app_sizes.dart';
import 'package:lokse/core/constants/app_strings.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/modules/learn/learn_model.dart';
import 'package:lokse/widgets/common_widgets.dart';
import 'learn_controller.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LearnController());
    final gc = GlobalController.instance;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with live coin badge
            SliverToBoxAdapter(
              child: GradientHeader(
                title: AppStrings.learningHub,
                subtitle: AppStrings.studyMaterials,
                trailing: const CoinBadge(dark: true),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: _CategoryChips(controller: c),
              ),
            ),

            // Post selector (Post-Specific only)
            SliverToBoxAdapter(
              child: Obx(() => AnimatedSize(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeInOut,
                    child: c.isPostSpecificMode
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                                AppSizes.lg, AppSizes.md, AppSizes.lg, 0),
                            child: _PostSelector(controller: c),
                          )
                        : const SizedBox.shrink(),
                  )),
            ),

            // Unified subject grid
            SliverToBoxAdapter(
              child: Obx(() {
                final all = c.filteredSubjects;
                if (all.isEmpty) {
                  return const EmptyState(
                      icon: Icons.menu_book_rounded,
                      message: AppStrings.noSubjects);
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSizes.lg, 14, AppSizes.lg, 0),
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
                      final s = all[i];
                      return (!s.isFree && !s.isUnlocked)
                          ? _LockedCard(
                              subject: s, onTap: () => c.unlockSubject(s))
                          : _UnlockedCard(
                              subject: s, onTap: () => c.openSubject(s));
                    },
                  ),
                );
              }),
            ),

            // Earn coins section
            SliverToBoxAdapter(
              child: _EarnSection(gc: gc),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxl)),
          ],
        ),
      ),
    );
  }
}

// ── CATEGORY CHIPS ────────────────────────────────────────────
class _CategoryChips extends StatelessWidget {
  final LearnController controller;
  const _CategoryChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Obx(() {
        final sel = controller.selectedCategory.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
          itemBuilder: (_, i) {
            final cat = controller.categories[i];
            final active = sel == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                    color: active ? Colors.transparent : AppColors.cardBorder,
                    width: 0.5,
                  ),
                ),
                child: Text(cat,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: active ? AppColors.white : AppColors.grey500)),
              ),
            );
          },
        );
      }),
    );
  }
}

// ── POST SELECTOR ─────────────────────────────────────────────
class _PostSelector extends StatelessWidget {
  final LearnController controller;
  const _PostSelector({required this.controller});

  static final _posts = LoksewaPost.all.where((p) => p.id != 'all').toList();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 4,
              height: 15,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXs)),
            ),
            const SizedBox(width: AppSizes.sm),
            const Text(AppStrings.selectPost,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ]),
          const SizedBox(height: AppSizes.md),
          Obx(() {
            final sel = controller.selectedPostId.value;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _posts.map((post) {
                final active = sel == post.id;
                return GestureDetector(
                  onTap: () => controller.selectPost(post.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.scaffold,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSm + 2),
                      border: Border.all(
                        color:
                            active ? AppColors.primary : AppColors.cardBorder,
                        width: active ? 1.5 : 0.5,
                      ),
                    ),
                    child: Text(post.label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                active ? AppColors.white : AppColors.grey600)),
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

// ── UNLOCKED CARD ─────────────────────────────────────────────
class _UnlockedCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;
  const _UnlockedCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(AppSizes.cardPadSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.subjectIcon,
              height: AppSizes.subjectIcon,
              decoration: BoxDecoration(
                  color: subject.bgColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm + 1)),
              child: Icon(subject.icon, color: subject.color, size: 16),
            ),
            const SizedBox(height: 6),
            Text(subject.name,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text('${subject.totalLessons} ${AppStrings.lessons}',
                style: const TextStyle(fontSize: 10, color: AppColors.grey400)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: subject.progress,
                  minHeight: 4,
                  backgroundColor: AppColors.grey200,
                  color: subject.color),
            ),
            const SizedBox(height: 3),
            Text('${(subject.progress * 100).toInt()}${AppStrings.done}',
                style: const TextStyle(fontSize: 10, color: AppColors.grey400)),
          ],
        ),
      ),
    );
  }
}

// ── LOCKED CARD ───────────────────────────────────────────────
class _LockedCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;
  const _LockedCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSizes.subjectIcon,
                        height: AppSizes.subjectIcon,
                        decoration: BoxDecoration(
                            color: subject.bgColor,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSm + 1)),
                        child:
                            Icon(subject.icon, color: subject.color, size: 16),
                      ),
                      const Spacer(),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                            color: AppColors.coinSurface,
                            borderRadius: BorderRadius.circular(7)),
                        child: const Icon(Icons.lock_rounded,
                            size: 12, color: AppColors.coin),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(subject.name,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${subject.totalLessons} ${AppStrings.lessons}',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.grey400)),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: const BoxDecoration(
                color: AppColors.coinSurface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSizes.radiusLg),
                  bottomRight: Radius.circular(AppSizes.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: AppColors.coin, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('${subject.coinCost} ${AppStrings.coins}',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coinText)),
                  const Spacer(),
                  const Text(AppStrings.unlock,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 9, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── EARN COINS ────────────────────────────────────────────────
class _EarnSection extends StatelessWidget {
  final GlobalController gc;
  const _EarnSection({required this.gc});

  @override
  Widget build(BuildContext context) {
    final methods = [
      _EarnData(
          AppStrings.dailyClaim,
          '+50 coins',
          Icons.calendar_today_rounded,
          AppColors.mediumDark,
          AppColors.mediumSurface),
      _EarnData(AppStrings.quizScore, '+10–100', Icons.quiz_rounded,
          AppColors.primary, AppColors.primarySurface),
      _EarnData(
          AppStrings.watchAd,
          '+30 coins',
          Icons.play_circle_outline_rounded,
          AppColors.success,
          AppColors.successSurface),
      _EarnData(AppStrings.referral, '+200 coins', Icons.people_rounded,
          const Color(0xFFDB2777), const Color(0xFFFDF2F8)),
      _EarnData(
          AppStrings.streakBonus,
          '+75 at 7d',
          Icons.local_fire_department_rounded,
          AppColors.success,
          AppColors.successSurface),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
              EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.xl, AppSizes.lg, 10),
          child: Text(AppStrings.earnCoins,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            itemCount: methods.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm + 2),
            itemBuilder: (_, i) {
              final m = methods[i];
              final isDaily = m.title == AppStrings.dailyClaim;
              return GestureDetector(
                onTap: isDaily ? gc.claimDailyReward : () {},
                child: Container(
                  width: 90,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: AppColors.cardBorder, width: 0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: m.bg,
                            borderRadius: BorderRadius.circular(9)),
                        child: Icon(m.icon, color: m.color, size: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(m.title,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(m.reward,
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.success,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EarnData {
  final String title, reward;
  final IconData icon;
  final Color color, bg;
  const _EarnData(this.title, this.reward, this.icon, this.color, this.bg);
}
