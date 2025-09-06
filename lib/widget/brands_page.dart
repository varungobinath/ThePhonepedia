import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:thephonepedia/widget/custom_drawer.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  List<dynamic> brandDetails = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    // print('Fetching brands...');
    try {
      final uri = Uri.parse('https://www.thephonepedia.com/api/phones/brands');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // print('Brands fetched successfully');
        setState(() {
          final List<dynamic> data = jsonDecode(response.body);
          brandDetails = data;
          isLoading = false;
        });
      } else {
        // print('Failed to load brands. Status code: ${response.statusCode}');
        setState(() {
          error = 'Failed to load brands';
          isLoading = false;
        });
      }
    } catch (e) {
      // print('An error occurred: $e');
      setState(() {
        error = 'An error occurred: $e';
        isLoading = false;
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
          'Brands',
          style: GoogleFonts.notoSans(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      drawer: const CustomDrawer(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    if (brandDetails.isEmpty) {
      return const Center(child: Text('No brands found'));
    }
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: brandDetails.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 3,
        childAspectRatio: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        final brand = brandDetails[index];
        return GestureDetector(
          onTap: () {
            context.push('/brand', extra: brand['id']);
          },
          child: Card(
            elevation: 2,
            child: Center(
              child: Text(brand['name']),
            ),
          ),
        );
      },
    );
  }
}
