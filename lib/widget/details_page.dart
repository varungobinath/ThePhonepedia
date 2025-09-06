import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thephonepedia/widget/custom_drawer.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> phone;

  const DetailsPage({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    final specsGroups = phone['specs'] as List<dynamic>? ?? [];
    final imageUrl = phone['image_url'] != null
        ? 'https://www.thephonepedia.com/images/${Uri.encodeComponent(phone['image_url'])}'
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
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
          phone['name'] ?? 'Phone Details',
          style: GoogleFonts.notoSans(color: Colors.white),
        ),
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // --- Add phone image here ---
            Center(
              child: Image.network(
                imageUrl!=null?imageUrl:'',
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
                },
              ),
            ),

          const SizedBox(height: 12),
          Text(
            phone['name'],
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Loop through each group
          for (final group in specsGroups) buildSpecGroup(group),
        ],
      ),
    );
  }

  Widget buildSpecGroup(dynamic group) {
    final title = group['title'] ?? '';
    final specs = group['specs'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.lightBlue,
            ),
          ),
          const SizedBox(height: 8),

          for (final item in specs) buildSpecItem(item),
        ],
      ),
    );
  }

  Widget buildSpecItem(dynamic item) {
    final key = item['key'] ?? '';
    final vals = item['val'] as List<dynamic>? ?? [];
    final valueString = vals.join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              key,
              style: GoogleFonts.notoSans(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              valueString,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
