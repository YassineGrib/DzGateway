import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';

class DatabaseTest extends StatefulWidget {
  @override
  _DatabaseTestState createState() => _DatabaseTestState();
}

class _DatabaseTestState extends State<DatabaseTest> {
  String _result = 'Testing...';

  @override
  void initState() {
    super.initState();
    _testDatabase();
  }

  Future<void> _testDatabase() async {
    try {
      print('🔍 Starting database test...');
      
      // Test basic connection
      final supabase = Supabase.instance.client;
      print('✅ Supabase client initialized');
      
      // Test travel_agencies table query
      print('🔍 Querying travel_agencies table...');
      final response = await supabase
          .from('travel_agencies')
          .select('*')
          .limit(5);
      
      print('📊 Raw response: $response');
      print('📊 Response type: ${response.runtimeType}');
      print('📊 Response length: ${response.length}');
      
      if (response.isEmpty) {
        print('⚠️ No travel agencies found in database');
        setState(() {
          _result = 'No travel agencies found in database';
        });
      } else {
        print('✅ Found ${response.length} travel agencies');
        for (var agency in response) {
          print('🏢 Agency: ${agency['name']} - Active: ${agency['is_active']}');
        }
        setState(() {
          _result = 'Found ${response.length} travel agencies:\n' +
              response.map((a) => '• ${a['name']}').join('\n');
        });
      }
      
    } catch (e, stackTrace) {
      print('❌ Database test error: $e');
      print('📍 Stack trace: $stackTrace');
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Test'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Database Connection Test',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Result:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testDatabase,
              child: Text('Test Again'),
            ),
          ],
        ),
      ),
    );
  }
}