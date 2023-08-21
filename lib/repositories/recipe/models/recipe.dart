part of 'package:recipe_social_media/repositories/recipe/recipe_repo.dart';

class Recipe extends Equatable with JsonConvertible {
  const Recipe(this.id, this.title, this.description, this.chefUsername, this.creationDate);

  final String id;
  final String title;
  final String description;
  final String chefUsername;
  final DateTime creationDate;

  static Recipe fromJson(Map jsonData, JsonWrapper jsonWrapper) {
    return Recipe(
      jsonData["id"],
      jsonData["title"],
      jsonData["description"],
      jsonData["chefUsername"],
      DateTime.parse(jsonData["creationDate"])
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, chefUsername, creationDate];
}
