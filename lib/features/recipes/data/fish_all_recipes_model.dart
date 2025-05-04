import 'recipe_model.dart';

class FishAllRecipes {
  String? name;
  List<Recipe>? recipe;

  FishAllRecipes({this.name, this.recipe});

  FishAllRecipes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['recipe'] != null) {
      recipe = <Recipe>[];
      json['recipe'].forEach((v) {
        recipe!.add(Recipe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (recipe != null) {
      data['recipe'] = recipe!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'FishFullRecipes{name: $name, recipe: $recipe}';
  }
}
