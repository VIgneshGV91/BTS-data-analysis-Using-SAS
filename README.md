# BTS-data-analysis-Using-SAS
Analysis of BUREAU OF TRANSPORTATION STATISTICS Data using SAS

This exercise has 2 problems. The first problem relates to the point of sale transation dataset. The 2nd problem relates to the BTS dataset.

#Problem 1
Point_of_Sale.txt is a pipe-delimited text file that contains 100 purchase transactions from a
point of sale system. Each transaction contains a variable number of items, and each
transaction is written in a single row in the .txt file. The variables in each row of the .txt file
are: Transaction ID, Number of Items, Product Code, Units, and Price. Product Code, Units,
and Price are repeated in each record <Number of Items> times.


Intially file is Read into a SAS dataset named TRANSACTIONS1, with one observation (row) for
each item in each transaction.  The dataset contains only the following variables:
Transaction ID,
a variable named Item_ID that numbers each item within a transaction from 1 to N,
Product Code,
Units,
Price,
and a derived variable named Cost that reflects the product of Units and Price.

A second SAS dataset named TRANSACTIONS2 is created to perfom a few aggregated functions with data.....

PROC PRINT, PROC FREQ,PROC MEANS are used to generate summary statistics MIN, MAX, MEAN, and STDEV for
each numeric variable in the Transactions dataset. 
PROC UNIVARIATE is used to generate descriptive output for the variable COST. Plot of histogram of the values of COST, and both a
normal and a lognormal distribution over the histogram has been overlaid.

#Problem 2
The BTS monthly flight on-time performance file for June 2015 file is read into a SAS dataset
named BTS201506. New lag Variables have been created.
PROC UNIVARIATE is used to generate a description of the variables ArrDelay, ArrDelayLag,
and ArrDelayLag2. Plot of histogram of each with a normal and lognormal distribution
overlay is created. 
Used PROC CORR to generate a correlation matrix for the variables
DepDelay, ArrDelay, ArrDelayLag, and ArrDelayLag2.
Used all non-cancelled flights in BTS201506 to estimate a regular OLS regression model
with DepDelay as the DV and the following as the IVs:
CRSDepTime
seqnum
DepDelayLagInd
DepDelayLag
DepDelayLagCum
ArrDelayLagInd
ArrDelayLag
ArrDelayLagCum
DepDelayLag2
ArrDelayLag2


Next, used all non-cancelled flights in BTS201506 to estimate a separate LOGISTIC
regression model for each carrier. Created a new variable named DepDelayIND, defined as 1
when DepDelay is greater than 15, and 0 otherwise. Specified DepDelayInd as the response
variable and used the same IVs as in the OLS regression model above.
