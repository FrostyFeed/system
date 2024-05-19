If WScript.Arguments.Count <> 6 Then
WScript.Echo "Неправильна кількість аргументів. Перевірте вхідні дані."
WScript.Quit 1
End If
' Встановлення значень аргументів
Arg1 = WScript.Arguments(0)
Arg2 = WScript.Arguments(1)
Arg3 = WScript.Arguments(2)
Arg4 = WScript.Arguments(3)
Arg5 = WScript.Arguments(4)
Arg6 = WScript.Arguments(5)

' Отримання ім'я файлу з першого аргументу
fileName = WScript.Arguments(0)
' Створення об'єкту для роботи з файловою системою
Set fso = CreateObject("Scripting.FileSystemObject")
' Перевірка існування файлу
If Not fso.FileExists(fileName) Then
' Створення файлу, якщо він не існує
Set logFile = fso.CreateTextFile(fileName, True)
' Запис поточної дати та часу у файл
logFile.WriteLine "Дата і час: " & Now
logFile.WriteLine "Файл з ім'ям " & fileName & " відкрито або створено."
logFile.Close
WScript.Echo "Файл '" & fileName & "' створено."
Else
' Дописування у файл, якщо він вже існує
Set logFile = fso.OpenTextFile(fileName, 8, True)
logFile.WriteLine "Дата і час: " & Now
logFile.WriteLine "Файл з ім'ям " & fileName & " відкрито або створено."
logFile.Close
WScript.Echo "Файл '" & fileName & "' вже існує. Дані додано."
End If

' Запуск зовнішньої команди для оновлення часу з NTP серверу
Set objShell = CreateObject("WScript.Shell")
objShell.Run "w32tm /resync"
' Отримання поточного часу
currentTime = Now
' Отримання ім'я файлу з другого аргументу
fileName = WScript.Arguments(1)
' Відкриття або створення файлу log
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(fileName, 8, True)
' Запис поточного часу у файл log
logFile.WriteLine "Поточний час: " & currentTime
' Закриття файлу log
logFile.Close

' Отримання ім'я файлу з другого аргументу
fileName = WScript.Arguments(1)
' Відкриття або створення файлу log
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(fileName, 8, True)
' Вивід списку усіх запущених процесів у файл log
Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("tasklist")
Do Until objExec.StdOut.AtEndOfStream
strLine = objExec.StdOut.ReadLine
logFile.WriteLine strLine
Loop
' Закриття файлу log
logFile.Close

' Отримання третього аргументу - імені процесу для завершення
processName = WScript.Arguments(2)
' Відкриття або створення файлу log
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(fileName, 8, True)
' Завершення процесу
Set objShell = CreateObject("WScript.Shell")
objShell.Run "taskkill /F /IM " & processName, 0, True
' Запис інформації про завершення процесу у файл log
logFile.WriteLine "Завершено процес з ім'ям " & processName
' Закриття файлу log
logFile.Close

' Отримання другого аргументу - шляху до файлів для видалення
Dim folderPath
folderPath = WScript.Arguments(1)
' Створення об'єкту FileSystemObject
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
' Лог файл
Dim logFilePath
logFilePath = WScript.Arguments(0)
' Відкриття лог файлу для дописування
Dim logFile
Set logFile = fso.OpenTextFile(logFilePath, 8, True)
' Логіка видалення файлів
Dim deletedCount
deletedCount = 0
deletedCount = deletedCount + DeleteFiles(folderPath, ".TMP")
deletedCount = deletedCount + DeleteTempFiles(folderPath, "temp")
' Запис кількості видалених файлів у лог файл
logFile.WriteLine "Кількість видалених файлів: " & deletedCount
' Закриття лог файлу
logFile.Close
' Підпрограма для видалення файлів з певним розширенням
Function DeleteFiles(folderPath, extension)
Dim folder, file, files
Set folder = fso.GetFolder(folderPath)
Set files = folder.Files
Dim count
count = 0
For Each file in files
If LCase(fso.GetExtensionName(file.Name)) = LCase(extension) Then
file.Delete True ' True - видалити файл без запиту підтвердження
count = count + 1
End If
Next
DeleteFiles = count
End Function
' Підпрограма для видалення файлів з певним початком імені
Function DeleteTempFiles(folderPath, startName)
Dim folder, file, files
Set folder = fso.GetFolder(folderPath)
Set files = folder.Files
Dim count
count = 0
For Each file in files
If LCase(Left(file.Name, Len(startName))) = LCase(startName) Then
file.Delete True ' True - видалити файл без запиту підтвердження
count = count + 1
End If
Next
DeleteTempFiles = count
End Function

