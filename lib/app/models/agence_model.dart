class AgenceModel {
  final int? id;
  final String nom;
  final String email;
  final String telephone;
  final String ville;
  final String adresse;
  final String? logoUrl;

  AgenceModel({
    required this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.ville,
    required this.adresse,
    this.logoUrl,
  });

  factory AgenceModel.fromJson(Map<String, dynamic> json) {
    return AgenceModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      ville: json['ville'] ?? '',
      adresse: json['adresse'] ?? '',
      logoUrl: json['logo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'ville': ville,
      'adresse': adresse,
      'logo_url': logoUrl,
    };
  }
}