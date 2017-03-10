HADOOP_VERSION=2.7.3
SPARK_VERSION=2.1.0

command -v curl >/dev/null 2>&1 || { echo >&2 "curl is not installed, Installing now"; apt-get -qq update; apt-get -qq -y install curl;}

HADOOP_PREFIX=/usr/local/hadoop
if [ -e $HADOOP_PREFIX ]; then
	echo "Hadoop is already installed";
else
	echo "Downloading Java..."
	if [ ! -e /usr/java/default/ ]; then
		mkdir -p /usr/java/default
		curl -Ls 'http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie' | tar --strip-components=1 -xz -C /usr/java/default/
		export JAVA_HOME=/usr/java/default/jdk1.8.0_121
		export PATH=$PATH:$JAVA_HOME/bin
	fi
	echo "Downloading Hadoop..."
	curl -s http://apache.forsale.plus/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz | tar -xz -C /usr/local/
	cd /usr/local && ln -s ./hadoop-$HADOOP_VERSION hadoop
	echo "Prepareing hadoop..."
	sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/java/default\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
	sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
	echo "Hadoop installed."
fi

SPARK_PREFIX=/usr/local/spark
if [ -e $SPARK_PREFIX ];
	then echo "Spark is already installed";
else
	echo "Downloading Java..."
	if [ ! -e /usr/java/default/ ]; then
		mkdir -p /usr/java/default
		curl -Ls 'http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
		tar --strip-components=1 -xz -C /usr/java/default/
		export JAVA_HOME=/usr/java/default/jdk1.8.0_121
		export PATH=$PATH:$JAVA_HOME/bin
	fi
	echo "Downloading Spark..."
	curl -s http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
	cd /usr/local && ln -s ./spark-$SPARK_VERSION-bin-hadoop2.7 spark
	echo "Spark installed."
fi


