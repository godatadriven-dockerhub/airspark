# Airspark = Apache Airflow + Spark in one Docker container

Airflow docker container based on Python 3.5.

## Running the container
By default airflow --help is run:

```
docker run godatadriven/airspark
```

To run the webserver, try our `upgradedb_webserver` command which first runs upgradedb (inits and upgrades the airflow database) before it starts the webserver

```
docker run godatadriven/airspark upgradedb_webserver
```
