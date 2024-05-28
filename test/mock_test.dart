import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whisper/screens/homepage.dart';
import 'package:whisper/screens/login.dart';
import 'package:whisper/screens/signup.dart';
import 'package:whisper/setup.dart';
import 'mock_test.mocks.dart';
import 'package:whisper/api.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([api, Ws])

void main() {
  group("login", () {
    testWidgets('login with invalid info', (WidgetTester tester) async {
      // Create a mock ApiService
      final mockApiService = Mockapi();

      // Define the response you want to mock
      when(mockApiService.loginUser('wrongUser', 'wrongPass')).thenAnswer((realInvocation) => Future(() => false));


      // Build our app and trigger a frame.
      setupAndRunApp(service: mockApiService);

      // Enter the username and password
      await tester.enterText(find.byKey(const Key('username')), 'wrongUser');
      await tester.enterText(find.byKey(const Key('password')), 'wrongPass');

      await tester.pumpAndSettle();
      // Tap the continue button
      await tester.tap(find.text("Continue"));
      await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.

      // Verify that the error message is displayed
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text("Incorrect username or password"), findsAtLeast(1));
    });

    testWidgets('login with invalid info', (WidgetTester tester) async {
      // Create a mock ApiService
      final mockApiService = Mockapi();

      // Define the response you want to mock
      when(mockApiService.loginUser('validusername', 'validpassword')).thenAnswer((realInvocation) => Future(() => true));
      when(mockApiService.getContacts()).thenAnswer((realInvocation) => Future(() => {}));
      when(mockApiService.getUserData()).thenAnswer((realInvocation) => Future(() => {
        "id": 0,
        "username": "testuser",
        "email": "test@email.com",
        "password": "validpassword in hash form"
      }
      ));


      // Build our app and trigger a frame.
      setupAndRunApp(service: mockApiService);

      // Enter the username and password
      await tester.enterText(find.byKey(const Key('username')), 'validusername');
      await tester.enterText(find.byKey(const Key('password')), 'validpassword');

      await tester.pumpAndSettle();
      // Tap the continue button
      await tester.tap(find.text("Continue"));
      await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.

      // Verify that the error message is displayed
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('login with no info', (WidgetTester tester) async {
      // Create a mock ApiService
      final mockApiService = Mockapi();

      // Define the response you want to mock
      when(mockApiService.loginUser(' ', ' ')).thenAnswer((realInvocation) => Future(() => false));


      // Build our app and trigger a frame.
      setupAndRunApp(service: mockApiService);

      // Enter the username and password
      await tester.enterText(find.byKey(const Key('username')), ' ');
      await tester.enterText(find.byKey(const Key('password')), ' ');

      await tester.pumpAndSettle();
      // Tap the continue button
      await tester.tap(find.text("Continue"));
      await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.

      // Verify that the error message is displayed
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text("Incorrect username or password"), findsAtLeast(1));
    });
  });

  group("signup", () {
    testWidgets('signup with valid info', (WidgetTester tester) async {
      // Create a mock ApiService
      final mockApiService = Mockapi();

      // Define the response you want to mock
      when(mockApiService.signupUser('validusername', 'validpassword', 'valid@email.com'))
          .thenAnswer((_) => Future(() => {"success": true}));


      // Build our app and trigger a frame.
      setupAndRunApp(service: mockApiService);
      await tester.pumpAndSettle();
      // Enter the username and password
      await tester.tap(find.text("sign-up"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('username')), 'validusername');
      await tester.enterText(find.byKey(const Key('password')), 'validpassword');
      await tester.enterText(find.byKey(const Key('email')), 'valid@email.com');
      await tester.pumpAndSettle();
      // Tap the continue button
      await tester.tap(find.text("Continue"));
      await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.

      // Verify that the error message is displayed
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('signup with invalid email', (WidgetTester tester) async {
      // Create a mock ApiService
      final mockApiService = Mockapi();

      // Define the response you want to mock
      when(mockApiService.signupUser('validusername', 'validpassword', 'invalidemail'))
          .thenAnswer((_) => Future(() => {"success": true}));


      // Build our app and trigger a frame.
      setupAndRunApp(service: mockApiService);
      await tester.pumpAndSettle();
      // Enter the username and password
      await tester.tap(find.text("sign-up"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('username')), 'validusername');
      await tester.enterText(find.byKey(const Key('password')), 'validpassword');
      await tester.enterText(find.byKey(const Key('email')), 'invalidemail');
      await tester.pumpAndSettle();
      // Tap the continue button
      await tester.tap(find.text("Continue"));
      await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.

      // Verify that the error message is displayed
      expect(find.byType(SignupPage), findsOneWidget);
      expect(find.text("Email is invalid"), findsOne);
    });
  });


}