FROM node:10.5.0-stretch

WORKDIR /app

COPY package*.json /app/
RUN  npm install

COPY . /app/

CMD [ "bin/hubot", "-a", "slack" ]
