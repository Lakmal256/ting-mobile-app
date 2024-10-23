import 'package:app/themes/themes.dart';
import 'package:flutter/material.dart';

class HeaderWithBackButtonWidget extends StatelessWidget {
  const HeaderWithBackButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.navigate_before_outlined,
                color: Colors.white, size: 40)),
        Hero(
          tag: 'logo',
          child: Image.asset(AssestPath.assestLogoPath,
              width: 100.0, fit: BoxFit.cover),
        ),
      ],
    );
  }
}
