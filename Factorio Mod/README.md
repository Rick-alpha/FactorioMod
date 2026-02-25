# Factorio Mod Workspace

Dieses Workspace ist als Startpunkt für deine Factorio-Mod eingerichtet.

## Enthaltene Dateien

- `info.json` – Mod-Metadaten
- `control.lua` – Laufzeitlogik
- `data.lua` – Prototypen-Definitionen
- `settings.lua` – Mod-Settings
- `locale/en/base.cfg` – Lokalisierungstexte

## VS Code Tasks

- **Factorio: Validate info.json**  
  Prüft, ob `info.json` gültiges JSON ist.
- **Factorio: Build ZIP**  
  Baut ein ZIP im Ordner `build/` mit dem Namen `<name>_<version>.zip`.

## Nutzung in Factorio

1. ZIP mit dem Task **Factorio: Build ZIP** erzeugen.
2. ZIP nach `%APPDATA%\\Factorio\\mods` kopieren.
3. Factorio starten und Mod aktivieren.

Alternativ für schnelle Entwicklung kannst du den Workspace-Ordner auch direkt als Mod-Ordner nutzen.

## Sprite Editor (64x64 → 120x64)

Ein einfacher Editor liegt unter `tools/sprite-editor/index.html`.

### Start

- Datei `tools/sprite-editor/index.html` in VS Code öffnen
- Rechtsklick auf die Datei und im Browser öffnen (oder per Live Server)

### Funktionen

- Bearbeitung nur im 64x64-Hauptbild über Raster-Klicks
- Automatische Erzeugung der Varianten 32x32, 16x16 und 8x8
- Layout des finalen Spritesheets: 120x64 (64 links, dann 32/16/8 rechts oben)
- Farbwahl über Color-Picker und Palette
- Pipette zum Aufnehmen einer Farbe aus dem Bild
- Export als PNG (`sprite_120x64.png`)

### Gebäudemodus (96x96)

- Umschaltbar auf `Gebäude (96x96)`
- Exportiert automatisch drei Dateien aus einem 96x96-Source-Sprite:
  - `originalname.png` als 8x4-Raster mit 1712x904
  - `originalname-shadow.png` (schwarz, +2px rechts/+4px unten) als 8x4-Raster mit 1520x660
  - `remants/originalname-remants.png` als 1x3-Raster mit 328x846
