import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'dart:math' as math;

class PieChart extends StatefulWidget {
  const PieChart({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(widget.expenses, Category.food),
      ExpenseBucket.forCategory(widget.expenses, Category.moneylent),
      ExpenseBucket.forCategory(widget.expenses, Category.grocery),
      ExpenseBucket.forCategory(widget.expenses, Category.travel),
      ExpenseBucket.forCategory(widget.expenses, Category.others),
    ];
  }

  double get totalExpenses {
    double total = 0;
    for (final bucket in buckets) {
      total += bucket.totalExpenses;
    }
    return total;
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.food:
        return Colors.red[400]!;
      case Category.travel:
        return Colors.blue[400]!;
      case Category.grocery:
        return Colors.green[400]!;
      case Category.moneylent:
        return Colors.orange[400]!;
      case Category.others:
        return Colors.purple[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (totalExpenses == 0) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              isDarkMode ? Colors.grey[850]! : Colors.blue[50]!,
              isDarkMode ? Colors.grey[900]! : Colors.indigo[100]!,
            ],
          ),
        ),
        child: Center(
          child: Text(
            'No expenses to display',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            isDarkMode ? Colors.grey[850]! : Colors.blue[50]!,
            isDarkMode ? Colors.grey[900]! : Colors.indigo[100]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.indigo.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Spending Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.indigo[900],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: PieChartPainter(
                    buckets: buckets,
                    totalExpenses: totalExpenses,
                    animation: _animation.value,
                    selectedIndex: _selectedIndex,
                    getCategoryColor: _getCategoryColor,
                  ),
                  child: GestureDetector(
                    onTapDown: (details) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final center = Offset(box.size.width / 2, box.size.height / 2);
                      final position = details.localPosition;
                      final dx = position.dx - center.dx;
                      final dy = position.dy - center.dy;
                      final distance = math.sqrt(dx * dx + dy * dy);
                      
                      if (distance < 90 && distance > 30) {
                        double angle = math.atan2(dy, dx);
                        if (angle < 0) angle += 2 * math.pi;
                        
                        double currentAngle = -math.pi / 2;
                        for (int i = 0; i < buckets.length; i++) {
                          final bucket = buckets[i];
                          if (bucket.totalExpenses > 0) {
                            final sweepAngle = (bucket.totalExpenses / totalExpenses) * 2 * math.pi;
                            if (angle >= currentAngle && angle <= currentAngle + sweepAngle) {
                              setState(() {
                                _selectedIndex = i;
                              });
                              return;
                            }
                            currentAngle += sweepAngle;
                          }
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < buckets.length; i++)
                if (buckets[i].totalExpenses > 0)
                  _buildLegendItem(
                    buckets[i].category,
                    buckets[i].totalExpenses,
                    isDarkMode,
                    i == _selectedIndex,
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    Category category,
    double amount,
    bool isDarkMode,
    bool isSelected,
  ) {
    final color = _getCategoryColor(category);
    final percentage = (amount / totalExpenses * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? color.withOpacity(0.2)
            : (isDarkMode ? Colors.grey[800] : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            category.name.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '($percentage%)',
            style: TextStyle(
              fontSize: 9,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  PieChartPainter({
    required this.buckets,
    required this.totalExpenses,
    required this.animation,
    required this.selectedIndex,
    required this.getCategoryColor,
  });

  final List<ExpenseBucket> buckets;
  final double totalExpenses;
  final double animation;
  final int? selectedIndex;
  final Color Function(Category) getCategoryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.5;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < buckets.length; i++) {
      final bucket = buckets[i];
      if (bucket.totalExpenses > 0) {
        final sweepAngle =
            (bucket.totalExpenses / totalExpenses) * 2 * math.pi * animation;
        final isSelected = i == selectedIndex;
        final paint = Paint()
          ..color = getCategoryColor(bucket.category)
          ..style = PaintingStyle.fill;

        final outerRadius = isSelected ? radius + 10 : radius;
        final rect = Rect.fromCircle(center: center, radius: outerRadius);

        canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

        // Draw inner circle to create donut effect
        final innerPaint = Paint()
          ..color = Colors.grey[850]!
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, radius * 0.5, innerPaint);

        startAngle += sweepAngle;
      }
    }

    // Draw total in center
    final textPainter = TextPainter(
      text: TextSpan(
        text: '₹${totalExpenses.toStringAsFixed(0)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}