' Отримання третього аргументу - шляху до архіву
Dim archivePath
archivePath = WScript.Arguments(2)
' Створення об'єкту для роботи з Shell
Dim objShell
Set objShell = CreateObject("Shell.Application")
' Стискаємо файли
ZipFiles archivePath, WScript.Arguments(1)
' Підпрограма для стискання файлів
Sub ZipFiles(archivePath, folderPath)
Dim sourceFolder, files, file
Set sourceFolder = objShell.NameSpace(folderPath)
Set files = sourceFolder.Items
objShell.Namespace(archivePath & ".zip").CopyHere files
End Sub


'Отримання четвертого аргументу - шляху до папки для переписування архіву
Dim destinationFolder
destinationFolder = WScript.Arguments(3)
' Переписування архіву
CopyFile WScript.Arguments(2) & ".zip", destinationFolder
' Підпрограма для копіювання файлу
Sub CopyFile(sourceFile, destFolder)
Dim objFSO
Set objFSO = CreateObject("Scripting.FileSystemObject")
objFSO.CopyFile sourceFile, destFolder & "\", True
End Sub

 'Перевірка чи існує архів за минулий день
Dim yesterdayArchivePath
yesterdayArchivePath = destinationFolder & "\" & FormatDateTime(Date - 1, 2) & ".zip"
Dim objFSO
Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists(yesterdayArchivePath) Then
WriteToLog "Знайдено архів за минулий день: " & yesterdayArchivePath
Else
WriteToLog "Архів за минулий день не знайдено"
SendEmail "user@example.com", "Відсутній архів за минулий день", "Архів за минулий день відсутній."
End If
' Підпрограма для запису в лог
Sub WriteToLog(logMessage)
Dim logFile, fso, ts
Set fso = CreateObject("Scripting.FileSystemObject")
Set logFile = fso.OpenTextFile(WScript.Arguments(1), 8, True)
logFile.WriteLine Now & " - " & logMessage
logFile.Close
End Sub
' Підпрограма для відправки електронного листа
Sub SendEmail(emailAddress, subject, body)
Dim objEmail
Set objEmail = CreateObject("CDO.Message")
' Налаштування відправника та отримувача
objEmail.From = "vlad.negerey1@google.com"
objEmail.To = emailAddress
objEmail.Subject = subject
objEmail.TextBody = body
' Налаштування SMTP сервера
objEmail.Configuration.Fields.Item
("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objEmail.Configuration.Fields.Item
("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.example.com"
objEmail.Configuration.Fields.Item
("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
objEmail.Configuration.Fields.Update
' Відправлення листа
objEmail.Send
End Sub



' Перевіряє, чи є за шляхом Аргумент4 архіви, старші 30 днів, та якщо є, то
видаляє. Інформує в log.
Sub DeleteOldArchives(folderPath)
' Створення об'єкта для роботи з файловою системою
Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")
' Перелік усіх файлів у папці
Dim objFolder : Set objFolder = objFSO.GetFolder(folderPath)
Dim objFiles : Set objFiles = objFolder.Files
' Поточна дата
Dim currentDate : currentDate = Now
' Кількість днів, які вважаються застарілими
Const DAYS_THRESHOLD = 30
' Перегляд усіх файлів у папці
For Each objFile In objFiles
' Перевірка, чи файл є архівом .zip
If LCase(objFSO.GetExtensionName(objFile.Name)) = "zip" Then
' Обчислення різниці у датах (кількість днів)
Dim daysDifference : daysDifference = DateDiff("d",
objFile.DateLastModified, currentDate)
' Якщо файл старший за визначений поріг, видаляємо його
If daysDifference > DAYS_THRESHOLD Then
objFSO.DeleteFile objFile.Path, True ' Видалення файлу
WriteToLog "Видалено застарілий архів: " & objFile.Name
End If
End If
Next
End Sub


 'Перевіряє, чи є підключення до Internet, та інформує в log.
Sub CheckInternetConnection()
' Створення об'єкта для виконання HTTP-запитів
Dim objHTTP : Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
' URL-адреса для перевірки доступності Інтернету
Dim url : url = "http://www.google.com"
' Виконання HTTP-запиту за вказаною URL-адресою
objHTTP.Open "GET", url, False
objHTTP.send
' Перевірка статусу HTTP-відповіді
If objHTTP.Status = 200 Then
WriteToLog "Підключення до Інтернету є."
Else
WriteToLog "Немає підключення до Інтернету."
End If
End Sub


' Перевіряє наявність комп'ютера з вказаною IP-адресою у локальній мережі та
завершує його роботу.
Sub CheckAndShutdownComputer(ipAddress)
' Виконання команди ping для перевірки доступності комп'ютера з вказаною IP-
адресою
Dim command : command = "ping -n 1 " & ipAddress
Dim shell : Set shell = CreateObject("WScript.Shell")
Dim pingResult : pingResult = shell.Run(command, 0, True)
' Перевірка результату виконання команди ping
If pingResult = 0 Then
WriteToLog "Комп'ютер з IP-адресою " & ipAddress & " знайдено у мережі.
Завершення роботи..."
' Виконання команди для завершення роботи комп'ютера
shell.Run "shutdown -s -f -t 0", 0, True
Else
WriteToLog "Комп'ютер з IP-адресою " & ipAddress & " не знайдено у
мережі."
End If
End Sub



' Отримує список комп'ютерів у мережі та записує отриману інформацію у log.
Sub GetNetworkComputers()
' Виконання команди arp -a для отримання списку комп'ютерів у мережі
Dim shell : Set shell = CreateObject("WScript.Shell")
Dim command : command = "arp -a"
Dim result : result = shell.Exec(command)
' Зчитування результату виконання команди та запис у log
While Not result.StdOut.AtEndOfStream
Dim line : line = result.StdOut.ReadLine
WriteToLog line
Wend
WriteToLog "Список комп'ютерів у мережі успішно отримано."
End Sub

 'Функція для перевірки доступності комп'ютера за IP адресою
Function CheckComputerAvailability(ipAddress)
Dim objShell : Set objShell = CreateObject("WScript.Shell")
Dim objPing : Set objPing =
GetObject("winmgmts:{impersonationLevel=impersonate}").ExecQuery("select * from Win32_PingStatus where address = '" & ipAddress & "'")
For Each objResult In objPing
If IsObject(objResult) Then
If objResult.StatusCode = 0 Then
' Комп'ютер доступний у мережі
CheckComputerAvailability = True
Else
' Комп'ютер не доступний у мережі
CheckComputerAvailability = False
End If
End If
Next
End Function
' Функція для запису повідомлення у лог
Sub WriteToLog(message)
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
Dim logFile : Set logFile = fso.OpenTextFile("lab.log", 8, True)
logFile.WriteLine Now & " " & message
logFile.Close
End Sub
' Читання IP адресів з файлу
Dim ipFile : Set ipFile =
CreateObject("Scripting.FileSystemObject").OpenTextFile("ipon.txt", 1)
Dim ipAddress : ipAddress = ipFile.ReadAll
ipFile.Close
' Перетворення рядка в масив IP адрес
Dim ipAddresses : ipAddresses = Split(ipAddress, vbCrLf)
' Перевірка доступності кожного IP адресу
Dim availableComputers : availableComputers = ""
Dim unavailableComputers : unavailableComputers = ""
For Each ip In ipAddresses
If CheckComputerAvailability(ip) Then
availableComputers = availableComputers & ip & vbCrLf
Else
unavailableComputers = unavailableComputers & ip & vbCrLf
End If
Next
' Запис до лог файлу
WriteToLog "Доступні комп'ютери:"
WriteToLog availableComputers
WriteToLog "Недоступні комп'ютери:"
WriteToLog unavailableComputers



' Функція для перевірки розміру лог файлу
Function CheckLogFileSize(logFilePath, maxSize)
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
Dim logFile, fileSize
' Перевірка наявності файлу
If fso.FileExists(logFilePath) Then
' Отримання об'єкта файлу
Set logFile = fso.GetFile(logFilePath)
' Отримання розміру файлу
fileSize = logFile.Size
' Перевірка розміру файлу
If fileSize > maxSize Then
' Інформування в лог
WriteToLog "Розмір лог-файлу перевищує допустимий ліміт (" & maxSize
& " байт)."
End If
Else
' Інформування в лог про відсутність файлу
WriteToLog "Файл логу не знайдено: " & logFilePath
End If
' Звільнення ресурсів
Set fso = Nothing
End Function



' Функція для отримання інформації про диски
Function GetDiskSpaceInfo()
Dim objWMIService, colDisks, objDisk, info
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
Dim logMessage
' Підключення до WMI
Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set colDisks = objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk")
' Перебір дисків
For Each objDisk In colDisks
' Отримання інформації про диск
info = "Диск " & objDisk.DeviceID & ": " & FormatSize(objDisk.FreeSpace)
& " вільно з " & FormatSize(objDisk.Size)
' Запис інформації про диск у лог
WriteToLog info
Next
' Звільнення ресурсів
Set objWMIService = Nothing
Set colDisks = Nothing
Set fso = Nothing
End Function
' Функція для форматування розміру у зручний для читання вигляд
Function FormatSize(size)
Dim units : units = Array("Б", "КБ", "МБ", "ГБ", "ТБ")
Dim i : i = 0
Do While size >= 1024 And i < UBound(units)
size = size / 1024
i = i + 1
Loop
FormatSize = Round(size, 2) & " " & units(i)
End Function



' Функція для виконання команди systeminfo та запису результату у файл
Sub ExecuteSystemInfo()
Dim objShell, objFSO, objFile, strCommand, strOutputFile
' Створення об'єктів Shell та FileSystemObject
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
' Формування команди systeminfo та шляху до вихідного файлу
strCommand = "cmd /c systeminfo"
strOutputFile = "systeminfo_" & FormatDateTime(Now, 1) & ".txt"
' Виконання команди systeminfo та запис результату у файл
objShell.Run strCommand & " > " & strOutputFile, 0, True
' Перевірка, чи було створено файл
If objFSO.FileExists(strOutputFile) Then
WScript.Echo "Результати команди systeminfo записано у файл: " &
strOutputFile
Else
WScript.Echo "Не вдалося записати результати команди systeminfo у файл."
End If
' Звільнення ресурсів
Set objShell = Nothing
Set objFSO = Nothing
End Sub



Dim objShell
Set objShell = CreateObject("WScript.Shell")
' Шлях до VBScript файлу
scriptPath = "script.vbs"
' Команда для створення завдання у Планувальнику завдань
taskCommand = "schtasks /create /sc daily /tn MyTask /tr """ & scriptPath & """
/st 09:00"
' Виконання команди
objShell.Run taskCommand, 0, True
