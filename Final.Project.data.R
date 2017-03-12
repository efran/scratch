# Organize the data file - eliminate gender variants
info_data <- read.csv("egFirstShared_sample3.csv")
info_data$gender[info_data$gender=="Female"] <- "female"
info_data$gender[info_data$gender=="FEMALE"] <- "female"
info_data$gender[info_data$gender=="female "] <- "female"
info_data$gender[info_data$gender=="Male"] <- "male"
info_data$gender[info_data$gender=="mâle"] <- "male"

# Add column for tracking number of previous projects
tmp <- data.frame(prev.projects=unlist(tapply(info_data$id, info_data$id, function (x) {seq(0, length(x)-1)})),
                  id=unlist(tapply(info_data$id, info_data$id, function (x) {x})))

info_data <- info_data[order(info_data$id, info_data$datetime_first_shared),]
tmp <- tmp[order(tmp$id, tmp$prev.projects),]
info_data$prev.projects <- tmp$prev.projects

# Add column to track running sum of loveits
tmp2 <- data.frame(running.lovecount=unlist(tapply(info_data$love_count, info_data$id, function (x) {cumsum(x)})),
                   id=unlist(tapply(info_data$id, info_data$id, function (x) {x})))

info_data <- info_data[order(info_data$id, info_data$datetime_first_shared),]
tmp <- tmp[order(tmp$id, tmp2$running.lovecount),]
info_data$running.lovecount <- tmp2$running.lovecount

# Add column to track running loveit count for all previous projects
info_data$previous.total.love <- info_data$running.lovecount - info_data$love_count