# 📘 MakeBox Official Documentation

## 👋 Introduction
MakeBox is a PowerShell 7.5+ module for fast, text-first workspace scaffolding and template-driven project setup.

In this section, we set the context for the rest of the document: what MakeBox is, why it was designed this way, and where to start if this is your first time.

From the current repository implementation, the key design decisions are clear:
- The module is intentionally command-line focused (`mkbox` as the entry point, plus short aliases).
- Workspace safety is enforced through a root marker file (`.mkboxroot`).
- Template resolution is deterministic (user templates first, then built-in templates).
- Output is standardized through `Write-MkBoxHost` so behavior stays simple and consistent.

If you have not read the getting started guide yet, do that first. It is important, and the installation process is documented there.

- Getting Started: [GETTING_STARTED.md](./GETTING_STARTED.md)

> **Important:** Installation instructions are intentionally kept in `GETTING_STARTED.md`.  
> This documentation assumes MakeBox is already installed and importable.

> **Prerequisite:** PowerShell 7.5 or newer.

### Quick Navigation (What to Read Based on Your Need)
If you are looking for a specific type of information, use this map:

- Start here for core purpose and design: **Section 1 (Functionality)**
- Learn what is already implemented and why: **Section 2 (Implemented Features)**
- Find command syntax/parameters/examples: **Section 3 (Commands and Aliases)**
- Understand internal architecture (public vs private): **Section 4 (Helper Layer)**
- Troubleshoot errors, edge cases, and debugging: **Section 5 (Edge Cases, Error Codes, Debug)**

> **If you came for edge cases:** Go directly to **Section 5**.  
> It contains code-by-code guidance, practical fix actions, and troubleshooting flows.

## ⚙️ 1. Functionality
MakeBox provides four practical capabilities:

1. Workspace lifecycle
- Initialize a workspace (`mkbox init`).
- Find or move to the workspace root (`mkbox root`).

2. File and folder scaffolding
- Create new files/folders quickly.
- Remove or copy items with safeguards.

3. Template lifecycle
- Save your own reusable templates.
- Create projects/files from templates.
- Remove, clear, and list templates.

4. Operational support
- Use built-in help and alias listing.
- Run environment checks with doctor.

In the next section, we go deeper into how each capability is implemented and how to use it effectively.

## 🧩 2. Currently Implemented Functions and Features
This section describes what is implemented today and how it helps in real usage.
In this section, we go feature by feature and explain not only what exists, but also why the behavior is designed that way.

### 2.1 Workspace Marker and Root Discovery
- Marker file: `.mkboxroot`
- Root search behavior: current directory -> parent -> parent ... until found
- Implemented by: `Find-MkBoxWorkspaceRoot`, `Ensure-MkBoxWorkspaceRoot`, `Invoke-MkBoxRoot`

Why this helps:
- You can run commands from nested subfolders and still resolve the correct workspace.

Effective usage:
```powershell
mkbox root
mkbox root -m
```

### 2.2 Safe Workspace-Oriented Operations
Commands that require workspace root checks:
- `new`, `get`, `rm`, `copy`

Why this helps:
- Prevents accidental execution outside an initialized workspace.

### 2.3 Template Store Management (User Scope)
- User templates are kept under Documents:
  - `...\MakeBox\Templates\Projects`
  - `...\MakeBox\Templates\Files`
- Store creation can happen automatically via `Ensure-MkBoxUserTemplatesStore -CreateIfMissing`.

Why this helps:
- User templates are available globally, independent of current workspace.

> **Note:** Use `mkls` to quickly verify what is currently stored in your user template store.

### 2.4 Built-in + User Template Resolution
- Built-in templates are inside module `Templates/`.
- User templates are checked first.
- If not found in user scope, built-in scope is checked.

Why this helps:
- You can override a built-in template name with your own template name.

### 2.5 Root Marker Safety for Template/Copy Operations
Implemented safety checks block operations that involve `.mkboxroot` in unsafe contexts:
- `Save-MkBoxUserTemplate`
- `Invoke-MkBoxGet` (project template contains marker)
- `Copy-MkBoxItem`

Why this helps:
- Prevents unintentionally cloning or saving workspace root metadata in the wrong place.

### 2.6 Confirmed Remove Flows
`rm`, `delt`, and `clrt` support interactive confirmation (unless `-Force` is used).

