import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      // Fallback to local asset SVG
      return SvgPicture.asset(
        'assets/icons/logo.svg',
        width: widget.size,
        height: widget.size,
      );
    }
  }
}
