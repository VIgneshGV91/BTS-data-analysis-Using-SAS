title "&SYSUSERID - HW1" ;
ods pdf ‘C:\Users\vigne\HW1.pdf’;
/*****************************************************************/
/*********** Problem 1 Part A **********************************/
/*****************************************************************/

FILENAME IN1 "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\Point_of_Sale.txt" ;

data TRANSACTIONS1; 
length Transaction_ID $9. Item_ID 8. Product_Code $3. Units Price 8. ;
format Price z6.2 Item_ID Units z2.;
retain Transaction_ID Count ;

infile IN1 dsd delimiter='|' ;

	input Transaction_ID $ Count @ ;
		do Item_ID = 1 to Count ;

				input Product_Code $ Units Price @@ ;
					Cost + (Units * Price);
						output;
drop Count;

FILE "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\TRANSACTION1_output.txt" ;
   put Transaction_ID Item_ID Product_Code Units Price Cost;
        Cost = 0;
		end ;

run;

PROC PRINT data = TRANSACTIONS1 double label noobs;
	VAR Transaction_ID Item_ID Product_Code Units Price Cost;
RUN;

/*****************************************************************/
/*********** Problem 1 Part B **********************************/
/*****************************************************************/

FILENAME IN1 "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\Point_of_Sale.txt" ;

data TRANSACTIONS2; 
length Transaction_ID $9. Item_ID 8. Product_Code $3. Units Price 8. ;
format Price z6.2 Item_ID Units z2.;
retain Transaction_ID Count ;

infile IN1 dsd delimiter='|' ;

	input Transaction_ID $ Count @ ;
	    Cost = 0;
		do Item_ID = 1 to Count ;

				input Product_Code $ Units Price @@ ;
					Cost + (Units * Price);
					Prod1=substr(Product_Code,1,1);
					Prod2=substr(Product_Code,2,1);
					Prod3=substr(Product_Code,3,1);
						output;

FILE "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\TRANSACTION2_output.txt" ;
   put Transaction_ID Item_ID Product_Code Prod1 Prod2 Prod3 Units Price Cost;
		end ;
run;


PROC PRINT data = TRANSACTIONS2 double label noobs;
	VAR Transaction_ID Item_ID Product_Code Prod1 Prod2 Prod3 Units Price Cost;
RUN;

PROC FREQ data = TRANSACTIONS2;
	TABLE Prod1-Prod3;
RUN;

PROC FREQ data = TRANSACTIONS2;
	TABLE Prod2*Prod3 / norow nocol nopct;
RUN;

PROC MEANS data = TRANSACTIONS2;
	VAR _NUMERIC_; 
RUN;

PROC MEANS data = TRANSACTIONS2;
	VAR _NUMERIC_; 
	BY Transaction_ID;
RUN;

proc univariate data=TRANSACTIONS2;
   var Cost;
   BY Transaction_ID;
run;

goptions nodisplay;
ods graphics off;
proc univariate data=TRANSACTIONS2 noprint;
  var Cost;
  histogram Cost / normal(noprint color=red)
        name='LG1'
        vscale=count
        height=2;
 inset normal(mu sigma) / pos=nw header='Normal Estimates' height=2;
run;
quit;

proc univariate data=TRANSACTIONS2 noprint;
  var Cost;
  histogram Cost / lognormal(w=3 theta=est)
               name='LGN1'
			   vscale=count
			   height=2;
   inset n mean (5.3) std='Std Dev' (5.3) skewness (5.3) /
         pos = ne  header = 'Lognormal Estimates';
run;
quit;

/* Replay the two graphs into the same template */
goptions display;

proc greplay igout=work.gseg nofs tc=sashelp.templt template=whole;
  treplay 1:LG1 1:LGN1;
run;
ods graphics on;
quit;





/*****************************************************************/
/*********** Problem 2**********************************/
/*****************************************************************/

/***************************** The Really Easy Way ************************************/
/***************************** Good If Data Is Known Clean ****************************/
/***************************** Requires PC Files Engine ****************************/

PROC IMPORT OUT= WORK.BTS201506
            DATAFILE= "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\On_Time_On_Time_Performance_2015_6.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


/*****************************************************************/
/*****************************************************************/

filename in201506 "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\On_Time_On_Time_Performance_2015_6.csv" ;

data BTS201506 ;
infile in201506 dsd delimiter="," dlmstr=',' missover firstobs=2 ;

length Year 4. Quarter 4. Month 4. DayofMonth 4. DayOfWeek 4. FlightDate 8. ; 
format flightdate yymmdd10. ;

input Year Quarter Month DayofMonth DayOfWeek FlightDate :yymmdd10. ;
if DayOfWeek=7 ;
run ;




