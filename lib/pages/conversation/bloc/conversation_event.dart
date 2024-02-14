part of 'conversation_bloc.dart';

@immutable
sealed class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

final class InitState extends ConversationEvent {
  const InitState(this.conversation);

  final Conversation conversation;

  @override
  List<Object> get props => [conversation];
}

final class GoToInteractionPageAndExpectResult extends ConversationEvent {
  const GoToInteractionPageAndExpectResult(this.context, this.arguments);

  final BuildContext context;
  final RecipeInteractionPageArguments arguments;

  @override
  List<Object> get props => [context, arguments];
}

final class AttachImages extends ConversationEvent {
  const AttachImages(this.imageFiles);

  final List<XFile> imageFiles;

  @override
  List<Object> get props => [imageFiles];
}

final class AttachRecipes extends ConversationEvent {
  const AttachRecipes();
}

final class CancelRecipeAttachment extends ConversationEvent {
  const CancelRecipeAttachment();
}

final class DetachImage extends ConversationEvent {
  const DetachImage(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

final class SetCheckboxValue extends ConversationEvent {
  const SetCheckboxValue(this.index, this.value);

  final int index;
  final bool value;

  @override
  List<Object> get props => [index, value];
}

final class ScrollToMessage extends ConversationEvent {
  const ScrollToMessage(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class SendMessage extends ConversationEvent {
  const SendMessage();
}

final class ResetPopupDialog extends ConversationEvent {
  const ResetPopupDialog();
}

final class RemoveMessage extends ConversationEvent {
  const RemoveMessage(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class ReplyToMessage extends ConversationEvent {
  const ReplyToMessage(this.message);

  final Message? message;

  @override
  List<Object?> get props => [message];
}