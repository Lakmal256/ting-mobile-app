import 'package:flutter/material.dart';

class CustomSearchIconButton extends StatelessWidget {
  const CustomSearchIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20)),
      child: const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 25, vertical: 5),
        child: Icon(Icons.search, color: Colors.white),
      )),
    );
  }
}