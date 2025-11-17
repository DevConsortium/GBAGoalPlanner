import 'package:flutter/material.dart';

class TImageRowWithCaptions extends StatelessWidget {
  const TImageRowWithCaptions({
    super.key,
    required this.items,
  });

  final List<ImageCaptionItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return Column(
            children: [
              ClipOval(
                child: Image.asset(
                  item.imagePath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.caption,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ImageCaptionItem {
  final String imagePath;
  final String caption;

  ImageCaptionItem({required this.imagePath, required this.caption});
}
