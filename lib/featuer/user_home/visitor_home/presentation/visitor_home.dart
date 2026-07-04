import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/job_project_cubit/job_project_cubit.dart';
import 'package:hb/core/cubit/job_project_cubit/job_project_state.dart';
import 'package:hb/core/data/models/job_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_appbar.dart';
import 'package:hb/core/widgets/custom_drawer_visitor.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:hb/core/widgets/info_row.dart';
import 'package:hb/core/widgets/search_box_widget.dart';
import 'package:hb/featuer/jobs_projects/presentation/details_job_project_view.dart';
import 'package:hb/featuer/jobs_projects/widgets/filtter_job_project_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VisitorHome extends StatefulWidget {
  const VisitorHome({super.key});

  @override
  State<VisitorHome> createState() => _VisitorHomeState();
}

class _VisitorHomeState extends State<VisitorHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFiltterVisible = false;

  @override
  void initState() {
    super.initState();
    getJobProject();
  }

  void getJobProject() {
    context.read<JobProjectCubit>().fetchJobProject();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawerVisitor(),
      appBar: CustomAppBar(
        title: 'Jobs & Projects',
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer(); // ✅ فتح drawer باستخدام المفتاح
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            children: [
              // box saesh
              SearchBoxWidget(
                hintText: loc.search_by_title,
                fillColor: AppColor.whiteColor,
                isFilterOpen: isFiltterVisible,
                onTap: () {
                  setState(() {
                    isFiltterVisible = !isFiltterVisible;
                  });
                },
              ),
                AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  );
                },
                child: isFiltterVisible
                    ? FiltterJobProjectWidget(key: ValueKey("filter_open"))
                    : SizedBox(key: ValueKey("filter_closed")),
              ),
              DashedLine(),
              SizedBox(height: 20.h),
              BlocBuilder<JobProjectCubit, JobProjectState>(
                builder: (context, state) {
                  final data = state.data ?? List.generate(3, (index) => JobProjectModel());
                  return Skeletonizer(
                    enabled: state.loading ?? false,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsJobProjectView(jobProjectModel: data[index],)),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadiusDirectional.circular(16.r),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].title ?? '',
                                  style: MyTextStyle().textStyleSemiBold16(),
                                ),
                                DashedLine(),
                                SizedBox(height: 20.h),
                                InfoRow(label: 'Company: ', value: data[index].company   ?? ''),
                                SizedBox(height: 20.h),
                                InfoRow(label: '${loc.deadline}:', value: data[index].deadline ?? ''),
                                SizedBox(height: 20.h),
                                InfoRow(label: '${loc.status}: ', value: data[index].status ?? ''),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemCount: data.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