filename in201506 "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\On_Time_On_Time_Performance_2015_6.csv" ;

data BTS201506 ;
data BTS201506
(drop = CRSDepTime DepTime CRSArrTime ArrTime FirstDepTime WheelsOff WheelsOn Div1WheelsOn Div1WheelsOff Div2WheelsOn 
Div2WheelsOff Div3WheelsOn Div3WheelsOff Div4WheelsOn Div4WheelsOff Div5WheelsOn Div5WheelsOff 
rename =(CRSDepTimeF=CRSDepTime DepTimeF=DepTime CRSArrTimeF=CRSArrTime ArrTimeF=ArrTime FirstDepTimeF=FirstDepTime 
WheelsOffF=WheelsOff WheelsOnF=WheelsOn Div1WheelsOnF=Div1WheelsOn Div1WheelsOffF=Div1WheelsOff Div2WheelsOnF=Div2WheelsOn 
Div2WheelsOffF=Div2WheelsOff Div3WheelsOnF=Div3WheelsOn Div3WheelsOffF=Div3WheelsOff Div4WheelsOnF=Div4WheelsOn 
Div4WheelsOffF=Div4WheelsOff Div5WheelsOnF=Div5WheelsOn Div5WheelsOffF=Div5WheelsOff) ) ;


infile in201506 dsd delimiter="," dlmstr=',' missover firstobs=2 ;

length Year 4. Quarter 4. Month 4. DayofMonth 4. DayOfWeek 4. FlightDate 8. UniqueCarrier $8. AirlineID  $4. 
Carrier  $4. TailNum  $10. FlightNum  $4. OriginAirportID  $8. OriginAirportSeqID  $8. OriginCityMarketID  $6. Origin  $32. 
OriginCityName  $32. OriginState  $32. OriginStateFips  $32. OriginStateName  $32. OriginWac  $32. DestAirportID  $6. 
DestAirportSeqID  $6. DestCityMarketID  $6. Dest  $32. DestCityName  $32. DestState  $32. DestStateFips  $32. 
DestStateName  $32. DestWac  $32. CRSDepTime  $8. CRSDepTimeF 8. DepTime  $8. DepTimeF  8. DepDelay 4. DepDelayMinutes 4. 
DepDel15 4. DepartureDelayGroups 4. DepTimeBlk  $9. TaxiOut 4. WheelsOff  $8. WheelsOffF  8. WheelsOn  $8. WheelsOnF  8. 
TaxiIn 4. CRSArrTime  $8. CRSArrTimeF  8. ArrTime  $8. ArrTimeF  8. ArrDelay 4. ArrDelayMinutes 4. ArrDel15 4. 
ArrivalDelayGroups  4. ArrTimeBlk  $9. Cancelled 4. CancellationCode  $8. Diverted  4. CRSElapsedTime 4. ActualElapsedTime 4. 
AirTime 4. Flights 4. Distance 4. DistanceGroup 4. CarrierDelay 4. WeatherDelay 4. NASDelay 4. SecurityDelay 4. LateAircraftDelay 4. 
FirstDepTime  $8. FirstDepTimeF  8. TotalAddGTime 4. LongestAddGTime 4. DivAirportLandings 4. DivReachedDest 4. DivActualElapsedTime 4. DivArrDelay 4. 
DivDistance 4. Div1Airport  $8. Div1AirportID  $8. Div1AirportSeqID  $8. Div1WheelsOn  $8. Div1WheelsOnF  8. Div1TotalGTime 4. Div1LongestGTime 4. 
Div1WheelsOff  $8. Div1WheelsOffF  8. Div1TailNum  $8. Div2Airport  $8. Div2AirportID  $8. Div2AirportSeqID  $8. Div2WheelsOn  $8. Div2WheelsOnF  8. Div2TotalGTime 4. 
Div2LongestGTime 4. Div2WheelsOff  $8. Div2WheelsOffF  8. Div2TailNum  $8. Div3Airport  $8. Div3AirportID  $8. Div3AirportSeqID  $8. Div3WheelsOn  $8. Div3WheelsOnF  8. 
Div3TotalGTime 4. Div3LongestGTime 4. Div3WheelsOff  $8. Div3WheelsOffF  8. Div3TailNum  $8. Div4Airport  $8. Div4AirportID  $8. Div4AirportSeqID  $8. 
Div4WheelsOn  $8. Div4WheelsOnF  8. Div4TotalGTime 4. Div4LongestGTime 4. Div4WheelsOff  $8. Div4WheelsOffF  8. Div4TailNum  $8. Div5Airport  $8. Div5AirportID  $8. 
Div5AirportSeqID  $8. Div5WheelsOn  $8. Div5WheelsOnF  8. Div5TotalGTime 4. Div5LongestGTime 4. Div5WheelsOff  $8. Div5WheelsOffF  8. Div5TailNum   $8.  ; 

