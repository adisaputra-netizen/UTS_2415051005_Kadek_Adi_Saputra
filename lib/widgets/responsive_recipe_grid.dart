import 'package:flutter/material.dart';

/// Widget grid resep yang responsif menyesuaikan lebar layar:
/// - Lebar >= 900px: 3 kolom
/// - Lebar >= 600px: 2 kolom
/// - Lebar < 600px: 1 kolom (tampilan list mobile)
class ResponsiveRecipeGrid extends StatelessWidget {
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final double mainAxisExtent;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const ResponsiveRecipeGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(12.0),
    this.mainAxisExtent = 88.0,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            mainAxisExtent: mainAxisExtent,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
