class WorkTableModel {
  String workDescription;
  String quantity;
  String unit;
  String id;

  WorkTableModel({

    required this.workDescription,
    required this.quantity,
    required this.unit,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'workDescription': workDescription,
      'quantity': quantity,
      'unit': unit,
      'id':id,
    };
  }

  factory WorkTableModel.fromJson(Map<String, dynamic> json) {
    return WorkTableModel(
      id: json['id'],
      workDescription: json['workDescription'] ?? '',
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? '',
    );
  }
}
