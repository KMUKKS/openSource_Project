

FormatTime, CurrentDateTime,, yyyy.MM.dd 

FileCreateDir, %A_ScriptDir%\CopyData
FileCreateDir, %A_ScriptDir%\DataBase
FileCreateDir, %A_ScriptDir%\SaveTime

FileAppend, , %A_ScriptDir%\DataBase\%CurrentDateTime%db.txt
FileAppend, , %A_ScriptDir%\CopyData\%CurrentDateTime%.txt
FileAppend, , %A_ScriptDir%\SaveTime\%CurrentDateTime%.txt

read_line_count = 0
write_line_count = 0




^f2::
FormatTime,tempvalue,,yyyyMMdd
tempvalue -= 1
FormatTime,tempvalue,%tempvalue%,yyyy.MM.dd
FileRead,alldata1,%A_ScriptDir%\DataBase\%CurrentDateTime%db.txt
FileRead,alldata2,%A_ScriptDir%\DataBase\%tempvalue%db.txt
MsgBox,%alldata1%%alldata2% 
return

f8::

FileRemoveDir, %A_ScriptDir%\CopyData, 1
FileRemoveDir, %A_ScriptDir%\SaveTime, 1
ExitApp

^c::
Hotkey, ^c, off
send, ^c

FormatTime, SavedTime,, yyyy-MM-dd hh:mm

write_line_count += 1
read_line_count := write_line_count

FileAppend, %Clipboard%`n, %A_ScriptDir%\DataBase\%CurrentDateTime%db.txt
FileAppend, %Clipboard%`n, %A_ScriptDir%\CopyData\%CurrentDateTime%.txt
FileAppend, %SavedTime%`n, %A_ScriptDir%\SaveTime\%CurrentDateTime%.txt

Hotkey, ^c, on


return


^f1::
msgbox, Instruction Manual`n Ctrl+c : Multi-copy and Store text file. `n Ctrl+b : Select copied text using up,down keyboard button `n f8 : Delete copy-file and End the program `n ctrl+f2 : Show all copied text that last 2 days
return


^b::
FileReadLine, Value, %A_ScriptDir%\CopyData\%CurrentDateTime%.txt, read_line_count
FileReadLine, Timecheck, %A_ScriptDir%\SaveTime\%CurrentDateTime%.txt, read_line_count
MouseGetPos,xp,yp
splashtexton, 500, 300,,%value%     %Timecheck%
WinMove,,%value%,%xp%,%yp%
sleep,150
goto, CheckIn



DownBbutton:
if(read_line_count = write_line_count){
  if(write_line_count > 10){
     read_line_count := write_line_count
     read_line_count -= 9
  }else{
     read_line_count = 1
  }
}else{
  read_line_count += 1
}
FileReadLine, Value, %A_ScriptDir%\CopyData\%CurrentDateTime%.txt, read_line_count
FileReadLine, Timecheck, %A_ScriptDir%\SaveTime\%CurrentDateTime%.txt, read_line_count
MouseGetPos,xp,yp
splashtexton, 500, 300,,%value%     %Timecheck%
WinMove,,%value%,%xp%,%yp%
sleep,150
goto, CheckIn



Upbutton:
if((read_line_count = write_line_count-9) || (read_line_count = 1)){
  read_line_count := write_line_count
}else{
  read_line_count -= 1
}
FileReadLine, Value, %A_ScriptDir%\CopyData\%CurrentDateTime%.txt, read_line_count
FileReadLine, Timecheck, %A_ScriptDir%\SaveTime\%CurrentDateTime%.txt, read_line_count
MouseGetPos,xp,yp
splashtexton, 500, 300,,%value%     %Timecheck%
WinMove,,%value%,%xp%,%yp%
sleep,150
goto, CheckIn



  
CheckIn:
while(!GetKeyState("down", "P") || !GetKeyState("up", "P"))
{
  if(GetKeyState("down", "P"))
  {
     goto, DownBbutton
  }else if(GetKeyState("up", "P")){
     goto, Upbutton
  }   
  
  if(!GetKeyState("Ctrl","P"))
  {
     goto, ExitCtrlB
  }
}
  
        
ExitCtrlB:
SplashTextOff
tempVal=Clipboard
Clipboard = %value%
send,^v
Clipboard = %tempVal%
;send, %value%
read_line_count := write_line_count
return
