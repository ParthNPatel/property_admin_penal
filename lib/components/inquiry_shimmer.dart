import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../responsive/responsive.dart';

class InquiryShimmer extends StatelessWidget {
  const InquiryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Responsive.isDesktop(context) ? 200.sp : 100.sp,
                child: Card(
                  child: Container(
                    height: 80,
                    width: Responsive.isDesktop(context) ? 200.sp : 100.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey,
      direction: ShimmerDirection.ltr,
    );
  }
}
