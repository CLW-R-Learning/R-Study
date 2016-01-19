# NBA
Chih Hui(Jason) Wang  
December 16, 2015  




```r
library(dplyr)
library(googleVis)
op <- options(gvis.plot.tag='chart')
```


```r
setwd('C:/Users/jason/Desktop/R/CLW_R_Learning/Jason Wang/Practice/NBA/Data')
```


```r
glossary <- read.csv('glossary.csv', stringsAsFactors=FALSE)
NBAT <- gvisTable(glossary)
plot(NBAT)
```

<!-- Table generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:44 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataTableID10107a263bfa () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "Rk",
" Rank" 
],
[
 "Player",
"Player name" 
],
[
 "Pos",
" Position" 
],
[
 "Age",
" Age of Player at the start of February 1st of that season." 
],
[
 "Tm",
" Team" 
],
[
 "G",
" Games" 
],
[
 "GS",
" Games Started" 
],
[
 "MP",
" Minutes Played" 
],
[
 "FG",
" Field Goals" 
],
[
 "FGA",
" Field Goal Attempts" 
],
[
 "FG%",
" Field Goal Percentage" 
],
[
 "3P",
" 3-Point Field Goals" 
],
[
 "3PA",
" 3-Point Field Goal Attempts" 
],
[
 "3P",
" FG% on 3-Pt FGAs." 
],
[
 "2P",
" 2-Point Field Goals" 
],
[
 "2PA",
" 2-point Field Goal Attempts" 
],
[
 "2P",
" FG% on 2-Pt FGAs." 
],
[
 "eFG%",
" Effective Field Goal Percentage" 
],
[
 "This statistic adjusts for the fact that a 3-point field goal is worth one more point than a 2-point field goal.",
"" 
],
[
 "FT",
" Free Throws" 
],
[
 "FTA",
" Free Throw Attempts" 
],
[
 "FT%",
" Free Throw Percentage" 
],
[
 "ORB",
" Offensive Rebounds" 
],
[
 "DRB",
" Defensive Rebounds" 
],
[
 "TRB",
" Total Rebounds" 
],
[
 "AST",
" Assists" 
],
[
 "STL",
" Steals" 
],
[
 "BLK",
" Blocks" 
],
[
 "TOV",
" Turnovers" 
],
[
 "PF",
" Personal Fouls" 
],
[
 "PTS",
" Points" 
] 
];
data.addColumn('string','Term');
data.addColumn('string','Description');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartTableID10107a263bfa() {
var data = gvisDataTableID10107a263bfa();
var options = {};
options["allowHtml"] = true;

    var chart = new google.visualization.Table(
    document.getElementById('TableID10107a263bfa')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "table";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartTableID10107a263bfa);
})();
function displayChartTableID10107a263bfa() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartTableID10107a263bfa"></script>
 
<!-- divChart -->
  
<div id="TableID10107a263bfa" 
  style="width: 500; height: automatic;">
</div>


```r
#Remove the note for eFG%
colname <- glossary[-19, 1]
colname[14] <- '3P%'
colname[17] <- '2P%'

#Get the filename
filenames <- grep("NBA[0-9]{4}.csv", list.files(), value=TRUE)


all <- NULL
#Read and process file
for(file in filenames){
  data <- read.csv(file, header=TRUE, col.names=colname,
                   stringsAsFactors=FALSE)
  #Remove header and the player team TOT
  #TOT is the total of player perfromance
  #if the player had switched team in that season
  data <- data %>%
            filter(Rk != 'Rk', Tm != 'TOT') %>%
            mutate(Year=substr(file, 4, 7))
  
  if(is.null(all)){
    all <- data
  }else{
    all <- rbind(all, data)
  }
}

write.csv(all, 'NBAall.csv', row.names=FALSE)
NBA <- all
```


```r
NBA <- read.csv('NBAall.csv', stringsAsFactors=FALSE)
head(NBA)
```

```
  Rk              Player Pos Age  Tm  G GS   MP  FG  FGA   FG. X3P X3PA
1  1  Mahmoud Abdul-Rauf  PG  31 VAN 41  0  486 120  246 0.488   4   14
2  2   Tariq Abdul-Wahad  SG  26 DEN 29 12  420  43  111 0.387   4   10
3  3 Shareef Abdur-Rahim  SF  24 VAN 81 81 3241 604 1280 0.472  12   64
4  4      Cory Alexander  PG  27 ORL 26  0  227  18   56 0.321   4   16
5  5  Courtney Alexander  PG  23 DAL 38  6  472  62  178 0.348   3   10
6  5  Courtney Alexander  PG  23 WAS 27 18  910 177  395 0.448  14   36
   X3P. X2P X2PA  X2P.  eFG.  FT FTA   FT. ORB DRB TRB AST STL BLK TOV  PF
1 0.286 116  232 0.500 0.496  22  29 0.759   5  20  25  76   9   1  26  50
2 0.400  39  101 0.386 0.405  21  36 0.583  14  45  59  22  14  13  34  54
3 0.188 592 1216 0.487 0.477 443 531 0.834 175 560 735 250  90  77 231 238
4 0.250  14   40 0.350 0.357  12  18 0.667   0  25  25  36  16   0  25  29
5 0.300  59  168 0.351 0.357  33  45 0.733  20  43  63  21  16   3  21  76
6 0.389 163  359 0.454 0.466  90 105 0.857  22  58  80  41  29   2  54  63
   PTS Year
1  266 2000
2  111 2000
3 1663 2000
4   52 2000
5  160 2000
6  458 2000
```


```r
team <- c("NBA", rep("EAST", 3), rep("WEST", 3),
          rep("ATLANTIC", 5), rep("CENTRAL", 5), rep("SOUTHEAST", 5),
          rep("PACIFIC", 5), rep("SOUTHWEST", 5), rep("NORTHWEST", 5),
          "BOS", "BRK", "NYU", "PHI", "TOR",
          "CHI", "CLE", "DET", "IND", "MIL",
          "ATL", "MIA", "ORL", "WAS", "CHA",
          "GSE", "LAC", "LAL", "PHO", "SAC",
          "NOP", "DAL", "HOU", "SAS", "MEM",
          "DEN", "MIN", "POR", "OKC", "UTA"
)

parent <- c(NA, rep("NBA", 6), rep("EAST", 15), rep("WEST", 15),
            rep("ATLANTIC", 5), rep("CENTRAL", 5), rep("SOUTHEAST", 5),
            rep("PACIFIC", 5), rep("SOUTHWEST", 5),
            rep("NORTHWEST", 5))

division <- data.frame(Team=team, Parent=parent, Val=1:length(team))

org <- gvisOrgChart(division,
                    options=list(
                      width=1400,
                      height=1200,
                      size='small',
                      allowCollapse=TRUE
                    ))

plot(org)
```

<!-- OrgChart generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:44 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataOrgChartID1010165e37e () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "NBA",
null,
"1" 
],
[
 "EAST",
"NBA",
"2" 
],
[
 "EAST",
"NBA",
"3" 
],
[
 "EAST",
"NBA",
"4" 
],
[
 "WEST",
"NBA",
"5" 
],
[
 "WEST",
"NBA",
"6" 
],
[
 "WEST",
"NBA",
"7" 
],
[
 "ATLANTIC",
"EAST",
"8" 
],
[
 "ATLANTIC",
"EAST",
"9" 
],
[
 "ATLANTIC",
"EAST",
"10" 
],
[
 "ATLANTIC",
"EAST",
"11" 
],
[
 "ATLANTIC",
"EAST",
"12" 
],
[
 "CENTRAL",
"EAST",
"13" 
],
[
 "CENTRAL",
"EAST",
"14" 
],
[
 "CENTRAL",
"EAST",
"15" 
],
[
 "CENTRAL",
"EAST",
"16" 
],
[
 "CENTRAL",
"EAST",
"17" 
],
[
 "SOUTHEAST",
"EAST",
"18" 
],
[
 "SOUTHEAST",
"EAST",
"19" 
],
[
 "SOUTHEAST",
"EAST",
"20" 
],
[
 "SOUTHEAST",
"EAST",
"21" 
],
[
 "SOUTHEAST",
"EAST",
"22" 
],
[
 "PACIFIC",
"WEST",
"23" 
],
[
 "PACIFIC",
"WEST",
"24" 
],
[
 "PACIFIC",
"WEST",
"25" 
],
[
 "PACIFIC",
"WEST",
"26" 
],
[
 "PACIFIC",
"WEST",
"27" 
],
[
 "SOUTHWEST",
"WEST",
"28" 
],
[
 "SOUTHWEST",
"WEST",
"29" 
],
[
 "SOUTHWEST",
"WEST",
"30" 
],
[
 "SOUTHWEST",
"WEST",
"31" 
],
[
 "SOUTHWEST",
"WEST",
"32" 
],
[
 "NORTHWEST",
"WEST",
"33" 
],
[
 "NORTHWEST",
"WEST",
"34" 
],
[
 "NORTHWEST",
"WEST",
"35" 
],
[
 "NORTHWEST",
"WEST",
"36" 
],
[
 "NORTHWEST",
"WEST",
"37" 
],
[
 "BOS",
"ATLANTIC",
"38" 
],
[
 "BRK",
"ATLANTIC",
"39" 
],
[
 "NYU",
"ATLANTIC",
"40" 
],
[
 "PHI",
"ATLANTIC",
"41" 
],
[
 "TOR",
"ATLANTIC",
"42" 
],
[
 "CHI",
"CENTRAL",
"43" 
],
[
 "CLE",
"CENTRAL",
"44" 
],
[
 "DET",
"CENTRAL",
"45" 
],
[
 "IND",
"CENTRAL",
"46" 
],
[
 "MIL",
"CENTRAL",
"47" 
],
[
 "ATL",
"SOUTHEAST",
"48" 
],
[
 "MIA",
"SOUTHEAST",
"49" 
],
[
 "ORL",
"SOUTHEAST",
"50" 
],
[
 "WAS",
"SOUTHEAST",
"51" 
],
[
 "CHA",
"SOUTHEAST",
"52" 
],
[
 "GSE",
"PACIFIC",
"53" 
],
[
 "LAC",
"PACIFIC",
"54" 
],
[
 "LAL",
"PACIFIC",
"55" 
],
[
 "PHO",
"PACIFIC",
"56" 
],
[
 "SAC",
"PACIFIC",
"57" 
],
[
 "NOP",
"SOUTHWEST",
"58" 
],
[
 "DAL",
"SOUTHWEST",
"59" 
],
[
 "HOU",
"SOUTHWEST",
"60" 
],
[
 "SAS",
"SOUTHWEST",
"61" 
],
[
 "MEM",
"SOUTHWEST",
"62" 
],
[
 "DEN",
"NORTHWEST",
"63" 
],
[
 "MIN",
"NORTHWEST",
"64" 
],
[
 "POR",
"NORTHWEST",
"65" 
],
[
 "OKC",
"NORTHWEST",
"66" 
],
[
 "UTA",
"NORTHWEST",
"67" 
] 
];
data.addColumn('string','Team');
data.addColumn('string','Parent');
data.addColumn('string','Val');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartOrgChartID1010165e37e() {
var data = gvisDataOrgChartID1010165e37e();
var options = {};
options["width"] =   1400;
options["height"] =   1200;
options["size"] = "small";
options["allowCollapse"] = true;

    var chart = new google.visualization.OrgChart(
    document.getElementById('OrgChartID1010165e37e')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "orgchart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartOrgChartID1010165e37e);
})();
function displayChartOrgChartID1010165e37e() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartOrgChartID1010165e37e"></script>
 
