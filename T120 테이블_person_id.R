# 코드제목: T120 테이블_person_id
# 코드용도: T120 테이블을 person id 기준으로 aggregation
# 코드최종결과물: 'gy20_2002.rda'
# 코드작성자: 인연준
# 코드 작성일자: 2019년 5얼 14일
# 업데이트 내용: X
# 메모리 최적화 코딩 유무 (Y/N): Y
# 총 실행시간 산출 코드 유무 (Y/N): N



rm(list=ls())

library(dplyr)

setwd("C:/CloudStation/!6 DB_Dataset/표본코호트1.0 DB_DEMO/02_T120")
gy20 <- readr::read_csv("nhid_gy20_t1_2002.csv")

#PERSON_ID랑 날짜로 오름차순
gy20 <- gy20 %>% arrange(PERSON_ID,RECU_FR_DT)

#앞날과 전날의 차이 구하기
date_og = gy20$RECU_FR_DT
date_lag1 = c(as.Date('2000-01-01'),gy20$RECU_FR_DT); date_lag1 = date_lag1[-length(date_lag1)]

diff = date_og - date_lag1
gy20 <- gy20 %>% mutate(diff=diff)
rm(date_og,date_lag1,diff)


fst_day = gy20 %>% group_by(PERSON_ID) %>% summarise(RECU_FR_DT = min(RECU_FR_DT)) %>% mutate(index=1) 

gy20 <- left_join(gy20,fst_day,by=c('PERSON_ID','RECU_FR_DT'))
rm(fst_day)
gy20[which(gy20$index == 1),'diff'] <- NA


#1번째 자리 2면 응급 구조대 후송 / 2번째 자리 1이면 응급실
gy20[which(stringr::str_sub(gy20$IN_PAT_CORS_TYPE,1,1) == "2"),'IN_PAT_CORS_TYPE'] <- 1
gy20[which(stringr::str_sub(gy20$IN_PAT_CORS_TYPE,2,2) == "1"),'IN_PAT_CORS_TYPE'] <- 1


gy20 <- gy20 %>% group_by(PERSON_ID) %>% summarise(YKIHO_ID = min(YKIHO_ID), #이거 나중에 바꿔야
                                               number_key = length(RECU_FR_DT),
                                               mean_day_diff = mean(diff,na.rm=T),
                                               sd_day_diff = sd(diff,na.rm=T),
                                               FORM_IP_CNT = sum(FORM_CD==2,na.rm=T),
                                               FORM_OP_CNT = sum(FORM_CD==3,na.rm=T),
                                               DSBJT_CD = mean(DSBJT_CD),
                                               IN_PAT_CORS_TYPE = sum(IN_PAT_CORS_TYPE,na.rm=T), #입원 경로 구분 추가전처리 필요
                                               OFFC_INJ_TYPE = mode(OFFC_INJ_TYPE), #최빈값으로 
                                               RECN_MEAN = mean(RECN,na.rm=T),
                                               RECN_SD = sd(RECN,na.rm=T),
                                               VSCN_MEAN = mean(VSCN,na.rm=T),
                                               VSCN_SD = sd(VSCN,na.rm=T),
                                               FST_IN_PAT_DT = sum(FST_IN_PAT_DT,na.rm=T), #여기부터 돈
                                               DMD_TRAMT = sum(DMD_TRAMT,na.rm=T),
                                               DMD_SBRDN_AMT = sum(DMD_SBRDN_AMT,na.rm=T),
                                               DMD_JBRDN_AMT = sum(DMD_JBRDN_AMT,na.rm=T),
                                               DMD_CT_TOT_AMT = sum(DMD_CT_TOT_AMT,na.rm=T),
                                               DMD_MRI_TOT_AMT = sum(DMD_MRI_TOT_AMT,na.rm=T),
                                               EDEC_ADD_RT = sum(EDEC_ADD_RT,na.rm=T),
                                               EDEC_TRAMT = sum(EDEC_TRAMT,na.rm=T),
                                               EDEC_SBRDN_AMT = sum(EDEC_SBRDN_AMT,na.rm=T),
                                               EDEC_JBRDN_AMT = sum(EDEC_JBRDN_AMT,na.rm=T),
                                               EDEC_CT_TOT_AMT = sum(EDEC_CT_TOT_AMT,na.rm=T),
                                               EDEC_MRI_TOT_AMT = sum(EDEC_MRI_TOT_AMT,na.rm=T),
                                               DMD_DRG_NO = sum(DMD_DRG_NO,na.rm=T), #여기까지 돈 
                                               TOT_PRES_DD_CNT_MEAN = mean(TOT_PRES_DD_CNT,na.rm=T),
                                               TOT_PRES_DD_CNT_SD = sd(TOT_PRES_DD_CNT,na.rm=T)
)





gy20
#setwd('C:/CohortDB/02_T120')
save(gy20,file='gy20_2002.rda')
rm(gy20)
