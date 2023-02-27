import 'package:appventure/components/custom_app_bar.dart';
import 'package:appventure/screens/vendor/order_overview/components/order_overview_screen_account_view.dart';
import 'package:appventure/screens/vendor/order_overview/components/order_overview_screen_parameter.dart';
import 'package:appventure/services/response/vendor_dashboard_response.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderOverviewScreen extends StatefulWidget {
  static const String route = '/orderoverview';
  @override
  _OrderOverviewState createState() => _OrderOverviewState();
}

class _OrderOverviewState extends State<OrderOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final OrderOverviewScreenParameter arguments =
        ModalRoute.of(context).settings.arguments;
    final VendorDashboardResponse vendorDashboardResponse =
        arguments.vendorDashboardResponse;

    return Scaffold(
      backgroundColor: CustomTheme.backgroundColorVendor,
      body: OrderOverviewScreenAccountView(
        vendorDashboardResponse: vendorDashboardResponse,
      ),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).vendor_orderOverview_title,
        appBar: AppBar(),
        centerTitle: true,
      ),
    );
  }
}
