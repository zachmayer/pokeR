#include <Rcpp.h>
//#include <omp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
int GetHandValue(IntegerVector cards, IntegerVector HR){
  IntegerVector::iterator pCards = cards.begin();
  int p = HR[53 + *pCards++];
  p = HR[p + *pCards++];
  p = HR[p + *pCards++];
  p = HR[p + *pCards++];
  p = HR[p + *pCards++];
  p = HR[p + *pCards++];
  return HR[p + *pCards++];
}

// [[Rcpp::export]]
IntegerVector GetMultiHandValue(IntegerVector multicards, IntegerVector HR) {
  int n = multicards.size()/7;
  IntegerVector out(n);
  int p = 0;

  std::vector<int> multicards2 = Rcpp::as<std::vector<int> >(multicards);
  std::vector<int> HR2 = Rcpp::as<std::vector<int> >(HR);
  std::vector<int>::iterator pCards = multicards2.begin();

  //#pragma omp parallel for private(p, pCards) default(shared) schedule(auto)
  for (int i = 0; i < n; ++i){
    p = HR2[53 + *pCards++];
    p = HR2[p + *pCards++];
    p = HR2[p + *pCards++];
    p = HR2[p + *pCards++];
    p = HR2[p + *pCards++];
    p = HR2[p + *pCards++];
    out[i] = HR2[p + *pCards++];
  }
  return out;
}
