class FigmaComponent {
  String key;
  String file_key;
  String node_id;
  String thumbnail_url;
  String name;
  String description;
  String updated_at;
  String created_at;

  FigmaComponent(this.key, this.file_key, this.node_id, this.thumbnail_url,
      this.name, this.description, this.updated_at, this.created_at);

  static FigmaComponent fromJson(Map<String, dynamic> json) {
    return FigmaComponent(
        json["key"],
        json["file_key"],
        json["node_id"],
        json["humbnail_url"],
        json["name"],
        json["description"],
        json["updated_at"],
        json["created_at"]);
  }
}
