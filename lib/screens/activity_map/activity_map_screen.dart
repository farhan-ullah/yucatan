import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/activity_list_screen/components/activily_list_item_shimmer.dart';
import 'package:yucatan/screens/activity_list_screen/components/activity_list_item_view.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/response/activity_multi_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/services/user_service.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/Callbacks.dart';
import 'package:yucatan/utils/DialogUtils.dart';
import 'package:yucatan/utils/datefulWidget/DateStatefulWidget.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class ActivityMapScreen extends DateStatefulWidget {
  @override
  _ActivityMapScreenState createState() => _ActivityMapScreenState();
}

class _ActivityMapScreenState extends DateState<ActivityMapScreen> {
  // Initial Map Position
  LatLng _initialcameraposition = LatLng(49.0083509, 13.2255874);

  // Maps
  // GoogleMapController _controller;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set<Marker>();
  bool zoomedToLocation = false;
  Uint8List? markerIconSmall /*,markerIconSmall1*/;

  Uint8List? markerIconLarge /*,markerIconLarge1*/;

  loc.Location _location = loc.Location();
  CarouselController carouselController = CarouselController();

  List<ActivityModel> activities = <ActivityModel>[];
  ActivityModel? currentlyLargeMarkerActivity;

  bool collapsed = false;
  DateTime selectedDate = DateTime.now();

  UserLoginModel? _user;
  List<String>? _favoriteActivities = [];
  bool? showAppBar;

  @override
  void initState() {
    showAppBar = true;
    _loadActivities();
    _loadMarkerIcons();
    _loadFavoriteActivities();

    selectedDate = GlobalDate.current();

    super.initState();
  }

  @override
  void dispose() {
    eventBus.fire(OnMapClickCallback(true));
    super.dispose();
  }

  @override
  onDateChanged(DateTime dateTime) {
    if (mounted) {
      setState(() {
        selectedDate = dateTime;
      });
    }
  }

  _loadMarkerIcons() async {
    markerIconSmall = await getBytesFromAsset(
        'lib/assets/images/location_marker_small.png',
        Dimensions.getScaledSize(28.0).toInt());
    markerIconLarge = await getBytesFromAsset(
        'lib/assets/images/location_marker_large.png',
        Dimensions.getScaledSize(90.0).toInt());
  }

  void _loadFavoriteActivities() async {
    _user = await UserProvider.getUser();

    if (_user == null) return;

    _favoriteActivities =
        await UserService.getFavoriteActivitiesForUser(_user!.sId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition, zoom: 8),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  markers: markers,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  onTap: (LatLng latLng) {
                    showAppBar = !showAppBar!;
                    eventBus.fire(OnMapClickCallback(showAppBar!));
                  },
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: new EdgeInsets.all(
                                  Dimensions.getScaledSize(10.0)),
                              child: Container(
                                height: Dimensions.getScaledSize(50.0),
                                width: Dimensions.getScaledSize(50.0),
                                child: FloatingActionButton(
                                  heroTag: "activity_map_screen_1",
                                  onPressed: _currentLocation,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.gps_fixed,
                                    color: CustomTheme.primaryColorDark,
                                    size: Dimensions.getScaledSize(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: Padding(
                          //     padding: new EdgeInsets.all(
                          //         Dimensions.getScaledSize(10.0)),
                          //     child: Container(
                          //       height: Dimensions.getScaledSize(50.0),
                          //       width: Dimensions.getScaledSize(50.0),
                          //       child: DateSelector(onDateSelected: (date) {
                          //         _onDateSelected(date);
                          //       }),
                          //     ),
                          //   ),
                          // ),
                          CarouselSlider(
                            carouselController: carouselController,
                            items: _buildRecommendedActivities(activities),
                            options: CarouselOptions(
                              height: Dimensions.getHeight(percentage: 29.0),
                              viewportFraction: 0.7,
                              onPageChanged: (index, reason) {
                                Vibrate.feedback(FeedbackType.selection);

                                _setLargeIconForActivity(activities[index]);
                                _adjustMapsCamera(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller.complete(_cntlr);
    _location.onLocationChanged.listen((l) async {
      if (zoomedToLocation == false) {
        zoomedToLocation = true;
        final GoogleMapController controller = await _controller.future;
        if (mounted) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(l.latitude!, l.longitude!), zoom: 8),
            ),
          );
        }
      }
    });
  }

  /*void updateMarkerIconOnZoom(bool isSmallMarker){
    Set<Marker> localMarkers = Set<Marker>();
    if (activities  != null) {
      activities.forEach(
            (element) async {
          if (element.location.lat != null && element.location.lon != null) {
            localMarkers.add(
              Marker(
                markerId: MarkerId(element.sId),
                icon: isSmallMarker
                    ? BitmapDescriptor.fromBytes(markerIconSmall1)
                    : BitmapDescriptor.fromBytes(markerIconSmall),
                position: LatLng(
                  double.parse(element.location.lat),
                  double.parse(element.location.lon),
                ),
                onTap: () {
                  setState(() {
                    collapsed = false;
                  });
                  _setLargeIconForActivity(element);
                  _animateToActivity(element);
                },
              ),
            );
          }
        },
      );
    }
    setState(() {
      markers = localMarkers;
    });
  }*/

  void _loadActivities() async {
    ActivityMultiResponse? result = await ActivityService.getAll();

    Set<Marker> localMarkers = Set<Marker>();

    if (result!.errors == null) {
      activities = result.data!;
      result.data!.forEach(
        (element) async {
          if (element.location!.lat != null && element.location!.lon != null) {
            localMarkers.add(
              Marker(
                markerId: MarkerId(element.sId!),
                icon: BitmapDescriptor.fromBytes(markerIconSmall!),
                position: LatLng(
                  double.parse(element.location!.lat!),
                  double.parse(element.location!.lon!),
                ),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      collapsed = false;
                    });
                  }
                  _setLargeIconForActivity(element);
                  _animateToActivity(element);
                },
              ),
            );
          }
        },
      );
    }

    if (mounted) {
      setState(() {
        markers = localMarkers;
      });
    }
  }

