docker-compose up -d db
docker-compose run --rm flaskapp #!/bin/bash -c "cd /opt/services/flaskapp/src && python -c 'import database; database.init_db()'"

docker-compose up -d

<--------------------------------------------------->

To manually bootstrap the database:

1. build the image:
docker-compose up -d boot_db

2. run the boot_db image; docker-compose.yml file is configured to open a bash shell on run 
docker-compose run boot_db

3. In the bash shell (workdir is /opt/services/flaskapp/src), run the following command:
python -c 'import database; database.init_db()'

4. The db has now been bootstrapped with the correct tables; exit the bash shell with the 'exit' command.
exit 