format flightdate yymmdd10. ;

input Year Quarter Month DayofMonth DayOfWeek FlightDate :yymmdd10. UniqueCarrier $ AirlineID $ Carrier $ TailNum $ FlightNum $ 
OriginAirportID $ OriginAirportSeqID $ OriginCityMarketID $ Origin $ OriginCityName $ OriginState $ OriginStateFips $ 
OriginStateName $ OriginWac $ DestAirportID $ DestAirportSeqID $ DestCityMarketID $ Dest $ DestCityName $ DestState $ 
DestStateFips $ DestStateName $ DestWac $ CRSDepTime $ DepTime $ DepDelay DepDelayMinutes DepDel15 DepartureDelayGroups 
DepTimeBlk $ TaxiOut WheelsOff $ WheelsOn $ TaxiIn CRSArrTime $ ArrTime $ ArrDelay ArrDelayMinutes ArrDel15 ArrivalDelayGroups 
ArrTimeBlk $ Cancelled CancellationCode $ Diverted CRSElapsedTime ActualElapsedTime AirTime Flights Distance DistanceGroup 
CarrierDelay WeatherDelay NASDelay SecurityDelay LateAircraftDelay FirstDepTime $ TotalAddGTime LongestAddGTime 
DivAirportLandings DivReachedDest DivActualElapsedTime DivArrDelay DivDistance Div1Airport $ Div1AirportID $ Div1AirportSeqID $ 
Div1WheelsOn $ Div1TotalGTime Div1LongestGTime Div1WheelsOff $ Div1TailNum $ Div2Airport $ Div2AirportID $ Div2AirportSeqID $ 
Div2WheelsOn $ Div2TotalGTime Div2LongestGTime Div2WheelsOff $ Div2TailNum $ Div3Airport $ Div3AirportID $ Div3AirportSeqID $ 
Div3WheelsOn $ Div3TotalGTime Div3LongestGTime Div3WheelsOff $ Div3TailNum $ Div4Airport $ Div4AirportID $ Div4AirportSeqID $ 
Div4WheelsOn $ Div4TotalGTime Div4LongestGTime Div4WheelsOff $ Div4TailNum $ Div5Airport $ Div5AirportID $ Div5AirportSeqID $ 
Div5WheelsOn $ Div5TotalGTime Div5LongestGTime Div5WheelsOff $ Div5TailNum  $ ;  

if CRSDepTime="2400" then do ;
	CRSDepTimeF=input("23:59", time5.) ; end ;
		else do ;
			format CRSDepTimeF time5. ;
			CRSDepTimeF=input(substr(CRSDepTime,1,2)||":"||substr(CRSDepTime,3,2), time5.) ; end ;

if DepTime="2400" then do ;
	DepTimeF=input("23:59", time5.) ; end ;
		else do ;
			format DepTimeF time5. ;
			DepTimeF=input(substr(DepTime,1,2)||":"||substr(DepTime,3,2), time5.) ; end ;

if CRSArrTime="2400" then do ;
	CRSArrTimeF=input("23:59", time5.) ; end ;
		else do ;
			format CRSArrTimeF time5. ;
			CRSArrTimeF=input(substr(CRSArrTime,1,2)||":"||substr(CRSArrTime,3,2), time5.) ; end ;

if ArrTime="2400" then do ;
	ArrTimeF=input("23:59", time5.) ; end ;
		else do ;
			format ArrTimeF time5. ;
			ArrTimeF=input(substr(ArrTime,1,2)||":"||substr(ArrTime,3,2), time5.) ; end ;

if FirstDepTime="2400" then do ;
	FirstDepTimeF=input("23:59", time5.) ; end ;
		else do ;
			format FirstDepTimeF time5. ;
			FirstDepTimeF=input(substr(FirstDepTime,1,2)||":"||substr(FirstDepTime,3,2), time5.) ; end ;

if WheelsOff="2400" then do ;
	WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format WheelsOffF time5. ;
			WheelsOffF=input(substr(WheelsOff,1,2)||":"||substr(WheelsOff,3,2), time5.) ; end ;

if WheelsOn="2400" then do ;
	WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format WheelsOnF time5. ;
			WheelsOnF=input(substr(WheelsOn,1,2)||":"||substr(WheelsOn,3,2), time5.) ; end ;

if Div1WheelsOn="2400" then do ;
	Div1WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div1WheelsOnF time5. ;
			Div1WheelsOnF=input(substr(Div1WheelsOn,1,2)||":"||substr(Div1WheelsOn,3,2), time5.) ; end ;

