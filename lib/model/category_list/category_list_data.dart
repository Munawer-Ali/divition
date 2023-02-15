class CategoryListData {
  List<CategoryList>? data;

  CategoryListData({this.data});

  CategoryListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryList>[];
      json['data'].forEach((v) {
        data!.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  int? id;
  String? slug;
  String? image;
  String? title;
  String? customerPrice;
  bool? outOfStock;
  Category? category;
  String? description;
  dynamic specialDiscount;

  CategoryList(
      {this.id,
        this.slug,
        this.image,
        this.title,
        this.customerPrice,
        this.outOfStock,
        this.category,
        this.description,
        this.specialDiscount});

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    image = json['image'];
    title = json['title'];
    customerPrice = json['customer_price'];
    outOfStock = json['out_of_stock'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    description = json['description'];
    if(json.containsKey("categorized_discount")){
      specialDiscount=json['categorized_discount']??0;
    }else{
      specialDiscount=0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['title'] = this.title;
    data['customer_price'] = this.customerPrice;
    data['out_of_stock'] = this.outOfStock;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['description'] = this.description;
    data['categorized_discount'] = this.specialDiscount;
    return data;
  }
}

class Category {
  int? id;
  String? slug;
  String? image;
  String? title;
  String? type;

  Category({this.id, this.slug, this.image, this.title, this.type});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    image = json['image'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}