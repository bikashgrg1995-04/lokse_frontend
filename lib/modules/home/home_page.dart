import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/constants/app_sizes.dart';
import 'package:lokse/core/constants/app_strings.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/modules/auth/profile/profile_controller.dart';
import 'package:lokse/widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<ProfileController>();
    final gc = GlobalController.instance;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Obx(() {
          // ✅ OPTIONAL loading state
          if (profile.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HomeHeader(profile: profile, gc: gc),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    child: Obx(() => Row(
                          children: [
                            Expanded(
                                child: _StatCard(
                                    value: '${gc.currentStreak.value}',
                                    label: AppStrings.dayStreak,
                                    color: AppColors.primary)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _StatCard(
                                    value: gc.accuracyPct,
                                    label: AppStrings.accuracy,
                                    color: AppColors.success)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _StatCard(
                                    value: '${gc.totalCoins.value}',
                                    label: AppStrings.coins,
                                    color: AppColors.mediumDark)),
                          ],
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: _DailyChallenge(gc: gc),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                  child:
                      Obx(() => _StreakTracker(streak: gc.currentStreak.value)),
                ),
                SectionHeader(
                    title: AppStrings.featuredTopics,
                    actionLabel: AppStrings.seeAll,
                    onAction: () {}),
                const Padding(
                  padding: EdgeInsets.all(AppSizes.lg),
                  child: _FeaturedTopics(),
                ),
                SectionHeader(
                    title: AppStrings.announcements,
                    actionLabel: AppStrings.seeAll,
                    onAction: () {}),
                const Padding(
                  padding: EdgeInsets.only(
                      left: AppSizes.lg,
                      right: AppSizes.lg,
                      bottom: AppSizes.xxl),
                  child: _Announcements(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final ProfileController profile;
  final GlobalController gc;

  const _HomeHeader({required this.profile, required this.gc});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final p = profile.rxProfile.value;

      final name = p?.fullName ?? 'Guest';
      final imageUrl = p?.profileImageUrl ?? '';
      final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
            AppSizes.xl, AppSizes.xxl, AppSizes.xl, 44),
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_greeting(),
                      style: TextStyle(
                          color: AppColors.white.withOpacity(0.65),
                          fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(name,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.circle,
                          size: 6, color: Color(0xFF4ADE80)),
                      const SizedBox(width: 6),
                      Text(AppStrings.aspirant,
                          style: TextStyle(
                              color: AppColors.white.withOpacity(0.55),
                              fontSize: 12)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: Text(gc.xpTier,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSizes.md),

            // ✅ FIXED Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.white.withOpacity(0.2),
              backgroundImage: imageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Text(initials,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18))
                  : null,
            ),
          ],
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatCard(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSizes.md, horizontal: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(color: AppColors.grey400, fontSize: 11),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DailyChallenge extends StatelessWidget {
  final GlobalController gc;
  const _DailyChallenge({required this.gc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg + 2),
      decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.dailyChallenge,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          const Text(AppStrings.todayQuizSet,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                child: const Text('15 questions left',
                    style: TextStyle(color: AppColors.white, fontSize: 12)),
              ),
              Obx(() => GestureDetector(
                    onTap: gc.canClaimDaily.value ? gc.claimDailyReward : () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusSm)),
                      child: Text(
                        gc.canClaimDaily.value
                            ? 'Claim +50 🪙'
                            : AppStrings.startNow,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakTracker extends StatelessWidget {
  final int streak;
  const _StreakTracker({required this.streak});
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final completedDays = (streak % 7).clamp(0, 7);
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(AppStrings.thisWeek,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text('$streak day streak 🔥',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumDark,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_days.length, (i) {
              final done = i < completedDays;
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: done ? AppColors.primary : AppColors.grey100,
                        shape: BoxShape.circle),
                    child: done
                        ? const Icon(Icons.check,
                            color: AppColors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(height: 5),
                  Text(_days[i],
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.grey400)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FeaturedTopics extends StatelessWidget {
  const _FeaturedTopics();
  static const _topics = [
    _Topic('General Knowledge', Icons.public, 0.65, AppColors.primary,
        AppColors.primarySurface),
    _Topic('Nepali History', Icons.history_edu, 0.40, AppColors.success,
        AppColors.successSurface),
    _Topic('Arithmetic', Icons.calculate, 0.55, AppColors.mediumDark,
        AppColors.mediumSurface),
    _Topic('Constitution', Icons.account_balance, 0.30, AppColors.bossDark,
        AppColors.bossSurface),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _topics.map((t) => _TopicCard(topic: t)).toList(),
    );
  }
}

class _Topic {
  final String label;
  final IconData icon;
  final double progress;
  final Color color, bg;
  const _Topic(this.label, this.icon, this.progress, this.color, this.bg);
}

class _TopicCard extends StatelessWidget {
  final _Topic topic;
  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: topic.bg,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
              child: Icon(topic.icon, color: topic.color, size: 18),
            ),
            const Spacer(),
            Text(topic.label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: topic.progress,
                  minHeight: 4,
                  backgroundColor: AppColors.grey100,
                  color: topic.color),
            ),
            const SizedBox(height: 4),
            Text('${(topic.progress * 100).toInt()}% complete',
                style: const TextStyle(fontSize: 10, color: AppColors.grey400)),
          ],
        ),
      ),
    );
  }
}

class _Announcements extends StatelessWidget {
  const _Announcements();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AnnouncementCard(
            title: 'New mock test added',
            subtitle: 'Lok Sewa PSC — Officer Level',
            tag: 'New',
            tagColor: AppColors.primary,
            tagBg: AppColors.primarySurface),
        SizedBox(height: 8),
        _AnnouncementCard(
            title: 'Result published',
            subtitle: 'Section Officer Written — 2080',
            tag: 'Result',
            tagColor: AppColors.success,
            tagBg: AppColors.successSurface),
      ],
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title, subtitle, tag;
  final Color tagColor, tagBg;
  const _AnnouncementCard(
      {required this.title,
      required this.subtitle,
      required this.tag,
      required this.tagColor,
      required this.tagBg});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {},
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.grey400)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: tagBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm - 2)),
            child: Text(tag,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: tagColor)),
          ),
        ],
      ),
    );
  }
}
