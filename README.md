# Saarbrücker Forschungstage @ DFKI Spielwiese

Infos und How-to's rund um den Workshop Humanoide Roboter und heuristische
Spiele-KI an den Saarbrücker Forschungstagen.

## Intro

Dieser Workshop bietet eine Einführung in einfache Robotik anhand des humanoiden
Roboter Pepper. Dabei werden grundlegende Algorithmen der künstlichen
Intelligenz KI und Computer Vision CV diskutiert und den Studenten fürs tüfteln
bereitgestellt. Die Teilnehmer können mithilfe der bereitgestellten
Virtuellen Maschine und ohne grossen Aufwand auf der Plattform ihrer Wahl
programmieren und auf Pepper testen.


## Geplantes Verhalten

Es sollte eine Anwendung entwickelt werden, die es ermöglicht gegen Pepper Tic Tac Toe zu spielen. Um ein Spiel zu starten gibt man Pepper sprachlich einen Startbefehl. Danach fordert Pepper den Spieler auf seine Spielzüge zu spielen und wenn Pepper am Zug ist, zeigt er dem Spieler, wo er Peppers Spielstein platzieren soll. Wird ein unerlaubter oder falscher Spielzug erkannt, meldet Pepper dies und fordert den Spieler auf die auf dem Display angezeigte Spielsituation wiederherzustellen. Gewinnt einer der Spieler, verkündet Pepper den Gewinner und wartet auf einen neuen Spielstart, oder das beenden seines Verhaltens. 

## Setup

Damit Pepper TicTacToe spielen kann, müssen zuerst ein paar Probleme gelöst werden. Zuerst muss Pepper seine Umgebung - in diesem Fall das Spielfeld, die Magnete und Züge - erkennen können. 

Die Umgebung wird in der Anwendung über den Kamera Sensor wahrgenommen. Das hat zur Folge, dass die Kamerabilder verarbeitet werden müssen, damit Pepper den Spielstatus weiss und überlegen kann welchen Schritt er als nächstes ausführen soll. Die Schritte die Pepper ausführt, verändern das Spiel ebenfalls und sollten in der Berechnung berücksichtigt werden. 

Mit dem internen Weltmodell und einfachen Bedingungsregeln findet Pepper heraus, welchen Zug er als nächstes machen soll. Damit Pepper den Spielzug ausführen kann braucht er noch Hilfe eines Menschen, da seine Hand weder genug kräftig, noch genau ist. Deshalb, muss er seine Wünsche über Sprache klar und deutlich ausdrücken können. Neben Sprache wird in der Anwendung auch auf Körpersprache gesetzt. Wobei Pepper auf die Position wo sein Magnet gesetzt werden soll zeigt.

Bei Spielende, reagiert Pepper auf 3 verschiedene Spielausgänge mit verschiedenen Verhalten. Dabei erkennt er ob er gewonnen oder verloren hat oder das Spiel unentschieden ausgegangen ist.

### Beschreibung der Umgebung, Aktuatoren, Sensoren und dem Leistungsmass

+ Umgebung
	+ Mitspieler
	+ Magnetwand auf Augenhöhe von Pepper mit vordefiniertem Tic Tac Toe Spielfeld mit roten und blauen Spielsteinen

+ Aktuatoren
	+ Lautsprecher zum kommunizieren
	+ Arme zum nächten Spielzug anzeigen
	+ Display zur besseren Verständigung

+ Sensoren
	+ Mikrofon für Spielstart und -abbruch
	+ Kamera für Fotos der Umgebung und Spielfeldanalyse

+ Leistungsmass
	+ Anzahl korrekt beendeter Spiele messen
	+ Peppers Ziel ist es möglichst viele Spiele zu gewinnen und möglichst wenige zu verlieren

## Lösungsansatz - Agententypen

Als Grundstruktur wird ein Model-based Agent verwendet. Dieser ist so ausgelegt, dass er einem festen Ablauf folgt mit dem Ziel, das Spiel erfolgreich zu beenden.

