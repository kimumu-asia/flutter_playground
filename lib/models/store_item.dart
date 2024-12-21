class StoreItem {
  String storeName;
  String imageUrl;
  String? reviewScore;
  String? reviewCount;

  StoreItem(
      {required this.storeName,
      required this.imageUrl,
      this.reviewScore,
      this.reviewCount});
}
