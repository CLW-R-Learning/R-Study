# Regular expression in R
Chih Hui(Jason) Wang  
November 8, 2015  


# Regular Expression (Basic)

* Concatenation: a set of characters.
* Logical OR: several pattern, use '|'.
* Replication: repetition of pattern.
* Grouping: expressions inside '()'.

You can use `help(regex)` for more information. 

1. Metacharacter

`. \ | ( ) [ { $ * + ?`
These special characters are reserved for other purposes. If you want to find a pattern with those characters including, you have to use double backslash(\\) in R to escape them.(In other languages, you can use single backslash(\) to escape them.)

```r
s1 <- c("$123", "12466", "$12,345")

#grep will return you the index of certain pattern
#Give you all the word
grep("$", s1)
```

```
[1] 1 2 3
```

```r
#Use double backslash to escape the $
grep("\\$", s1)
```

```
[1] 1 3
```

2. Sequence

Sequences of characters which can match.

Expression | Description
--- | ---
\\d | match a digit character
\\D | match a non-digit character
\\s | match a space character
\\S | match a non-space character
\\w | match a word character
\\W | match a non-word character
\\b | match a word boundary
\\B | match a non-(word boundary)
\\h | match a horizontal space
\\H | match a non-horizontal space
\\v | match a vertical space
\\V | match a non-vertical space


```r
s2 <- "2015/11/30 Sunnay day"

#Substitute for digit
gsub("\\d", "-", s2)
```

```
[1] "----/--/-- Sunnay day"
```

```r
#space
gsub("\\s", "-", s2)
```

```
[1] "2015/11/30-Sunnay-day"
```

```r
#boundary
gsub("\\b", "-", s2)
```

```
[1] "-2-0-1-5-/-1-1-/-3-0- -S-u-n-n-a-y- -d-a-y-"
```

3. Character classes

Expression | Description
--- | ---
[aeiou] | match any one lower case vowel
[AEIOU] | match any one upper case vowel
[0123456789] | match any digit
[0-9] | match any digit (same as previous class)
[a-z] | match any lower case ASCII letter
[A-Z] | match any upper case ASCII letter
[a-zA-Z0-9] | match any of the above classes
[^aeiou] | match anything other than a lowercase vowel
[^0-9] | match anything other than a digit


```r
s3 <- "Banana and Apple"

#vowel
gsub("[ae]", "i", s3)
```

```
[1] "Binini ind Appli"
```

```r
#Not vowel
gsub("[^ae]", "i", s3)
```

```
[1] "iaiaiaiaiiiiiiie"
```

4. POSIX Character Classes

Expression | Description
--- | ---
[[:lower:]] | Lower-case letters
[[:upper:]] | Upper-case letters
[[:alpha:]] | Alphabetic characters ([[:lower:]] and [[:upper:]])
[[:digit:]] | Digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
[[:alnum:]] | Alphanumeric characters ([[:alpha:]] and [[:digit:]])
[[:blank:]] | Blank characters: space and tab
[[:cntrl:]] | Control characters
[[:punct:]] | Punctuation characters: ! " # % & ' ( ) * + , - . / : ;
[[:space:]] | Space characters: tab, newline, vertical tab, form feed, carriage return, and space
[[:xdigit:]] | Hexadecimal digits: 0-9 A B C D E F a b c d e f
[[:print:]] | Printable characters ([[:alpha:]], [[:punct:]] and space)
[[:graph:]] | Graphical characters ([[:alpha:]] and [[:punct:]])


```r
gsub("[[:upper:]]", "U", s3)
```

```
[1] "Uanana and Upple"
```

5. Quantifiers

Expression | Description
--- | ---
? | The preceding item is optional and will be matched at most once
* | The preceding item will be matched zero or more times
+ | The preceding item will be matched one or more times
{n} |  The preceding item is matched n times
{n,} | The preceding item is matched n or more times
{n,m} | The preceding item is matched at least n times, but not more than m times


```r
s4 <- c("Jasonaaa", "Sanlyy", "Oraclelll")

grep("a{3}", s4)
```

```
[1] 1
```

### Demo example: mail box


```r
data <- readLines("C:/Users/jason/Desktop/Python/mbox-short.txt")

#We can find that there is some tab in some line 
head(data)
```

```
[1] "From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008"   
[2] "Return-Path: <postmaster@collab.sakaiproject.org>"          
[3] "Received: from murder (mail.umich.edu [141.211.14.90])"     
[4] "\t by frankenstein.mail.umich.edu (Cyrus v2.3.8) with LMTPA;"
[5] "\t Sat, 05 Jan 2008 09:14:16 -0500"                          
[6] "X-Sieve: CMU Sieve 2.3"                                     
```

