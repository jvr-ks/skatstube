# Skatstube
(Sorry, German language only)

Einfache App zur Eingabe vordefinierter Textsätze im Chatfeld, z. B. bei der [Skatstube]( https://www.skatstube.de/).   
Verwendet **[ ALT ] + [ g ]** als Hotkey.  
  
Weitere Funktionen:  
* Clickhammer
* Inhalts-Alarm
  
#### Letzte Änderungen:
* Koordinaten von "Screen-mode" in "Client-mode" geändert.   
Dazu muss natürlich die Skatstube App temporär in den Hintergrund gebracht werden.  
* Inhalts-Alarm
* "Select Set" aus Menü entfernt  
* clickhammerDelayDefault in Config-Datei ("skatstube.ini")  
Delay (Mikrosekunden) zwischen den Clicks  
* [timer60/5] oder [timer120/5]  
Sendet:  
Bitte 1 Minute Pause ...  
Pause (1 min), noch: 55 s  
Pause (1 min), noch: 50 s  
Pause (1 min), noch: 45 s  
Pause (1 min), noch: 40 s  
...  
* Es gibt jetzt 3 "Sets", jeweils mit einem eigenen Datensatz (in der Datei "skatstube1(2,3).txt"),  
sowie eigenen Einfügekoordinaten: chatfield1(2,3)PosX und chatfield1(2,3)PosY  -> Config-Datei ("skatstube.ini")  
(Menü: Koordinaten -> Eingabe-Koordinaten neu erfassen)  
  
Umschaltung per "Select Set" Tasten.  
Bei Umschaltung wird zusätzlich der Hintergrund eingefärbt.  
  
#### Beschreibung:
**Das Menü wird erst durch betätigen der Hotkey-Tasten-Kombination angezeigt.**  
(Nach dem Start läuft die App immer im Hintergrund!)  
   
Durch Auswahl eines Satzes im Menü per Klick, wird dieser in das Chatfeld eingetragen.  
  
Wird gleichzeitig die [Umschalt]-Taste gedrückt, kann der Satz stattdessen bearbeitet werden.  
  
Die Sätze werden in den Dateien "skatstube1(2,3).txt" (im gleichen Ordner) gespeichert.  
    
Die Position des Chatfeldes wird einmalig Menü -> Koordinaten (3 Werte, abhängig von "Select set") neu erfasst,  
und in der Config-Datei gespeichert.   
**Dazu muss der Startordner beschreibbar sein!**  
Die Config-Datei kann als Startparameter angegeben werden, ohne Angabe wird "skatstube.ini" verwendet.  
  
##### Besonderheiten:  
* Ein Unterstrich als letztes Zeichen verhindert das Abschicken/Eingabe des Satzes, sodass noch Anfügungen oder Änderungen durchgeführt werden können.   
* Durch das Eintragen über die Zwischenablage kann der gewählte Satz auch manuell an beliebiger Position mittels **[ STRG ] + [ v ]** eingefügt werden.  
* Befehl "Clickhammer" sendet laufend Mausklicks (Um an einen Tisch in der "Kneipe" zu gelangen).  
Koordinaten-Wechsel ist mit gedrückter [UMSCHALT] Taste möglich.  
  
Portabel, keine Installation erforderlich.  
  
##### Download  
Download from github  
benötigt:  
[skatstube.exe](https://github.com/jvr-ks/skatstube/raw/master/skatstube.exe)  
[skatstube.ini](https://github.com/jvr-ks/skatstube/raw/master/skatstube.ini)  
[alarm.mp3](https://github.com/jvr-ks/skatstube/raw/master/[alarm.mp3])  
  
optional:  
[skatstube1.txt](https://github.com/jvr-ks/skatstube/raw/master/skatstube1.txt)  
[skatstube2.txt](https://github.com/jvr-ks/skatstube/raw/master/skatstube2.txt)  
[skatstube3.txt](https://github.com/jvr-ks/skatstube/raw/master/skatstube3.txt)  
[alarm.ahk](https://github.com/jvr-ks/skatstube/raw/master/alarm.ahk)  


##### Inhalts-Alarm  
Testet ein 10 x 10 Pixel großes Feld unter dem Cursor.  
Sobald sich der Inhalt ändert (Mittelwert der Farben)  
wird ein Alarm ausgelöst (Datei: "alarm.mp3" wird abgespielt).  
Falls eine Datei "alarm.ahk" existiert (Datei in der Config-Datei definiert: "alarmScript" ),  
wird sie zusätzlich ausgeführt.  
(Dazu ist ein installiertes Autohotkey erforderlich!)  


Virus check siehe unten. 
  
#### Weitere benötigte Dateien  
* skatstube1(2,3).txt (UTF-8 kodiert)  
* skatstube.ini Config-Datei (UTF-8 kodiert)  
  
Die Datei "skatstube.txt" ist mit dem Windows-Editor zu bearbeiten, besser jedoch ist **[Notepad ++](https://notepad-plus-plus.org/)**  
   
In der Config-Datei befindet sich neben den Koordinaten noch ein Eintrag,  
der den Pfad zu Notepad als Parameter "notepadpath" angibt, default ist Notepad++ 64 bit.  
  
#### Requirements  
* Windows 10 or later only.  
  
#### Quellcode: [Autohotkey](https://www.autohotkey.com) script  
* skatstube.ahk  
  
#### License: MIT  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:  
  
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.  
  
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.  
  
Copyright (c) 2020 J. v. Roos  
  
##### Virus check at Virustotal 
[Check here](https://www.virustotal.com/gui/url/ba1f78c8a3d1b808c93a09bba74e7ed7012c0b2d2e27aff7ab755e173fc17869/detection/u-ba1f78c8a3d1b808c93a09bba74e7ed7012c0b2d2e27aff7ab755e173fc17869-1625252112
)  
Use [CTRL] + Click to open in a new window! 
