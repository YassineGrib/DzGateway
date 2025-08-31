class AiTripRequest {
  final double budget;
  final int days;
  final List<String> preferredWilayas;
  final List<String> preferences; // صحراء، بحر، جبال، تاريخي، ثقافي
  final String? additionalInfo;
  final int groupSize;
  final String travelStyle; // اقتصادي، متوسط، فاخر
  final List<String> interests; // طبيعة، تاريخ، ثقافة، مغامرة، استرخاء

  AiTripRequest({
    required this.budget,
    required this.days,
    required this.preferredWilayas,
    required this.preferences,
    this.additionalInfo,
    required this.groupSize,
    required this.travelStyle,
    required this.interests,
  });

  Map<String, dynamic> toJson() {
    return {
      'budget': budget,
      'days': days,
      'preferredWilayas': preferredWilayas,
      'preferences': preferences,
      'additionalInfo': additionalInfo,
      'groupSize': groupSize,
      'travelStyle': travelStyle,
      'interests': interests,
    };
  }

  factory AiTripRequest.fromJson(Map<String, dynamic> json) {
    return AiTripRequest(
      budget: json['budget']?.toDouble() ?? 0.0,
      days: json['days'] ?? 1,
      preferredWilayas: List<String>.from(json['preferredWilayas'] ?? []),
      preferences: List<String>.from(json['preferences'] ?? []),
      additionalInfo: json['additionalInfo'],
      groupSize: json['groupSize'] ?? 1,
      travelStyle: json['travelStyle'] ?? 'متوسط',
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  String generatePrompt() {
    String prompt = '''أنت مخطط رحلات سياحية خبير في الجزائر. أريد منك تخطيط رحلة سياحية مفصلة بناءً على المعلومات التالية:

📊 معلومات الرحلة:
• الميزانية: ${budget.toStringAsFixed(0)} دج
• عدد الأيام: $days أيام
• عدد الأشخاص: $groupSize أشخاص
• نمط السفر: $travelStyle

🗺️ الولايات المفضلة: ${preferredWilayas.join('، ')}

🎯 التفضيلات: ${preferences.join('، ')}

💡 الاهتمامات: ${interests.join('، ')}
''';

    if (additionalInfo != null && additionalInfo!.isNotEmpty) {
      prompt += '\n📝 معلومات إضافية: $additionalInfo\n';
    }

    prompt += '''\nيرجى تقديم:
1. برنامج يومي مفصل للرحلة
2. أماكن الإقامة المقترحة مع الأسعار التقريبية
3. المطاعم والأكلات المحلية المميزة
4. وسائل النقل والمواصلات
5. الأنشطة والمعالم السياحية
6. نصائح مهمة للسفر
7. تقدير التكاليف التفصيلي
8. أفضل الأوقات لزيارة كل مكان

اجعل الإجابة باللغة العربية ومنظمة بشكل جميل مع استخدام الرموز التعبيرية.''';

    return prompt;
  }
}

class AiTripResponse {
  final String content;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;

  AiTripResponse({
    required this.content,
    required this.timestamp,
    this.isLoading = false,
    this.error,
  });

  factory AiTripResponse.loading() {
    return AiTripResponse(
      content: '',
      timestamp: DateTime.now(),
      isLoading: true,
    );
  }

  factory AiTripResponse.error(String errorMessage) {
    return AiTripResponse(
      content: '',
      timestamp: DateTime.now(),
      error: errorMessage,
    );
  }

  factory AiTripResponse.success(String content) {
    return AiTripResponse(
      content: content,
      timestamp: DateTime.now(),
    );
  }
}