#### Task1: Remove tab


```r
data <- gsub("\t", "", data)

#Notice the space does not remove
head(data)
```

```
[1] "From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008"  
[2] "Return-Path: <postmaster@collab.sakaiproject.org>"         
[3] "Received: from murder (mail.umich.edu [141.211.14.90])"    
[4] " by frankenstein.mail.umich.edu (Cyrus v2.3.8) with LMTPA;"
[5] " Sat, 05 Jan 2008 09:14:16 -0500"                          
[6] "X-Sieve: CMU Sieve 2.3"                                    
```

#### Task2: Remove line start by space


```r
#For thsoe start with space, we remove the first space
#Because some of line are start with many space, we write a while loop to deal with the problem
while(any(grepl("^\\s", data))){
  data[grep("^\\s", data)] <- sub("\\s", "", data[grep("^\\s", data)])
}
```

#### A alternative way for previous two tasks

```r
data2 <- readLines("C:/Users/jason/Desktop/Python/mbox-short.txt")

while(any(grepl("^[[:space:]]", data2))){
  data2[grep("^[[:space:]]", data2)] <- sub("^[[:space:]]", "", data2[grep("^[[:space:]]", data2)])
}

#Check whether they are equal
all.equal(data, data2)
```

```
[1] "1 string mismatch"
```


```r
#There is a tab in the middle of line
grep("\t", data2)
```

```
[1] 321
```


```r
data2[grep("\t", data2)]
```

```
[1] "Sakai Source Repository  \t#38024  \tWed Nov 07 14:54:46 MST 2007  \tzqian@umich.edu  \t Fix to SAK-10788: If a provided id in a couse site is fake or doesn't provide any user information, Site Info appears to be like project site with empty participant list"
```


```r
#Remove tab
data2 <- gsub("\t", "", data2)

#We are done!
all.equal(data, data2)
```

```
[1] TRUE
```


```r
#There are some line are non-character
tail(data)
```

```
[1] ""                                                                                                                           
[2] ""                                                                                                                           
[3] "----------------------"                                                                                                     
[4] "This automatic notification message was sent by Sakai Collab (https://collab.sakaiproject.org/portal) from the Source site."
[5] "You can modify how you receive notifications at My Workspace > Preferences."                                                
[6] ""                                                                                                                           
```

#### Task3: Remove unmeaningful line

* Lines without not character
* Lines start with non-character such as '----'


```r
#Start with ---
data[grep("^[[:punct:]]", data)]
```

```
 [1] "----------------------"                                                  
 [2] "----------------------"                                                  
 [3] "----------------------"                                                  
 [4] "----------------------"                                                  
 [5] "----------------------"                                                  
 [6] "----------------------"                                                  
 [7] "------------------------------------------------------------------------"
 [8] "------------------------------------------------------------------------"
 [9] "----------------------"                                                  
[10] "------------------------------------------------------------------------"
[11] "------------------------------------------------------------------------"
[12] "----------------------"                                                  
[13] "- left moot (unused) entries commented for now"                          
[14] "----------------------"                                                  
[15] "- left moot (unused) entries commented for now"                          
[16] "----------------------"                                                  
[17] "----------------------"                                                  
[18] "- left moot (unused) entries commented for now"                          
[19] "----------------------"                                                  
[20] "----------------------"                                                  
[21] "----------------------"                                                  
[22] "----------------------"                                                  
[23] "----------------------"                                                  
[24] "------------------------------------------------------------------------"
[25] "------------------------------------------------------------------------"
[26] "----------------------"                                                  
[27] "----------------------"                                                  
[28] "------------------------------------------------------------------------"
[29] "------------------------------------------------------------------------"
[30] "----------------------"                                                  
[31] "------------------------------------------------------------------------"
[32] "------------------------------------------------------------------------"
[33] "----------------------"                                                  
[34] "----------------------"                                                  
[35] "----------------------"                                                  
[36] "----------------------"                                                  
[37] "----------------------"                                                  
[38] "----------------------"                                                  
[39] "------------------------------------------------------------------------"
[40] "------------------------------------------------------------------------"
[41] "----------------------"                                                  
[42] "------------------------------------------------------------------------"
[43] "------------------------------------------------------------------------"
[44] "----------------------"                                                  
```

