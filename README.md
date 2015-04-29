## Kv-008 repository for ecomap project

1. clone this project
2. ```vagrant up```
3. ```vagrant ssh```
4. ```CONFIG_CLASS='api.v1_0.settings.LocalSettings' fab init_db``` for first time usage.
5. ```CONFIG_CLASS='api.v1_0.settings.LocalSettings' ./app.py``` to start app.
6. go to localhost:8001 in your browser
