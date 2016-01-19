#' @title Maps a vector of poker cards to an integer
#'
#' @description 2 is low and A is high.  Suits go clubs, diamonds, hearts,
#' spaces.  E.g. '2c'=1 and 'As'=52
#'
#' @details No details
#' @note No notes
#' @param x a poker card
#' @importFrom fastmatch fmatch
#' @importFrom stringi stri_trans_tolower
#' @export
#' @examples
#' mapCards(c("As", "Ks", "Qs", "Js", "Ts", "3c", "5h"))
mapCards <- function(x){
  fmatch(stri_trans_tolower(x), cardMap)
}

#' @title Evaluate a poker hand
#'
#' @description Returns an integer, where higher = a better hand
#'
#' @details No details
#'
#' @note No notes
#'
#' @param x An integer vector.
#' @return an integer, where higher = better
#' @references \url{https://gist.github.com/EluctariLLC/832122}
#' @importFrom bitops bitShiftR bitAnd
#' @export
#' @examples
#' evalHand(mapCards(c("As", "Ks", "Qs", "Js", "Ts", "3c", "5h")))
evalHand <- function(x) {
  stopifnot(is.integer(x))
  stopifnot(length(x)==7)
  if(anyNA(x)){stop('x must not have NAs')}
  rank <- GetMultiHandValue(x, handRanks)
  handCategory <- bitShiftR(rank, 12)
  rankWithinCategory <- bitAnd(handCategory, 0x00000FFF)
  list(
    handCategory=handCategory,
    handCategory=handCategory,
    rank=rank,
    handName=handNames[handCategory]
  )
}

#' @title Evaluate multiple poker hands
#'
#' @description Returns an integer vector, where higher = a better hand
#'
#' @details No details
#'
#' @note No notes
#'
#' @param x An integer vector.
#' @return an integer, where higher = better
#' @references \url{https://gist.github.com/EluctariLLC/832122}
#' @importFrom bitops bitShiftR bitAnd
#' @export
#' @examples
#' n <- 2e7 #20 million hands
#' cards <- sample(1:52, 7*n, replace=TRUE)
#' t1 <- system.time(res <- evalMultiHand(cards))
#' hps <- prettyNum(n / t1[['elapsed']],big.mark=",",scientific=FALSE)
#' print(paste("evaluated", hps, "poker hands per second"))
evalMultiHand <- function(x) {
  stopifnot(is.integer(x))
  stopifnot(is.vector(x))
  stopifnot(min(x)>=1)
  stopifnot(max(x)<=52)
  if(anyNA(x)){stop('x must not have NAs')}
  stopifnot(length(x) %% 7 == 0)
  rank <- GetMultiHandValue(x, handRanks)
  list(
    rank=rank,
    besthand=which.max(rank)
  )
}

#' @title Evaluate multiple poker hands using the SpecialK evaluator
#'
#' @description Returns an integer vector, where higher = a better hand
#'
#' @details No details
#'
#' @note No notes
#'
#' @param x An integer vector.
#' @return an integer, where higher = better
#' @references \url{https://gist.github.com/EluctariLLC/832122}
#' @importFrom bitops bitShiftR bitAnd
#' @export
#' @examples
#' n <- 2e7 #20 million hands
#' cards <- sample(1:52, 7*n, replace=TRUE)
#' t1 <- system.time(res_sk <- evalMultiHandSpecialK(cards))
#' hps <- prettyNum(n / t1[['elapsed']],big.mark=",",scientific=FALSE)
#' print(paste("evaluated", hps, "poker hands per second"))
evalMultiHandSpecialK <- function(x) {
  stopifnot(is.integer(x))
  stopifnot(is.vector(x))
  stopifnot(min(x)>=1)
  stopifnot(max(x)<=52)
  if(anyNA(x)){stop('x must not have NAs')}
  x <- x - 1L
  stopifnot(length(x) %% 7 == 0)
  rank <- GetMultiHandValueSpecialK(x)
  list(
    rank=rank,
    besthand=which.max(rank)
  )
}