<!-- divChart -->
  
<div id="OrgChartID1010165e37e" 
  style="width: 1400; height: 1200;">
</div>



```r
C <- NBA %>% filter(Pos == "C") %>%
      group_by(Player) %>%
      summarise(FT=sum(FT), ORB=sum(ORB), DRB=sum(DRB),
                BLK=sum(BLK), TOV=sum(TOV), PTS=sum(PTS))

Ctable <- gvisTable(C, formats=list(PTS="#,###"),
                    options=list(page="enable"))

plot(Ctable)
```

<!-- Table generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:44 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataTableID101032ad5156 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "Aaron Gray",
186,
431,
759,
87,
265,
1066 
],
[
 "Aaron Williams",
276,
334,
593,
147,
234,
1313 
],
[
 "Adonal Foyle",
267,
975,
1684,
962,
445,
2275 
],
[
 "Al Harrington",
150,
113,
353,
17,
97,
1153 
],
[
 "Al Horford",
988,
1229,
3319,
576,
808,
7039 
],
[
 "Al Jefferson",
1675,
1676,
4681,
912,
995,
12055 
],
[
 "Alan Henderson",
121,
216,
319,
44,
83,
521 
],
[
 "Aleksandar Radojevic",
7,
9,
19,
2,
15,
19 
],
[
 "Alex Kirk",
2,
1,
0,
0,
0,
4 
],
[
 "Alex Len",
93,
181,
372,
123,
100,
518 
],
[
 "Alexis Ajinca",
150,
216,
458,
117,
152,
924 
],
[
 "Alonzo Mourning*",
738,
532,
1101,
649,
465,
2865 
],
[
 "Alvin Jones",
10,
13,
23,
9,
11,
26 
],
[
 "Amal McCaskill",
34,
71,
120,
31,
41,
176 
],
[
 "Amar'e Stoudemire",
2227,
935,
2255,
593,
937,
8509 
],
[
 "Anderson Varejao",
574,
991,
1936,
221,
389,
2794 
],
[
 "Andray Blatche",
262,
287,
508,
128,
240,
1556 
],
[
 "Andre Drummond",
338,
1046,
1586,
379,
287,
2701 
],
[
 "Andrea Bargnani",
609,
199,
665,
140,
321,
3005 
],
[
 "Andreas Glyniadakis",
1,
2,
6,
0,
9,
17 
],
[
 "Andrew Bogut",
679,
1350,
3346,
863,
926,
5511 
],
[
 "Andrew Bynum",
987,
1007,
2214,
657,
644,
4822 
],
[
 "Andrew DeClercq",
187,
445,
620,
125,
224,
1027 
],
[
 "Andris Biedrins",
383,
1190,
2441,
580,
479,
3247 
],
[
 "Anthony Davis",
348,
207,
466,
189,
109,
1394 
],
[
 "Anthony Mason",
84,
90,
326,
12,
79,
466 
],
[
 "Anthony Randolph",
161,
105,
230,
67,
92,
654 
],
[
 "Antonio Davis",
718,
626,
1305,
279,
375,
2550 
],
[
 "Arinze Onuaku",
3,
7,
14,
3,
2,
27 
],
[
 "Aron Baynes",
116,
178,
317,
33,
112,
665 
],
[
 "Arvydas Sabonis*",
250,
139,
527,
111,
160,
1092 
],
[
 "Ben Handlogten",
27,
45,
75,
9,
28,
163 
],
[
 "Ben Wallace",
921,
2764,
5762,
1722,
860,
5086 
],
[
 "Bernard James",
51,
85,
127,
61,
34,
203 
],
[
 "Bismack Biyombo",
291,
571,
1152,
443,
245,
1239 
],
[
 "Bo Outlaw",
72,
134,
234,
71,
76,
378 
],
[
 "Bobby Jones",
23,
11,
27,
1,
14,
84 
],
[
 "Boniface N'Dong",
6,
15,
22,
5,
6,
50 
],
[
 "Brad Miller",
2141,
1369,
3677,
453,
1143,
8049 
],
[
 "Brandan Wright",
188,
249,
429,
194,
90,
1406 
],
[
 "Brandon Bass",
344,
249,
465,
103,
168,
1340 
],
[
 "Brendan Haywood",
1318,
2081,
2794,
1109,
851,
5538 
],
[
 "Brian Cook",
49,
94,
223,
42,
46,
613 
],
[
 "Brian Grant",
590,
744,
1649,
179,
431,
3084 
],
[
 "Brian Scalabrine",
16,
7,
43,
10,
12,
136 
],
[
 "Brian Skinner",
147,
312,
682,
204,
171,
1095 
],
[
 "Britton Johnsen",
7,
15,
30,
1,
14,
42 
],
[
 "Brook Lopez",
1607,
1161,
1868,
724,
796,
7404 
],
[
 "Bruno Sundov",
8,
27,
68,
12,
25,
143 
],
[
 "Bryant Reeves",
113,
132,
320,
54,
90,
622 
],
[
 "Byron Mullens",
102,
120,
299,
63,
101,
795 
],
[
 "Calvin Booth",
234,
301,
677,
344,
174,
1148 
],
[
 "Carlos Boozer",
171,
130,
435,
18,
149,
1033 
],
[
 "Carlos Rogers",
39,
62,
115,
24,
22,
238 
],
[
 "Cezary Trybanski",
5,
6,
9,
7,
10,
15 
],
[
 "Channing Frye",
372,
311,
844,
148,
225,
2236 
],
[
 "Charles Oakley",
28,
37,
70,
6,
21,
74 
],
[
 "Cheikh Samb",
4,
13,
18,
12,
4,
22 
],
[
 "Cherokee Parks",
38,
99,
198,
47,
57,
374 
],
[
 "Chris Andersen",
806,
895,
1688,
714,
392,
2931 
],
[
 "Chris Bosh",
3228,
1450,
3941,
691,
1287,
12355 
],
[
 "Chris Dudley",
22,
93,
172,
43,
40,
120 
],
[
 "Chris Hunter",
52,
56,
111,
35,
30,
270 
],
[
 "Chris Johnson",
51,
47,
85,
46,
38,
205 
],
[
 "Chris Kaman",
1340,
1480,
4078,
930,
1536,
8164 
],
[
 "Chris Mihm",
719,
818,
1344,
422,
510,
3110 
],
[
 "Chris Richard",
16,
52,
83,
12,
24,
98 
],
[
 "Chris Taft",
1,
19,
17,
7,
2,
47 
],
[
 "Chris Wilcox",
373,
423,
862,
118,
328,
2061 
],
[
 "Christian Laettner",
67,
75,
137,
27,
70,
398 
],
[
 "Chuck Hayes",
219,
716,
1392,
162,
320,
1583 
],
[
 "Clifford Robinson",
51,
62,
174,
62,
71,
562 
],
[
 "Clint Capela",
4,
10,
26,
9,
5,
32 
],
[
 "Cody Zeller",
273,
215,
500,
90,
149,
962 
],
[
 "Cole Aldrich",
103,
194,
476,
141,
117,
605 
],
[
 "Corie Blount",
22,
90,
184,
24,
51,
188 
],
[
 "Corsley Edwards",
7,
12,
13,
4,
2,
27 
],
[
 "Courtney Sims",
0,
3,
3,
0,
1,
6 
],
[
 "Curtis Borchardt",
66,
99,
179,
46,
70,
258 
],
[
 "D.J. White",
41,
31,
75,
12,
7,
203 
],
[
 "Dale Davis",
501,
1118,
1703,
399,
302,
2625 
],
[
 "Dalibor Bagaric",
57,
84,
154,
43,
72,
251 
],
[
 "Dan Gadzuric",
362,
892,
1385,
437,
349,
2426 
],
[
 "Dan McClintock",
0,
10,
7,
2,
3,
18 
],
[
 "Daniel Orton",
32,
29,
58,
19,
22,
98 
],
[
 "Daniel Santiago",
111,
76,
184,
47,
85,
417 
],
[
 "Danny Fortson",
345,
315,
404,
20,
169,
807 
],
[
 "Darius Songaila",
209,
217,
523,
50,
245,
1620 
],
[
 "Darko Milicic",
280,
483,
1051,
473,
449,
2174 
],
[
 "Darryl Watkins",
11,
13,
26,
6,
15,
35 
],
[
 "David Andersen",
46,
54,
154,
12,
37,
367 
],
[
 "David Harrison",
201,
184,
365,
185,
216,
949 
],
[
 "David Lee",
517,
484,
1416,
62,
339,
2933 
],
[
 "David Robinson*",
772,
562,
1284,
448,
309,
2648 
],
[
 "Dean Garrett",
27,
81,
193,
59,
35,
213 
],
[
 "DeAndre Jordan",
705,
1541,
3103,
895,
623,
4142 
],
[
 "DeMarcus Cousins",
1705,
1107,
2619,
392,
1168,
6618 
],
[
 "Deng Gai",
0,
0,
0,
0,
0,
0 
],
[
 "Derrick Caracter",
17,
19,
24,
10,
19,
81 
],
[
 "Derrick Coleman",
186,
199,
458,
95,
155,
882 
],
[
 "DeSagana Diop",
167,
771,
1233,
549,
299,
1066 
],
[
 "Dewayne Dedmon",
55,
156,
266,
72,
69,
313 
],
[
 "Dexter Pittman",
18,
38,
51,
8,
22,
116 
],
[
 "Didier Ilunga-Mbenga",
54,
129,
222,
141,
87,
414 
],
[
 "Dikembe Mutombo*",
883,
1254,
2666,
846,
535,
3025 
],
[
 "Dirk Nowitzki",
811,
210,
1215,
181,
280,
3459 
],
[
 "Dragan Tarlac",
25,
37,
85,
19,
38,
103 
],
[
 "Drew Gooden",
304,
303,
521,
97,
191,
1409 
],
[
 "Duane Causwell",
12,
23,
60,
18,
23,
76 
],
[
 "Dwight Howard",
3580,
2283,
6186,
1460,
2117,
12401 
],
[
 "Earl Barron",
127,
188,
304,
30,
107,
640 
],
[
 "Ed Davis",
66,
95,
205,
38,
45,
438 
],
[
 "Eddie Griffin",
44,
107,
282,
148,
43,
320 
],
[
 "Eddy Curry",
1427,
804,
1470,
301,
997,
5750 
],
[
 "Efthimi Rentzias",
8,
10,
16,
2,
4,
52 
],
[
 "Ekpe Udoh",
217,
293,
393,
273,
144,
899 
],
[
 "Elden Campbell",
236,
127,
356,
96,
142,
824 
],
[
 "Elton Brand",
151,
275,
584,
187,
122,
1177 
],
[
 "Emeka Okafor",
1053,
1538,
3253,
803,
793,
5807 
],
[
 "Enes Kanter",
495,
741,
1110,
126,
444,
2960 
],
[
 "Eric Dawson",
1,
5,
5,
2,
3,
15 
],
[
 "Eric Montross",
18,
88,
225,
49,
66,
236 
],
[
 "Erick Dampier",
1218,
2143,
3337,
1113,
1055,
5359 
],
[
 "Erik Murphy",
0,
2,
6,
4,
2,
6 
],
[
 "Ernest Brown",
1,
1,
5,
1,
3,
3 
],
[
 "Ervin Johnson",
144,
573,
1169,
300,
186,
841 
],
[
 "Etan Thomas",
501,
607,
1155,
404,
352,
2159 
],
[
 "Evan Eschmeyer",
90,
180,
313,
74,
75,
330 
],
[
 "Fab Melo",
1,
0,
3,
2,
1,
7 
],
[
 "Fabricio Oberto",
49,
159,
218,
31,
105,
335 
],
[
 "Felton Spencer",
32,
32,
53,
10,
23,
68 
],
[
 "Festus Ezeli",
92,
201,
267,
116,
95,
392 
],
[
 "Francisco Elson",
273,
497,
1141,
255,
355,
1726 
],
[
 "Garret Siler",
11,
16,
12,
4,
10,
45 
],
[
 "Garth Joseph",
0,
2,
0,
1,
2,
2 
],
[
 "Gary Trent",
69,
83,
133,
17,
54,
379 
],
[
 "Glen Davis",
424,
317,
617,
69,
221,
1758 
],
[
 "Gorgui Dieng",
250,
326,
583,
176,
180,
996 
],
[
 "Greg Foster",
36,
59,
155,
21,
55,
246 
],
[
 "Greg Monroe",
616,
723,
1292,
146,
476,
3064 
],
[
 "Greg Oden",
206,
256,
400,
130,
138,
840 
],
[
 "Greg Ostertag",
397,
827,
1374,
643,
387,
1808 
],
[
 "Greg Smith",
83,
127,
241,
47,
47,
473 
],
[
 "Greg Stiemsma",
103,
190,
489,
232,
143,
641 
],
[
 "Gustavo Ayon",
28,
102,
222,
27,
76,
316 
],
[
 "Ha Seung-Jin",
14,
20,
47,
13,
26,
70 
],
[
 "Hakeem Olajuwon*",
170,
222,
575,
178,
179,
1124 
],
[
 "Hamady N'Diaye",
6,
7,
18,
9,
6,
20 
],
[
 "Hamed Haddadi",
79,
137,
235,
92,
92,
339 
],
[
 "Hanno Mottola",
57,
81,
187,
19,
70,
396 
],
[
 "Hasheem Thabeet",
119,
203,
392,
184,
123,
483 
],
[
 "Hassan Whiteside",
83,
161,
360,
138,
63,
593 
],
[
 "Henry Sims",
196,
227,
371,
50,
141,
940 
],
[
 "Hilton Armstrong",
171,
275,
430,
134,
217,
829 
],
[
 "Horace Grant",
80,
159,
322,
49,
51,
608 
],
[
 "Ian Mahinmi",
422,
491,
899,
242,
301,
1588 
],
[
 "Isaac Austin",
32,
61,
232,
28,
65,
302 
],
[
 "J.J. Hickson",
590,
685,
1455,
170,
459,
2920 
],
[
 "Jabari Smith",
37,
20,
47,
12,
15,
163 
],
[
 "Jackie Butler",
69,
73,
132,
31,
73,
343 
],
[
 "Jackson Vroman",
44,
59,
103,
17,
57,
196 
],
[
 "Jahidi White",
354,
482,
851,
261,
287,
1336 
],
[
 "Jake Tsakalidis",
337,
436,
802,
223,
268,
1497 
],
[
 "Jake Voskuhl",
467,
562,
977,
166,
340,
1814 
],
[
 "Jamaal Magloire",
1391,
1418,
2990,
603,
998,
4917 
],
[
 "Jamal Sampson",
13,
38,
62,
11,
16,
53 
],
[
 "James Lang",
3,
5,
6,
3,
2,
11 
],
[
 "Jamie Feick",
6,
12,
44,
3,
7,
22 
],
[
 "Jared Reiner",
4,
34,
75,
13,
23,
54 
],
[
 "Jarron Collins",
731,
645,
934,
98,
334,
2095 
],
[
 "Jason Collier",
158,
175,
268,
32,
120,
841 
],
[
 "Jason Collins",
719,
825,
1565,
321,
532,
2452 
],
[
 "Jason Maxiell",
416,
595,
749,
255,
237,
1950 
],
[
 "Jason Smith",
272,
251,
500,
121,
212,
1407 
],
[
 "Jason Thompson",
198,
224,
413,
73,
139,
939 
],
[
 "JaVale McGee",
525,
780,
1327,
685,
417,
3222 
],
[
 "Jeff Ayres",
22,
37,
94,
18,
14,
138 
],
[
 "Jeff Foote",
0,
1,
5,
1,
2,
4 
],
[
 "Jeff Foster",
779,
2089,
3127,
307,
611,
3704 
],
[
 "Jeff Withey",
86,
72,
142,
68,
32,
288 
],
[
 "Jelani McCoy",
114,
204,
459,
127,
190,
818 
],
[
 "Jeremy Tyler",
59,
98,
171,
42,
68,
373 
],
[
 "Jermaine O'Neal",
1180,
878,
2295,
879,
860,
5514 
],
[
 "Jerome James",
234,
387,
695,
378,
394,
1516 
],
[
 "Jerome Jordan",
46,
66,
66,
21,
24,
180 
],
[
 "Jerome Moiso",
48,
84,
191,
54,
79,
278 
],
[
 "Jim McIlvaine",
8,
8,
27,
15,
9,
28 
],
[
 "Joakim Noah",
1243,
1823,
3309,
774,
963,
5201 
],
[
 "Joe Smith",
230,
241,
475,
99,
111,
1141 
],
[
 "Joel Anthony",
228,
508,
700,
482,
204,
936 
],
[
 "Joel Freeland",
41,
150,
249,
45,
55,
343 
],
[
 "Joel Przybilla",
501,
1112,
2553,
836,
574,
2293 
],
[
 "Joey Dorsey",
31,
79,
111,
17,
39,
135 
],
[
 "Joffrey Lauvergne",
18,
27,
50,
10,
22,
93 
],
[
 "Johan Petro",
248,
536,
1300,
234,
374,
2202 
],
[
 "John Amaechi",
201,
103,
242,
36,
158,
749 
],
[
 "John Coker",
0,
3,
2,
0,
2,
2 
],
[
 "John Edwards",
15,
26,
41,
19,
20,
99 
],
[
 "John Henson",
78,
124,
188,
135,
87,
470 
],
[
 "John Thomas",
30,
49,
68,
15,
26,
126 
],
[
 "Jon Brockman",
40,
74,
110,
3,
24,
136 
],
[
 "Jon Leuer",
2,
5,
8,
0,
5,
22 
],
[
 "Jonas Valanciunas",
561,
562,
1217,
244,
339,
2433 
],
[
 "Jordan Hill",
214,
363,
685,
131,
199,
1441 
],
[
 "Jordan Williams",
43,
66,
90,
15,
23,
197 
],
[
 "Josh Boone",
32,
104,
154,
48,
31,
258 
],
[
 "Josh Harrellson",
6,
33,
50,
16,
13,
103 
],
[
 "Josh McRoberts",
19,
40,
87,
16,
19,
179 
],
[
 "Josh Powell",
63,
115,
216,
23,
65,
353 
],
[
 "Justin Hamilton",
44,
61,
80,
30,
30,
245 
],
[
 "Justin Williams",
31,
71,
93,
21,
19,
165 
],
[
 "Jusuf Nurkic",
84,
125,
257,
68,
86,
426 
],
[
 "Juwan Howard",
55,
108,
227,
10,
72,
437 
],
[
 "Keith Benson",
0,
2,
1,
0,
0,
0 
],
[
 "Kelly Olynyk",
192,
232,
436,
66,
204,
1263 
],
[
 "Kelvin Cato",
362,
489,
1122,
315,
222,
1542 
],
[
 "Ken Johnson",
2,
4,
28,
12,
6,
32 
],
[
 "Kendrick Perkins",
792,
1280,
3123,
892,
1191,
4120 
],
[
 "Kenyon Martin",
17,
34,
61,
17,
16,
129 
],
[
 "Keon Clark",
239,
320,
734,
272,
234,
1451 
],
[
 "Kevin Garnett",
358,
201,
1181,
163,
286,
2303 
],
[
 "Kevin Love",
265,
274,
460,
50,
118,
899 
],
[
 "Kevin Seraphin",
193,
350,
692,
220,
335,
1943 
],
[
 "Kevin Willis",
205,
326,
606,
88,
194,
1270 
],
[
 "Kosta Koufos",
275,
710,
1267,
338,
294,
2281 
],
[
 "Kosta Perovic",
4,
6,
7,
2,
1,
10 
],
[
 "Kurt Thomas",
550,
779,
2247,
379,
490,
3727 
],
[
 "Kwame Brown",
626,
772,
1607,
283,
521,
2680 
],
[
 "Kyle O'Quinn",
87,
165,
408,
114,
115,
661 
],
[
 "Kyrylo Fesenko",
55,
97,
172,
53,
66,
305 
],
[
 "LaMarcus Aldridge",
83,
144,
168,
73,
43,
565 
],
[
 "Lance Allred",
1,
0,
1,
0,
0,
3 
],
[
 "Larry Sanders",
162,
410,
771,
352,
179,
1330 
],
[
 "Lavoy Allen",
43,
159,
236,
55,
55,
455 
],
[
 "Lawrence Roberts",
11,
26,
23,
2,
5,
51 
],
[
 "Leon Powe",
271,
200,
267,
39,
97,
797 
],
[
 "Leon Smith",
11,
11,
22,
1,
3,
33 
],
[
 "Lonny Baxter",
116,
145,
225,
47,
81,
494 
],
[
 "Loren Woods",
138,
263,
419,
128,
138,
555 
],
[
 "Lorenzen Wright",
680,
1043,
2157,
349,
603,
4240 
],
[
 "Luc Longley",
13,
26,
40,
9,
22,
49 
],
[
 "Lucas Nogueira",
2,
2,
9,
0,
2,
6 
],
[
 "Luke Schenscher",
9,
18,
36,
7,
9,
55 
],
[
 "Luke Zeller",
0,
1,
9,
0,
0,
19 
],
[
 "Maciej Lampe",
25,
37,
105,
10,
35,
215 
],
[
 "Mamadou N'Diaye",
92,
88,
137,
64,
40,
262 
],
[
 "Marc Gasol",
1787,
1066,
3003,
802,
1010,
7285 
],
[
 "Marc Jackson",
689,
523,
814,
89,
378,
2624 
],
[
 "Marcin Gortat",
726,
955,
2692,
590,
544,
4894 
],
[
 "Marcus Camby",
1105,
1811,
5432,
1668,
904,
6196 
],
[
 "Marcus Cousin",
0,
0,
3,
1,
1,
4 
],
[
 "Mario Kasun",
42,
76,
112,
16,
41,
198 
],
[
 "Mark Blount",
864,
895,
1889,
508,
933,
4941 
],
[
 "Mark Madsen",
112,
292,
354,
60,
121,
488 
],
[
 "Marreese Speights",
510,
519,
912,
196,
283,
2650 
],
[
 "Martynas Andriuskevicius",
0,
1,
3,
0,
0,
0 
],
[
 "Mason Plumlee",
157,
175,
337,
63,
106,
717 
],
[
 "Matt Bonner",
56,
108,
177,
19,
40,
589 
],
[
 "Matt Geiger",
38,
53,
92,
10,
27,
216 
],
[
 "Maurice Taylor",
24,
26,
67,
8,
31,
176 
],
[
 "Mehmet Okur",
1297,
773,
2161,
278,
661,
5913 
],
[
 "Melvin Ely",
127,
152,
320,
73,
134,
629 
],
[
 "Mengke Bateer",
29,
39,
75,
5,
40,
156 
],
[
 "Meyers Leonard",
118,
152,
464,
57,
103,
802 
],
[
 "Michael Bradley",
0,
5,
7,
0,
4,
12 
],
[
 "Michael Doleac",
255,
427,
1046,
158,
285,
2013 
],
[
 "Michael Olowokandi",
379,
637,
1764,
502,
636,
2951 
],
[
 "Michael Ruffin",
91,
369,
420,
91,
101,
307 
],
[
 "Michael Stewart",
18,
31,
34,
8,
11,
60 
],
[
 "Mike Sweetney",
346,
332,
556,
95,
245,
1336 
],
[
 "Mikki Moore",
356,
403,
706,
170,
292,
1643 
],
[
 "Mile Ilic",
0,
0,
1,
0,
3,
0 
],
[
 "Miles Plumlee",
99,
322,
646,
159,
165,
953 
],
[
 "Miroslav Raduljica",
47,
56,
57,
13,
30,
189 
],
[
 "Mouhamed Sene",
33,
28,
47,
22,
15,
103 
],
[
 "Nate Huffman",
5,
9,
14,
3,
3,
23 
],
[
 "Nathan Jawai",
26,
49,
55,
9,
27,
124 
],
[
 "Nazr Mohammed",
997,
1773,
2844,
623,
886,
5723 
],
[
 "Nenad Krstic",
390,
429,
918,
160,
252,
2383 
],
[
 "Nene Hilario",
1490,
1019,
2333,
466,
904,
6034 
],
[
 "Nerlens Noel",
140,
185,
426,
142,
146,
744 
],
[
 "Nick Collison",
524,
960,
1604,
275,
445,
3017 
],
[
 "Nikola Pekovic",
761,
796,
990,
151,
405,
3351 
],
[
 "Nikola Vucevic",
373,
784,
1815,
214,
434,
3530 
],
[
 "Obinna Ekezie",
72,
69,
110,
12,
45,
230 
],
[
 "Ognjen Kuzmic",
9,
17,
21,
5,
15,
35 
],
[
 "Olden Polynice",
17,
158,
222,
77,
82,
429 
],
[
 "Oleksiy Pecherov",
73,
88,
178,
22,
59,
438 
],
[
 "Oliver Miller",
15,
46,
84,
26,
33,
121 
],
[
 "Olumide Oyedeji",
27,
61,
135,
15,
30,
127 
],
[
 "Omer Asik",
497,
859,
1879,
302,
459,
2103 
],
[
 "Othella Harrington",
258,
204,
380,
62,
217,
1058 
],
[
 "P.J. Brown",
486,
712,
1363,
220,
283,
2022 
],
[
 "Pape Sow",
61,
78,
136,
24,
41,
219 
],
[
 "Pat Burke",
61,
90,
176,
40,
87,
468 
],
[
 "Patrick Ewing*",
266,
184,
664,
136,
216,
1150 
],
[
 "Patrick O'Bryant",
28,
32,
95,
40,
42,
186 
],
[
 "Pau Gasol",
2099,
1439,
3355,
809,
1093,
9213 
],
[
 "Paul Davis",
7,
21,
23,
5,
8,
51 
],
[
 "Paul Grant",
3,
7,
10,
1,
7,
25 
],
[
 "Pavel Podkolzin",
4,
0,
9,
1,
4,
4 
],
[
 "Pervis Ellison",
2,
2,
10,
2,
3,
6 
],
[
 "Peter John Ramos",
1,
1,
3,
1,
3,
11 
],
[
 "Predrag Drobnjak",
315,
313,
660,
117,
242,
2187 
],
[
 "Primoz Brezec",
427,
563,
764,
134,
274,
2452 
],
[
 "Raef LaFrentz",
369,
532,
1130,
540,
258,
2895 
],
[
 "Rafael Araujo",
76,
124,
271,
16,
111,
389 
],
[
 "Randolph Morris",
20,
17,
49,
4,
18,
78 
],
[
 "Rasheed Wallace",
411,
283,
1669,
418,
312,
3556 
],
[
 "Rasho Nesterovic",
317,
1375,
2381,
849,
676,
5040 
],
[
 "Ratko Varda",
1,
0,
1,
0,
1,
5 
],
[
 "Robert Archibald",
13,
21,
29,
3,
9,
29 
],
[
 "Robert Sacre",
126,
180,
341,
100,
90,
700 
],
[
 "Robert Swift",
72,
122,
254,
86,
71,
416 
],
[
 "Robert Traylor",
262,
474,
682,
200,
286,
1441 
],
[
 "Robert Whaley",
3,
16,
27,
8,
14,
49 
],
[
 "Robin Lopez",
766,
1070,
1277,
550,
427,
3802 
],
[
 "Ronny Turiaf",
497,
520,
1237,
593,
358,
2209 
],
[
 "Roy Hibbert",
1183,
1341,
2282,
990,
930,
5909 
],
[
 "Ruben Boumtje-Boumtje",
15,
22,
35,
17,
14,
43 
],
[
 "Rudy Gobert",
202,
316,
614,
230,
143,
790 
],
[
 "Ryan Hollins",
423,
326,
519,
189,
306,
1501 
],
[
 "Samaki Walker",
66,
115,
253,
55,
56,
296 
],
[
 "Samardo Samuels",
96,
73,
135,
23,
62,
350 
],
[
 "Samuel Dalembert",
1193,
2289,
4653,
1546,
1271,
6814 
],
[
 "Scot Pollard",
357,
661,
1130,
265,
237,
1639 
],
[
 "Scott Williams",
118,
222,
497,
75,
94,
907 
],
[
 "Sean Marks",
69,
120,
241,
61,
75,
402 
],
[
 "Sean May",
21,
20,
50,
7,
19,
123 
],
[
 "Sean Rooks",
208,
200,
540,
139,
181,
1067 
],
[
 "Sean Williams",
93,
128,
219,
114,
80,
449 
],
[
 "Semih Erden",
60,
57,
133,
29,
50,
262 
],
[
 "Shaquille O'Neal",
3041,
2047,
4437,
1296,
1756,
13909 
],
[
 "Shareef Abdur-Rahim",
170,
122,
276,
40,
116,
793 
],
[
 "Shawn Bradley",
424,
506,
1141,
599,
230,
1767 
],
[
 "Shawn Kemp",
115,
147,
304,
33,
102,
537 
],
[
 "Shawnelle Scott",
17,
76,
77,
12,
26,
125 
],
[
 "Shelden Williams",
76,
141,
209,
39,
66,
268 
],
[
 "Sim Bhullar",
0,
0,
1,
1,
0,
2 
],
[
 "Slavko Vranes",
0,
0,
0,
0,
0,
0 
],
[
 "Solomon Alabi",
7,
22,
39,
11,
8,
39 
],
[
 "Solomon Jones",
160,
169,
271,
99,
115,
595 
],
[
 "Soumaila Samake",
12,
32,
44,
19,
6,
68 
],
[
 "Spencer Hawes",
529,
872,
2328,
542,
803,
4830 
],
[
 "Stanislav Medvedenko",
58,
89,
83,
13,
47,
373 
],
[
 "Steven Adams",
182,
341,
514,
143,
170,
802 
],
[
 "Steven Hunter",
273,
368,
561,
346,
184,
1367 
],
[
 "Stromile Swift",
233,
188,
353,
112,
160,
1005 
],
[
 "Tarik Black",
65,
142,
226,
24,
48,
379 
],
[
 "Theo Ratliff",
667,
811,
1804,
1144,
561,
2921 
],
[
 "Tiago Splitter",
412,
379,
743,
132,
254,
1738 
],
[
 "Tim Duncan",
2138,
1433,
4487,
1141,
1232,
10215 
],
[
 "Tim Ohlbrecht",
1,
0,
1,
0,
4,
3 
],
[
 "Timofey Mozgov",
447,
523,
1003,
282,
351,
2065 
],
[
 "Todd Fuller",
8,
7,
11,
2,
3,
28 
],
[
 "Todd MacCulloch",
205,
292,
450,
140,
128,
1163 
],
[
 "Tony Battie",
462,
806,
1798,
448,
387,
2886 
],
[
 "Tony Massenburg",
65,
59,
97,
19,
50,
273 
],
[
 "Travis Knight",
35,
85,
134,
30,
47,
187 
],
[
 "Trey Thompkins",
5,
4,
20,
3,
6,
57 
],
[
 "Tyler Zeller",
360,
408,
777,
160,
231,
1842 
],
[
 "Tyrus Thomas",
169,
104,
272,
103,
105,
671 
],
[
 "Tyson Chandler",
2002,
2868,
5423,
1166,
1351,
7920 
],
[
 "Uros Slokar",
9,
7,
7,
2,
9,
38 
],
[
 "Vernon Macklin",
8,
14,
20,
4,
3,
46 
],
[
 "Viacheslav Kravtsov",
15,
33,
29,
10,
20,
97 
],
[
 "Victor Alexander",
4,
7,
22,
1,
5,
40 
],
[
 "Vin Baker",
230,
260,
309,
70,
199,
1073 
],
[
 "Vitaly Potapenko",
322,
556,
808,
82,
300,
1738 
],
[
 "Vitor Faverani",
24,
42,
86,
27,
41,
164 
],
[
 "Vlade Divac",
808,
723,
1690,
370,
689,
3491 
],
[
 "Vladimir Stepania",
168,
396,
662,
110,
159,
916 
],
[
 "Wang Zhizhi",
108,
56,
175,
35,
68,
604 
],
[
 "Will Perdue",
2,
6,
12,
2,
0,
14 
],
[
 "Yao Ming",
2485,
1233,
3261,
920,
1311,
9247 
],
[
 "Zach Randolph",
278,
224,
623,
19,
209,
1443 
],
[
 "Zan Tabak",
20,
65,
148,
30,
57,
216 
],
[
 "Zaza Pachulia",
1716,
1785,
2816,
289,
1109,
5698 
],
[
 "Zeljko Rebraca",
300,
196,
492,
160,
203,
1276 
],
[
 "Zendon Hamilton",
115,
74,
137,
10,
48,
261 
],
[
 "Zydrunas Ilgauskas",
2283,
2148,
3276,
1185,
1354,
9761 
] 
];
data.addColumn('string','Player');
data.addColumn('number','FT');
data.addColumn('number','ORB');
data.addColumn('number','DRB');
data.addColumn('number','BLK');
data.addColumn('number','TOV');
data.addColumn('number','PTS');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartTableID101032ad5156() {
var data = gvisDataTableID101032ad5156();
var options = {};
options["allowHtml"] = true;
options["page"] = "enable";

  var dataFormat1 = new google.visualization.NumberFormat({pattern:"#,###"});
  dataFormat1.format(data, 6);

    var chart = new google.visualization.Table(
    document.getElementById('TableID101032ad5156')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "table";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartTableID101032ad5156);
})();
function displayChartTableID101032ad5156() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartTableID101032ad5156"></script>
 
