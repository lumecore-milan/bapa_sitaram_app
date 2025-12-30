import 'package:flutter/material.dart';
import 'dart:math';

class ShimmerDemo extends StatelessWidget {
  const ShimmerDemo({super.key, this.count = 20});
  final int count;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return const Padding(padding: EdgeInsets.only(bottom: 20), child: ShimmerWidget.rectangular(height: 70));
      },
    );
  }
}

class ShimmerWidget extends StatefulWidget {

  const ShimmerWidget.rectangular({required this.height, super.key, this.width = double.infinity, this.borderRadius = 12});
  final double width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: const Alignment(-1, -0.3),
              end: const Alignment(1, 0.3),
              colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
              stops: [max(_controller.value - 0.3, 0), _controller.value, min(_controller.value + 0.3, 1)],
            ),
          ),
        );
      },
    );
  }
}
