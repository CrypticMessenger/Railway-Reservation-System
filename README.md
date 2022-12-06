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

## Progress 
- [x] correct input format (slr,and ages and genders)
- [x] multilevel threading support
- [x] 3 team member extention
- [x] testing


## Folder Structure

The workspace contains two folders by default, where:

- `src`: the folder to maintain sources
- `lib`: the folder to maintain dependencies
- `db` : the folder to maintain sql database files
- `client` : the folder to maintain input files 
- `bin` : the folder to maintain .class files
- `response` : the folder to maintain output files 
- `tests` : the folder containing rigourous tests
  
.
├── **README.md**
├── **bin**
│   ├── App.class
│   ├── ParseSchedule.class
│   ├── QueryRunner.class
│   ├── ServiceModule.class
│   ├── client.class
│   ├── invokeWorkers.class
│   ├── routePlanner.class
│   └── sendQuery.class
├── **client**
│   ├── admin.txt
│   ├── route_query.txt
│   ├── train_schedule.txt
│   └── train_schedule1.txt
├── **db**
│   ├── cleanDB.sql
│   ├── makeDB.sql
│   └── routeDB.sql
├── **img**
│   ├── plan1.jpg
│   ├── plan2.jpg
│   └── plan3.pdf
├── **lib**
│   └── postgresql-42.5.0.jar
├── **response**
└── **src**
    ├── App.java
    ├── ParseSchedule.java
    ├── ServiceModule.java
    ├── client.java
    ├── invokeWorkers.java
    ├── routePlanner.java
    └── sendQuery.java

## Contributors  
| **Name**      | **Entry Number** | 
| :---        |    :----:   |  
| Aditya_      | 2020CSB1065      | 
| Amit Kumar   | 2020CSB1070        | 
| Ankit Sharma      | 2020CSB1072       |


<b>*Under the guidance of Dr. Vishwanath Gunturi *</b>



