import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }
    setState(() => isLoading = true);

    final url = Uri.parse('https://10.0.2.2:80/api/search?name=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        searchResults = jsonData['data'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          style: GoogleFonts.notoSans(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'Search phones...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: fetchSearchResults,
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: buildSearchResults(theme),
    );
  }

  Widget buildSearchResults(ThemeData theme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (searchResults.isEmpty) {
      return Center(
        child: Text('No results', style: theme.textTheme.bodyMedium),
      );
    }
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final phone = searchResults[index];
        return ListTile(
          title: Text(
            phone['name'],
            style: GoogleFonts.notoSans(
              fontSize: 18,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          onTap: () {
            context.pushReplacement('/details', extra: phone);
          },
        );
      },
    );
  }
}