<!-- divChart -->
  
<div id="TableID101032ad5156" 
  style="width: 500; height: automatic;">
</div>



```r
pos_summary <- NBA %>%
                filter(Year > 2010) %>%
                group_by(Pos, Year) %>%
                summarise(ORB=sum(ORB), DRB=sum(DRB),
                          AST=sum(AST), STL=sum(STL),
                          BLK=sum(BLK), TOV=sum(TOV),
                          PTS=sum(PTS))

bubble <- gvisBubbleChart(pos_summary, idvar="Pos",
                          xvar="AST", yvar="DRB",
                          colorvar="Year", sizevar="PTS",
                          options=list(
                            width=800,
                            height=500,
                            vAxis="{title:'Defensive Rebound'}", 
                            hAxis="{title:'Assist'}",
                            sizeAxis="{minValue:29000, maxSize:20}"
                          ))

plot(bubble)
```

<!-- BubbleChart generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:44 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataBubbleChartID101043b13da1 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "C",
3635,
15105,
"2011",
29047 
],
[
 "C",
5295,
20005,
"2012",
40853 
],
[
 "C",
4971,
19363,
"2013",
38329 
],
[
 "C",
4959,
19464,
"2014",
38238 
],
[
 "F",
1,
13,
"2013",
25 
],
[
 "G",
0,
3,
"2013",
2 
],
[
 "G-F",
3,
11,
"2013",
6 
],
[
 "PF",
5069,
16818,
"2011",
41166 
],
[
 "PF",
7372,
21143,
"2012",
52279 
],
[
 "PF",
7635,
21698,
"2013",
55527 
],
[
 "PF",
7910,
22308,
"2014",
53074 
],
[
 "PG",
16765,
7835,
"2011",
39029 
],
[
 "PG",
20833,
9146,
"2012",
48308 
],
[
 "PG",
21720,
10724,
"2013",
53685 
],
[
 "PG",
22193,
11719,
"2014",
54465 
],
[
 "SF",
6760,
11882,
"2011",
36595 
],
[
 "SF",
8453,
14556,
"2012",
46092 
],
[
 "SF",
9008,
15634,
"2013",
48214 
],
[
 "SF",
7432,
13287,
"2014",
41669 
],
[
 "SG",
9304,
9361,
"2011",
44757 
],
[
 "SG",
12462,
11269,
"2012",
53691 
],
[
 "SG",
10793,
10869,
"2013",
52694 
],
[
 "SG",
11708,
12945,
"2014",
58589 
] 
];
data.addColumn('string','Pos');
data.addColumn('number','AST');
data.addColumn('number','DRB');
data.addColumn('string','Year');
data.addColumn('number','PTS');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartBubbleChartID101043b13da1() {
var data = gvisDataBubbleChartID101043b13da1();
var options = {};
options["width"] =    800;
options["height"] =    500;
options["vAxis"] = {title:'Defensive Rebound'};
options["hAxis"] = {title:'Assist'};
options["sizeAxis"] = {minValue:29000, maxSize:20};

    var chart = new google.visualization.BubbleChart(
    document.getElementById('BubbleChartID101043b13da1')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartBubbleChartID101043b13da1);
})();
function displayChartBubbleChartID101043b13da1() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartBubbleChartID101043b13da1"></script>
 
