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
  final size;
  final rating;
  final totalBedroom;
  final totalWashroom;
  final VoidCallback? onEdit;

  const ProductTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.size,
    required this.rating,
    this.onEdit,
    this.totalBedroom,
    this.totalWashroom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            CommonText.textBoldWight700(text: "${price}/year", fontSize: 15),
            SizedBox(
              width: 1.w,
            ),
            Row(
              children: [
                CommonText.textBoldWight700(
                    color: themColors309D9D, text: "Size: ", fontSize: 13),
                CommonText.textBoldWight700(
                    color: Colors.grey, text: size, fontSize: 13),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CommonText.textBoldWight700(
                    text: totalBedroom, fontSize: 13, color: Colors.grey),
                CommonText.textBoldWight700(
                    color: themColors309D9D, text: " Bedroom", fontSize: 11),
              ],
            ),
            SizedBox(
              width: 1.w,
            ),
            Row(
              children: [
                CommonText.textBoldWight700(
                    color: Colors.grey, text: totalWashroom, fontSize: 13),
                CommonText.textBoldWight700(
                    color: themColors309D9D, text: " Bathroom", fontSize: 11),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.star,
            size: 15,
            color: CommonColor.yellowColor,
          ),
          SizedBox(
            width: 5,
          ),
          CommonText.textBoldWight400(
              text: rating, fontSize: 15, color: CommonColor.greyColor838589),
        ]),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
