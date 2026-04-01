class AgenceModel {
  final int? id;
  final String nomAgence;
  final String emailAgence;
  final String telephone;
  final String bp;
  final int? prorietaire;

  AgenceModel({required this.id, required this.nomAgence, required this.emailAgence, required this.telephone, required this.bp, required this.prorietaire});

  factory AgenceModel.fromJson(Map<String, dynamic> json) {
    return AgenceModel(
      id: int.parse(json['id'].toString()),
      nomAgence: json['nom_agence'], 
      emailAgence: json['email_agence'], 
      telephone: json['telephone'], 
      bp: json['BP'], 
      prorietaire: int.parse(json['proprietaire'].toString())
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'nom_agence' : nomAgence,
      'email_agence' : emailAgence,
      'telephone' : telephone,
      'BP' : bp,
      'proprietaire' : prorietaire
    };
  }
}