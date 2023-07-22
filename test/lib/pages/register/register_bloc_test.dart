import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_social_media/forms/bloc/base_form.dart';
import 'package:recipe_social_media/pages/register/register_bloc.dart';
import '../../../mocks/generic_mocks.dart';

void main() {
  late AuthenticationRepositoryMock authRepoMock;

  setUp(() {
    authRepoMock = AuthenticationRepositoryMock();
  });

  group("formSubmitted method tests", () {
    blocTest("form submission success",
      build: () {
        when(() => authRepoMock.register(any(), any(), any())).thenAnswer((invocation) => Future.value(null));
        return RegisterBloc(authRepo: authRepoMock);
      },
      act: (bloc) => bloc.add(const FormSubmitted()),
      expect: () => [
        const InputState(formStatus: FormzSubmissionStatus.inProgress, errorMessage: null),
        const InputState(formStatus: FormzSubmissionStatus.success, errorMessage: null)
      ]
    );

    blocTest("form submission failure",
      build: () {
        when(() => authRepoMock.register(any(), any(), any())).thenAnswer((invocation) => Future.value("form error"));
        return RegisterBloc(authRepo: authRepoMock);
      },
      act: (bloc) => bloc.add(const FormSubmitted()),
      expect: () => [
        const InputState(formStatus: FormzSubmissionStatus.inProgress, errorMessage: null),
        const InputState(formStatus: FormzSubmissionStatus.failure, errorMessage: "form error")
      ]
    );
  });
}