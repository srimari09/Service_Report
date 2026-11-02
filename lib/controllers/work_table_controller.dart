import 'package:get/get.dart';
import 'package:karamtechnology_services/services/service_report_service.dart';

import '../model/worktable_model.dart';

class WorkTableController extends GetxController {
  RxList<WorkTableModel> workTableData = <WorkTableModel>[].obs;

  final ServiceReportService _serviceReportService = ServiceReportService();
  String? currentReportId;


  void addWorkData() {
    workTableData.add(
      WorkTableModel(id: '',quantity: '', unit: '', workDescription: ''),
    );
  }

  void deleteWorkData(int index) {
    if (index >= 0 && index <= workTableData.length) {
      workTableData.removeAt(index);
    }
  }

  void updateWorkData({
    required int index,
    String? description,
    String? quantity,
    String? unit,
  }) {
    if (description != null) {
      workTableData[index].workDescription = description;
    }

    if (quantity != null) {
      workTableData[index].quantity = quantity;
    }

    if (unit != null) {
      workTableData[index].unit = unit;
    }
    workTableData.refresh();
  }

  /*--------------------------------------------------------------------*/
  //FIRESTORE CONNECTION TO WORKTABLE
  /*--------------------------------------------------------------------*/

  //SAVE THE DATA
  Future<void> saveWorkItem(String companyId,String reportId,int index) async {
    try {
      if (reportId.isEmpty) {
        print('Report ID is null');
        return;
      }

      for (final workItem in workTableData) {
        //skip the empty row
        if (workItem.workDescription.trim().isEmpty &&
            workItem.unit.trim().isEmpty) {
          continue;
        }
        await addWorkItemIntoFirestore(companyId,reportId,workItem,index);
      }
      print('created');
    } catch (e) {
      print(e);
    }
  }

  //ADD THE DATA INTO THE TABLE

  Future<void> addWorkItemIntoFirestore(String companyId,String reportId, WorkTableModel workItem, int index) async {
    try {
      if (reportId.isEmpty) {
        print('Report ID is null');
        return;
      }
      final workItemId = await _serviceReportService.addWorkTable(
        companyId,
        reportId,
        workItem,
        index,
      );
      print('Work Item Created: $workItemId');
    } catch (e) {
      '-----------------ERROR IN ADDING DATA INTO THE WORKTABLE: $e ______________';
    }
  }

  //READ THE DATA INTO THE TABLE

  Future<List<WorkTableModel>> readWorkItemFromFirestore(String companyId,String reportId) async {
    try {
      if ( reportId.isEmpty) {
        print('Report Id is null');
        return List.empty();
      }

      final workItems = await _serviceReportService.getWorkTableData(
        companyId,
        reportId,
      );
      workTableData.clear();
      if(workItems !=null)
        {
          workTableData.addAll(workItems);
        }
      print('----------------- WORK ITEMS LOADED -----------------');
      print('REPORT ID : $reportId');
      print('TOTAL WORK ITEMS : ${workTableData.length}');

      return workTableData;
    } catch (e) {
      print('-----------------ERROR IN GETTING DATA FROM THE WORKTABLE: $e ______________');
      return List.empty();

    }
  }

  //UPDATE THE DATA INTO THE TABLE

  Future<void> updateWorkItemToFirestore(
      String companyId,
      String reportId,
      String workDocRefId,
      WorkTableModel workItem,
      int index
  )
  async {
    try
    {
      if ( companyId.isEmpty || reportId.isEmpty)
      {
        print('-Report Id is Null-');
        throw Exception('Report ID is null');
      }

      await _serviceReportService.updateWorkTable(
        companyId,
        reportId,
        workDocRefId,
        workItem,
        index
      );

      print(' WORK ITEMS UPDATED SUCCESSFLULLY');
      print('REPORT ID : $reportId');
      print('UPDATED ID : $workDocRefId ');
    }
    catch (e)
    {
      '-ERROR IN UPDATING DATA FROM THE WORKTABLE: $e-';
      rethrow;
    }
  }

  //DELETED THE DATA INTO THE TABLE

  Future<void> deleteWorkItemFromFirestore(String companyId,String reportId,String workItemDocId) async {
    try {
 final index =   workTableData.indexWhere((item) =>item.id == workItemDocId);

 if (reportId.isEmpty || companyId.isEmpty) {
        print('Report Id or Company Id is null');
        return;
      }
      if (index == -1) return;


      await _serviceReportService.deleteWorkTable(
        companyId,
        reportId,
        workItemDocId,
      );

      print('----------------- WORK ITEMS DELETED -----------------');
      print('REPORT ID : $reportId');
      print('DELETED WORK ITEM ID : $workItemDocId ');

      //delete in local UI
      workTableData.removeWhere((item) =>item.id == workItemDocId);
      workTableData.refresh();

    }
    catch (e) {
      '-----------------ERROR IN DELETING DATA FROM THE WORKTABLE: $e ______________';
    }
  }
  //---------------------------------------------------------------//
  //          CLEAR LOCAL WORKTABLE DATA AND CURRENT REPORT ID
  //---------------------------------------------------------------//

  void clearWorkTableData() {
    workTableData.clear();
    print('cleared the local worktable');
  }

  void clearCurrentReportId() {
    currentReportId = null;
    print('--CURRENT REPORT ID CLEARED--');
  }
}
