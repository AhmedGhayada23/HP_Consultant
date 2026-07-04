import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/chat_cubit/chat_cubit.dart';
import 'package:hb/core/cubit/chat_cubit/chat_state.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_accounting_clint.dart';
import 'package:hb/core/widgets/custom_drawer_company.dart';
import 'package:hb/core/widgets/custom_drawer_consultant.dart';
import 'package:hb/core/widgets/custom_drawer_student.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/chat_support/widgets/card_chat_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatSupportView extends StatefulWidget {
  const ChatSupportView({super.key});

  @override
  State<ChatSupportView> createState() => _ChatSupportViewState();
}

class _ChatSupportViewState extends State<ChatSupportView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  void fetchChats() async {
    context.read<ChatCubit>().fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<UserCubit>();

    // تحديد الـ Drawer المناسب حسب نوع المستخدم
    Widget? selectedDrawer;

    switch (userCubit.userType) {
      case UserType.CompanyUser:
        selectedDrawer = const CustomDrawerCompany();
        break;
      case UserType.ConsultantUser:
        selectedDrawer = const CustomDrawerConsultant();
        break;
      case UserType.StudentUser:
        selectedDrawer = const CustomDrawerStudent();
        break;
      case UserType.AccountingClintUser:
        selectedDrawer = const CustomDrawerAccountingClint();
        break;
      case UserType.VisitorUser:
      default:
        selectedDrawer = const Drawer();
    }
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: selectedDrawer,
      appBar: CustomAppBar(
        title: loc.chat_support,
        onMenuTap: () {
          _scaffoldKey.currentState
              ?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),

        child: Column(
          children: [
            Container(
              height: 55.h,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: MyTextFieldWidget(
                fillColor: AppColor.whiteColor,
                hintText: loc.search_by_title,
                showPrefixIcon: true,
                assetsPrefixIcon: AppSvg.searchSvg,
                onChanged: (value) =>
                    context.read<ChatCubit>().fetchChats(search: value),
              ),
            ),
            SizedBox(height: 20.h),
            // items
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    final bool isLoading = state.isLoading;
                    final data = state.chatData ?? [];

                    if (!isLoading && data.isEmpty) {
                      return EmptyStateWidget(
                        title: loc.no_data_available,
                        icon: Icons.chat_bubble_outline,
                      );
                    }

                    final itemCount = isLoading ? 3 : data.length;
                    return Skeletonizer(
                      enabled: isLoading,
                      child: ListView.separated(
                        itemBuilder: (context, index) => isLoading
                            ? const CardChatWidget()
                            : CardChatWidget(chatModel: data[index]),
                        separatorBuilder: (context, index) =>
                            Divider(color: AppColor.borderColor),
                        itemCount: itemCount,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
