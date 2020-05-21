# EnableBDE
Script to enable Bitlocker, TPM ( if required ) and set BIOS password

Deigned to be run from a GPO which creates a scheduled task
Dell CCTK files to be stored on a server



SCHEDULED TASK SETTINGS

GENERAL

Run task as NT AUTHORITY\System
Run whether user is logged on or not
Run with Highest Privileges 
Configure for Windows 7

TRIGGERS

One time at a specified time
After triggered, repeat every x times indefinitely 

ACTIONS

Start a program - Powershell.exe
Details - -ExecutionPolicy Bypass -File "\\s-server1.dcCmpy.com\share$\GPOFiles\EnableBitlocker.ps1"

CONDITIONS

Blank

SETTINGS

Allow task to be run on demand
Run task as soon as possible



