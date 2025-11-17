import 'package:flutter/material.dart';

class ViewToggleWidget extends StatelessWidget {
  final ValueChanged<bool> onToggle;

  const ViewToggleWidget({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTileView = true; // Example toggle value, in real use this can be passed or managed globally

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'View as:',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              isTileView = !isTileView;
              onToggle(isTileView); // Pass the updated value to the parent
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isTileView ? Colors.blue : Colors.grey,
              ),
              child: Row(
                mainAxisAlignment:
                isTileView ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.grid_on,
                      color: isTileView ? Colors.white : Colors.black,
                      size: 20.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.view_column,
                      color: !isTileView ? Colors.white : Colors.black,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            isTileView ? "Tile View" : "Box View",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}