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

To create database, first we have to open a connection to an empty database. There are several ways to import table into database. Here I first read the data into R, remove the row which DepDelay is NA and use `dbWriteTable` to write data into the database. With argument `append=TRUE`, I can append the data one by one into database. It also takes about 30 minutes to create the database.

The alternative way is to unzip all the file and then directly write the csv file into database. 


```r
#Create database connection
db <- dbConnect(SQLite(), dbname="airline.db")

#Length to check that the function read the data correctly 
l <- 0 

for(i in year){
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

After constructing the database, we can use `dbListTables` and `dbListFields` to examine the tables in the database and the fields for certain table




```r
#Table in the airline database
dbListTables(db)
```

```
[1] "airline"
```

```r
#Column name in airline
dbListFields(db, "airline")
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
query_count <- "select count(*) as Count from airline" 
dbGetQuery(db, query_count)
```

```
      Count
1 121232833
```

Also, you can use another function `dbSendQuery` combined with `fetch` to pull out the data. It will be very convenient if you just want to pull out the beginning of the data. When you use `dbSendQuery`, the database will receive your query and wait for the instruction from you. Then you can use `fetch` to retrieve the query result. 

(Note: You probably do not want to pull everything back to your R which probably will crash your R because of the massive memory use.)

```r
query_data <- "select * from airline"

#Send the query while not fetch any data back
fulldata <- dbSendQuery(db, query_data)

#Fetch three observations back
fetch(fulldata, n=3)
```

```
  Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime CRSArrTime
1 1987    10         14         3     741        730     912        849
2 1987    10         15         4     729        730     903        849
3 1987    10         17         6     741        730     918        849
  UniqueCarrier FlightNum TailNum ActualElapsedTime CRSElapsedTime AirTime
1            PS      1451      NA                91             79      NA
2            PS      1451      NA                94             79      NA
3            PS      1451      NA                97             79      NA
  ArrDelay DepDelay Origin Dest Distance TaxiIn TaxiOut Cancelled
1       23       11    SAN  SFO      447     NA      NA         0
2       14       -1    SAN  SFO      447     NA      NA         0
3       29       11    SAN  SFO      447     NA      NA         0
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

#### dplyr

In dplyr, you can write the query in a more R way (not SQL syntax). You have to use `src_sqlite` to connect the database and `tbl` to get the airline data. Then, you can start write the code to pull out information you want to search.



```r
library(dplyr)

#Open connection to database
flight <- src_sqlite("Airline/airline.db")
```


```r
#Connection to our airline table
airline <- tbl(flight, "airline")

airline %>% head()
```

```
  Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime CRSArrTime
1 1987    10         14         3     741        730     912        849
2 1987    10         15         4     729        730     903        849
3 1987    10         17         6     741        730     918        849
4 1987    10         18         7     729        730     847        849
5 1987    10         19         1     749        730     922        849
6 1987    10         21         3     728        730     848        849
  UniqueCarrier FlightNum TailNum ActualElapsedTime CRSElapsedTime AirTime
1            PS      1451      NA                91             79      NA
2            PS      1451      NA                94             79      NA
3            PS      1451      NA                97             79      NA
4            PS      1451      NA                78             79      NA
5            PS      1451      NA                93             79      NA
6            PS      1451      NA                80             79      NA
  ArrDelay DepDelay Origin Dest Distance TaxiIn TaxiOut Cancelled
1       23       11    SAN  SFO      447     NA      NA         0
2       14       -1    SAN  SFO      447     NA      NA         0
3       29       11    SAN  SFO      447     NA      NA         0
4       -2       -1    SAN  SFO      447     NA      NA         0
5       33       19    SAN  SFO      447     NA      NA         0
6       -1       -2    SAN  SFO      447     NA      NA         0
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
#Compute the proportion of delay flight for each combination of airline, month, dayofweek, origin, dest
airline %>%
  filter(Year == 2008) %>%
  group_by(UniqueCarrier, Origin, Dest) %>%
  summarise(late_proportion=mean(DepDelay < 0)) %>%
  ungroup() %>%
  arrange(desc(late_proportion)) %>%
  head()
```

```
  UniqueCarrier Origin Dest late_proportion
1            9E    ATL  CAE               1
2            9E    ATL  CMH               1
3            9E    ATL  MSP               1
4            9E    ATL  MSY               1
5            9E    ATL  PFN               1
6            9E    AUS  DTW               1
```


```r
airline %>%
  filter(Year == 2008, Dest == 'SFO', Origin == 'LAX') %>%
  head()
```

```
  Year Month DayofMonth DayOfWeek DepTime CRSDepTime ArrTime CRSArrTime
1 2008     1          3         4     708        710     829        835
2 2008     1          3         4    2321       1955      38       2115
3 2008     1          3         4    2008       1805    2139       1930
4 2008     1          3         4    1625       1430    1748       1550
5 2008     1          3         4    1305       1050    1421       1210
6 2008     1          3         4    1558       1245    1709       1405
  UniqueCarrier FlightNum TailNum ActualElapsedTime CRSElapsedTime AirTime
1            WN       457  N738CB                81             85      61
2            WN       593  N901WN                77             80      65
3            WN       646  N738CB                91             85      70
4            WN       656  N738CB                83             80      67
5            WN       680  N738CB                76             80      63
6            WN       776  N901WN                71             80      60
  ArrDelay DepDelay Origin Dest Distance TaxiIn TaxiOut Cancelled
1       -6       -2    LAX  SFO      337      4      16         0
2      203      206    LAX  SFO      337      6       6         0
3      129      123    LAX  SFO      337      5      16         0
4      118      115    LAX  SFO      337      3      13         0
5      131      135    LAX  SFO      337      5       8         0
6      184      193    LAX  SFO      337      7       4         0
  CancellationCode Diverted CarrierDelay WeatherDelay NASDelay
1                         0           NA           NA       NA
2                         0            0            0      203
3                         0            0           24        6
4                         0            0            0        5
5                         0            0            0      131
6                         0          184            0        0
  SecurityDelay LateAircraftDelay
1            NA                NA
2             0                 0
3             0                99
4             0               113
5             0                 0
6             0                 0
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

### Have fun for playing airline dataset!

### Reference

* [Sandy Muspratt's R Blog - Creating SQLite databases from R](http://sandymuspratt.blogspot.com/2012/11/r-and-sqlite-part-1.html)
