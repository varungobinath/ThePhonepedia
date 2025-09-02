import 'package:go_router/go_router.dart';
import 'package:thephonepedia/widget/homepage.dart';
import 'package:thephonepedia/widget/details_page.dart';
import 'package:thephonepedia/widget/brands_page.dart';
import 'package:thephonepedia/widget/brand_phones_page.dart';
import 'package:thephonepedia/widget/searchpage.dart';
import 'package:flutter/material.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/details',
      pageBuilder: (context, state) {
        final phoneData = state.extra as Map<String, dynamic>;
        return MaterialPage(
          key: state.pageKey,
          child: DetailsPage(phone: phoneData),
        );
      },
    ),
    GoRoute(
      path: '/brands',
      builder: (context, state) => const BrandsPage(),
    ),
    GoRoute(
      path: '/brand',
      builder: (context, state) {
        final brandId = state.extra as int;
        return BrandPhones(brandId: brandId);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
  ],
);
