import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recipe_social_media/forms/bloc/base_form.dart';
import 'package:recipe_social_media/forms/models/form_models.dart';
import 'package:recipe_social_media/repositories/authentication/auth_repo.dart';
import 'package:recipe_social_media/repositories/image/image_repo.dart';
import 'package:recipe_social_media/utilities/utilities.dart';

export 'profile_settings_form_bloc.dart';
part 'profile_settings_form_event.dart';

class ProfileSettingsFormBloc extends FormBloc {
  ProfileSettingsFormBloc(this._authRepo, this._imageRepo, this._networkManager): super() {
    on<UpdateUsername>(_updateUsername);
    on<UpdateEmail>(_updateEmail);
    on<UpdatePassword>(_updatePassword);
    on<UpdateProfileImage>(_updateProfileImage);
    on<ResetForm>(_resetForm);
    on<ResetErrorMessage>(_resetErrorMessage);
  }

  final AuthenticationRepository _authRepo;
  final ImageRepository _imageRepo;
  final NetworkManager _networkManager;

  void _resetErrorMessage(ResetErrorMessage event, Emitter<InputState> emit) {
    emit(state.copyWith(
      errorMessage: ""
    ));
  }

  void _resetForm(ResetForm event, Emitter<InputState> emit) {
    emit(state.copyWith(
      errorMessage: null,
      email: const Email.pure(),
      userName: const Username.pure(),
      password: const Password.pure(),
      confirmedPassword: const ConfirmedPassword.pure(),
      emailValid: false,
      userNameValid: false,
      passwordValid: false,
      confirmedPasswordValid: false,
      formStatus: FormzSubmissionStatus.initial,
    ));
  }

  void _updateProfileImage(UpdateProfileImage event, Emitter<InputState> emit) async {
    bool hasNetwork = await _networkManager.isNetworkConnected();
    if (!hasNetwork) {
      return emit(state.copyWith(
        formStatus: FormzSubmissionStatus.failure,
        errorMessage: "Network issue encountered, please check your internet connection"
      ));
    }

    emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));
    Signature? uploadSignature = await _imageRepo.getSignature();
    if (uploadSignature == null) {
      return emit(state.copyWith(
        formStatus: FormzSubmissionStatus.failure,
        errorMessage: "Issue uploading image, please check and try again"
      ));
    }

    HostedImage? profileImage = await _imageRepo.uploadImage(
      event.imagePath,
      SignedUploadContract(uploadSignature.signature, uploadSignature.timeStamp)
    );

    if (profileImage == null) {
      return emit(state.copyWith(
        formStatus: FormzSubmissionStatus.failure,
        errorMessage: "Issue uploading image, please check and try again"
      ));
    }

    _updateUser(
      currentImageId: event.currentImageId,
      profileImageId: profileImage.publicId
    );
  }

  void _updatePassword(UpdatePassword event, Emitter<InputState> emit) {
    if (!state.passwordValid || !state.confirmedPasswordValid) return;
    _updateUser(password: state.password.value);
  }

  void _updateEmail(UpdateEmail event, Emitter<InputState> emit) {
    if (!state.emailValid) return;
    _updateUser(email: state.email.value);
  }

  void _updateUsername(UpdateUsername event, Emitter<InputState> emit) async {
    if (!state.userNameValid) return;
    _updateUser(username: state.userName.value);
  }

  void _updateUser({String? currentImageId, String? profileImageId, String? username, String? email, String? password}) async {
    String errorMessage = "";
    bool hasNetwork = await _networkManager.isNetworkConnected();

    if (!hasNetwork) {
      errorMessage = "Network issue encountered, please check your internet connection";
    } else {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));
      final userId = (await _authRepo.currentUser).id;
      errorMessage = await _authRepo.updateUser(
        id: userId,
        profileImageId: profileImageId,
        username: username,
        email: email,
        password: password
      );
    }

    if (profileImageId != null) {
      if (errorMessage.isEmpty) {
        if (currentImageId != null) {
          await _imageRepo.removeImage(currentImageId);
        }
      } else {
        await _imageRepo.removeImage(profileImageId);
      }
    }

    emit(state.copyWith(
      errorMessage: errorMessage,
      formStatus: errorMessage.isEmpty
        ? FormzSubmissionStatus.success
        : FormzSubmissionStatus.failure,
    ));
  }
}