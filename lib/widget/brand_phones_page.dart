import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:thephonepedia/widget/custom_drawer.dart';

class BrandPhones extends StatefulWidget {
  final int brandId;
  const BrandPhones({super.key, required this.brandId});

  @override
  State<BrandPhones> createState() => _BrandPhonesState();
}

class _BrandPhonesState extends State<BrandPhones> {
  List<dynamic> phones = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchPhones();
  }

  Future<void> fetchPhones() async {
    final uri = Uri.parse(
        'https://www.thephonepedia.com/api/phones/brand/${widget.brandId}');
    try {
      final response =
      await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            phones = jsonDecode(response.body);
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load (status ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, size: 30, color: Colors.white70),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          'Brand Phones',
          style: GoogleFonts.notoSans(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : phones.isEmpty
          ? const Center(child: Text("No phones found"))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        itemCount: phones.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> phone = phones[index];
          final imageUrl = phone['image_url'] != null
              ? 'https://www.thephonepedia.com/images/${Uri.encodeComponent(phone['image_url'])}'
              : null;

          return GestureDetector(
            onTap: () {
              context.push('/details', extra: phone);
            },
            child: Card(
              elevation: 4,
              shadowColor: Colors.black54,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Phone Image
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Icon(Icons.broken_image,
                            size: 80, color: Colors.grey);
                      },
                    )
                        : const Icon(Icons.broken_image,
                        size: 80, color: Colors.grey),
                  ),
                  // Phone Name
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      phone['name'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
