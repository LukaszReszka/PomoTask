import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'constants.dart';

class CalendarClient {
  CalendarApi? _calendarApi;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

    // CalendarClient() {
    //   var scopes = ["https://www.googleapis.com/auth/calendar"];
    //   ClientId clientId = ClientId();
    //   clientViaUserConsent(clientId, scopes, _prompt).then((AuthClient client) {
    //     _calendarApi = CalendarApi(client);
    //   });
    // }


  Future<bool> initAuth() async {
    final storedRefreshToken = await _secureStorage.read(key: 'refreshToken');
    final TokenResponse? result;

    if (storedRefreshToken == null) {
      return false;
    }

    try {
      // Obtaining token response from refresh token
      result = await _appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          issuer: 'https://accounts.google.com',
          refreshToken: storedRefreshToken,
        ),
      );

      final bool setResult = await _handleAuthResult(result);
      return setResult;
    } catch (e, s) {
      print('error on Refresh Token: $e - stack: $s');
      // logOut() possibly
      return false;
    }
  }

  Future<bool> login() async {
    final AuthorizationTokenRequest authorizationTokenRequest;

    try {
      authorizationTokenRequest = AuthorizationTokenRequest(
        clientId,
        redirectUrl,
        issuer: 'https://accounts.google.com',
        scopes: ['calendar'],
      );

      // Requesting the auth token and waiting for the response
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        authorizationTokenRequest,
      );

      // Taking the obtained result and processing it
      return await _handleAuthResult(result);
    } on PlatformException {
      print("User has cancelled or no internet!");
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    await _secureStorage.delete(key: 'refreshToken');
    return true;
  }

  Future<bool> _handleAuthResult(result) async {
    final bool isValidResult =
        result != null && result.accessToken != null && result.idToken != null;
    if (isValidResult) {
      // Storing refresh token to renew login on app restart
      if (result.refreshToken != null) {
        await _secureStorage.write(
          key: 'refreshToken',
          value: result.refreshToken,
        );
      }

      final String googleAccessToken = result.accessToken;

      // Send request to backend with access token
      // final url = Uri.https(
      //   'api.your-server.com',
      //   '/v1/social-authentication',
      //   {
      //     'access_token': googleAccessToken,
      //   },
      // );
      // final response = await http.get(url);
      // final backendToken = response.token

      // Let's assume it has been successful and a valid token has been returned
    //   const String backendToken = 'TOKEN';
    //   if (backendToken != null) {
    //     await _secureStorage.write(
    //       key: BACKEND_TOKEN_KEY,
    //       value: backendToken,
    //     );
    //   }
    //   return true;
    // } else {
    //   return false;
    }
    return true; //TODO do usunięcia
  }

  // insert(title, startTime, endTime) {
  //   var _clientID = ClientId("YOUR_CLIENT_ID", "");
  //   clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
  //     var calendar = CalendarApi(client);
  //     calendar.calendarList.list().then((value) => print("VAL________$value"));
  //
  //     String calendarId = "primary";
  //     Event event = Event(); // Create object of event
  //
  //     event.summary = title;
  //
  //     EventDateTime start = new EventDateTime();
  //     start.dateTime = startTime;
  //     start.timeZone = "GMT+05:00";
  //     event.start = start;
  //
  //     EventDateTime end = new EventDateTime();
  //     end.timeZone = "GMT+05:00";
  //     end.dateTime = endTime;
  //     event.end = end;
  //     try {
  //       calendar.events.insert(event, calendarId).then((value) {
  //         print("ADDEDDD_________________${value.status}");
  //         if (value.status == "confirmed") {
  //           log('Event added in google calendar');
  //         } else {
  //           log("Unable to add event in google calendar");
  //         }
  //       });
  //     } catch (e) {
  //       log('Error creating event $e');
  //     }
  //   });
  // }
}