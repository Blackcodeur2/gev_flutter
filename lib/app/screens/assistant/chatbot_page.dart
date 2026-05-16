import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:camer_trip/app/models/chat_message_model.dart';
import 'package:camer_trip/app/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  
  bool _isTyping = false;
  List<ChatMessage> _messages = [
    ChatMessage(
      text: "Bonjour ! Je suis votre assistant CamerTrip conçu avec une IA avancée. Comment puis-je vous aider aujourd'hui ?",
      isUser: false,
      time: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString('chatbot_history');
      if (historyJson != null) {
        final List<dynamic> decodedList = jsonDecode(historyJson);
        final List<ChatMessage> loadedMessages = decodedList.map((item) => ChatMessage.fromJson(item)).toList();
        if (loadedMessages.isNotEmpty && mounted) {
          setState(() {
            _messages = loadedMessages;
          });
        }
      }
    } catch (e) {
      debugPrint("Erreur chargement historique : \$e");
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesToSave = _messages.take(50).toList();
      final String historyJson = jsonEncode(messagesToSave.map((m) => m.toJson()).toList());
      await prefs.setString('chatbot_history', historyJson);
    } catch (e) {
      debugPrint("Erreur sauvegarde historique : \$e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSend({String? hardcodedText}) async {
    final textToSend = hardcodedText ?? _controller.text.trim();
    if (textToSend.isEmpty) return;

    final userMessage = ChatMessage(
      text: textToSend,
      isUser: true,
      time: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, userMessage); // Insertion au début car on a reverse: true
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();
    _saveHistory();
    
    // Extraire l'historique : prendre les 10 derniers messages (hors erreurs et le message actuel) 
    // Attention _messages est en ordre chronologique inverse (index 0 = le plus récent)
    // On doit préparer la liste `history` dans le bon ordre chronologique pour l'API.
    final historyToSend = _messages
        .skip(1) // skip the newly added user message
        .where((m) => !m.isError)
        .take(10)
        .toList()
        .reversed
        .map((m) => m.toHistory())
        .toList();

    try {
      final answer = await _chatService.sendMessage(textToSend, historyToSend);
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.insert(0, ChatMessage(
            text: answer,
            isUser: false,
            time: DateTime.now(),
          ));
        });
        _scrollToBottom();
        _saveHistory();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.insert(0, ChatMessage(
            text: e.toString().replaceFirst("Exception: ", ""),
            isUser: false,
            time: DateTime.now(),
            isError: true,
          ));
        });
        _scrollToBottom();
      }
    }
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
          bottom: false,
          child: Column(
            children: [
              const MyAppBar(title: "Assistant IA"),
              
              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  reverse: true, // Le fond de la liste est au bas de l'écran
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildPremiumBubble(message, cs, isDark);
                  },
                ),
              ),

              // Indicateur de saisie
              if (_isTyping) _buildTypingIndicator(cs, isDark),

              // Suggestions rapides
              if (_messages.length <= 2 && !_isTyping) _buildQuickActions(cs),

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
                color: message.isError ? Colors.red.withOpacity(0.1) : cs.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: message.isError ? Colors.red.withOpacity(0.2) : cs.primary.withOpacity(0.2)),
              ),
              child: Icon(
                message.isError ? Icons.error_outline : Icons.auto_awesome, 
                color: message.isError ? Colors.red : cs.primary, 
                size: 16
              ),
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
                color: message.isUser 
                    ? null 
                    : (message.isError ? Colors.red.withOpacity(isDark ? 0.2 : 0.05) : (isDark ? cs.surfaceContainerHigh : Colors.white)),
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
                    ? Border.all(color: message.isError ? Colors.red.withOpacity(0.3) : (isDark ? Colors.white10 : cs.primary.withOpacity(0.05))) 
                    : null,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : (message.isError ? Colors.red : cs.onSurface),
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
    final actions = ["Quels sont les voyages de demain ?", "Quelles sont mes réservations ?", "Où sont vos agences ?"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: actions.map((text) => Container(
          margin: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text(text),
            onPressed: () {
              _handleSend(hardcodedText: text);
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
    // Adding extra bottom padding if needed for iOS SafeArea or navigation bar is handled by SafeArea widget above.
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 130), // Push chat bar up away from main navigation bar
      decoration: const BoxDecoration(
        color: Colors.transparent, 
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
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: "Posez votre question...",
                        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.3), fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
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
