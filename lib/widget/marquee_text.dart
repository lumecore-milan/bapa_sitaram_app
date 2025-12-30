import 'package:flutter/material.dart';

import 'package:bapa_sitaram/services/loger_service.dart';

enum MarqueeDirection { ltr, rtl }

class MarqueeText extends StatefulWidget {
  const MarqueeText({required this.widget, super.key, this.direction = MarqueeDirection.rtl});

  final Text widget;
  final MarqueeDirection direction;

  @override
  _MarqueeTextState createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;
  bool _isScrolling = true;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    /*controller = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();*/
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
    /* animation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: const Offset(-1.2, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );*/
  }

  Future<void> _startScroll() async {
    try {
      while (_isScrolling) {
        await _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(seconds: 20), // adjust speed
          curve: Curves.linear,
        );

        if (_isScrolling) {
          _controller.jumpTo(0);
        }
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  @override
  void dispose() {
    _isScrolling = false;
    _controller.dispose();
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 1 > 0
        ? ClipRect(
            child: ListView(padding: .zero, shrinkWrap: true, scrollDirection: Axis.horizontal, controller: _controller, physics: const NeverScrollableScrollPhysics(), children: [widget.widget, const SizedBox(width: 10), widget.widget]),
          )
        : ClipRect(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SlideTransition(position: animation, child: widget.widget),
            ),
          );
  }
}
