#코드제목 : 
#코드용도 : aggregation
#코드최종결과물: rda file
#코드작성자: 인연준
#코드 작성일자: 2019년 5월 11일
#업데이트 내용: 직접 알고리즘 짜지 않고 빠른 함수를 사용
#메모리 최적화 코딩 유무 (Y/N): Y
#총 실행시간 산출 코드 유무 (Y/N): Y

rm(list=ls())
start_time <- Sys.time()


library(dplyr)
library(tidyr)
options(warning=-1)
options('scipen'=100)


setwd("C:/????")
gy40<-readr::read_csv("????.csv")


#SICK_SYM 앞 1,2자리 남기기
str2<-stringr::str_sub(gy40$SICK_SYM,1,2)
str1<-stringr::str_sub(gy40$SICK_SYM,1,1)

#SICK_1부터 SICK_22까지 넣기
gy40$SICK_SYM[str1 == 'A' | str1 == 'B'] <- 'SICK_1'
gy40$SICK_SYM[str1 == 'C'] <- 'SICK_2'
gy40$SICK_SYM[str2 == 'D1' | str2 == 'D2' | str2 == 'D3' | str2 == 'D4'] <- 'SICK_2'
gy40$SICK_SYM[str2 == 'D5' | str2 == 'D6' | str2 == 'D7' | str2 == 'D8'] <- 'SICK_3'
gy40$SICK_SYM[str1 == 'E'] <- 'SICK_4'
gy40$SICK_SYM[str1 == 'F'] <- 'SICK_5'
gy40$SICK_SYM[str1 == 'G'] <- 'SICK_6'
gy40$SICK_SYM[str2 == 'H0' | str2 == 'H1' | str2 == 'H2' | str2 == 'H3' | str2 == 'H4' | str2 == 'H5'] <- 'SICK_7'
gy40$SICK_SYM[str2 == 'H6' | str2 == 'H7' | str2 == 'H8' | str2 == 'H9'] <- 'SICK_8'
gy40$SICK_SYM[str1 == 'I'] <- 'SICK_9'
gy40$SICK_SYM[str1 == 'J'] <- 'SICK_10'
gy40$SICK_SYM[str1 == 'K'] <- 'SICK_11'
gy40$SICK_SYM[str1 == 'L'] <- 'SICK_12'
gy40$SICK_SYM[str1 == 'M'] <- 'SICK_13'
gy40$SICK_SYM[str1 == 'N'] <- 'SICK_14'
gy40$SICK_SYM[str1 == 'O'] <- 'SICK_15'
gy40$SICK_SYM[str1 == 'P'] <- 'SICK_16'
gy40$SICK_SYM[str1 == 'Q'] <- 'SICK_17'
gy40$SICK_SYM[str1 == 'R'] <- 'SICK_18'
gy40$SICK_SYM[str1 == 'S' | str1 == 'T'] <- 'SICK_19'
gy40$SICK_SYM[str1 == 'U'] <- 'SICK_22'
gy40$SICK_SYM[str1 == 'V' | str1 == 'Y'] <- 'SICK_20'
gy40$SICK_SYM[str1 == 'Z'] <- 'SICK_21'

gy40$index <- 1

#여기까지가 part 1

mid_time <- Sys.time()
part1_time = mid_time - start_time
print(paste('part1 time :',part1_time))

gy40 <- spread(gy40, key='SICK_SYM',value='index')
gy40 <- gy40[-which(duplicated(gy40$KEY_SEQ)),]

#여기까지가 part 2

end_time <- Sys.time()


part2_time = end_time - mid_time

print(paste('part2 time :',part2_time))

entire_time = end_time - start_time
print(paste('entire time :',entire_time))

setwd("C:/????")
save(gy40,file='gy40_2002.rda')
rm(gy40)
