import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_social_media/forms/widgets/form_widgets.dart';
import 'package:recipe_social_media/pages/recipes/recipe_interaction/bloc/recipe_interaction_bloc.dart';
import 'package:recipe_social_media/pages/recipes/recipe_interaction/widgets/recipe_interaction_widgets.dart' as riw;
import 'package:recipe_social_media/repositories/authentication/auth_repo.dart';
import 'package:recipe_social_media/repositories/image/image_repo.dart';
import 'package:recipe_social_media/repositories/navigation/args/recipe_interaction_page_arguments.dart';
import 'package:recipe_social_media/repositories/recipe/recipe_repo.dart';
import 'package:recipe_social_media/widgets/custom_expansion_tile.dart';

class RecipeInteractionPage extends StatelessWidget {
  const RecipeInteractionPage({super.key});

  static const double inputFormFontSize = 14;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      args = args as RecipeInteractionPageArguments;
      print(args.recipeId);
      print(args.readonly);
    }

    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => ImageRepository()),
          RepositoryProvider(create: (_) => RecipeRepository()),
        ],
        child: BlocProvider<RecipeInteractionBloc>(
            create: (recipeInteractContext) => RecipeInteractionBloc(
              context.read<AuthenticationRepository>(),
              recipeInteractContext.read<RecipeRepository>(),
              recipeInteractContext.read<ImageRepository>()),
            child: BlocBuilder<RecipeInteractionBloc, RecipeInteractionState>(
              buildWhen: (p, c) => p.formStatus != c.formStatus,
              builder: (context, state) {
                return state.formStatus.isInProgress
                    ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                    : Scaffold(
                        appBar: AppBar(
                          title: const riw.RecipeTitleInput(),
                          backgroundColor: Colors.white,
                          elevation: 0.5,
                          leading: const riw.RecipeBackButton(),
                          actions: const <Widget>[
                            riw.RecipeSubmitButton()
                          ],
                        ),
                        resizeToAvoidBottomInset: false,
                        backgroundColor: Colors.white,
                        body: SingleChildScrollView(
                            reverse: true,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  children: <Widget>[
                                    const Row(children: <Widget>[
                                        Expanded(child: riw.RecipeThumbnailPicker())
                                    ]),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: riw.RecipeDescriptionInput()
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget> [
                                        riw.RecipeTagInput(),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: riw.RecipeTagList()
                                        )
                                      ]
                                    )
                                  ),
                                  CustomExpansionTile(
                                    title: const Text(
                                      'Ingredients',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    children: const [
                                      SizedBox(
                                          height: 65,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  flex: 2,
                                                  child: riw.IngredientNameInput()),
                                              Flexible(
                                                  flex: 1,
                                                  child: riw.IngredientQuantityInput()),
                                              Flexible(
                                                  flex: 2,
                                                  child: riw.IngredientMeasurementInput())
                                            ],
                                          )),
                                      riw.IngredientList()
                                    ],
                                  ),
                                  CustomExpansionTile(
                                    title: const Text(
                                      'Recipe Steps',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    children: const [
                                      SizedBox(
                                          height: 100,
                                          child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: riw.RecipeStepDescriptionInput(),
                                                ),
                                                Flexible(
                                                    flex: 0,
                                                    child: riw.RecipeStepImagePicker()
                                                )
                                              ]
                                          )
                                      ),
                                      riw.RecipeStepList()
                                    ],
                                  ),
                                  CustomExpansionTile(
                                    title: const Text(
                                      'Extra Information',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    children: const [
                                      SizedBox(
                                          height: 65,
                                          child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: riw.ServingNumberInput()
                                                ),
                                                Flexible(
                                                  child: RIServingSizeField()
                                                ),
                                              ]
                                          )
                                      ),
                                      SizedBox(
                                          height: 65,
                                          child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: riw.CookingTimeInput()
                                                ),
                                                Flexible(
                                                  child: riw.KilocaloriesInput(),
                                                ),
                                              ]
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ))));
            })));
  }
}

class RIServingSizeField extends StatelessWidget {
  const RIServingSizeField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeInteractionBloc, RecipeInteractionState>(
        buildWhen: (p, c) => p.servingSize != c.servingSize
            || p.servingSizeValid != c.servingSizeValid,
        builder: (context, state) {
          return FormInput(
            textController: state.servingSizeTextController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            innerPadding: const EdgeInsets.only(left: 5),
            outerPadding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
            hint: 'Serving Size',
            boxDecorationType: state.servingSizeValid
                ? FormInputBoxDecorationType.textArea
                : FormInputBoxDecorationType.error,
            fontSize: RecipeInteractionPage.inputFormFontSize,
            eventFunc: (value) {
              context
                  .read<RecipeInteractionBloc>()
                  .add(ServingSizeChanged(value));
            },
          );
        }
    );
  }
}
