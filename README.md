## Kv-008 repository for ecomap project

1. clone this project
2. ```vagrant up```
3. ```vagrant ssh```
4. ```cd /ecomap```
5. ```fab init_db populate_db:n```  where n is a number of records in each database, to create and populate DB
6. ```python app.py``` or ```./app.py``` to start app.
7. go to localhost:8000 in your browser
