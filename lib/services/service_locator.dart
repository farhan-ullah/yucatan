import 'package:yucatan/screens/vendor/burger_menu/bloc/vendor_burger_menu_bloc.dart';
import 'package:yucatan/screens/favorites_screen/bloc/favorite_activities_for_user_bloc.dart';
import 'package:yucatan/screens/favorites_screen/bloc/favourite_bloc.dart';
import 'package:yucatan/screens/favorites_screen/bloc/user_bloc.dart';
import 'package:yucatan/screens/vendor/dashboard/bloc/vendor_dashboard_bloc.dart';
import 'package:yucatan/screens/vendor/dashboard/line_graph_bloc/line_graph_bloc.dart';
import 'package:yucatan/screens/vendor/order_overview/order_overview_bloc/transactions_for_date_range_bloc.dart';
import 'package:yucatan/screens/vendor/order_overview/order_overview_bloc/vendor_account_balance_bloc.dart';
import 'package:yucatan/screens/vendor/order_overview/order_overview_bloc/vendor_next_payout_date_bloc.dart';
import 'package:yucatan/screens/vendor/order_overview/order_overview_bloc/vendor_payouts_bloc.dart';
import 'package:yucatan/screens/vendor/demand_screen/vendor_demand_bloc/date_options_bloc.dart';
import 'package:yucatan/screens/vendor/demand_screen/vendor_demand_bloc/vendor_demand_bloc.dart';
import 'package:get_it/get_it.dart';

import 'connection/NetworkObserver.dart';

var getIt = GetIt.instance;

void serviceLocator() {
  getIt.registerSingleton<NetworkObserver>(NetworkObserver());
  getIt.registerLazySingleton(() => LineGraphBloc());
  getIt.registerLazySingleton<VendorBurgerMenuBloc>(
      () => VendorBurgerMenuBloc());
  getIt.registerLazySingleton(() => UserLoginModelBloc());
  getIt.registerLazySingleton(() => FavoriteActivitiesForUserBloc());
  getIt.registerLazySingleton(() => GetActivityBloc());
  getIt.registerLazySingleton(() => VendorDashboardBloc());
  getIt.registerLazySingleton(() => VendorPayoutsBloc());
  getIt.registerLazySingleton(() => VendorAccountBalanceBloc());
  getIt.registerLazySingleton(() => TransactionsForDateRangeBloc());
  getIt.registerLazySingleton(() => VendorNextPayoutBloc());
  getIt.registerLazySingleton(() => VendorDemandBloc());
  getIt.registerLazySingleton(() => DateOptionsBloc());
}
