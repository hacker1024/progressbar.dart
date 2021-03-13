// Copyright (c) 2021 hacker1024. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:progressbar2/progressbar2.dart';

Future<void> main() async {
  const total = 10;

  final progressBar = ProgressBar(
    formatter: (current, total, progress, elapsed) =>
        '$current/$total (${progress * 100}%) [${ProgressBar.formatterBarToken}] ${elapsed.inSeconds}s',
    total: total,
    width: 20,
  );

  progressBar.render();
  for (var i = 0; i < total; ++i) {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    ++progressBar.value;
    progressBar.render();
  }
}
