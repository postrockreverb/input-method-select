# Input Method Select

A minimal macOS CLI utility to switch keyboard input methods programmatically — fast and reliable for scripting, automation, and hotkeys.

Works around macOS bug with "candidate box" input methods (e.g., Japanese IME)

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

# Candidate input methods bug workaround

If your input method displays a candidate window (like many East Asian input methods), macOS sometimes fails to fully switch using only the system API.

To fix this, whenever you’re switching from ABC input method, the following sequence will be applied:

1. Switch to your target input method
2. Switch back to ABC
3. Switch again to the target input method

If you are NOT switching from ABC, the normal switch is sufficient.

## License

MIT
