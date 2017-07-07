# Local upload small-lending data
# Ingeset full lending data

install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-vajda/2/R")
library(h2o)
h2o.init(ip="10.0.12.125", port=54321, startH2O = FALSE)

filepath = normalizePath("small-lending.csv")
rData.hex = h2o.uploadFile(path=filepath, destination_frame="rData.hex")

h2o.ls()
model1<- h2o.getModel('drf-ab4aad66-0439-43b4-a12d-f50394bb783d')

library(sqldf)
smTest <- read.csv.sql("ingest-data/lendingdata/lendingdata.csv", sql = "select * from file order by random() limit 200")

smTest.hex <- as.h2o(smTest, destination_frame = "smTest.hex")
test.fit = h2o.predict(model1, newdata = smTest.hex)

predictions <- as.data.frame(test.fit)
compare <- cbind(smTest$bad_loan, predictions)

h2o.download_pojo(model1, get_jar = TRUE, jar_name = "genmodel-jar1.jar", path='~/')
