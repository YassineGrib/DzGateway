import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/ai_trip_request_model.dart';
import '../../../services/ai_trip_service.dart';

class AiTripScreen extends StatefulWidget {
  const AiTripScreen({super.key});

  @override
  State<AiTripScreen> createState() => _AiTripScreenState();
}

class _AiTripScreenState extends State<AiTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _daysController = TextEditingController();
  final _groupSizeController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  
  List<String> _selectedWilayas = [];
  List<String> _selectedPreferences = [];
  List<String> _selectedInterests = [];
  String _selectedTravelStyle = 'متوسط';
  
  AiTripResponse? _currentResponse;
  bool _isLoading = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _daysController.dispose();
    _groupSizeController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _generateTripPlan() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedWilayas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار ولاية واحدة على الأقل')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _currentResponse = AiTripResponse.loading();
    });

    final request = AiTripRequest(
      budget: double.parse(_budgetController.text),
      days: int.parse(_daysController.text),
      preferredWilayas: _selectedWilayas,
      preferences: _selectedPreferences,
      additionalInfo: _additionalInfoController.text.isEmpty 
          ? null 
          : _additionalInfoController.text,
      groupSize: int.parse(_groupSizeController.text),
      travelStyle: _selectedTravelStyle,
      interests: _selectedInterests,
    );

    try {
      final response = await AiTripService.generateTripPlan(request);
      setState(() {
        _currentResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentResponse = AiTripResponse.error('حدث خطأ: ${e.toString()}');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '🤖 مخطط الرحلات الذكي',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildBasicInfoSection(),
              const SizedBox(height: 20),
              _buildWilayasSection(),
              const SizedBox(height: 20),
              _buildPreferencesSection(),
              const SizedBox(height: 20),
              _buildInterestsSection(),
              const SizedBox(height: 20),
              _buildAdditionalInfoSection(),
              const SizedBox(height: 30),
              _buildGenerateButton(),
              const SizedBox(height: 20),
              if (_currentResponse != null) _buildResponseSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.smart_toy,
            size: 50,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Text(
            'مرحباً بك في مخطط الرحلات الذكي',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'أخبرنا عن تفضيلاتك وسنخطط لك رحلة مثالية في الجزائر',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: '📊 معلومات أساسية',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'الميزانية (دج)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الميزانية';
                    }
                    if (double.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _daysController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'عدد الأيام',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عدد الأيام';
                    }
                    final days = int.tryParse(value);
                    if (days == null || days < 1) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _groupSizeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'عدد الأشخاص',
                    prefixIcon: Icon(Icons.group),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عدد الأشخاص';
                    }
                    final size = int.tryParse(value);
                    if (size == null || size < 1) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedTravelStyle,
                  decoration: const InputDecoration(
                    labelText: 'نمط السفر',
                    prefixIcon: Icon(Icons.style),
                    border: OutlineInputBorder(),
                  ),
                  items: AiTripService.getTravelStyles()
                      .map((style) => DropdownMenuItem(
                            value: style,
                            child: Text(style),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTravelStyle = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWilayasSection() {
    return _buildSection(
      title: '🗺️ الولايات المفضلة',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AiTripService.getAlgerianWilayas()
            .map((wilaya) => FilterChip(
                  label: Text(wilaya),
                  selected: _selectedWilayas.contains(wilaya),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedWilayas.add(wilaya);
                      } else {
                        _selectedWilayas.remove(wilaya);
                      }
                    });
                  },
                  selectedColor: Colors.green.withOpacity(0.3),
                  checkmarkColor: Colors.green,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: '🎯 التفضيلات السياحية',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AiTripService.getTravelPreferences()
            .map((preference) => FilterChip(
                  label: Text(preference),
                  selected: _selectedPreferences.contains(preference),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPreferences.add(preference);
                      } else {
                        _selectedPreferences.remove(preference);
                      }
                    });
                  },
                  selectedColor: Colors.blue.withOpacity(0.3),
                  checkmarkColor: Colors.blue,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return _buildSection(
      title: '💡 الاهتمامات',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AiTripService.getTravelInterests()
            .map((interest) => FilterChip(
                  label: Text(interest),
                  selected: _selectedInterests.contains(interest),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest);
                      } else {
                        _selectedInterests.remove(interest);
                      }
                    });
                  },
                  selectedColor: Colors.orange.withOpacity(0.3),
                  checkmarkColor: Colors.orange,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return _buildSection(
      title: '📝 معلومات إضافية',
      child: TextFormField(
        controller: _additionalInfoController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'أي معلومات أو طلبات خاصة تريد إضافتها...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _generateTripPlan,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'جاري التخطيط...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                '🚀 خطط رحلتي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildResponseSection() {
    return _buildSection(
      title: '✨ خطة رحلتك',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _currentResponse!.isLoading
            ? const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('جاري إنشاء خطة رحلتك...'),
                ],
              )
            : _currentResponse!.error != null
                ? Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentResponse!.error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : SelectableText(
                    _currentResponse!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}