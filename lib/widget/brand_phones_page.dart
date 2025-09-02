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
  
  @override
  void initState(){
    super.initState();
    fetchPhones();
  }
  
  Future<void> fetchPhones() async{
    final uri = Uri.parse('https://10.0.2.2:80/api/phones/brand/${widget.brandId}');
    final response = await http.get(uri);
    if(response.statusCode==200){
      if(mounted){
        setState(() {
          phones = jsonDecode(response.body);
        });
      }
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
        title: Text('Brand Phones',style: GoogleFonts.notoSans(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      drawer: const CustomDrawer(),
      body: GridView.builder(
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
        ),
            // padding: EdgeInsets.all(8),
            itemCount: phones.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 2,
                mainAxisSpacing: 3,
                childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
            final Map<String,dynamic> phone = phones[index];
            final imageUrl = phone['image_url'] != null
                ? 'https://10.0.2.2:80/images/${Uri.encodeComponent(phone['image_url'])}'
                : null;
            return GestureDetector(
              onTap: (){
                context.push('/details',extra: phone);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30
                ),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    // side: const BorderSide(
                    //   color: Colors.lightBlue,
                    //   width: 2,
                    // ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(
                          imageUrl!,
                          height: 220,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(phone['name'], style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
      )
    );
  }
}
