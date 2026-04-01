class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String numCni;
  final String dateNaissance;
  final String email;
  final int? gareId;
  final String role;
  final String statut;

  UserModel({required this.id, required this.nom, required this.prenom, required this.numCni, required this.dateNaissance, required this.email, this.gareId, required this.role, this.statut = "CLIENT"});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      nom: json['nom'] ?? '', 
      prenom: json['prenom'] ?? '', 
      numCni: json['num_cni'] ?? '', 
      dateNaissance:json['date_naissance'].toString(),
      email: json['email'], 
      role: json['role_user'],
      statut: json['statut'],
      gareId: int.parse((json['gare_id'] ?? 0).toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'nom' : nom,
      'prenom' : prenom,
      'num_cni' : numCni,
      'email' : email,
      'date_naissance' : dateNaissance,
      'role_user' : role,
      'statut' : statut,
    };
  }
}