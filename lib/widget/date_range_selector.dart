import 'package:flutter/material.dart';
import 'package:expense_tracker/models/date_filter.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatefulWidget {
  const DateRangeSelector({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  final DateFilter currentFilter;
  final void Function(DateFilter) onApply;

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  late FilterType _selectedFilterType;
  late ChartType _selectedChartType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedFilterType = widget.currentFilter.filterType;
    _selectedChartType = widget.currentFilter.chartType;
    _startDate = widget.currentFilter.startDate;
    _endDate = widget.currentFilter.endDate;
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: _endDate ?? now,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now,
      firstDate: _startDate ?? DateTime(now.year - 10),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _applyFilter() {
    if (_selectedFilterType == FilterType.custom &&
        (_startDate == null || _endDate == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final newFilter = DateFilter(
      filterType: _selectedFilterType,
      chartType: _selectedChartType,
      startDate: _startDate,
      endDate: _endDate,
    );

    widget.onApply(newFilter);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final dateFormat = DateFormat.yMMMd();

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
              ),
              const SizedBox(width: 12),
              Text(
                'Filter & Chart Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.grey[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart Type Selection
          Text(
            'Chart Type',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildChartTypeButton(
                  'Bar Chart',
                  Icons.bar_chart,
                  ChartType.bar,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChartTypeButton(
                  'Pie Chart',
                  Icons.pie_chart,
                  ChartType.pie,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filter Type Selection
          Text(
            'Date Range',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterTypeButton(
                  'All Time',
                  Icons.all_inclusive,
                  FilterType.allTime,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterTypeButton(
                  'Custom Range',
                  Icons.date_range,
                  FilterType.custom,
                  isDarkMode,
                ),
              ),
            ],
          ),

          // Date Pickers (only show if custom range selected)
          if (_selectedFilterType == FilterType.custom) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    'From',
                    _startDate,
                    _pickStartDate,
                    dateFormat,
                    isDarkMode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateButton(
                    'To',
                    _endDate,
                    _pickEndDate,
                    dateFormat,
                    isDarkMode,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.blue[700] : Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(
    String label,
    IconData icon,
    ChartType type,
    bool isDarkMode,
  ) {
    final isSelected = _selectedChartType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode ? Colors.blue[700] : Colors.blue[600])
              : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDarkMode ? Colors.blue[500]! : Colors.blue[400]!)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.grey[300] : Colors.grey[800]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTypeButton(
    String label,
    IconData icon,
    FilterType type,
    bool isDarkMode,
  ) {
    final isSelected = _selectedFilterType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterType = type;
          if (type == FilterType.allTime) {
            _startDate = null;
            _endDate = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode ? Colors.green[700] : Colors.green[600])
              : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDarkMode ? Colors.green[500]! : Colors.green[400]!)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.grey[300] : Colors.grey[800]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(
    String label,
    DateTime? date,
    VoidCallback onTap,
    DateFormat dateFormat,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null ? dateFormat.format(date) : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.grey[900],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}