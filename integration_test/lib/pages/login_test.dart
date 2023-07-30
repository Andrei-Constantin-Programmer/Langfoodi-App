import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_social_media/pages/login/login_bloc.dart';
import 'package:recipe_social_media/pages/login/login_page.dart';
import 'package:recipe_social_media/repositories/authentication/auth_repo.dart';
import 'package:recipe_social_media/repositories/navigation/navigation_repo.dart';
import '../../../test_utilities/mocks/generic_mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AuthenticationRepositoryMock authRepoMock;
  late NavigationRepositoryMock navigRepoMock;

  setUp(() {
    authRepoMock = AuthenticationRepositoryMock();
    navigRepoMock = NavigationRepositoryMock();
    registerFallbackValue(BuildContextMock());
  });

  Widget createSystemUnderTest() {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(create: (_) => authRepoMock),
          RepositoryProvider<NavigationRepository>(create: (_) => navigRepoMock),
        ],
        child: const LoginPage(),
      )
    );
  }

  group("login tests", () {
    testWidgets("Valid login submission", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.loginWithUserNameOrEmail(any(), any())).thenAnswer((invocation) => Future.value(null));
      await widgetTester.pumpWidget(createSystemUnderTest());

      final userNameOrEmailInput = find.byType(UserNameEmailInput);
      final userNameOrEmailTextField = find.descendant(
          of: userNameOrEmailInput,
          matching: find.byType(TextField)
      );

      final passwordInput = find.byType(PasswordInput);
      final passwordTextField = find.descendant(
          of: passwordInput,
          matching: find.byType(TextField)
      );

      // Act
      await widgetTester.enterText(userNameOrEmailTextField, "username1");
      await widgetTester.enterText(passwordTextField, "Password123!");
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(LoginButton));
      await widgetTester.pumpAndSettle();

      // Assert
      expect(find.text("server error"), findsNothing);
      verify(() => navigRepoMock.goTo(any(), "/home", RouteType.onlyThis)).called(1);
    });

    testWidgets("Invalid login submission", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.loginWithUserNameOrEmail(any(), any())).thenAnswer((invocation) => Future.value("server error"));
      await widgetTester.pumpWidget(createSystemUnderTest());

      final userNameOrEmailInput = find.byType(UserNameEmailInput);
      final userNameOrEmailTextField = find.descendant(
          of: userNameOrEmailInput,
          matching: find.byType(TextField)
      );

      final passwordInput = find.byType(PasswordInput);
      final passwordTextField = find.descendant(
          of: passwordInput,
          matching: find.byType(TextField)
      );

      // Act
      await widgetTester.enterText(userNameOrEmailTextField, "username1");
      await widgetTester.enterText(passwordTextField, "Password123!");
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(LoginButton));
      await widgetTester.pumpAndSettle();

      // Assert
      expect(find.text("server error"), findsOneWidget);
    });
  });
}