#base image for node.js
FROM node:alpine

#working dir for conatiner
WORKDIR  /app

#copy package.json and package-lock.json on conatainer
COPY package*.json ./

#install nodejs dependencies
RUN npm install 

#copy rest of the app code on container
COPY . .

#expose the app on port
EXPOSE 3000

#command that runs the app
CMD [ "npm","start" ]