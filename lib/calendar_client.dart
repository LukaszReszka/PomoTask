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
      _currentUser = await _googleSignIn.signInSilently();
      //TODO inicjalizacja calendaApi
    }
    return isSignedIn;
  }

  Future<bool> login() async {
    _currentUser = await _googleSignIn.signIn();
    //TODO inicjalizacja calendaApi
    return (_currentUser != null);
  }

  logout() async {
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
