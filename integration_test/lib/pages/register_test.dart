import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_social_media/pages/register/register_bloc.dart';
import 'package:recipe_social_media/pages/register/register_page.dart';
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
          child: const RegisterPage(),
        )
    );
  }
  
  group("register integration tests", () {
    testWidgets("valid registration", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.register(any(), any(), any())).thenAnswer((invocation) => Future.value(null));
      await widgetTester.pumpWidget(createSystemUnderTest());

      final userNameTextField = find.descendant(
        of: find.byType(UserNameInput),
        matching: find.byType(TextField)
      );
      final emailTextField = find.descendant(
          of: find.byType(EmailInput),
          matching: find.byType(TextField)
      );
      final passwordTextField = find.descendant(
          of: find.byType(PasswordInput),
          matching: find.byType(TextField)
      );
      final confirmedPasswordTextField = find.descendant(
          of: find.byType(ConfirmPasswordInput),
          matching: find.byType(TextField)
      );
      
      // Act
      await widgetTester.enterText(userNameTextField, "username1");
      await widgetTester.enterText(emailTextField, "email@mail.com");
      await widgetTester.enterText(passwordTextField, "Password123!");
      await widgetTester.enterText(confirmedPasswordTextField, "Password123!");
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(RegisterButton));
      await widgetTester.pumpAndSettle();

      // Assert
      final Text formErrorLabel = widgetTester.widget(find.descendant(
        of: find.byType(FormErrorLabel),
        matching: find.byType(Text)
      ));

      expect(formErrorLabel.data, "");
      expect(find.text("server error"), findsNothing);
      expect(find.text("Needs 3+ length & only letters/numbers"), findsNothing);
      expect(find.text("Invalid email"), findsNothing);
      expect(find.text("Needs 8+ length & 1 uppercase, 1 lowercase, 1 digit & 1 special"), findsNothing);
      expect(find.text("Passwords must match"), findsNothing);
      verify(() => navigRepoMock.goTo(any(), "/home", RouteType.onlyThis)).called(1);
    });

    testWidgets("invalid registration form", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.register(any(), any(), any())).thenAnswer((invocation) => Future.value("server error"));
      await widgetTester.pumpWidget(createSystemUnderTest());

      final userNameTextField = find.descendant(
          of: find.byType(UserNameInput),
          matching: find.byType(TextField)
      );
      final emailTextField = find.descendant(
          of: find.byType(EmailInput),
          matching: find.byType(TextField)
      );
      final passwordTextField = find.descendant(
          of: find.byType(PasswordInput),
          matching: find.byType(TextField)
      );
      final confirmedPasswordTextField = find.descendant(
          of: find.byType(ConfirmPasswordInput),
          matching: find.byType(TextField)
      );

      // Act
      await widgetTester.enterText(userNameTextField, "username1");
      await widgetTester.enterText(emailTextField, "email@.com");
      await widgetTester.enterText(passwordTextField, "Password123");
      await widgetTester.enterText(confirmedPasswordTextField, "Password123!");
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(RegisterButton));
      await widgetTester.pumpAndSettle();

      // Assert
      final Text formErrorLabel = widgetTester.widget(find.descendant(
          of: find.byType(FormErrorLabel),
          matching: find.byType(Text)
      ));

      expect(formErrorLabel.data, "");
      expect(find.text("server error"), findsNothing);
      expect(find.text("Needs 3+ length & only letters/numbers"), findsNothing);
      expect(find.text("Invalid email"), findsOneWidget);
      expect(find.text("Needs 8+ length & 1 uppercase, 1 lowercase, 1 digit & 1 special"), findsOneWidget);
      expect(find.text("Passwords must match"), findsOneWidget);
      verifyNever(() => navigRepoMock.goTo(any(), "/home", RouteType.onlyThis));
    });

    testWidgets("invalid registration", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.register(any(), any(), any())).thenAnswer((invocation) => Future.value("server error"));
      await widgetTester.pumpWidget(createSystemUnderTest());

      final userNameTextField = find.descendant(
          of: find.byType(UserNameInput),
          matching: find.byType(TextField)
      );
      final emailTextField = find.descendant(
          of: find.byType(EmailInput),
          matching: find.byType(TextField)
      );
      final passwordTextField = find.descendant(
          of: find.byType(PasswordInput),
          matching: find.byType(TextField)
      );
      final confirmedPasswordTextField = find.descendant(
          of: find.byType(ConfirmPasswordInput),
          matching: find.byType(TextField)
      );

      // Act
      await widgetTester.enterText(userNameTextField, "username1");
      await widgetTester.enterText(emailTextField, "email@mail.com");
      await widgetTester.enterText(passwordTextField, "Password123!");
      await widgetTester.enterText(confirmedPasswordTextField, "Password123!");
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(RegisterButton));
      await widgetTester.pumpAndSettle();

      // Assert
      expect(find.text("server error"), findsOneWidget);
      expect(find.text("Needs 3+ length & only letters/numbers"), findsNothing);
      expect(find.text("Invalid email"), findsNothing);
      expect(find.text("Needs 8+ length & 1 uppercase, 1 lowercase, 1 digit & 1 special"), findsNothing);
      expect(find.text("Passwords must match"), findsNothing);
      verifyNever(() => navigRepoMock.goTo(any(), "/home", RouteType.onlyThis));
    });
  });
}