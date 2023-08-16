part of 'recipe_models.dart';

class Recipe extends Equatable {
  const Recipe(this.id, this.title, this.description, this.chefUsername,
      this.creationDate);

  final String id;
  final String title;
  final String description;
  final String chefUsername;
  final DateTime creationDate;

  @override
  List<Object?> get props =>
      [id, title, description, chefUsername, creationDate];
}
