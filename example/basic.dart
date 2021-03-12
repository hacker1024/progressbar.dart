// Copyright (c) 2014, <Jaron Tai>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library progress_bar.example;

import 'dart:async';

import 'package:progress_bar/progress_bar.dart';

void main() {
  final bar = ProgressBar(' [:bar] :percent :etas ', total: 10);
  Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
    bar.tick();
    if (bar.complete) {
      timer.cancel();
    }
  });
}
