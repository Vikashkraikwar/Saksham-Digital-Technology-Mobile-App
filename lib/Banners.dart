import 'dart:async'; // <-- ADD THIS IMPORT for the Timer

import 'package:database/Models/BannersModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<BannerResponse> futureBanners;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ---- ADDED: A Timer for auto-scrolling ----
  Timer? _timer;
  // ------------------------------------------

  // ---- ADDED: A function to start the animation timer ----
  void _startBannerTimer(int bannerCount) {
    // If a timer is already running, cancel it
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < bannerCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Loop back to the first banner
      }

      // Animate to the next page
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }
  // ----------------------------------------------------

  @override
  void initState() {
    super.initState();
    futureBanners = fetchBanners();

    // ---- MODIFIED: Start the timer AFTER the banner data is loaded ----
    futureBanners.then((bannerData) {
      if (bannerData.data.isNotEmpty) {
        _startBannerTimer(bannerData.data.length);
      }
    });
    // ----------------------------------------------------------------

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // <-- ADDED: Cancel the timer when the screen is closed
    super.dispose();
  }

  Future<BannerResponse> fetchBanners() async {
    final response = await http.get(Uri.parse('https://sakshamdigitaltechnology.com/api/banners'));
    if (response.statusCode == 200) {
      return bannerResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load banners from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    // The rest of your build method is unchanged
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Banners & List'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<BannerResponse>(
        future: futureBanners,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final banners = snapshot.data!.data;
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: banners.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: buildListItem(index, banners),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text('No data found.'));
        },
      ),
    );
  }

  Widget buildListItem(int index, List<BannerData> banners) {
    // Your buildListItem method is unchanged
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Column(
          children: [
            SizedBox(
              height: 200.0,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: banners.length,
                itemBuilder: (context, pageIndex) {
                  final banner = banners[pageIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      banner.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (dotIndex) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == dotIndex ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == dotIndex
                        ? Colors.deepPurple
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    }
    final bannerIndex = index - 1;
    final banner = banners[bannerIndex];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          banner.title ?? 'No Title Provided',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}