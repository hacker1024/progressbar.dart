// Copyright (c) 2021 hacker1024. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

/// A function to format a progress bar string.
///
/// [current] is the current progress value.
/// [total] is the total progress value.
/// [progress] is the ratio of current : total in the form of a double between 0 and 1.
/// [elapsed] is the elapsed time.
typedef ProgressBarFormatter = String Function(
  int current,
  int total,
  double progress,
  Duration elapsed,
);

class ProgressBar {
  static const formatterBarToken = ':bar';

  /// A function to format the progress bar text.
  ///
  /// See [ProgressBarFormatter] for the available values.
  /// Additionally, the [formatterBarToken] should be included to be replaced
  /// with the progress bar indicator.
  ProgressBarFormatter formatter;

  /// The total value.
  int _total;

  /// The total value.
  int get total => _total;

  set total(int newTotalTickCount) {
    assert(newTotalTickCount > 1);
    _total = newTotalTickCount;
  }

  /// The current value.
  int get value => _value;

  /// The width of the rendered progress bar.
  ///
  /// If this is `null`, the maximum available width is used.
  ///
  /// If there's not enough room to use the set width, the maximum available
  /// width will be used instead.
  int? width;

  /// A backing field for [completeChar].
  String _completeChar;

  /// The character to use for the filled portion of the progress bar.
  String get completeChar => _completeChar;

  set completeChar(String newCompleteChar) {
    assert(newCompleteChar.length == 1);
    _completeChar = newCompleteChar;
  }

  /// A backing field for [incompleteChar].
  String _incompleteChar;

  /// The character to use for the empty portion of the progress bar.
  String get incompleteChar => _incompleteChar;

  set incompleteChar(String newIncompleteChar) {
    assert(newIncompleteChar.length == 1);
    _incompleteChar = newIncompleteChar;
  }

  /// Create a [ProgressBar] instance.
  ///
  /// See [ProgressBar.formatter] for formatting documentation.
  /// Also see [ProgressBar.total], [ProgressBar.width],
  /// [ProgressBar.completeChar], and [ProgressBar.incompleteChar].
  ProgressBar({
    required this.formatter,
    required int total,
    this.width,
    String completeChar = '=',
    String incompleteChar = '-',
  })  : assert(total > 1),
        _total = total,
        assert(completeChar.length == 1),
        _completeChar = completeChar,
        assert(incompleteChar.length == 1),
        _incompleteChar = incompleteChar;

  /// The current value.
  var _value = 0;

  /// The time of the first tick.
  DateTime? _startTime;

  /// The last rendered output.
  String _lastOutput = '';

  /// Set the tick count.
  set value(int newTickCount) {
    // If the new value is the same as the current one, do nothing.
    if (newTickCount == _value) return;

    // If the old tick count is zero, record the start time.
    if (_value == 0) _startTime = DateTime.now();

    // Use the new value.
    _value = newTickCount;
  }

  /// Render the progress bar.
  ///
  /// If [force] is `true`, the progress bar will be redrawn even if the output
  /// hasn't changed since the last render.
  void render({bool force = false}) {
    // Abort if stdout isn't attached to a terminal.
    assert(stdout.hasTerminal, 'Cannot render - no terminal is available!');

    // Calculate the progress percentage.
    final progress = min(max(_value / _total, 0.0), 1.0);

    // Calculate the elapsed time.
    final elapsed = _startTime == null
        ? Duration.zero
        : DateTime.now().difference(_startTime!);

    // Format the output.
    var output = formatter(
      _value,
      _total,
      progress,
      elapsed,
    );

    // Compute the available space for the bar.
    final textLength = output.replaceAll(':bar', '').length;
    final availableSpace = max(0, stdout.terminalColumns - textLength);

    // Use the set width for the rendered bar width, unless there isn't enough
    // space.
    final computedWidth =
        width == null ? availableSpace : min(width!, availableSpace);

    // If the output string length is equal to the text length, there's no :bar
    // token.
    if (output.length != textLength) {
      // Render the progress bar and add it to the output string.
      final barProgressLength = (computedWidth * progress).round();
      final completeBarProgress = _completeChar * barProgressLength;
      final incompleteBarProgress =
          _incompleteChar * (computedWidth - barProgressLength);
      output = output.replaceAll(
        formatterBarToken,
        completeBarProgress + incompleteBarProgress,
      );
    }

    // Output the progress bar.
    _output(output, force: force);
  }

  /// Remove a rendered progress bar from the console.
  void unrender() => _output('', force: true);

  /// Writes the [output] to [stdout] if the output is different to the last
  /// output (or if [force] is `true`).
  void _output(String output, {bool force = false}) {
    // Abort if stdout isn't attached to a terminal.
    assert(stdout.hasTerminal, 'Cannot render - no terminal is available!');

    if (force || output != _lastOutput) {
      // Clear the current line.
      // https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#deletion
      stdout.write('\u001b[2K');

      // Move the cursor back to the beginning.
      stdout.writeCharCode(13); // Carriage return

      // Write the output.
      stdout.write(output);

      // Update _lastOutput.
      _lastOutput = output;
    }
  }
}
