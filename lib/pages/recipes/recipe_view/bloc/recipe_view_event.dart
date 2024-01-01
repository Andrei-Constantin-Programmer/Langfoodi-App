part of 'recipe_view_bloc.dart';

@immutable
sealed class RecipeViewEvent extends Equatable {
  const RecipeViewEvent();

  @override
  List<Object> get props => [];
}

final class ChangeRecipesToDisplay extends RecipeViewEvent {
  const ChangeRecipesToDisplay();
}

final class GoToInteractionPageAndExpectResult extends RecipeViewEvent {
  const GoToInteractionPageAndExpectResult(this.context, this.arguments);

  final BuildContext context;
  final RecipeInteractionPageArguments arguments;

  @override
  List<Object> get props => [context, arguments];
}