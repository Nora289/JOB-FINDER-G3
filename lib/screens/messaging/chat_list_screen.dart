import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/models/message_model.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  static final List<ChatModel> _mockChats = [
    ChatModel(
      id: '1',
      contactName: 'HR Google',
      contactAvatar: 'assets/images/Goolge.png',
      lastMessage:
          'Thank you for applying. We would like to schedule an interview.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 2,
      companyName: 'Google',
    ),
    ChatModel(
      id: '2',
      contactName: 'Smart Recruiter',
      contactAvatar: 'assets/images/Smart .png',
      lastMessage: 'When can you start?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      companyName: 'Smart Axiata',
    ),
    ChatModel(
      id: '3',
      contactName: 'Wing HR Team',
      contactAvatar: 'assets/images/Wing.png',
      lastMessage: 'We have reviewed your application and...',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 1,
      companyName: 'Wing Bank',
    ),
    ChatModel(
      id: '4',
      contactName: 'ABA Recruitment',
      contactAvatar: 'assets/images/ABA Bank.png',
      lastMessage: 'Please send us your updated portfolio.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
      companyName: 'ABA Bank',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: _mockChats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: AppColors.textHint.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _mockChats.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 80),
              itemBuilder: (context, index) {
                final chat = _mockChats[index];
                return _chatTile(context, chat);
              },
            ),
    );
  }

  Widget _chatTile(BuildContext context, ChatModel chat) {
    final timeStr = _formatTime(chat.lastMessageTime);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      tileColor: Colors.white,
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: chat.contactAvatar.isNotEmpty
            ? ClipOval(
                child: Image.asset(
                  chat.contactAvatar,
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Text(
                    chat.contactName[0],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            : Text(
                chat.contactName[0],
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.contactName,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: chat.unreadCount > 0
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            timeStr,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: chat.unreadCount > 0
                  ? AppColors.primary
                  : AppColors.textHint,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: chat.unreadCount > 0
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: chat.unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${chat.unreadCount}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      onTap: () => context.push('/chat/${chat.id}'),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inHours < 24) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
