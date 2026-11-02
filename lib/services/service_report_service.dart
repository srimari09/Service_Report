import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:karamtechnology_services/model/company_model.dart';
import 'package:karamtechnology_services/model/home_model.dart';
import 'package:karamtechnology_services/model/worktable_model.dart';

class ServiceReportService {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  //get the all service report Id from the particular companyId and pass it to Stream query below:
  CollectionReference<Map<String, dynamic>> getServiceReportCollection(
    String companyId,
  ) {
    return _firestoreInstance
        .collection('companies')
        .doc(companyId)
        .collection('ourServiceReport');
  }

  //Each complete service report FROM THE PARTICULAR COMPANY
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllServiceReportList(
    String companyId,
  ) {
    return getServiceReportCollection(companyId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<String> addCompanyDetails(CompanyModel companyDetails) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      debugPrint('AUTH UID: ${user?.uid}');
      debugPrint('MODEL OWNER UID: ${companyDetails.ownerUId}');

      final data = companyDetails.toJson();

      debugPrint('COMPANY DATA: $data');
      debugPrint('JSON OWNER UID: ${data['ownerUID']}');

      if (user == null) {
        throw Exception('User is not logged in');
      }

      if (data['ownerUID'] != user.uid) {
        throw Exception(
          'Owner UID mismatch: ${data['ownerUID']} != ${user.uid}',
        );
      }

      final companyDocRef = await _firestoreInstance
          .collection('companies')
          .add(data);

      debugPrint('Company ID: ${companyDocRef.id}');

      return companyDocRef.id;
    } catch (e, stackTrace) {
      debugPrint('Add Company Error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }


  Future<CompanyModel?> getCompanyDetails(String companyId)
  async{
    final companySnapData = await _firestoreInstance.collection('companies').doc(companyId).get();
    if(!companySnapData.exists || companySnapData.data() == null)
      {
        return null;
      }
    return CompanyModel.fromJson(companySnapData.data()!);
  }

  // ============================================================
  //  UPDATE THE COMPANY DETAILS
  // ============================================================
  Future<String> updateCompanyDetails(
    String companyRefId,
    CompanyModel companyDetails,
  ) async {
    final data = companyDetails.toJson();
    print('--------$data-----------');
    final companyDocRef = await _firestoreInstance
        .collection('companies')
        .doc(companyRefId);
    await companyDocRef.update(data);
    print(
      '__-----__Added company details Ref Id Printed__------__ ${companyRefId}',
    );
    final savedDoc = await companyDocRef.get();

    if (savedDoc.exists) {
      print('Updated Company Details: ${savedDoc.data()}');
    } else {
      print('Company document not found');
    }
    return companyDocRef.id;
  }

  //get company details
  Future<CompanyModel?> getCompanyById(String companyId) async {
    final doc = await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return CompanyModel.fromJson({...doc.data()!, 'companyId': doc.id});
  }

  //file_Name_increment_function
  Future<String> fileNameStore(String companyId, String saveName) async {
    final counterRef = _firestoreInstance
        .collection('companies')
        .doc(companyId)
        .collection('counters')
        .doc('serviceReportCounter');

    final number = await _firestoreInstance.runTransaction(((
      transaction,
    ) async {
      final snapshot = await transaction.get(counterRef);

      final data = snapshot.data();

      final Object? storedValue = data?['lastNumber'];

      final int lastNumber = storedValue is num ? storedValue.toInt() : 0;

      final int nextNumber = lastNumber + 1;

      transaction.set(counterRef, {'lastNumber': nextNumber});
      return nextNumber;
    }));
    return '${saveName.trim()}_${number.toString().padLeft(3, '0')}';
  }

  // ============================================================
  // MAIN REPORT and WorkTable Items created at the same time in BD
  // CREATE MAIN REPORT + ALL WORK ITEMS ATOMICALLY
  // ============================================================

  Future<String> addMainReportWithAllWorkItems(
    String companyId,
    HomeModel report,
    List<WorkTableModel> workItems,
  ) async{
    if (companyId.trim().isEmpty) {
      print('companyId is Empty');
    }

    if (workItems.length + 1 > 500) {
      throw Exception('Too many work items for one batch');
    }

    final reportCollection = getServiceReportCollection(companyId);

    final reportDocRef = reportCollection.doc();

    //create one batch for all writes
    final batch = _firestoreInstance.batch();

    batch.set(reportDocRef, {
      ...report.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    //workItem collection
    final workRef = reportDocRef.collection('workTableItems');
    for (int index =0; index<workItems.length;index++) {

      final item =workItems[index];

      final workData = Map<String, dynamic>.from(item.toJson() );
      //fireStore generates actual doc ID
      workData.remove('id');
      batch.set(workRef.doc(), {...workData, 'sortOrder': index});
    }

    //commit all writes
    await batch.commit();

    debugPrint('REPORT SAVED: $reportDocRef');
    debugPrint('WORKITEMS SAVED: ${workItems.length}, ${workRef.id}');
    return reportDocRef.id;
  }

  // CREATE THE MAIN REPORT separately
  Future<String> addReport(String companyId, HomeModel report) async {
    final docRef = await getServiceReportCollection(companyId)
        .add(report.toJson());

    print('__-----__Added Main Document Id Printed__------__ ${docRef.id}');
    return docRef.id;
  }

  //READ THE EXISTING DATA
  Future<HomeModel?> getMainReport(String companyId, String reportId) async {
    final getSnapData = await getServiceReportCollection(companyId)
        .doc(reportId)
        .get();

    if (!getSnapData.exists || getSnapData.data() == null) {
      return null;
    }

    return HomeModel.fromJson(getSnapData.data()!);
  }

  //UPDATE
  Future<void> updatedMainReport(
    String companyId,
    String reportId,
    HomeModel report,
  ) async {
    await getServiceReportCollection(companyId)
        .doc(reportId)
        .update(report.toJson());

    print('__-----__Updated Main Document Id Printed__------__ ${reportId}');
  }

  //DELETE
  Future<void> deleteMainReport(String companyId, String reportId) async {
    await getServiceReportCollection(companyId).doc(reportId).delete();

    print('__-----__Deleted Main Document Id Printed__------__ ${reportId}');
  }

  /*_______________________________________________________________________________________________________*/

  DocumentReference<Map<String, dynamic>> getWorkItemsSubCollection(
    String companyId,
    String reportId,
  ) {
    return _firestoreInstance
        .collection('companies')
        .doc(companyId)
        .collection('ourServiceReport')
        .doc(reportId);
  }

  //CREATE  WORKITEMS in the table
  Future<String> addWorkTable(
    String companyId,
    String reportId,
    WorkTableModel workItem,
      int sortOrderIndex
  ) async
  {

    final workData = Map<String,dynamic>.from(workItem.toJson(),);
    workData.remove('id');
    workData['sortOrder'] = sortOrderIndex;


    final workDocRef = await getWorkItemsSubCollection(
      companyId,
      reportId,
    ).collection('workTableItems').add(workItem.toJson());

    print(
      '__-----__Added worktable Document Id Printed__------__ ${workDocRef.id}',
    );
    return workDocRef.id;
  }

  //READ THE WORKTABLE DATA
  Future<List<WorkTableModel>?> getWorkTableData(
    String companyId,
    String reportId,
  ) async {
    final getSnapshot = await getWorkItemsSubCollection(
      companyId,
      reportId,
    ).collection('workTableItems').orderBy('sortOrder', descending: false).get();

    if (getSnapshot.docs.toList().isEmpty) {
      return null;
    }

    return getSnapshot.docs
        .map((docs) => WorkTableModel.fromJson({...docs.data(), 'id': docs.id}))
        .toList();
  }

  //update the worktable
  Future<void> updateWorkTable(
    String companyId,
    String reportId,
    String workDocRefId,
    WorkTableModel workItem,
      int sortOrderIndex
  ) async {

    final workData = Map<String,dynamic>.from(workItem.toJson());
    workData.remove('id');
    workData['sortOrder'] = sortOrderIndex;


    await getWorkItemsSubCollection(
      companyId,
      reportId,
    ).collection('workTableItems').doc(workDocRefId).update(workItem.toJson());
    print(
      '____Updated Document main report Id____ $reportId, -------workItem id----$workDocRefId-------------- ',
    );
  }

  //delete the workTable

  Future<void> deleteWorkTable(
    String companyId,
    String reportId,
    String workDocRefId,
  ) async {
    await getWorkItemsSubCollection(
      companyId,
      reportId,
    ).collection('workTableItems').doc(workDocRefId).delete();
    print(
      '_______ Deleted Document Id Printed____ $reportId,-------------$workDocRefId-------------- ',
    );
  }
}
