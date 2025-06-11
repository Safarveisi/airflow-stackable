FROM oci.stackable.tech/sdp/spark-k8s:3.5.5-stackable25.3.0

# Install Pyspark job dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
    pandas scikit-learn