if Div1WheelsOff="2400" then do ;
	Div1WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div1WheelsOffF time5. ;
			Div1WheelsOffF=input(substr(Div1WheelsOff,1,2)||":"||substr(Div1WheelsOff,3,2), time5.) ; end ;

if Div2WheelsOn="2400" then do ;
	Div2WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div2WheelsOnF time5. ;
			Div2WheelsOnF=input(substr(Div2WheelsOn,1,2)||":"||substr(Div2WheelsOn,3,2), time5.) ; end ;

if Div2WheelsOff="2400" then do ;
	Div2WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div2WheelsOffF time5. ;
			Div2WheelsOffF=input(substr(Div2WheelsOff,1,2)||":"||substr(Div2WheelsOff,3,2), time5.) ; end ;

if Div3WheelsOn="2400" then do ;
	Div3WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div3WheelsOnF time5. ;
			Div3WheelsOnF=input(substr(Div3WheelsOn,1,2)||":"||substr(Div3WheelsOn,3,2), time5.) ; end ;

if Div3WheelsOff="2400" then do ;
	Div3WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div3WheelsOffF time5. ;
			Div3WheelsOffF=input(substr(Div3WheelsOff,1,2)||":"||substr(Div3WheelsOff,3,2), time5.) ; end ;

if Div4WheelsOn="2400" then do ;
	Div4WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div4WheelsOnF time5. ;
			Div4WheelsOnF=input(substr(Div4WheelsOn,1,2)||":"||substr(Div4WheelsOn,3,2), time5.) ; end ;

if Div4WheelsOff="2400" then do ;
	Div4WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div4WheelsOffF time5. ;
			Div4WheelsOffF=input(substr(Div4WheelsOff,1,2)||":"||substr(Div4WheelsOff,3,2), time5.) ; end ;

if Div5WheelsOn="2400" then do ;
	Div5WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div5WheelsOnF time5. ;
			Div5WheelsOnF=input(substr(Div5WheelsOn,1,2)||":"||substr(Div5WheelsOn,3,2), time5.) ; end ;

if Div5WheelsOff="2400" then do ;
	Div5WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div5WheelsOffF time5. ;
			Div5WheelsOffF=input(substr(Div5WheelsOff,1,2)||":"||substr(Div5WheelsOff,3,2), time5.) ; end ;



run ;



/***************************************************************************************/
/***************************************************************************************/
/***************************** Macrotize Long Strings **********************************/
/***************************************************************************************/
/***************************************************************************************/

%let droprenamemv = (drop = CRSDepTime DepTime CRSArrTime ArrTime FirstDepTime WheelsOff WheelsOn Div1WheelsOn Div1WheelsOff Div2WheelsOn 
Div2WheelsOff Div3WheelsOn Div3WheelsOff Div4WheelsOn Div4WheelsOff Div5WheelsOn Div5WheelsOff 
rename =(CRSDepTimeF=CRSDepTime DepTimeF=DepTime CRSArrTimeF=CRSArrTime ArrTimeF=ArrTime FirstDepTimeF=FirstDepTime 
WheelsOffF=WheelsOff WheelsOnF=WheelsOn Div1WheelsOnF=Div1WheelsOn Div1WheelsOffF=Div1WheelsOff Div2WheelsOnF=Div2WheelsOn 
Div2WheelsOffF=Div2WheelsOff Div3WheelsOnF=Div3WheelsOn Div3WheelsOffF=Div3WheelsOff Div4WheelsOnF=Div4WheelsOn 
Div4WheelsOffF=Div4WheelsOff Div5WheelsOnF=Div5WheelsOn Div5WheelsOffF=Div5WheelsOff) ) ;

