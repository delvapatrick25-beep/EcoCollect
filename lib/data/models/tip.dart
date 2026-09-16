enum TipCategory {
  tri('Tri'),
  eau('Eau'),
  energie('Énergie'),
  alimentation('Alimentation'),
  transport('Transport');

  final String label;

  const TipCategory(this.label);
}

class Tip {
  final String id;
  final String titre;
  final String contenu;
  final String categorie;
  final String? imageUrl;

  const Tip({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.categorie,
    this.imageUrl,
  });
}