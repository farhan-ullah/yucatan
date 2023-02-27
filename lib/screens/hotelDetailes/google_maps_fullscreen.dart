import 'package:appventure/components/custom_app_bar.dart';
import 'package:appventure/models/activity_model.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:map_launcher/map_launcher.dart' as maplauncher;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleMapsFullscreen extends StatefulWidget {
  final ActivityModelLocation location;
  final String destinationTitle;

  GoogleMapsFullscreen({this.location, this.destinationTitle});

  @override
  _GoogleMapsFullscreenState createState() => _GoogleMapsFullscreenState();
}

class _GoogleMapsFullscreenState extends State<GoogleMapsFullscreen> {
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: AppLocalizations.of(context).googleMapScreen_title,
        centerTitle: true,
      ),
      floatingActionButton: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(
              horizontal: Dimensions.getScaledSize(15.0),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(widget.location.lat),
                double.parse(widget.location.lon),
              ),
              zoom: 14,
            ),
            markers: [
              Marker(
                markerId: MarkerId('0'),
                position: LatLng(
                  double.parse(widget.location.lat),
                  double.parse(widget.location.lon),
                ),
              ),
            ].toSet(),
            onMapCreated: _onMapCreated,
            compassEnabled: false,
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            buildingsEnabled: false,
            trafficEnabled: false,
            tiltGesturesEnabled: false,
            mapType: MapType.satellite,
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: new EdgeInsets.only(bottom: 40.0, right: 10.0),
                  child: Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: Container(
                      height: Dimensions.getScaledSize(50.0),
                      width: Dimensions.getScaledSize(50.0),
                      child: FloatingActionButton(
                        heroTag: "google_maps_fullscreen_1",
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
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: new EdgeInsets.only(bottom: 115.0, right: 10.0),
                  child: Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: Container(
                      height: Dimensions.getScaledSize(50.0),
                      width: Dimensions.getScaledSize(50.0),
                      child: FloatingActionButton(
                        heroTag: "google_maps_fullscreen_2",
                        onPressed: _launchMapForActivity,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.navigation,
                          color: CustomTheme.primaryColorDark,
                          size: Dimensions.getScaledSize(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

  void _launchMapForActivity() async {
    final availableMaps = await maplauncher.MapLauncher.installedMaps;
    final coords = maplauncher.Coords(
        double.parse(widget.location.lat), double.parse(widget.location.lon));

    availableMaps.first.showDirections(
      destination: coords,
      destinationTitle: widget.destinationTitle,
    );
  }

  void _currentLocation() async {
    loc.Location _location = new loc.Location();
    loc.LocationData location;

    try {
      location = await _location.getLocation();
    } on PlatformException catch (e) {
      print(e.message);
      location = null;
    }

    this._controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(location.latitude, location.longitude),
            zoom: 17.0,
          ),
        ));
  }
}
