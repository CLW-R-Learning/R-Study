# Airline data (1987-2008)
Chih Hui(Jason) Wang  
November 15, 2015  



In this intro, I will demonstrate the code in R to download the airline datasets, which can be find on [ASA Website](http://stat-computing.org/dataexpo/2009/the-data.html).

### 1. Create Directory for Data

First of all, we have to create a directory for storing our airline dataset.

```r
#Make directory called Airline
if(dir.exists("Airline")){
  warning("You have already Airline directory in your current working directory")
}else{
  dir.create("Airline")
}
```


```r
#Change your current directory
setwd("Airline")
```

### 2. Download Airline Data

Now we can download our data. We will download the data from 1987 to 2008. It takes about half of hour to finished the download.

```r
#You can change directory first before downloading
year <- 1987:2008

for(i in year){
  #Change link name
  fileurl <- paste("http://stat-computing.org/dataexpo/2009/", i, ".csv.bz2", sep="")
  
  #file name
  filename <- paste(i, ".csv.bz2", sep="")
    
  #Download file for each year
  download.file(url=fileurl, destfile=filename)
  
}
```


```r
#Check whether all the file are correctly download
list.files("C:/Users/jason/Documents/Airline")
```

```
 [1] "1987.csv.bz2" "1988.csv.bz2" "1989.csv.bz2" "1990.csv.bz2"
 [5] "1991.csv.bz2" "1992.csv.bz2" "1993.csv.bz2" "1994.csv.bz2"
 [9] "1995.csv.bz2" "1996.csv.bz2" "1997.csv.bz2" "1998.csv.bz2"
[13] "1999.csv.bz2" "2000.csv.bz2" "2001.csv.bz2" "2002.csv.bz2"
[17] "2003.csv.bz2" "2004.csv.bz2" "2005.csv.bz2" "2006.csv.bz2"
[21] "2007.csv.bz2" "2008.csv.bz2" "airline.db"  
```

```r
#You can directly use list.files()
```


### 3. Create Database

With data, we can start to construct our database. We will use `data.table`, `RSQLite` later. If you do not have those packages. You can use `install.package(package_name)` to install them.


```r
library(data.table)
library(RSQLite)
```

```
Loading required package: DBI
```

```r
library(dplyr)
```

```

Attaching package: 'dplyr'

The following objects are masked from 'package:data.table':

    between, last

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union
```

To create database, first we have to open a connection to an empty database. There are several ways to import table into database. Here I first read the data into R, remove the row which DepDelay is NA and use `dbWriteTable` to write data into the database. With argument `append=TRUE`, I can append the data one by one into database. It also takes about 30 minutes to create the database.

The alternative way is to unzip all the file and then directly write the csv file into database. 

### Complete Database

```r
#Create database connection
db <- dbConnect(SQLite(), dbname="airline.db")

#Length to check that the function read the data correctly 
l <- 0 

for(i in year){
  #----- If you don't have unix in your computer try the below code -----
  #in_file <- paste(i, ".csv.bz2", sep="")
  #data <- read.csv(bzfile(in_file))

  #----- Otherwise just use the below code -----
  #Print message for reading
  cat(paste("Start reading data for", i, "\n"))
  
  #Construct the command to read data
  #This is bash code for sequential unzip the data
  #which it will process through the data without
  #expilictly unzip it. 
  in_file <- paste("bunzip2 -c ", i, ".csv.bz2", sep="")
  
  #Read data
  data <- fread(in_file, data.table=FALSE)
  
  #Check length   
  l <- l + dim(data)[1] - sum(is.na(data$DepDelay))
  
  #Write data into the Flight table
  dbWriteTable(conn=db, name="airline", value=data[!is.na(data$DepDelay), ], append=TRUE)
  
  #Remove data
  rm(data)
  
  #Print message for reading
  cat(paste("Finished reading data for", i, "\n"))
}
```

### Sample Database(10% size)

It takes about 10 minute to create this sample database.


```r
#Set seed
set.seed(0)

#Create database connection
db <- dbConnect(SQLite(), dbname="airline.db")

#Length to check that the function read the data correctly 
l <- 0 
system.time(
for(i in year){
  #Print message for reading
  cat(paste("Start reading data for", i, "\n"))
  
  #----- If you don't have unix in your computer try the below code -----
  #in_file <- paste(i, ".csv.bz2", sep="")
  #data <- read.csv(bzfile(in_file))

  #----- Otherwise just use the below code -----
  
  #Construct the command to read data
  #This is bash code for sequential unzip the data
  #which it will process through the data without
  #expilictly unzip it. 
  in_file <- paste("bunzip2 -c ", i, ".csv.bz2", sep="")
  
  #Read data
  data <- fread(in_file)
  
  #Remove DepDelay NA
  data <- data[!is.na(data$DepDelay), ]
  
  #sample only 10 percent of observation
  data <- data %>% group_by(UniqueCarrier) %>% sample_frac(0.1, replace=FALSE)
  
  #Change class
  class(data) <- "data.frame"
  
  #Check length   
  l <- l + dim(data)[1]
  
  #Write data into the Flight table
  dbWriteTable(conn=db, name="Sairline", value=data, append=TRUE)
  
  #Remove data
  rm(data)
  
  #Print message for reading
  cat(paste("Finished reading data for", i, "\n"))
}
)
```

_For the following demonstration, we will use the small database._

After constructing the database, we can use `dbListTables` and `dbListFields` to examine the tables in the database and the fields for certain table




```r
#Table in the airline database
dbListTables(db)
```

```
[1] "Sairline"    "airline"     "destination" "flight"      "origin"     
```

```r
#Column name in airline
dbListFields(db, "Sairline")
```

```
 [1] "Year"              "Month"             "DayofMonth"       
 [4] "DayOfWeek"         "DepTime"           "CRSDepTime"       
 [7] "ArrTime"           "CRSArrTime"        "UniqueCarrier"    
[10] "FlightNum"         "TailNum"           "ActualElapsedTime"
[13] "CRSElapsedTime"    "AirTime"           "ArrDelay"         
[16] "DepDelay"          "Origin"            "Dest"             
[19] "Distance"          "TaxiIn"            "TaxiOut"          
[22] "Cancelled"         "CancellationCode"  "Diverted"         
[25] "CarrierDelay"      "WeatherDelay"      "NASDelay"         
[28] "SecurityDelay"     "LateAircraftDelay"
```

### 4. Query

#### a. DBI: dbGetQuery and dbSendQuery + fetch

First, you can use the SQL syntax and the function `dbGetQuery` in DBI package, which will automatically library when you library RSQLite,  to pull out the information you want from database.

Here we use _count(*)_ to count the row number in the airline dataset.

```r
query_count <- "select count(*) as Count from Sairline" 
dbGetQuery(db, query_count)
```

```
     Count
1 12123284
```

Also, you can use another function `dbSendQuery` combined with `fetch` to pull out the data. It will be very convenient if you just want to pull out the beginning of the data. When you use `dbSendQuery`, the database will receive your query and wait for the instruction from you. Then you can use `fetch` to retrieve the query result. 

(Note: You probably do not want to pull everything back to your R which probably will crash your R because of the massive memory use.)

```r
query_data <- "select * from Sairline"

#Send the query while not fetch any data back
fulldata <- dbSendQuery(db, query_data)

#Fetch three observations back
fetch(fulldata, n=3)
```

```
  Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime CRSArrTime
1 1987    12         17         4    1306       1305    1337       1339
2 1987    10          3         6     832        800     947        914
3 1987    11          9         1     832        830     940        940
  UniqueCarrier FlightNum TailNum ActualElapsedTime CRSElapsedTime AirTime
1            PS      1832      NA                31             34      NA
2            PS      1906      NA                75             74      NA
3            PS      1457      NA                68             70      NA
  ArrDelay DepDelay Origin Dest Distance TaxiIn TaxiOut Cancelled
1       -2        1    SFO  MRY       77     NA      NA         0
2       33       32    SFO  LAX      337     NA      NA         0
3        0        2    LAX  SFO      337     NA      NA         0
  CancellationCode Diverted CarrierDelay WeatherDelay NASDelay
1               NA        0           NA           NA       NA
2               NA        0           NA           NA       NA
3               NA        0           NA           NA       NA
  SecurityDelay LateAircraftDelay
1            NA                NA
2            NA                NA
3            NA                NA
```

You can keep fetching next 3 observations like the way previous code. When you finish your work, you have to clear the connection between database.


```r
#Clear the connection
dbClearResult(fulldata)
```

```
[1] TRUE
```

#### b. dplyr

In dplyr, you can write the query in a more R way (not SQL syntax). You have to use `src_sqlite` to connect the database and `tbl` to get the airline data. Then, you can start write the code to pull out information you want to search.



```r
library(dplyr)

#Open connection to database
flight <- src_sqlite("Airline/airline.db")
```


```r
#Connection to our airline table
airline <- tbl(flight, "Sairline")

airline %>% head()
```

```
  Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime CRSArrTime
1 1987    12         17         4    1306       1305    1337       1339
2 1987    10          3         6     832        800     947        914
3 1987    11          9         1     832        830     940        940
4 1987    11         20         5    1748       1738    1817       1800
5 1987    12          9         3     636        635     742        735
6 1987    10          3         6    1231       1230    1324       1327
  UniqueCarrier FlightNum TailNum ActualElapsedTime CRSElapsedTime AirTime
1            PS      1832      NA                31             34      NA
2            PS      1906      NA                75             74      NA
3            PS      1457      NA                68             70      NA
4            PS      1831      NA                89             82      NA
5            PS      1851      NA               126            120      NA
6            PS      1807      NA                53             57      NA
  ArrDelay DepDelay Origin Dest Distance TaxiIn TaxiOut Cancelled
1       -2        1    SFO  MRY       77     NA      NA         0
2       33       32    SFO  LAX      337     NA      NA         0
3        0        2    LAX  SFO      337     NA      NA         0
4       17       10    TUS  LAX      451     NA      NA         0
5        7        1    PHX  SFO      651     NA      NA         0
6       -3        1    LAX  SJC      308     NA      NA         0
  CancellationCode Diverted CarrierDelay WeatherDelay NASDelay
1               NA        0           NA           NA       NA
2               NA        0           NA           NA       NA
3               NA        0           NA           NA       NA
4               NA        0           NA           NA       NA
5               NA        0           NA           NA       NA
6               NA        0           NA           NA       NA
  SecurityDelay LateAircraftDelay
1            NA                NA
2            NA                NA
3            NA                NA
4            NA                NA
5            NA                NA
6            NA                NA
```

It will return `data.frame` to you.

```r
class(airline %>% head())
```

```
[1] "data.frame"
```

Useful function

* select: select columns in the data
* filter: remove row from data
* mutate: create new varible and add into data
* group_by: divided data into groups according to columns
* summarise: give summary to the group data
* arrange: sort the data increasingly or decreasingly

The following are two examples:

```r
#Compute the proportion of more than 30 minutes delay flight for each combination of airline, month, dayofweek, origin, dest
airline %>%
  group_by(UniqueCarrier, Origin, Dest, Month, DayofWeek) %>%
  summarise(late_proportion=mean(DepDelay > 60)) %>%
  ungroup() %>%
  arrange(desc(late_proportion)) %>%
  head()
```

```
  UniqueCarrier Origin Dest Month DayofWeek late_proportion
1            9E    ALB  DTW     2         4               1
2            9E    ALB  MSP     6         3               1
3            9E    ALB  MSP     7         1               1
4            9E    ATL  BNA    12         4               1
5            9E    ATL  BUF     5         3               1
6            9E    ATL  GSP     1         4               1
```


```r
airline %>%
  filter(Year == 2008, Dest == 'SFO', Origin == 'LAX') %>%
  head()
```

```
  Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime CRSArrTime
1 2008     4         27         7    1900       1900    2015       2025
2 2008     7          3         4    2003       2005    2109       2120
3 2008     1         22         2    1338       1235    1444       1400
4 2008    11         23         7    1808       1810    1914       1925
5 2008     8          3         7    1645       1645    1746       1800
6 2008     5         18         7     914        905    1019       1020
  UniqueCarrier FlightNum TailNum ActualElapsedTime CRSElapsedTime AirTime
1            WN       344  N227WN                75             85      58
2            WN      2172  N326SW                66             75      52
3            WN        70  N300SW                66             85      52
4            WN      2781  N481WN                66             75      54
5            WN      3832  N414WN                61             75      51
6            WN      3511  N510SW                65             75      53
  ArrDelay DepDelay Origin Dest Distance TaxiIn TaxiOut Cancelled
1      -10        0    LAX  SFO      337      4      13         0
2      -11       -2    LAX  SFO      337      7       7         0
3       44       63    LAX  SFO      337      5       9         0
4      -11       -2    LAX  SFO      337      3       9         0
5      -14        0    LAX  SFO      337      4       6         0
6       -1        9    LAX  SFO      337      5       7         0
  CancellationCode Diverted CarrierDelay WeatherDelay NASDelay
1                         0           NA           NA       NA
2                         0           NA           NA       NA
3                         0            0            0       43
4                         0           NA           NA       NA
5                         0           NA           NA       NA
6                         0           NA           NA       NA
  SecurityDelay LateAircraftDelay
1            NA                NA
2            NA                NA
3             0                 1
4            NA                NA
5            NA                NA
6            NA                NA
```



### Data Description
Column | Name | Description
--- | --- | ---
1 | Year | 1987-2008
2 | Month | 1-12
3 | DayofMonth | 1-31
4 | DayOfWeek | 1 (Monday) - 7 (Sunday)
5 | DepTime | actual departure time (local, hhmm)
6 | CRSDepTime | scheduled departure time (local, hhmm)
7 | ArrTime | actual arrival time (local, hhmm)
8 | CRSArrTime |scheduled arrival time (local, hhmm)
9 | UniqueCarrier | unique carrier code
10 | FlightNum | flight number
11 | TailNum | plane tail number
12 | ActualElapsedTime | in minutes
13 | CRSElapsedTime | in minutes
14 | AirTime | in minutes
15 | ArrDelay | arrival delay, in minutes
16 | DepDelay | departure delay, in minutes
17 | Origin | origin IATA airport code
18 | Dest | destination IATA airport code
19 | Distance | in miles
20 | TaxiIn | taxi in time, in minutes
21 | TaxiOut | taxi out time in minutes
22 | Cancelled | was the flight cancelled?
23 | CancellationCode | reason for cancellation (A = carrier, B = weather, C = NAS, D = security)
24 | Diverted | 1 = yes, 0 = no
25 | CarrierDelay | in minutes
26 | WeatherDelay | in minutes
27 | NASDelay | in minutes
28 | SecurityDelay | in minutes
29 | LateAircraftDelay | in minutes

### Have fun!

### Reference

* [Sandy Muspratt's R Blog - Creating SQLite databases from R](http://sandymuspratt.blogspot.com/2012/11/r-and-sqlite-part-1.html)
