import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/widgets/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dio/dio.dart';

class AIStyleGuide extends StatefulWidget {
  const AIStyleGuide({super.key});

  @override
  State<AIStyleGuide> createState() => _AIStyleGuideState();
}

class _AIStyleGuideState extends State<AIStyleGuide> {
  bool _isOpen = false;
  final TextEditingController _queryController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final String _apiKey = 'AIzaSyCuN2k6W65ngjrkjSkNCCVE4l7Y4KDkSAc';

  void _openAssistant() {
    setState(() {
      _isOpen = true;
    });
    
    // Auto-message if conversation is empty
    if (_messages.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _isOpen) {
          setState(() {
            _messages.add({
              'role': 'assistant', 
              'content': "Welcome, patron. How may I assist with your sartorial queries today? Ask me about suit pairings, fabric maintenance, or evening wear etiquette."
            });
          });
        }
      });
    }
  }

  Future<void> _getAdvice() async {
    final query = _queryController.text.trim();
    if (query.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _messages.add({'role': 'user', 'content': query});
      _queryController.clear();
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$_apiKey',
        data: {
          "contents": [
            {
              "parts": [
                {
                  "text": "You are 'Suit Pro Assistant', a high-end sartorial concierge for Suit Pro London. Your expertise is in bespoke tailoring, garment care (especially wool, silk, and linen), suit pairings, and evening wear etiquette. Always maintain a distinguished, polite, and helpful tone. User query: $query"
                }
              ]
            }
          ]
        },
      );

      final String aiResponse = response.data['candidates'][0]['content']['parts'][0]['text'];

      if (mounted) {
        setState(() {
          _messages.add({'role': 'assistant', 'content': aiResponse});
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({'role': 'assistant', 'content': "Apologies, patron. I am currently unable to reach the archives. Please try again shortly."});
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _openAssistant,
          child: GlassContainer(
            width: double.infinity,
            borderRadius: 40,
            opacity: 0.1,
            blur: 20,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF18181B), Colors.black],
            ),
            padding: EdgeInsets.all(28.w),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.15)),
            child: Stack(
              children: [
                Positioned(
                  right: -15.w,
                  bottom: -15.h,
                  child: Opacity(
                    opacity: 0.05,
                    child: Icon(LucideIcons.scissors, size: 90.sp, color: AppTheme.gold),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.1)),
                      ),
                      child: Icon(LucideIcons.sparkles, color: AppTheme.gold, size: 24.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'SARTORIAL AI CONCIERGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Instant expert advice on bespoke style & garment care.',
                      style: TextStyle(
                        color: AppTheme.mutedForeground,
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isOpen) _buildModal(),
      ],
    );
  }

  Widget _buildModal() {
    final modal = Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Backdrop
          Animate(
            child: GestureDetector(
              onTap: () => setState(() => _isOpen = false),
              child: Container(
                color: AppTheme.background.withValues(alpha: 0.8),
              ),
            ),
          ).fadeIn(),

          Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: GlassContainer(
                width: double.infinity,
                borderRadius: 48,
                opacity: 0.2,
                blur: 30,
                padding: EdgeInsets.zero,
                border: Border.all(color: AppTheme.gold.withValues(alpha: 0.3)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.1),
                        border: Border(bottom: BorderSide(color: AppTheme.gold.withValues(alpha: 0.1))),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(48.r)),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => setState(() => _isOpen = false),
                              child: Icon(LucideIcons.x, color: AppTheme.mutedForeground, size: 20.sp),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Icon(LucideIcons.sparkles, color: AppTheme.gold, size: 40.sp),
                                SizedBox(height: 16.h),
                                Text('Suit Pro Assistant', style: Theme.of(context).textTheme.headlineSmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(minHeight: 150.h, maxHeight: 400.h),
                            child: _messages.isEmpty 
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40.h),
                                    child: Text(
                                      '"Welcome, patron. How may I assist with your sartorial queries today? Ask me about suit pairings, fabric maintenance, or evening wear etiquette."',
                                      style: TextStyle(
                                        color: AppTheme.mutedForeground,
                                        fontSize: 12.sp,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = _messages[index];
                                    final isUser = msg['role'] == 'user';
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: Column(
                                        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                              color: isUser ? AppTheme.gold.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                                              borderRadius: BorderRadius.circular(16.r),
                                            ),
                                            child: Text(
                                              msg['content']!,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontStyle: isUser ? FontStyle.normal : FontStyle.italic,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                          if (!isUser && index == _messages.length - 1) ...[
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                _buildBadge(LucideIcons.shieldCheck, 'Certified Advice'),
                                                SizedBox(width: 16.w),
                                                _buildBadge(LucideIcons.heart, 'Patron Care'),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _queryController,
                                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                                  onSubmitted: (_) => _getAdvice(),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. How to store wool suits?',
                                    hintStyle: TextStyle(color: Colors.white24, fontSize: 12.sp),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: _getAdvice,
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.gold,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          width: 16.w,
                                          height: 16.h,
                                          child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                                        )
                                      : Icon(LucideIcons.send, color: Colors.black, size: 16.sp),
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
            ),
          ),
        ],
      ),
    );

    return Animate(child: modal).fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack);
  }

  Widget _buildBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.gold, size: 12.sp),
        SizedBox(width: 4.w),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: AppTheme.gold,
            fontSize: 8.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