Why this helps:
- Destructive operations remain deliberate by default.

### 2.7 Standardized Console Output
`Write-MkBoxHost` provides typed output categories:
- `dn` success
- `wr` warning
- `err` error
- `i` info
- `?` question/prompt

Why this helps:
- Predictable output style and scan-friendly terminal behavior.

## 🧠 3. Commands and Aliases
All user-facing commands can be called either through `mkbox <command>` or short aliases.

In this section, we focus on practical command usage: syntax, parameters, examples, and operational cautions.

> **Note:** If you are unsure where to begin, start with `mkhelp` and then open command-specific help such as `mkhelp get`.
>
> **Important:** Workspace-oriented commands (`new`, `get`, `rm`, `copy`) expect a valid workspace context (`.mkboxroot`).

### 3.1 `mkbox` (command router)
Description:
- Main entry command that dispatches to all supported subcommands.

Usage:
```powershell
mkbox
mkbox help
mkbox <command> [args]
```

Be careful:
- Unknown command names fall back to help output.

### 3.2 `init` / `mkinit`
Description:
- Initializes current directory as a MakeBox workspace.

Parameters:
- none

Usage:
```powershell
mkbox init
mkinit
```

What to be careful about:
- If `.mkboxroot` already exists in the current directory, init will not reinitialize.

### 3.3 `root` / `mkroot`
Description:
- Finds workspace root or moves to it.

Parameters:
- `-Find` (`-f`): find root (default behavior)
- `-Move` (`-m`): `Set-Location` to root

Usage:
```powershell
mkbox root
mkbox root -m
mkroot -f
```

What to be careful about:
- Do not pass `-find` and `-move` together.

### 3.4 `new` / `mkfolder` / `mkfile`
Description:
- Creates empty folders/files.

Parameters (`mkbox new`):
- `<Instance>`: `file` or `folder`
- `<Name...>` (`-n`): one or more target names

Usage:
```powershell
mkbox new folder src docs
mkbox new file README.md notes.txt
mkfolder src docs
mkfile README.md notes.txt
```

What to be careful about:
- Existing paths are skipped.
- If a file/folder with same name already exists (opposite type), command warns and skips.

Pipeline:
- Supported in public functions (`Invoke-MkBoxNew`, `New-MkBoxFolder`, `New-MkBoxFile`).
- Alias wrappers (`mkfolder`, `mkfile`) are optimized for CLI usage; for pure pipeline workflows, call public functions directly.

Example:
```powershell
"src","docs" | New-MkBoxFolder
"README.md","notes.txt" | New-MkBoxFile
```

### 3.5 `get` / `mkgetproject` / `mkgetfile`
Description:
- Creates files/projects from templates.

Parameters:
- `<Instance>`: `file` or `project`
- `<TemplateName>` (`-t` / `-Template`)
- `[TargetName...]` (`-n` / `-Name`): optional output names

Usage:
```powershell
mkbox get project c-basic my-c-app
mkbox get file ProjectNotes notes.txt
mkgetproject c-basic my-c-app
mkgetfile ProjectNotes notes.txt
```

What to be careful about:
- Requires initialized workspace.
- If project template contains `.mkboxroot`, operation is blocked.
- If target already exists, that target is skipped.

Pipeline:
- Supported in `Invoke-MkBoxGet` for target name input.
- Use this when you want to materialize one template into multiple targets.

Example:
```powershell
"app1","app2" | Invoke-MkBoxGet project c-basic
```

### 3.6 `rm` / `mkrm`
Description:
- Removes relative workspace items recursively with confirmation.

Parameters:
- `<ItemName...>` (`-n` / `-Name`)
- `-Force` (`-f`): skip confirmations

Usage:
```powershell
mkbox rm build temp
mkrm build -f
```

What to be careful about:
- Only safe relative names are accepted; rooted/UNC/traversal (`..`) is blocked.
- Default mode asks per-item confirmation.

Pipeline:
- Supported in `Remove-MkBoxItem`.
- Useful when remove targets are produced by previous commands.

Example:
```powershell
"build","tmp","cache" | Remove-MkBoxItem -Force
```

### 3.7 `copy` / `mkcopy`
Description:
- Copies file/folder from source to destination (recursive).

