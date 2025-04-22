import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:open_bible_ai/pages/slides/widget/activities_corner.dart';
import 'package:open_bible_ai/pages/slides/widget/daily-verse_widget.dart';
import 'package:open_bible_ai/pages/slides/widget/last_verse.dart';

class MainSlide extends StatefulWidget {
  const MainSlide({super.key});

  @override
  State<MainSlide> createState() => _MainSlideState();
}

class _MainSlideState extends State<MainSlide> {
  List<Widget> slides = [
    DailyVerse(),
    Container(color: Colors.green, child: Center(child: Text("Slide 2"))),
    Container(color: Colors.blue, child: Center(child: Text("Slide 3"))),
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(title: Text("OpenBibleVx"), centerTitle: true),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return slides[index];
                },
                itemCount: slides.length,
                outer: true,
                pagination: SwiperPagination(),
                control: SwiperControl(),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LastVerse(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ActivitiesCorner(),
          ),
        ),
      ],
    );
  }
}
