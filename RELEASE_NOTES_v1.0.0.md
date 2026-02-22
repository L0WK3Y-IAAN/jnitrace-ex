# JNITrace EX 1.0.0

First stable release of **JNITrace EX**, a maintained fork of [chame1eon/jnitrace](https://github.com/chame1eon/jnitrace) that works with current Frida and Python versions.

## What's in this release

- **Frida 16 & 17 support** – Uses `Module.findGlobalExportByName()` for Frida 17 compatibility (replacing the deprecated `findExportByName(null, …)` in jnitrace-engine).
- **Python 3.7+** – Modern packaging with `importlib_metadata` and `importlib_resources` (no `pkg_resources`).
- **Stable terminal output** – Unbuffered stdout and flushes so trace output appears in real time without `adb logcat`.
- **Run from source** – `./scripts/jnitrace.sh` runs from the repo using the project venv and `PYTHONPATH`, no global install required.

## Install

```bash
pip install jnitrace-ex
```

Then run:

```bash
jnitrace -l libnative-lib.so -b none com.example.myapplication
```

## Requirements

- **Device:** Android (arm, arm64, x86, x64) with frida-server 16.x or 17.x  
- **Host:** Python 3.7+, Frida 16+

## Links

- **Repository:** [github.com/L0WK3Y-IAAN/jnitrace-ex](https://github.com/L0WK3Y-IAAN/jnitrace-ex)
- **Issues:** [github.com/L0WK3Y-IAAN/jnitrace-ex/issues](https://github.com/L0WK3Y-IAAN/jnitrace-ex/issues)
- **Original jnitrace:** [github.com/chame1eon/jnitrace](https://github.com/chame1eon/jnitrace)
