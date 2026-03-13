import 'package:flutter/material.dart';
import 'package:langkara/Pages/room_chat_page.dart';
import 'package:langkara/services/chat_service.dart';
import 'package:intl/intl.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final ChatService _chatService = ChatService();
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    try {
      final conversations = await _chatService.getConversations();
      if (mounted) {
        setState(() {
          _conversations = conversations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return '';
    final dt = DateTime.tryParse(isoTime);
    if (dt == null) return '';

    final now = DateTime.now();
    final local = dt.toLocal();
    final diff = now.difference(local);

    if (diff.inDays == 0) {
      return DateFormat('HH:mm').format(local);
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE', 'id').format(local);
    } else {
      return DateFormat('dd/MM/yy').format(local);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2A4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pesan",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF1A2A4F),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadConversations,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _conversations.length,
                    separatorBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Colors.grey[200]),
                    ),
                    itemBuilder: (context, index) {
                      final conv = _conversations[index];
                      return _buildConversationTile(conv);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada pesan",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Mulai percakapan dengan temanmu\nmelalui halaman Temanku",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conv) {
    final otherUsername = conv['other_username'] ?? 'Anonim';
    final otherAvatarUrl = conv['other_avatar_url'] as String?;
    final lastMessage = conv['last_message'] as String?;
    final lastMessageTime = conv['last_message_time'] as String?;
    final unreadCount = conv['unread_count'] as int? ?? 0;
    final otherUserId = conv['other_user_id'] as String;
    final lastSenderId = conv['last_message_sender_id'] as String?;
    final currentUserId = _chatService.currentUserId;
    final isMyLastMessage = lastSenderId == currentUserId;

    return Material(
      color: unreadCount > 0 ? const Color(0xFFF0F4FF) : Colors.white,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoomChatPage(
                otherUserId: otherUserId,
                otherUserName: otherUsername,
                otherUserAvatar: otherAvatarUrl,
              ),
            ),
          );
          // Refresh conversations when returning from chat
          _loadConversations();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFE8E8E8),
                backgroundImage:
                    otherAvatarUrl != null ? NetworkImage(otherAvatarUrl) : null,
                child: otherAvatarUrl == null
                    ? Text(
                        otherUsername[0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF1A2A4F),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              // Name + last message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUsername,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight:
                            unreadCount > 0 ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 15,
                        color: const Color(0xFF1A2A4F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage != null
                          ? (isMyLastMessage ? 'Anda: $lastMessage' : lastMessage)
                          : 'Belum ada pesan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        color: unreadCount > 0
                            ? const Color(0xFF1A2A4F)
                            : Colors.grey[500],
                        fontWeight: unreadCount > 0
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Time + unread badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(lastMessageTime),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      color: unreadCount > 0
                          ? const Color(0xFF1A2A4F)
                          : Colors.grey[400],
                      fontWeight:
                          unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A2A4F), Color(0xFFDD979B)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
