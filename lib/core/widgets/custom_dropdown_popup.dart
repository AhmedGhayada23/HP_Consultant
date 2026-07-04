import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/l10n/app_localizations.dart';

/// CustomDropdownPopup - Dropdown يفتح كـ Bottom Sheet في نصف الشاشة
class CustomDropdownPopup extends StatefulWidget {
  final String hint;
  final List<String> items;
  final ValueChanged<String>? onChanged;
  final Color color;
  final String? selectedValue;

  const CustomDropdownPopup({
    super.key,
    required this.hint,
    required this.items,
    this.onChanged,
    this.color = AppColor.gray1,
    this.selectedValue,
  });

  @override
  State<CustomDropdownPopup> createState() => _CustomDropdownPopupState();
}

class _CustomDropdownPopupState extends State<CustomDropdownPopup> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue ?? '';
  }

  void _showPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return PopupMenu(
          items: widget.items,
          onItemSelected: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged?.call(value);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPopup,
      child: Container(
        height: 58.h,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.borderColor.withOpacity(0.4), width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedValue.isNotEmpty ? _selectedValue : widget.hint,
                style: MyTextStyle().textStyleMedium15().copyWith(
                  color: _selectedValue.isNotEmpty ? Colors.black87 : AppColor.hintTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.keyboard_arrow_down_rounded, size: 24.r, color: AppColor.hintTextColor),
          ],
        ),
      ),
    );
  }
}

/// Popup Menu Widget - Bottom Sheet Version
class PopupMenu extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemSelected;

  const PopupMenu({super.key, required this.items, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final popupHeight = screenSize.height * 0.5; // نصف الشاشة

    return Container(
      height: popupHeight + bottomPadding,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // العنوان مع زر الإغلاق
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.selectCountry,
                  style: MyTextStyle().textStyleSemiBold20().copyWith(color: Colors.black),
                ),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.r, color: Colors.black54),
                ),
              ],
            ),
          ),
          DashedLine(dashCount: 20, color: AppColor.gray4),
          // ListView للعناصر
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  DashedLine(dashCount: 30, color: AppColor.gray5),
              itemBuilder: (context, index) {
                final item = items[index];
                final isLast = index == items.length - 1;

                return InkWell(
                  onTap: () => onItemSelected(item),
                  splashColor: AppColor.k1primeryColor.withOpacity(0.1),
                  highlightColor: AppColor.k1primeryColor.withOpacity(0.05),
                  child: Container(
                    height: 52.h,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      border: !isLast
                          ? Border(
                              bottom: BorderSide(
                                color: AppColor.borderColor.withOpacity(0.15),
                                width: 0.5,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item,
                          textDirection: TextDirection.rtl,
                          style: MyTextStyle().textStyleRegular14().copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          size: 20.r,
                          color: AppColor.k1primeryColor.withOpacity(0.5),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColor.borderColor.withOpacity(0.15), width: 0.5),
              ),
              color: AppColor.backgroundColor.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${items.length} ${AppLocalizations.of(context)!.available_countries}',
                  style: MyTextStyle().textStyleRegular11().copyWith(color: AppColor.hintTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
