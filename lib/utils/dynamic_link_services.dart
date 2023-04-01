import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkServices{

  static Future<String> createDynamicLink({required int id}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://safaqatek.page.link',
      link: Uri.parse('https://safaqatek.page.link/$id'),
      androidParameters: const AndroidParameters(
        packageName: 'com.company.safaqatek',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'io.safaqatek.com',
        minimumVersion: '0',
      ),
    );

    Uri url;
    final ShortDynamicLink shortLink =
    await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    url = shortLink.shortUrl;
    return url.toString();
  }

}