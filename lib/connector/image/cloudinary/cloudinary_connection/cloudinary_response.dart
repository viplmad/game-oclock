class CloudinaryResponse {
  String publicId;
  int version;
  int width;
  int height;
  String format;
  String createdAt;
  String resourceType;
  List<Object> tags;
  int bytes;
  String type;
  String etag;
  String url;
  String secureUrl;
  String signature;
  String originalFilename;
  String error;

  CloudinaryResponse.fromJsonMap(Map<String, dynamic> map)
      : publicId = map["public_id"],
        version = map["version"],
        width = map["width"],
        height = map["height"],
        format = map["format"],
        createdAt = map["created_at"],
        resourceType = map["resource_type"],
        tags = map["tags"],
        bytes = map["bytes"],
        type = map["type"],
        etag = map["etag"],
        url = map["url"],
        secureUrl = map["secure_url"],
        signature = map["signature"],
        originalFilename = map["original_filename"];

  CloudinaryResponse.fromError(this.error);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = publicId;
    data['version'] = version;
    data['width'] = width;
    data['height'] = height;
    data['format'] = format;
    data['created_at'] = createdAt;
    data['resource_type'] = resourceType;
    data['tags'] = tags;
    data['bytes'] = bytes;
    data['type'] = type;
    data['etag'] = etag;
    data['url'] = url;
    data['secure_url'] = secureUrl;
    data['signature'] = signature;
    data['original_filename'] = originalFilename;
    return data;
  }
}