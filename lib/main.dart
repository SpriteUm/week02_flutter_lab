import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 02 Lab Extended',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// ─── Main Screen with Bottom Navigation ─────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    CounterPage(),
    FormPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Counter',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit),
            label: 'Form',
          ),
        ],
      ),
    );
  }
}

// ─── Page 1: Dashboard ──────────────────────────────────
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClockWidget(),
            SizedBox(height: 16),
            Text('ข้อมูลสรุป',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            InfoCard(
              title: 'นักศึกษา', value: '42 คน',
              icon: Icons.people, color: Colors.indigo,
            ),
            SizedBox(height: 8),
            InfoCard(
              title: 'GPA เฉลี่ย', value: '3.21',
              icon: Icons.school, color: Colors.green,
            ),
            SizedBox(height: 8),
            InfoCard(
              title: 'รายวิชา', value: '5 วิชา',
              icon: Icons.book, color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Page 2: Counter (โจทย์ B: เพิ่ม History) ────────────
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  int _step = 1;
  final List<String> _history = [];

  // ฟังก์ชันฟอร์แมตเวลา HH:mm:ss
  String _getCurrentTime() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  // ฟังก์ชันบันทึก History
  void _recordHistory(String action) {
    final timeStr = _getCurrentTime();
    setState(() {
      _history.insert(0, '$timeStr — $action (รวม: $_count)');
    });
  }

  void _increment() {
    setState(() => _count += _step);
    _recordHistory('เพิ่ม $_step');
  }

  void _decrement() {
    setState(() => _count -= _step);
    _recordHistory('ลด $_step');
  }

  void _reset() {
    setState(() => _count = 0);
    _recordHistory('Reset');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // แสดงตัวเลข Counter
            Text(
              '$_count',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: _count >= 0 ? Colors.indigo : Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            // ปุ่มดำเนินการ
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'dec',
                  onPressed: _decrement,
                  backgroundColor: Colors.red.shade50,
                  child: const Icon(Icons.remove, color: Colors.red),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'inc',
                  onPressed: _increment,
                  backgroundColor: Colors.green.shade50,
                  child: const Icon(Icons.add, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // เลือกขนาด Step
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 5, 10, 100].map((s) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('$s'),
                    selected: _step == s,
                    onSelected: (_) => setState(() => _step = s),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 24),
            // ส่วนแสดงประวัติ (History Section)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ประวัติกิจกรรม',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_history.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => setState(() => _history.clear()),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('ล้าง History'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _history.isEmpty
                  ? const Center(
                      child: Text(
                        'ยังไม่มีประวัติการใช้งาน',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            child: Text(
                              _history[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Page 3: Form (โจทย์ C: เพิ่ม Dropdown เลือกภาษา) ─────
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _nameController = TextEditingController();
  String _greeting = '';
  String _error = '';
  String _selectedLanguage = 'ไทย'; // ค่าเริ่มต้นภาษา

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    setState(() {
      if (name.isEmpty) {
        // ข้อความ Error ตามภาษาที่เลือก
        if (_selectedLanguage == 'ไทย') {
          _error = 'กรุณากรอกชื่อ';
        } else if (_selectedLanguage == 'อังกฤษ') {
          _error = 'Please enter your name';
        } else {
          _error = '名前を入力してください';
        }
        _greeting = '';
      } else {
        _error = '';
        final h = DateTime.now().hour;

        // คำทักทายแยกตามภาษา
        if (_selectedLanguage == 'ไทย') {
          final period = h < 12 ? 'ตอนเช้า' : h < 17 ? 'ตอนบ่าย' : 'ตอนเย็น';
          _greeting = 'สวัสดี$period คุณ$name! 👋\nยินดีต้อนรับสู่ Flutter';
        } else if (_selectedLanguage == 'อังกฤษ') {
          final period = h < 12 ? 'Morning' : h < 17 ? 'Afternoon' : 'Evening';
          _greeting = 'Good $period, $name! 👋\nWelcome to Flutter';
        } else if (_selectedLanguage == 'ญี่ปุ่น') {
          final period = h < 12 ? 'おはようございます' : h < 18 ? 'こんにちは' : 'こんばんは';
          _greeting = '$period $name さん! 👋\nFlutterへようこそ';
        }
      }
    });
  }

  void _clear() {
    _nameController.clear();
    setState(() {
      _greeting = '';
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างคำทักทาย'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown เลือกภาษา
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'ภาษาของคำทักทาย',
                prefixIcon: Icon(Icons.language),
                border: OutlineInputBorder(),
              ),
              items: ['ไทย', 'อังกฤษ', 'ญี่ปุ่น'].map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(lang),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedLanguage = val);
                }
              },
            ),
            const SizedBox(height: 12),
            // ช่องกรอกชื่อ
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อของคุณ',
                hintText: 'เช่น สมชาย',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                errorText: _error.isEmpty ? null : _error,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.waving_hand),
                    label: const Text('สร้างคำทักทาย'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _clear,
                  child: const Text('ล้าง'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_greeting.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Text(
                  _greeting,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Components ────────────────────────────────

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.indigo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.access_time, size: 32, color: Colors.indigo),
              Text(
                '${_pad(_currentTime.hour)}:${_pad(_currentTime.minute)}:${_pad(_currentTime.second)}',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_currentTime.day}/${_currentTime.month}/${_currentTime.year + 543}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}