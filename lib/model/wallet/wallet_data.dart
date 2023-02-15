class WalletData {
  List<Wallet>? data;

  WalletData({this.data});

  WalletData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Wallet>[];
      json['data'].forEach((v) {
        data!.add(new Wallet.fromJson(v));
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

class Wallet {
  int? id;
  String? amount;
  String? transactionTypeCase;
  String? createdAt;
  String? orderNo;
  String? status;
  String? transactionType;

  Wallet(
      {this.id,
        this.amount,
        this.transactionTypeCase,
        this.createdAt,
        this.orderNo,
        this.status,
        this.transactionType});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    transactionTypeCase = json['transaction_type_case'];
    createdAt = json['created_at'];
    orderNo = json['order_no'];
    status = json['status'];
    transactionType = json['transaction_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['transaction_type_case'] = this.transactionTypeCase;
    data['created_at'] = this.createdAt;
    data['order_no'] = this.orderNo;
    data['status'] = this.status;
    data['transaction_type'] = this.transactionType;
    return data;
  }
}