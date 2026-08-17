import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/app_drawer.dart';

class CalculateCGPAPage extends StatefulWidget {
  final String userEmail;

  const CalculateCGPAPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<CalculateCGPAPage> createState() => _CalculateCGPAPageState();
}

class _CalculateCGPAPageState extends State<CalculateCGPAPage> {
  final _numSemestersController = TextEditingController();
  int _numSemesters = 0;
  final List<Map<String, TextEditingController>> _semesters = [];
  List<Map<String, dynamic>> _savedSemesters = [];

  @override
  void initState() {
    super.initState();
    _loadSavedSemesters();
  }

  Future<void> _loadSavedSemesters() async {
    final semesters = await DatabaseService.getSemesters(widget.userEmail);
    setState(() {
      _savedSemesters = semesters;
    });
  }

  void _createSemesterFields() {
    final num = int.tryParse(_numSemestersController.text);
    if (num == null || num <= 0 || num > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number (1-8)'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _numSemesters = num;
      _semesters.clear();
      for (int i = 0; i < num; i++) {
        _semesters.add({
          'credits': TextEditingController(),
          'qp': TextEditingController(),
        });
      }
    });
  }

  void _useSavedSemester(int index, int semesterIndex) {
    if (semesterIndex < _savedSemesters.length) {
      final saved = _savedSemesters[semesterIndex];
      setState(() {
        _semesters[index]['credits']!.text = saved['totalCredits'].toString();
        _semesters[index]['qp']!.text = saved['totalQP'].toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Loaded saved semester ${semesterIndex + 1}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _calculateCGPA() {
    double totalQP = 0;
    double totalCredits = 0;

    for (int i = 0; i < _semesters.length; i++) {
      final credits = double.tryParse(_semesters[i]['credits']!.text);
      final qp = double.tryParse(_semesters[i]['qp']!.text);

      if (credits != null && qp != null && credits > 0) {
        totalQP += qp;
        totalCredits += credits;
      }
    }

    if (totalCredits == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid data'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final cgpa = totalQP / totalCredits;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Text('CGPA Result'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your CGPA',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cgpa.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ResultRow('Total Quality Points', totalQP.toStringAsFixed(2)),
            _ResultRow('Total Credit Hours', totalCredits.toStringAsFixed(0)),
            _ResultRow('Number of Semesters', _numSemesters.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: AppDrawer(userEmail: widget.userEmail),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E1065), AppColors.background],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.gradientStart, AppColors.primary],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.analytics_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Calculate Total CGPA',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Combine multiple semesters for CGPA',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _numSemestersController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Number of Semesters (Max 8)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.list_alt_rounded),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _createSemesterFields,
                              icon: const Icon(Icons.add),
                              label: const Text('Create'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ..._semesters.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final semester = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        color: AppColors.cardBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${idx + 1}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Semester ${idx + 1}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_savedSemesters.isNotEmpty)
                                    PopupMenuButton<int>(
                                      icon: const Icon(Icons.history, color: Colors.white70),
                                      tooltip: 'Load Saved Semester',
                                      onSelected: (value) => _useSavedSemester(idx, value),
                                      itemBuilder: (context) => List.generate(
                                        _savedSemesters.length,
                                            (i) => PopupMenuItem(
                                          value: i,
                                          child: Text('Saved Semester ${i + 1}'),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: semester['credits'],
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Total Credit Hours',
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.schedule_outlined, color: Colors.white70),
                                  filled: true,
                                  fillColor: AppColors.cardBackgroundAlt,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: semester['qp'],
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Total Quality Points',
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.star_outlined, color: Colors.white70),
                                  filled: true,
                                  fillColor: AppColors.cardBackgroundAlt,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    if (_semesters.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _calculateCGPA,
                        icon: const Icon(Icons.analytics_rounded),
                        label: const Text('Calculate CGPA'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}