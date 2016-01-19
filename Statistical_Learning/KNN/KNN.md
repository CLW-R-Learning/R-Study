# K-Nearest Neighbor
Chih Hui(Jason) Wang  
January 17, 2016  




```r
library(ggplot2)
library(dplyr)
library(reshape2)
library(gridExtra)
library(class)
```
# Introduction

The K-nearest neighbor algorithm can be applied to both classification and regression problem. Its main idea is that given the features($x_1, x_2, \cdots, x_p$), we find out the K-closet observations in our dataset and then average the responses($y_1, y_2, \cdots, y_K$) and use the outcome to predict the $y$.    
In regression setting, it is easily understandable. In classification, the *average* mean that the object will be classified by a majority vote of those K responses. For example, if $K=3$ and the 3-nearest neighbors' y are (0, 1, 1), then we will assign y to 1 since there are two 1s in its 3-nearest neighbor.

The following example is a simulated example which illustrates how KNN works.

```r
set.seed(10)
y <- as.factor(rep(c("A", "B"), each=10))

#Construct mean of each normal distribution
mu1 <- as.numeric(y)
mu2 <- mu1[length(mu1):1]

#Simulated Data
sim_data <- data.frame(x1=rnorm(20, mean=mu1),
                       x2=rnorm(20, mean=mu2), 
                       y=y)

g1 <- ggplot(sim_data, aes(x=x1, y=x2, color=y)) + geom_point(size=5) +
  scale_color_manual(values=c("dodgerblue", "darkorange")) + 
  labs(title="Simulated Data", x="X1", y="X2")
g1
```

<img src="KNN_files/figure-html/simulated_data-1.png" title="" alt="" style="display: block; margin: auto;" />

To get more sense on the algorithm, I write a function **my_knn** to compute the k-closest responses. I construct another dataset which form a grid around the ranges of $x_1$ and $x_2$. Then, I apply the function to each of the observations and add an additional layer on it to visualize which class those points will be assigned.

# Flexibility

I use both k=1 and k=3 to run the KNN algorithm. For k=1, the algorithm simply finds out what is the closest observation's response and assign it to the new observation. Its behavior will be more local compared to the k=3 case. At the same time, it's not so flexible as the k=3 case. A more flexibility model has less bias while more variance. For instance, if we use k=1, the model will be very different when you change one of the points in data. The value k will selected by cross validation.

```r
x1_range <- seq(min(sim_data$x1), max(sim_data$x1), by=0.1)
x2_range <- seq(min(sim_data$x2), max(sim_data$x2), by=0.1)

points_grid <- expand.grid(x1_range, x2_range)
colnames(points_grid) <- c("x1", "x2")

my_knn <- function(newx, datax, datay, k){
  #Combine to compute distance
  all <- rbind(newx, datax)
  
  rownames(all) <- 1:nrow(all)
  
  #Distance
  distance_matrix <- as.matrix(dist(all))
  
  #Take out the first row to get 
  d <- distance_matrix[, 1]
  
  #Y
  datay[as.numeric(names(sort(d)[2:(2 + k - 1)])) - 1]
}

#k = 3
points_grid$predict_y <- rep("A", nrow(points_grid))
k <- 3
for(i in 1:nrow(points_grid)){
  y <- my_knn(points_grid[i, -3], sim_data[, -3], sim_data[, 3], k)
  
  #Since we use k=3, if one of the categories is bigger than 2, then it's the majority
  points_grid$predict_y[i] <- names(which(table(y) >= k/2))
}
points_grid$predict_y <- as.factor(points_grid$predict_y)

g2 <- g1 + geom_point(data=points_grid, aes(x=x1, y=x2, color=predict_y)) + labs(title="K=3")

#k=1
points_grid$predict_y <- rep("A", nrow(points_grid))
k <- 1
for(i in 1:nrow(points_grid)){
  y <- my_knn(points_grid[i, -3], sim_data[, -3], sim_data[, 3], k)
  
  #Since we use k=3, if one of the categories is bigger than 2, then it's the majority
  points_grid$predict_y[i] <- names(which(table(y) >= k/2))
}
points_grid$predict_y <- as.factor(points_grid$predict_y)

g3 <- g1 + geom_point(data=points_grid, aes(x=x1, y=x2, color=predict_y)) + labs(title="K=1")

grid.arrange(g2, g3, nrow=1)
```

