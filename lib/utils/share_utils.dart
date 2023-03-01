import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils{

  ///share content from your the app via the platform's share dialog
  static void shareText(String text){
    Share.share("Hi, sieh Dir diese Aktivität in Appventure an.\n$text");
  }
  ///create a Dynamic Link programmatically by setting the following parameters
  static Future<void>  createFirebaseDynamicLink(String activityId) async {

    String link = "https://myappventure.de/activity_id=$activityId"; // it can be any url, it does not have to be an existing one
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://myappventure.page.link',
      link: Uri.parse(link),
      androidParameters: const AndroidParameters(
        packageName: 'de.myappventure.appventure',
        minimumVersion: 246,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'de.myappventure.appventure',
        minimumVersion: '0.4.3',
        appStoreId: '1538207336',
      ),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        campaign: 'share-with-friends',
        medium: 'social',
        source: 'mobile-app',
      ),
      socialMetaTagParameters:  const SocialMetaTagParameters(
        title: 'Appventure',
        description: 'Hi, sieh Dir diese Aktivität in Appventure an!',
      ),
    );

    //final Uri dynamicUrl = await parameters.buildUrl();

    final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    // parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;

    shareText(shortUrl.toString());
  }

}