
# 데이터 불러오기
ro_data_mice <- read.csv("C:/Users/eourm/Desktop/융합팀플/LaVue-main/LaVue-main/mice_df_robust.csv")
#data_mice <- read.csv("C:/Users/eourm/Desktop/융합팀플/LaVue-main/LaVue-main/dat_mice.csv")
str(ro_data_mice)
ro_dat_mice<- ro_data_mice[,-c(1)] 
ro_dat_mice$date <- as.Date(ro_dat_mice$date)
#str(data_mice)
#dat_mice<- data_mice[,-c(1)] 
#dat_mice$date <- as.Date(dat_mice$date)

#다음날 최고기온뽑는과정
#to_tempHigh <- dat_mice$tempHigh
#str(to_tempHigh)
#to_tempHigh <- to_tempHigh[-1]
#to_tempHigh[43383]<-0
#mice_df <- data.frame(dat_mice, to_tempHigh)
#str(mice_df)

min(ro_dat_mice[-1])
ro_dat_mice[-1] <- log(ro_dat_mice[-1]+6)

str(ro_dat_mice)
#----PCA------
# 변수들 간 상관계수
round(cor(ro_dat_mice[,-c(1,28)]),3)

pca_cov <- prcomp(ro_dat_mice[,-c(1,28)])#공분산 행렬 이용

options(max.print=30000)
print(pca_cov)

plot(pca_cov, type = "l")
# plot에서는 기울기가 완만하게 변하는 팔꿈치 부분을 명확하게 정하기 쉽지 않다.
# 제6 ~ 제10 주성분의 기울기가 비슷해 보인다.

summary(pca_cov)
# 각 주성분의 중요도(Proportion of Variance) 누적합인 Cumulative Proportion을 보면
# 제1의 주성분부터 제6의 주성분으로 전체 데이터의 91.26 %를 설명할 수 있다.
# 그러므로 6개의 주성분만 선택한다.

summary(pca_cov$sdev)#평균고유값 0.07

pca <- prcomp(ro_dat_mice[,-c(1,28)], scale = T) #상관계수 행렬 이용
plot(pca, type = "l")
# plot에서 제5 주성분부터 기울기가 완만하게 변하고 그 이후로는 거의 의미가 없기 때문에
# 제5 주성분까지 5개의 주성분을 선택한다.

summary(pca)
print(pca_cov)

head(ro_dat_mice[,-c(1,28)])
#변수 선택
# 설문조사처럼 같은 scale 점수화가 된 경우에는 공분산행렬 사용해도 되지만
# 변수들의 scale이 많이 다른 경우 특정 변수가 전체적인 경향을 좌우하기 때문에 
# 상관계수 행렬을 사용하여 분석하는 것이 좋다.

# 주성분 갯수의 선택
# (1) 주성분의 누적 중요도(Cumulative Proportion)가 70 ~ 90 % 사이에서 선택.
# (2) 평균 고유값보다 작은 고유값을 갖는 주성분을 버림.
#     상관계수 행렬 이용시 평균 분산(표준편차) = 1 이므로 Standard deviation이 1 또는 0.7 보다 작은 것은 버림.
# (3) Scree diagram에서 기울기가 완만해지는 시점, 즉 팔꿈치에 대응하는 지점까지 선택.

ro_dat_mice <- ro_dat_mice[,c('date','to_tempHigh','tempHigh','LocalAPAvg','tempAvg','tempLow','VPAvg','seaAPAvg','grassTempMin','windMax',
                              'windAvg','airDXSum','windMaxDir','RHMin','sunlightTimeSum','RHAvg','windMaxInstantDir','temp5Avg','temp10Avg',
                              'temp20Avg','temp30Avg')]

#데이더 나누기
train <- subset(ro_dat_mice, format(date,'%Y') < 2017)
test <- subset(ro_dat_mice, format(date,'%Y') >= 2017)
str(test)

train <- train[-1]
test <- test[-1]

#min(rlogtrain)
#min(rlogtest)
str(train)
str(test)





#tempAvg+tempLow+windMaxInstantDir+windMax+windAvg+RHMin+sunlightTimeSum+temp5Avg
robustLog_model <- lm(to_tempHigh~., train)
summary(robustLog_model)




#전위
model_fwd <- step(lm(to_tempHigh ~1, train),
                  trace = 0, direction = "forward",
                  scope = list(lower=to_tempHigh ~ 1,upper = formula(robustLog_model)))
