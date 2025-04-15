class StoreItem {
  String storeName;
  String imageUrl;
  String? reviewRate;
  String? revisitRate;
  String? visitCount;

  StoreItem(
      {required this.storeName,
      required this.imageUrl,
      this.reviewRate,
      this.revisitRate,
      this.visitCount});
}
