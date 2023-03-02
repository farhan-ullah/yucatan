import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/file_model.dart';
import 'package:yucatan/screens/hotelDetailes/images_fullscreen_view.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HotelRoomeList extends StatefulWidget {
  final ActivityModel activity;

  HotelRoomeList({required this.activity});

  @override
  _HotelRoomeListState createState() => _HotelRoomeListState();
}

class _HotelRoomeListState extends State<HotelRoomeList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.getScaledSize(20.0),
        bottom: Dimensions.getScaledSize(20.0),
      ),
      child: Column(
        children: [
          Container(
            height: Dimensions.getHeight(percentage: 17.0),
            child: CarouselSlider(
              items:
                  _buildImages(widget.activity.activityDetails!.media!.photos!),
              options: CarouselOptions(
                height: Dimensions.getHeight(percentage: 17.0),
                viewportFraction: 0.5,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildImages(List<FileModel> files) {
    List<Widget> images = [];

    for (var file in files) {
      images.add(
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(Dimensions.getScaledSize(10.0))),
          // padding: EdgeInsets.only(
          //   left: Dimensions.getScaledSize(10.0),
          //   right: Dimensions.getScaledSize(10.0),
          // ),
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImagesFullscreenView(
                          activity: widget.activity,
                          imageUrl: file.publicUrl!,
                        ),
                    fullscreenDialog: true),
              );
            },
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(Dimensions.getScaledSize(10.0)),
              child: Stack(
                children: [
                  loadCachedNetworkImage(
                    file.publicUrl!,
                    fit: BoxFit.cover,
                    height: Dimensions.getHeight(percentage: 17.0),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                        height: Dimensions.getHeight(percentage: 8.0),
                        width: MediaQuery.of(context).size.width),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return images;
  }
}
