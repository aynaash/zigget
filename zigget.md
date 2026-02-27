# zigget — Project Plan

> A clean, webi-inspired tool installer built in Zig.
> Goal: learn Zig properly through a real, completable project.

---

## What It Does

zigget lets you install developer tools cleanly from the command line — no homebrew, no curl-pipe-bash, no admin rights. You run `zigget install <tool>` and it figures out your OS/arch, fetches the right binary, extracts it, and puts it on your PATH.

---

## Learning Goals

By finishing zigget you will have touched:

- Allocators and memory management
- Error handling with error unions
- comptime for OS/arch detection
- HTTP requests via std.http
- File I/O and archive extraction
- Cross-compilation and releasing binaries
- Zig build system (build.zig)

---

## Phases

### Phase 1 — Hello World + Project Setup
- `zig init` scaffold
- Clean up generated files
- Print `zigget v0.1.0` to stdout
- Commit to GitHub

### Phase 2 — OS and Arch Detection
- Detect OS at comptime: linux, macos, windows
- Detect arch at comptime: x86_64, aarch64
- Print detected platform to stdout
- Learn: `@import("builtin")`, comptime, enums

### Phase 3 — CLI Argument Parsing
- Parse subcommands: `install`, `list`, `version`
- Parse tool name argument: `zigget install fzf`
- Handle missing or invalid args gracefully
- Learn: `std.process.args()`, iterators, error handling

### Phase 4 — Package Manifest
- Define a simple local manifest (hardcoded list of tools to start)
- Each entry has: name, version, download URL template per platform
- Learn: structs, comptime maps, string formatting

### Phase 5 — HTTP Download
- Fetch a binary from a URL using `std.http`
- Show download progress
- Save to temp file
- Learn: std.http.Client, streams, file writing
- Note: HTTPS may be rough — be ready to debug this

### Phase 6 — Extraction
- Extract .tar.gz and .zip archives
- Use std.compress or shell out to system tools initially
- Place binary in `~/.local/bin` or `~/zigget/bin`

### Phase 7 — PATH Management
- Check if install dir is on PATH
- Warn user if not
- Optionally write to shell rc file (.bashrc, .zshrc)

### Phase 8 — Polish
- `zigget list` shows available tools
- `zigget version` shows version
- Nice error messages
- README with install instructions

### Phase 9 — Release
- Cross-compile for linux-x86_64, linux-aarch64, macos-aarch64
- Upload binaries to GitHub Releases
- Write install one-liner (ironic: install zigget with curl)
- Post to r/Zig and Zig Discord #projects

---

## Stack

- Language: Zig (latest stable)
- No external dependencies to start — stdlib only
- Build system: build.zig

---

## Commands to Know

```bash
zig init              # scaffold new project
zig build run         # build and run
zig build run -- install fzf   # pass args
zig version           # check your zig version
zig targets           # see all cross-compile targets
```

---

## Resources

- ziglings — learn Zig by fixing broken programs
- https://ziglang.org/documentation/master/std/
- Karl Seguin's blog — clearest Zig tutorials
- Zig Discord #help channel

---

## Milestone Checklist

- [ ] Phase 1: Hello World
- [ ] Phase 2: OS/Arch detection
- [ ] Phase 3: CLI parsing
- [ ] Phase 4: Package manifest
- [ ] Phase 5: HTTP download
- [ ] Phase 6: Extraction
- [ ] Phase 7: PATH management
- [ ] Phase 8: Polish
- [ ] Phase 9: Release
