import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/utils/widget_dimensions.dart';

class NoFavouriteScreen extends StatefulWidget {
  final VoidCallback? callback;

  NoFavouriteScreen({this.callback});

  @override
  _NoFavouriteScreenState createState() {
    return _NoFavouriteScreenState();
  }
}

class _NoFavouriteScreenState extends State<NoFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: Scaffold.of(context).appBarMaxHeight),
          Expanded(flex: 3, child: Container()),
          Text(
            AppLocalizations.of(context)!.commonWords_mistake,
            style: TextStyle(
              color: CustomTheme.primaryColorDark,
              fontSize: Dimensions.getScaledSize(20.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Dimensions.getScaledSize(20.0)),
          Text(
            AppLocalizations.of(context)!.noFavoritesScreen_noFavorites,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(16.0),
                letterSpacing: CustomTheme.letterSpacing,
                color: CustomTheme.primaryColorDark),
          ),
          SizedBox(height: Dimensions.getScaledSize(30.0)),
          SizedBox(
            height: Dimensions.getHeight(percentage: 35.0),
            child: Image.asset(
              "lib/assets/images/favorites_empty.png",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(flex: 2, child: Container()),
          Container(
            width: Dimensions.getWidth(percentage: 50),
            height: Dimensions.getScaledSize(45.0),
            child: OutlinedButton(
              onPressed: () {
                widget.callback!();
              },
              child: Text(
                AppLocalizations.of(context)!.noFavoritesScreen_goToSearch,
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(20.0),
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(BorderSide(
                    color: CustomTheme.primaryColorDark,
                  )),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor:
                      MaterialStateProperty.all(CustomTheme.primaryColorDark),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.getScaledSize(7)),
                  ))),
            ),
          ),
          Expanded(flex: 5, child: Container()),
        ],
      ),
    );
  }

/*  void _navigateToSearch() {
    Navigator.of(context).pushNamed(
      SearchScreen.route,
    );
  }*/
}