<!-- divChart -->
  
<div id="BubbleChartID101043b13da1" 
  style="width: 800; height: 500;">
</div>


```r
allpg <- NBA %>% filter(Pos == 'PG') %>%
          group_by(Player) %>%
          summarise(AST=sum(AST))

pghist <- gvisHistogram(allpg,
                        options=list(
                          width=800,
                          height=500,
                          colors="['#5C3292', '#1A8763', '#871B47']"
                        ))

plot(pghist)
```

<!-- Histogram generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:44 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataHistogramID10103a797eb4 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "A.J. Guyton",
147 
],
[
 "A.J. Price",
554 
],
[
 "Aaron Brooks",
1600 
],
[
 "Aaron McKie",
11 
],
[
 "Aaron Miles",
24 
],
[
 "Acie Law",
309 
],
[
 "Allen Iverson",
1511 
],
[
 "Alvin Williams",
887 
],
[
 "Andre Barrett",
135 
],
[
 "Andre Miller",
7323 
],
[
 "Andre Owens",
55 
],
[
 "Anthony Carter",
1985 
],
[
 "Anthony Goldwire",
129 
],
[
 "Anthony Johnson",
1718 
],
[
 "Anthony Roberson",
35 
],
[
 "Antonio Burks",
104 
],
[
 "Antonio Daniels",
1430 
],
[
 "Armon Johnson",
56 
],
[
 "Austin Rivers",
68 
],
[
 "Avery Bradley",
288 
],
[
 "Avery Johnson",
698 
],
[
 "Baron Davis",
5716 
],
[
 "Ben Hansbrough",
21 
],
[
 "Ben Uzoh",
130 
],
[
 "Beno Udrih",
2130 
],
[
 "Bimbo Coles",
332 
],
[
 "Blake Ahearn",
22 
],
[
 "Bob Sura",
592 
],
[
 "Bobby Brown",
118 
],
[
 "Bobby Jackson",
908 
],
[
 "Brandin Knight",
1 
],
[
 "Brandon Jennings",
2542 
],
[
 "Brandon Knight",
1187 
],
[
 "Brent Price",
14 
],
[
 "Brevin Knight",
3065 
],
[
 "Brian Roberts",
615 
],
[
 "Brian Shaw",
192 
],
[
 "Bryce Cotton",
15 
],
[
 "Bryce Drew",
310 
],
[
 "C.J. Miles",
16 
],
[
 "C.J. Watson",
1283 
],
[
 "Carldell Johnson",
22 
],
[
 "Carlos Arroyo",
1684 
],
[
 "Casper Ware",
10 
],
[
 "Cedric Jackson",
14 
],
[
 "Charles Jenkins",
186 
],
[
 "Charlie Ward",
1040 
],
[
 "Chauncey Billups",
4679 
],
[
 "Chris Childs",
722 
],
[
 "Chris Duhon",
2690 
],
[
 "Chris Garner",
18 
],
[
 "Chris Herren",
56 
],
[
 "Chris Paul",
6950 
],
[
 "Chris Quinn",
446 
],
[
 "Chris Smith",
0 
],
[
 "Chris Whitney",
721 
],
[
 "Chucky Atkins",
1974 
],
[
 "Corey Benjamin",
69 
],
[
 "Cory Alexander",
36 
],
[
 "Cory Higgins",
36 
],
[
 "Cory Joseph",
275 
],
[
 "Courtney Alexander",
141 
],
[
 "Courtney Fortson",
10 
],
[
 "D.J. Augustin",
2084 
],
[
 "Damian Lillard",
1495 
],
[
 "Damon Jones",
1542 
],
[
 "Damon Stoudamire",
2712 
],
[
 "Dan Dickau",
752 
],
[
 "Dana Barros",
188 
],
[
 "Daniel Ewing",
90 
],
[
 "Daniel Gibson",
498 
],
[
 "Dante Exum",
198 
],
[
 "Darius Morris",
189 
],
[
 "Darrell Armstrong",
2139 
],
[
 "Darren Collison",
2086 
],
[
 "Darrick Martin",
189 
],
[
 "David Stockton",
9 
],
[
 "David Vanterpool",
66 
],
[
 "Dean Oliver",
44 
],
[
 "Dee Brown",
133 
],
[
 "Delonte West",
761 
],
[
 "DeMarcus Nelson",
13 
],
[
 "Dennis Schroder",
410 
],
[
 "Derek Anderson",
325 
],
[
 "Derek Fisher",
2345 
],
[
 "Deron Williams",
6081 
],
[
 "Derrick Rose",
2205 
],
[
 "Derrick Zimmerman",
7 
],
[
 "Devin Harris",
3144 
],
[
 "Diante Garrett",
151 
],
[
 "Dominique Jones",
83 
],
[
 "Donald Sloan",
296 
],
[
 "Doug Overton",
223 
],
[
 "Dwight Buycks",
24 
],
[
 "Dwyane Wade",
275 
],
[
 "E'Twaun Moore",
34 
],
[
 "Earl Boykins",
1716 
],
[
 "Earl Watson",
3871 
],
[
 "Eddie Gill",
217 
],
[
 "Eddie House",
682 
],
[
 "Eldridge Recasner",
44 
],
[
 "Elfrid Payton",
533 
],
[
 "Elliot Perry",
86 
],
[
 "Emanual Davis",
68 
],
[
 "Eric Bledsoe",
1316 
],
[
 "Eric Gordon",
31 
],
[
 "Eric Maynor",
651 
],
[
 "Eric Snow",
2594 
],
[
 "Erick Barkley",
40 
],
[
 "Erick Green",
39 
],
[
 "Erick Strickland",
369 
],
[
 "Eugene Jeter",
162 
],
[
 "Felipe Lopez",
34 
],
[
 "Frank Williams",
155 
],
[
 "Gabe Pruitt",
13 
],
[
 "Gal Mekel",
76 
],
[
 "Garrett Temple",
24 
],
[
 "Gary Grant",
1 
],
[
 "Gary Payton*",
3418 
],
[
 "George Hill",
1540 
],
[
 "Gerald Fitch",
33 
],
[
 "Gilbert Arenas",
2909 
],
[
 "Goran Dragic",
1615 
],
[
 "Greg Anthony",
364 
],
[
 "Greivis Vasquez",
1101 
],
[
 "Horace Jenkins",
9 
],
[
 "Howard Eisley",
1136 
],
[
 "Hubert Davis",
110 
],
[
 "Igor Rakocevic",
33 
],
[
 "Iman Shumpert",
164 
],
[
 "Ira Bowman",
7 
],
[
 "Isaiah Canaan",
120 
],
[
 "Isaiah Thomas",
1320 
],
[
 "Ish Smith",
566 
],
[
 "J.J. Barea",
566 
],
[
 "J.J. Redick",
36 
],
[
 "J.R. Bremer",
215 
],
[
 "Jacque Vaughn",
1444 
],
[
 "Jalen Rose",
273 
],
[
 "Jamaal Tinsley",
3330 
],
[
 "Jamal Crawford",
961 
],
[
 "Jameer Nelson",
3754 
],
[
 "James Robinson",
0 
],
[
 "JamesOn Curry",
0 
],
[
 "Jamison Brewer",
47 
],
[
 "Jannero Pargo",
794 
],
[
 "Jarrett Jack",
1871 
],
[
 "Jason Hart",
774 
],
[
 "Jason Kidd",
7994 
],
[
 "Jason Terry",
1828 
],
[
 "Jason Williams",
3723 
],
[
 "Javaris Crittenton",
145 
],
[
 "Jawad Williams",
34 
],
[
 "Jay Williams",
350 
],
[
 "Jeff McInnis",
2086 
],
[
 "Jeff Teague",
2201 
],
[
 "Jerel McNeal",
2 
],
[
 "Jeremy Lin",
1388 
],
[
 "Jeremy Pargo",
119 
],
[
 "Jermaine Jackson",
25 
],
[
 "Jerome Dyson",
18 
],
[
 "Jerry Smith",
4 
],
[
 "Jerryd Bayless",
1153 
],
[
 "Jimmer Fredette",
166 
],
[
 "Joe Crispin",
26 
],
[
 "John Crotty",
204 
],
[
 "John Lucas",
259 
],
[
 "John Lucas III",
102 
],
[
 "John Salmons",
47 
],
[
 "John Stockton*",
2016 
],
[
 "John Wall",
2990 
],
[
 "Jonny Flynn",
634 
],
[
 "Jordan Clarkson",
206 
],
[
 "Jordan Farmar",
1407 
],
[
 "Jorge Gutierrez",
52 
],
[
 "Jose Barea",
1183 
],
[
 "Jose Calderon",
4242 
],
[
 "Josh Akognon",
1 
],
[
 "Josh Selby",
34 
],
[
 "Jrue Holiday",
2268 
],
[
 "Juan Dixon",
255 
],
[
 "Julyan Stone",
2 
],
[
 "Junior Harrington",
366 
],
[
 "Justin Dentmon",
10 
],
[
 "Kalin Lucas",
0 
],
[
 "Kareem Rush",
68 
],
[
 "Keith McLeod",
536 
],
[
 "Kemba Walker",
1525 
],
[
 "Kendall Marshall",
706 
],
[
 "Kenny Anderson",
963 
],
[
 "Kenny Satterfield",
176 
],
[
 "Kevin Burleson",
48 
],
[
 "Kevin Martin",
22 
],
[
 "Kevin Ollie",
1248 
],
[
 "Keyon Dooling",
1349 
],
[
 "Khalid El-Amin",
145 
],
[
 "Kirk Hinrich",
3155 
],
[
 "Kyle Lowry",
3212 
],
[
 "Kyrie Irving",
1447 
],
[
 "Langston Galloway",
150 
],
[
 "Laron Profit",
89 
],
[
 "Larry Drew",
45 
],
[
 "Larry Hughes",
306 
],
[
 "Larry Robinson",
36 
],
[
 "Leandro Barbosa",
445 
],
[
 "Lester Hudson",
66 
],
[
 "Lindsey Hunter",
656 
],
[
 "Lionel Chalmers",
51 
],
[
 "Lorenzo Brown",
131 
],
[
 "Lou Williams",
1072 
],
[
 "Lucious Harris",
135 
],
[
 "Luis Flores",
11 
],
[
 "Luke Ridnour",
3150 
],
[
 "Luther Head",
105 
],
[
 "Maalik Wayns",
29 
],
[
 "Mahmoud Abdul-Rauf",
76 
],
[
 "Marco Belinelli",
15 
],
[
 "Marcus Banks",
728 
],
[
 "Marcus Smart",
208 
],
[
 "Marcus Williams",
574 
],
[
 "Mardy Collins",
101 
],
[
 "Mario Chalmers",
1985 
],
[
 "Mark Jackson",
1760 
],
[
 "Marko Jaric",
877 
],
[
 "Marquis Teague",
63 
],
[
 "Mateen Cleaves",
310 
],
[
 "Matt Maloney",
171 
],
[
 "Maurice Baker",
1 
],
[
 "Michael Carter-Williams",
883 
],
[
 "Michael Hawkins",
13 
],
[
 "Mickael Pietrus",
27 
],
[
 "Mike Bibby",
4527 
],
[
 "Mike Conley",
3236 
],
[
 "Mike James",
2075 
],
[
 "Mike Penberthy",
73 
],
[
 "Mike Taylor",
106 
],
[
 "Mike Wilks",
229 
],
[
 "Milt Palacio",
1117 
],
[
 "Mo Williams",
3656 
],
[
 "Monta Ellis",
471 
],
[
 "Moochie Norris",
1092 
],
[
 "Mookie Blaylock",
576 
],
[
 "Muggsy Bogues",
5 
],
[
 "Mustafa Shakur",
29 
],
[
 "Nate Robinson",
1822 
],
[
 "Nate Wolters",
208 
],
[
 "Nick Van Exel",
1294 
],
[
 "Nolan Smith",
97 
],
[
 "Norris Cole",
800 
],
[
 "Omar Cook",
46 
],
[
 "Orien Greene",
129 
],
[
 "Pablo Prigioni",
635 
],
[
 "Patrick Beverley",
460 
],
[
 "Patrick Mills",
451 
],
[
 "Paul McPherson",
38 
],
[
 "Pepe Sanchez",
49 
],
[
 "Phil Pressey",
358 
],
[
 "Quincy Douby",
93 
],
[
 "Rafer Alston",
3132 
],
[
 "Rajon Rondo",
4775 
],
[
 "Ramon Sessions",
2132 
],
[
 "Randy Brown",
191 
],
[
 "Randy Foye",
624 
],
[
 "Randy Livingston",
82 
],
[
 "Raul Lopez",
428 
],
[
 "Ray McCallum",
308 
],
[
 "Raymond Felton",
4229 
],
[
 "Reece Gaines",
50 
],
[
 "Reggie Jackson",
986 
],
[
 "Rick Brunson",
708 
],
[
 "Ricky Rubio",
1651 
],
[
 "Robert Pack",
450 
],
[
 "Rod Strickland",
1264 
],
[
 "Rodney Stuckey",
1475 
],
[
 "Rodrigue Beaubois",
374 
],
[
 "Roger Mason",
134 
],
[
 "Roko Ukic",
165 
],
[
 "Ron Harper",
113 
],
[
 "Ronald Murray",
349 
],
[
 "Ronnie Price",
673 
],
[
 "Royal Ivey",
382 
],
[
 "Russ Smith",
8 
],
[
 "Russell Westbrook",
3619 
],
[
 "Rusty LaRue",
73 
],
[
 "Salim Stoudamire",
28 
],
[
 "Sam Cassell",
3391 
],
[
 "Sam Jacobson",
4 
],
[
 "Sarunas Jasikevicius",
288 
],
[
 "Sasha Vujacic",
139 
],
[
 "Scott Machado",
6 
],
[
 "Sean Colson",
10 
],
[
 "Sean Singletary",
29 
],
[
 "Sebastian Telfair",
1960 
],
[
 "Sergio Rodriguez",
839 
],
[
 "Seth Curry",
1 
],
[
 "Shabazz Napier",
130 
],
[
 "Shammond Williams",
539 
],
[
 "Shane Heal",
5 
],
[
 "Shane Larkin",
297 
],
[
 "Shaun Livingston",
1731 
],
[
 "Shelvin Mack",
624 
],
[
 "Sherman Douglas",
144 
],
[
 "Sherron Collins",
8 
],
[
 "Smush Parker",
791 
],
[
 "Speedy Claxton",
1441 
],
[
 "Spencer Dinwiddie",
104 
],
[
 "Stephen Curry",
2866 
],
[
 "Stephon Marbury",
4186 
],
[
 "Steve Blake",
3246 
],
[
 "Steve Francis",
2713 
],
[
 "Steve Kerr",
190 
],
[
 "Steve Nash",
9444 
],
[
 "Sundiata Gaines",
81 
],
[
 "T.J. Ford",
2495 
],
[
 "Taurean Green",
8 
],
[
 "Terrell Brandon",
847 
],
[
 "Terry Porter",
456 
],
[
 "Tierre Brown",
196 
],
[
 "Tim Frazier",
60 
],
[
 "Tim Hardaway",
785 
],
[
 "Toney Douglas",
432 
],
[
 "Tony Allen",
67 
],
[
 "Tony Delk",
179 
],
[
 "Tony Parker",
5970 
],
[
 "Toure' Murry",
49 
],
[
 "Travis Best",
1307 
],
[
 "Travis Diener",
432 
],
[
 "Trey Burke",
724 
],
[
 "Troy Bell",
4 
],
[
 "Troy Hudson",
1410 
],
[
 "Ty Lawson",
2745 
],
[
 "Tyler Ennis",
73 
],
[
 "Tyronn Lue",
1685 
],
[
 "Tyshawn Taylor",
57 
],
[
 "Tyus Edney",
54 
],
[
 "Vernon Maxwell",
49 
],
[
 "Victor Oladipo",
327 
],
[
 "Vinny Del Negro",
128 
],
[
 "Vonteego Cummings",
287 
],
[
 "Walker Russell",
58 
],
[
 "Will Blalock",
17 
],
[
 "Will Bynum",
1167 
],
[
 "Will Cherry",
8 
],
[
 "Will Conroy",
15 
],
[
 "Will Solomon",
133 
],
[
 "William Avery",
111 
],
[
 "Willie Warren",
27 
],
[
 "Yuta Tabuse",
3 
],
[
 "Zabian Dowdell",
51 
],
[
 "Zach LaVine",
276 
],
[
 "Zoran Planinic",
97 
] 
];
data.addColumn('string','Player');
data.addColumn('number','AST');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartHistogramID10103a797eb4() {
var data = gvisDataHistogramID10103a797eb4();
var options = {};
options["allowHtml"] = true;
options["width"] =    800;
options["height"] =    500;
options["colors"] = ['#5C3292', '#1A8763', '#871B47'];

    var chart = new google.visualization.Histogram(
    document.getElementById('HistogramID10103a797eb4')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "corechart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartHistogramID10103a797eb4);
})();
function displayChartHistogramID10103a797eb4() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartHistogramID10103a797eb4"></script>
 
