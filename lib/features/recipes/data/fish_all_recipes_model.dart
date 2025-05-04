import 'recipe_model.dart';

class FishAllRecipes {
  String? name;
  String? photo;
  List<Recipe>? recipe;

  FishAllRecipes({this.name, this.recipe});

  FishAllRecipes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
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
    data['photo'] = photo;
    if (recipe != null) {
      data['recipe'] = recipe!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'FishFullRecipes{name: $name,photo: $photo,recipe: $recipe}';
  }
}