![Model-based Reflex
Agent](https://upload.wikimedia.org/wikipedia/commons/8/8d/Model_based_reflex_agent.png)

### Ansatz für Spracheingabe für Spielstart / -abbruch

Um ein Spiel starten zu können wird ein Simple Reflex Agent verwendet, welcher die Spracheingabe auswertet und ein Spiel startet, sollten die richtigen Worte für den Spielstart gesagt werden.

![Simple Reflex Agent](https://upload.wikimedia.org/wikipedia/commons/9/91/Simple_reflex_agent.png)

### Ansatz für die Spiellogik

Für die Spiellogik wird ein Utility-based Agent verwendet. Bei diesem kommt als Input das momentane Spielfeld. Aus dem Spielfeld werden alle möglichen Spielzüge berechnet, welche gespielt werden können. 

Für jeden möglichen Spielzug wird dann mithilfe einer 
Heuristik berechnet, wie gut dieser für den Agenten ist. Aus den getätigten Berechnungen wird dann die beste ausgewählt und der dazugehörige Spielzug getätigt. Mithilfe dieses Agenten wird sichergestellt, dass Pepper möglichst viele Spiele gewinnen kann.

#### Heuristik
Eine Art Vermutung, die auf der Grundlage bestimmter Annahmen getroffen werden.
Damit können keine perfekten Ergebnisse garantiert werden aber ist schnell berechnet.


![Utility-based Agent](https://upload.wikimedia.org/wikipedia/commons/d/d8/Model_based_utility_based.png)

Ziel wäre es nun, dass ihr alleine oder in Gruppen (je nach interesse) (zusammen)arbeitet und ein bisschen tüftelt.


## Ideen woran getüftelt werden kann

+ Mach Pepper unbesiegbar
	+ Schau dir die Bedingungsregeln in `TicTacToeAiHeuristic.py` an und
		+ gibt es momentan eine Reihe von Zügen womit du Pepper jedes mal besiegst?
		+ überlege dir was daran verbessert werden könnte
		+ sieh dir auch `TicTacToeAiRand.py` an als alternative Spielstrategie die einfach einen zufälligen Zug zurückgibt
		+ suche nach alternativen Spiel-Strategien
		[//]: # (TODO: Einfaches RL? ML? DL?)

+ Die Bildverarbeitung verstehen und damit experimentieren
	+ Studiere die CV Pipeline in `DetectBoard.py` und
		+ versuche die Bilderkennung in verschiedenem Licht aus
			+ mithilfe des `DetectBoard.py` kannst du das Resultat nach jedem Schritt der Pipeline in einem Bild sehen
			+ welche Schritte werden dabei in welcher Reihenfolge ausgeführt?
			+ spiele mit den Parametern und finde andere (allenfalls bessere) Lösungen
			+ gibt's alternative und/oder bessere Lösungsmöglichkeiten?

+ Andere/Mehr Behaviors und Animationen
	+ Momentan reagiert Pepper nur auf falsche Züge, wenn man versucht zu Cheaten oder wenn ein Spiel zu ende ist
		+ Diese Reaktionen können verändert werden oder
		+ es können neue hinzugefügt werden, bspw.
			+ dass Pepper den Spieler nach 10 Sekunden stichelt
				+ _\#MachMal_
			+ wenn ein guter/schlechter Zug gemacht wurde
				+ _\#IstDasDeinErnst_ _\#MindGames_
			+ eigene Ideen
		+ Denkbar wäre auch ein Erkennen was nicht in Ordnung ist und kommunikation zur Behebung an Spieler

+ Eigene Idee(n) einbringen :smiley:


## Eingesetzte externe Software

	Ubuntu Linux 18.04
		+ Python 2.7
		+ OpenCV 3.4
		+ Entwicklungsumgebung PyCharm 2019.1.3
		+ NAOqi 2.5.10


### Verbindung mit dem WLAN (Verbindung zu Pepper, kein Internet - für Internet siehe Whiteboard):

__SSID__: `linksys`


## Wie weiter

1) Einteilung in Gruppen
2) Jede Gruppe arbeitet klont sich das Git Repository unter https://github.com/kw90/forschungstage-dfki
3) Fragen ist willkommen :)


### Git Repository klonen, Step-by-Step-Anleitung

0) Virtuelle Maschine in VirtualBox importieren und starten
1) Terminal öffnen (`Ctrl+Alt+t`)
2) Ausführen `mkdir source && cd source`
3) PyCharm starten (Shortcut in linker Taskleiste)
4) Im PyCharm-Menü nach Start: Auf `Check out from Version Control` > `Git` klicken
5) Im sich darauf öffnenden Fenster: URL = `https://github.com/kw90/naoqi-opencv-tictactoe.git`, Directory = `/home/masc29/source`
6) Auf `Clone` klicken
7) Im Terminal `cd TicTacToe` ausführen
8) Test ausführen anhand `python Main.py`
9) Das Hauptprogramm sollte starten und folgender Output sollte in der Konsole angezeigt werden
```bash
arms collison protection: True
external collison protection: True
speech configuration done
CONNECTED
   0   0   0
   0   0   0
   0   0   0
speech configuration done
Say ´lets play´ or press enter to start a game.
```

Damit seid ihr ready zum Weiterentwickeln. Damit ihr wisst welche Datei für welche Aufgabe zuständig ist - und somit wo Änderungen gemacht werden müssen wenn ihr etwas hinzufügen wollt - findet ihr im nächsten Kapitel eine Aufteilung.

## Was macht was und was ist wofür zuständig

+ `Main.py`
	+ Ist das Startup File für das Hauptprogramm
	+ Damit werden alle Komponenten gestartet
+ `DetectBoard.py`
	+ Ist die Datei die den Hauptsächlichen Bildverarbeitungscode beinhaltet
		+ Im Ordner image_processing befinden sich zudem noch 3 weitere Hilfsdateien mit Hilfsfunktionen die von `DetectBoard.py` aufgerufen werden
	+ Hierin wird in regelmäßigen Abständen ein Bild von Peppers Front-Kamera geschossen
	+ Das Bild wird in eurer VM unter `/home/masc29/source/TicTacToe/pictures` abgespeichert und daraufhin analysiert
	+ In der Analyse werden Linien auf dem Spielfeld und Kanten der Spielsteine erkannt
	+ Die Farbe eines erkannten Spielsteins wird anhand von Schwellwerten für die Farben Rot und Blau erkannt
+ `TicTacToe.py`
	+ Darin wird die gesamte Spiellogik abgewickelt
	+ `TicTacToeAiHeuristic.py`
		+ Darin befindet sich die Spiellogik bestehend aus klar vordefinierten Bedingungsregeln
	+ Als Alternative zeigt `TicTacToeAiRand.py` eine rein zufällige Spielstrategie




