[Setup]
AppName = Fablicator Interface
AppVersion = 2.0
ChangesAssociations = yes
CloseApplications = yes
DefaultDirName = {sd}\Fablicator\Fablicator
DefaultGroupName = Fablicator
OutputBaseFilename = fablicator_interface-setup-win10
OutputDir = release
UninstallDisplayName = Fablicator Interface
UninstallDisplayIcon = {app}\fablicator.exe,0

[Types]
Name: "main"; Description: "Select printer type"; Flags: iscustom

[Components]
Name: "required"; Description: "Required files"; Types: main; Flags: fixed
Name: "cfg"; Description: "Configuration"; Types: main
Name: "cfg/mx"; Description: "MX"; Types: main; Flags: exclusive
Name: "cfg/sx"; Description: "SX"; Types: main; Flags: exclusive
Name: "cfg/fm1"; Description: "FM1"; Types: main; Flags: exclusive

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"
Name: docshortcut; Description: "Create a &desktop shortcut for the documentation"; GroupDescription: "Additional icons:"
Name: associate; Description: "&Associate .gcode files"; GroupDescription: "Other tasks:"

[Files]
Source: "dist\fablicator.exe"; DestDir: "{app}"; Components: required
Source: "Documentation\*"; DestDir: "{app}\Documentation"; Components: required; Flags: 
Source: "Configs\mx\printrunconf.ini"; DestDir: "{localappdata}\Printrun\Printrun"; Components: cfg\mx
Source: "Configs\sx\printrunconf.ini"; DestDir: "{localappdata}\Printrun\Printrun"; Components: cfg\sx
Source: "Configs\fm1\printrunconf.ini"; DestDir: "{localappdata}\Printrun\Printrun"; Components: cfg\fm1

[Registry]
Root: HKA; Subkey: "Software\Classes\.gcode"; ValueType: string; ValueName: ""; ValueData: "GcodeFile.gcode"; Flags: uninsdeletevalue; Tasks: associate
Root: HKA; Subkey: "Software\Classes\.gcode\OpenWithProgids"; ValueType: string; ValueName: "GcodeFile.gcode"; ValueData: ""; Flags: uninsdeletevalue; Tasks: associate
Root: HKA; Subkey: "Software\Classes\GcodeFile.gcode"; ValueType: string; ValueName: ""; ValueData: "GCode File"; Flags: uninsdeletekey; Tasks: associate
Root: HKA; Subkey: "Software\Classes\GcodeFile.gcode\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\fablicator.exe,0"; Tasks: associate
Root: HKA; Subkey: "Software\Classes\GcodeFile.gcode\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\fablicator.exe"" ""%1"""; Tasks: associate
Root: HKA; Subkey: "Software\Classes\Applications\fablicator.exe\SupportedTypes"; ValueType: string; ValueName: ".gcode"; ValueData: ""; Tasks: associate

[Icons]
Name: "{group}\Fablicator Interface"; Filename: "{app}\fablicator.exe"; WorkingDir: "{app}"
Name: "{group}\Fablicator Interface - User Manual"; Filename: "{app}\Documentation\FablicatorInterface-UserManual.pdf"; WorkingDir: "{app}"
Name: "{group}\Uninstall Fablicator Interface"; Filename: "{uninstallexe}"
Name: "{userdesktop}\Fablicator Interface"; Filename: "{app}\fablicator.exe"; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{userdesktop}\Fablicator Interface - User Manual"; Filename: "{app}\Documentation\FablicatorInterface-UserManual.pdf"; WorkingDir: "{app}"; Tasks: docshortcut