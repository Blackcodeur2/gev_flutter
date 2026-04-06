class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String numCni;
  final String dateNaissance;
  final String email;
  final String telephone;
  final int? gareId;
  final String role;
  final String statut;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.numCni,
    required this.dateNaissance,
    required this.email,
    required this.telephone,
    this.gareId,
    required this.role,
    this.statut = "CLIENT",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      numCni: json['num_cni'] ?? '',
      dateNaissance: json['date_naissance'].toString(),
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      role: json['role_user'] ?? 'CLIENT',
      statut: json['statut'] ?? 'CLIENT',
      gareId: json['gare_id'] != null
          ? int.tryParse(json['gare_id'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'nom' : nom,
      'prenom' : prenom,
      'num_cni' : numCni,
      'email' : email,
      'telephone' : telephone,
      'date_naissance' : dateNaissance,
      'role_user' : role,
      'statut' : statut,
      'gare_id' : gareId,
    };
  }
}