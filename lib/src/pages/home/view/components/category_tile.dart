import 'package:app_quitanda/src/config/custom_colors.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile(
      {super.key,
      required this.category,
      required this.isSelected,
      required this.onPressed});

  final String category;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: widget.onPressed,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? CustomColors.customSwatchColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.category,
            style: TextStyle(
                color: widget.isSelected
                    ? Colors.white
                    : CustomColors.customContrastColor,
                fontWeight: FontWeight.bold,
                fontSize: widget.isSelected ? 16 : 14),
          ),
        ),
      ),
    );
  }
}
