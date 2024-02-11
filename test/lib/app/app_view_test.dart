import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_social_media/app/app.dart';
import 'package:recipe_social_media/pages/home/home_page.dart';
import 'package:recipe_social_media/pages/login/login_page.dart';
import 'package:recipe_social_media/pages/splash/splash_page.dart';
import '../../../test_utilities/mocks/generic_mocks.dart';

void main() {
  late AuthenticationRepositoryMock authRepoMock;
  late NavigationRepositoryMock navigRepoMock;
  late RecipeRepositoryMock recipeRepoMock;
  late ImageRepositoryMock imageRepoMock;
  late ConversationRepositoryMock conversationRepoMock;
  late MessageRepositoryMock messageRepoMock;
  late ImageTransformationBuilderMock imageTransformationBuilderMock;
  late ImageBuilderMock imageBuilderMock;
  late NetworkManagerMock networkManagerMock;
  late LocalStoreMock localStoreMock;

  setUp(() {
    recipeRepoMock = RecipeRepositoryMock();
    imageRepoMock = ImageRepositoryMock();
    authRepoMock = AuthenticationRepositoryMock();
    navigRepoMock = NavigationRepositoryMock();
    conversationRepoMock = ConversationRepositoryMock();
    messageRepoMock = MessageRepositoryMock();
    imageBuilderMock = ImageBuilderMock();
    imageTransformationBuilderMock = ImageTransformationBuilderMock();
    networkManagerMock = NetworkManagerMock();
    localStoreMock = LocalStoreMock();

    when(() => localStoreMock.getKey("currentTheme")).thenAnswer((invocation) => Future.value("light"));
    when(() => imageBuilderMock.getAssetImage(any())).thenReturn(const AssetImage("assets/images/light_auth_bg.png"));
  });

  Widget createWidgetUnderTest() {
    return App(
      authRepo: authRepoMock,
      navigationRepo: navigRepoMock,
      imageRepo: imageRepoMock,
      recipeRepo: recipeRepoMock,
      imageBuilder: imageBuilderMock,
      conversationRepo: conversationRepoMock,
      messageRepo: messageRepoMock,
      imageTransformationBuilder: imageTransformationBuilderMock,
      networkManager: networkManagerMock,
      localStore: localStoreMock,
    );
  }

  group("app and app view tests", () {
    testWidgets("app status is authenticated", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.isAuthenticated()).thenAnswer((invocation) => Future.value(true));
      await widgetTester.pumpWidget(createWidgetUnderTest());
      await widgetTester.pumpAndSettle();

      // Assert
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets("app status is unauthenticated", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.isAuthenticated()).thenAnswer((invocation) => Future.value(false));
      await widgetTester.pumpWidget(createWidgetUnderTest());
      await widgetTester.pumpAndSettle();

      // Assert
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets("app status is loading", (widgetTester) async {
      // Arrange
      when(() => authRepoMock.isAuthenticated()).thenAnswer((invocation) => Future.delayed(const Duration(seconds: 5), () => Future.value(false)));
      await widgetTester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(SplashPage), findsOneWidget);
      await widgetTester.pumpAndSettle();
    });
  });
}