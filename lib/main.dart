import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'src/data/circle_repository.dart';
import 'src/data/firestore_circle_repository.dart';
import 'src/data/local_circle_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final CircleRepository repository;
  String? dataStatusMessage;

  try {
    await Firebase.initializeApp();
    repository = FirestoreCircleRepository();
  } on Exception {
    repository = LocalCircleRepository.seeded();
    dataStatusMessage =
        'Firebase is not configured in this project yet, so you are seeing local demo circles. '
        'Once FlutterFire is configured, circles and posts will load from Cloud Firestore.';
  }

  runApp(
    SkillCircleApp(
      repository: repository,
      dataStatusMessage: dataStatusMessage,
    ),
  );
}