%let lengthmv = length Year 4. Quarter 4. Month 4. DayofMonth 4. DayOfWeek 4. FlightDate 8. UniqueCarrier $8. AirlineID  $4. 
Carrier  $4. TailNum  $10. FlightNum  $4. OriginAirportID  $8. OriginAirportSeqID  $8. OriginCityMarketID  $6. Origin  $32. 
OriginCityName  $32. OriginState  $32. OriginStateFips  $32. OriginStateName  $32. OriginWac  $32. DestAirportID  $6. 
DestAirportSeqID  $6. DestCityMarketID  $6. Dest  $32. DestCityName  $32. DestState  $32. DestStateFips  $32. 
DestStateName  $32. DestWac  $32. CRSDepTime  $8. CRSDepTimeF 8. DepTime  $8. DepTimeF  8. DepDelay 4. DepDelayMinutes 4. 
DepDel15 4. DepartureDelayGroups 4. DepTimeBlk  $9. TaxiOut 4. WheelsOff  $8. WheelsOffF  8. WheelsOn  $8. WheelsOnF  8. 
TaxiIn 4. CRSArrTime  $8. CRSArrTimeF  8. ArrTime  $8. ArrTimeF  8. ArrDelay 4. ArrDelayMinutes 4. ArrDel15 4. 
ArrivalDelayGroups  4. ArrTimeBlk  $9. Cancelled 4. CancellationCode  $8. Diverted  4. CRSElapsedTime 4. ActualElapsedTime 4. 
AirTime 4. Flights 4. Distance 4. DistanceGroup 4. CarrierDelay 4. WeatherDelay 4. NASDelay 4. SecurityDelay 4. LateAircraftDelay 4. 
FirstDepTime  $8. FirstDepTimeF  8. TotalAddGTime 4. LongestAddGTime 4. DivAirportLandings 4. DivReachedDest 4. DivActualElapsedTime 4. DivArrDelay 4. 
DivDistance 4. Div1Airport  $8. Div1AirportID  $8. Div1AirportSeqID  $8. Div1WheelsOn  $8. Div1WheelsOnF  8. Div1TotalGTime 4. Div1LongestGTime 4. 
Div1WheelsOff  $8. Div1WheelsOffF  8. Div1TailNum  $8. Div2Airport  $8. Div2AirportID  $8. Div2AirportSeqID  $8. Div2WheelsOn  $8. Div2WheelsOnF  8. Div2TotalGTime 4. 
Div2LongestGTime 4. Div2WheelsOff  $8. Div2WheelsOffF  8. Div2TailNum  $8. Div3Airport  $8. Div3AirportID  $8. Div3AirportSeqID  $8. Div3WheelsOn  $8. Div3WheelsOnF  8. 
Div3TotalGTime 4. Div3LongestGTime 4. Div3WheelsOff  $8. Div3WheelsOffF  8. Div3TailNum  $8. Div4Airport  $8. Div4AirportID  $8. Div4AirportSeqID  $8. 
Div4WheelsOn  $8. Div4WheelsOnF  8. Div4TotalGTime 4. Div4LongestGTime 4. Div4WheelsOff  $8. Div4WheelsOffF  8. Div4TailNum  $8. Div5Airport  $8. Div5AirportID  $8. 
Div5AirportSeqID  $8. Div5WheelsOn  $8. Div5WheelsOnF  8. Div5TotalGTime 4. Div5LongestGTime 4. Div5WheelsOff  $8. Div5WheelsOffF  8. Div5TailNum   $8.  ; 

%let inputmv = input Year Quarter Month DayofMonth DayOfWeek FlightDate :yymmdd10. UniqueCarrier $ AirlineID $ Carrier $ TailNum $ FlightNum $ 
OriginAirportID $ OriginAirportSeqID $ OriginCityMarketID $ Origin $ OriginCityName $ OriginState $ OriginStateFips $ 
OriginStateName $ OriginWac $ DestAirportID $ DestAirportSeqID $ DestCityMarketID $ Dest $ DestCityName $ DestState $ 
DestStateFips $ DestStateName $ DestWac $ CRSDepTime $ DepTime $ DepDelay DepDelayMinutes DepDel15 DepartureDelayGroups 
DepTimeBlk $ TaxiOut WheelsOff $ WheelsOn $ TaxiIn CRSArrTime $ ArrTime $ ArrDelay ArrDelayMinutes ArrDel15 ArrivalDelayGroups 
ArrTimeBlk $ Cancelled CancellationCode $ Diverted CRSElapsedTime ActualElapsedTime AirTime Flights Distance DistanceGroup 
CarrierDelay WeatherDelay NASDelay SecurityDelay LateAircraftDelay FirstDepTime $ TotalAddGTime LongestAddGTime 
DivAirportLandings DivReachedDest DivActualElapsedTime DivArrDelay DivDistance Div1Airport $ Div1AirportID $ Div1AirportSeqID $ 
Div1WheelsOn $ Div1TotalGTime Div1LongestGTime Div1WheelsOff $ Div1TailNum $ Div2Airport $ Div2AirportID $ Div2AirportSeqID $ 
Div2WheelsOn $ Div2TotalGTime Div2LongestGTime Div2WheelsOff $ Div2TailNum $ Div3Airport $ Div3AirportID $ Div3AirportSeqID $ 
Div3WheelsOn $ Div3TotalGTime Div3LongestGTime Div3WheelsOff $ Div3TailNum $ Div4Airport $ Div4AirportID $ Div4AirportSeqID $ 
Div4WheelsOn $ Div4TotalGTime Div4LongestGTime Div4WheelsOff $ Div4TailNum $ Div5Airport $ Div5AirportID $ Div5AirportSeqID $ 
Div5WheelsOn $ Div5TotalGTime Div5LongestGTime Div5WheelsOff $ Div5TailNum  $ ;

