import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../responsive/responsive.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 10,
            mainAxisExtent: 350),
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  top: 4.sp,
                  right: 16.sp,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4.sp,
                  right: 4.sp,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 15,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey,
      direction: ShimmerDirection.ltr,
    );
  }
}



