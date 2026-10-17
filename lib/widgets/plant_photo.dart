import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class PlantPhoto extends StatelessWidget {
  const PlantPhoto({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.heroTag,
    this.borderRadius,
    this.gradient,
  });

  final String asset;
  final BoxFit fit;
  final String? heroTag;
  final BorderRadius? borderRadius;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      asset,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => const _Fallback(),
    );

    if (gradient != null) {
      image = Stack(
        fit: StackFit.expand,
        children: [
          image,
          DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
        ],
      );
    }

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }
    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }
    return image;
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.sprout, AppColors.leaf],
        ),
      ),
      child: Center(
        child: Icon(Icons.eco_outlined, color: Colors.white70, size: 32),
      ),
    );
  }
}

const LinearGradient plantScrim = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Colors.transparent, Color(0xCC10241A)],
  stops: [0.4, 1.0],
);
