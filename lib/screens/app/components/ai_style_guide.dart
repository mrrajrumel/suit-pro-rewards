import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/widgets/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AIStyleGuide extends StatefulWidget {
  const AIStyleGuide({super.key});

  @override
  State<AIStyleGuide> createState() => _AIStyleGuideState();
}

class _AIStyleGuideState extends State<AIStyleGuide> {
  bool _isOpen = false;
  final TextEditingController _queryController = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  void _getAdvice() async {
    final query = _queryController.text.trim();
    if (query.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // TODO: Integrate with AI Service (e.g. Gemini)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _response = "As a distinguished patron of Suit Pro London, I recommend storing your wool suits in a breathable garment bag to preserve the natural fibers. Avoid plastic covers as they trap moisture. For daily care, use a horsehair brush to remove surface dust.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isOpen = true),
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
                                Text('Style Concierge', style: Theme.of(context).textTheme.headlineSmall),
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
                            constraints: BoxConstraints(minHeight: 150.h, maxHeight: 300.h),
                            child: SingleChildScrollView(
                              child: _response.isNotEmpty
                                  ? Column(
                                      children: [
                                        Text(
                                          _response,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.italic,
                                            height: 1.6,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 24.h),
                                        Divider(color: AppTheme.gold.withValues(alpha: 0.05)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _buildBadge(LucideIcons.shieldCheck, 'Certified Advice'),
                                            SizedBox(width: 16.w),
                                            _buildBadge(LucideIcons.heart, 'Patron Care'),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Center(
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
                                    ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _queryController,
                                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
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
