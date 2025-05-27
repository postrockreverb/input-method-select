# Input Method Switcher for macOS

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

## License

MIT
