import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:code_test_flutter/data/api/entities/photo_api_model.dart';
import 'package:code_test_flutter/res/styles.dart';
import 'package:code_test_flutter/res/strings.dart';

class PhotoDetailScreen extends StatelessWidget {
  final PhotoApiModel photo;

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: photo.id,
              child: CachedNetworkImage(
                imageUrl: photo.urls.full,
                fit: BoxFit.cover,
                placeholder: (context, url) => CachedNetworkImage(
                  imageUrl: photo.urls.thumb,
                  fit: BoxFit.cover,
                ),
                fadeInDuration: const Duration(milliseconds: 50),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                (photo.description?.isNotEmpty ?? false) ? photo.description! : Strings.noContentPlaceholder,
                style: TextStyles.textNormal,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
