import 'dart:developer';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

class CalendarClient {
  CalendarApi? _calendarApi;
  final _googleSignIn =
      GoogleSignIn(scopes: ['https://www.googleapis.com/auth/calendar']);
  GoogleSignInAccount? _currentUser;

  Future<bool> initAuth() async {
    final isSignedIn = _googleSignIn.isSignedIn();
    if (await isSignedIn) {
      log('User already logged in');
      _currentUser = await _googleSignIn.signInSilently();
      var httpClient = (await _googleSignIn.authenticatedClient())!;
      _calendarApi = CalendarApi(httpClient);
    }
    return isSignedIn;
  }

  Future<bool> login() async {
    log('Logging in user');
    _currentUser = await _googleSignIn.signIn();
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    _calendarApi = CalendarApi(httpClient);
    return (_currentUser != null);
  }

  logout() async {
    log('Logging out user');
    await _googleSignIn.disconnect();
  }

  getUserPhoto() {
    return _currentUser?.photoUrl;
  }

  getUserName() {
    return _currentUser?.displayName;
  }

  getUserEmail() {
    return _currentUser?.email;
  }

  addEvent(title, startTime, endTime, pomosDone, totalPomos) {
    String calendarId = 'primary';

    EventDateTime start = EventDateTime(
        dateTime: DateTime.parse(startTime), timeZone: 'Europe/London');

    EventDateTime end = EventDateTime(
        dateTime: DateTime.parse(endTime), timeZone: 'Europe/London');

    EventReminders reminders = EventReminders(
        overrides: <EventReminder>[EventReminder(method: 'popup', minutes: 2)],
        useDefault: false);

    Event event = Event(
        summary: title,
        start: start,
        end: end,
        description: 'Created by PomoTask ;)\nPomos: $pomosDone/$totalPomos',
        colorId: '11',
        eventType: 'focusTime',
        reminders: reminders);

    try {
      _calendarApi?.events.insert(event, calendarId).then((value) {
        if (value.status == 'confirmed') {
          log('Event added in google calendar');
          return value;
        } else {
          log('Unable to add event in google calendar');
        }
      });
    } catch (e) {
      log('Error creating event $e');
    }
  }
}