%macro timevars ;
if CRSDepTime="2400" then do ;
	CRSDepTimeF=input("23:59", time5.) ; end ;
		else do ;
			format CRSDepTimeF time5. ;
			CRSDepTimeF=input(substr(CRSDepTime,1,2)||":"||substr(CRSDepTime,3,2), time5.) ; end ;
if DepTime="2400" then do ;
	DepTimeF=input("23:59", time5.) ; end ;
		else do ;
			format DepTimeF time5. ;
			DepTimeF=input(substr(DepTime,1,2)||":"||substr(DepTime,3,2), time5.) ; end ;
if CRSArrTime="2400" then do ;
	CRSArrTimeF=input("23:59", time5.) ; end ;
		else do ;
			format CRSArrTimeF time5. ;
			CRSArrTimeF=input(substr(CRSArrTime,1,2)||":"||substr(CRSArrTime,3,2), time5.) ; end ;
if ArrTime="2400" then do ;
	ArrTimeF=input("23:59", time5.) ; end ;
		else do ;
			format ArrTimeF time5. ;
			ArrTimeF=input(substr(ArrTime,1,2)||":"||substr(ArrTime,3,2), time5.) ; end ;
if FirstDepTime="2400" then do ;
	FirstDepTimeF=input("23:59", time5.) ; end ;
		else do ;
			format FirstDepTimeF time5. ;
			FirstDepTimeF=input(substr(FirstDepTime,1,2)||":"||substr(FirstDepTime,3,2), time5.) ; end ;
if WheelsOff="2400" then do ;
	WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format WheelsOffF time5. ;
			WheelsOffF=input(substr(WheelsOff,1,2)||":"||substr(WheelsOff,3,2), time5.) ; end ;
if WheelsOn="2400" then do ;
	WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format WheelsOnF time5. ;
			WheelsOnF=input(substr(WheelsOn,1,2)||":"||substr(WheelsOn,3,2), time5.) ; end ;
if Div1WheelsOn="2400" then do ;
	Div1WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div1WheelsOnF time5. ;
			Div1WheelsOnF=input(substr(Div1WheelsOn,1,2)||":"||substr(Div1WheelsOn,3,2), time5.) ; end ;
if Div1WheelsOff="2400" then do ;
	Div1WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div1WheelsOffF time5. ;
			Div1WheelsOffF=input(substr(Div1WheelsOff,1,2)||":"||substr(Div1WheelsOff,3,2), time5.) ; end ;
if Div2WheelsOn="2400" then do ;
	Div2WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div2WheelsOnF time5. ;
			Div2WheelsOnF=input(substr(Div2WheelsOn,1,2)||":"||substr(Div2WheelsOn,3,2), time5.) ; end ;
if Div2WheelsOff="2400" then do ;
	Div2WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div2WheelsOffF time5. ;
			Div2WheelsOffF=input(substr(Div2WheelsOff,1,2)||":"||substr(Div2WheelsOff,3,2), time5.) ; end ;
if Div3WheelsOn="2400" then do ;
	Div3WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div3WheelsOnF time5. ;
			Div3WheelsOnF=input(substr(Div3WheelsOn,1,2)||":"||substr(Div3WheelsOn,3,2), time5.) ; end ;
if Div3WheelsOff="2400" then do ;
	Div3WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div3WheelsOffF time5. ;
			Div3WheelsOffF=input(substr(Div3WheelsOff,1,2)||":"||substr(Div3WheelsOff,3,2), time5.) ; end ;
if Div4WheelsOn="2400" then do ;
	Div4WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div4WheelsOnF time5. ;
			Div4WheelsOnF=input(substr(Div4WheelsOn,1,2)||":"||substr(Div4WheelsOn,3,2), time5.) ; end ;
if Div4WheelsOff="2400" then do ;
	Div4WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div4WheelsOffF time5. ;
			Div4WheelsOffF=input(substr(Div4WheelsOff,1,2)||":"||substr(Div4WheelsOff,3,2), time5.) ; end ;
if Div5WheelsOn="2400" then do ;
	Div5WheelsOnF=input("23:59", time5.) ; end ;
		else do ;
			format Div5WheelsOnF time5. ;
			Div5WheelsOnF=input(substr(Div5WheelsOn,1,2)||":"||substr(Div5WheelsOn,3,2), time5.) ; end ;
if Div5WheelsOff="2400" then do ;
	Div5WheelsOffF=input("23:59", time5.) ; end ;
		else do ;
			format Div5WheelsOffF time5. ;
			Div5WheelsOffF=input(substr(Div5WheelsOff,1,2)||":"||substr(Div5WheelsOff,3,2), time5.) ; end ;
