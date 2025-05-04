
class Recipe {
  int? id;
  String? name;
  String? origin;
  String? photo;
  int? difficulty;
  List<String>? ingredients;
  List<String>? instructions;

  Recipe(
      {this.id,
      this.name,
      this.origin,
      this.photo,
      this.difficulty,
      this.ingredients,
      this.instructions});

  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    origin = json['origin'];
    photo = json['photo'];
    difficulty = json['difficulty'];
    ingredients = json['ingredients'].cast<String>();
    instructions = json['instructions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['origin'] = origin;
    data['photo'] = photo;
    data['difficulty'] = difficulty;
    data['ingredients'] = ingredients;
    data['instructions'] = instructions;
    return data;
  }

  //tostring
  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, origin: $origin, photo: $photo, difficulty: $difficulty, ingredients: $ingredients, instructions: $instructions}';
  }
}
