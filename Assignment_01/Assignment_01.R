library(tidyverse)
library(reshape2)

data <- read.csv("train.csv", row.names = "Id")
head(data)

#Summary statistics of the sale prices
summary(data$SalePrice)
hist(data$SalePrice) #Histogram

#Sale price by 1st floor square feet
with(data, coef(lm(SalePrice ~ X1stFlrSF)))
data %>% ggplot(aes(x = X1stFlrSF, y = SalePrice)) +
    geom_point() + 
    geom_abline(slope = 124.5006, intercept = 36173.4468, col = "red") +
    labs(title = "Does sale price depend on the 1st floor square feet?")

#Sale price by above ground area
with(data, coef(lm(SalePrice ~ GrLivArea)))
data %>% ggplot(aes(x = GrLivArea, y = SalePrice)) +
    geom_point() + 
    geom_abline(slope = 107.1304, intercept = 18569.0259, col = "red") +
    labs(title = "Does sale price depend on the above ground area?")

#Boxplot of sale price by overall quality 
data %>% ggplot(aes(x = OverallQual, 
                    y = SalePrice, fill = OverallQual)) +
    geom_boxplot(aes(group = OverallQual)) +
    labs(title = "Sale price by overall quality")

#Average price by different zoning
price.zoning <- data %>%
    group_by(MSZoning) %>%
    summarise(AveragePrice = mean(SalePrice)) %>%
    arrange(desc(AveragePrice))

#Average lot area by zoning classification
zoning <- data %>%
    group_by(MSZoning) %>%
    summarise(AverageLotArea = mean(LotArea)) %>%
    arrange(desc(AverageLotArea))

#Counts of different zoning classes
sum.zoning <- data %>%
    group_by(MSZoning) %>%
    summarise(count = length(MSZoning)) %>%
    arrange(desc(count))

sum.zoning %>% ggplot(aes(x = MSZoning, y = count)) +
    geom_bar(aes(fill = MSZoning), stat = "identity") +
    labs(title = "Counts of different zoning classes")

#Counts of different lot shapes 
sum.lotshape <- data %>%
    group_by(LotShape) %>%
    summarise(count = length(LotShape)) %>%
    arrange(desc(count))

sum.lotshape %>% ggplot(aes(x = LotShape, y = count)) +
    geom_bar(aes(fill = LotShape), stat = "identity") +
    labs(title = "Counts of different lot shapes")

#Correlation matrices for numeric columns
mat.corr <- cor(data[sapply(data, is.numeric)], 
                use = "pairwise.complete.obs")
#Base plotting system
heatmap(mat.corr)

#ggplot
melted.cormat <- melt(mat.corr)
melted.cormat %>% ggplot(aes(x = Var1, y = Var2, fill = value)) + 
    geom_tile()



