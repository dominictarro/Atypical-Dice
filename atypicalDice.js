
function nCr(n, r) {
    /*
    Computationally efficient means of computing n Choose r.

    nCr = n! / (r! * (n-r)!)
    */
   let total = 1;
   if (r == 0) {
       return total;
   } else if (r > n/2) {
       return nCr(n, n-r);
   }
   for (let k = 1; k <= r; ++k) {
        total *= (n - k + 1);
        total /= k;
   }
   return total;

}


function count(t, n, s) {
    /*
    Counts the number of times that n dice with s sides each are rolled and the sum of the rolls equals t.

    t: Sum of all dice. Calculating the probability of hitting this.
    n: Total number of dice.
    s: Number of sides on a given die (assumed homogenous).
    */
    let t_count = 0;
    let sum_super = (t - n) / s;
    sum_super = sum_super - sum_super % 1;
    
    for (let k = 0; k <= sum_super; k++) {
        t_count += (-1)**k * nCr(n, k) * nCr(t - s*k - 1, n-1);
    }
    return t_count;

}


function pmf(t, n, s) {
    /*
    Calculates the probability that n dice with s sides each are rolled and the sum of the roll equals t.

    t: Sum of all dice. Calculating the probability of hitting this.
    n: Total number of dice.
    s: Number of sides on a given die (assumed homogenous).
    */

    let pow = s**n;
    if ((n > t) || (pow < t)) return 0.0;
    return count(t, n, s) / pow;
}


function probXltY(X, Y) {
    /*
    Calculates the probability a dice roll from set X is less than a dice roll from set Y.

    X: An array containing the data for dice set X. Formatted as (# of dice, # of sides). Both should be integers.
    Y: An array containing the data for dice set Y. Formatted as (# of dice, # of sides). Both should be integers.
    */

    let summation = 0.0;

    for (let t=Y[0]; t <= Y[0]*Y[1]; t++) {
        const p_Y_eq_t = pmf(t, Y[0], Y[1]);
        let p_X_lt_t = 0.0;

        for (var x=X[0]; x < t; x++) {
            p_X_lt_t += pmf(x, X[0], X[1]);
        }
        summation += p_X_lt_t * p_Y_eq_t;
    }

    return summation;
}

console.log(probXltY([6, 6], [9, 4]));
