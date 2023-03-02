import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/file_model.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesFullscreenView extends StatefulWidget {
  final ActivityModel activity;
  final String imageUrl;

  ImagesFullscreenView({required this.activity, required this.imageUrl});

  @override
  _ImagesFullscreenViewState createState() => _ImagesFullscreenViewState();
}

class _ImagesFullscreenViewState extends State<ImagesFullscreenView> {
  String currentImage = "";
  List<String> sortedImages = [];

  @override
  void initState() {
    super.initState();
    currentImage = widget.imageUrl;
    sortedImages = _getSortedImages(
        widget.activity.activityDetails!.media!.photos!, widget.imageUrl);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
          ),
          Builder(
            builder: (context) {
              return Container(
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          CachedNetworkImageProvider(sortedImages[index]),
                      initialScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(tag: index),
                      maxScale: PhotoViewComputedScale.contained * 4.0,
                      minScale: PhotoViewComputedScale.contained * 1.0,
                    );
                  },
                  customSize: Size(Dimensions.getWidth(percentage: 98.5),
                      Dimensions.getHeight(percentage: 100.0)),
                  itemCount: sortedImages.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: Dimensions.getScaledSize(20.0),
                      height: Dimensions.getScaledSize(20.0),
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  onPageChanged: (index) {
                    setState(() {
                      currentImage = sortedImages[index];
                    });
                  },
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: AppBar().preferredSize.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.getScaledSize(8.0),
                          left: Dimensions.getScaledSize(8.0)),
                      child: Container(
                        width: AppBar().preferredSize.height -
                            Dimensions.getScaledSize(8.0),
                        height: AppBar().preferredSize.height -
                            Dimensions.getScaledSize(8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.4),
                            shape: BoxShape.circle),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimensions.getScaledSize(32.0)),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.all(Dimensions.getScaledSize(8.0)),
                              child:
                                  Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${sortedImages.indexOf(currentImage) + 1}/${widget.activity.activityDetails!.media!.photos!.length}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: Dimensions.getScaledSize(56.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getSortedImages(List<FileModel> files, String clickedImageUrl) {
    List<String> sortedImageUrls = [];

    int clickedImageIndex =
        files.indexWhere((element) => element.publicUrl == clickedImageUrl);

    sortedImageUrls.add(clickedImageUrl);

    for (var i = clickedImageIndex + 1; i < files.length; i++) {
      sortedImageUrls.add(files[i].publicUrl!);
    }

    for (var i = 0; i < clickedImageIndex; i++) {
      sortedImageUrls.add(files[i].publicUrl!);
    }

    return sortedImageUrls;
  }
}
