import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      icon: Icons.directions_car_rounded,
      iconColor: AppColors.onlineGreen,
      title: 'New Ride Request',
      subtitle: 'A passenger is requesting a ride from 123 Main St. to Rizal Boulevard.',
      time: '2 min ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.star_rounded,
      iconColor: const Color(0xFFFFC107),
      title: 'New Rating Received',
      subtitle: 'You received a 5-star rating from your last passenger. Great job!',
      time: '15 min ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.campaign_rounded,
      iconColor: AppColors.accentBlue,
      title: 'Promotion: Weekend Bonus',
      subtitle: 'Earn extra ₱200 for completing 10 trips this weekend!',
      time: '1 hour ago',
      isUnread: true,
    ),
    _NotificationItem(
      icon: Icons.update_rounded,
      iconColor: AppColors.primaryNavy,
      title: 'System Update',
      subtitle: 'TODA GO Driver app v2.1 is now available. Update for new features.',
      time: '3 hours ago',
      isUnread: false,
    ),
    _NotificationItem(
      icon: Icons.account_balance_wallet_rounded,
      iconColor: AppColors.onlineGreen,
      title: 'Daily Earnings Summary',
      subtitle: 'You earned ₱1,250.00 today from 12 completed trips.',
      time: 'Yesterday',
      isUnread: false,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isUnread: false);
      }
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '✅ All notifications marked as read',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        backgroundColor: AppColors.onlineGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => n.isUnread).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 18,
              left: 4,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Notifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (unreadCount > 0)
                  GestureDetector(
                    onTap: _markAllAsRead,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Read all',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),

          // ── Unread Count Badge ──────────────────────────────────────────
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.offlineRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount unread',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.offlineRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Notification List ───────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return _NotificationCard(
                  notification: notif,
                  onTap: () {
                    setState(() {
                      _notifications[index] =
                          notif.copyWith(isUnread: false);
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '📖 ${notif.title}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        backgroundColor: AppColors.primaryNavy,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification Item Model ──────────────────────────────────────────────────
class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
  });

  _NotificationItem copyWith({bool? isUnread}) {
    return _NotificationItem(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      time: time,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}

// ── Notification Card Widget ─────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isUnread
                  ? Colors.white
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: notification.isUnread
                  ? Border.all(
                      color: AppColors.primaryNavy.withValues(alpha: 0.12),
                      width: 1,
                    )
                  : null,
              boxShadow: [
                if (notification.isUnread)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: notification.iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notification.icon,
                      color: notification.iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: notification.isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                          ),
                          if (notification.isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.accentBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.subtitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.time,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
