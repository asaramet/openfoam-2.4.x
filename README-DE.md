# Docker-Image für OpenFOAM 2.4.x mit OpenMPI 1.6.5 und Debian 8.11-slim
## Testing und Aktualisierung von Legacy-Code

Suchen Sie eine einfache Möglichkeit, Ihren Legacy-OpenFOAM 2.4.x-Code auf neuen Systemen auszuführen und zu testen? Suchen Sie nicht weiter! Stellen Sie das OpenFOAM 2.4.x Docker-Image vor, das entwickelt wurde, um die Herausforderungen der Installation der veralteten Version auf neuen Systemen zu adressieren. Dieses Image ermöglicht einfaches Testen alter Code und Aktualisieren auf neuere Versionen.

### Wie man das Image verwendet

1. Laden Sie das Image mit dem folgenden Befehl herunter:
```
docker image pull asaramet/openfoam-2.4.x
```

2. Erstellen Sie einen Container und mounten Sie Ihren lokalen Ordner mit dem Container mit der Option "-v". Zum Beispiel, um das aktuelle Arbeitsverzeichnis zu mounten:
```
docker run -v $(pwd):/OpenFOAM -it asaramet/openfoam-2.4.x
```

Um den lokalen Ordner `/path/to/local/folder` in das Verzeichnis `/OpenFOAM` des Containers zu mounten:
```
docker run -v /path/to/local/folder:/OpenFOAM -it asaramet/openfoam-2.4.x
```
Dadurch können Sie auf die Dateien im gemounteten lokalen Ordner innerhalb des Containers zugreifen und auch Änderungen, die innerhalb des Containers vorgenommen werden, werden im lokalen Ordner widergespiegelt.

Durch Verwenden der Option `-v` erstellen Sie ein Volume, eine Möglichkeit, Daten außerhalb des Dateisystems des Containers zu speichern. Dadurch können Sie die Daten auch dann behalten, wenn der Container gelöscht oder neu erstellt wird.

In diesem Beispiel wird der lokale Ordner `/path/to/local/folder` in das Verzeichnis `/OpenFOAM` im Container gemountet. Sie können den lokalen Ordner und das Verzeichnis des Containers entsprechend Ihren Anforderungen angeben.

Bitte beachten Sie, dass der lokale Ordner vor Ausführen des Befehls vorhanden sein sollte, der `/path/to/local/folder` sollte durch den vollständigen Pfad des lokalen Ordners ersetzt werden, den Sie mounten möchten.

3. Sobald Sie im Container sind, initialisieren Sie die OpenFOAM-Umgebungsvariablen mit dem Befehl:
```
foamInit
```

4. Um den Container zu verlassen, verwenden Sie den Befehl `exit`. Um einen laufenden Container erneut zu betreten, können Sie die folgenden Befehle verwenden:
```
# Erhalten Sie die Container-ID
docker container ls -a

# Starten Sie den Container interaktiv
docker start -ai <CONTAINER ID>
```