<!-- divChart -->
  
<div id="HistogramID10103a797eb4" 
  style="width: 800; height: 500;">
</div>



```r
pg <- c('Stephen Curry', 'Chris Paul', 'Russell Westbrook',
            'John Wall', 'Kyrie Irving')

famouspg <- NBA %>% filter(Player %in% pg)
#Interested column
interest <- c('Player', 'G', 'MP', 'FG', 'FGA', 'X3P', 'X3PA',
              'AST', 'STL', 'TOV', 'PTS', 'Year')

famouspg <- famouspg[interest]

M1 <- gvisMotionChart(famouspg, idvar="Player", timevar="Year", xvar="AST", yvar="PTS")

plot(M1)
```

<!-- MotionChart generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:44 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataMotionChartID101040eb4ef2 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "Chris Paul",
2005,
78,
2808,
407,
947,
50,
177,
611,
175,
183,
1258 
],
[
 "Chris Paul",
2006,
64,
2353,
381,
871,
50,
143,
569,
118,
161,
1104 
],
[
 "Chris Paul",
2007,
80,
3006,
630,
1291,
92,
249,
925,
217,
201,
1684 
],
[
 "Chris Paul",
2008,
78,
3002,
631,
1255,
64,
176,
861,
216,
231,
1781 
],
[
 "Russell Westbrook",
2008,
82,
2668,
436,
1095,
35,
129,
435,
110,
274,
1256 
],
[
 "Stephen Curry",
2009,
80,
2896,
528,
1143,
166,
380,
472,
152,
243,
1399 
],
[
 "Chris Paul",
2009,
45,
1712,
314,
637,
52,
127,
480,
96,
112,
841 
],
[
 "Russell Westbrook",
2009,
82,
2813,
485,
1160,
23,
104,
652,
108,
268,
1322 
],
[
 "Stephen Curry",
2010,
74,
2489,
505,
1053,
151,
342,
432,
109,
226,
1373 
],
[
 "Chris Paul",
2010,
80,
2880,
430,
928,
71,
183,
782,
188,
177,
1268 
],
[
 "John Wall",
2010,
69,
2606,
398,
972,
34,
115,
574,
121,
261,
1131 
],
[
 "Russell Westbrook",
2010,
82,
2847,
614,
1390,
34,
103,
670,
155,
316,
1793 
],
[
 "Stephen Curry",
2011,
26,
732,
145,
296,
55,
121,
138,
39,
65,
383 
],
[
 "Kyrie Irving",
2011,
51,
1558,
350,
747,
73,
183,
275,
54,
160,
944 
],
[
 "Chris Paul",
2011,
60,
2181,
425,
890,
79,
213,
543,
152,
124,
1189 
],
[
 "John Wall",
2011,
66,
2386,
378,
894,
3,
42,
530,
95,
255,
1076 
],
[
 "Russell Westbrook",
2011,
66,
2331,
578,
1266,
62,
196,
362,
112,
239,
1558 
],
[
 "Stephen Curry",
2012,
78,
2983,
626,
1388,
272,
600,
539,
126,
240,
1786 
],
[
 "Kyrie Irving",
2012,
59,
2048,
484,
1070,
109,
279,
350,
89,
191,
1325 
],
[
 "Chris Paul",
2012,
70,
2335,
412,
856,
76,
232,
678,
169,
159,
1186 
],
[
 "John Wall",
2012,
49,
1602,
324,
735,
12,
45,
373,
65,
157,
906 
],
[
 "Russell Westbrook",
2012,
82,
2861,
673,
1535,
97,
300,
607,
145,
273,
1903 
],
[
 "Stephen Curry",
2013,
78,
2846,
652,
1383,
261,
615,
666,
128,
294,
1873 
],
[
 "Kyrie Irving",
2013,
71,
2496,
532,
1237,
123,
344,
433,
108,
190,
1478 
],
[
 "Chris Paul",
2013,
62,
2171,
406,
870,
78,
212,
663,
154,
145,
1185 
],
[
 "John Wall",
2013,
82,
2980,
579,
1337,
108,
308,
721,
149,
295,
1583 
],
[
 "Russell Westbrook",
2013,
46,
1412,
346,
791,
68,
214,
319,
88,
177,
1002 
],
[
 "Stephen Curry",
2014,
80,
2613,
653,
1341,
286,
646,
619,
163,
249,
1900 
],
[
 "Kyrie Irving",
2014,
75,
2730,
578,
1235,
157,
378,
389,
114,
186,
1628 
],
[
 "Chris Paul",
2014,
82,
2857,
568,
1170,
139,
349,
838,
156,
190,
1564 
],
[
 "John Wall",
2014,
79,
2837,
519,
1166,
65,
217,
792,
138,
304,
1387 
],
[
 "Russell Westbrook",
2014,
67,
2302,
627,
1471,
86,
288,
574,
140,
293,
1886 
] 
];
data.addColumn('string','Player');
data.addColumn('number','Year');
data.addColumn('number','G');
data.addColumn('number','MP');
data.addColumn('number','FG');
data.addColumn('number','FGA');
data.addColumn('number','X3P');
data.addColumn('number','X3PA');
data.addColumn('number','AST');
data.addColumn('number','STL');
data.addColumn('number','TOV');
data.addColumn('number','PTS');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartMotionChartID101040eb4ef2() {
var data = gvisDataMotionChartID101040eb4ef2();
var options = {};
options["width"] =    600;
options["height"] =    500;
options["state"] = "\n{\"xAxisOption\":\"8\",\"yAxisOption\":\"11\",\"dimensions\":{\"iconDimensions\":[\"dim0\"]}}\n";

    var chart = new google.visualization.MotionChart(
    document.getElementById('MotionChartID101040eb4ef2')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "motionchart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartMotionChartID101040eb4ef2);
})();
function displayChartMotionChartID101040eb4ef2() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartMotionChartID101040eb4ef2"></script>
 
