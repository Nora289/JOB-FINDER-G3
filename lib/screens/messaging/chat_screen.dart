import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/theme_provider.dart';
import 'package:job_finder/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  // ── Per-chat contact info ──────────────────────────────
  static const Map<String, Map<String, String>> contactInfo = {
    '1': {'name': 'ABA Bank', 'avatar': 'assets/images/ABA Bank.png'},
    '2': {'name': 'Smart Axiata', 'avatar': 'assets/images/Smart .png'},
    '3': {'name': 'Wing Bank', 'avatar': 'assets/images/Wing.png'},
    '4': {'name': 'Un Pheasa', 'avatar': 'assets/images/Un pheasa.jpg'},
    '5': {'name': 'Yorn Somnang', 'avatar': 'assets/images/Yorn Somnang.jpg'},
    '6': {'name': 'Sruoch Srean', 'avatar': 'assets/images/Sruoch Srean.jpg'},
    '7': {'name': 'Sok Nora', 'avatar': 'assets/images/Sok nora.JPG'},
    '8': {'name': 'Pan Sothea', 'avatar': 'assets/images/Pan Sothea.jpg'},
  };

  // ── Per-chat seed messages ─────────────────────────────
  static final Map<String, List<MessageModel>> seedMessages = {
    '1': [
      MessageModel(
        id: '1-1',
        senderId: 'c',
        senderName: 'ABA Bank',
        senderAvatar: '',
        content:
            'Hi! Thank you for applying to our Flutter Developer position at ABA Bank.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
      MessageModel(
        id: '1-2',
        senderId: 'c',
        senderName: 'ABA Bank',
        senderAvatar: '',
        content: 'Are you available for an interview this week?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 2, minutes: 50),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '1-3',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Yes, I am available! Thank you for considering me.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 2, minutes: 30),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '1-4',
        senderId: 'c',
        senderName: 'ABA Bank',
        senderAvatar: '',
        content: 'Great! How about Wednesday at 10:00 AM via Google Meet?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
      MessageModel(
        id: '1-5',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Wednesday 10 AM works perfectly for me!',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 45),
        ),
        isMe: true,
      ),
    ],
    '2': [
      MessageModel(
        id: '2-1',
        senderId: 'c',
        senderName: 'Smart Axiata',
        senderAvatar: '',
        content:
            'Hello! We received your application for the Mobile Developer role.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isMe: false,
      ),
      MessageModel(
        id: '2-2',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'Hello! Yes, I am very interested in this role at Smart Axiata.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 4, minutes: 40),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '2-3',
        senderId: 'c',
        senderName: 'Smart Axiata',
        senderAvatar: '',
        content:
            'We would like to invite you for a technical screening. Are you available?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 4, minutes: 20),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '2-4',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Absolutely! I am ready for the technical screening.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isMe: true,
      ),
      MessageModel(
        id: '2-5',
        senderId: 'c',
        senderName: 'Smart Axiata',
        senderAvatar: '',
        content: 'Are you available for an interview on Thursday at 2 PM?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 3, minutes: 30),
        ),
        isMe: false,
      ),
    ],
    '3': [
      MessageModel(
        id: '3-1',
        senderId: 'c',
        senderName: 'Wing Bank',
        senderAvatar: '',
        content:
            'Hi, we are reviewing your application for the Backend Developer position.',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isMe: false,
      ),
      MessageModel(
        id: '3-2',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'Thank you for reaching out! I am very excited about Wing Bank.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 5, minutes: 45),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '3-3',
        senderId: 'c',
        senderName: 'Wing Bank',
        senderAvatar: '',
        content: 'Could you share your latest portfolio or GitHub link?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 5, minutes: 20),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '3-4',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Sure! Here is my GitHub: github.com/username',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isMe: true,
      ),
      MessageModel(
        id: '3-5',
        senderId: 'c',
        senderName: 'Wing Bank',
        senderAvatar: '',
        content:
            'Are you available for an interview? We will be in touch soon!',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 4, minutes: 30),
        ),
        isMe: false,
      ),
    ],
    '4': [
      MessageModel(
        id: '4-1',
        senderId: 'c',
        senderName: 'Un Pheasa',
        senderAvatar: '',
        content:
            'Hello! I am a recruiter at Passapp. We are looking for a backend developer.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isMe: false,
      ),
      MessageModel(
        id: '4-2',
        senderId: 'c',
        senderName: 'Un Pheasa',
        senderAvatar: '',
        content:
            'Your profile matches our requirements perfectly. Are you open to new opportunities?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 3, minutes: 50),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '4-3',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'Hi Un Pheasa! Yes, I am open to new opportunities. Tell me more.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 3, minutes: 30),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '4-4',
        senderId: 'c',
        senderName: 'Un Pheasa',
        senderAvatar: '',
        content:
            'We are looking for a backend developer with Node.js and PostgreSQL experience.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 3, minutes: 10),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '4-5',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'I have 2 years of experience with both. I would love to apply!',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 2, minutes: 50),
        ),
        isMe: true,
      ),
    ],
    '5': [
      MessageModel(
        id: '5-1',
        senderId: 'c',
        senderName: 'Yorn Somnang',
        senderAvatar: '',
        content:
            'Hi! I found your profile and I think you would be a great fit for our team.',
        timestamp: DateTime.now().subtract(const Duration(hours: 7)),
        isMe: false,
      ),
      MessageModel(
        id: '5-2',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'Thanks Yorn! What kind of role are you looking to fill?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 6, minutes: 40),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '5-3',
        senderId: 'c',
        senderName: 'Yorn Somnang',
        senderAvatar: '',
        content:
            'We are looking for a backend developer with API integration experience.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 6, minutes: 15),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '5-4',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'That sounds interesting! I have strong REST API experience.',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isMe: true,
      ),
      MessageModel(
        id: '5-5',
        senderId: 'c',
        senderName: 'Yorn Somnang',
        senderAvatar: '',
        content: 'Can we schedule a quick call to discuss the role further?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 5, minutes: 30),
        ),
        isMe: false,
      ),
    ],
    '6': [
      MessageModel(
        id: '6-1',
        senderId: 'c',
        senderName: 'Sruoch Srean',
        senderAvatar: '',
        content:
            'Hello! I came across your profile and was impressed by your Flutter skills.',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        isMe: false,
      ),
      MessageModel(
        id: '6-2',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'Hi Sruoch! Thank you for reaching out. What position are you hiring for?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 7, minutes: 45),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '6-3',
        senderId: 'c',
        senderName: 'Sruoch Srean',
        senderAvatar: '',
        content:
            'We are looking for a backend developer to join our fintech startup.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 7, minutes: 20),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '6-4',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'A fintech startup sounds exciting! I would love to learn more.',
        timestamp: DateTime.now().subtract(const Duration(hours: 7)),
        isMe: true,
      ),
      MessageModel(
        id: '6-5',
        senderId: 'c',
        senderName: 'Sruoch Srean',
        senderAvatar: '',
        content:
            'We are looking for a backend developer. Can we set up an interview?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 6, minutes: 30),
        ),
        isMe: false,
      ),
    ],
    '7': [
      MessageModel(
        id: '7-1',
        senderId: 'c',
        senderName: 'Sok Nora',
        senderAvatar: '',
        content:
            'Hi! I saw your profile and I think you would be a great fit for our company.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 2, minutes: 30),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '7-2',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'Hello Sok Nora! Thank you for the kind words. Which company are you from?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 2, minutes: 10),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '7-3',
        senderId: 'c',
        senderName: 'Sok Nora',
        senderAvatar: '',
        content: 'I am from TechCam. We are expanding our mobile team rapidly.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 50),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '7-4',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content: 'That is great to hear! I am open to new opportunities.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '7-5',
        senderId: 'c',
        senderName: 'Sok Nora',
        senderAvatar: '',
        content:
            'Would you be interested in a Flutter Lead role? The package is very competitive.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isMe: false,
      ),
    ],
    '8': [
      MessageModel(
        id: '8-1',
        senderId: 'c',
        senderName: 'Pan Sothea',
        senderAvatar: '',
        content:
            'Hi there! I am Pan Sothea, a tech recruiter. Can we schedule a call to discuss the role?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 45),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '8-2',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'Hi Pan Sothea! Sure, I would be happy to have a call. What is the role?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
        isMe: true,
      ),
      MessageModel(
        id: '8-3',
        senderId: 'c',
        senderName: 'Pan Sothea',
        senderAvatar: '',
        content:
            'We are hiring a Senior Flutter Developer for a 6-month contract project.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 15),
        ),
        isMe: false,
      ),
      MessageModel(
        id: '8-4',
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: '',
        content:
            'That sounds interesting! I am available for a call this afternoon.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isMe: true,
      ),
      MessageModel(
        id: '8-5',
        senderId: 'c',
        senderName: 'Pan Sothea',
        senderAvatar: '',
        content: 'Can we schedule a call to discuss the role at 3 PM today?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isMe: false,
      ),
    ],
  };

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  late List<MessageModel> _messages;

  @override
  void initState() {
    super.initState();
    final seed = ChatScreen.seedMessages[widget.chatId];
    _messages = seed != null ? List.from(seed) : [];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          senderName: 'Me',
          senderAvatar: '',
          content: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isMe: true,
        ),
      );
    });
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Builder(
          builder: (context) {
            final info = ChatScreen.contactInfo[widget.chatId];
            final contactName = info?['name'] ?? 'Unknown';
            final contactAvatar = info?['avatar'] ?? '';
            final initial = contactName.isNotEmpty
                ? contactName[0].toUpperCase()
                : '?';
            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: contactAvatar.isNotEmpty
                      ? AssetImage(contactAvatar)
                      : null,
                  onBackgroundImageError: contactAvatar.isNotEmpty
                      ? (_, __) {}
                      : null,
                  child: contactAvatar.isEmpty
                      ? Text(
                          initial,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contactName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Online',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.phone_outlined,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _messageBubble(message, isDark);
              },
            ),
          ),
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    color: AppColors.textHint,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkCard
                          : AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(MessageModel message, bool isDark) {
    // Received bubble: light grey in light mode, elevated surface in dark mode
    final receivedBg = isDark
        ? const Color(0xFF2E3250) // clearly visible elevated dark-blue surface
        : Colors.white;
    final receivedText = isDark
        ? AppColors
              .darkTextPrimary // white text in dark mode
        : AppColors.textPrimary;
    final receivedTime = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textHint;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.primary : receivedBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMe ? 16 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: message.isMe ? Colors.white : receivedText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: message.isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : receivedTime,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
