part of 'package:recipe_social_media/pages/recipes/recipe_interaction/widgets/recipe_interaction_widgets.dart';

class ReadonlyIngredientList extends StatelessWidget {
  const ReadonlyIngredientList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeInteractionBloc, RecipeInteractionState>(
      buildWhen: (p, c) => p.ingredientList.length != c.ingredientList.length,
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: state.ingredientList.length,
          separatorBuilder: (context, _) {
            return const SizedBox(height: 20);
          },
          itemBuilder: (context, index) {
            final ing = state.ingredientList[index];
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  ing.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Text(
                  "${ing.quantity.toStringAsFixed(ing.quantity.truncateToDouble() == ing.quantity ? 0 : 3)} ${ing.unitOfMeasurement}",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ]));
          });
      });
  }
}
