class CloudinaryResponse {
  bool isError;
  String? publicId;
  int? version;
  int? width;
  int? height;
  String? format;
  String? createdAt;
  String? resourceType;
  List<Object>? tags;
  int? bytes;
  String? type;
  String? etag;
  String? url;
  String? secureUrl;
  String? signature;
  String? originalFilename;
  String? error;

  CloudinaryResponse.fromJsonMap(Map<String, dynamic> map)
      : isError = false,
        publicId = map['public_id'] as String,
        version = map['version'] as int,
        width = map['width'] as int,
        height = map['height'] as int,
        format = map['format'] as String,
        createdAt = map['created_at'] as String,
        resourceType = map['resource_type'] as String,
        tags = map['tags'] as List<Object>,
        bytes = map['bytes'] as int,
        type = map['type'] as String,
        etag = map['etag'] as String,
        url = map['url'] as String,
        secureUrl = map['secure_url'] as String,
        signature = map['signature'] as String,
        originalFilename = map['original_filename'] as String;

  CloudinaryResponse.fromError(this.error)
      : isError = true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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