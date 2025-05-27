# Input Method Select

A minimal macOS CLI utility to **switch keyboard input methods** programmatically, with optional **window focus refresh** for input methods that use candidate boxes.

## Install

```sh
brew tap postrockreverb/tap
brew install input-method-select
```

## Usage

```sh
input-method-select com.apple.keylayout.ABC
input-method-select com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese
```

## Building

```sh
make
```

This will create:

- dist-arm64/input-method-select (for Apple Silicon)
- dist-x86_64/input-method-select (for Intel Macs)

## Customize Candidate Input Methods

If your input method requires a focus refresh (e.g., it uses a candidate window), add its input_source_id to the kCandidateInputSources array in input-method-select.m:

```objc
static NSArray<NSString *> *const kCandidateInputSources = @[
  // candidate boxes input methods here
  @"com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
];
```

## When Does Window Focus Refresh?

Window focus is refreshed only when switching from an input method listed in kCandidateInputSources.
This works around a macOS bug where such input methods (with candidate boxes) may not deactivate properly using system API calls alone.
The tool creates and focuses a temporary window to refresh system focus.
Input methods that don’t use candidate boxes do not trigger a focus refresh.

## License

MIT
