import 'package:flutter/material.dart';
import 'ticket_divider.dart';

class TicketWidget extends StatelessWidget {
  final Widget top;
  final Widget bottom;
  final double borderRadius;
  final double notchRadius;
  final double dividerIndent;
  final double dividerEndIndent;

  const TicketWidget({
    super.key,
    required this.top,
    required this.bottom,
    this.borderRadius = 32.0,
    this.notchRadius = 12.0,
    this.dividerIndent = 24.0,
    this.dividerEndIndent = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _TicketInternal(
            top: top,
            bottom: bottom,
            borderRadius: borderRadius,
            notchRadius: notchRadius,
            dividerIndent: dividerIndent,
            dividerEndIndent: dividerEndIndent,
          );
        },
      ),
    );
  }
}

class _TicketInternal extends StatefulWidget {
  final Widget top;
  final Widget bottom;
  final double borderRadius;
  final double notchRadius;
  final double dividerIndent;
  final double dividerEndIndent;

  const _TicketInternal({
    required this.top,
    required this.bottom,
    required this.borderRadius,
    required this.notchRadius,
    required this.dividerIndent,
    required this.dividerEndIndent,
  });

  @override
  State<_TicketInternal> createState() => _TicketInternalState();
}

class _TicketInternalState extends State<_TicketInternal> {
  double _splitY = 0;
  final GlobalKey _topKey = GlobalKey();

  void _calculateSplit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final RenderBox? box =
          _topKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final newSplitY = box.size.height + 10.5;
        if (_splitY != newSplitY) {
          setState(() {
            _splitY = newSplitY;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateSplit();
  }

  @override
  void didUpdateWidget(covariant _TicketInternal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateSplit();
  }

  @override
  Widget build(BuildContext context) {
    _calculateSplit();
    return ClipPath(
      clipper: _TicketSideClipper(
        splitY: _splitY,
        notchRadius: widget.notchRadius,
        borderRadius: widget.borderRadius,
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(key: _topKey, child: widget.top),
            TicketDivider(
              indent: widget.dividerIndent,
              endIndent: widget.dividerEndIndent,
            ),
            widget.bottom,
          ],
        ),
      ),
    );
  }
}

class _TicketSideClipper extends CustomClipper<Path> {
  final double splitY;
  final double notchRadius;
  final double borderRadius;

  _TicketSideClipper({
    required this.splitY,
    required this.notchRadius,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.addRRect(
      RRect.fromLTRBR(
        0,
        0,
        size.width,
        size.height,
        Radius.circular(borderRadius),
      ),
    );

    if (splitY > 0) {
      final Path cutouts = Path();
      cutouts.addOval(
        Rect.fromCircle(center: Offset(0, splitY), radius: notchRadius),
      );
      cutouts.addOval(
        Rect.fromCircle(
          center: Offset(size.width, splitY),
          radius: notchRadius,
          ),
      );
      return Path.combine(PathOperation.difference, path, cutouts);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant _TicketSideClipper oldClipper) {
    return oldClipper.splitY != splitY;
  }
}
