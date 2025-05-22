// This model represents the data needed for a Midtrans transaction
class MidtransTransaction {
  final int amount;
  final String name;
  final String email;

  MidtransTransaction({
    required this.amount,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'name': name,
      'email': email,
    };
  }
}

// This model represents the response from the transaction endpoint
class MidtransTokenResponse {
  final String token;

  MidtransTokenResponse({required this.token});

  factory MidtransTokenResponse.fromJson(Map<String, dynamic> json) {
    return MidtransTokenResponse(
      token: json['token'] as String,
    );
  }
}
