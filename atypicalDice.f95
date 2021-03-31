!! gfortran atypicalDice.f95
!! **********************************************************************************************************************
!! 
!! ** Problem **
!! Patrick has nine, four-sided dice (pyramidal dice) with faces labeled 1 through 4. Claire has six, six-sided
!! dice (cubic dice) with faces labeled 1 through 9. Patrick and Claire roll their dice and compare the sum of
!! the faces: the person with the highest total wins. What is the probability Pyramidal Patrick beats Cubic
!! Claire? Round to seven decimal places.
!!
!! **********************************************************************************************************************
program atypicalDice
    !! ******************************************************************************************************************
    !!
    !! Calculates the probability a dice roll from set X is less than a dice roll from set Y.
    !! 
    !! X: 6 dice with 6 sides each
    !! Y: 9 dice with 4 sides each
    !!
    !! ******************************************************************************************************************
    implicit none
    integer(KIND=16), dimension(2) :: X, Y
    integer(KIND=16) :: t, z
    real(KIND=16) :: p_Y_eq_t, p_X_lt_t, summation = 0.0d0
    X = (/6, 6/)
    Y = (/9, 4/)

    do t = Y(1), Y(1)*Y(2)
        p_Y_eq_t = pmf(t, Y(1), Y(2))
        p_X_lt_t = 0.0d0

        do z = X(1), t-1
            p_X_lt_t = p_X_lt_t + pmf(z, X(1), X(2))
        end do
        summation = summation + p_X_lt_t * p_Y_eq_t
    end do

    WRITE(*,*) summation
    

    contains
        function nCr(n, r) result(total)
            !! **********************************************************************************************************
            !!
            !! Computationally efficient means of computing n Choose r
            !! 
            !! n: Size of population to choose from
            !! r: Size of sample chosen
            !!
            !! **********************************************************************************************************
            implicit none
            integer(KIND=16), intent(IN) :: n, r
            integer(KIND=16) :: r_true
            integer(KIND=16) :: total, k = 1
            total = 1
        
            if (r == 0) return
        
            if (r > n/2) then
                r_true = n - r
            else
                r_true = r
            end if
        
            do k = 1, r
                total = total * (n - k + 1) / k
            end do
        end function nCr
        
        
        function count(t, n, s)
            !! **********************************************************************************************************
            !!
            !! Counts the number of times that n dice with s sides each are rolled and the sum of the rolls equals t.
            !! 
            !! t: Sum of all dice. Calculating the probability of hitting this.
            !! n: Total number of dice.
            !! s: Number of sides on a given die (assumed homogenous).
            !!
            !! **********************************************************************************************************
            implicit none
            integer(KIND=16), intent(IN) :: t, n, s
            integer(KIND=16) :: count, group, spill, sum_super, k = 0
            real(KIND=16) :: sum_super_real

            count = 0
            sum_super_real = (t - n) / s
            sum_super = FLOOR(sum_super_real)
        
            do k = 0, sum_super
                count = count + (-1)**k * nCr(n, k) * nCr(t - s*k - 1, n-1)
            end do
        
        end function count


        function pmf(t, n, s)
            !! **********************************************************************************************************
            !!
            !! Calculates the probability that n dice with s sides each are rolled and the sum of the roll equals t.
            !! 
            !! t: Sum of all dice. Calculating the probability of hitting this.
            !! n: Total number of dice.
            !! s: Number of sides on a given die (assumed homogenous).
            !!
            !! **********************************************************************************************************
            implicit none
            integer(KIND=16), intent(IN) :: t, n, s
            real(KIND=16) :: pmf
            pmf = 0.0d0
            if (n > t) return
            if (s**n < t) return
            
            pmf = REAL(count(t, n, s)) / REAL(s**n)
        end function pmf


end program atypicalDice