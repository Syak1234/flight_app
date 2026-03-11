import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart' as bc;
import '../../../../core/theme/app_colors.dart';

class BarcodeWidget extends StatelessWidget {
  const BarcodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: bc.BarcodeWidget(
        barcode: bc.Barcode.code128(),
        data:
            'BC-IDV-98242113XP', // Longer data string creates more dense lines
        color: AppColors.textPrimary,
        drawText: false,
        width: 230,
        height: 60,
      ),
    );
  }
}
