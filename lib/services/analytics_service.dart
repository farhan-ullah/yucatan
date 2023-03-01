import 'package:yucatan/models/activity_category_data_model.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../screens/booking/components/booking_bar.dart';

class AnalyticsService {
  static initStore() {}
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static final facebookAppEvents = FacebookAppEvents();
  late Product productToReturn;
  static setUser(UserLoginModel user) async {
    if (kReleaseMode == false) return;

    analytics.logEvent(
      name: 'login',
      parameters: <String, dynamic>{
        'user_id': user.sId,
        'user_email': user.email,
        'time': DateTime.now().toIso8601String(),
      },
    );

    await analytics.setUserId();
    await facebookAppEvents.setUserID(user.sId!);
    await facebookAppEvents.setUserData(
      email: user.email,
      city: "",
      country: "",
      dateOfBirth: "",
      firstName: "",
      gender: "",
      lastName: "",
      phone: "",
      state: "",
      zip: "",
    );
  }

  static logViewContent(ActivityCategoryDataModel activityCategoryDataModel,
      ActivityModel activityModel) async {
    if (kReleaseMode == false) return;

    var itemId = activityCategoryDataModel == null
        ? activityModel != null
            ? activityModel.sId
            : ""
        : activityCategoryDataModel.id;
    analytics.logEvent(
      name: 'select_content',
      parameters: <String, dynamic>{
        'content_type': 'Activity',
        'item_id': itemId,
        'time': DateTime.now().toIso8601String(),
      },
    );

    facebookAppEvents.logViewContent(content: <String, dynamic>{
      "content_type": "Activity",
      'item_id': itemId,
      'time': DateTime.now().toIso8601String()
    }, id: itemId, currency: "", type: "");
  }

  static logAddtoCart(OrderProduct orderProduct, Product product) {
    if (kReleaseMode == false) return;

    analytics.logEvent(
      name: 'add_to_cart',
      parameters: <String, dynamic>{
        'item': orderProduct.id,
        'item_name': product.title,
        'value': product.price! * orderProduct.amount!,
        'time': DateTime.now().toIso8601String(),
      },
    );
    facebookAppEvents.logAddToCart(
      content: <String, dynamic>{
        'item_name': product.title,
        'time': DateTime.now().toIso8601String(),
      },
      id: orderProduct.id!,
      type: 'add_to_cart',
      currency: "EUR",
      price: product.price! * orderProduct.amount!,
    );
  }

  static logAddToWishlist(String activityId, String userId) {
    if (kReleaseMode == false) return;

    analytics.logEvent(
      name: 'add_to_wishlist',
      parameters: <String, dynamic>{
        'activity_id': activityId,
        'user_id': userId,
        'time': DateTime.now().toIso8601String(),
      },
    );
    // FacebookAppEvents().logAddToWishlist(id: id, type: type, currency: currency, price: price)
    facebookAppEvents.logEvent(
      name: 'add_to_wishlist',
      parameters: <String, dynamic>{
        'activity_id': activityId,
        'user_id': userId,
        'time': DateTime.now().toIso8601String(),
      },
    );
  }

  static logRegistration(String sId, String email) {
    if (kReleaseMode == false) return;

    facebookAppEvents.logCompletedRegistration(registrationMethod: 'email');
    analytics.logEvent(
      name: 'sign_up',
      parameters: <String, dynamic>{
        'user_id': sId,
        'user_email': email,
        'time': DateTime.now().toIso8601String(),
      },
    );
  }

  static logInitiatedCheckout(OrderModel orderModel) async {
    if (kReleaseMode == false) return;

    analytics.logEvent(
      name: 'begin_checkout',
      parameters: <String, dynamic>{
        'time': DateTime.now().toIso8601String(),
      },
    );

    var activityResponse =
        await ActivityService.getActivity(orderModel.activityId!);
    if (activityResponse == null || activityResponse.data == null) return;
    double totalPrice = 0.0;
    orderModel.products!.forEach((product) {
      var activityProduct = _findProduct(activityResponse.data!, product.id!);
      totalPrice += product.amount!* activityProduct.price!;
    });
    facebookAppEvents.logInitiatedCheckout(
      contentId: orderModel.activityId,
      contentType: 'begin_checkout',
      currency: "EUR",
      numItems: orderModel.products!.length,
      paymentInfoAvailable: true,
      totalPrice: totalPrice,
    );
  }

  // static logOpenBookingFunnel(String activityId) {
  //   if (kReleaseMode == false) return;

  //   FacebookAppEvents().logInitiatedCheckout(
  //     contentId: activityId,
  //   );
  // }

  static logout() async {
    if (kReleaseMode == false) return;

    await facebookAppEvents.clearUserData();
    await facebookAppEvents.clearUserID();
    await analytics.setUserId();
  }

  static logRequestPurchase(OrderModel orderModel, String paymentType) async {
    if (kReleaseMode == false) return;

    analytics.logEvent(
      name: 'add_payment_info',
      parameters: <String, dynamic>{
        'payment_type': paymentType,
        'time': DateTime.now().toIso8601String(),
      },
    );

    //Log firebase event
    analytics.logEvent(
      name: 'add_shipping_info',
      parameters: <String, dynamic>{
        'address_json': AddressModel.toJson(orderModel.address!),
        'time': DateTime.now().toIso8601String(),
      },
    );
  }

  static logPurchaseCompleted(BookingModel booking) {
    analytics.logEvent(
      name: 'purchase',
      parameters: <String, dynamic>{
        'booking_id': booking.id,
        'value': booking.totalPrice,
        'currency': booking.currency,
        'time': DateTime.now().toIso8601String(),
      },
    );

    facebookAppEvents.logPurchase(
      amount: booking.totalPrice!,
      currency: booking.currency!,
      parameters: <String, dynamic>{},
    );
  }

  static logAddReview(double value) {
    if (kReleaseMode == false) return;

    facebookAppEvents.logRated(valueToSum: value);
  }

  static logOpenNotification( message) {
    if (kReleaseMode == false) return;

    var parameters = <String, dynamic>{
      'message_id': message.messageId,
      'message_name': message.notification?.title,
      'message_time': message.sentTime?.toIso8601String(),
      'message_device_time': DateTime.now().toIso8601String(),
      'topic': message.from,
    };
    facebookAppEvents.logPushNotificationOpen(payload: parameters);

    analytics
        .logEvent(name: 'fcm_notification_open', parameters: parameters);
  }
}

Product _findProduct(ActivityModel activity, String productId) {
  // Product productToReturn;

  activity.bookingDetails!.productCategories!.forEach(
    (category) {
      category.products!.forEach(
        (product) {
          if (product.id == productId) {
            productToReturn = product;
          }
        },
      );

      category.productSubCategories!.forEach(
        (subCategory) {
          subCategory.products!.forEach(
            (product) {
              if (product.id == productId) {
                productToReturn = product;
              }
            },
          );
        },
      );
    },
  );

  return productToReturn;
}