<img src="KNN_files/figure-html/construct_region-1.png" title="" alt="" style="display: block; margin: auto;" />

# Alogrithm

1. Calculate the distance of the new observation to every observation in the dataset. 
2. Find out the k-closest points.
3. Look at how those points are classified and assign the majority class to the new observation.

At this point, you may notice two things. First, what distance measurement should we use? Normally, if all features are quantitative, we will use Euclidean distance. In this case, it is recommended to standardize the feature variable. Otherwise, the variables with large scale will tend to dominate the results of the algorithm. On the other hand, if all features are qualitative, then we will choose some measurement like Hamming distance. Second, what if the distance of the new observation to two or several observations have ties? If there are ties among the k-nearest neighbors, all the tied candidates will be chosen randomly.

# Example
It is the handwritten digits data, from 0 to 9. There are 5000 observations in the data. The first column is the response 0 to 9. The features are 784 pixels, flatten from a 28x28 matrix.

```r
digits <- read.csv("Data/digitsTrain.csv")
dim(digits)
```

```
[1] 5000  785
```
I write a function called **digit_visual** which will transform the one-row data back to a matrix and visualize it. As you can see below, these are the handwritten digits from 0 to 9. Our goal is to use KNN algorithm to predict the digits correctly.

```r
digit_visual <- function(digit_row){
  m <- matrix(as.integer(digit_row), ncol=28, byrow=TRUE)
  dm <- melt(m)
  
  ggplot(dm, aes(x=Var1, y=Var2, z=value, fill=value)) + 
    geom_tile() + scale_fill_gradient(low="white", high="black") +
    theme_bw() + theme(panel.grid.major=element_blank(),
                       axis.title.x=element_blank(),
                       axis.text.x=element_blank(),
                       axis.title.y=element_blank(),
                       axis.text.y=element_blank(),
                       axis.ticks=element_blank(),
                       legend.position="none") + coord_flip() + scale_x_reverse()
    
}

zero_to_nine <- digits %>% 
  group_by(label) %>%
  sample_n(1)

grid.arrange(
  digit_visual(zero_to_nine[1, -1]),
  digit_visual(zero_to_nine[2, -1]),
  digit_visual(zero_to_nine[3, -1]),
  digit_visual(zero_to_nine[4, -1]),
  digit_visual(zero_to_nine[5, -1]),
  digit_visual(zero_to_nine[6, -1]),
  digit_visual(zero_to_nine[7, -1]),
  digit_visual(zero_to_nine[8, -1]),
  digit_visual(zero_to_nine[9, -1]),
  digit_visual(zero_to_nine[10, -1]),
  ncol=5
)
```

<img src="KNN_files/figure-html/visual-1.png" title="" alt="" style="display: block; margin: auto;" />
Now we split the dataset into two part, training, and testing set. Here we separate 20% of the data into the testing set. We will use the training set to train our KNN model and use the model to predict the response on the testing set.

```r
set.seed(1)
train_index <- sample(1:nrow(digits), nrow(digits)*0.8)

train_digits <- digits[train_index, ]
test_digits <- digits[-train_index, ]
```
We will use the functions, **knn** and **knn.cv**, in the *class* package to run the algorithm. The arguments in both functions are pretty similar. The following is the explanation of the arguments we use:
* train: the features of the training set. It should be a matrix or data frame.
* test: the features of the testing set. It should be a matrix or data frame.
* cl: the response of the training set.
* k: number of neighbors.
* use.all: when there are ties, how to handle the ties. If true, all the ties will be included into the k neighbors. Otherwise, a random selection will choose exactly k neighbors.
The output is the predicted response of the testing set. It will automatically transform the data type into factor. You can also check the help page of the function by `?knn`.


