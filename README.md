# Saarbrücker Forschungstage @ DFKI Spielwiese

Infos und How-to's rund um den Workshop Humanoide Roboter und heuristische
Spiele-KI an den Saarbrücker Forschungstagen.

## Intro

Dieser Workshop bietet eine Einführung in einfache Robotik anhand des humanoiden
Roboter Pepper. Dabei werden grundlegende Algorithmen der künstlichen
Intelligenz KI und Computer Vision CV diskutiert und den Studenten fürs tüfteln
bereitgestellt. Die Teilnehmer können mithilfe der bereitgestellten
Dockerumgebung und ohne grossen Aufwand auf der Plattform ihrer Wahl
programmieren und auf Pepper testen.


## Das DFKI
- see PPT Industry_4_0_talk-2018.pptx: https://cloud.dfki.de/owncloud/index.php/f/53550344
- momentan macht jeder KI
	- gibts über 30 jahre $`\Rightarrow`$ kein newcomer


## Setup

![Model-based Reflex
Agent](https://upload.wikimedia.org/wikipedia/commons/8/8d/Model_based_reflex_agent.png)

Damit Pepper TicTacToe spielen kann, müssen zuerst ein paar Probleme gelöst
werden. Zuerst muss Pepper seine Umgebung - in diesem Fall das Spielfeld, die Magnete und
Züge - erkennen können. Die Umgebung wird in der Anwendung über den Kamera
Sensor wahrgenommen. Das hat zur Folge, dass die Kamerabilder verarbeitet werden
müssen, damit Pepper den Spielstatus weiss und überlegen kann welchen Schritt er
als nächstes ausführen soll. Die Schritte die Pepper ausführt, verändern das
Spiel ebenfalls und sollten in der Berechnung berücksichtigt werden. Mit dem
internen Weltmodell und einfachen Bedingungsregeln findet Pepper heraus, welchen
Zug er als nächstes machen soll. Damit Pepper den Spielzug ausführen kann
braucht er noch Hilfe eines Menschen, da seine Hand weder genug kräftig, noch
genau ist. Deshalb, muss er seine Wünsche über Sprache klar und deutlich
ausdrücken können. Neben Sprache wird in der Anwendung auch auf Körpersprache
gesetzt. Wobei Pepper auf die Position wo sein Magnet gesetzt werden soll zeigt.
Bei Spielende, reagiert Pepper auf 3 verschiedene Spielausgänge mit
verschiedenen Verhalten. Dabei erkennt er ob er gewonnen oder verloren hat oder
das Spiel unentschieden ausgegangen ist.

Ziel wäre es nun, dass ihr alleine oder in Gruppen (je nach interesse)
(zusammen)arbeitet und ein bisschen tüftelt.


## Ideen woran getüftelt werden kann

+ Mach Pepper unbesiegbar
	+ Schau dir die Bedingungsregeln in `TicTacToeAiHeuristic.py` an und
		+ gibt es momentan eine Reihe von Zügen womit du Pepper jedes mal besiegst?
		+ überlege dir was daran verbessert werden könnte
		+ suche nach alternativen Spiel-Strategien
		[//]: # (TODO: Einfaches RL? ML? DL?)

+ Die Bildverarbeitung verbessern
	+ Studiere die CV Pipeline in `DetectBoard.py` und
		+ versuche die Bilderkennung in verschiedenem Licht aus
			+ mithilfe des `DetectBoard.py` kannst du das Resultat nach jedem Schritt
				der Pipeline in einem Bild sehen
			+ welche Schritte werden dabei in welcher Reihenfolge ausgeführt?
			+ spiele mit den Parametern und finde andere (allenfalls bessere) Lösungen
			+ gibt's alternative und/oder bessere Lösungsmöglichkeiten?

+ Andere/Mehr Behaviors und Animationen
	+ Momentan reagiert Pepper nur auf falsche Züge, wenn man versucht zu Cheaten
		oder wenn ein Spiel zu ende ist.
		+ Diese Reaktionen können verändert werden oder
		+ es können neue hinzugefügt werden, bspw.
			+ dass Pepper den Spieler nach 10 Sekunden stichelt
				+ _\#MachMal_
			+ wenn ein guter/schlechter Zug gemacht wurde
				+ _\#IstDasDeinErnst_ _\#MindGames_
			+ eigene Ideen

+ Eigene Idee(n) einbringen :smiley:


## Requirements

Folgende Software muss vorher installiert werden:

+ Docker Engine >= v16 (aktuelle Version v18.09 empfohlen)
	+ Eine Installations-Anleitung für jegliche Betriebssysteme kann auf [Docker
		Docs](https://docs.docker.com/install/) gefunden werden

Verbindung mit dem WLAN:

__SSID__: `PRAF`

__KEY__: `poposoft`


## Entwicklungsanleitung

Damit wir losprogrammieren können, brauchen wir zuerst die Versionsverwaltungs Software `Git`. Eine Installationsanleitung findet ihr unter https://git-scm.com/book/de/v1/Los-geht%E2%80%99s-Git-installieren.

Repo naoqi-opencv-tictactoe-dev von (https://gitlab.enterpriselab.ch/RoboCup/naoqi-opencv-tictactoe-dev) clonen  mittels

```bash
git clone --recurse-submodules -j8 https://gitlab.enterpriselab.ch/RoboCup/naoqi-opencv-tictactoe-dev
```
und in den Ordner hinein navigieren

```bash
cd naoqi-opencv-tictactoe-dev
```

In diesem Folder dann

```bash
docker build -t naoqi-opencv-tictactoe:latest .
```

aufrufen. Dies zieht das Docker Image vom Docker Hub, kopiert den
TicTacToe Folder hinein und setzt die Command `python Main.py` als
Startbefehl.

Daraufhin, kann mit

```bash
docker run -it --network host naoqi-opencv-tictactoe:latest
```

das Python Programm auf Pepper ausgeführt werden.

Wenn in der TicTacToe Anwendung etwas geändert wurde, kann dann einfach mittels den beiden commands

```bash
docker build -t naoqi-opencv-tictactoe:latest .
docker run -it --network host naoqi-opencv-tictactoe:latest
```

der container neu gebaut und ausgeführt werden.

