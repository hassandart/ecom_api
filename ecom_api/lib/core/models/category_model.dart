class CategoryModel {
  final int id;
  final String name;
  final String slug; // Ajout du champ pour l'API

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug, // Requis à la création
  });
}
