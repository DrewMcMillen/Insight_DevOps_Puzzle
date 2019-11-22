# Insight DevOps Engineering Systems Puzzle

## General Notes

After installing the docker engine and docker-compose, the first step was to try bootstrapping the datbaase and builidng all of the images in order to see if the website would load. Since I'm using Windows, the localhost:8080 address didn't work;
I had to use the command $docker-machine ip default to get the ip address for the virtualbox VM that was running linux.  Once I had done this, I could connect to the NGINX web server, but it was giving a 502 bad gateway error, indicating that the 
Flask app wasn't working.  Since we're using the built in Flask server as the WSGI app server, I changed the proxy_pass port to 5000, as this is the default port for the flask server.  Once I did this, the index page rendered, meaning that the Flask 
server was up and running, but when I tried to enter an item, I received an sqlalchemy error stating that the 'items' table didn't exist, meaning that the database did not bootstrap properly.  I worked around this by creating a new image in the docker-compose
YAML file called boot_db that was identical to the flaskapp image except it is configured to open a bash shell upon running.  From the bash shell, I manually ran python -c 'import database; database.init_db()' which bootstrapped the database properly.  
After this, the items I entered into the form were committing to the database (I checked using the  '$docker-compose exec db psql ' to open a postgresql shell and view the items table using SELECT * FROM items;).  However, the NGINX server did not route 
to the correct URL for the "success" page.  I found that the HOST proxy header was repeated in the NGINX conf file, so I deleted one of them to fix the problem.  

##Specific Bugs

-Initially, the docker-compose run --rm flaskapp /bin/bash -c "cd /opt/services/flaskapp/src && python -c 'import database; database.init_db()'" command would generate an error; I noticed that the #! before /bin/bash was missing, which solved the problem

-I switched the nginx ports in the YAML file to "8080:80" since the first port is the host port and the second is the container port

-I exposed port 5000 instead of 5001 in the Dockerfile since 5000 is the flask default port

-I changed the proxy_pass address to port 5000 on the flaskapp container since that is the flask default port 

-I created another image in the YAML file called boot_db with the following configs added in order to open a bash shell in the container:
entrypoint: /bin/sh 
    stdin_open: true
    tty: true   

-From the bash shell, I ran the following command to manually bootstrap the database tables:
python -c 'import database; database.init_db()'

-the Proxy_Set_Header Host command was repeated in the flaskapp.conf, so I deleted the $http_host one and set the first one to $host:8080

-in the database.py file, I noticed that in the create_engine method, the dialect was specified as 'postgres', which wasn't listed on sqlalchemy.org as a 
valid dialect, so I changed it to 'postgresql'.  

-Finally, the success page returns a string of the results variable, which contains a list of all the query objects from the items table.
However, the list is full of blank spaces and commas, which seems like a bug.  The query seems to be reading the database properly because every time 
I add a new item, another comma appears in the list.  However, I did not have time to figure out how to get sqlalchemy to correctly display the item names
in the browser window, so this bug still needs to be fixed.   
