#this line starts using the official python image with interpreter and basic dependencies 
FROM python:3
#This line allows us to see error messages where stdout is used for generating log msgs
ENV PYTHONUNBUFFERED 1
#makes the dir along with parents if needed
RUN mkdir -p /opt/services/flaskapp/src
#copies the requirements.txt file from the host into the container
COPY requirements.txt /opt/services/flaskapp/src/
#Sets working dir so all following cmds are executed from this dir
WORKDIR /opt/services/flaskapp/src
#Run pip install in the container to install all the packages in requirements text file
RUN pip install -r requirements.txt
#copy all files from host dir into container
COPY . /opt/services/flaskapp/src
#container listens on port 5001 at runtine, TCP is default. Note that this doesn't actually publish the port
#to actually publish port must use -p flag on docker run to publish and map to this port
EXPOSE 5000
#this runs the python app.py command in the container
CMD ["python", "app.py"]

