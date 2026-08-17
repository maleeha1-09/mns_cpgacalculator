import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/database_service.dart';
import '../../services/qp_calculator.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/app_drawer.dart';

class CalculateGPAPage extends StatefulWidget {
  final String userEmail;

  const CalculateGPAPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<CalculateGPAPage> createState() => _CalculateGPAPageState();
}

class _CalculateGPAPageState extends State<CalculateGPAPage> {
  final _numSubjectsController = TextEditingController();
  int _numSubjects = 0;
  final List<Map<String, TextEditingController>> _subjects = [];
  final List<double> _qualityPoints = [];

  void _createSubjectFields() {
    final num = int.tryParse(_numSubjectsController.text);
    if (num == null || num <= 0 || num > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number (1-20)'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _numSubjects = num;
      _subjects.clear();
      _qualityPoints.clear();
      for (int i = 0; i < num; i++) {
        _subjects.add({
          'name': TextEditingController(),
          'total': TextEditingController(),
          'obtained': TextEditingController(),
          'credits': TextEditingController(),
        });
        _qualityPoints.add(0.0);
      }
    });
  }

  void _updateQualityPoint(int index) {
    final totalText = _subjects[index]['total']!.text;
    final obtainedText = _subjects[index]['obtained']!.text;

    final total = double.tryParse(totalText);
    final obtained = double.tryParse(obtainedText);

    if (total != null && obtained != null && total > 0) {
      final qp = QPCalculator.calculateQP(obtained, total);
      setState(() {
        _qualityPoints[index] = qp;
      });
    } else {
      setState(() {
        _qualityPoints[index] = 0.0;
      });
    }
  }

  void _calculateGPA() {
    double totalQP = 0;
    double totalCredits = 0;

    for (int i = 0; i < _subjects.length; i++) {
      final total = double.tryParse(_subjects[i]['total']!.text);
      final obtained = double.tryParse(_subjects[i]['obtained']!.text);
      final credits = double.tryParse(_subjects[i]['credits']!.text);

      if (total != null &&
          obtained != null &&
          credits != null &&
          total > 0 &&
          credits > 0) {
        final qp = QPCalculator.calculateQP(obtained, total);
        setState(() {
          _qualityPoints[i] = qp;
        });
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

    final gpa = totalQP / totalCredits;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.star_rounded, color: AppColors.accentYellow, size: 32),
            SizedBox(width: 8),
            Text('GPA Result'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your GPA',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gpa.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ResultRow('Total Quality Points', totalQP.toStringAsFixed(2)),
            _ResultRow('Total Credit Hours', totalCredits.toStringAsFixed(0)),
            _ResultRow('Number of Subjects', _numSubjects.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveSemester(gpa, totalQP, totalCredits);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Semester'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSemester(
      double gpa,
      double totalQP,
      double totalCredits,
      ) async {
    final semesterData = {
      'gpa': gpa,
      'totalQP': totalQP,
      'totalCredits': totalCredits,
      'numSubjects': _numSubjects,
      'subjects': _subjects
          .map(
            (s) => {
          'name': s['name']!.text,
          'total': s['total']!.text,
          'obtained': s['obtained']!.text,
          'credits': s['credits']!.text,
        },
      )
          .toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    await DatabaseService.saveSemester(widget.userEmail, semesterData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semester saved successfully!'),
        backgroundColor: AppColors.success,
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
                            Icons.calculate_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Calculate Semester GPA',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Enter subject details to calculate your GPA',
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
                                controller: _numSubjectsController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Number of Subjects',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.numbers),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _createSubjectFields,
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
                    ..._subjects.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final subject = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
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
                                    'Subject ${idx + 1}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: subject['name'],
                                decoration: InputDecoration(
                                  labelText: 'Subject Name (Optional)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.book_outlined),
                                  filled: true,
                                  fillColor: AppColors.cardBackgroundAlt,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: subject['total'],
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) => _updateQualityPoint(idx),
                                      decoration: InputDecoration(
                                        labelText: 'Total Marks',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.cardBackgroundAlt,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: subject['obtained'],
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) => _updateQualityPoint(idx),
                                      decoration: InputDecoration(
                                        labelText: 'Obtained',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.cardBackgroundAlt,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: subject['credits'],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Credit Hours',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.schedule_outlined),
                                  filled: true,
                                  fillColor: AppColors.cardBackgroundAlt,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.cardBackgroundAlt,
                                      AppColors.background,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primaryLight),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.star_rounded, color: AppColors.accentYellow),
                                        SizedBox(width: 8),
                                        Text(
                                          'Quality Points:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _qualityPoints[idx].toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    if (_subjects.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _calculateGPA,
                        icon: const Icon(Icons.calculate_rounded),
                        label: const Text('Calculate GPA'),
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