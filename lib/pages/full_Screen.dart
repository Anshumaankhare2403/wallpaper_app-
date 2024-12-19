import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';

class Fullscreen extends StatefulWidget {
  final String imageUrl;
  final String downloadUrl;

  const Fullscreen(
      {super.key, required this.imageUrl, required this.downloadUrl});

  @override
  State<Fullscreen> createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {
  Future<void> downloadImage() async {
    try {
      String? imageId = await ImageDownloader.downloadImage(
        widget.downloadUrl,
        destination: AndroidDestinationType.directoryPictures,
      );

      if (imageId == null) {
        throw Exception("Image download failed: No image ID returned.");
      }

      String? imagePath = await ImageDownloader.findPath(imageId);
      if (imagePath == null) {
        throw Exception("Failed to find the path for the downloaded image.");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image downloaded to: $imagePath"),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      print("Detailed error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to download image: $error"),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const Text(
                    "Wallpaper",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const FaIcon(
                    FontAwesomeIcons.solidFaceKissWinkHeart,
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
            ),

            // Image Display
            Expanded(
              child: Center(
                child: Hero(
                  tag: widget.imageUrl, // Hero animation tag
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),

            // Download Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: downloadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Button color
                  minimumSize: const Size(double.infinity, 60), // Full width
                ),
                child: const Text(
                  "Download Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
