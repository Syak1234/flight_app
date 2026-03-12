import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart' as bc;
import '../../../../core/theme/app_colors.dart';

class BarcodeWidget extends StatelessWidget {
  final String data;
  const BarcodeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: bc.BarcodeWidget(
        barcode: bc.Barcode.code128(),
        data: data,
        color: AppColors.textPrimary,
        drawText: false,
        width: 230,
        height: 60,
      ),
    );
  }
}
