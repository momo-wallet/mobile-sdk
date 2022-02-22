import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModelAdvanced {
  ///Converts map to the respective items.
  LocationModelAdvanced.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        url = map['url'],
        coordinates = map['location'],
        videoURL = map['link'];

  LocationModelAdvanced.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data,
          reference: snapshot.reference,
        );

  ///Set the document reference of firestore.
  final DocumentReference reference;

  String name;

  final String url;

  final GeoPoint coordinates;

  final String videoURL;

  static LocationModelAdvanced initialData() {
    return LocationModelAdvanced.fromMap(({
      'name': 'Thai',
      'url':
          'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
      'location': null,
      'link': 'https://youtu.be/2IxQgXQl_Ws',
    }));
  }

  static List<LocationModelAdvanced> initialListData() {
    return [
      LocationModelAdvanced.fromMap(({
        'name': 'Thai',
        'url':
            'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
        'location': null,
        'link': 'https://youtu.be/2IxQgXQl_Ws',
      }))
    ];
  }
}

class LocationModelNormal {
  String name;

  final String url;

  final GeoPoint coordinates;

  final String videoURL;

  LocationModelNormal({
    this.name,
    this.url,
    this.coordinates,
    this.videoURL,
  });

  factory LocationModelNormal.fromMap(Map<String, dynamic> data) {
    return LocationModelNormal(
      name: data['name'] ?? '',
      url: data['url'] ?? '',
      coordinates: data['location'] ?? null,
      videoURL: data['link'] ?? '',
    );
  }

  factory LocationModelNormal.initialData() {
    return LocationModelNormal(
      coordinates: null,
      name: 'Thai',
      videoURL: 'https://youtu.be/2IxQgXQl_Ws',
      url:
          'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
    );
  }
}
