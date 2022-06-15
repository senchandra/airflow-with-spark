# airflow-with-spark
Docker build files for airflow-with-spark along with a sample spark DAG and spark-submit job. Airflow runs end to end seamlessly with spark 2.4.8.

# Pre-requisites
Docker and docker-compose should be installed

# Build steps
Clone the repo, and run the build.sh file. This will create an image airflow:latest and will start the container.

# List of programs running
1. Spark standalone cluster manager (Master and slave). Spark UI at port 8080 and spark master at spark://127.0.1.1:7077
2. Airflow webserver (Running on port 8089)
3. Airflow scheduler

# Running the sample spark job
This is a simple DAG with a simple wordcount spark job.
1. Open the Airflow webserver (localhost:8089). Login using credentials username-admin, password-admin.
2. Allow all the DAG(s) to be loaded as DAG refreshing takes some time. The sample DAG is under the name 'sparkoperator_demo' which requires a spark connection to be made with the connection id as 'spark_local'.
3. Open Connections under Admin tab. Click on 'Create a new Record' (+ button). Enter the details below in Connection configuration and then click on Save:
   a. Connection Id - spark_local
   b. Connection Type - spark
   c. Host - spark://127.0.1.1
   d. Port - 7077
4. Go to DAGs tab. Click on sparkoperator_demo. Toggle to the Pause button to Unpause. Click on the Play button on the right selecting the dropdown option 'Trigger DAG'.
5. Toggle the 'Auto Refresh' button to see the progress. Click on 'Graph' -> 'spark_submit_task' -> 'Log' to see the spark logs.
6. While the DAG and spark job is running, spark application is registerd in the cluster manager which can be observed in Spark UI at localhost:8080.
7. To add further DAGs, add your python dag file in /root/airflow/dags/ folder inside the container.. DAG auto registers and upon refreshing the Airflow UI at loclahost:8089 can be seen under DAGs tab. It may not be visible if there is any error in dag file, which would be observed in Airflow UI or thorugh the command 'airflow dags list' inside the container.
