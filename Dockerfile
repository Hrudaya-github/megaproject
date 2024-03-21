FROM Maven as build 
WORKDIR /app
COPY . .
RUN mvn clean install 

FROM openjdk:17.0
WORKDIR /app
COPY --from=build /app/target/Uber.jar  /app/
CMD [ "java","-jar","Uber.jar" ]
EXPOSE 9090