```r
str(knn)
```

```
function (train, test, cl, k = 1, l = 0, prob = FALSE, use.all = TRUE)  
```

```r
str(knn.cv)
```

```
function (train, cl, k = 1, l = 0, prob = FALSE, use.all = TRUE)  
```

We first use the **knn.cv** to decide the parameter k and then apply the **knn** function to make a prediction on the testing set. According to the help page of **knn.cv**, it uses leave-one-out cross validation. It will output the predicted response of each observation in training data. Therefore, all we have to do is to tune the parameter k around a specific range. With the predicted value, we can compute the accuracy of the model and then compare them for different k value. Finally, we just choose the one with the highest accuracy.

```r
results <- rep(0, 10)
for(k in 1:10){
  pred <- knn.cv(train_digits[, -1], train_digits[, 1], k)
  results[k] <- mean(pred == train_digits[, 1])
}

results
```

```
 [1] 0.93225 0.91775 0.93700 0.93125 0.93325 0.93525 0.93300 0.93050
 [9] 0.93050 0.92575
```
From above results, we see that when k=6, the accuracy rate is the highest. Therefore, we use k=6 as our final model and run KNN on the testing set. It turns out that the accuracy rate is around 94.6%. From the table, we can find that the algorithm performs not so well on predicting when the true digits are 2, 5, 8 and 9. Also, when the predicted values are 1 and 9, it is more likely to be wrong. Besides, it mistakes 2 as 1 and 4 as 9 the most time.

```r
pred <- knn(train_digits[, -1], test_digits[, -1], train_digits[, 1], k=3)

mean(pred == test_digits[, 1])
```

```
[1] 0.946
```

```r
table(prediction=pred, true=test_digits[, 1])
```

```
          true
prediction   0   1   2   3   4   5   6   7   8   9
         0  89   0   0   0   0   0   1   0   0   3
         1   0 126   5   0   1   2   0   2   3   0
         2   0   0  85   0   0   0   0   0   1   0
         3   0   0   1  91   0   1   0   0   3   1
         4   0   0   0   0  91   0   1   0   1   1
         5   0   0   0   3   0  86   0   0   3   1
         6   0   0   1   0   1   1  99   0   0   0
         7   0   2   2   0   1   0   0 105   1   3
         8   0   0   0   0   0   1   1   0  73   0
         9   0   0   0   0   2   2   0   1   1 101
```

We now can pull out those wrong case and see what kind of the digits will be hard for our algorithm to predict. Here, we pick the cases that 2 is mistaken by 1. You can see that one of them are really hard to distinguish while the others are not. To further analysis, you may pick up some special feature of these wrong-predicted data and run the algorithm again. 

```r
test_digits$predict <- pred
wrong_data <- test_digits[pred != test_digits[, 1], ]

predict1_true2 <- wrong_data[wrong_data$label == 2 & wrong_data$predict == 1, ]

grid.arrange(
  digit_visual(predict1_true2[1, -c(1, 786)]) + labs(title="Mistaken as 1"),
  digit_visual(predict1_true2[2, -c(1, 786)]) + labs(title="Mistaken as 1"),
  digit_visual(predict1_true2[3, -c(1, 786)]) + labs(title="Mistaken as 1"),
  digit_visual(predict1_true2[4, -c(1, 786)]) + labs(title="Mistaken as 1"),
  digit_visual(predict1_true2[5, -c(1, 786)]) + labs(title="Mistaken as 1"),
  ncol=3
)
```

<img src="KNN_files/figure-html/predict_wrong-1.png" title="" alt="" style="display: block; margin: auto;" />

```r
predict9_true4 <- wrong_data[wrong_data$label == 4 & wrong_data$predict == 9, ]
```

KNN is one of the simple but powerful machine learning algorithms. As you can see, in this handwritten data, it can reach 94.6% accuracy. It can be viewed as a baseline comparison of those advanced algorithms. We only illustrate how it works on the classification problem. However, it is very easy to extend to the regression problem. 