<!-- divChart -->
  
<div id="MotionChartID101040eb4ef2" 
  style="width: 600; height: 500;">
</div>


```r
sf <- c('James Harden', 'Kevin Durant', 'LeBron James',
            'Jimmy Butler', 'Paul George')

famoussf <- NBA %>% filter(Player %in% sf)
#Interested column
interest <- c('Player', 'G', 'MP', 'FG', 'FGA', 'X3P', 'X3PA',
              'ORB', 'DRB', 'AST', 'STL', 'TOV', 'PTS', 'Year')

famoussf <- famoussf[interest]

M2 <- gvisMotionChart(famoussf, idvar="Player", timevar="Year", xvar="AST", yvar="PTS")

plot(M2)
```

<!-- MotionChart generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:45 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataMotionChartID1010515c14f0 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "LeBron James",
2003,
79,
3122,
622,
1492,
63,
217,
99,
333,
465,
130,
273,
1654 
],
[
 "LeBron James",
2004,
80,
3388,
795,
1684,
108,
308,
111,
477,
577,
177,
262,
2175 
],
[
 "LeBron James",
2005,
79,
3361,
875,
1823,
127,
379,
75,
481,
521,
123,
260,
2478 
],
[
 "LeBron James",
2006,
78,
3190,
772,
1621,
99,
310,
83,
443,
470,
125,
250,
2132 
],
[
 "Kevin Durant",
2007,
80,
2768,
587,
1366,
59,
205,
70,
278,
192,
78,
232,
1624 
],
[
 "LeBron James",
2007,
75,
3027,
794,
1642,
113,
359,
133,
459,
539,
138,
255,
2250 
],
[
 "Kevin Durant",
2008,
74,
2885,
661,
1390,
97,
230,
77,
405,
205,
96,
225,
1871 
],
[
 "LeBron James",
2008,
81,
3054,
789,
1613,
132,
384,
106,
507,
587,
137,
241,
2304 
],
[
 "Kevin Durant",
2009,
82,
3239,
794,
1668,
128,
351,
105,
518,
231,
112,
271,
2472 
],
[
 "James Harden",
2009,
76,
1738,
233,
578,
93,
248,
47,
197,
137,
80,
106,
753 
],
[
 "LeBron James",
2009,
76,
2966,
768,
1528,
129,
387,
71,
483,
651,
125,
261,
2258 
],
[
 "Kevin Durant",
2010,
78,
3038,
711,
1538,
145,
414,
57,
476,
214,
88,
218,
2161 
],
[
 "Paul George",
2010,
61,
1265,
179,
395,
41,
138,
37,
187,
65,
62,
70,
476 
],
[
 "James Harden",
2010,
82,
2189,
298,
684,
113,
324,
42,
213,
176,
92,
106,
998 
],
[
 "LeBron James",
2010,
79,
3063,
758,
1485,
92,
279,
80,
510,
554,
124,
284,
2111 
],
[
 "Jimmy Butler",
2011,
42,
359,
32,
79,
2,
11,
23,
33,
14,
11,
14,
109 
],
[
 "Kevin Durant",
2011,
66,
2546,
643,
1297,
133,
344,
40,
487,
231,
88,
248,
1850 
],
[
 "Paul George",
2011,
66,
1958,
281,
639,
90,
234,
56,
314,
158,
108,
117,
798 
],
[
 "James Harden",
2011,
62,
1946,
309,
629,
114,
292,
30,
222,
229,
62,
137,
1044 
],
[
 "LeBron James",
2011,
62,
2326,
621,
1169,
54,
149,
94,
398,
387,
115,
213,
1683 
],
[
 "Jimmy Butler",
2012,
82,
2134,
239,
512,
40,
105,
136,
192,
115,
78,
62,
705 
],
[
 "Kevin Durant",
2012,
81,
3119,
731,
1433,
139,
334,
46,
594,
374,
116,
280,
2280 
],
[
 "Paul George",
2012,
79,
2972,
493,
1176,
170,
469,
88,
515,
327,
143,
233,
1377 
],
[
 "James Harden",
2012,
78,
2985,
585,
1337,
179,
486,
62,
317,
455,
142,
295,
2023 
],
[
 "LeBron James",
2012,
76,
2877,
765,
1354,
103,
254,
97,
513,
551,
129,
226,
2036 
],
[
 "Jimmy Butler",
2013,
67,
2591,
275,
693,
68,
240,
87,
243,
175,
127,
102,
878 
],
[
 "Kevin Durant",
2013,
81,
3122,
849,
1688,
192,
491,
58,
540,
445,
103,
285,
2593 
],
[
 "Paul George",
2013,
80,
2898,
577,
1362,
182,
500,
64,
478,
283,
151,
224,
1737 
],
[
 "James Harden",
2013,
73,
2777,
549,
1205,
177,
483,
61,
283,
446,
115,
265,
1851 
],
[
 "LeBron James",
2013,
77,
2902,
767,
1353,
116,
306,
81,
452,
488,
121,
270,
2089 
],
[
 "Jimmy Butler",
2014,
65,
2513,
421,
912,
73,
193,
114,
265,
212,
114,
93,
1301 
],
[
 "Kevin Durant",
2014,
27,
913,
238,
467,
64,
159,
16,
162,
110,
24,
74,
686 
],
[
 "Paul George",
2014,
6,
91,
18,
49,
9,
22,
4,
18,
6,
5,
12,
53 
],
[
 "James Harden",
2014,
81,
2981,
647,
1470,
208,
555,
75,
384,
565,
154,
321,
2217 
],
[
 "LeBron James",
2014,
69,
2493,
624,
1279,
120,
339,
51,
365,
511,
109,
272,
1743 
] 
];
data.addColumn('string','Player');
data.addColumn('number','Year');
data.addColumn('number','G');
data.addColumn('number','MP');
data.addColumn('number','FG');
data.addColumn('number','FGA');
data.addColumn('number','X3P');
data.addColumn('number','X3PA');
data.addColumn('number','ORB');
data.addColumn('number','DRB');
data.addColumn('number','AST');
data.addColumn('number','STL');
data.addColumn('number','TOV');
data.addColumn('number','PTS');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartMotionChartID1010515c14f0() {
var data = gvisDataMotionChartID1010515c14f0();
var options = {};
options["width"] =    600;
options["height"] =    500;
options["state"] = "\n{\"xAxisOption\":\"10\",\"yAxisOption\":\"13\",\"dimensions\":{\"iconDimensions\":[\"dim0\"]}}\n";

    var chart = new google.visualization.MotionChart(
    document.getElementById('MotionChartID1010515c14f0')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "motionchart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartMotionChartID1010515c14f0);
})();
function displayChartMotionChartID1010515c14f0() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartMotionChartID1010515c14f0"></script>
 