```r
#We use gsub to remove all the line start with non-character
while(any(grepl("^[[:punct:]]", data))){
  data[grep("^[[:punct:]]", data)] <- sub("^[[:punct:]]", "", data[grep("^[[:punct:]]", data)])
}

tail(data)
```

```
[1] ""                                                                                                                           
[2] ""                                                                                                                           
[3] ""                                                                                                                           
[4] "This automatic notification message was sent by Sakai Collab (https://collab.sakaiproject.org/portal) from the Source site."
[5] "You can modify how you receive notifications at My Workspace > Preferences."                                                
[6] ""                                                                                                                           
```

Now we can remove those line without any single character

```r
data <- data[sapply(data, nchar) != 0]

head(data)
```

```
[1] "From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008" 
[2] "Return-Path: <postmaster@collab.sakaiproject.org>"        
[3] "Received: from murder (mail.umich.edu [141.211.14.90])"   
[4] "by frankenstein.mail.umich.edu (Cyrus v2.3.8) with LMTPA;"
[5] "Sat, 05 Jan 2008 09:14:16 -0500"                          
[6] "X-Sieve: CMU Sieve 2.3"                                   
```

```r
tail(data)
```

```
[1] "r35014 | wagnermr@iupui.edu | 2007-09-12 16:17:59 -0400 (Wed, 12 Sep 2007) | 3 lines"                                       
[2] "SAK-11458"                                                                                                                  
[3] "http://bugs.sakaiproject.org/jira/browse/SAK-11458"                                                                         
[4] "Course grade does not appear on \"All Grades\" page if no categories in gb"                                                 
[5] "This automatic notification message was sent by Sakai Collab (https://collab.sakaiproject.org/portal) from the Source site."
[6] "You can modify how you receive notifications at My Workspace > Preferences."                                                
```

Now we can do some more interesting work!

#### Task4 Find email address

To find the email address, my strategy is first find out those line with @ which indicated that the line probably contain email address. Then I collapse those line into one string and seperate them by space. After that, I can search the @ sign again in those string to get the email. 

```r
linemail <- paste(data[grep("@", data)], collapse=" ")

#Sepearate by space, it will return list, so I unlist here
string <- unlist(strsplit(linemail, " "))

#It seems that it is not quite good
#There are some annoying <, > and ; in the beginning and end email
email <- string[grep("@", string)]
head(email)
```

```
[1] "stephen.marquard@uct.ac.za"                           
[2] "<postmaster@collab.sakaiproject.org>"                 
[3] "<200801051412.m05ECIaH010327@nakamura.uits.iupui.edu>"
[4] "<source@collab.sakaiproject.org>;"                    
[5] "<source@collab.sakaiproject.org>;"                    
[6] "<source@collab.sakaiproject.org>;"                    
```

Let's do more processing to get email address. 


```r
email <- gsub("<|>|\\;", "", email)
unique(email)
```

