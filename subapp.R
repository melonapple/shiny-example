library(data.table)
library(stringr)
library(raster)

# lat/lon computation

station = fread('Example/data/stations.csv', encoding='UTF-8')


station$전철역명 = ifelse(str_detect(station$'전철역명', '역'), station$'전철역명', paste0(station$'전철역명', '역'))



station_location = mutate_geocode(station, 전철역명)


p = get_googlemap('seoul', zoom=11) %>% ggmap()

color_list <- c("#0052A4", "#009D3E", "#EF7C1C", "#00A5DE", "#996CAC", "#CD7C2F", "#747F00", "#EA545D", "#BDB092")


korea <- shapefile('Example/TL_SCCO_SIG.shp') %>%
  spTransform(CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))

korea$SIG_KOR_NM <- iconv(korea$SIG_KOR_NM, from = "CP949", to = "UTF-8", sub = NA, mark = TRUE, toRaw = FALSE) # change encoding
korea <- fortify(korea, region='SIG_CD')

korea$id <- as.numeric(korea$id)
seoul_map <- korea[korea$id <= 11740, ]

rm(korea)


save.image(file='Example/data/station_latlon.RData')


