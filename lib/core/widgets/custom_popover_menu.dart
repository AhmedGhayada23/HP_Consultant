import 'package:flutter/material.dart';

class CustomPopover extends StatefulWidget {
  final Widget child;
  final WidgetBuilder popoverBuilder;
  final bool barrierDismissible;

  const CustomPopover({
    super.key,
    required this.child,
    required this.popoverBuilder,
    this.barrierDismissible = true,
  });

  @override
  State<CustomPopover> createState() => _CustomPopoverState();
}

class _CustomPopoverState extends State<CustomPopover> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showPopover() {
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: widget.barrierDismissible ? _removePopover : null,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 40), // المسافة تحت الزر
              child: Material(
                color: Colors.transparent,
                child: widget.popoverBuilder(context),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showPopover();
          } else {
            _removePopover();
          }
        },
        child: widget.child,
      ),
    );
  }
}
