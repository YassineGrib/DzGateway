import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(Map<String, dynamic>)? onFilterChanged;
  final List<String>? filterOptions;
  final String searchHint;
  final Color primaryColor;

  const SearchFilterWidget({
    super.key,
    this.onSearchChanged,
    this.onFilterChanged,
    this.filterOptions,
    this.searchHint = 'ابحث...',
    this.primaryColor = AppColors.primary,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Initialize filters
    if (widget.filterOptions != null) {
      for (String option in widget.filterOptions!) {
        _selectedFilters[option] = false;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onSearchChanged(String value) {
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(value);
    }
  }

  void _onFilterChanged() {
    if (widget.onFilterChanged != null) {
      widget.onFilterChanged!(_selectedFilters);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Expanded Search and Filter Panel
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: _animation.value,
                child: _isExpanded ? _buildExpandedPanel() : const SizedBox(),
              ),
            );
          },
        ),
        // Floating Action Button
        Positioned(
          bottom: 0,
          right: 0,
          child: FloatingActionButton(
            onPressed: _toggleExpansion,
            backgroundColor: widget.primaryColor,
            child: AnimatedRotation(
              turns: _isExpanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isExpanded ? Icons.close : Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedPanel() {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      margin: const EdgeInsets.only(bottom: 72, right: 16, left: 16),
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: widget.searchHint,
              hintStyle: GoogleFonts.tajawal(
                color: AppColors.textSecondary,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: widget.primaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                borderSide: BorderSide(color: widget.primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
            ),
          ),
          
          // Filters Section
          if (widget.filterOptions != null && widget.filterOptions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.medium),
            Text(
              'الفلاتر',
              style: GoogleFonts.tajawal(
                fontSize: AppFontSizes.medium,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Wrap(
              spacing: AppSpacing.small,
              runSpacing: AppSpacing.small,
              children: widget.filterOptions!.map((option) {
                return FilterChip(
                  label: Text(
                    option,
                    style: GoogleFonts.tajawal(
                      fontSize: AppFontSizes.small,
                      color: _selectedFilters[option] == true
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                  selected: _selectedFilters[option] == true,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilters[option] = selected;
                    });
                    _onFilterChanged();
                  },
                  selectedColor: widget.primaryColor,
                  checkmarkColor: Colors.white,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: _selectedFilters[option] == true
                        ? widget.primaryColor
                        : AppColors.border,
                  ),
                );
              }).toList(),
            ),
          ],
          
          // Action Buttons
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      for (String key in _selectedFilters.keys) {
                        _selectedFilters[key] = false;
                      }
                    });
                    _onSearchChanged('');
                    _onFilterChanged();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                    ),
                  ),
                  child: Text(
                    'مسح الكل',
                    style: GoogleFonts.tajawal(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggleExpansion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                    ),
                  ),
                  child: Text(
                    'تطبيق',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}