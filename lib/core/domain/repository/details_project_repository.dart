import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/details_project_data_source.dart';
import 'package:hb/core/data/models/details_project_model.dart';

abstract class DetailsProjectRepository {
  Future<DetailsProjectModel> getDetailsProject(int id);
  Future<void> closeProject(BuildContext context, int id);
}

class DetailsProjectRepositoryImpl extends DetailsProjectRepository {
  final DetailsProjectDataSource dataSource;
  DetailsProjectRepositoryImpl(this.dataSource);
  @override
  Future<DetailsProjectModel> getDetailsProject(int id) {
    return dataSource.getDetailsProject(id);
  }

  @override
  Future<void> closeProject(context, int id) {
    return dataSource.closeProject(context, id);
  }
}
