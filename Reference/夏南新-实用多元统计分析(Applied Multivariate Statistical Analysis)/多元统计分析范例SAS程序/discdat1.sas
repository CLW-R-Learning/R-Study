data discdat1;
input no x1 x2 x3 x4 x5 x6 type;
label x1='30M'
      x2='THROW SMALL BALL'
      X3='WEIGHT LIFTING'
      X4='THROW MEDICINE BALL'
      X5='SHOT PUT'
      X6='5STEP AND JUMP';
cards;
 1   3.60   4.30   82.30   70.00   90.00   18.52   1
 2   3.30   4.10   87.48   80.00  100.00   18.48   1
 3   3.30   4.22   87.74   85.00  115.00   18.56   1
 4   3.21   4.05   88.60   75.00  100.00   19.10   1
 5   3.10   4.38   89.98   95.00  120.00   20.14   1
 6   3.20   4.90   89.10   85.00  105.00   19.44   1
 7   3.30   4.20   89.00   75.00   85.00   19.17   1
 8   3.50   4.50   84.20   80.00  100.00   18.80   1
 9   3.70   4.60   82.10   70.00   85.00   17.68   1
10   3.40   4.40   90.18   75.00  100.00   19.14   1
11   3.60   4.30   82.10   70.00   90.00   18.10   1
12   3.60   4.50   82.00   55.00   70.00   17.40   1
13   3.60   4.20   82.20   70.00   90.00   18.12   1
14   3.40   4.20   85.40   85.00  100.00   18.66   1
15   3.30   4.30   90.10   80.00  100.00   19.86   1
16   3.12   4.20   89.00   85.00  100.00   20.00   1
17   3.10   4.20   90.20   85.00  115.00   20.80   1
18   3.60   4.20   81.96   65.00   80.00   17.20   1
19   3.70   4.40   81.00   80.00   95.00   17.00   1
20   3.30   4.30   90.00   80.00  110.00   19.80   1
21   3.80   4.09   80.00   60.00   80.00   16.89   1
22   3.70   4.30   83.90   85.00  100.00   18.76   1
23   3.50   4.20   85.40   85.00  100.00   18.70   1
24   3.40   4.10   86.70   85.00  110.00   18.50   1
25   3.30   4.10   88.10   75.00   85.00   18.96   1
26   3.70   4.10   84.10   70.00   95.00   18.70   1
27   3.60   4.30   82.00   70.00   90.00   18.40   1
28   3.20   4.20   89.20   85.00  115.00   19.88   1
29   3.40   4.00  103.00   95.00  110.00   24.80   2
30   3.30   4.50  118.00   90.00  120.00   25.70   2
31   3.10   4.50  105.00   85.00  110.00   25.10   2
32   3.80   4.10  104.53   80.00  100.00   24.98   2
33   3.00   4.20  112.00   95.00  125.00   25.35   2
34   3.90   3.70   98.20   85.00   90.00   21.80   2
35   3.50   4.10   98.70   90.00  120.00   22.78   2
36   3.10   3.90   98.20   60.00   90.00   21.98   2
37   3.30   3.90  109.00  100.00  120.00   25.30   2
38   3.10   3.95   98.40   95.00  115.00   25.20   2
39   3.14   3.90   95.30   90.00  110.00   21.42   2
40   3.60   4.30   93.60   75.00   85.00   20.84   2
41   3.12   3.90   95.80   80.00  105.00   21.80   2
42   3.00   3.90   93.80   85.00   90.00   21.08   2
43   3.40   3.91   96.30  110.00  120.00   21.98   2
44   3.63   3.78   98.56   85.00  120.00   22.36   2
45   3.30   3.98   97.40   85.00  100.00   22.34   2
46   3.30   4.40  112.00   75.00  110.00   25.10   2
47   3.50   4.10  107.70   87.50  110.00   25.10   2
48   3.40   4.20   92.10   80.00  120.00   22.16   2
49   3.60   4.10   99.48   85.00  120.00   23.10   2
50   3.10   4.40  116.00   75.00  110.00   25.30   2
51   3.12   4.00  102.70   80.00  110.00   24.68   2
52   3.60   4.10  115.00   85.00  115.00   23.70   2
53   3.50   4.30   97.80   75.00  100.00   24.10   2
;
run;
data discdat2;
input no x1 x2 x3 x4 x5 x6;
label x1='30M'
      x2='THROW SMALL BALL'
      X3='WEIGHT LIFTING'
      X4='THROW MEDICINE BALL'
      X5='SHOT PUT'
      X6='5STEP AND JUMP';
cards;
 1   3.50   4.10   85.30   75.00   105.00   18.65
 2   3.40   4.40   85.40   75.00    95.00   18.60
 3   3.60   4.30   85.36   75.00    90.00   18.60
 4   3.60   4.10   83.70   75.00   105.00   18.60
 5   3.20   4.10   89.35   75.00    95.00   20.28
 6   3.40   4.15   86.28   60.00    77.50   18.90
 7   3.60   4.20   84.10   80.00   100.00   18.70
 8   3.10   4.10   98.00   95.00   130.00   22.30
 9   3.00   4.10  122.00  100.00   115.00   27.10
10   3.20   4.30   92.68   80.00   105.00   20.68
11   3.10   4.20   91.76   85.00   100.00   22.20
12   3.30   4.20   98.40   65.00   100.00   22.86
13   3.30   4.60   92.00   80.00   195.00   23.07
14   3.40   4.30   97.36   75.00   110.00   22.12
;
run;
proc discrim data=discdat1 testdata=discdat2  crosslisterr testlist;
class type;
var x1-x6;
run;
