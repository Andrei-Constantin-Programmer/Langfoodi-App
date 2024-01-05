import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_social_media/pages/recipes/recipe_view/bloc/recipe_view_bloc.dart';
import 'package:recipe_social_media/repositories/navigation/args/recipe_interaction/recipe_interaction_page_arguments.dart';
import 'package:recipe_social_media/utilities/utilities.dart';
import 'package:recipe_social_media/widgets/shared_widgets.dart';

class RecipeViewPage extends StatelessWidget implements PageLander {
  const RecipeViewPage({super.key});

  @override
  void onLanding(BuildContext context) {
    BlocProvider.of<RecipeViewBloc>(context)
        .add(const ChangeRecipesToDisplay());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeViewBloc, RecipeViewState>(
      listener: (context, state) {
        if (state.dialogMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) => BlocProvider<RecipeViewBloc>.value(
              value: BlocProvider.of<RecipeViewBloc>(context),
              child: CustomAlertDialog(
                title: Text(state.dialogTitle),
                content: Text(state.dialogMessage),
                leftButtonText: null,
                rightButtonText: "Ok",
                rightButtonCallback: () => context
                  .read<RecipeViewBloc>()
                  .add(const ChangeRecipesToDisplay()),
              )
            )
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: EasySearchBar(
            backgroundColor: const Color(0xFF02A713),
            iconTheme: const IconThemeData(color: Colors.white, size: 25),
            title: const Text("My Recipes", style: TextStyle(color: Colors.white)),
            searchHintText: "Search Your Recipes",
            searchHintStyle: const TextStyle(fontSize: 20),
            searchTextStyle: const TextStyle(fontSize: 20),
            suggestionBuilder: (suggestion) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(suggestion, style: const TextStyle(fontSize: 18)),
              );
            },
            suggestions: state.searchSuggestions,
            // onSuggestionTap: (suggestion) => context
            //   .read<RecipeViewBloc>()
            //   .add(const ResetSearchSuggestions()),
            onSearch: (value) => context
              .read<RecipeViewBloc>()
              .add(SearchTermChanged(value)),
            //onSuggestionTap: (suggestion) => print(suggestion),
          ),
          floatingActionButton: CustomFloatingButton(
            key: const Key("recipeViewPage"),
            icon: Icons.add,
            eventFunc: () => context
              .read<RecipeViewBloc>()
              .add(GoToInteractionPageAndExpectResult(
              context, RecipeInteractionPageArguments(
              pageType: RecipeInteractionType.create))
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: state.pageLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BlocBuilder<RecipeViewBloc, RecipeViewState>(
                        builder: (context, state) {
                          return state.recipesToDisplay.isEmpty
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("No Recipes Yet",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              : ItemScrollPanel(
                                  titleFontSize: 22,
                                  hasButton: true,
                                  buttonIcon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                                  items: state.recipesToDisplay.where((r) => r.show == true).toList(),
                                  scrollDirection: Axis.vertical,
                                  imageAspectRatio: 3/4,
                                  onTapButton: (ScrollItem item) => showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider<RecipeViewBloc>.value(
                                      value: BlocProvider.of<RecipeViewBloc>(context),
                                      child: CustomAlertDialog(
                                        title: const Text("Remove Recipe"),
                                        content: Text("Are you sure you want to remove ${item.title}"),
                                        rightButtonText: "Remove",
                                        rightButtonCallback: () => context
                                          .read<RecipeViewBloc>()
                                          .add(RemoveRecipe(item.id)),
                                      )
                                    )
                                  ),
                                  onTap: (ScrollItem item) => context
                                    .read<RecipeViewBloc>()
                                    .add(GoToInteractionPageAndExpectResult(
                                      context, RecipeInteractionPageArguments(
                                        pageType: RecipeInteractionType.readonly,
                                        recipeId: item.id)
                                    ))
                                );
                      })
                    ],
                  ),
                )
            )
        );
      }
    );
  }
}

class PlaceholderPage extends StatelessWidget implements PageLander {
  const PlaceholderPage({super.key});

  @override
  void onLanding(BuildContext context) {
    print("Placeholder page here");
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Placeholder page here");
  }
}
