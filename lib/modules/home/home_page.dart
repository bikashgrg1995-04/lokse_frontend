import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lokse/modules/auth/profile/profile_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ──────────────────────────────────────────────
              _Header(profileController: profileController),

              // ── STATS ROW ────────────────────────────────────────────
              Transform.translate(
                offset: const Offset(0, -20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Expanded(
                          child: _StatCard(
                              value: '12',
                              label: 'Day Streak',
                              color: Color(0xFF1E3EBF))),
                      SizedBox(width: 10),
                      Expanded(
                          child: _StatCard(
                              value: '74%',
                              label: 'Accuracy',
                              color: Color(0xFF059669))),
                      SizedBox(width: 10),
                      Expanded(
                          child: _StatCard(
                              value: '320',
                              label: 'XP Points',
                              color: Color(0xFFD97706))),
                    ],
                  ),
                ),
              ),

              // ── DAILY CHALLENGE ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                child: _DailyChallenge(),
              ),

              // ── STREAK TRACKER ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                child: _StreakTracker(),
              ),

              // ── FEATURED TOPICS ──────────────────────────────────────
              _SectionHeader(title: 'Featured Topics', onTap: () {}),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                child: _FeaturedTopics(),
              ),

              // ── ANNOUNCEMENTS ────────────────────────────────────────
              _SectionHeader(title: 'Announcements', onTap: () {}),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                child: _Announcements(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final ProfileController profileController;
  const _Header({required this.profileController});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 44),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3EBF), Color(0xFF4F6EF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  final profile = profileController.profile;
                  final name = profile?.fullName ?? 'Guest';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ADE80),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Loksewa Aspirant',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(width: 12),
              Obx(() {
                final profile = profileController.profile;
                final imageUrl = profile?.profileImageUrl ?? '';
                final initials = (profile?.fullName.isNotEmpty == true)
                    ? profile!.fullName[0].toUpperCase()
                    : 'U';
                return CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl)
                      : null,
                  child: imageUrl.isEmpty
                      ? Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        )
                      : null,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STAT CARD
// ═══════════════════════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DAILY CHALLENGE
// ═══════════════════════════════════════════════════════════════
class _DailyChallenge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3EBF), Color(0xFF4F6EF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DAILY CHALLENGE',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Complete today's quiz set",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '15 questions left',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: navigate to quiz
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Start now',
                        style: TextStyle(
                          color: Color(0xFF1E3EBF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STREAK TRACKER
// ═══════════════════════════════════════════════════════════════
class _StreakTracker extends StatelessWidget {
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    // Assume today is Friday (index 4), so first 5 days are complete
    const completedDays = 5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This week',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                '12 day streak 🔥',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
                      color: done
                          ? const Color(0xFF1E3EBF)
                          : const Color(0xFFF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: done
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FEATURED TOPICS
// ═══════════════════════════════════════════════════════════════
class _FeaturedTopics extends StatelessWidget {
  static const _topics = [
    _TopicData(
        label: 'General Knowledge',
        icon: Icons.public,
        progress: 0.65,
        color: Color(0xFF1E3EBF),
        bg: Color(0xFFEEF1FB)),
    _TopicData(
        label: 'Nepali History',
        icon: Icons.history_edu,
        progress: 0.40,
        color: Color(0xFF059669),
        bg: Color(0xFFECFDF5)),
    _TopicData(
        label: 'Arithmetic',
        icon: Icons.calculate,
        progress: 0.55,
        color: Color(0xFFD97706),
        bg: Color(0xFFFFFBEB)),
    _TopicData(
        label: 'Constitution',
        icon: Icons.account_balance,
        progress: 0.30,
        color: Color(0xFF7C3AED),
        bg: Color(0xFFF5F3FF)),
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

class _TopicData {
  final String label;
  final IconData icon;
  final double progress;
  final Color color;
  final Color bg;

  const _TopicData({
    required this.label,
    required this.icon,
    required this.progress,
    required this.color,
    required this.bg,
  });
}

class _TopicCard extends StatelessWidget {
  final _TopicData topic;
  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO: navigate to topic
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: topic.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(topic.icon, color: topic.color, size: 18),
            ),
            const Spacer(),
            Text(
              topic.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: topic.progress,
                minHeight: 4,
                backgroundColor: const Color(0xFFF0F0F0),
                color: topic.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(topic.progress * 100).toInt()}% complete',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ANNOUNCEMENTS
// ═══════════════════════════════════════════════════════════════
class _Announcements extends StatelessWidget {
  static const _items = [
    _AnnouncementData(
        title: 'New mock test added',
        subtitle: 'Lok Sewa PSC — Officer Level',
        tag: 'New',
        tagColor: Color(0xFF1E3EBF),
        tagBg: Color(0xFFEEF1FB)),
    _AnnouncementData(
        title: 'Result published',
        subtitle: 'Section Officer Written — 2080',
        tag: 'Result',
        tagColor: Color(0xFF059669),
        tagBg: Color(0xFFECFDF5)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items
          .map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _AnnouncementCard(data: a),
              ))
          .toList(),
    );
  }
}

class _AnnouncementData {
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final Color tagBg;

  const _AnnouncementData({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
  });
}

class _AnnouncementCard extends StatelessWidget {
  final _AnnouncementData data;
  const _AnnouncementCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO: navigate to announcement detail
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: data.tagBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                data.tag,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: data.tagColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SECTION HEADER HELPER
// ═══════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SectionHeader({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'See all',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF1E3EBF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
