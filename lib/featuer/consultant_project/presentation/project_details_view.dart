import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/consultant_project_cubit/consultant_project_cubit.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_cubit.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_state.dart';
import 'package:hb/core/cubit/milestone_cubit/milestone_cubit.dart';
import 'package:hb/core/data/models/active_project_model.dart';
import 'package:hb/core/data/models/details_project_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/core/widgets/custom_popup_widget.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/featuer/consultant_project/presentation/update_consultant_project_view.dart';
import 'package:hb/featuer/file_web_view/file_web_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ProjectDetailsView extends StatefulWidget {
  final ActiveProjectModel activeProjectModel;
  const ProjectDetailsView({super.key, required this.activeProjectModel});

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsProjectCubit>().fetchDetailsProject(
      widget.activeProjectModel.id!,
    );
    context.read<ConsultantProjectCubit>().fetchConsultantProject();
    context.read<MilestoneCubit>().getMilestone(widget.activeProjectModel.id!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsProjectCubit, DetailsProjectState>(
      builder: (context, state) {
        final bool loading = state.loading ?? false;

        final DetailsProjectModel data = loading
            ? DetailsProjectModel(
                project: ProjectDetails.fake(),
                assignedConsultants: List.generate(
                  1,
                  (_) => AssignedConsultantModel(
                    id: 0,
                    name: "John Doe",
                    role: "Developer",
                  ),
                ),
                projectMilestones: List.generate(
                  2,
                  (_) => ProjectMilestones.fake(),
                ),
                projectFiles: List.generate(1, (_) => ProjectFiles.fake()),
              )
            : (state.data ??
                  DetailsProjectModel(
                    project: null,
                    assignedConsultants: [],
                    projectMilestones: [],
                    projectFiles: [],
                  ));

        return Scaffold(
          appBar: _buildAppBar(context, data, widget.activeProjectModel.id!),
          body: Skeletonizer(
            enabled: loading,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Column(
                children: [
                  _ProjectInfoCard(project: data.project),

                  SizedBox(height: 20.h),

                  _ConsultantsSection(
                    consultants: data.assignedConsultants ?? [],
                    projectModel: data,
                  ),

                  SizedBox(height: 20.h),

                  _MilestonesSection(
                    projectMilestones: data.projectMilestones ?? [],
                  ),

                  SizedBox(height: 20.h),

                  _FilesSection(projectFile: data.projectFiles ?? []),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    DetailsProjectModel project,
    int id,
  ) {
    return AppBar(
      backgroundColor: AppColor.blackColor,
      iconTheme: IconThemeData(color: AppColor.whiteColor),
      title: Text(
        AppLocalizations.of(context)!.project_details,
        style: MyTextStyle().textStyleSemiBold16().copyWith(
          color: AppColor.whiteColor,
        ),
      ),
      actions: [
        CustomPopupWidget(
          items: [
            PopupMenuItemModel(
              text: AppLocalizations.of(context)!.add_new_consultant,
              onTap: () {
                showAddConsultantDialog(context, project);
              },
            ),
            PopupMenuItemModel(
              text: AppLocalizations.of(context)!.edit_project,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateConsultantProjectView(
                      projectId: project.project!.id,
                    ),
                  ),
                );
              },
            ),
            PopupMenuItemModel(
              text: AppLocalizations.of(context)!.upload_a_new_file,
              onTap: () {
                showUploadFileDialog(context, project.project!.id);
              },
            ),
            PopupMenuItemModel(
              text: AppLocalizations.of(context)!.close_project,
              color: AppColor.countNotificationBgColor,
              onTap: () {
                context.read<DetailsProjectCubit>().closeProject(context, id);
              },
            ),
          ],
          child: Container(
            height: 28.h,
            width: 28.w,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Icon(
                Icons.more_vert,
                color: AppColor.blackColor,
                size: 24.r,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
      ],
    );
  }
}

//========================= 1. Project Info =========================//
class _ProjectInfoCard extends StatelessWidget {
  final ProjectDetails? project; // ✅ من الـ API مش activeProjectModel

  const _ProjectInfoCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(AppLocalizations.of(context)!.title, project?.title ?? ''),
          _infoRow(
            AppLocalizations.of(context)!.deadline,
            project?.deadline ?? '',
          ),
          _infoRow(
            AppLocalizations.of(context)!.status,
            project?.statusLabel ?? '',
          ), // ✅ statusLabel أوضح للمستخدم
          _infoRow(AppLocalizations.of(context)!.budget, project?.budget ?? ''),
          SizedBox(height: 20.h),
          Text(
            AppLocalizations.of(context)!.description,
            style: MyTextStyle().textStyleRegular14(),
          ),
          SizedBox(height: 8.h),
          Text(
            project?.description ?? '',
            style: MyTextStyle().textStyleMedium16(),
          ), // ✅ إصلاح الخطأ الإملائي
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MyTextStyle().textStyleRegular14()),
          Text(value, style: MyTextStyle().textStyleMedium16()),
        ],
      ),
    );
  }
}

