class FileModel {
  String? id;
  String? name;
  String? path;
  String? originalName;
  String? publicUrl;
  String? fileExtension;
  double? sizeInMb;

  FileModel({
    this.id,
    this.name,
    this.path,
    this.originalName,
    this.publicUrl,
    this.fileExtension,
    this.sizeInMb,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['_id'],
      name: json['name'],
      path: json['path'],
      originalName: json['originalName'],
      publicUrl: json['publicUrl'],
      fileExtension: json['fileExtension'],
      sizeInMb: double.tryParse(json['sizeInMb'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "path": path,
    "originalName": originalName,
    "publicUrl": publicUrl,
    "fileExtension": fileExtension,
    "sizeInMb": sizeInMb,
  };

}
