import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TicketDivider extends StatelessWidget {
  final double indent;
  final double endIndent;
  final double verticalPadding;
  final Color? color;

  const TicketDivider({
    super.key,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.verticalPadding = 10.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: verticalPadding,
        bottom: verticalPadding,
        left: indent,
        right: endIndent,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 6.0;
          const dashHeight = 1.2; // Slightly thicker for better visibility
          final dashCount = (boxWidth / (2 * dashWidth)).floor();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color ?? AppColors.divider,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