//========================= 2. Consultants Section =========================//
class _ConsultantsSection extends StatelessWidget {
  final List<AssignedConsultantModel> consultants; // ✅ من الـ API بدل hardcoded
  final DetailsProjectModel projectModel;
  const _ConsultantsSection({
    required this.consultants,
    required this.projectModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.consultants_assigned,
            style: MyTextStyle().textStyleSemiBold16(),
          ),
          SizedBox(height: 16.h),

          // ✅ EmptyState لو فش consultants
          if (consultants.isEmpty)
            EmptyStateWidget(
              title: AppLocalizations.of(context)!.consultants_empty_title,
              subtitle: AppLocalizations.of(context)!.consultants_empty_title,
              icon: Icons.person_outline,
            )
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: consultants.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final c = consultants[index];
                return _ConsultantCard(name: c.name, role: c.role);
              },
            ),

          SizedBox(height: 20.h),
          CustomButton(
            onTap: () => showAddConsultantDialog(context, projectModel),
            color: AppColor.k1primeryColor,
            text: AppLocalizations.of(context)!.add_consultant,
          ),
        ],
      ),
    );
  }
}

class _ConsultantCard extends StatelessWidget {
  final String name;
  final String role;

  const _ConsultantCard({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.gray5,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: MyTextStyle().textStyleSemiBold14()),
              Text(
                'Active',
                style: MyTextStyle().textStyleRegular14().copyWith(
                  color: AppColor.k1primeryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(role, style: MyTextStyle().textStyleRegular14()),
        ],
      ),
    );
  }
}

//========================= 3. Milestones Section =========================//
class _MilestonesSection extends StatelessWidget {
  final List<ProjectMilestones> projectMilestones;
  const _MilestonesSection({required this.projectMilestones});

  @override
  Widget build(BuildContext context) {
    if (projectMilestones.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.project_milestones,
            style: MyTextStyle().textStyleSemiBold16(),
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: projectMilestones.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) => _MilestoneCard(
              title: projectMilestones[index].title,
              assignedTo: projectMilestones[index].assignedTo,
              deadline: projectMilestones[index].deadline,
              status:
                  projectMilestones[index].statusLabel, // ✅ statusLabel أوضح
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final String title, assignedTo, deadline, status;
  const _MilestoneCard({
    required this.title,
    required this.assignedTo,
    required this.deadline,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.gray5,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: MyTextStyle().textStyleSemiBold14()),
          SizedBox(height: 20.h),
          _row('${AppLocalizations.of(context)!.assigned_to}:', assignedTo),
          _row('${AppLocalizations.of(context)!.deadline}:', deadline),
          _row(
            '${AppLocalizations.of(context)!.status}:',
            status,
            color: AppColor.k1primeryColor,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: MyTextStyle().textStyleRegular14()),
          Text(
            value,
            style: MyTextStyle().textStyleRegular14().copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

//========================= 4. Files Section =========================//
class _FilesSection extends StatelessWidget {
  final List<ProjectFiles> projectFile;
  const _FilesSection({required this.projectFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.project_files_deliverables,
            style: MyTextStyle().textStyleSemiBold14(),
          ),
          SizedBox(height: 20.h),

          // ✅ EmptyState لو فش files
          if (projectFile.isEmpty)
            EmptyStateWidget(
              title: AppLocalizations.of(context)!.no_files,
              subtitle: AppLocalizations.of(context)!.please_upload_files,
              icon: Icons.folder_open_outlined,
            )
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: projectFile.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) => _FileCard(
                fileName: projectFile[index].name,
                uploadedBy: projectFile[index].authority,
                onView: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FileWebViewPage(
                        fileName: projectFile[index].name,
                        fileUrl: projectFile[index].file,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  final String fileName, uploadedBy;
  final VoidCallback onView;

  const _FileCard({
    required this.fileName,
    required this.uploadedBy,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.gray5,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 39.w,
              height: 43.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColor.k1primeryColor.withValues(alpha: 0.15),
              ),
              child: Center(
                child: VectorGraphic(loader: AssetBytesLoader(AppSvg.fileSvg)),
              ),
            ),
            title: Text(fileName, style: MyTextStyle().textStyleRegular14()),
            subtitle: Text(
              uploadedBy,
              style: MyTextStyle().textStyleRegular11(),
            ),
          ),
          SizedBox(height: 16.h),
          CustomButtonBorder(
            onTap: onView,
            borderColor: AppColor.k1primeryColor,
            text: AppLocalizations.of(context)!.view_file,
          ),
        ],
      ),
    );
  }
}
