import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import 'favourite_button.dart';

class ProductTile extends StatelessWidget {
  final image;
  final title;
  final subtitle;
  final price;
  final oldPrice;
  final rating;
  final VoidCallback? onEdit;

  const ProductTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.oldPrice,
    required this.rating,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: CommonColor.greyColorF2F2F2,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover),
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
                    onTap: onEdit,
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: CommonColor.greyColor838589,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CommonText.textBoldWight700(text: title, fontSize: 15),
        SizedBox(
          height: 5,
        ),
        CommonText.textBoldWight400(
            text: subtitle, fontSize: 14, color: CommonColor.greyColor838589),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText.textBoldWight700(text: price, fontSize: 15),
            SizedBox(
              width: 1.w,
            ),
            CommonText.textBoldWight700(
                color: CommonColor.greyColorD9D9D9,
                textDecoration: TextDecoration.lineThrough,
                text: oldPrice,
                fontSize: 13),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              size: 10,
              color: CommonColor.yellowColor,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CommonText.textBoldWight400(
            text: rating, fontSize: 13, color: CommonColor.greyColor838589),
      ],
    );
  }
}
