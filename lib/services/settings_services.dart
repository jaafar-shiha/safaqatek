import 'dart:convert';
import 'dart:io';

import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/http_enum.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Notifications/add_notification.dart';
import 'package:safaqtek/models/Notifications/notifications_data.dart';
import 'package:safaqtek/models/Setttings/settings_data.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';
import 'package:safaqtek/models/base_error_response.dart';
import 'package:safaqtek/models/base_success_response.dart';
import 'package:safaqtek/services/base_api.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SettingsServices extends BaseAPI{

  Future<ResponseState<SettingsData>> getSettings() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/settings',
      httpEnum: HttpEnum.get,
      parseJson: (json) => SettingsData.fromMap(json),
    );
  }

  Future<ResponseState<BaseSuccessResponse>> updateUserProfile({required UpdateUserProfile updateUserProfile}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/profile/update',
      httpEnum: HttpEnum.post,
      data: updateUserProfile.toMap(),
      headers: {
        'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      parseJson: (json) => BaseSuccessResponse.fromMap(json),
    );
  }

  Future<ResponseState<BaseSuccessResponse>> updateUserImage({required File imageFile}) async {
    var stream =  http.ByteStream(Stream.castFrom(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('https://safaqatek.com/api/v1/${locator<MainApp>().language!.languageCode}/user/profile/update',);
    var request =  http.MultipartRequest("POST", uri);
    var multipartFile =  http.MultipartFile('avatar', stream, length,
        filename: 'vv',contentType: MediaType('image', 'png'));
    request.headers.addAll({
      'Authorization': 'Bearer ${locator<MainApp>().token}',
    });
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200)
    {
      String successResponseString = await response.stream.transform(utf8.decoder).first;
      return ResponseState.success(BaseSuccessResponse.fromMap(jsonDecode(successResponseString)));

    }
    else{
      String errorResponseString = await response.stream.transform(utf8.decoder).first;
      return ResponseState.error(BaseErrorResponse.fromMap(jsonDecode(errorResponseString)));

    }

  }

  Future<ResponseState<AddNotification>> addNotification({required AddNotification addNotification}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/notification',
      httpEnum: HttpEnum.post,
      data: addNotification.toMap(),
      headers: {
        'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      parseJson: (json) => AddNotification.fromMap(json),
    );
  }


  Future<ResponseState<NotificationData>> getNotifications() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/notification',
      httpEnum: HttpEnum.get,
      headers: {
        'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      parseJson: (json) => NotificationData.fromMap(json),
    );
  }
}