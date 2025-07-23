import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constants.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';



class FilterBottomSheet extends StatefulWidget {
  final TaskFilter currentFilter;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TaskFilter _tempFilter;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _tempFilter = widget.currentFilter;
    _selectedDate = widget.currentFilter.specificDate;
  }

  void _updateCategory(String category) {
    setState(() {
      if (_tempFilter.category == category) {
        _tempFilter = _tempFilter.copyWith(category: null);
      } else {
        _tempFilter = _tempFilter.copyWith(category: category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Priority Filter Section
          _buildSectionTitle('Priority'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                '1 (Highest)',
                _tempFilter.priority == 1,
                    () => _updatePriority(1),
                color: Colors.red,
              ),
              _buildFilterChip(
                '2 (High)',
                _tempFilter.priority == 2,
                    () => _updatePriority(2),
                color: Colors.orange,
              ),
              _buildFilterChip(
                '3 (Medium)',
                _tempFilter.priority == 3,
                    () => _updatePriority(3),
                color: Colors.yellow,
              ),
              _buildFilterChip(
                '4 (Low)',
                _tempFilter.priority == 4,
                    () => _updatePriority(4),
                color: Colors.green,
              ),
              _buildFilterChip(
                '5 (Lowest)',
                _tempFilter.priority == 5,
                    () => _updatePriority(5),
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Category'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CategoryConstants.categories.map((categoryItem) {
              final isSelected = _tempFilter.category == categoryItem.name;
              return _buildFilterChip(
                categoryItem.name,
                isSelected,
                    () => _updateCategory(categoryItem.name),
                color: categoryItem.color,
              );
            }).toList(),
          ),

          // Date Filter Section
          _buildSectionTitle('Date'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                'Today',
                _tempFilter.dateFilter == DateFilterType.today,
                    () => _updateDateFilter(DateFilterType.today),
              ),
              _buildFilterChip(
                'Tomorrow',
                _tempFilter.dateFilter == DateFilterType.tomorrow,
                    () => _updateDateFilter(DateFilterType.tomorrow),
              ),
              _buildFilterChip(
                'This Week',
                _tempFilter.dateFilter == DateFilterType.thisWeek,
                    () => _updateDateFilter(DateFilterType.thisWeek),
              ),
              _buildFilterChip(
                'This Month',
                _tempFilter.dateFilter == DateFilterType.thisMonth,
                    () => _updateDateFilter(DateFilterType.thisMonth),
              ),
              _buildFilterChip(
                'Overdue',
                _tempFilter.dateFilter == DateFilterType.overdue,
                    () => _updateDateFilter(DateFilterType.overdue),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Specific Date Picker
          GestureDetector(
            onTap: _pickSpecificDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _tempFilter.dateFilter == DateFilterType.specific
                    ? Colors.blue.withOpacity(0.2)
                    : const Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _tempFilter.dateFilter == DateFilterType.specific
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: _tempFilter.dateFilter == DateFilterType.specific
                        ? Colors.blue
                        : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDate != null
                        ? 'Selected: ${_formatDate(_selectedDate!)}'
                        : 'Pick specific date',
                    style: TextStyle(
                      color: _tempFilter.dateFilter == DateFilterType.specific
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildFilterChip(
      String label,
      bool isSelected,
      VoidCallback onTap, {
        Color? color,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? Colors.blue).withOpacity(0.2)
              : const Color(0xFF333333),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? (color ?? Colors.blue) : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? (color ?? Colors.blue) : Colors.white,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _updatePriority(int priority) {
    setState(() {
      if (_tempFilter.priority == priority) {
        _tempFilter = _tempFilter.copyWith(priority: null);
      } else {
        _tempFilter = _tempFilter.copyWith(priority: priority);
      }
    });
  }

  void _updateDateFilter(DateFilterType dateFilter) {
    setState(() {
      if (_tempFilter.dateFilter == dateFilter) {
        _tempFilter = _tempFilter.copyWith(dateFilter: null);
      } else {
        _tempFilter = _tempFilter.copyWith(dateFilter: dateFilter);
      }
    });
  }

  Future<void> _pickSpecificDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _tempFilter = _tempFilter.copyWith(
          dateFilter: DateFilterType.specific,
          specificDate: date,
        );
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _tempFilter = const TaskFilter();
      _selectedDate = null;
    });
  }

  void _applyFilters() {
    context.read<TaskBloc>().add(ApplyFiltersEvent(_tempFilter));
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}