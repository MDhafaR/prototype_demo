class MataAir {
  int? id;
  String localId;
  String nama;
  String kota;
  bool isSync;
  String lastModified;

  MataAir({
    this.id,
    required this.localId,
    required this.nama,
    required this.kota,
    this.isSync = false,
    required this.lastModified,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'local_id': localId,
      'nama': nama,
      'kota': kota,
      'is_sync': isSync ? 1 : 0,
      'last_modified': lastModified,
    };
  }

  factory MataAir.fromMap(Map<String, dynamic> map) {
    return MataAir(
      id: map['id'],
      localId: map['local_id'],
      nama: map['nama'],
      kota: map['kota'],
      isSync: map['is_sync'] == 1,
      lastModified: map['last_modified'],
    );
  }
}