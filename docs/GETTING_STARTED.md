# 🚀 Getting Started with MakeBox

Welcome to the MakeBox installation and guide section! Below, you'll find the steps to get started with MakeBox.

> **Prerequisite:** Before continuing, please install the latest PowerShell 7.5 release to ensure full compatibility with MakeBox.

## 📦 Installation Instructions

1. **Download the Module Source**: Visit the [MakeBox releases](https://github.com/Zloyhan/MakeBoxPS/releases) page and download the latest package. This ensures you are working with an official and versioned release.
2. **Extract the Archive**: Unzip the downloaded file and verify that the module root folder is named `MakeBox` and contains `MakeBox.psd1` and `MakeBox.psm1`. PowerShell uses these files to identify and load the module correctly.
3. **Copy to a PowerShell Module Path**: In order for PowerShell to access the module by name, the `MakeBox` folder must be placed in a directory that PowerShell scans for modules.
   - **Current user scope** (recommended for PowerShell 7.5+): `C:\Users\<YourUser>\Documents\PowerShell\Modules\`
   - **All users scope** (administrator required, PowerShell 7.5+): `C:\Program Files\PowerShell\Modules\`
4. **Import the Module**: Open a new PowerShell session and run the command below so the module is loaded into the active session:
   ```powershell
   Import-Module MakeBox -Force
   ```
5. **Verify Installation**: Confirm that installation and module loading were successful:
   ```powershell
   mkbox
   ```

> **Note:** To check which module directories your PowerShell session uses, run:
> ```powershell
> $env:PSModulePath -split ';'
> ```
> Place the `MakeBox` folder in one of the listed paths.

## 🧭 Quick Start Guide

Imagine you are starting a new project and want a clean place to work.  
First, you create a dedicated folder so your MakeBox tests stay isolated:

```powershell
mkdir C:\Programming\TestMakeBox
```

Then you move into that folder, because MakeBox is workspace-oriented and always acts relative to your current location:

```powershell
cd C:\Programming\TestMakeBox
```

Now you open PowerShell 7.5 (`pwsh`) in this location so all commands run in the expected environment:

```powershell
pwsh
```

At this point, you initialize MakeBox:

```powershell
mkbox init
```

This step creates the workspace marker (`.mkboxroot`) and foundational structure (for example `common`), which tells MakeBox that this directory is now an active workspace.

With the workspace ready, you scaffold your first structure:

```powershell
mkfolder src docs
mkfile README.md notes.txt
```

Now you have immediate project structure and starter files.  
Next, you can check where MakeBox sees your workspace root and discover available commands:

```powershell
mkroot
mkhelp
mkalias
```

After that, you can start using templates to create reusable project or file content.  
The built-in examples currently available in this repository are:
- Project template: `c-basic`
- File template: `ProjectNotes` (from `ProjectNotes.txt`)

```powershell
mkbox get project c-basic my-first-c-project
mkbox get file ProjectNotes notes-project.txt
```

### Built-in vs User Templates

- **Built-in templates** are shipped with the module and stored in the module's `Templates` folder.
- **User templates** are templates you save yourself with `mksave` (`mkbox savet`) and keep in your user template store under Documents.
- When you run `mkbox get`, MakeBox resolves templates in this order:
  1. User templates
  2. Built-in templates

This means your own user template can override a built-in template with the same name.

Finally, when you want to inspect your template store:

```powershell
mkls
```

This prints your current templates in a tree format so you can quickly see what is available.

## ✅ First-Run Verification and Common Issues

After completing the quick start, it is recommended to run the checks below:

```powershell
mkbox
mkhelp
mkroot
```

Expected outcome:
- `mkbox` prints module info and usage direction.
- `mkhelp` prints available commands.
- `mkroot` confirms workspace root location when run inside your initialized workspace.

If something does not work:
- Re-import the module in a clean terminal session:
  ```powershell
  Remove-Module MakeBox -ErrorAction SilentlyContinue
  Import-Module MakeBox -Force
  ```
- Confirm your module path contains the `MakeBox` folder:
  ```powershell
  $env:PSModulePath -split ';'
  ```
- Confirm you are using PowerShell 7.5+:
  ```powershell
  $PSVersionTable.PSVersion
  ```

For further assistance, please refer to the documentation or community forums.