```
 [1] "stephen.marquard@uct.ac.za"                            
 [2] "postmaster@collab.sakaiproject.org"                    
 [3] "200801051412.m05ECIaH010327@nakamura.uits.iupui.edu"   
 [4] "source@collab.sakaiproject.org"                        
 [5] "apache@localhost)"                                     
 [6] "louis@media.berkeley.edu"                              
 [7] "200801042308.m04N8v6O008125@nakamura.uits.iupui.edu"   
 [8] "zqian@umich.edu"                                       
 [9] "200801042109.m04L92hb007923@nakamura.uits.iupui.edu"   
[10] "rjlowe@iupui.edu"                                      
[11] "200801042044.m04Kiem3007881@nakamura.uits.iupui.edu"   
[12] "200801042001.m04K1cO0007738@nakamura.uits.iupui.edu"   
[13] "200801041948.m04JmdwO007705@nakamura.uits.iupui.edu"   
[14] "cwen@iupui.edu"                                        
[15] "200801041635.m04GZQGZ007313@nakamura.uits.iupui.edu"   
[16] "hu2@iupui.edu"                                         
[17] "200801041633.m04GX6eG007292@nakamura.uits.iupui.edu"   
[18] "gsilver@umich.edu"                                     
[19] "200801041611.m04GB1Lb007221@nakamura.uits.iupui.edu"   
[20] "200801041610.m04GA5KP007209@nakamura.uits.iupui.edu"   
[21] "200801041609.m04G9EuX007197@nakamura.uits.iupui.edu"   
[22] "200801041608.m04G8d7w007184@nakamura.uits.iupui.edu"   
[23] "wagnermr@iupui.edu"                                    
[24] "200801041537.m04Fb6Ci007092@nakamura.uits.iupui.edu"   
[25] "200801041515.m04FFv42007050@nakamura.uits.iupui.edu"   
[26] "antranig@caret.cam.ac.uk"                              
[27] "200801041502.m04F21Jo007031@nakamura.uits.iupui.edu"   
[28] "gopal.ramasammycook@gmail.com"                         
[29] "200801041403.m04E3psW006926@nakamura.uits.iupui.edu"   
[30] "david.horwitz@uct.ac.za"                               
[31] "200801041200.m04C0gfK006793@nakamura.uits.iupui.edu"   
[32] "dhorwitz@david-horwitz-6:~/branchManagemnt/sakai_2-5-x"
[33] "200801041106.m04B6lK3006677@nakamura.uits.iupui.edu"   
[34] "200801040947.m049lUxo006517@nakamura.uits.iupui.edu"   
[35] "josrodri@iupui.edu"                                    
[36] "200801040932.m049W2i5006493@nakamura.uits.iupui.edu"   
[37] "200801040905.m0495rWB006420@nakamura.uits.iupui.edu"   
[38] "200801040023.m040NpCc005473@nakamura.uits.iupui.edu"   
[39] "200801032216.m03MGhDa005292@nakamura.uits.iupui.edu"   
[40] "ray@media.berkeley.edu"                                
[41] "200801032205.m03M5Ea7005273@nakamura.uits.iupui.edu"   
[42] "200801032133.m03LX3gG005191@nakamura.uits.iupui.edu"   
[43] "200801032127.m03LRUqH005177@nakamura.uits.iupui.edu"   
[44] "200801032122.m03LMFo4005148@nakamura.uits.iupui.edu"   
```

You can find out that there are still some line are actually not email such as dhorwitz@david-horwitz-6:~/branchManagemnt/sakai_2-5-x and 200801051412.m05ECIaH010327@nakamura.uits.iupui.edu.

Now let's try to write a more complicated regular expression. Since the email is in the format abcd@efg.hijk, first I use `[[:alnum:]]` to get the combination of digit and alphabetic characters and combine with quantifier `+` which mean one or more character. After @ at sign, I use the group expression `()` to cover the pattern efg..


```r
#You can also use grep("[[:alnum:]]+@([[:alnum:]]+\\.)+", email, value=TRUE)
email <- email[grep("[[:alnum:]]+@([[:alnum:]]+\\.)+", email)]

unique(email)
```

```
 [1] "stephen.marquard@uct.ac.za"                         
 [2] "postmaster@collab.sakaiproject.org"                 
 [3] "200801051412.m05ECIaH010327@nakamura.uits.iupui.edu"
 [4] "source@collab.sakaiproject.org"                     
 [5] "louis@media.berkeley.edu"                           
 [6] "200801042308.m04N8v6O008125@nakamura.uits.iupui.edu"
 [7] "zqian@umich.edu"                                    
 [8] "200801042109.m04L92hb007923@nakamura.uits.iupui.edu"
 [9] "rjlowe@iupui.edu"                                   
[10] "200801042044.m04Kiem3007881@nakamura.uits.iupui.edu"
[11] "200801042001.m04K1cO0007738@nakamura.uits.iupui.edu"
[12] "200801041948.m04JmdwO007705@nakamura.uits.iupui.edu"
[13] "cwen@iupui.edu"                                     
[14] "200801041635.m04GZQGZ007313@nakamura.uits.iupui.edu"
[15] "hu2@iupui.edu"                                      
[16] "200801041633.m04GX6eG007292@nakamura.uits.iupui.edu"
[17] "gsilver@umich.edu"                                  
[18] "200801041611.m04GB1Lb007221@nakamura.uits.iupui.edu"
[19] "200801041610.m04GA5KP007209@nakamura.uits.iupui.edu"
[20] "200801041609.m04G9EuX007197@nakamura.uits.iupui.edu"
[21] "200801041608.m04G8d7w007184@nakamura.uits.iupui.edu"
[22] "wagnermr@iupui.edu"                                 
[23] "200801041537.m04Fb6Ci007092@nakamura.uits.iupui.edu"
[24] "200801041515.m04FFv42007050@nakamura.uits.iupui.edu"
[25] "antranig@caret.cam.ac.uk"                           
[26] "200801041502.m04F21Jo007031@nakamura.uits.iupui.edu"
[27] "gopal.ramasammycook@gmail.com"                      
[28] "200801041403.m04E3psW006926@nakamura.uits.iupui.edu"
[29] "david.horwitz@uct.ac.za"                            
[30] "200801041200.m04C0gfK006793@nakamura.uits.iupui.edu"
[31] "200801041106.m04B6lK3006677@nakamura.uits.iupui.edu"
[32] "200801040947.m049lUxo006517@nakamura.uits.iupui.edu"
[33] "josrodri@iupui.edu"                                 
[34] "200801040932.m049W2i5006493@nakamura.uits.iupui.edu"
[35] "200801040905.m0495rWB006420@nakamura.uits.iupui.edu"
[36] "200801040023.m040NpCc005473@nakamura.uits.iupui.edu"
[37] "200801032216.m03MGhDa005292@nakamura.uits.iupui.edu"
[38] "ray@media.berkeley.edu"                             
[39] "200801032205.m03M5Ea7005273@nakamura.uits.iupui.edu"
[40] "200801032133.m03LX3gG005191@nakamura.uits.iupui.edu"
[41] "200801032127.m03LRUqH005177@nakamura.uits.iupui.edu"
[42] "200801032122.m03LMFo4005148@nakamura.uits.iupui.edu"
```

