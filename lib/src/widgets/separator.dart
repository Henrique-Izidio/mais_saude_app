import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({
    Key? key,
    required this.isSliver,
    required this.isColumn,
    required this.value,
  }) : super(key: key);

  final bool isSliver;
  final bool isColumn;
  final double value;

  @override
  Widget build(BuildContext context) {
    if (isSliver) {
      return SliverList(
        delegate: SliverChildListDelegate([
          spacer(),
        ]),
      );
    } else {
      return spacer();
    }
  }

  Widget spacer() {
    if (isColumn) {
      return SizedBox(
        height: value,
      );
    } else {
      return SizedBox(
        height: value,
      );
    }
  }
  
}
