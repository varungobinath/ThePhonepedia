import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thephonepedia/theme/theme_notifier.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Drawer(
      // width: 300,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: Image.asset('assets/images/img.png').image,
                  backgroundColor: Colors.lightBlue,
                ),
                const SizedBox(height: 10),
                Text(
                  'ThePhonepedia',
                  style: GoogleFonts.notoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Home'),
            onTap: () {
              context.pushReplacement('/');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.branding_watermark),
            title: const Text('Brands'),
            onTap: () {
              Navigator.pop(context);
              context.push('/brands');
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
            children: [
              ListTile(
                title: const Text('Light'),
                leading: const Icon(Icons.light_mode),
                onTap: () {
                  themeNotifier.setThemeMode(ThemeMode.light);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                leading: const Icon(Icons.dark_mode),
                onTap: () {
                  themeNotifier.setThemeMode(ThemeMode.dark);
                },
              ),
              ListTile(
                title: const Text('System'),
                leading: const Icon(Icons.settings_brightness),
                onTap: () {
                  themeNotifier.setThemeMode(ThemeMode.system);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