For the problem of 200801051412.m05ECIaH010327@nakamura.uits.iupui.edu, it probably should be dealed with by additional procedure.

You can also use the gregexpr function to get the location of pattern. However, you have to be very careful about the data type of the object it return as well as the position it return. It give you a vector with attribute which you have to use `attributes` to retrieve the information. The following is the example:

```r
location <- gregexpr("[[:alnum:]]+@([[:alnum:]]+\\.[[:alnum:]]+)+", linemail)[[1]]

len <- unlist(attributes(location))[1:305]
attributes(location) <- NULL

email <- rep(0, length(location))
for(i in 1:length(location)){
  email[i] <- substr(linemail, location[i], location[i] + len[i] - 1)
}

unique(email)
```

```
 [1] "marquard@uct.ac.za"                    
 [2] "postmaster@collab.sakaiproject.org"    
 [3] "m05ECIaH010327@nakamura.uits.iupui.edu"
 [4] "source@collab.sakaiproject.org"        
 [5] "louis@media.berkeley.edu"              
 [6] "m04N8v6O008125@nakamura.uits.iupui.edu"
 [7] "zqian@umich.edu"                       
 [8] "m04L92hb007923@nakamura.uits.iupui.edu"
 [9] "rjlowe@iupui.edu"                      
[10] "m04Kiem3007881@nakamura.uits.iupui.edu"
[11] "m04K1cO0007738@nakamura.uits.iupui.edu"
[12] "m04JmdwO007705@nakamura.uits.iupui.edu"
[13] "cwen@iupui.edu"                        
[14] "m04GZQGZ007313@nakamura.uits.iupui.edu"
[15] "hu2@iupui.edu"                         
[16] "m04GX6eG007292@nakamura.uits.iupui.edu"
[17] "gsilver@umich.edu"                     
[18] "m04GB1Lb007221@nakamura.uits.iupui.edu"
[19] "m04GA5KP007209@nakamura.uits.iupui.edu"
[20] "m04G9EuX007197@nakamura.uits.iupui.edu"
[21] "m04G8d7w007184@nakamura.uits.iupui.edu"
[22] "wagnermr@iupui.edu"                    
[23] "m04Fb6Ci007092@nakamura.uits.iupui.edu"
[24] "m04FFv42007050@nakamura.uits.iupui.edu"
[25] "antranig@caret.cam.ac.uk"              
[26] "m04F21Jo007031@nakamura.uits.iupui.edu"
[27] "ramasammycook@gmail.com"               
[28] "m04E3psW006926@nakamura.uits.iupui.edu"
[29] "horwitz@uct.ac.za"                     
[30] "m04C0gfK006793@nakamura.uits.iupui.edu"
[31] "m04B6lK3006677@nakamura.uits.iupui.edu"
[32] "m049lUxo006517@nakamura.uits.iupui.edu"
[33] "josrodri@iupui.edu"                    
[34] "m049W2i5006493@nakamura.uits.iupui.edu"
[35] "m0495rWB006420@nakamura.uits.iupui.edu"
[36] "m040NpCc005473@nakamura.uits.iupui.edu"
[37] "m03MGhDa005292@nakamura.uits.iupui.edu"
[38] "ray@media.berkeley.edu"                
[39] "m03M5Ea7005273@nakamura.uits.iupui.edu"
[40] "m03LX3gG005191@nakamura.uits.iupui.edu"
[41] "m03LRUqH005177@nakamura.uits.iupui.edu"
[42] "m03LMFo4005148@nakamura.uits.iupui.edu"
```

