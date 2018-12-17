FROM 600537240653.dkr.ecr.us-east-1.amazonaws.com/test-repo:latest

RUN rm -rf /app && rm -rf /logs

# Install application
RUN mkdir /app; mkdir /logs
RUN git clone git@github.com:codebuildaws/yii2.git /app && cd /app && git checkout master

# Install application dependencies and build necessary files
RUN cd /app/src && composer install --prefer-dist --optimize-autoloader
RUN cd /app/src/node-apps/websocket-proxy && npm install
RUN cd /app/src/node-apps/msgs-proxy && npm install
RUN cd /app/src/node-apps/msgs-proxy-lite && npm install
RUN cd /app/src/node-apps/nightmarejs && npm install

VOLUME /app/logs