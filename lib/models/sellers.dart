class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerProfileUrl;
  String? sellerEmail;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerProfileUrl,
    this.sellerEmail,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerProfileUrl = json["sellerProfileUrl"];
    sellerEmail = json["sellerEmail"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sellerUID"] = this.sellerUID;
    data["sellerName"] = this.sellerName;
    data["sellerProfileUrl"] = this.sellerProfileUrl;
    data["sellerEmail"] = this.sellerEmail;

    return data;
  }
}