#### Task5: Find the website link

I use the `gregexpr` here again. The regular expression for website will be more complicated. I will divided them into several part to illustrate. First, `(http://|https://)` is searching for the beginning website. Second, `[[:alnum:]]+` is for combination for letters and digits. Third, `(\\.|=|\\&|-)?` is for the pattern of link. `.` is the basic website structure. For `=` and `&`, for example if you search something by the google engine. There will be some `=` and `&`. `-` is also another basic website structure. All of them are some patterns which some websites will not have, so I use quantifier `?` here to represent matches at most once. In the end, I put `/?\\??` which is for the pattern of `/` and `?` in some websites.


```r
#get line contain website link first
http <- paste(grep("http:|https:|www\\.", data, value=TRUE), collapse=" ")

location <- gregexpr("(http://|https://)([[:alnum:]]+(\\.|=|\\&|-)?[[:alnum:]]+/?\\??)+", http)[[1]]

len <- unlist(attributes(location))[1:75]
attributes(location) <- NULL

website <- rep(0, length(location))
for(i in 1:length(location)){
  website[i] <- substr(http, location[i], location[i] + len[i] - 1)
}

unique(website)
```

```
 [1] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39772"
 [2] "https://collab.sakaiproject.org/portal"                    
 [3] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39771"
 [4] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39770"
 [5] "https://source.sakaiproject.org/svn/site-manage/trunk/"    
 [6] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39769"
 [7] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39766"
 [8] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39765"
 [9] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39764"
[10] "https://source.sakaiproject.org/svn/msgcntr/trunk"         
[11] "http://jira.sakaiproject.org/jira/browse/SAK-12488"        
[12] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39763"
[13] "http://jira.sakaiproject.org/jira/browse/SAK-12484"        
[14] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39762"
[15] "http://bugs.sakaiproject.org/jira/browse/SAK-12596"        
[16] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39761"
[17] "http://bugs.sakaiproject.org/jira/browse/SAK-12595"        
[18] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39760"
[19] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39759"
[20] "http://bugs.sakaiproject.org/jira/browse/SAK-12592"        
[21] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39758"
[22] "http://bugs.sakaiproject.org/jira/browse/SAK-12175"        
[23] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39757"
[24] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39756"
[25] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39755"
[26] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39754"
[27] "https://source.sakaiproject.org/svn/polls/trunk"           
[28] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39753"
[29] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39752"
[30] "https://source.sakaiproject.org/svn/podcasts/trunk"        
[31] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39751"
[32] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39750"
[33] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39749"
[34] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39746"
[35] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39745"
[36] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39744"
[37] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39743"
[38] "https://source.sakaiproject.org/svn/gradebook/trunk"       
[39] "http://jira.sakaiproject.org/jira/browse/SAK-12504"        
[40] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39742"
[41] "http://bugs.sakaiproject.org/jira/browse/SAK-11458"        
```

### A useful function

`glob2rx` is a function that transform your pattern into regular expression. When you try to write some regular expression, you may want to try this function to facilitate your work speed.

### Regular Expression Functions in R

Function | Purpose | Characteristic
--- | --- | ---
grep() | finding regex matches | which elements are matched (index or value)
grepl() | finding regex matches | which elements are matched (TRUE & FALSE)
regexpr() | finding regex matches | positions of the first match
gregexpr() | finding regex matches | positions of all matches
regexec() | finding regex matches | hybrid of regexpr() and gregexpr()
sub() | replacing regex matches | only first match is replaced
gsub() | replacing regex matches | all matches are replaced
strsplit() | splitting regex matches | split vector according to matches


# Regular Expression (package: stringr)

### Regex functions in stringr

The following function all follow the structure `function_name(string, pattern)`

Function | Description
--- | ---
str_detect() | Detect the presence or absence of a pattern in a string
str_extract() | Extract first piece of a string that matches a pattern
str_extract_all() | Extract all pieces of a string that match a pattern
str_match() | Extract first matched group from a string
str_match_all() | Extract all matched groups from a string
str_locate() | Locate the position of the first occurence of a pattern in a string
str_locate_all() | Locate the position of all occurences of a pattern in a string
str_replace() | Replace first occurrence of a matched pattern in a string
str_replace_all() | Replace all occurrences of a matched pattern in a string
str_split() | Split up a string into a variable number of pieces
str_split_fixed() | Split up a string into a fixed number of pieces


