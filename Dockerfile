FROM quay.io/openshifthomeroom/workshop-terminal:3.0.1

# Install basic packages
RUN source scl_source enable rh-python36 && \
    source /opt/app-root/bin/activate && \
    pip install boto3 && \
    fix-permissions /opt/app-root

## Install aws cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip" && \
    mkdir /tmp/aws-bin && \
    unzip /tmp/awscli-bundle.zip -d /tmp/aws-bin && \
    /tmp/aws-bin/awscli-bundle/install -i /opt/app-root/aws -b /opt/app-root/bin/aws && \
    aws --version && \
    rm -rf /tmp/aws-bin /tmp/awscli-bundle.zip && \
    fix-permissions /opt/app-root

COPY --chown=default:root agnosticd-runner /opt/app-root/bin/agnosticd-runner

RUN chmod +x /opt/app-root/bin/agnosticd-runner && \
    mkdir -p /opt/app-root/src/.ssh && \
    chmod 600 /opt/app-root/src/.ssh && \
    fix-permissions /opt/app-root

#RUN mkdir -p /runner/config && \
#    chmod -R g+w /runner && chgrp -R root /runner

ENV CONFIG_DIR="/opt/app-root/data"

VOLUME /opt/app-root/data
VOLUME /opt/app-root/src/.ssh

WORKDIR /opt/app-root/src

ENTRYPOINT ["/opt/app-root/bin/agnosticd-runner"]
CMD ["help"]




