import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Logo extends StatefulWidget {
  final double size;

  const Logo({super.key, this.size = 80.0});

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    _fetchLogoUrl();
  }

  Future<void> _fetchLogoUrl() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('site_settings')
          .doc('global')
          .get();
      if (doc.exists && doc.data()!.containsKey('logo_url')) {
        setState(() {
          _logoUrl = doc.data()!['logo_url'];
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_logoUrl != null) {
      return Image.network(
        _logoUrl!,
        width: widget.size,
        height: widget.size,
      );
    } else {
      // Fallback SVG
      return SvgPicture.string(
        '''
        <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id="gold-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#D4AF37" />
              <stop offset="50%" stop-color="#F6DC7D" />
              <stop offset="100%" stop-color="#BE8009" />
            </linearGradient>
          </defs>
          <g fill="url(#gold-gradient)">
            <path d="M50 5 L10 20 V50 C10 75 50 95 50 95 C50 95 90 75 90 50 V20 L50 5 Z" />
            <path d="M50 25 L35 45 L50 90 L65 45 L50 25 Z M50 35 L45 42 H55 L50 35 Z" fill="#1A1A1A" opacity="0.9" />
          </g>
        </svg>
        ''',
        width: widget.size,
        height: widget.size,
      );
    }
  }
}
