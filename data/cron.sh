#!/bin/sh 
DIR=/home/sites/policing.justicesos.org/web/htdocs/data
cd $DIR; wget -O data.csv https://data.cityofboston.gov/api/views/fqn4-4qap/rows.csv?accessType=DOWNLOAD && ogr2ogr -f "PGDump" -nln incidents incidents.sql data.csv && psql -d yesonfour -f incidents.sql && rm incidents.sql &&  psql -d yesonfour -f drug.incidents.sql && mv /tmp/incidents.csv .
