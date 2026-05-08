class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String? username;
  final String email;
  final String telephone;
  final String? numCni;
  final String dateNaissance;
  final String sexe;
  final String role;
  final String statut;
  final String? profilUrl;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    this.username,
    required this.email,
    required this.telephone,
    this.numCni,
    required this.dateNaissance,
    required this.sexe,
    required this.role,
    this.statut = "actif",
    this.profilUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      username: json['username'],
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      numCni: json['num_cni'],
      dateNaissance: json['date_naissance']?.toString() ?? '',
      sexe: json['sexe'] ?? 'M',
      role: json['role_user'] ?? 'CLIENT',
      statut: json['statut'] ?? 'actif',
      profilUrl: json['profil_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'username': username,
      'email': email,
      'telephone': telephone,
      'num_cni': numCni,
      'date_naissance': dateNaissance,
      'sexe': sexe,
      'role_user': role,
      'statut': statut,
      'profil_url': profilUrl,
    };
  }
}