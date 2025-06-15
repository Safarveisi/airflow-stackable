FROM oci.stackable.tech/sdp/spark-k8s:3.5.5-stackable25.3.0

RUN curl -L -O http://search.maven.org/remotecontent?filepath=org/apache/ivy/ivy/2.5.3/ivy-2.5.3.jar

# Jar dependencies
RUN java -Divy.cache.dir=/tmp -Divy.home=/tmp -jar ivy-2.5.3.jar -notransitive \
-dependency org.apache.iceberg iceberg-spark-runtime-3.5_2.12 1.9.1 \
-retrieve "/stackable/spark/jars/[artifact]-[revision](-[classifier]).[ext]"

RUN java -Divy.cache.dir=/tmp -Divy.home=/tmp -jar ivy-2.5.3.jar -confs compile \
-dependency org.apache.iceberg iceberg-spark-runtime-3.5_2.12 1.9.1 \
-retrieve "/stackable/spark/jars/[artifact]-[revision](-[classifier]).[ext]"

# Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
    pandas scikit-learn