summary(model_fwd)

#windMaxDir+ VPAvg(별하나)
model_fwd2 <- lm(to_tempHigh ~ tempHigh + tempAvg + sunlightTimeSum + 
                   windMax + temp5Avg + RHMin + windMaxInstantDir + windAvg + 
                   LocalAPAvg + tempLow + grassTempMin + temp30Avg + temp10Avg , data = train)
summary(model_fwd2)

#후위
model_bwd <- step(lm(to_tempHigh ~ ., train), 
                  direction = "backward", trace = 0,
                  scope = list(lower=to_tempHigh ~ 1, upper = formula(robustLog_model)))


summary(model_bwd)
#windMaxDir  + VPAvg
model_bwd2 <- lm(to_tempHigh ~ tempHigh + LocalAPAvg + tempAvg + 
                   tempLow + grassTempMin + windMax + windAvg +
                   RHMin + sunlightTimeSum + windMaxInstantDir + temp5Avg + 
                   temp10Avg + temp30Avg, data = train)
summary(model_bwd2)





train <- train[,c('to_tempHigh' ,'tempHigh' ,'LocalAPAvg' , 'tempAvg' , 
                    'tempLow' , 'grassTempMin' , 'windMax' , 'windAvg' ,
                    'RHMin' , 'sunlightTimeSum' , 'windMaxInstantDir' , 'temp5Avg' , 
                    'temp10Avg' ,'temp30Avg')]

test <- test[,c('to_tempHigh' ,'tempHigh' ,'LocalAPAvg' , 'tempAvg' , 
                'tempLow' , 'grassTempMin' , 'windMax' , 'windAvg' ,
                'RHMin' , 'sunlightTimeSum' , 'windMaxInstantDir' , 'temp5Avg' , 
                'temp10Avg' ,'temp30Avg')]
str(train)


#모델평가 테스트
predtemphigh <- predict(model_fwd3,test[-1])
plot(test[2:32,2], type = 'o', col = 'red')#실제 최고기온
lines(predtemphigh[2:32], type = 'o', col = 'blue')#다음날 최고기온

#다중공선성
library("car")
vif(model_fwd2)

#tempAvg +tempLow + temp10Avg+ temp30Avg(무의미)+ grassTempMin+ windAvg
model_fwd3 <- lm(to_tempHigh ~ tempHigh  + sunlightTimeSum + 
                   windMax + temp5Avg + RHMin + windMaxInstantDir  + 
                   LocalAPAvg , 
                 data = train)
summary(model_fwd3)
vif(model_fwd3)

train <- train[,c('to_tempHigh', 'tempHigh', 'sunlightTimeSum', 
                    'windMax', 'temp5Avg', 'RHMin', 'windMaxInstantDir',
                    'LocalAPAvg')]

test <- test[,c('to_tempHigh', 'tempHigh', 'sunlightTimeSum', 
                'windMax', 'temp5Avg', 'RHMin', 'windMaxInstantDir',
                'LocalAPAvg' )]



#잔차분석
par(mfrow=c(2,2))
plot(model_fwd3)

shapiro.test(model_fwd3$residuals[1:4999])#정규성 가정??독립성 가정이 깨지는거 아니냐??
car::durbinWatsonTest(model_fwd3)#독립성 가정
car::ncvTest(model_fwd3)#등분산성 검정 ??이것도 엉망인거 같은데??

install.packages('gvlma')
library(gvlma)
summary(gvlma::gvlma(model_fwd3))


#상관성 분석
cor(rlogtrain)
#install.packages("corrplot")
#install.packages("magrittr")
library(corrplot) # correlation test and visualization
library(magrittr)
# mtcars 데이터의 모든 변수간 상관계수 검정 진행 후, p.value 로 저장
dat%>%cor.mtest(method='pearson')->p.value

#p.value 구조, 변수 확인하기 
str(p.value)
dev.new() # chart 그리기 device 준비
dat %>% na.omit%>%cor %>% corrplot.mixed(p.mat=p.value[[1]], sig.level=.05, lower = 'number', upper='pie', tl.cex=.6, tl.col='black', order='hclust')

library(PerformanceAnalytics)
chart.Correlation(rlogtrain, histogram=TRUE, col="grey10", pch=1)#MEAN

install.packages("GGally")
library(GGally)
ggcorr(rlogtrain, name="corr", label=T)

par(mfrow=c(2,2))

library(forecast)

accuracy(model_fwd3)

AIC(model_fwd3)
