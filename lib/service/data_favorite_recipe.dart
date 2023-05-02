class FavoriteRecipe {
  late String id;
  late String title;
  late String imageUrl;

  FavoriteRecipe({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  FavoriteRecipe.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    imageUrl = map['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}
