import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class TrendingPhones extends StatefulWidget {
  const TrendingPhones({super.key});

  @override
  State<TrendingPhones> createState() => _TrendingPhonesState();
}

class _TrendingPhonesState extends State<TrendingPhones> {
  List<dynamic> _phones = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchTrendingPhones();
  }

  void fetchTrendingPhones() async {
    final url = Uri.parse('https://www.thephonepedia.com/api/trendingphones/');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (mounted) {
          setState(() {
            _phones = jsonData;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed (status ${response.statusCode})';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Trending Phones',
            style: GoogleFonts.notoSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : _phones.isEmpty
              ? const Center(child: Text('No trending phones found.'))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _phones.length,
            itemBuilder: (context, index) {
              final phone = _phones[index];
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
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey,
                              );
                            },
                          )
                              : const Icon(
                            Icons.broken_image,
                            size: 80,
                            color: Colors.grey,
                          ),
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
          ),
        ),
      ],
    );
  }
}
