import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/modules/auth/profile/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.put(ProfileController());
    final gc = GlobalController.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      // ── No outer Obx — each child manages its own reactivity ──
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── SLIVER APP BAR with profile ──────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _ProfileHeader(pc: pc, gc: gc),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
          ),

          // Loading overlay sliver
          SliverToBoxAdapter(
            child: Obx(() {
              if (pc.isLoading.value && pc.rxProfile.value == null) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)),
                );
              }
              return const SizedBox.shrink();
            }),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // ── STATS GRID — reactive inside widget ──────
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: _StatsGrid(),
                ),

                const SizedBox(height: 16),

                // ── XP PROGRESS — reactive inside widget ─────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _XpProgressCard(),
                ),

                const SizedBox(height: 16),

                // ── STREAK CALENDAR — reactive inside widget ──
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _StreakCard(),
                ),

                const SizedBox(height: 16),

                // ── ACHIEVEMENTS (static) ─────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _AchievementsCard(),
                ),

                const SizedBox(height: 16),

                // ── ACCOUNT INFO — reactive inside widget ─────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _AccountCard(),
                ),

                const SizedBox(height: 16),

                // ── SETTINGS ─────────────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _SettingsCard(),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── PROFILE HEADER ─────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final ProfileController pc;
  final GlobalController gc;
  const _ProfileHeader({required this.pc, required this.gc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1628), Color(0xFF0F2354), Color(0xFF1E3EBF)],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(painter: _HeaderPatternPainter()),
          ),

          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Avatar
                  Obx(() {
                    final imageUrl = pc.rxProfile.value?.profileImageUrl ?? '';
                    final name = pc.rxProfile.value?.fullName ?? '';
                    final initials =
                        name.isNotEmpty ? name[0].toUpperCase() : 'U';
                    final isUpdating = pc.isUpdating.value;

                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Outer ring
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1E3EBF).withOpacity(0.5),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: imageUrl.isNotEmpty
                                ? () => _openFullScreenImage(context, imageUrl)
                                : null,
                            child: Hero(
                              tag: 'profileHero',
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: Colors.white.withOpacity(0.15),
                                backgroundImage: imageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(imageUrl)
                                    : null,
                                child: imageUrl.isEmpty
                                    ? Text(
                                        initials,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        // Camera button
                        GestureDetector(
                          onTap: isUpdating ? null : pc.updateProfileImage,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isUpdating
                                ? const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1.5, color: Colors.white),
                                  )
                                : const Icon(Icons.camera_alt_rounded,
                                    size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 14),

                  // Name + verification
                  Obx(() {
                    final name = pc.rxProfile.value?.fullName ?? 'Guest';
                    final isVerified = pc.rxProfile.value?.isVerified ?? false;
                    final email = pc.rxProfile.value?.email ?? '';
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded,
                                  color: Color(0xFF60A5FA), size: 20),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // XP Tier badge — gc.totalXp.value tracked by parent Obx
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_events_rounded,
                                  color: Color(0xFFF59E0B), size: 14),
                              const SizedBox(width: 6),
                              Text(
                                // Access .value here so parent Obx tracks it
                                GlobalController.instance.xpTier,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Hero(
                tag: 'profileHero',
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, __) =>
                        const CircularProgressIndicator(color: Colors.white),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── STATS GRID ─────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    final gc = GlobalController.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Your Stats', icon: Icons.bar_chart_rounded),
        const SizedBox(height: 12),
        Obx(() => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _StatTile(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFF97316),
                  iconBg: const Color(0xFFFFF7ED),
                  value: '${gc.currentStreak.value}',
                  label: 'Day Streak',
                  suffix: '🔥',
                ),
                _StatTile(
                  icon: Icons.monetization_on_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFEF3C7),
                  value: '${gc.totalCoins.value}',
                  label: 'Coins',
                ),
                _StatTile(
                  icon: Icons.bolt_rounded,
                  iconColor: AppColors.xp,
                  iconBg: const Color(0xFFEDE9FE),
                  value: '${gc.totalXp.value}',
                  label: 'XP Points',
                ),
                _StatTile(
                  icon: Icons.gps_fixed_rounded,
                  iconColor: AppColors.success,
                  iconBg: AppColors.easySurface,
                  value: gc.accuracyPct,
                  label: 'Accuracy',
                ),
              ],
            )),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String value, label;
  final String? suffix;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF000000).withOpacity(0.06), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                suffix != null ? '$value$suffix' : value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.grey400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── XP PROGRESS CARD ──────────────────────────────────────────
class _XpProgressCard extends StatelessWidget {
  const _XpProgressCard();

