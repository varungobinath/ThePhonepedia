import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class LatestPhones extends StatefulWidget {
  const LatestPhones({super.key});

  @override
  State<LatestPhones> createState() => _LatestPhonesState();
}

class _LatestPhonesState extends State<LatestPhones> {
  late Future<List<dynamic>> _latestPhonesFuture;

  @override
  void initState() {
    super.initState();
    _latestPhonesFuture = fetchLatestPhones();
  }

  Future<List<dynamic>> fetchLatestPhones() async {
    final url = Uri.parse('https://www.thephonepedia.com/api/latest/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load latest phones');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Latest Phones',
            style: GoogleFonts.notoSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<dynamic>>(
            future: _latestPhonesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No latest phones found.'));
              }

              final phones = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: phones.length,
                itemBuilder: (context, index) {
                  final phone = phones[index];
                  return GestureDetector(
                    onTap: () => context.push('/details', extra: phone),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black54,
                      margin: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            Expanded(
                              child: phone['image_url'] != null
                                  ? Image.network(
                                      "https://www.thephonepedia.com/images/${Uri.encodeComponent(phone['image_url'])}",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image,
                                            size: 80, color: Colors.grey);
                                      },
                                    )
                                  : const Icon(Icons.broken_image,
                                      size: 80, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                phone['name'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