  List<Widget> _buildRecommendedActivities(List<ActivityModel> activities) {
    List<Widget> widgets = [];

    activities.forEach(
      (element) {
        widgets.add(
          ActivityListViewItem(
            isComingFromFullMapScreen: true,
            activityModel: element,
            isFavorite: _favoriteActivities!.contains(element.sId),
            width: Dimensions.getWidth(percentage: 75.0),
            onFavoriteChangedCallback: (String activityId) {
              if (mounted) {
                setState(() {
                  if (_favoriteActivities!.contains(activityId))
                    _favoriteActivities!.remove(activityId);
                  else
                    _favoriteActivities!.add(activityId);
                });
              }
            },
          ),
        );
      },
    );

    if (widgets.isEmpty) {
      widgets.add(ActivityListViewShimmer(
        width: Dimensions.getWidth(percentage: 75.0),
        isComingFromFullMapScreen: true,
      ));
    }

    return widgets;
  }

  void _animateToActivity(ActivityModel activity) {
    if (collapsed == false) {
      var index = activities.indexOf(activity);
      carouselController.jumpToPage(
        index,
      );
    }
  }

  void _adjustMapsCamera(int index) async {
    var activity = activities[index];
    if (activity.location!.lat != null && activity.location!.lon != null) {
      final GoogleMapController controller = await _controller.future;
      var zoom = await controller.getZoomLevel();
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                double.parse(activity.location!.lat!),
                double.parse(activity.location!.lon!),
              ),
              zoom: zoom),
        ),
      );
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _setMarkerIconForMarker(ActivityModel activity, Uint8List icon) {
    if (activity.location!.lat != null && activity.location!.lon != null) {
      markers.removeWhere((element) => element.markerId.value == activity.sId);
      markers.add(
        Marker(
          markerId: MarkerId(activity.sId!),
          icon: BitmapDescriptor.fromBytes(icon),
          position: LatLng(
            double.parse(activity.location!.lat!),
            double.parse(activity.location!.lon!),
          ),
          onTap: () {
            if (mounted) {
              setState(() {
                collapsed = false;
              });
            }
            _setLargeIconForActivity(activity);
            _animateToActivity(activity);
          },
        ),
      );
    }
  }

  void _setLargeIconForActivity(ActivityModel activity) {
    if (mounted) {
      setState(() {
        if (currentlyLargeMarkerActivity != null) {
          _setMarkerIconForMarker(
              currentlyLargeMarkerActivity!, markerIconSmall!);
        }
        currentlyLargeMarkerActivity = activity;
        _setMarkerIconForMarker(activity, markerIconLarge!);
      });
    }
  }

  void _currentLocation() async {
    if (Platform.isIOS) {
      PermissionStatus permissionStatus =
          await requestPermission(Permission.location);
      //print("PermissionStatus=${permissionStatus}");
      if (permissionStatus == PermissionStatus.granted) {
        //print('Permission granted');
      } else if (permissionStatus == PermissionStatus.denied) {
        //print('Denied. Show a dialog with a reason and again ask for the permission.');
        PermissionStatus permissionStatus =
            await requestPermission(Permission.location);
        if (permissionStatus != PermissionStatus.granted) {
          //print("permission not granted");
          return;
        }
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        //Take the user to the settings page.
        var result = await DialogUtils.displayDialog(
            context,
            AppLocalizations.of(context)!
                .location_permission_denied_alert_title,
            AppLocalizations.of(context)!.location_permission_denied_alert_body,
            AppLocalizations.of(context)!.actions_cancel,
            AppLocalizations.of(context)!.commonWords_ok,
            showCancelButton: true,
            showOKButton: true);
        if (result == true) {
          await openAppSettings();
          return;
        }
      }
    }

    loc.Location _location = new loc.Location();
    loc.LocationData? location;

    try {
      location = await _location.getLocation();
    } on PlatformException catch (e) {
      print(e.message);
      location = null;
    }
    if (location == null) {
      print("location is null");
      return;
    }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(location.latitude!, location.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  PermissionStatus? permissionStatus;
  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    permissionStatus = status;
    return permissionStatus!;
  }
}
