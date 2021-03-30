"""
** Problem **

Patrick has nine, four-sided dice (pyramidal dice) with faces labeled 1 through 4. Claire has six, six-sided
dice (cubic dice) with faces labeled 1 through 9. Patrick and Claire roll their dice and compare the sum of
the faces: the person with the highest total wins. What is the probability Pyramidal Patrick beats Cubic
Claire? Round to seven decimal places.


NOTE: Experiencing some rounding error around the millionth place decimal, possibly a slight mistake in the
formula/algorithm.

"""
import math


class AtypicalDice:

	@staticmethod
	def count(t: int, n: int, s: int) -> float:
		"""
		Counts the number of times that n dice with s sides each are rolled and the sum of the rolls equals t.

		t: Sum of all dice. Calculating the probability of hitting this.
		n: Total number of dice.
		s: Number of sides on a given die (assumed homogenous).
		"""
		t_count = 0
		sum_super = (t-n) // s

		for k in range(sum_super + 1):
			t_count += (-1)**k * math.comb(n, k) * math.comb(t-s*k-1, n-1)
		return t_count

	@staticmethod
	def pmf(t: int, n: int, s: int) -> float:
		"""
		Calculates the probability that n dice with s sides each are rolled and the sum of the rolls equals t.

		t: Sum of all dice. Calculating the probability of hitting this.
		n: Total number of dice.
		s: Number of sides on a given die (assumed homogenous).
		"""
		return AtypicalDice.count(t=t, n=n, s=s) / s ** n

	@staticmethod
	def prob_X_lt_Y(X: tuple, Y: tuple) -> float:
		"""
		Calculates the probability a dice roll from set X is less than a dice roll from set Y.

		X: A tuple containing the data for dice set X. Formatted as (# of dice, # of sides). Both should be integers.
		Y: A tuple containing the data for dice set Y. Formatted as (# of dice, # of sides). Both should be integers.
		"""
		min_outcome = min(X[0], Y[0])
		max_outcome = max(X[0]*X[1], Y[0]*Y[1])

		summation = 0
		for t in range(min_outcome, max_outcome):
			p_Y_eq_t = AtypicalDice.pmf(t=t, n=Y[0], s=Y[1])
			p_X_lt_t = 0

			for x in range(X[0], t):
				p_X_lt_t += AtypicalDice.pmf(t=x, n=X[0], s=X[1])

			summation += p_Y_eq_t * p_X_lt_t

		return summation


if __name__ == "__main__":

	print(round(AtypicalDice.prob_X_lt_Y(X=(6,6),Y=(9,4)), 7))

