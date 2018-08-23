import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class HomeShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Shimmer.fromColors(child: null, baseColor: null, highlightColor: null)
    );
  }
}
