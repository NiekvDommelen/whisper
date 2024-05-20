import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whisper/screens/login.dart';
import 'package:whisper/setup.dart';
import 'widget_test.mocks.dart';
import 'package:whisper/api.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([api])

void main() {
  testWidgets('Displays error message on incorrect input', (WidgetTester tester) async {
    // Create a mock ApiService
    final mockApiService = Mockapi();

    // Define the response you want to mock
    when(mockApiService.loginUser('wrongUser', 'wrongPass')).thenAnswer((realInvocation) => Future(() => false));
        

    // Build our app and trigger a frame.
    setupAndRunApp(service: mockApiService);

    // Enter the username and password
    await tester.enterText(find.byKey(const Key('username')), 'wrongUser');
    await tester.enterText(find.byKey(const Key('password')), 'wrongPass');

    // Tap the continue button
    await tester.tap(find.text("Continue"));
    await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.

    // Verify that the error message is displayed

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Incorrect username or password'), findsOneWidget);
  });

  // testWidgets('login with valid info', (WidgetTester tester) async {
  //   // Create a mock ApiService
  //   final mockApiService = MockApiService();
  //
  //   // Define the response you want to mock
  //   when(mockApiService.loginUser('validusername', 'validpassword'))
  //       .thenAnswer((_) async => http.Response('{"error": "Invalid credentials"}', 401));
  //
  //   // Build our app and trigger a frame.
  //   setupAndRunApp(service: mockApiService);
  //   await tester.pumpAndSettle();
  //   // Enter the username and password
  //   await tester.enterText(find.byKey(const Key('username')), 'validusername');
  //   await tester.enterText(find.byKey(const Key('password')), 'validpassword');
  //   await tester.pumpAndSettle();
  //   // Tap the continue button
  //   await tester.tap(find.byKey(const Key('Continue')));
  //   await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.
  //
  //   // Verify that the error message is displayed
  //   expect(find.byType(HomePage), findsOneWidget);
  // });

  // testWidgets('signup with valid info', (WidgetTester tester) async {
  //     // Create a mock ApiService
  //     final mockApiService = Mockapi();
  //
  //     // Define the response you want to mock
  //     when(mockApiService.signupUser('validusername', 'validpassword', 'valid@email.com'))
  //         .thenAnswer((_) => Future(() => {"success": false}));
  //
  //
  //     // Build our app and trigger a frame.
  //     setupAndRunApp(service: mockApiService);
  //     await tester.pumpAndSettle();
  //     // Enter the username and password
  //     await tester.tap(find.text("sign-up"));
  //     await tester.pumpAndSettle();
  //     await tester.enterText(find.byKey(const Key('username')), 'validusername');
  //     await tester.enterText(find.byKey(const Key('password')), 'validpassword');
  //     await tester.enterText(find.byKey(const Key('email')), 'valid@email.com');
  //     await tester.pumpAndSettle();
  //     // Tap the continue button
  //     await tester.tap(find.byKey(const Key('Continue')));
  //     await tester.pumpAndSettle(); // Rebuild the widget after the state has changed.
  //
  //     // Verify that the error message is displayed
  //     expect(find.byType(HomePage), findsOneWidget);
  //   });
}