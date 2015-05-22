####For import dump you need to run in command line(vagrant needed):
 * Go in ecomap folder;
 * For creating database use:
 ```
 fab create_database

 Choose database (default "test_db"): <set db or default>

 ```
 * For dump import
 ```
 fab import_dump

 Choose database (default "test_db"): <set db or default>
 Dump name(only name): <example: ecomap_db_dump>
 ```