  static const _tiers = [
    _TierData('Beginner', 0, 500, Color(0xFF94A3B8)),
    _TierData('Learner', 500, 2000, Color(0xFF22C55E)),
    _TierData('Practitioner', 2000, 5000, Color(0xFF3B82F6)),
    _TierData('Expert', 5000, 10000, Color(0xFF8B5CF6)),
    _TierData('Master', 10000, 15000, Color(0xFFF59E0B)),
  ];

  _TierData _currentTier(int xp) {
    for (final t in _tiers.reversed) {
      if (xp >= t.minXp) return t;
    }
    return _tiers.first;
  }

  _TierData? _nextTier(int xp) {
    for (int i = 0; i < _tiers.length; i++) {
      if (xp < _tiers[i].minXp) return _tiers[i];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final gc = GlobalController.instance;
    return Obx(() {
      final xp = gc.totalXp.value;
      final tier = _currentTier(xp);
      final next = _nextTier(xp);
      final progress = next == null
          ? 1.0
          : (xp - tier.minXp) / (next.minXp - tier.minXp).toDouble();

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: const Color(0xFF000000).withOpacity(0.06), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: tier.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.bolt_rounded, color: tier.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: tier.color,
                        ),
                      ),
                      Text(
                        '$xp XP total',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.grey400),
                      ),
                    ],
                  ),
                ),
                if (next != null)
                  Text(
                    '${next.minXp - xp} XP to ${next.name}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Tier progress row
            Row(
              children: _tiers.map((t) {
                final isActive = xp >= t.minXp;
                final isCurrent = t.name == tier.name;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive ? t.color : AppColors.grey100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      if (t != _tiers.last) const SizedBox(width: 3),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _tiers.map((t) {
                final isCurrent = t.name == tier.name;
                return Text(
                  t.name.substring(0, 3),
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrent ? tier.color : AppColors.grey300,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }); // end Obx
  }
}

class _TierData {
  final String name;
  final int minXp, maxXp;
  final Color color;
  const _TierData(this.name, this.minXp, this.maxXp, this.color);
}

// ── STREAK CARD ────────────────────────────────────────────────
class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    final gc = GlobalController.instance;
    return Obx(() {
      final streak = gc.currentStreak.value;
      final completedDays = (streak % 7).clamp(0, 7);
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: const Color(0xFF000000).withOpacity(0.06), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_fire_department_rounded,
                      color: Color(0xFFF97316), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Daily Streak',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827))),
                      Text('$streak consecutive days 🔥',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.grey400)),
                    ],
                  ),
                ),
                // Milestone
                if (streak >= 7)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${streak ~/ 7}w 🏆',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF97316)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final done = i < completedDays;
                final isToday = i == completedDays - 1 && completedDays > 0;
                return Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: done
                            ? (isToday
                                ? const Color(0xFFF97316)
                                : AppColors.primary)
                            : AppColors.grey100,
                        shape: BoxShape.circle,
                        boxShadow: done
                            ? [
                                BoxShadow(
                                  color: (isToday
                                          ? const Color(0xFFF97316)
                                          : AppColors.primary)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: done
                          ? Icon(
                              isToday
                                  ? Icons.local_fire_department_rounded
                                  : Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      days[i].substring(0, 1),
                      style: TextStyle(
                        fontSize: 10,
                        color: done ? AppColors.primary : AppColors.grey300,
                        fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                );
              }),
            ),
            if (streak > 0 && streak % 7 == 0) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFF97316).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.celebration_rounded,
                        color: Color(0xFFF97316), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '$streak-day streak! Bonus +75 coins claimed 🎉',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }); // end Obx
  }
}

// ── ACHIEVEMENTS CARD ──────────────────────────────────────────
class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard();

  static const _achievements = [
    _AchievData('First Quiz', Icons.quiz_rounded, Color(0xFF3B82F6),
        Color(0xFFEFF6FF), true),
    _AchievData('7-Day Streak', Icons.local_fire_department_rounded,
        Color(0xFFF97316), Color(0xFFFFF7ED), false),
    _AchievData('100 Questions', Icons.check_circle_rounded, Color(0xFF22C55E),
        Color(0xFFF0FDF4), true),
    _AchievData('Top Scorer', Icons.emoji_events_rounded, Color(0xFFF59E0B),
        Color(0xFFFEF9C3), false),
    _AchievData('Study 5 Days', Icons.school_rounded, Color(0xFF8B5CF6),
        Color(0xFFF5F3FF), true),
    _AchievData('500 XP', Icons.bolt_rounded, Color(0xFF6366F1),
        Color(0xFFEEF2FF), true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: const Color(0xFF000000).withOpacity(0.06), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
              title: 'Achievements', icon: Icons.emoji_events_rounded),
          const SizedBox(height: 14),
          Text(
            '${_achievements.where((a) => a.earned).length}/${_achievements.length} earned',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
            children: _achievements.map((a) => _AchievBadge(data: a)).toList(),
          ),
        ],
      ),
    );
  }
}

