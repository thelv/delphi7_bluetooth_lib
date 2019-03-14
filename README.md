# delphi7_bluetooth_lib
Delphi 7 Bluetooth with Winsock2.dll implementation

Winsock2.pas is a partial interface for winsock2 dll windows library (ws2_32.dll).
It has only functions and types required for making a simple bluetooth server.

Bluetooth.pas has an example of using winsock2 dll to create bluetooth server.

Put both files into your project dir, then call Bluetooth.start function.

Project was made as port from C++ of official Microsoft bluetooth example https://code.msdn.microsoft.com/windowsdesktop/Bluetooth-Connection-e3263296  
You can continue porting functions you need from this.
