// lib/featuer/reports_invoices/data/datasources/report_invoice_remote_datasource.dart

import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import '../models/report_invoice_model.dart';

abstract class ReportInvoiceRemoteDataSource {
  Future<List<ReportInvoiceModel>> getReports({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  });
}

class ReportInvoiceRemoteDataSourceImpl extends ReportInvoiceRemoteDataSource {
  static final ReportInvoiceRemoteDataSourceImpl _instance =
      ReportInvoiceRemoteDataSourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  ReportInvoiceRemoteDataSourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  factory ReportInvoiceRemoteDataSourceImpl() => _instance;

  @override
  Future<List<ReportInvoiceModel>> getReports({
    String? search,
    String? invoiceType,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (search != null) 'search': search,
      if (invoiceType != null) 'invoice_type': invoiceType,
      if (status != null) 'status': status,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
    };

    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.reportsInvoicesUrl,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Invoices data is null');
        }

        // الـ JSON: { "data": [ {...}, {...} ] }
        final List invoicesJson = data['data'];

        return invoicesJson.map((invoice) => ReportInvoiceModel.fromJson(invoice)).toList();
      } else {
        throw Exception('Failed to load Invoices: Status ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      log('DioException: ${e.response?.data}');
      log('DioException: ${e.response?.statusCode}');
      throw Exception('Network error while fetching Invoices: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error while fetching Invoices: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
