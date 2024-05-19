If WScript.Arguments.Count <> 6 Then
WScript.Echo "����������� ������� ���������. �������� ����� ���."
WScript.Quit 1
End If
' ������������ ������� ���������
Arg1 = WScript.Arguments(0)
Arg2 = WScript.Arguments(1)
Arg3 = WScript.Arguments(2)
Arg4 = WScript.Arguments(3)
Arg5 = WScript.Arguments(4)
Arg6 = WScript.Arguments(5)

' ��������� ��'� ����� � ������� ���������
fileName = WScript.Arguments(0)
' ��������� ��'���� ��� ������ � �������� ��������
Set fso = CreateObject("Scripting.FileSystemObject")
' �������� ��������� �����
If Not fso.FileExists(fileName) Then
' ��������� �����, ���� �� �� ����
Set logFile = fso.CreateTextFile(fileName, True)
' ����� ������� ���� �� ���� � ����
logFile.WriteLine "���� � ���: " & Now
logFile.WriteLine "���� � ��'�� " & fileName & " ������� ��� ��������."
logFile.Close
WScript.Echo "���� '" & fileName & "' ��������."
Else
' ����������� � ����, ���� �� ��� ����
Set logFile = fso.OpenTextFile(fileName, 8, True)
logFile.WriteLine "���� � ���: " & Now
logFile.WriteLine "���� � ��'�� " & fileName & " ������� ��� ��������."
logFile.Close
WScript.Echo "���� '" & fileName & "' ��� ����. ��� ������."
End If

' ������ �������� ������� ��� ��������� ���� � NTP �������
Set objShell = CreateObject("WScript.Shell")
objShell.Run "w32tm /resync"
' ��������� ��������� ����
currentTime = Now
' ��������� ��'� ����� � ������� ���������
fileName = WScript.Arguments(1)
' ³������� ��� ��������� ����� log
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(fileName, 8, True)
' ����� ��������� ���� � ���� log
logFile.WriteLine "�������� ���: " & currentTime
' �������� ����� log
logFile.Close

' ��������� ��'� ����� � ������� ���������
fileName = WScript.Arguments(1)
' ³������� ��� ��������� ����� log
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(fileName, 8, True)
' ���� ������ ��� ��������� ������� � ���� log
Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("tasklist")
Do Until objExec.StdOut.AtEndOfStream
strLine = objExec.StdOut.ReadLine
logFile.WriteLine strLine
Loop
' �������� ����� log
logFile.Close

' ��������� �������� ��������� - ���� ������� ��� ����������
processName = WScript.Arguments(2)
' ³������� ��� ��������� ����� log
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(fileName, 8, True)
' ���������� �������
Set objShell = CreateObject("WScript.Shell")
objShell.Run "taskkill /F /IM " & processName, 0, True
' ����� ���������� ��� ���������� ������� � ���� log
logFile.WriteLine "��������� ������ � ��'�� " & processName
' �������� ����� log
logFile.Close

' ��������� ������� ��������� - ����� �� ����� ��� ���������
Dim folderPath
folderPath = WScript.Arguments(1)
' ��������� ��'���� FileSystemObject
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
' ��� ����
Dim logFilePath
logFilePath = WScript.Arguments(0)
' ³������� ��� ����� ��� �����������
Dim logFile
Set logFile = fso.OpenTextFile(logFilePath, 8, True)
' ����� ��������� �����
Dim deletedCount
deletedCount = 0
deletedCount = deletedCount + DeleteFiles(folderPath, ".TMP")
deletedCount = deletedCount + DeleteTempFiles(folderPath, "temp")
' ����� ������� ��������� ����� � ��� ����
logFile.WriteLine "ʳ������ ��������� �����: " & deletedCount
' �������� ��� �����
logFile.Close
' ϳ��������� ��� ��������� ����� � ������ �����������
Function DeleteFiles(folderPath, extension)
Dim folder, file, files
Set folder = fso.GetFolder(folderPath)
Set files = folder.Files
Dim count
count = 0
For Each file in files
If LCase(fso.GetExtensionName(file.Name)) = LCase(extension) Then
file.Delete True ' True - �������� ���� ��� ������ ������������
count = count + 1
End If
Next
DeleteFiles = count
End Function
' ϳ��������� ��� ��������� ����� � ������ �������� ����
Function DeleteTempFiles(folderPath, startName)
Dim folder, file, files
Set folder = fso.GetFolder(folderPath)
Set files = folder.Files
Dim count
count = 0
For Each file in files
If LCase(Left(file.Name, Len(startName))) = LCase(startName) Then
file.Delete True ' True - �������� ���� ��� ������ ������������
count = count + 1
End If
Next
DeleteTempFiles = count
End Function

