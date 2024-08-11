import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ColorModel.dart';

class DualFAB extends StatefulWidget {

  final VoidCallback onAddPressed;
  final VoidCallback onCameraPressed;

    DualFAB({required this.onAddPressed,required this.onCameraPressed});
  @override
  _DualFABState createState() => _DualFABState();
}

class _DualFABState extends State<DualFAB> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorModel = Provider.of<ColorModel>(context);
    final selectedColor = colorModel.selectedColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Expanded FAB buttons
        AnimatedSizeAndFade(
          vsync: this,
          showChild: _isExpanded,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'btn1',
                onPressed: () {
                 widget.onAddPressed();
                  _toggleExpand();
                },
                child: Icon(Icons.edit),

              ),
              SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'btn2',
                onPressed: () {
                widget.onCameraPressed();
                  _toggleExpand();
                },
                child: Icon(Icons.camera_alt),

              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        // Main FAB
        FloatingActionButton(
          backgroundColor: selectedColor,

          onPressed: _toggleExpand,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value * 0.5 * 3.14,
                child: Icon(_isExpanded ? Icons.close : Icons.add,color: Colors.white,),
              );
            },
          ),

        ),
      ],
    );
  }
}

class AnimatedSizeAndFade extends StatelessWidget {
  final Widget child;
  final bool showChild;
  final TickerProvider vsync;

  AnimatedSizeAndFade({
    required this.child,
    required this.showChild,
    required this.vsync,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: showChild ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: showChild ? child : SizedBox.shrink(),
      ),
    );
  }
}