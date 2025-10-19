import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ChartBar extends StatefulWidget {
  const ChartBar({
    super.key,
    required this.fill,
    required this.amount,
    required this.category,
  });

  final double fill;
  final double amount;
  final Category category;

  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fillAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fillAnimation =
        Tween<double>(begin: 0, end: widget.fill).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(ChartBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fill != widget.fill) {
      _fillAnimation =
          Tween<double>(begin: oldWidget.fill, end: widget.fill).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutCubic),
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColor() {
    switch (widget.category) {
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
    final barColor = _getColor();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
            if (widget.amount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '₹${widget.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : barColor,
                  ),
                ),
              ),
            SizedBox(
              height: 180,
              child: AnimatedBuilder(
                animation: _fillAnimation,
                builder: (context, child) {
                  return widget.amount > 0
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${widget.category.name.toUpperCase()}: ₹${widget.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: barColor,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: (_fillAnimation.value) * 180,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                                color: _isHovered
                                    ? barColor.withOpacity(1)
                                    : barColor.withOpacity(0.8),
                                boxShadow: _isHovered
                                    ? [
                                        BoxShadow(
                                          color: barColor.withOpacity(0.6),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                                border: _isHovered
                                    ? Border.all(
                                        color: barColor,
                                        width: 2,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        )
                      : Container();
                },
              ),
            ),
          ],
        ),
      );
  }
}