import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/box_cubit/box_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class ExpandableBoxWidget extends StatelessWidget {
  final String title;
  final Widget content;
  final Color color;

  const ExpandableBoxWidget({
    super.key,
    required this.title,
    required this.content,
    this.color = AppColor.gray5,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoxCubit(),
      child: BlocBuilder<BoxCubit, bool>(
        builder: (context, isOpen) {
          return GestureDetector(
            onTap: () => context.read<BoxCubit>().toggle(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,

              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: MyTextStyle().textStyleSemiBold16(),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    ],
                  ),

                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(padding: const EdgeInsets.only(top: 12), child: content),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
