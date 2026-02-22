# JNITrace EX

**An updated JNITrace that works with the latest Frida (16.x and 17.x).**

JNITrace EX is a maintained fork of [chame1eon/jnitrace](https://github.com/chame1eon/jnitrace), modernized to run on current Frida and Python versions. It traces use of the JNI API in Android apps—similar to frida-trace or strace, but for the JNI.

---

## Why JNITrace EX?

The original jnitrace targeted older Frida (e.g. 14.x) and Python 2/3.4–3.7. This version was created so you can use JNI tracing with:

- **Frida 16 and 17** – Updated Python API usage and a patch for [jnitrace-engine](https://github.com/chame1eon/jnitrace-engine) so `Module.findExportByName(null, …)` is replaced with `Module.findGlobalExportByName(…)` (Frida 17 breaking change).
- **Python 3.7+** – Version and script loading use `importlib_metadata` / `importlib_resources` (with fallbacks) instead of deprecated `pkg_resources`.
- **Stable terminal output** – Unbuffered stdout and flushes so trace output appears in the terminal without needing `adb logcat`.
- **Easy run-from-source** – `./scripts/jnitrace.sh` runs jnitrace from the repo using the project’s venv and `PYTHONPATH`, so you don’t depend on a global `pip install jnitrace`.

**Repository:** [https://github.com/L0WK3Y-IAAN/jnitrace-ex](https://github.com/L0WK3Y-IAAN/jnitrace-ex)

---

## Installation

**From PyPI:**

```bash
pip install jnitrace-ex
```

After install, run the CLI with `jnitrace` (same as before).

**From source:**

Use a Python that has Frida installed (e.g. 3.12). Create a venv with a **stable** Python path, then install:

```bash
cd /path/to/jnitrace-ex
/path/to/python3 -m venv .venv   # e.g. /Library/Frameworks/Python.framework/Versions/3.12/bin/python3
.venv/bin/pip install -e .
.venv/bin/pip install -r requirements.txt
```

**Run without installing the CLI** (script uses repo + venv):

```bash
./scripts/jnitrace.sh -l libnative-lib.so -b none com.example.myapplication
```

**Troubleshooting:**

- `bad interpreter: ... python3.14: no such file or directory` – Recreate the venv with a Python that stays in the same place, or run: `.venv/bin/python3 -m jnitrace.jnitrace ...`
- `ModuleNotFoundError: No module named 'frida'` – Install Frida for that interpreter: `pip install frida`, or use the same Python as `frida-tools`.
- `ModuleNotFoundError: No module named 'jnitrace'` – From repo root run `.venv/bin/pip install -e .`, or use `./scripts/jnitrace.sh` (no install needed).

**Dependencies:**

- Android device (arm, arm64, x86, or x64) with **frida-server** (16.x or 17.x)
- Host: Python 3.7+, Frida 16+, colorama, hexdump, importlib_resources

---

## Running

Start frida-server on the device, then:

```bash
# Spawn app and trace (recommended)
./scripts/jnitrace.sh -l libnative-lib.so -b none com.example.myapplication

# Or after pip install
jnitrace -l libnative-lib.so com.example.myapplication
```

**Required:**

- `-l libnative-lib.so` – Library to trace. Use multiple `-l` for several libs, or `-l *` for all.
- `com.example.myapplication` – Package name (must be installed on the device).

**Useful options:**

- `-b none` – Disable backtrace (reduces overhead; often needed so the app doesn’t crash under tracing).
- `-m attach` – Attach to an already running process by name (e.g. `-m attach "AppName"`).
- `-R [host:port]` – Remote Frida server (default `127.0.0.1:27042`).
- `-i <regex>` – Include only JNI methods matching the regex (e.g. `-i "NewStringUTF|CallIntMethod"`).
- `-e <regex>` – Exclude JNI methods matching the regex.
- `-o path/output.json` – Save trace to JSON.
- `-p path/to/script.js` – Load a Frida script before jnitrace (e.g. anti-Frida bypass).
- `-a path/to/script.js` – Load a Frida script after jnitrace.
- `--hide-data` – Hide hexdumps and extra data.
- `--ignore-env` / `--ignore-vm` – Skip JNIEnv or JavaVM calls.

**Start frida-server:**

```bash
adb shell /data/local/tmp/frida-server
```

---

## Optional arguments (reference)

| Option | Description |
|--------|-------------|
| `-b <fuzzy\|accurate\|none>` | Backtrace mode. Default `accurate`; use `none` to avoid crashes on some apps. |
| `-i <regex>` | Include only JNI methods whose names match (can be used multiple times). |
| `-e <regex>` | Exclude JNI methods whose names match. |
| `-I <string>` | Include only these library exports (e.g. `Java_...` or RegisterNatives methods). |
| `-E <string>` | Exclude these library exports. |
| `--aux name=(string\|bool\|int)value` | Aux options when spawning (e.g. `--aux='uid=(int)10'`). |

---

## Building from source

Build the Frida script (needed for run-from-source or custom changes):

```bash
npm install
npm run build
```

`npm run watch` compiles on change. The built script is `jnitrace/build/jnitrace.js`. A patch is applied to `jnitrace-engine` (via `patch-package`) for Frida 17 compatibility.

---

## Output

Output is colored by thread. Each JNI call shows:

- Thread ID
- Timestamp (ms)
- Method name (e.g. `JNIEnv->NewStringUTF`)
- Arguments (`|-`) and return value (`|=`)
- Optional backtrace when `-b` is not `none`

String arguments and return values (e.g. from `NewStringUTF`) are shown in braces. With `-b none`, trace is lighter and less likely to destabilize the app.

---

## API (jnitrace-engine)

The engine is available as a separate npm package for custom Frida scripts:

```javascript
import { JNIInterceptor } from "jnitrace-engine";

JNIInterceptor.attach("FindClass", {
    onEnter(args) {
        console.log("FindClass method called");
        this.className = Memory.readCString(args[1]);
    },
    onLeave(retval) {
        console.log("\tLoading Class:", this.className);
        console.log("\tClass ID:", retval.get());
    }
});
```

More: [jnitrace-engine](https://github.com/chame1eon/jnitrace-engine)

---

## How it works (summary)

jnitrace injects a Frida script that hooks library loading (`dlopen`/`dlsym`). For libraries you choose with `-l`, it builds a *shadow* JNIEnv and replaces the real one so only those libs’ JNI calls go through trampolines. Arguments and return values are captured and sent to the Python host, which formats and prints them. Variadic JNI calls are handled by tracking `GetMethodID`/`GetStaticMethodID` and building method signatures so the correct NativeCallbacks can be created per call.

---

## Issues

For bugs or questions about **JNITrace EX**, open an issue at:

**[https://github.com/L0WK3Y-IAAN/jnitrace-ex/issues](https://github.com/L0WK3Y-IAAN/jnitrace-ex/issues)**

Please include:

- Device and Android version
- Frida version (host and frida-server)
- Target app (package name)
- Exact command and any error output

For the original jnitrace or the engine, see [chame1eon/jnitrace](https://github.com/chame1eon/jnitrace) and [chame1eon/jnitrace-engine](https://github.com/chame1eon/jnitrace-engine).
