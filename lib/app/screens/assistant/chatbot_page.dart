import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Bonjour ! Je suis votre assistant CamerTrip conçu avec une IA avancée. Comment puis-je vous aider aujourd'hui ?",
      isUser: false,
      time: DateTime.now(),
    ),
  ];

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _controller.text,
        isUser: true,
        time: DateTime.now(),
      ));
      _controller.clear();
      _isTyping = true;
    });

    // Simulation de réponse après un court délai
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: "C'est une excellente question ! Je recherche les disponibilités de voyages et les meilleurs tarifs pour vous. Souhaitez-vous que je filtre par agence ou par prix ?",
            isUser: false,
            time: DateTime.now(),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
                ? [cs.surface, cs.surfaceContainerHigh] 
                : [cs.primary.withOpacity(0.05), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const MyAppBar(title: "Assistant IA"),
              
              // Messages
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[_messages.length - 1 - index];
                    return _buildPremiumBubble(message, cs, isDark);
                  },
                ),
              ),

              // Indicateur de saisie
              if (_isTyping) _buildTypingIndicator(cs, isDark),

              // Suggestions rapides
              if (_messages.length == 1 && !_isTyping) _buildQuickActions(cs),

              // Zone de saisie
              _buildModernInputArea(cs, theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme cs, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainerHigh : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: cs.primary.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  "L'IA réfléchit...",
                  style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6), fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBubble(ChatMessage message, ColorScheme cs, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8, bottom: 4),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: cs.primary.withOpacity(0.2)),
              ),
              child: Icon(Icons.auto_awesome, color: cs.primary, size: 16),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: message.isUser 
                  ? LinearGradient(
                      colors: [cs.primary, cs.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
                color: message.isUser ? null : (isDark ? cs.surfaceContainerHigh : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: Radius.circular(message.isUser ? 22 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
                border: !message.isUser 
                    ? Border.all(color: isDark ? Colors.white10 : cs.primary.withOpacity(0.05)) 
                    : null,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : cs.onSurface,
                  fontSize: 15,
                  fontWeight: message.isUser ? FontWeight.w500 : FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
             const SizedBox(width: 8),
             const CircleAvatar(
               radius: 12,
               child: Icon(Icons.person, size: 14),
             ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions(ColorScheme cs) {
    final actions = ["Horaires de bus", "Réserver un billet", "Tarifs Douala-Ydé"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: actions.map((text) => Container(
          margin: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text(text),
            onPressed: () {
              _controller.text = text;
              _handleSend();
            },
            backgroundColor: cs.primary.withOpacity(0.05),
            labelStyle: TextStyle(color: cs.primary, fontSize: 13, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(color: cs.primary.withOpacity(0.2)),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildModernInputArea(ColorScheme cs, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: BoxDecoration(
        color: Colors.transparent, // Laisse passer le gradient de fond
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? cs.surfaceContainerHigh : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.emoji_emotions_outlined, color: cs.onSurface.withOpacity(0.35)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Posez votre question...",
                        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.3), fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic_none_rounded, color: cs.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
              onPressed: _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}
