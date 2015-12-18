[, 1] mpg Miles/(US) gallon 
[, 2] cyl Number of cylinders 
[, 3] disp Displacement (cu.in.) 
[, 4] hp Gross horsepower 
[, 5] drat Rear axle ratio 
[, 6] wt Weight (lb/1000) 
[, 7] qsec 1/4 mile time 
[, 8] vs V/S 
[, 9] am Transmission (0 = automatic, 1 = manual) 
[,10] gear Number of forward gears 
[,11] carb Number of carburetors

mtcars

pairs(mtcars[,-c(2,8:11)])
cor(mtcars[,-c(2,8:11)])
coplot(mpg ~ disp | as.factor(cyl), data = mtcars,
       panel = panel.smooth, rows = 1)



library(lme4)
data=cbind(mtcars[,-c(2,10,11)],data.frame(sapply(mtcars[,c(2,10,11)],dummy)))
fir=lm(mpg~.,data=data)
summary(fir)
#######看看那些觀測值和預測值差別特大
windows()
plot(mtcars[,1],fitted.values(fir))
text(mtcars[,1],fitted.values(fir),rownames(mtcars),cex=0.5,adj=-0.5)
abline(0,1)
#######不用做TRANSFORMATION
library(MASS)
boxcox(fir)
######剔除三個點 but why
data[c(17,18,20),]

anda=data[-c(17,18,20),]
ano=lm(mpg~.,data=anda)
summary(ano)
plot(ano)


##變數選取

trying=step(fir,direction="both")
drop1(trying)
del=lm(mpg ~ hp + wt + cyl.6 + gear.4 + gear.5  ,data=data)
summary(del)

del=lm(mpg ~ hp + wt  ,data=data)
summary(del)

##mpg應對hp配二次方
windows()
par(mfrow=c(2,2))
plot(mtcars[,c(4,1)])
plot(mtcars[,c(6,1)])
plot(mtcars[,c(4,6)])



del=lm(mpg ~ hp +I(hp^2) + wt +I(wt^2)  +hp*wt ,data=data)
summary(del)

trying=step(del,direction="both")
drop1(trying)

del=lm(mpg ~ hp + I(hp^2) + wt + I(wt^2),data=data)
summary(del)

##如果全部用原始變數

tryy=lm(mpg~.,data=mtcars)
summary(tryy)
trying=step(tryy,direction="both")
drop1(trying)

tryy=lm(mpg ~ wt + qsec + am,data=mtcars)
summary(tryy)


###R-squared:  0.8497,      Adjusted R-squared:  0.8336 下降，再加變數

pairs(mtcars[,c(1,6,7,9)])

##看看有無PATTERN
##at大wt好像小，am小好像wt大，再加入之前兩個hp變數，一起篩選
tryy=lm(mpg ~ wt +I(wt^2)+ qsec +am*wt+hp+I(hp^2),data=mtcars)
summary(tryy)
trying=step(tryy,direction="both")
drop1(trying)


##發瘋隨便試，似乎OVERFITTING
tryy=lm(mpg ~ wt + qsec*wt*am*hp*I(hp^2) + am + hp + I(hp^2) + wt:am,data=mtcars)
summary(tryy)
trying=step(tryy,direction="both")
drop1(trying)
##發瘋隨便試，似乎OVERFITTING
tryy=lm(mpg ~ wt + qsec + hp + I(hp^2) + wt:qsec + qsec:am  + 
              qsec:hp + wt:hp + am:hp  + wt:I(hp^2) + am:I(hp^2) + 
              wt:qsec:am + wt:qsec:hp + qsec:am:hp + wt:am:hp + 
              wt:qsec:I(hp^2) + qsec:am:I(hp^2) + wt:am:I(hp^2) + qsec:hp:I(hp^2) + 
              wt:hp:I(hp^2) + am:hp:I(hp^2) + wt:qsec:am:hp + wt:qsec:am:I(hp^2),data=mtcars)
summary(tryy)
trying=step(tryy,direction="both")
drop1(trying)

## 最終MODEL
fin=lm(mpg ~ wt + qsec + am + hp + I(hp^2) + wt:am,data=mtcars)
summary(fin)

fin=lm(mpg ~ wt +am + hp + I(hp^2) + wt:am,data=mtcars)
summary(fin)

pairs(mtcars[,c(1,4,6,9)])

anova(fin)
##看看有無PATTERN

##不要截距，overfitting？？
noin=lm(mpg ~ wt  + am + I(hp^2) + wt:am+0,data=mtcars)
summary(noin)
windows()
plot(mtcars[,1],fitted.values(noin))
text(mtcars[,1],fitted.values(noin),rownames(mtcars),cex=0.5,adj=-0.5)
abline(0,1)
##n似乎爛掉

#######看看那些觀測值和預測值差別特大
windows()
plot(mtcars[,1],fitted.values(fin))
text(mtcars[,1],fitted.values(fin),rownames(mtcars),cex=0.5,adj=-0.5)
abline(0,1)
#######不用做TRANSFORMATION
library(MASS)
boxcox(fin)
plot(fin)
library(car)
library(pander)

qqPlot(fin)










##用一個主成分RSQUARE0.7499 全部變數0.8931
printry=princomp(data[,2:ncol(data)])
sec=lm(data[,1]~printry$scores[,1])
summary(sec)
#######但只放wt解釋力就比較強
summary(lm(mpg~wt,data=mtcars))

###########heatmap
heatmap(as.matrix(mtcars),
        Rowv=NA,
        Colv=NA,
        col = heat.colors(256),
        scale="column",
        margins=c(2,8),
        main = "Car characteristics by Model")




