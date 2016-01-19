#Setup
library(microbenchmark)
library(pokeR)
n <- 5e6 #1 million hands
cards <- sample(1:52, 7*n, replace=TRUE)

#Warmup
r1 = evalMultiHand(cards)
r2 = evalMultiHandSpecialK(cards)

#Run benchmark
microbenchmark(
  twoplustwo = evalMultiHand(cards),
  SpecialK = evalMultiHandSpecialK(cards),
  times = 100
)