class _AchievData {
  final String label;
  final IconData icon;
  final Color color, bg;
  final bool earned;
  const _AchievData(this.label, this.icon, this.color, this.bg, this.earned);
}

class _AchievBadge extends StatelessWidget {
  final _AchievData data;
  const _AchievBadge({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: data.earned ? data.bg : AppColors.grey100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  data.earned ? data.color.withOpacity(0.2) : AppColors.grey200,
              width: 1.5,
            ),
            boxShadow: data.earned
                ? [
                    BoxShadow(
                      color: data.color.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                data.icon,
                color: data.earned ? data.color : AppColors.grey300,
                size: 26,
              ),
              if (!data.earned)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.lock_rounded,
                      size: 16, color: AppColors.grey300),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: data.earned ? const Color(0xFF374151) : AppColors.grey300,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ── ACCOUNT CARD ──────────────────────────────────────────────
class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProfileController>();
    return Obx(() {
      final profile = pc.rxProfile.value;
      final isVerified = profile?.isVerified ?? false;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: const Color(0xFF000000).withOpacity(0.06), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _SectionTitle(
                    title: 'Account', icon: Icons.manage_accounts_rounded),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showEditSheet(context, pc),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: 'Full Name',
              value: profile?.fullName.isNotEmpty == true
                  ? profile!.fullName
                  : 'Not set',
            ),
            const _Divider(),
            _InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profile?.email ?? '',
              trailing: isVerified
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.easySurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Verified',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.success,
                              fontWeight: FontWeight.w700)),
                    )
                  : GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.warningSurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Verify',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
            ),
            const _Divider(),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: profile?.phoneNumber.isNotEmpty == true
                  ? profile!.phoneNumber
                  : 'Not set',
            ),
          ],
        ),
      );
    }); // end Obx
  }

  void _showEditSheet(BuildContext context, ProfileController pc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(pc: pc),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Widget? trailing;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.grey400),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.grey400)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937))),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Divider(color: AppColors.grey100, thickness: 1, height: 1);
  }
}

// ── SETTINGS CARD ─────────────────────────────────────────────
class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    final gc = GlobalController.instance;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: const Color(0xFF000000).withOpacity(0.06), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.palette_outlined,
            iconColor: const Color(0xFF8B5CF6),
            iconBg: const Color(0xFFF5F3FF),
            title: 'Theme',
            onTap: () {},
          ),
          _DividerLine(),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBg: const Color(0xFFEFF6FF),
            title: 'Notifications',
            onTap: () {},
          ),
          _DividerLine(),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            iconColor: const Color(0xFF22C55E),
            iconBg: const Color(0xFFF0FDF4),
            title: 'Change Password',
            onTap: () {},
          ),
          _DividerLine(),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFEF9C3),
            title: 'Help & Support',
            onTap: () {},
          ),
          _DividerLine(),
          _SettingsTile(
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            iconBg: AppColors.hardSurface,
            title: 'Logout',
            titleColor: AppColors.error,
            onTap: () => _confirmLogout(context, gc),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, GlobalController gc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:
            const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
            'Are you sure you want to logout? Your progress will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.grey400)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              gc.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
        color: AppColors.grey100,
        thickness: 1,
        height: 1,
        indent: 16,
        endIndent: 16);
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? const Color(0xFF1F2937),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.grey300),
          ],
        ),
      ),
    );
  }
}

// ── EDIT PROFILE BOTTOM SHEET ────────────────────────────────
class _EditProfileSheet extends StatelessWidget {
  final ProfileController pc;
  const _EditProfileSheet({required this.pc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Edit Profile',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827))),
          const SizedBox(height: 20),

          // Full name
          _EditField(
            label: 'Full Name',
            controller: pc.fullNameController,
            icon: Icons.person_outline_rounded,
            hint: 'Your full name',
          ),
          const SizedBox(height: 16),

          // Phone
          _EditField(
            label: 'Phone Number',
            controller: pc.phoneController,
            icon: Icons.phone_outlined,
            hint: '98XXXXXXXX',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),

          // Save button
          Obx(() => GestureDetector(
                onTap: pc.isUpdating.value
                    ? null
                    : () async {
                        await pc.updateProfile();
                        Get.back();
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: pc.isUpdating.value
                          ? [AppColors.grey300, AppColors.grey300]
                          : [const Color(0xFF1E3EBF), const Color(0xFF4F6EF7)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: pc.isUpdating.value
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Center(
                    child: pc.isUpdating.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;

  const _EditField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.grey200, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.grey400, fontSize: 14),
              prefixIcon: Icon(icon, color: AppColors.grey400, size: 18),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ── SECTION TITLE ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
