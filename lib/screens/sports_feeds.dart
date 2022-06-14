import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Sports extends StatefulWidget {
  //
  Sports() : super();

  @override
  SportsState createState() => SportsState();
}

class SportsState extends State<Sports> {
  bool isGrid = true;
  static const String FEED_URL = 'https://www.news18.com/rss/sports.xml';
  RssFeed? _feed;
  String? _title;
  static const String loadingFeedMsg = 'Loading Feed...';
  static const String feedLoadErrorMsg = 'Error Loading Feed.';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg = 'assets/images/no_image.jpg';
  GlobalKey<RefreshIndicatorState>? _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed!.title);
    });
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    load();
  }

  isFeedEmpty() {
    return null == _feed || null == _feed!.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isFeedEmpty()
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              key: _refreshKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height * 0.7),
                  ),
                  itemCount: _feed!.items!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _feed!.items![index];
                    return InkWell(
                      onTap: () async {
                        final lurl = item.link!;
                        if (await canLaunchUrlString(item.link!)) {
                          await launchUrlString(
                            item.link!,
                          );
                        }
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 232, 226, 226),
                            width: 1, //
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              item.media!.contents![0].url!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              item.title!,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  backgroundColor: Colors.black26),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              onRefresh: () => load(),
            ),
    );
  }
}
