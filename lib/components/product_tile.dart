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
  final status;
  final VoidCallback? onEdit;
  final VoidCallback? onAdd;
  final VoidCallback? onDelete;

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
    this.status,
    this.onAdd,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(top: 7, bottom: 7, right: 20),
              decoration: BoxDecoration(
                color: CommonColor.greyColorF2F2F2,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 50.sp,
              child: CommonText.textBoldWight700(text: title, fontSize: 15),
            ),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 50.sp,
              child: CommonText.textBoldWight400(
                  text: subtitle,
                  fontSize: 14,
                  color: CommonColor.greyColor838589),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 25.sp,
              child: CommonText.textBoldWight700(text: price, fontSize: 15),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: Center(
                child: CommonText.textBoldWight700(
                    color: Colors.grey,
                    textDecoration: TextDecoration.lineThrough,
                    text: totalBedroom,
                    fontSize: 13),
              ),
              width: 50.sp,
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 50.sp,
                child: Center(
                  child: CommonText.textBoldWight700(
                      text: totalWashroom, fontSize: 15),
                )),
            SizedBox(
              width: 10,
            ),
            // SizedBox(
            //   width: 50.sp,
            //   child:
            //       CommonText.textBoldWight700(text: subCategory, fontSize: 15),
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
                width: 30.sp,
                child: Center(
                  child:
                      CommonText.textBoldWight700(text: status, fontSize: 15),
                )),
            SizedBox(
              width: 10,
            ),
            // SizedBox(
            //   width: 50.sp,
            //   child: CommonText.textBoldWight700(text: season, fontSize: 15),
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
              width: 50.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonText.textBoldWight700(
                      color: Colors.black, text: "5", fontSize: 13),
                  Icon(
                    Icons.star,
                    size: 15,
                    color: CommonColor.yellowColor,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: onDelete,
              child: Container(
                height: 10.sp,
                width: 10.sp,
                decoration: BoxDecoration(
                  border: Border.all(color: themColors309D9D, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.delete,
                  size: 20,
                  color: CommonColor.greyColor838589,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: onEdit,
              child: Container(
                height: 10.sp,
                width: 10.sp,
                decoration: BoxDecoration(
                  border: Border.all(color: themColors309D9D, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: CommonColor.greyColor838589,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: onAdd,
              child: Container(
                height: 10.sp,
                width: 10.sp,
                decoration: BoxDecoration(
                  border: Border.all(color: themColors309D9D, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: CommonColor.greyColor838589,
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
