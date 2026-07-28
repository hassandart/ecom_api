class ProudctsModel {
  final int id;
  final String name;
  final String image;
  final String description;
  final String type; // Correspond au nom de la catégorie (ex: "groceries")
  final String slug; // Ajout du slug de sa catégorie pour les filtres
  final double price;
  final double rate;

  ProudctsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.type,
    required this.slug, // Requis
    required this.price,
    required this.rate,
  });

  // Convertit le JSON de DummyJSON vers votre modèle personnalisé
  factory ProudctsModel.fromJson(Map<String, dynamic> json) {
    return ProudctsModel(
      id: json['id'] as int,
      name: json['title'] as String,
      image: json['thumbnail'] as String,
      description: json['description'] as String,
      type: json['category'] as String, // Nom brut de la catégorie
      slug:
          json['category']
              as String, // DummyJSON utilise le même nom pour le slug
      price: (json['price'] as num).toDouble(),
      rate: (json['rating'] as num).toDouble(),
    );
  }
}
