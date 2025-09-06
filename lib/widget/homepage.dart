import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thephonepedia/widget/custom_drawer.dart';
import 'package:thephonepedia/widget/latest_phones.dart';
import 'package:thephonepedia/widget/trendingphones.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        backgroundColor: Colors.lightBlue,
        title: Row(
          children: [
            Image.asset(
              'assets/images/img.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            Text(
              'ThePhonepedia',
              style: GoogleFonts.notoSans(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 30),
            color: Colors.white,
            onPressed: () => GoRouter.of(context).push('/search'),
          ),
        ],
      ),
      body: buildHomeContent(theme,context),
      drawer: const CustomDrawer(),
    );
  }

  Widget buildHomeContent(ThemeData theme,context) {
    final textColor = theme.textTheme.bodyLarge?.color;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const LatestPhones(),
          const SizedBox(height: 20),
          const TrendingPhones(),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Top Brands',
                style: GoogleFonts.poetsenOne(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 70,height: 70,
                        child: GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push('/brand', extra: 21);
                          },
                          child: Image.asset('assets/images/samsung.png',)
                        )
                    ),//21
                    SizedBox(width: 70,height: 70,
                        child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/brand', extra: 11);
                            },
                            child: Image.asset('assets/images/apple.png')
                        )
                    ),
                    SizedBox(width: 70,height: 70,
                        child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/brand', extra: 18);
                            },
                            child: Image.asset('assets/images/vivo.png',)
                        )
                    ),//21
                    SizedBox(width: 70,height: 70,
                        child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/brand', extra: 58);
                            },
                            child: Image.asset('assets/images/xiaomi.png')
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Image.asset('assets/images/img.png', height: 80),
          const SizedBox(height: 20),
          Text(
            'Your ultimate phone resource\nExplore latest phones, brands and check specs',
            textAlign: TextAlign.center,
            style: GoogleFonts.poetsenOne(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
