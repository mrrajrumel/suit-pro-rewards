import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Logo extends StatefulWidget {
  final double size;

  const Logo({super.key, this.size = 80.0});

  @override
  State<Logo> createState() => _LogoState();
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
        final url = doc.data()!['logo_url'];
        if (url != null && url.toString().isNotEmpty) {
          setState(() {
            _logoUrl = url;
          });
        }
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
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else {
      return _buildFallback();
    }
  }

  Widget _buildFallback() {
    return Image.asset(
      'assets/images/logo.png',
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.shield_outlined,
        size: widget.size,
        color: const Color(0xFFD4AF37),
      ),
    );
  }
}
