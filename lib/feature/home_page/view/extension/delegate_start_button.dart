import 'package:flutter/cupertino.dart';

class StartButtonDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  StartButtonDelegate(this.child);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
