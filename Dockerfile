FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y --no-install-recommends gnupg net-tools openssh-server openjdk-8-jdk nano curl wget libmysqlclient-dev libssl-dev libkrb5-dev

RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com/ --recv-keys BA6932366A755776 && \
    apt-get update
RUN apt-get install -y --no-install-recommends python3.7 python3.7-distutils
RUN ln -s /usr/bin/python3.7 /usr/bin/python && \
    ln -s /usr/bin/python3.7 /usr/bin/python3
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

ENV SPARK_HOME /opt/spark
ENV PATH $PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON=python3
RUN wget -O - "https://archive.apache.org/dist/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz" \
  | gunzip \
  | tar x -C /opt/ \
  && mv /opt/spark-2.4.8-bin-hadoop2.7 /opt/spark

ENV AIRFLOW_HOME /root/airflow
RUN pip3 install apache-airflow typing_extensions pyspark==2.4.8 && \
    pip3 install apache-airflow-providers-apache-spark
RUN mkdir -p /root/airflow/dags
COPY sample_files/sparkoperator_demo.py /root/airflow/dags/sparkoperator_demo.py
COPY sample_files/sparksubmit_basic.py /tmp/sparksubmit_basic.py
COPY sample_files/wordcount.txt /tmp/wordcount.txt

RUN airflow db init && \
    airflow users create --role Admin --username admin --firstname Admin --lastname . --email admin@abc.com --password admin

#RUN apt-get install -y --no-install-recommends supervisor && \
#    mkdir /var/log/supervisor
RUN pip3 install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
