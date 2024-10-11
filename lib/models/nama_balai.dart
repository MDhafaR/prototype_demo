class NamaBalai {
  final int id;
  final String nama;

  NamaBalai({required this.id, required this.nama});

  factory NamaBalai.fromJson(Map<String, dynamic> json) {
    return NamaBalai(
      id: json['id'] as int,
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
      };
}
