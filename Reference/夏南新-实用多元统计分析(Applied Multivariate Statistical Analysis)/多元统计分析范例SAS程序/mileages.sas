data mileages(type=distance);
     input (ATLANTA CHICAGO DENVER HOUSTON LOSANGEL
           MIAMI NEWYORK SANFRAN SENTTLE WASHDC) (5.)
           @52 city $ 15. ;
     cards;
   0  587 1212  701 1936  604  748 2139 2182  543 ATLANTA
 587    0  920  940 1745 1188  713 1858 1737  597 CHICAGO
1212  920    0  879  831 1726 1631  949 1021 1494 DENVER
 701  940  879    0 1374  968 1420 1645 1891 1220 HOUSTON
1936 1745  831 1374    0 2339 2451  347  959 2300 LOS ANGELES
 604 1188 1726  968 2339    0 1092 2594 2734  923 MIAMI
 748  713 1631 1420 2451 1092    0 2571 2408  205 NEW YORK
2139 1858  949 1645  347 2594 2571    0  678 2442 SAN FRANCISCO
2182 1737 1021 1891  959 2734 2408  678    0 2329 SEATTLE
 543  597 1494 1220 2300  923  205 2442 2329    0 WASHINGTON D.C.
;
proc cluster data=mileages method=average notie pseudo;
     id city;
proc tree horizontal spaces=2;
     id city;
proc cluster data=mileages method=centroid notie pseudo;
     id city;
proc tree horizontal spaces=2;
     id city;
proc cluster data=mileages method=single notie;
     id city;
proc tree horizontal space=2;
     id city;
proc cluster data=mileages method=ward pseudo;
     id city;
proc tree horizontal spaces=2;
     id city;
