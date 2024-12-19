// ignore_for_file: prefer_const_constructors

// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './home_page.dart';
import 'full_Screen.dart';

class DarkPage extends StatefulWidget {
  const DarkPage({super.key});

  @override
  State<DarkPage> createState() => _MyDarkPage();
}

class _MyDarkPage extends State<DarkPage> {
  bool isload = true;
  List<Map<String, dynamic>> allPosts = [];
  List<Map<String, dynamic>> post = [];
  int curp = 5; // Current page
  int perPage = 20; // Number of items per page
  final String accessKey =
      'XozpjdPlBpmKs0Y3sA1UvFOG61DtCXZSvuHxSjU_sSE'; // Replace with your key

  @override
  void initState() {
    super.initState();
    _fetchUnsplashPhotos();
  }

  Future<void> _fetchUnsplashPhotos() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.unsplash.com/photos?query=black&page=$curp&per_page=$perPage',
          // 'https://api.unsplash.com/search/photos?page=5&per_page=20&query=dark&client_id=$accessKey',
        ),
        headers: {
          'Authorization': 'Client-ID $accessKey',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = json.decode(response.body);
        setState(() {
          allPosts.addAll(fetchedPosts.map((e) => e as Map<String, dynamic>));
          post = allPosts;
          isload = false;
        });
      } else {
        throw Exception('Failed to fetch photos');
      }
    } catch (e) {
      setState(() {
        print("Error: $e");
        isload = false;
      });
    }
  }

  void _loadMore() {
    setState(() {
      curp++;
      isload = true;
    });
    _fetchUnsplashPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()),
                      );
                    },
                    child: FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "Dark Theme",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  ),
                  FaIcon(
                    FontAwesomeIcons.solidFaceKissWinkHeart,
                    color: Colors.white,
                    size: 25,
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemBuilder: (context, index) {
                  final item = post[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Fullscreen(
                              imageUrl: item['urls']
                                  ['regular'], // High-quality image URL
                              downloadUrl: item['links']
                                  ['download'], // Add the download URL
                            ),
                          ),
                        );
                        print("object");
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: NetworkImage(item['urls']['small_s3']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: post.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  // Space between rows
                  childAspectRatio: 6 / 10, // Aspect ratio of each item
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _loadMore,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 54),
                backgroundColor: Colors.indigoAccent[200],
              ),
              child: Text(
                "LOAD MORE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.023,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