<!-- divChart -->
  
<div id="MotionChartID1010515c14f0" 
  style="width: 600; height: 500;">
</div>


```r
C <- c('Anthony Davis', 'Kevin Love', 'Dwight Howard',
            'Marc Gasol', 'DeMarcus Cousins')

famousc <- NBA %>% filter(Player %in% C)
#Interested column
interest <- c('Player', 'G', 'MP', 'FG', 'FGA', 'X3P', 'X3PA',
              'ORB', 'DRB', 'AST', 'BLK', 'TOV', 'PTS', 'Year')

famousc <- famousc[interest]

M3 <- gvisMotionChart(famousc, idvar="Player", timevar="Year", xvar="ORB", yvar="PTS")

plot(M3)
```

<!-- MotionChart generated in R 3.2.3 by googleVis 0.5.10 package -->
<!-- Tue Jan 19 15:33:45 2016 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataMotionChartID10106c5e56d7 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "Dwight Howard",
2004,
82,
2670,
352,
677,
0,
2,
287,
536,
75,
136,
165,
981 
],
[
 "Dwight Howard",
2005,
82,
3021,
468,
881,
0,
2,
288,
734,
125,
115,
217,
1292 
],
[
 "Dwight Howard",
2006,
82,
3023,
526,
873,
1,
2,
283,
725,
158,
156,
317,
1443 
],
[
 "Dwight Howard",
2007,
82,
3088,
583,
974,
0,
4,
279,
882,
110,
176,
263,
1695 
],
[
 "Marc Gasol",
2008,
82,
2521,
350,
661,
0,
1,
201,
404,
143,
90,
164,
975 
],
[
 "Dwight Howard",
2008,
79,
2821,
560,
979,
0,
2,
336,
757,
112,
231,
240,
1624 
],
[
 "Kevin Love",
2008,
81,
2048,
316,
688,
2,
19,
274,
460,
84,
50,
118,
899 
],
[
 "Marc Gasol",
2009,
69,
2469,
378,
651,
0,
1,
208,
432,
165,
109,
135,
1008 
],
[
 "Dwight Howard",
2009,
82,
2843,
510,
834,
0,
7,
284,
798,
144,
228,
274,
1503 
],
[
 "Kevin Love",
2009,
60,
1714,
291,
646,
35,
106,
227,
431,
136,
23,
117,
842 
],
[
 "DeMarcus Cousins",
2010,
81,
2309,
432,
1004,
3,
18,
217,
482,
204,
68,
268,
1143 
],
[
 "Marc Gasol",
2010,
81,
2586,
364,
691,
3,
7,
154,
415,
200,
136,
146,
951 
],
[
 "Dwight Howard",
2010,
78,
2935,
619,
1044,
0,
7,
309,
789,
107,
186,
279,
1784 
],
[
 "Kevin Love",
2010,
73,
2611,
482,
1026,
88,
211,
330,
782,
184,
28,
155,
1476 
],
[
 "DeMarcus Cousins",
2011,
64,
1950,
448,
999,
2,
14,
265,
438,
102,
75,
170,
1160 
],
[
 "Marc Gasol",
2011,
65,
2370,
357,
740,
1,
12,
120,
459,
204,
121,
121,
952 
],
[
 "Dwight Howard",
2011,
54,
2070,
416,
726,
0,
7,
200,
585,
104,
116,
175,
1113 
],
[
 "Kevin Love",
2011,
55,
2145,
474,
1059,
105,
282,
226,
508,
111,
28,
128,
1432 
],
[
 "DeMarcus Cousins",
2012,
75,
2289,
482,
1036,
4,
22,
222,
524,
199,
55,
225,
1280 
],
[
 "Anthony Davis",
2012,
64,
1846,
349,
676,
0,
6,
165,
357,
63,
112,
89,
867 
],
[
 "Marc Gasol",
2012,
80,
2796,
429,
869,
1,
14,
184,
438,
318,
139,
157,
1127 
],
[
 "Dwight Howard",
2012,
76,
2722,
470,
813,
1,
6,
251,
694,
108,
186,
225,
1296 
],
[
 "Kevin Love",
2012,
18,
618,
105,
298,
20,
92,
64,
188,
42,
9,
39,
330 
],
[
 "DeMarcus Cousins",
2013,
71,
2298,
591,
1191,
0,
7,
218,
613,
207,
91,
251,
1614 
],
[
 "Anthony Davis",
2013,
67,
2358,
522,
1005,
2,
9,
207,
466,
105,
189,
109,
1394 
],
[
 "Marc Gasol",
2013,
59,
1970,
336,
711,
2,
11,
84,
340,
215,
76,
111,
859 
],
[
 "Dwight Howard",
2013,
71,
2396,
473,
800,
2,
7,
231,
635,
131,
128,
229,
1297 
],
[
 "Kevin Love",
2013,
77,
2797,
650,
1421,
190,
505,
224,
739,
341,
35,
196,
2010 
],
[
 "DeMarcus Cousins",
2014,
59,
2013,
498,
1066,
2,
8,
185,
562,
210,
103,
254,
1421 
],
[
 "Anthony Davis",
2014,
68,
2455,
642,
1199,
1,
12,
173,
523,
149,
200,
95,
1656 
],
[
 "Marc Gasol",
2014,
81,
2687,
530,
1072,
3,
17,
115,
515,
307,
131,
176,
1413 
],
[
 "Dwight Howard",
2014,
41,
1223,
251,
423,
1,
2,
110,
321,
50,
53,
115,
646 
],
[
 "Kevin Love",
2014,
75,
2532,
413,
952,
144,
392,
142,
589,
168,
39,
122,
1228 
] 
];
data.addColumn('string','Player');
data.addColumn('number','Year');
data.addColumn('number','G');
data.addColumn('number','MP');
data.addColumn('number','FG');
data.addColumn('number','FGA');
data.addColumn('number','X3P');
data.addColumn('number','X3PA');
data.addColumn('number','ORB');
data.addColumn('number','DRB');
data.addColumn('number','AST');
data.addColumn('number','BLK');
data.addColumn('number','TOV');
data.addColumn('number','PTS');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartMotionChartID10106c5e56d7() {
var data = gvisDataMotionChartID10106c5e56d7();
var options = {};
options["width"] =    600;
options["height"] =    500;
options["state"] = "\n{\"xAxisOption\":\"8\",\"yAxisOption\":\"13\",\"dimensions\":{\"iconDimensions\":[\"dim0\"]}}\n";

    var chart = new google.visualization.MotionChart(
    document.getElementById('MotionChartID10106c5e56d7')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "motionchart";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartMotionChartID10106c5e56d7);
})();
function displayChartMotionChartID10106c5e56d7() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartMotionChartID10106c5e56d7"></script>
 
<!-- divChart -->
  
<div id="MotionChartID10106c5e56d7" 
  style="width: 600; height: 500;">
</div>


* Reference    
[googleVis Example](https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html)
