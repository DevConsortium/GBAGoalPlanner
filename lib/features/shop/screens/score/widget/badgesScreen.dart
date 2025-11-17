import 'package:flutter/material.dart';

class FlipScrollImage extends StatefulWidget {

  final String icon;

  const FlipScrollImage({super.key, required this.icon});

  @override
  _FlipScrollImageState createState() => _FlipScrollImageState();
}

class _FlipScrollImageState extends State<FlipScrollImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousScrollPosition = 0.0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 3.14).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipImage() {
    if (_isFlipped) {
      _controller.reverse();
    }
    else {
      _controller.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  void _onScroll(ScrollNotification notification) {
    final scrollPosition = notification.metrics.pixels;
    if (scrollPosition > _previousScrollPosition && !_isFlipped) {
      _flipImage();
    } else if (scrollPosition < _previousScrollPosition && _isFlipped) {
      _flipImage();
    }
    _previousScrollPosition = scrollPosition;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _onScroll(notification);
        return true;
      },
      child: GestureDetector(
        onTap: _flipImage,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.rotationY(_animation.value),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Image.asset(
              'assets/images/brands/${widget.icon}.png',
              width: 300,
            ),
          ),
        ),
      ),
    );
  }
}
