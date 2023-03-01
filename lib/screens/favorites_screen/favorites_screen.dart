import 'package:yucatan/components/BaseState.dart';
import 'package:yucatan/components/custom_error_screen.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/favorites_screen/favorites_item_shimmer.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/search_screen/components/search_activity_item_view.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/service_locator.dart';
import 'package:yucatan/services/user_service.dart';
import 'package:yucatan/utils/Callbacks.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/favorite_activities_for_user_bloc.dart';
import 'bloc/favourite_bloc.dart';
import 'bloc/user_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  static final route = "/favorites";

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends BaseState<FavoritesScreen> {
  //Future<UserLoginModel> user;
  //Future<List<String>> favoriteActivitesFuture;
  List<String> favoriteActivities = [];
  String? userId;
  final userLoginModelBloc = getIt<UserLoginModelBloc>();
  final favoriteActivitiesForUserBloc = getIt<FavoriteActivitiesForUserBloc>();
  final getActivityBloc = getIt<GetActivityBloc>();

  @override
  void initState() {
    super.initState();
    userLoginModelBloc.eventSink.add(UserLoginAction.FetchLoggedInUser);
    //user = UserProvider.getUser();
    //this.network.offline => To check if connected to internet. Just extends your state with BaseState
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserLoginModel>(
      stream: userLoginModelBloc.userModelStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return CustomErrorEmptyScreen(
            topPadding: Scaffold.of(context).appBarMaxHeight!,
            title: AppLocalizations.of(context)!.commonWords_mistake,
            description:
                AppLocalizations.of(context)!.favoritesScreen_logInToSee,
            //image: "lib/assets/images/favorites_empty.png",
            rive: RiveAnimation(
              riveFileName: 'favorites_animiert_loop.riv',
              riveAnimationName: 'Animation 1',
              placeholderImage: 'lib/assets/images/favorites_empty.png',
              startAnimationAfterMilliseconds: 0,
            ),
            customButtonText: AppLocalizations.of(context)!.loginSceen_login,
            callback: _navigateToLogin,
          );
        } else if (snapshot.hasData) {
          userId = snapshot.data!.sId;
          favoriteActivitiesForUserBloc.setUserId(userId!);
          favoriteActivitiesForUserBloc.eventSink.add(
              FavoriteActivitiesForUserAction.FetchFavoriteActivitiesForUser);
          return StreamBuilder<List<String>>(
            stream:
                favoriteActivitiesForUserBloc.favoriteActivitiesForUserStream,
            builder: (context, snapshotFavorites) {
              if (snapshotFavorites.data == null ||
                  snapshotFavorites.data!.length == 0) {
                return CustomErrorEmptyScreen(
                  topPadding: Scaffold.of(context).appBarMaxHeight!,
                  title: AppLocalizations.of(context)!.commonWords_mistake,
                  description: AppLocalizations.of(context)!
                      .noFavoritesScreen_noFavorites,
                  //image: "lib/assets/images/favorites_empty.png",
                  rive: RiveAnimation(
                    riveFileName: 'favorites_animiert_loop.riv',
                    riveAnimationName: 'Animation 1',
                    placeholderImage: 'lib/assets/images/favorites_empty.png',
                    startAnimationAfterMilliseconds: 0,
                  ),
                  customButtonText: AppLocalizations.of(context)!
                      .noFavoritesScreen_goToSearch,
                  callback: () {
                    eventBus.fire(OnOpenSearch());
                  },
                );
              } else if (snapshotFavorites.hasData) {
                favoriteActivities = snapshotFavorites.data!;
                //print("favoriteActivities=${favoriteActivities.length}");
                double height = Scaffold.of(context).appBarMaxHeight!;
                getActivityBloc.sendFavoriteActivities(favoriteActivities);
                getActivityBloc.eventSink.add(GetActivityAction.FetchActivity);
                return StreamBuilder<List<ActivitySingleResponse>>(
                  stream: getActivityBloc.getActivtyStream,
                  builder: (context, snapshotActivity) {
                    if (snapshotActivity.hasData) {
                      if (snapshotActivity.data == null) {
                        return Container();
                      } else {
                        if (snapshotActivity.data == null ||
                            snapshotActivity.data!.length == 0) {
                          return CustomErrorEmptyScreen(
                            topPadding: Scaffold.of(context).appBarMaxHeight!,
                            title: AppLocalizations.of(context)!
                                .commonWords_mistake,
                            description: AppLocalizations.of(context)!
                                .noFavoritesScreen_noFavorites,
                            //image: "lib/assets/images/favorites_empty.png",
                            rive: RiveAnimation(
                              riveFileName: 'favorites_animiert_loop.riv',
                              riveAnimationName: 'Animation 1',
                              placeholderImage:
                                  'lib/assets/images/favorites_empty.png',
                              startAnimationAfterMilliseconds: 0,
                            ),
                            customButtonText: AppLocalizations.of(context)!
                                .noFavoritesScreen_goToSearch,
                            callback: () {
                              eventBus.fire(OnOpenSearch());
                            },
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(0, height, 0, 0),
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                top: Dimensions.getScaledSize(20.0),
                                left: Dimensions.getScaledSize(20.0),
                                bottom: Dimensions.getScaledSize(20.0),
                                right: Dimensions.getScaledSize(20.0),
                              ),
                              itemCount: snapshotActivity.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Dimensions.getScaledSize(5.0),
                                  ),
                                  child: SearchActivityItemView(
                                    activity: snapshotActivity.data![index].data!,
                                    onFavoriteChangedCallback:
                                        _onFavoriteDeleted,
                                    isfav: true,
                                    userData: snapshot.data,
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: Dimensions.getScaledSize(10.0),
                          left: Dimensions.getScaledSize(20.0),
                          bottom: Dimensions.getScaledSize(20.0),
                          right: Dimensions.getScaledSize(20.0),
                        ),
                        child: Center(
                          child: Text('${snapshot.error}'),
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        top: Dimensions.getScaledSize(120.0),
                        left: Dimensions.getScaledSize(20.0),
                        right: Dimensions.getScaledSize(20.0),
                      ),
                      child: FavoritesItemShimmer(),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: Dimensions.getScaledSize(10.0),
                    left: Dimensions.getScaledSize(20.0),
                    bottom: Dimensions.getScaledSize(20.0),
                    right: Dimensions.getScaledSize(20.0),
                  ),
                  child: Center(
                    child: Text('${snapshot.error}'),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(
                  top: Dimensions.getScaledSize(10.0),
                  left: Dimensions.getScaledSize(20.0),
                  bottom: Dimensions.getScaledSize(20.0),
                  right: Dimensions.getScaledSize(20.0),
                ),
                child: FavoritesItemShimmer(),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.only(
              top: Dimensions.getScaledSize(10.0),
              left: Dimensions.getScaledSize(20.0),
              bottom: Dimensions.getScaledSize(20.0),
              right: Dimensions.getScaledSize(20.0),
            ),
            child: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onFavoriteDeleted(ActivityModel activity) async {
    await UserService.deleteUserFavoriteActivity(
        userId: userId, activityId: activity.sId);
    favoriteActivities.remove(activity.sId);
    getActivityBloc.sendFavoriteActivities(favoriteActivities);
    getActivityBloc.eventSink.add(GetActivityAction.FetchActivity);
    eventBus.fire(onFavDeleted(true));
    /*setState(() {
      favoriteActivities.remove(activity.sId);
    });*/
  }

  void _navigateToLogin() {
    Navigator.of(context).pushNamed(LoginScreen.route).then(
      (value) {
        Navigator.of(context).pushReplacementNamed(
          MainScreen.route,
          arguments: MainScreenParameter(
            bottomNavigationBarIndex: 1,
          ),
        );
      },
    );
  }
}
