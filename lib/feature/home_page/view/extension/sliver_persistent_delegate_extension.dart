import 'package:flutter/material.dart';

class Delegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  Delegate(this.child);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 125;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
