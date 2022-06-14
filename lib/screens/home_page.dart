import 'package:cached_network_image/cached_network_image.dart';
import 'package:category_app/screens/education_feeds.dart';
import 'package:category_app/screens/entertainment_feeds.dart';
import 'package:category_app/screens/india.dart';
import 'package:category_app/screens/market_feed.dart';
import 'package:category_app/screens/sports_feeds.dart';
import 'package:category_app/screens/tech_feeds.dart';
import 'package:category_app/screens/top_stories.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("explore"),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: 'India',
              ),
              Tab(
                text: 'Top Stories',
              ),
              Tab(
                text: 'Market',
              ),
              Tab(
                text: 'Tech',
              ),
              Tab(
                text: 'Entertainment ',
              ),
              Tab(
                text: 'Sports',
              ),
              Tab(
                text: 'Education',
              ),
              Tab(
                text: 'fun or humour or meme',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            India(),
            TopStories(),
            Market(),
            Tech(),
            Entertainment(),
            Sports(),
            Education(),
            Center(
              child: Text("data"),
            ),
          ],
        ),
      ),
    );
  }
}
