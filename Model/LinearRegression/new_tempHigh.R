# 데이터 불러오기
data_mice <- read.csv("C:/Users/eourm/Desktop/융합팀플/LaVue-main/LaVue-main/dat_mice.csv")
str(data_mice)
dat_mice<- data_mice[,-c(1)] 
dat_mice$date <- as.Date(dat_mice$date)

setwd('C:/Users/eourm/Desktop/융합팀플/선형회귀')

#n+1날 최고기온뽑는과정
to_tempHigh <- dat_mice$tempHigh
str(to_tempHigh)
to_tempHigh <- to_tempHigh[-1]
to_tempHigh[43414]<-0
mice_df <- data.frame(dat_mice, to_tempHigh)
str(mice_df)
write.csv(mice_df, file="n+1일_data.csv", row.names = FALSE)

#n+2날 최고기온뽑는과정
to_tempHigh2 <- mice_df$to_tempHigh
str(to_tempHigh2)
to_tempHigh2 <- to_tempHigh2[-1]
to_tempHigh2[43414]<-0
str(to_tempHigh2[43381:43383])
mice_df2 <- data.frame(mice_df[,-27], to_tempHigh2)
str(mice_df2)
write.csv(mice_df2, file="n+2일_data.csv", row.names = FALSE)

#n+3날 최고기온뽑는과정
to_tempHigh3 <- mice_df2$to_tempHigh2
str(to_tempHigh3)
to_tempHigh3 <- to_tempHigh3[-1]
to_tempHigh3[43414]<-0
mice_df3 <- data.frame(mice_df2[,-27], to_tempHigh3)
str(mice_df3)
write.csv(mice_df3, file="n+3일_data.csv", row.names = FALSE)


#n+4날 최고기온뽑는과정
to_tempHigh4 <- mice_df3$to_tempHigh3
str(to_tempHigh4)
to_tempHigh4 <- to_tempHigh4[-1]
to_tempHigh4[43414]<-0
mice_df4 <- data.frame(mice_df3[,-27], to_tempHigh4)
str(mice_df4)
write.csv(mice_df4, file="n+4일_data.csv", row.names = FALSE)

#n+5날 최고기온뽑는과정
to_tempHigh5 <- mice_df4$to_tempHigh4
str(to_tempHigh5)
to_tempHigh5 <- to_tempHigh5[-1]
to_tempHigh5[43414]<-0
mice_df5 <- data.frame(mice_df4[,-27], to_tempHigh5)
str(mice_df5)
write.csv(mice_df5, file="n+5일_data.csv", row.names = FALSE)


#n+6날 최고기온뽑는과정
to_tempHigh6 <- mice_df5$to_tempHigh5
str(to_tempHigh6)
to_tempHigh6 <- to_tempHigh6[-1]
to_tempHigh6[43414]<-0
mice_df6 <- data.frame(mice_df5[,-27], to_tempHigh6)
str(mice_df6)
write.csv(mice_df6, file="n+6일_data.csv", row.names = FALSE)

#n+7날 최고기온뽑는과정
to_tempHigh7 <- mice_df6$to_tempHigh6
str(to_tempHigh7)
to_tempHigh7 <- to_tempHigh7[-1]
to_tempHigh7[43414]<-0
mice_df7 <- data.frame(mice_df6[,-27], to_tempHigh7)
str(mice_df7)
write.csv(mice_df7, file="n+7일_data.csv", row.names = FALSE)

