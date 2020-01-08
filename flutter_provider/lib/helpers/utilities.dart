import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_provider/model/location.dart';
import 'package:rxdart/rxdart.dart';

//final firestoreWondersInstance = Firestore.instance;
final locationStreamInstance = LocationStream();

const wonderCollection = 'wonders';
const fifthWonderDoc = 'fifth';

class LocationStream {
  ///All the backend streams related to Locations.
  LocationStream();

//  Stream<DocumentSnapshot> userDataStream(
//      {String documentId = fifthWonderDoc}) {
//    return firestoreWondersInstance
//        .collection(wonderCollection)
//        .document(documentId)
//        .snapshots();
//  }

  ///For documents.....
  Stream<LocationModelAdvanced> locationInfo() {
    LocationModelAdvanced _listModel = LocationModelAdvanced.initialData();
    StreamController<LocationModelAdvanced> a = BehaviorSubject<LocationModelAdvanced>();
    a.sink.add(_listModel);
    return a.stream;
  }

  Stream<List<LocationModelAdvanced>> allLocations(
      {String collectionId = wonderCollection}) {
//    final _collRef =
//        firestoreWondersInstance.collection(collectionId).snapshots();

//    final _listModel = _collRef.map((list) => list.documents
//        .map((doc) => LocationModelAdvanced.fromSnapshot(doc))
//        .toList());

    List<LocationModelAdvanced> _listModel = LocationModelAdvanced.initialListData();
    StreamController<List<LocationModelAdvanced>> a = BehaviorSubject<List<LocationModelAdvanced>>();
    a.sink.add(_listModel);

    return a.stream;
  }

  ///For documents.....
  Stream<LocationModelNormal> specificLocation(String docId) {
//    final _listModel = userDataStream(
//      documentId: docId,
//    ).map((list) => LocationModelNormal.fromMap(list.data));
    LocationModelNormal _listModel = LocationModelNormal.initialData();
    StreamController<LocationModelNormal> a = BehaviorSubject<LocationModelNormal>();
    a.sink.add(_listModel);


    return a.stream;
  }
}

///Sets the user...
class CurrentUser {
  static String docId = '';
  void dummy() {}
}
