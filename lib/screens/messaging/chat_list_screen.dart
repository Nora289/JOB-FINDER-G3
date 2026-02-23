import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/theme_provider.dart';
import 'package:job_finder/models/message_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static final List<ChatModel> _companyChats = [
    ChatModel(
      id: '1',
      contactName: 'ABA Bank',
      contactAvatar: 'assets/images/ABA Bank.png',
      lastMessage: 'Are you available for an interview...',
      lastMessageTime: DateTime(2024, 1, 1, 11, 45),
      unreadCount: 4,
      companyName: 'ABA Bank',
    ),
    ChatModel(
      id: '2',
      contactName: 'Smart Axiata',
      contactAvatar: 'assets/images/Smart .png',
      lastMessage: 'Are you available for an interview...',
      lastMessageTime: DateTime(2024, 1, 1, 11, 45),
      unreadCount: 3,
      companyName: 'Smart Axiata',
    ),
    ChatModel(
      id: '3',
      contactName: 'Wing Bank',
      contactAvatar: 'assets/images/Wing.png',
      lastMessage: 'Are you available for an interview...',
      lastMessageTime: DateTime(2024, 1, 1, 11, 45),
      unreadCount: 1,
      companyName: 'Wing Bank',
    ),
  ];

  static final List<ChatModel> _individualChats = [
    ChatModel(
      id: '4',
      contactName: 'Un Pheasa',
      contactAvatar: 'assets/images/Un pheasa.jpg',
      lastMessage: 'we are looking for a backend developer...',
      lastMessageTime: DateTime(2024, 1, 1, 11, 45),
      unreadCount: 4,
      companyName: '',
    ),
    ChatModel(
      id: '5',
      contactName: 'Yorn Somnang',
      contactAvatar: 'assets/images/Yorn Somnang.jpg',
      lastMessage: 'we are looking for a backend developer...',
      lastMessageTime: DateTime(2024, 1, 1, 11, 45),
      unreadCount: 3,
      companyName: '',
    ),
    ChatModel(
      id: '6',
      contactName: 'Sruoch Srean',
      contactAvatar: 'assets/images/Sruoch Srean.jpg',
      lastMessage: 'we are looking for a backend developer...',
      lastMessageTime: DateTime(2024, 1, 1, 11, 45),
      unreadCount: 1,
      companyName: '',
    ),
    ChatModel(
      id: '7',
      contactName: 'Sok Nora',
      contactAvatar: 'assets/images/Sok nora.JPG',
      lastMessage:
          'Hi! I saw your profile and I think you would be a great fit.',
      lastMessageTime: DateTime(2024, 1, 1, 10, 30),
      unreadCount: 2,
      companyName: '',
    ),
    ChatModel(
      id: '8',
      contactName: 'Pan Sothea',
      contactAvatar: 'assets/images/Pan Sothea.jpg',
      lastMessage: 'Can we schedule a call to discuss the role?',
      lastMessageTime: DateTime(2024, 1, 1, 9, 15),
      unreadCount: 0,
      companyName: '',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatModel> _filtered(List<ChatModel> list) {
    if (_searchQuery.isEmpty) return list;
    return list
        .where(
          (c) =>
              c.contactName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final filteredCompany = _filtered(_companyChats);
    final filteredIndividual = _filtered(_individualChats);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Messages',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.edit_outlined,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Search bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search a chat or message',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── List ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  if (filteredCompany.isNotEmpty)
                    ..._section(
                      context,
                      'Companies',
                      filteredCompany,
                      isDark,
                      isCompany: true,
                    ),
                  if (filteredIndividual.isNotEmpty)
                    ..._section(
                      context,
                      'Individual Messages',
                      filteredIndividual,
                      isDark,
                      isCompany: false,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _section(
    BuildContext context,
    String title,
    List<ChatModel> chats,
    bool isDark, {
    required bool isCompany,
  }) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ),
      ...chats.map(
        (chat) => _chatTile(context, chat, isDark, isCompany: isCompany),
      ),
    ];
  }

  Widget _chatTile(
    BuildContext context,
    ChatModel chat,
    bool isDark, {
    required bool isCompany,
  }) {
    final timeStr = '11:45 am';
    return InkWell(
      onTap: () => context.push('/chat/${chat.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(chat, isCompany),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.contactName,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextHint
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${chat.unreadCount}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatModel chat, bool isCompany) {
    if (chat.contactAvatar.isNotEmpty) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            chat.contactAvatar,
            width: 52,
            height: 52,
            fit: isCompany ? BoxFit.contain : BoxFit.cover,
            errorBuilder: (_, __, ___) => _initialsCircle(chat),
          ),
        ),
      );
    }
    return _initialsCircle(chat);
  }

  Widget _initialsCircle(ChatModel chat) {
    final colors = [
      const Color(0xFF5C6BC0),
      const Color(0xFF26A69A),
      const Color(0xFFEF5350),
      const Color(0xFF8D6E63),
      const Color(0xFF546E7A),
    ];
    final colorIndex = chat.id.hashCode.abs() % colors.length;
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: colors[colorIndex],
        shape: BoxShape.circle,
      ),
      child: _initials(chat.contactName, color: Colors.white),
    );
  }

  Widget _initials(String name, {Color color = AppColors.primary}) {
    final parts = name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'
        : name.isNotEmpty
        ? name[0]
        : '?';
    return Center(
      child: Text(
        initials.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