%mend ;

/***************************************************************************************/
/***************************************************************************************/
/********************* Reference Multiple Files in Single FILENAME *********************/
/***************************************************************************************/
/***************************************************************************************/

data BTS201506_day1 &droprenamemv. ;
infile in201506 delimiter="," dsd dlmstr=',' missover firstobs=2 obs=55000 ;

&lengthmv. ;
format flightdate yymmdd10. ;
&inputmv. ;

%timevars ;

if DayOfMonth=1 ;

run ;

/***************************************************************************************/
/***************************************************************************************/
/**************** Reference Multiple Files in a SAS Dataset Manifest *******************/
/***************************************************************************************/
/***************************************************************************************/
data manifest ;
infile datalines firstobs=1 ;
length fil2read $155;
input fil2read $155.;
datalines;
C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\On_Time_On_Time_Performance_2015_6.csv 
;



data one &droprenamemv. ;
set manifest ;
infile dummy filevar=fil2read end=done dsd delimiter=',' firstobs=2 obs=max ;

	&lengthmv. ;

do while(not done);
	&inputmv. ;

	%timevars ;

/*if _N_>0 and DayOfMonth=1 then do ; output; end;*/
/*if _N_>0 and Month=6 and Carrier="AA" then do ; output; end;*/
* if Carrier ^="Carr" ;

output ;
end;
run ;


/****************************************************************/
/****************************************************************/
/*********************  Conventional ****************************/
/****************************************************************/
/****************************************************************/
filename bts1 "C:\Vignesh\Studies\Spring 19\Adv Analytics using SAS\HW1\On_Time_On_Time_Performance_2015_6.csv"  ;


data one &droprenamemv. ;
infile bts1 dsd delimiter=',' firstobs=2 ;

	&lengthmv. ;

	&inputmv. ;

	%timevars ;
run ;



data One ;
set One ;
run ;

proc sort data=one ;
by Carrier TailNum FlightDate CRSDepTime FlightNum ;
run ;



data BTS_lag_delays_201506 ;
retain DepDelayLag 0 DepDelayLagCum 0 ArrDelayLag 0 ArrDelayLagCum 0 DepDelayLag2 0 ArrDelayLag2 0;
format flightdate yymmdd10. SeqNum DepDelayLagInd DepDelayLag DepDelayLagCum ArrDelayLagInd ArrDelayLag ArrDelayLagCum DepDelayLag2 ArrDelayLag2 4. ;
set one ;
by Carrier TailNum FlightDate ;
if first.FlightDate=1 then do ;
	DepDelayLag=0 ;
    DepDelayLag2=0 ;
	DepDelayLagInd=0 ;
	DepDelayLagCum=0 ;

	ArrDelayLag=0 ;
	ArrDelayLag2=0 ;
	ArrDelayLagInd=0 ;
	ArrDelayLagCum=0 ;

	SeqNum=1 ;
end ;


else do ;
	SeqNum+1 ;
	DepDelayLagInd=(DepDelayLag>0) ;
	DepDelayLagCum+DepDelayLag ;
	ArrDelayLagInd=(ArrDelayLag>0) ;
	ArrDelayLagCum+ArrDelayLag ;
end ;

if SeqNum=2 then do;
	DepDelayLag2=0;
	ArrDelayLag2=0;
end;

output ;

DepDelayLag=DepDelay ;
ArrDelayLag=ArrDelay ;
DepDelayLag2=lag(DepDelay) ;
ArrDelayLag2=lag(ArrDelay) ;

run ;


proc univariate data=BTS_lag_delays_201506;
   var ArrDelay ArrDelayLag ArrDelayLag2;
run;

/* ArrDelay */
goptions nodisplay;
ods graphics off;
proc univariate data=BTS_lag_delays_201506 noprint;
  var ArrDelay;
  histogram ArrDelay / normal(noprint color=red)
        name='LG2'
        vscale=count
        height=2;
 inset normal(mu sigma) / pos=nw header='Normal Estimates' height=2;
run;
quit;

proc univariate data=BTS_lag_delays_201506 noprint;
  var ArrDelay;
  histogram ArrDelay / lognormal(w=3 theta=est)
               name='LGN2'
			   vscale=count
			   height=2;
   inset n mean (5.3) std='Std Dev' (5.3) skewness (5.3) /
         pos = ne  header = 'Lognormal Estimates';
run;
quit;

/* Replay the two graphs into the same template */
goptions display;
proc greplay igout=work.gseg nofs tc=sashelp.templt template=whole;
  treplay 1:LG2 1:LGN2;
run;
ods graphics on;
quit;

/* ArrDelayLag */

