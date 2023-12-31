# Spatial Econometrics in R
# Originally made and Copyrighted on 2013 by Ani Katchova
# I made some modifications due to the sp & spdep packages evolution



install.packages("sf")
install.packages('spDataLarge', repos='https://nowosad.github.io/drat/', type='source')
install.packages("spatial")
install.packages("spatialreg")

library(sf)
library(spatial)
library(spatialreg)

data(columbus)
mydata <- columbus
attach(mydata)
Y <- cbind(CRIME)
X <- cbind(INC, HOVAL)
xy <- cbind(mydata$X, mydata$Y)
neighbors <- col.gal.nb
coords <- coords


# Neighbors summary
summary(neighbors)
plot(neighbors, coords)


# Descriptive statistics
summary(Y)
summary(X)

# OLS regression
olsreg <- lm(Y ~ X)
summary(olsreg)

## SPATIAL ANALYSIS BASED ON CONTIGUITY
# Spatial weight matrix based on contiguity
listw <- nb2listw(neighbors)
summary(listw)

# Moran's I test
moran.test(CRIME, listw)
moran.plot(CRIME, listw)

# Lagrange multiplier test for spatial lag and spatial error dependencies
lm.LMtests(olsreg, listw, test=c("LMlag", "LMerr"))

# Spatial lag model
spatial.lag <- lagsarlm(CRIME ~ INC + HOVAL, data = mydata, listw)
summary(spatial.lag)

# Spatial error model
spatial.error <- errorsarlm(CRIME ~ INC + HOVAL, data = mydata, listw)
summary(spatial.error)

## SPATIAL ANALYSIS BASED ON DISTANCE WEIGHT MATRIX
# Spatial weight matrix based on distance (with lower and upper bounds for distance,d1 and d2)
nb <- dnearneigh(xy, d1=0, d2=10)

listw <- nb2listw(nb, style="W")
summary(listw)

# Moran's I test
moran.test(CRIME, listw)
moran.plot(CRIME, listw)
# Lagrange multiplier test for spatial lag and spatial error dependencies
lm.LMtests(olsreg, listw, test=c("LMlag", "LMerr"))

# Spatial lag model
spatial.lag1 <- lagsarlm(CRIME ~ INC + HOVAL, data = mydata, listw)
summary(spatial.lag1)

# Spatial error model
spatial.error1 <- errorsarlm(CRIME ~ INC + HOVAL, data = mydata, listw)
summary(spatial.error1)
