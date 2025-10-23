import 'package:flutter/material.dart';
import 'package:code_test_flutter/core/platform_meta.dart';

class RippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color splashColor;
  final BorderRadius borderRadius;
  final PlatformMeta platform;

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = BorderRadius.zero,
    this.splashColor = Colors.white24,
    this.platform = PlatformMeta.instance,
  });

  @override
  Widget build(BuildContext context) {
    if (platform.isIos) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    } else {
      return Material(
          borderRadius: borderRadius,
          color: Colors.transparent,
          child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: borderRadius),
            splashColor: splashColor,
            onTap: onTap,
            child: child,
          ));
    }
  }
}