goptions nodisplay;
ods graphics off;
proc univariate data=BTS_lag_delays_201506 noprint;
  var ArrDelayLag;
  histogram ArrDelayLag / normal(noprint color=red)
        name='LG3'
        vscale=count
        height=2;
 inset normal(mu sigma) / pos=nw header='Normal Estimates' height=2;
run;
quit;

proc univariate data=BTS_lag_delays_201506 noprint;
  var ArrDelayLag;
  histogram ArrDelayLag / lognormal(w=3 theta=est)
               name='LGN3'
			   vscale=count
			   height=2;
   inset n mean (5.3) std='Std Dev' (5.3) skewness (5.3) /
         pos = ne  header = 'Lognormal Estimates';
run;
quit;

/* Replay the two graphs into the same template */
goptions display;
proc greplay igout=work.gseg nofs tc=sashelp.templt template=whole;
  treplay 1:LG3 1:LGN3;
run;
ods graphics on;
quit;

/* ArrDelayLag2 */

goptions nodisplay;
ods graphics off;
proc univariate data=BTS_lag_delays_201506 noprint;
  var ArrDelayLag2;
  histogram ArrDelayLag2 / normal(noprint color=red)
        name='NM6'
        vscale=count
        height=2;
 inset normal(mu sigma) / pos=nw header='Normal Estimates' height=2;
run;
quit;

proc univariate data=BTS_lag_delays_201506 noprint;
  var ArrDelayLag2;
  histogram ArrDelayLag2 / lognormal(w=3 theta=est)
               name='LNM6'
			   vscale=count
			   height=2;
   inset n mean (5.3) std='Std Dev' (5.3) skewness (5.3) /
         pos = ne  header = 'Lognormal Estimates';
run;
quit;

/* Replay the two graphs into the same template */
goptions display;
proc greplay igout=work.gseg nofs tc=sashelp.templt template=whole;
  treplay 1:NM6 1:LNM6;
run;
ods graphics on;
quit;


ods select Cov PearsonCorr;
proc corr data=BTS_lag_delays_201506 noprob outp=BTSCorr /** store results **/
          nomiss /** listwise deletion of missing values **/
          cov;   /**  include covariances **/
var  DepDelay ArrDelay ArrDelayLag ArrDelayLag2;
run;

PROC PRINT data = BTSCorr double label noobs;
RUN;


/*Use all non-cancelled flights in BTS201506 to estimate a regular OLS regression model with DepDelay as the DV and the following as the IVs:*/

/**********************************************************************************************/
/********************** Let's evaluate our model **********************************************/
/**********************************************************************************************/
proc reg data=BTS_lag_delays_201506 ;
model DepDelay = CRSDepTime seqnum ArrDelayLagInd ArrDelayLag ArrDelayLagCum DepDelayLagInd DepDelayLag DepDelayLagCum DepDelayLag2 ArrDelayLag2
 / VIF SPEC ;
/**** VIF allows us to detect multicollinearity ****/
where Cancelled=0 ;
run ; quit ;

proc corr data=BTS_lag_delays_201506 ;
var CRSDepTime seqnum ArrDelayLagInd ArrDelayLag ArrDelayLagCum DepDelayLagInd DepDelayLag DepDelayLagCum DepDelayLag2 ArrDelayLag2 ;
run ;

/**** Let's address the multicollinearity ****/
proc reg data=BTS_lag_delays_201506 ;
model DepDelay = CRSDepTime seqnum ArrDelayLagInd ArrDelayLag ArrDelayLagCum  DepDelayLag2 ArrDelayLag2 /*DepDelayLagInd DepDelayLag DepDelayLagCum*/ 
 / VIF SPEC ;
/**** VIF allows us to detect multicollinearity ****/
where Cancelled=0 ;
run ; quit ;



/*Create a new variable named DepDelayIND, defined as 1 when DepDelay is greater than 15, and 0 otherwise. Specify DepDelayInd as the response variable and use the same IVs as in the OLS regression model above.*/

/*For all Carriers*/
DATA BTS_lag_delays_201506_Ind;
  SET BTS_lag_delays_201506;
     	 
  DepDelayInd = .;
  IF (DepDelayMinutes <= 15) THEN DepDelayInd = 0; 
  IF (DepDelayMinutes >  15) THEN DepDelayInd = 1;
RUN;


/*By Carrier*/
proc logistic data=BTS_lag_delays_201506_Ind descending;
  class DepDelayLagInd ArrDelayLagInd / param=ref ;
  model DepDelayInd = CRSDepTime seqnum DepDelayLag DepDelayLagCum  ArrDelayLag ArrDelayLagCum DepDelayLag2 ArrDelayLag2;
  by Carrier ;
run;

ods pdf close ;