```r
library(stringr)
```


```r
s1 <- c("$123", "12466", "$12,345")

#Use double backslash to escape the $
str_detect(s1, "\\$")
```

```
[1]  TRUE FALSE  TRUE
```


```r
s2 = c("12 Jun 2002", " 8 September 2004 ", "22-July-2009 ", "01 01 2001",
       "date", "02.06.2000", "xxx-yyy-zzzz", "$2,600")

str_extract(s2, "[0-9]{1,2}[- .][a-zA-Z]+[- .][0-9]{4}")
```

```
[1] "12 Jun 2002"      "8 September 2004" "22-July-2009"    
[4] NA                 NA                 NA                
[7] NA                 NA                
```


```r
str_match(s2, "[0-9]{1,2}[- .][a-zA-Z]+[- .][0-9]{4}")
```

```
     [,1]              
[1,] "12 Jun 2002"     
[2,] "8 September 2004"
[3,] "22-July-2009"    
[4,] NA                
[5,] NA                
[6,] NA                
[7,] NA                
[8,] NA                
```


```r
str_match(s2, "([0-9]{1,2})[- .]([a-zA-Z]+)[- .]([0-9]{4})")
```

```
     [,1]               [,2] [,3]        [,4]  
[1,] "12 Jun 2002"      "12" "Jun"       "2002"
[2,] "8 September 2004" "8"  "September" "2004"
[3,] "22-July-2009"     "22" "July"      "2009"
[4,] NA                 NA   NA          NA    
[5,] NA                 NA   NA          NA    
[6,] NA                 NA   NA          NA    
[7,] NA                 NA   NA          NA    
[8,] NA                 NA   NA          NA    
```


```r
s3 <- c("Jason", "Sanly", "Oracle")

str_locate(s3, "a")
```

```
     start end
[1,]     2   2
[2,]     2   2
[3,]     3   3
```


```r
s3 <- c("Jason", "Sanly", "Oracle")

str_replace(s3, "a", "aa")
```

```
[1] "Jaason"  "Saanly"  "Oraacle"
```


```r
s5 <- c("R is a collaborative project with many contributors")

str_split(s5, " ")
```

```
[[1]]
[1] "R"             "is"            "a"             "collaborative"
[5] "project"       "with"          "many"          "contributors" 
```


```r
s6 <- c("chocolate", "vanilla", "cinnamon", "mint", "lemon")

#Divide into only two seperate character
str_split(s6, "[aeiou]", n=2)
```

```
[[1]]
[1] "ch"     "colate"

[[2]]
[1] "v"     "nilla"

[[3]]
[1] "c"      "nnamon"

[[4]]
[1] "m"  "nt"

[[5]]
[1] "l"   "mon"
```


```r
#Return matrix
str_split_fixed(s6, "n", 2)
```

```
     [,1]        [,2]   
[1,] "chocolate" ""     
[2,] "va"        "illa" 
[3,] "ci"        "namon"
[4,] "mi"        "t"    
[5,] "lemo"      ""     
```

Now let's use those function to do the task4, 5 for email and website searching. I will try a different way to write the regular expression here. 


```r
data <- readLines("C:/Users/jason/Desktop/Python/mbox-short.txt")

data <- str_replace_all(data, "(^\t )|(\t)|(^  +)|(^-+)", "")
data <- data[nchar(data) != 0]

head(data)
```

```
[1] "From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008" 
[2] "Return-Path: <postmaster@collab.sakaiproject.org>"        
[3] "Received: from murder (mail.umich.edu [141.211.14.90])"   
[4] "by frankenstein.mail.umich.edu (Cyrus v2.3.8) with LMTPA;"
[5] "Sat, 05 Jan 2008 09:14:16 -0500"                          
[6] "X-Sieve: CMU Sieve 2.3"                                   
```


```r
email <- str_extract_all(data, "([a-zA-Z0-9]+)@([a-zA-Z0-9\\.-]+)\\.[a-zA-Z0-9]+")

unique(unlist(email))
```

