
# 데이터 불러오기
ro_data_mice2 <- read.csv("C:/Users/eourm/Desktop/융합팀플/선형회귀/RobustScaler/mice_df_robust2.csv")
str(ro_data_mice2)
ro_data_mice2$date <- as.Date(ro_data_mice2$date)



min(ro_data_mice2[-1])
ro_data_mice2[-1] <- log(ro_data_mice2[-1]+6)

str(ro_data_mice2)
#----PCA------
# 변수들 간 상관계수
round(cor(ro_data_mice2[,-c(1,28)]),3)

pca_cov <- prcomp(ro_data_mice2[,-c(1,28)])#공분산 행렬 이용

options(max.print=30000)
print(pca_cov)

plot(pca_cov, type = "l")
# plot에서는 기울기가 완만하게 변하는 팔꿈치 부분을 명확하게 정하기 쉽지 않다.
# 제6 ~ 제10 주성분의 기울기가 비슷해 보인다.

summary(pca_cov$sdev)#평균고유값 0.074871

summary(pca_cov)
# 각 주성분의 중요도(Proportion of Variance) 누적합인 Cumulative Proportion을 보면
# 제1의 주성분부터 제6의 주성분으로 전체 데이터의 91.28 %를 설명할 수 있다.
# 그러므로 6개의 주성분만 선택한다.


pca <- prcomp(ro_data_mice2[,-c(1,28)], scale = T) #상관계수 행렬 이용
plot(pca, type = "l")
# plot에서 제5 주성분부터 기울기가 완만하게 변하고 그 이후로는 거의 의미가 없기 때문에
# 제5 주성분까지 5개의 주성분을 선택한다.
# 공분산 행렬을 이용한 변수가 더 설명력이 높음

summary(pca)
print(pca_cov)

head(ro_data_mice2[,-c(1,28)])
#변수 선택
# 설문조사처럼 같은 scale 점수화가 된 경우에는 공분산행렬 사용해도 되지만
# 변수들의 scale이 많이 다른 경우 특정 변수가 전체적인 경향을 좌우하기 때문에 
# 상관계수 행렬을 사용하여 분석하는 것이 좋다.

# 주성분 갯수의 선택
# (1) 주성분의 누적 중요도(Cumulative Proportion)가 70 ~ 90 % 사이에서 선택.
# (2) 평균 고유값보다 작은 고유값을 갖는 주성분을 버림.
#     상관계수 행렬 이용시 평균 분산(표준편차) = 1 이므로 Standard deviation이 1 또는 0.7 보다 작은 것은 버림.
# (3) Scree diagram에서 기울기가 완만해지는 시점, 즉 팔꿈치에 대응하는 지점까지 선택.

ro_data_mice2 <- ro_data_mice2[,c('date','to_tempHigh2','tempHigh','LocalAPAvg','tempAvg','tempLow','VPAvg',
                                  'seaAPAvg','grassTempMin','temp5Avg','windMax','windAvg','airDXSum',
                                  'windMaxDir','RHAvg','RHMin','windMaxInstantDir','sunlightTimeSum','temp30Avg',
                                  'temp10Avg','temp20Avg','evapnSmallSum')]

#데이더 나누기
train2 <- subset(ro_data_mice2, format(date,'%Y') < 2017)
test2 <- subset(ro_data_mice2, format(date,'%Y') >= 2017)
str(test2)

train2 <- train2[-1]
test2 <- test2[-1]

#min(rlogtrain)
#min(rlogtest)
str(train2)
str(test2)





#tempAvg+tempLow+windMaxInstantDir+windMax+windAvg+RHMin+sunlightTimeSum+temp5Avg
robustLog_model2 <- lm(to_tempHigh2~., train2)
summary(robustLog_model2)




#전위
model_fwd_d2 <- step(lm(to_tempHigh2 ~1, train2),
                  trace = 0, direction = "forward",
                  scope = list(lower=to_tempHigh2 ~ 1,upper = formula(robustLog_model2)))
summary(model_fwd_d2)

#tempAvg+ grassTempMin(별2)  + RHMin(별2)
model_fwd2_d2 <- lm(to_tempHigh2 ~ sunlightTimeSum + temp5Avg + 
                      windMaxInstantDir + VPAvg + tempHigh + tempLow + windMaxDir + 
                      temp10Avg + temp30Avg + RHAvg + seaAPAvg + LocalAPAvg, data = train2)
summary(model_fwd2_d2)

#다중공선성
library("car")
vif(model_fwd2_d2)

#temp10Avg + temp30Avg (무의미)+ tempLow +  windMaxDir(별두개) +
model_fwd3_d2 <- lm(to_tempHigh2 ~ sunlightTimeSum + temp5Avg + windMaxInstantDir + 
                      VPAvg + tempHigh + RHAvg + seaAPAvg + LocalAPAvg, data = train2)
summary(model_fwd3_d2)
vif(model_fwd3_d2)

train2 <- train2[,c('to_tempHigh2','tempHigh'   , 'sunlightTimeSum','temp5Avg','windMaxInstantDir' ,'VPAvg' ,
                  'RHAvg' ,'seaAPAvg',   'LocalAPAvg')]

test2 <- test2[,c('to_tempHigh2','tempHigh' , 'sunlightTimeSum','temp5Avg','windMaxInstantDir' ,'VPAvg' , 
                'RHAvg' ,'seaAPAvg',   'LocalAPAvg')]








#모델평가 테스트
predtemphigh <- predict(model_fwd3_d2,test2[-1])
plot(test2[1:32,2], type = 'o', col = 'red')#실제 최고기온
lines(predtemphigh[1:32], type = 'o', col = 'blue')#다음날 최고기온


#잔차분석
par(mfrow=c(2,2))
plot(model_fwd3_d2)

shapiro.test(model_fwd3_d2$residuals[1:4999])#정규성 가정??독립성 가정이 깨지는거 아니냐??
car::durbinWatsonTest(model_fwd3_d2)#독립성 가정
car::ncvTest(model_fwd3_d2)#등분산성 검정 ??이것도 엉망인거 같은데??

install.packages('gvlma')
library(gvlma)
summary(gvlma::gvlma(model_fwd3_d2))


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
all_date2 <- rbind(train2, test2)
chart.Correlation(all_date2, histogram=TRUE, col="grey10", pch=1)#MEAN

install.packages("GGally")
library(GGally)
ggcorr(rlogtrain, name="corr", label=T)






