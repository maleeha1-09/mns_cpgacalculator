import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/app_drawer.dart';

class FormulaPage extends StatelessWidget {
  const FormulaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),
      backgroundColor: Colors.deepPurple.shade50,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.calculate_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'CGPA Formulas',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Understanding the calculations',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFormulaCard(
                    'GPA Formula',
                    'GPA = (Total Quality Points) / (Total Credit Hours)',
                    'Quality Points for each subject are summed and then divided by total credit hours.',
                    Icons.functions_rounded,
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildFormulaCard(
                    'CGPA Formula',
                    'CGPA = (Sum of all Quality Points) / (Sum of all Credit Hours)',
                    'All quality points from all semesters are summed and divided by total credit hours across all semesters.',
                    Icons.analytics_rounded,
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Quality Points System',
                    'Quality Points are based on obtained marks and maximum marks:\n\n'
                        '• Grade A (80-100%): Highest QP\n'
                        '• Grade B (65-79%): High QP\n'
                        '• Grade C (50-64%): Medium QP\n'
                        '• Grade D (40-49%): Low QP\n\n'
                        'QP values vary based on maximum marks: 20, 40, 60, 80, or 100',
                    Icons.star_rounded,
                    Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'How to Calculate',
                    '1. Enter marks and credit hours for each subject\n'
                        '2. System calculates Quality Points automatically\n'
                        '3. GPA = Total QP / Total Credits\n'
                        '4. CGPA combines multiple semesters',
                    Icons.checklist_rounded,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
          const CustomFooter(),
        ],
      ),
    );
  }

  Widget _buildFormulaCard(
      String title,
      String formula,
      String description,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                formula,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.deepPurple.shade900,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title,
      String content,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.deepPurple.shade900,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}