# progressbar2
A progress bar for Dart console apps.

## Usage
A `ProgressBar` object requires a `formatter` function as well as a `total` value.
Additionally, the `width`, `completeChar`, and `incompleteChar` may be customized.

Basic usage:
```dart
const total = 10;

final progressBar = ProgressBar(
  formatter: (current, total, progress, elapsed) =>
      '[${ProgressBar.formatterBarToken}] ${(progress * 100).floor()}% ${elapsed.inSeconds}s',
  total: total,
);

progressBar.render();
for (var i = 0; i < total; ++i) {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  ++progressBar.value;
  progressBar.render();
}
```

![basic](https://raw.github.com/hacker1024/progressbar.dart/master/example/progress_bar_basic.gif)

### Formatting
The `formatter` function converts the given information into a progress bar
string. Additionally, the `ProgressBar.formatterBarToken` string, when included,
is replaced with a progress bar indicator.

## Incrementing
The value of the progress bar can be set at any time with the `value` setter.
To increment the progress by 1, a simple `++myProgressBar.value` statement will
do the trick.

## Rendering
To render the progress bar to the console, `render()` may be called.
Additionally, `unrender()` can be called to erase the progress bar.

## ETAs?
As there are many ways to calculate an ETA, this package leaves the
implementation up to the developer, providing the elapsed time for this purpose.

Personally, I recommend [`package:moving_average`][moving_average].

[moving_average]: https://pub.dev/packages/moving_average

## Acknowledgements
- Jaron Tai <jaroncn@gmail.com> for the original [`progress_bar` package][progress_bar].

[progress_bar]: https://pub.dev/packages/progress_bar

## Features and bugs
Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/hacker1024/progressbar.dart/issues

## License
```
Copyright (c) 2021 hacker1024.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the hacker1024 nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```