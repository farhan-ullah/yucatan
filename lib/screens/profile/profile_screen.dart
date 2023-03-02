import 'package:yucatan/screens/profile/components/profile_wrapper.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserLoginModel>? user;

  @override
  void initState() {
    user = UserProvider.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profileScreen_title),
        backgroundColor: CustomTheme.primaryColorDark,
      ),
      backgroundColor: CustomTheme.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<UserLoginModel>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildProfileView(snapshot.data!);
            } else if (snapshot.hasError) {
              return _getError(snapshot.error!);
            }
            return _getProgressIndicator();
          },
        ),
      ),
    );
  }

  //---------------------------------------------

  Widget _buildProfileView(UserLoginModel model) {
    return ProfileWrapper(model: model);
  }

  Widget _getProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _getError(Object error) {
    return Text('$error');
  }
}
