import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/l10n/app_localizations.dart';

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final List<SkillsModel> skillItems;
  final List<String>? selectedSkills;
  final bool isMultiSelect;
  final ValueChanged<String>? onChanged;
  final ValueChanged<List<String>>? onMultiChanged;
  final Color color;
  final String? selectedValue;
  final String? emptyText; // يُعرض داخل القائمة عند عدم وجود عناصر

  const CustomDropdown({
    super.key,
    required this.hint,
    this.items = const [],
    this.skillItems = const [],
    this.selectedSkills = const [],
    this.isMultiSelect = false,
    this.onChanged,
    this.onMultiChanged,
    this.color = AppColor.gray1,
    this.selectedValue,
    this.emptyText,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isOpened = false;
  String _selectedValue = '';
  final List<SkillsModel> _selectedSkills = [];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue ?? '';
    if (widget.selectedSkills != null && widget.selectedSkills!.isNotEmpty) {
      _selectedSkills.clear();
      _selectedSkills.addAll(
        widget.skillItems.where((s) => widget.selectedSkills!.contains(s.name)),
      );
    }
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue && widget.selectedValue != null) {
      _selectedValue = widget.selectedValue!;
    }
  }

  void _toggleDropdown() {
    setState(() {
      _isOpened = !_isOpened;
    });
  }

  void _selectValue(String value) {
    setState(() {
      _selectedValue = value;
      _isOpened = false;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 58.h;
    double itemHeight = 42.h;

    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor, width: 0.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: headerHeight,
            child: InkWell(
              onTap: _toggleDropdown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedSkills.isNotEmpty
                          ? _selectedSkills.map((s) => s.name).join(', ')
                          : _selectedValue.isNotEmpty
                          ? _selectedValue
                          : widget.hint,
                      overflow: TextOverflow.ellipsis,
                      style: MyTextStyle().textStyleMedium15().copyWith(
                        color: _selectedSkills.isNotEmpty || _selectedValue.isNotEmpty
                            ? Colors.black
                            : AppColor.hintTextColor,
                      ),
                    ),
                  ),
                  Icon(
                    _isOpened ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 24.r,
                  ),
                ],
              ),
            ),
          ),
          if (_isOpened)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.isMultiSelect
                      ? widget.skillItems.map((skill) {
                          final isSelected = _selectedSkills.any((s) => s.id == skill.id);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSkills.removeWhere((s) => s.id == skill.id);
                                } else {
                                  _selectedSkills.add(skill);
                                }
                              });
                              widget.onMultiChanged?.call(
                                _selectedSkills.map((s) => s.name).toList(),
                              );
                            },
                            child: Container(
                              height: itemHeight,
                              alignment: AlignmentDirectional.centerStart,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.k1primeryColor.withValues(alpha: 0.1)
                                    : null,
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColor.borderColor.withValues(alpha: 0.3),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                    color: isSelected ? AppColor.k1primeryColor : Colors.grey,
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(skill.name, style: MyTextStyle().textStyleRegular14()),
                                ],
                              ),
                            ),
                          );
                        }).toList()
                      : widget.items.isEmpty
                      ? [
                          // لا توجد بيانات → رسالة داخل القائمة
                          Container(
                            height: itemHeight,
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text(
                              widget.emptyText ??
                                  AppLocalizations.of(context)!
                                      .no_data_available,
                              style: MyTextStyle().textStyleRegular14().copyWith(
                                color: AppColor.gray2,
                              ),
                            ),
                          ),
                        ]
                      : widget.items.map((item) {
                          return InkWell(
                            onTap: () => _selectValue(item),
                            child: Container(
                              height: itemHeight,
                              alignment: AlignmentDirectional.centerStart,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColor.borderColor.withValues(alpha: 0.3),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Text(item, style: MyTextStyle().textStyleRegular14()),
                            ),
                          );
                        }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