Parameters:
- `<SourcePath>`
- `<DestinationPath>`
- `-Force` (`-f`)

Usage:
```powershell
mkbox copy .\src .\backup\src
mkcopy .\notes.txt .\archive\notes.txt -f
```

What to be careful about:
- Requires initialized workspace.
- Copy is blocked if source/destination includes `.mkboxroot` context in disallowed ways.

### 3.8 `savet` / `mksave`
Description:
- Saves a sibling file/folder from current directory as user template.

Parameters:
- `-Name` (`-n`): template name
- `-SourcePath`: sibling file/folder name in current directory
- `-Type`: `project` or `file` (optional, auto-detected when omitted)
- `-Force` (`-f`): overwrite existing template without prompt

Usage:
```powershell
mkbox savet -Name myproj -SourcePath src -Type project
mksave -n mynotes -SourcePath notes.txt
```

What to be careful about:
- Source must be sibling-only (no rooted/full/path traversal input).
- If source includes `.mkboxroot`, save is blocked.

> **Note:** `-SourcePath` should be a sibling name like `src` or `notes.txt`, not a full path.

### 3.9 `delt` / `mkdel`
Description:
- Removes user template by name.

Parameters:
- `-Name` (`-n`)
- `-Type`: `auto` | `project` | `file` (default: `auto`)
- `-Force` (`-f`)

Usage:
```powershell
mkbox delt -Name myproj -Type project
mkdel -n mynotes -Type auto -f
```

What to be careful about:
- `auto` may remove both a project and file template if names match.

### 3.10 `clrt` / `mkclr`
Description:
- Clears all user templates.

Parameters:
- `-Force` (`-f`)

Usage:
```powershell
mkbox clrt
mkclr -f
```

What to be careful about:
- This is destructive for all user templates.

### 3.11 `lst` / `mkls`
Description:
- Lists current user templates as a tree.

Parameters:
- none

Usage:
```powershell
mkbox lst
mkls
```

What to be careful about:
- If no templates are present, command prints warning and exits.

> **Tip:** `mkls` shows both project templates and file templates in tree output.

### 3.12 `doctor` / `mkdoc`
Description:
- Checks workspace and template store state, fixes what is safe to fix automatically.

Parameters:
- none

Usage:
```powershell
mkbox doctor
mkdoc
```

What to be careful about:
- If no workspace root is found from current path, doctor warns but still validates template store.

> **Tip:** Run `mkdoc` after moving machines, changing Documents path settings, or importing the module on a clean environment.

### 3.13 `help` / `mkhelp` and `alias` / `mkalias`
Description:
- `help`: general or command-specific help
- `alias`: alias mapping list

Parameters:
- `mkbox help [command]`
- `mkbox alias` has no parameters

Usage:
```powershell
mkhelp
mkhelp get
mkalias
```

What to be careful about:
- Use command-specific help when unsure about parameter order.

### 3.14 Pipeline Behavior
Pipeline-capable public command functions (direct function usage):
- `Invoke-MkBoxNew`
- `Invoke-MkBoxGet`
- `New-MkBoxFolder`
- `New-MkBoxFile`
- `Remove-MkBoxItem`

Examples:
```powershell
"a","b","c" | New-MkBoxFolder
"notes1.txt","notes2.txt" | New-MkBoxFile
"tmp1","tmp2" | Remove-MkBoxItem -Force
```

Important note:
- Aliases (`mkfolder`, `mkfile`, etc.) route through `mkbox` wrappers for output consistency.
- For true PowerShell pipeline workflows, use the exported function names directly.

You can refer back to Sections **3.4**, **3.5**, and **3.6** for command-specific pipeline examples.

## 🛠️ 4. Helper Command Layer (Public vs Private)
This module has a clear two-layer architecture:

In this section, we explain why helper functions exist and when they are triggered behind the scenes.

### 4.1 Public Command Functions (user-facing)
- `Initialize-MkBoxWorkspace`
- `Invoke-MkBoxRoot`
- `Get-MkBoxWorkspaceRoot`
- `Invoke-MkBoxNew`
- `Invoke-MkBoxGet`
- `New-MkBoxFolder`
- `New-MkBoxFile`
- `Remove-MkBoxItem`
- `Copy-MkBoxItem`
- `Save-MkBoxUserTemplate`
- `Remove-MkBoxUserTemplate`
- `Clear-MkBoxUserTemplates`
- `Get-MkBoxTemplatesTree`
- `Invoke-MkBoxDoctor`
- `Show-MkBoxHelp`
- `Show-MkBoxAliases`
- `mkbox`

