import 'dart:io';

import 'package:flutter/foundation.dart';

const apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: kIsWeb
    ? 'http://localhost:3000'
    : 'http://10.0.2.2:3000',
);