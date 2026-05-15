import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ReferralService {
  static const String _referralKey = 'pending_referral_code';

  /// Initializes the referral tracking by checking the Play Store install referrer.
  static Future<void> initTracking() async {
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Only check if we haven't already captured a referral
      if (prefs.containsKey(_referralKey)) return;

      final ReferrerDetails referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      final String? referrer = referrerDetails.installReferrer;

      if (referrer != null && (referrer.contains('ref=') || referrer.contains('ref%3D'))) {
        // Handle both raw and URL-encoded referrers
        final String decodedReferrer = Uri.decodeComponent(referrer);
        
        // Extract the code
        // Example: utm_source=google-play&utm_medium=organic&ref=RUMEA5OB
        final Map<String, String> params = Uri.splitQueryString(decodedReferrer.replaceAll('&', '?').split('?').last);
        final String? code = params['ref'];
        
        if (code != null && code.isNotEmpty) {
          await prefs.setString(_referralKey, code);
          debugPrint('Captured referral code from Play Store: $code');
        }
      }
    } catch (e) {
      debugPrint('Failed to track install referrer: $e');
    }
  }

  /// Gets the pending referral code if any.
  static Future<String?> getPendingReferral() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_referralKey);
  }

  /// Clears the pending referral code after it has been used.
  static Future<void> clearPendingReferral() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_referralKey);
  }
}