```
 [1] "marquard@uct.ac.za"                    
 [2] "postmaster@collab.sakaiproject.org"    
 [3] "m05ECIaH010327@nakamura.uits.iupui.edu"
 [4] "source@collab.sakaiproject.org"        
 [5] "louis@media.berkeley.edu"              
 [6] "m04N8v6O008125@nakamura.uits.iupui.edu"
 [7] "zqian@umich.edu"                       
 [8] "m04L92hb007923@nakamura.uits.iupui.edu"
 [9] "rjlowe@iupui.edu"                      
[10] "m04Kiem3007881@nakamura.uits.iupui.edu"
[11] "m04K1cO0007738@nakamura.uits.iupui.edu"
[12] "m04JmdwO007705@nakamura.uits.iupui.edu"
[13] "cwen@iupui.edu"                        
[14] "m04GZQGZ007313@nakamura.uits.iupui.edu"
[15] "hu2@iupui.edu"                         
[16] "m04GX6eG007292@nakamura.uits.iupui.edu"
[17] "gsilver@umich.edu"                     
[18] "m04GB1Lb007221@nakamura.uits.iupui.edu"
[19] "m04GA5KP007209@nakamura.uits.iupui.edu"
[20] "m04G9EuX007197@nakamura.uits.iupui.edu"
[21] "m04G8d7w007184@nakamura.uits.iupui.edu"
[22] "wagnermr@iupui.edu"                    
[23] "m04Fb6Ci007092@nakamura.uits.iupui.edu"
[24] "m04FFv42007050@nakamura.uits.iupui.edu"
[25] "antranig@caret.cam.ac.uk"              
[26] "m04F21Jo007031@nakamura.uits.iupui.edu"
[27] "ramasammycook@gmail.com"               
[28] "m04E3psW006926@nakamura.uits.iupui.edu"
[29] "horwitz@uct.ac.za"                     
[30] "m04C0gfK006793@nakamura.uits.iupui.edu"
[31] "m04B6lK3006677@nakamura.uits.iupui.edu"
[32] "m049lUxo006517@nakamura.uits.iupui.edu"
[33] "josrodri@iupui.edu"                    
[34] "m049W2i5006493@nakamura.uits.iupui.edu"
[35] "m0495rWB006420@nakamura.uits.iupui.edu"
[36] "m040NpCc005473@nakamura.uits.iupui.edu"
[37] "m03MGhDa005292@nakamura.uits.iupui.edu"
[38] "ray@media.berkeley.edu"                
[39] "m03M5Ea7005273@nakamura.uits.iupui.edu"
[40] "m03LX3gG005191@nakamura.uits.iupui.edu"
[41] "m03LRUqH005177@nakamura.uits.iupui.edu"
[42] "m03LMFo4005148@nakamura.uits.iupui.edu"
```


```r
website <- str_extract_all(data, "(http://|https://)([a-zA-Z0-9\\.\\&\\?/=\\-]+)")

unique(unlist(website))
```

```
 [1] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39772"
 [2] "https://collab.sakaiproject.org/portal"                    
 [3] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39771"
 [4] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39770"
 [5] "https://source.sakaiproject.org/svn/site-manage/trunk/"    
 [6] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39769"
 [7] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39766"
 [8] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39765"
 [9] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39764"
[10] "https://source.sakaiproject.org/svn/msgcntr/trunk"         
[11] "http://jira.sakaiproject.org/jira/browse/SAK-12488"        
[12] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39763"
[13] "http://jira.sakaiproject.org/jira/browse/SAK-12484"        
[14] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39762"
[15] "http://bugs.sakaiproject.org/jira/browse/SAK-12596"        
[16] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39761"
[17] "http://bugs.sakaiproject.org/jira/browse/SAK-12595"        
[18] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39760"
[19] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39759"
[20] "http://bugs.sakaiproject.org/jira/browse/SAK-12592"        
[21] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39758"
[22] "http://bugs.sakaiproject.org/jira/browse/SAK-12175"        
[23] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39757"
[24] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39756"
[25] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39755"
[26] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39754"
[27] "https://source.sakaiproject.org/svn/polls/trunk"           
[28] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39753"
[29] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39752"
[30] "https://source.sakaiproject.org/svn/podcasts/trunk"        
[31] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39751"
[32] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39750"
[33] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39749"
[34] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39746"
[35] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39745"
[36] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39744"
[37] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39743"
[38] "https://source.sakaiproject.org/svn/gradebook/trunk"       
[39] "http://jira.sakaiproject.org/jira/browse/SAK-12504"        
[40] "http://source.sakaiproject.org/viewsvn/?view=rev&rev=39742"
[41] "http://bugs.sakaiproject.org/jira/browse/SAK-11458"        
```


* Reference: [Handling and Processing Strings in R, Gaston Sanchez](www.gastonsanchez.com)
* Data Resource: [mbox-short.txt](http://www.py4inf.com/code/mbox-short.txt) from PythonLearn.
