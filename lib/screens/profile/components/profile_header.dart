import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../profile_event_handler.dart';

class ProfileHeader extends StatefulWidget {
  final UserLoginModel? model;
  final ProfileEventHandler? eventHandler;

  const ProfileHeader({Key? key, this.model, this.eventHandler})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ProfileHeaderState(model!, eventHandler!);
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? _username;

  _ProfileHeaderState(UserLoginModel model, ProfileEventHandler eventHandler) {
    this._username = model.username;
    eventHandler.subscribe(_profileEventListener);
    eventHandler.subscribeUsername(_profileUsernameEventListener);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.eventHandler?.broadcastState(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.getScaledSize(32.0),
        right: Dimensions.getScaledSize(32.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: Dimensions.getScaledSize(40.0),
            backgroundColor: CustomTheme.primaryColorLight,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                child: Center(
                    child: Text(
                  _username!.isEmpty ? "U" : _username![0],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: Dimensions.getScaledSize(64.0),
                    fontWeight: FontWeight.w100,
                  ),
                )),
              ),
            ),
          ),
          SizedBox(
            width: Dimensions.getScaledSize(20.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _username ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: CustomTheme.primaryColorLight,
                          fontSize: Dimensions.getScaledSize(22.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                /*Row(
                  children: [
                    Flexible(
                      child: Text(
                        _model.email ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimensions.getScaledSize(12.0),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.getScaledSize(5.0),
                ),
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => this.setState(() {
                          if(!_isEdit){
                            _isEdit = true;
                            widget.eventHandler?.broadcastState(true);
                          }
                        }),
                        child: Text(
                          _isEdit ? 'In Bearbeitung' : 'Profil bearbeiten',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CustomTheme.primaryColorLight,
                            fontSize: Dimensions.getScaledSize(12.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  _profileEventListener(bool isEdit) {
    this.setState(() {});
  }

  _profileUsernameEventListener(String username) {
    this.setState(() {
      this._username = username;
    });
  }
}
