/*
** Problem **

Patrick has nine, four-sided dice (pyramidal dice) with faces labeled 1 through 4. Claire has six, six-sided
dice (cubic dice) with faces labeled 1 through 9. Patrick and Claire roll their dice and compare the sum of
the faces: the person with the highest total wins. What is the probability Pyramidal Patrick beats Cubic
Claire? Round to seven decimal places.

NOTE: Experiencing a rounding mistake to 6 decimals

*/
#include <iostream>
#include <cmath>
using namespace std;


long nCr(int n, int r) {
    /*
    Computationally efficient means of computing n Choose r.

    nCr = n! / (r! * (n-r)!)
    */
    if (r == 0) return 1;
    // Better for large r
    if (r > n/2) return nCr(n, n - r);

    long total = 1;

    // Avoids overflow ceiling better
    for (int k = 1; k <= r; ++k) {
        total *= (n - k + 1);
        total /= k;
    }
    return total;
}


long count(int t, int n, int s) {
    /*
    Counts the number of times that n dice with s sides each are rolled and the sum of the rolls equals t.

    t: Sum of all dice. Calculating the probability of hitting this.
    n: Total number of dice.
    s: Number of sides on a given die (assumed homogenous).
    */
    long t_count = 0;
    int sum_super = floor((t - n) / s);

    for (int k=0; k <= sum_super; k++) {
        t_count += pow(-1, k) * nCr(n, k) * nCr(t - s*k - 1, n-1);
    }
    return t_count;
}


long double pmf(int t, int n, int s) {
    /*
    Calculates the probability that n dice with s sides each are rolled and the sum of the roll equals t.

    t: Sum of all dice. Calculating the probability of hitting this.
    n: Total number of dice.
    s: Number of sides on a given die (assumed homogenous).
    */
    if ((n > t) || (pow(n, s) < t)) return 0.0;
    return count(t, n, s) / pow(s, n);
}


long double prob_X_lt_Y(int *X, int *Y) {
    /*
    Calculates the probability a dice roll from set X is less than a dice roll from set Y.

    X: An array containing the data for dice set X. Formatted as (# of dice, # of sides). Both should be integers.
    Y: An array containing the data for dice set Y. Formatted as (# of dice, # of sides). Both should be integers.
    */
    long double summation = 0.0;

    for (int t=Y[0]; t <= Y[0]*Y[1]; t++) {
        long double p_Y_eq_t = pmf(t, Y[0], Y[1]);
        long double p_X_lt_t = 0.0;
        for (int x=X[0]; x<t; x++) {
            p_X_lt_t += pmf(x, X[0], X[1]);
        }
        summation += p_X_lt_t * p_Y_eq_t;

    }

    return summation;
}


int main() {
    int X[2] = {6, 6};
    int Y[2] = {9, 4};
    long double answer = prob_X_lt_Y(X, Y);
    cout << answer << endl;

    return 0;
}
