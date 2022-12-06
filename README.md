<center>
<h1> Railway Reservation System </h1>

![image](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![image](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
</center>

    
## Folder Structure

The workspace contains following folders, where:

- `src`: the folder to maintain sources
- `lib`: the folder to maintain dependencies
- `db` : the folder to maintain sql database files
- `client` : the folder to maintain input files 
- `bin` : the folder to maintain .class files
- `response` : the folder to maintain output files 
- `tests` : the folder containing rigourous tests
```
.
├── README.md
├── bin
│   ├── App.class
│   ├── ParseSchedule.class
│   ├── QueryRunner.class
│   ├── ServiceModule.class
│   ├── client.class
│   ├── invokeWorkers.class
│   ├── routePlanner.class
│   └── sendQuery.class
├── client
│   ├── admin.txt
│   ├── route_query.txt
│   ├── train_schedule.txt
│   └── train_schedule1.txt
├── db
│   ├── cleanDB.sql
│   ├── makeDB.sql
│   └── routeDB.sql
├── img
│   ├── plan1.jpg
│   ├── plan2.jpg
│   └── plan3.pdf
├── lib
│   └── postgresql-42.5.0.jar
├── response
└── src
    ├── App.java
    ├── ParseSchedule.java
    ├── ServiceModule.java
    ├── client.java
    ├── invokeWorkers.java
    ├── routePlanner.java
    └── sendQuery.java
```

## Changes to be performed before running.
- In case of error regarding password ```ALTER USER postgres WITH PASSWORD '1421';```
- mv ./lib/postgresql-42.5.0.jar ./src
- unzip postgresql-42.5.0.jar
- change password in ```App.java```
- change file path in ```App.java```
- change file path in ```sendQuery.java```
- change file path in ```routePlanner.java```
- change password in ```routePlanner.java```
- change password in ```ParseSchedule.java```
- change address in ```ParseSchedule.java```
- change password in ```ServiceModule.java```
- use ```time java App.java``` to time the running java program.

## Steps to run and test :
### for booking requests:
To run this program, you will need to use three terminal windows.

- In the first terminal window:
  - you will need to start the Postgres server. This can be done by:
  ```
  sudo service postgresql start         
  sudo su postgres
  ```
  - run following commands to create and connect to Database:
  ```
  create database railway_reservation_system;
  \c railway_reservation_system
  ```
  - run following command to fill the database with apt triggers and relations:
  ```
  \i makeDB.sql
  -- or copy the content of makeDB.sql and paste it in the terminal.
  ```
- In the second terminal window, you will need to run the `App.java` and `ServiceModule.java` files. These files are responsible for starting the application by filling in the trains available in the database and servicing server, respectively.
  - To run these files, navigate to the `src` where they are located, and use the java command to execute them:
  ```
  cd ./src
  javac *.java  
  java App
  java ServiceModule
  ```
- In the third terminal window, you will need to run the `client.java` file. This file is responsible for starting sending client booking requests to the servicing server. 
  - To run this file, navigate to the directory where it is located i.e. `src`, and use the java command to execute it.
  ```
  cd ./src
  java client.java
  ```
- Once all three terminal windows are running, the program will be fully operational.

### for getting routes with at-max one stop
Given the train schedules, their stops with departure and arrival times and dates, client can query to find route from a source to destination with at-max 1 stop. 
To start querying for routes with at most one stop, you will need to use 2 terminal windows.
- In first terminal window, 
  - you will need to start the Postgres server. This can be done by:
  ```
  sudo service postgresql start         
  sudo su postgres
  ```
  - run following commands to create and connect to Database:
  ```
  create database train_schedule;
  \c train_schedule
  ```
  - run following command to fill the database with apt triggers and relations:
  ```
  \i routeDB.sql
  -- or copy the content of routeDB.sql and paste it in the terminal.
  ```
- In second terminal window,
  - you will need to run the `ParseSchedule.java` file. This file is **responsible for parsing the train schedule** and storing it in the `train_schedule` database. To run this file, navigate to the directory where it is located i.e. `src` , and use the java command to execute it.
  ```
  cd ./src
  javac *.java
  java ParseSchedule.java
  ```
  - Once the `ParseSchedule.java` file has finished executing, you can use the terminal window to run the `routePlanner.java` file. This file is responsible for querying the train_schedule database and finding all possible routes with at most one stop, based on the queries in the `route_query.txt` file.
  ```
  java routePlanner.java
  ```
- Once the `routePlanner.java` file has finished executing, it will output all possible routes with at most one stop, based on the queries in the route_query.txt file.

## Progress 
- [x] multilevel threading support
- [x] 3 team member extention
- [x] testing

## Results
- Increasing number of threads appropriately will lead to increased throughput in the given testCases (located in `TestCases` directory).
- Program uses multithreading for scalablility purposes while taking care of concurrency issues taught in this course.

## Contributors  
<b>Under the guidance of Dr. Vishwanath Gunturi : </b><br>
| **Name**      | **Entry Number** | 
| :---        |    :----:   |  
| Aditya_      | 2020CSB1065      | 
| Amit Kumar   | 2020CSB1070        | 
| Ankit Sharma      | 2020CSB1072       |





