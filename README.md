# powershell-nisgroup

PowerShell cmdlet for adding an AD group to the local NIS server (and setting its GID).

This is a small cmdlet to add an existing AD group to the local NIS server whils creating its group ID (GID). It is especially useful on Windows Server 2016 where Microsoft removed the NIS service and the GUI tools for managing Unix Attributes from ADUC. It will automatically find and assign the next available GID.

# Usage

    Add-NisGroup -sAMAccountName [-NISDomain]

Parameters:

* `sAMAccountName`: the username to add Unix Attributes to.

* `NISDomain`: the NIS Domain to use (default: `int`)

# Build

The script is already written in PowerShell, so you do not have to build it. 

## Usage

To import the script in your current session: `Import-Module Add-NisGroup.psm1`. Alternarively, run it from its directory.

You must use an Administrator shell for it to work. 

You need to have PowerShell ActiveDirectory module installed (part of RSAT).

## Package

You can use the provided NSIS script to build a GUI installer with the script. NSIS is available for Windows and Linux, see http://nsis.sourceforge.net (on Linux, be sure to check with your distro first):

* From the top level directoy of the repo, call `makensis Add-NisGroup.nsis`.

# Binary Downloads

See home page for compiled binary downloads: http://www.zavedil.com/powershell-cmdlet-for-unix-attributes

# Bugs & Wishes

Report bugs & wishes here or contact the author via email.

# Author

Assen Totin, assen.totin@gmail.com