' ��������� �������� ��������� - ����� �� ������
Dim archivePath
archivePath = WScript.Arguments(2)
' ��������� ��'���� ��� ������ � Shell
Dim objShell
Set objShell = CreateObject("Shell.Application")
' �������� �����
ZipFiles archivePath, WScript.Arguments(1)
' ϳ��������� ��� ��������� �����
Sub ZipFiles(archivePath, folderPath)
Dim sourceFolder, files, file
Set sourceFolder = objShell.NameSpace(folderPath)
Set files = sourceFolder.Items
objShell.Namespace(archivePath & ".zip").CopyHere files
End Sub


'��������� ���������� ��������� - ����� �� ����� ��� ������������� ������
Dim destinationFolder
destinationFolder = WScript.Arguments(3)
' ������������� ������
CopyFile WScript.Arguments(2) & ".zip", destinationFolder
' ϳ��������� ��� ��������� �����
Sub CopyFile(sourceFile, destFolder)
Dim objFSO
Set objFSO = CreateObject("Scripting.FileSystemObject")
objFSO.CopyFile sourceFile, destFolder & "\", True
End Sub

 '�������� �� ���� ����� �� ������� ����
Dim yesterdayArchivePath
yesterdayArchivePath = destinationFolder & "\" & FormatDateTime(Date - 1, 2) & ".zip"
Dim objFSO
Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists(yesterdayArchivePath) Then
WriteToLog "�������� ����� �� ������� ����: " & yesterdayArchivePath
Else
WriteToLog "����� �� ������� ���� �� ��������"
SendEmail "user@example.com", "³������ ����� �� ������� ����", "����� �� ������� ���� �������."
End If
' ϳ��������� ��� ������ � ���
Sub WriteToLog(logMessage)
Dim logFile, fso, ts
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(WScript.Arguments(1), 8, True)
logFile.WriteLine Now & " - " & logMessage
logFile.Close
End Sub
' ϳ��������� ��� �������� ������������ �����
Sub SendEmail(emailAddress, subject, body)
Dim objEmail
Set objEmail = CreateObject("CDO.Message")
' ������������ ���������� �� ����������
objEmail.From = "vlad.negerey1@google.com"
objEmail.To = emailAddress
objEmail.Subject = subject
objEmail.TextBody = body
' ������������ SMTP �������
objEmail.Configuration.Fields.Item
("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objEmail.Configuration.Fields.Item
("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.example.com"
objEmail.Configuration.Fields.Item
("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
objEmail.Configuration.Fields.Update
' ³���������� �����
objEmail.Send
End Sub



' ��������, �� � �� ������ ��������4 ������, ������ 30 ���, �� ���� �, ��
�������. ������� � log.
Sub DeleteOldArchives(folderPath)
' ��������� ��'���� ��� ������ � �������� ��������
Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")
' ������ ��� ����� � �����
Dim objFolder : Set objFolder = objFSO.GetFolder(folderPath)
Dim objFiles : Set objFiles = objFolder.Files
' ������� ����
Dim currentDate : currentDate = Now
' ʳ������ ���, �� ���������� ����������
Const DAYS_THRESHOLD = 30
' �������� ��� ����� � �����
For Each objFile In objFiles
' ��������, �� ���� � ������� .zip
If LCase(objFSO.GetExtensionName(objFile.Name)) = "zip" Then
' ���������� ������ � ����� (������� ���)
Dim daysDifference : daysDifference = DateDiff("d",
objFile.DateLastModified, currentDate)
' ���� ���� ������� �� ���������� ����, ��������� ����
If daysDifference > DAYS_THRESHOLD Then
objFSO.DeleteFile objFile.Path, True ' ��������� �����
WriteToLog "�������� ��������� �����: " & objFile.Name
End If
End If
Next
End Sub


 '��������, �� � ���������� �� Internet, �� ������� � log.
Sub CheckInternetConnection()
' ��������� ��'���� ��� ��������� HTTP-������
Dim objHTTP : Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
' URL-������ ��� �������� ���������� ���������
Dim url : url = "http://www.google.com"
' ��������� HTTP-������ �� �������� URL-�������
objHTTP.Open "GET", url, False
objHTTP.send
' �������� ������� HTTP-������
If objHTTP.Status = 200 Then
WriteToLog "ϳ��������� �� ��������� �."
Else
WriteToLog "���� ���������� �� ���������."
End If
End Sub


' �������� �������� ����'����� � �������� IP-������� � �������� ����� ��
������� ���� ������.
Sub CheckAndShutdownComputer(ipAddress)
' ��������� ������� ping ��� �������� ���������� ����'����� � �������� IP-
�������
Dim command : command = "ping -n 1 " & ipAddress
Dim shell : Set shell = CreateObject("WScript.Shell")
Dim pingResult : pingResult = shell.Run(command, 0, True)
' �������� ���������� ��������� ������� ping
If pingResult = 0 Then
WriteToLog "����'���� � IP-������� " & ipAddress & " �������� � �����.
���������� ������..."
' ��������� ������� ��� ���������� ������ ����'�����
shell.Run "shutdown -s -f -t 0", 0, True
Else
WriteToLog "����'���� � IP-������� " & ipAddress & " �� �������� �
�����."
End If
End Sub



' ������ ������ ����'����� � ����� �� ������ �������� ���������� � log.
Sub GetNetworkComputers()
' ��������� ������� arp -a ��� ��������� ������ ����'����� � �����
Dim shell : Set shell = CreateObject("WScript.Shell")
Dim command : command = "arp -a"
Dim result : result = shell.Exec(command)
' ���������� ���������� ��������� ������� �� ����� � log
While Not result.StdOut.AtEndOfStream
Dim line : line = result.StdOut.ReadLine
WriteToLog line
Wend
WriteToLog "������ ����'����� � ����� ������ ��������."
End Sub

 '������� ��� �������� ���������� ����'����� �� IP �������
Function CheckComputerAvailability(ipAddress)
Dim objShell : Set objShell = CreateObject("WScript.Shell")
Dim objPing : Set objPing =
GetObject("winmgmts:{impersonationLevel=impersonate}").ExecQuery("select * from Win32_PingStatus where address = '" & ipAddress & "'")
For Each objResult In objPing
If IsObject(objResult) Then
If objResult.StatusCode = 0 Then
' ����'���� ��������� � �����
CheckComputerAvailability = True
Else
' ����'���� �� ��������� � �����
CheckComputerAvailability = False
End If
End If
Next
End Function
' ������� ��� ������ ����������� � ���
Sub WriteToLog(message)
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
Dim logFile : Set logFile = fso.OpenTextFile("lab.log", 8, True)
logFile.WriteLine Now & " " & message
logFile.Close
End Sub
' ������� IP ������ � �����
Dim ipFile : Set ipFile =
CreateObject("Scripting.FileSystemObject").OpenTextFile("ipon.txt", 1)
Dim ipAddress : ipAddress = ipFile.ReadAll
ipFile.Close
' ������������ ����� � ����� IP �����
Dim ipAddresses : ipAddresses = Split(ipAddress, vbCrLf)
' �������� ���������� ������� IP ������
Dim availableComputers : availableComputers = ""
Dim unavailableComputers : unavailableComputers = ""
For Each ip In ipAddresses
If CheckComputerAvailability(ip) Then
availableComputers = availableComputers & ip & vbCrLf
Else
unavailableComputers = unavailableComputers & ip & vbCrLf
End If
Next
' ����� �� ��� �����
WriteToLog "������� ����'�����:"
WriteToLog availableComputers
WriteToLog "��������� ����'�����:"
WriteToLog unavailableComputers



' ������� ��� �������� ������ ��� �����
Function CheckLogFileSize(logFilePath, maxSize)
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
Dim logFile, fileSize
' �������� �������� �����
If fso.FileExists(logFilePath) Then
' ��������� ��'���� �����
Set logFile = fso.GetFile(logFilePath)
' ��������� ������ �����
fileSize = logFile.Size
' �������� ������ �����
If fileSize > maxSize Then
' ������������ � ���
WriteToLog "����� ���-����� �������� ���������� ��� (" & maxSize
& " ����)."
End If
Else
' ������������ � ��� ��� ��������� �����
WriteToLog "���� ���� �� ��������: " & logFilePath
End If
' ��������� �������
Set fso = Nothing
End Function



' ������� ��� ��������� ���������� ��� �����
Function GetDiskSpaceInfo()
Dim objWMIService, colDisks, objDisk, info
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
Dim logMessage
' ϳ��������� �� WMI
Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set colDisks = objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk")
' ������ �����
For Each objDisk In colDisks
' ��������� ���������� ��� ����
info = "���� " & objDisk.DeviceID & ": " & FormatSize(objDisk.FreeSpace)
& " ����� � " & FormatSize(objDisk.Size)
' ����� ���������� ��� ���� � ���
WriteToLog info
Next
' ��������� �������
Set objWMIService = Nothing
Set colDisks = Nothing
Set fso = Nothing
End Function
' ������� ��� ������������ ������ � ������� ��� ������� ������
Function FormatSize(size)
Dim units : units = Array("�", "��", "��", "��", "��")
Dim i : i = 0
Do While size >= 1024 And i < UBound(units)
size = size / 1024
i = i + 1
Loop
FormatSize = Round(size, 2) & " " & units(i)
End Function



' ������� ��� ��������� ������� systeminfo �� ������ ���������� � ����
Sub ExecuteSystemInfo()
Dim objShell, objFSO, objFile, strCommand, strOutputFile
' ��������� ��'���� Shell �� FileSystemObject
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
' ���������� ������� systeminfo �� ����� �� ��������� �����
strCommand = "cmd /c systeminfo"
strOutputFile = "systeminfo_" & FormatDateTime(Now, 1) & ".txt"
' ��������� ������� systeminfo �� ����� ���������� � ����
objShell.Run strCommand & " > " & strOutputFile, 0, True
' ��������, �� ���� �������� ����
If objFSO.FileExists(strOutputFile) Then
WScript.Echo "���������� ������� systeminfo �������� � ����: " &
strOutputFile
Else
WScript.Echo "�� ������� �������� ���������� ������� systeminfo � ����."
End If
' ��������� �������
Set objShell = Nothing
Set objFSO = Nothing
End Sub



Dim objShell
Set objShell = CreateObject("WScript.Shell")
' ���� �� VBScript �����
scriptPath = "script.vbs"
' ������� ��� ��������� �������� � ������������� �������
taskCommand = "schtasks /create /sc daily /tn MyTask /tr """ & scriptPath & """
/st 09:00"
' ��������� �������
objShell.Run taskCommand, 0, True
