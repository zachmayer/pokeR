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
#' @param x an integer matrix, where each column is a hand, or an integer vector.
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
#' @param x an integer matrix, where each column is a hand, or an integer vector.
#' @param threads Number of openmp threads to use
#' @return an integer, where higher = better
#' @references \url{https://gist.github.com/EluctariLLC/832122}
#' @importFrom bitops bitShiftR bitAnd
#' @export
#' @examples
#' cards <- sample(1:52, 7*2e7, replace=TRUE) #20 million hands
#' system.time(res <- evalMultiHand(cards))
evalMultiHand <- function(x) {
  stopifnot(is.integer(x))
  stopifnot(is.vector(x))
  if(anyNA(x)){stop('x must not have NAs')}
  stopifnot(length(x) %% 7 == 0)
  rank <- GetMultiHandValue(x, handRanks)
  list(
    rank=rank,
    besthand=which.max(rank)
  )
}
