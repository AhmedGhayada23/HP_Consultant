import 'package:flutter/material.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

class MessageInputBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final bool isSending;

  const MessageInputBarWidget({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        boxShadow: [BoxShadow(blurRadius: 3, color: AppColor.borderColor, offset: Offset(0, -3))],
      ),
      child: Center(
        child: Container(
          height: 55.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppColor.gray5,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: loc.type_message,
                    hintStyle: const TextStyle(color: Colors.grey),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                ),
              ),
              // إرفاق صور/ملفات
              if (onAttach != null)
                GestureDetector(
                  onTap: isSending ? null : onAttach,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.attach_file_rounded,
                      color: AppColor.gray2,
                      size: 24.0,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: isSending ? null : onSend,
                child: CircleAvatar(
                  radius: 21.0,
                  backgroundColor: isSending ? AppColor.gray2 : AppColor.uploadImageColor,
                  child: isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.whiteColor,
                          ),
                        )
                      : const Center(
                          child: VectorGraphic(
                            loader: AssetBytesLoader(AppSvg.sentSvg),
                            colorFilter: ColorFilter.mode(AppColor.whiteColor, BlendMode.srcIn),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