### 4.2 Private Helper Functions (internal)
- `Write-MkBoxHost`: standardized terminal output style
- `Find-MkBoxWorkspaceRoot`: upward root-marker traversal
- `Ensure-MkBoxWorkspaceRoot`: guard for workspace-required commands
- `Get-MkBoxUserTemplatesPath`: resolves user template paths under Documents
- `Ensure-MkBoxUserTemplatesStore`: validates/creates store structure
- `Find-MkBoxTemplateSource`: resolves templates user-first then built-in
- `Test-MkBoxContainsRootMarker`: detects root marker presence for safety checks
- `Test-MkBoxSafeRelativeName`: validates remove target names

When these helpers are called:
- Before workspace-sensitive operations (`new`, `get`, `rm`, `copy`)
- Before template operations (`savet`, `delt`, `clrt`, `lst`, `doctor`, `get`)
- During safety checks for root-marker and path validation

> **Note:** Public functions are designed for user workflows. Private helpers are internal implementation details and should normally not be called directly.

## 🚨 5. Edge Cases, Error Codes, and Debug Guidance
This section maps current error/edge codes to practical fixes.

This is the section to use when a command does not behave as expected. Each code is intended to be actionable, not generic.

### 5.1 Edge Codes
- `MKBOX-EC-001`: user template base path exists as file, must be directory
- `MKBOX-EC-002`: templates path exists as file, must be directory
- `MKBOX-EC-003`: templates store not found (non-create mode)
- `MKBOX-EC-004`: project template contains `.mkboxroot` (blocked for safety)

### 5.2 Error Codes
- `MKBOX-ERR-NEWF-001`: folder creation failed
- `MKBOX-ERR-NEWFILE-001`: file creation failed
- `MKBOX-ERR-GET-001`: template materialization failed
- `MKBOX-ERR-RM-001`: unsafe relative name blocked
- `MKBOX-ERR-RM-002`: remove failed
- `MKBOX-ERR-CPY-001`: copy source not found
- `MKBOX-ERR-CPY-002`: source contains root marker (blocked)
- `MKBOX-ERR-CPY-003`: destination contains root marker (blocked)
- `MKBOX-ERR-CPY-004`: copy failed
- `MKBOX-ERR-SAVE-001`: save blocked due to root marker in source
- `MKBOX-ERR-SAVE-002`: `project` type mismatch with non-folder source
- `MKBOX-ERR-SAVE-003`: `file` type mismatch with non-file source
- `MKBOX-ERR-SAVE-004`: save copy failed
- `MKBOX-ERR-DELT-001`: template delete failed
- `MKBOX-ERR-CLRT-001`: clear templates failed
- `MKBOX-ERR-DOCTOR-001`: doctor template-store check failed

### 5.3 Practical Debug Flow
1. Confirm workspace state:
```powershell
mkroot
```

2. Confirm help/usage for current command:
```powershell
mkhelp <command>
```

3. Validate template inventory:
```powershell
mkls
```

4. Run environment repair checks:
```powershell
mkdoc
```

5. Re-import module when behavior appears stale:
```powershell
Remove-Module MakeBox -ErrorAction SilentlyContinue
Import-Module <path-to-MakeBox.psd1> -Force
```

### 5.4 Example Troubleshooting Scenarios
Scenario A: unsafe remove target
```powershell
mkbox rm ..\secret
```
Expected:
- `MKBOX-ERR-RM-001`
- Fix by using only safe relative names under current workspace.

Scenario B: project get blocked by root marker
```powershell
mkbox get project some-template myproj
```
Expected (if template contains `.mkboxroot`):
- `MKBOX-EC-004`
- Fix by removing `.mkboxroot` from that template source.

Scenario C: save template with invalid source path style
```powershell
mkbox savet -Name mytemp -SourcePath C:\full\path\file.txt
```
Expected:
- warning that sibling source is required
- Fix by changing directory (`cd`) to source location and passing only sibling name:
```powershell
mkbox savet -Name mytemp -SourcePath file.txt
```
