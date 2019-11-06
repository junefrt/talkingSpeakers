#     *talkingSpeakers*, 2018

> Pour exécuter le programme, une clé .json permettant d'accéder à l'API Cloud Speech-to-text est nécessaire. 
Pour des raisons de sécurité, cette clé n'est pas accessible. 
Il est possible de créer un compte à partir de cette page (https://cloud.google.com/speech-to-text/?hl=fr) afin de générer une nouvelle clé. 


## Exécution de l'œuvre

1. Ouvrir le Terminal et se placer dans le dossier `talkingspeakers/` ;
2. Taper les commandes suivantes pour installer les modules nécessaires : 
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

nvm install 9.3.0

rm -rf node_modules

npm install —save @google-could/speech grpc yargs > node-record-lpcm16
```
3. Enfin, pour exécuter le programme taper la commande : 
```
./talkingspeaker.sh ./[clé.json]
```

## Arborescence du programme

talkingspeakers/ <br>
+-- data/ <br>
|   +-- firstPhrase.txt — *phrase de démarrage*. <br>
|   +-- saves.txt — *catalogues des phrases préférées de Google.* <br>
+-- speech2text/ <br>
|   +-- recognize.js — *script pour transcrire la parole en texte.* <br>
+-- tts/ <br>
|   +-- tts.js — *script pour utiliser la voix de Google Traduction.* <br>
+-- talkingSpeaker-*.json — *clé .json.* <br>
+-- talkingspeaker.sh — *script du processus global de l'œuvre.* <br>
+-- tts.mp3 — *fichier audio de la dernière phrase analysée et diffusée.* 
