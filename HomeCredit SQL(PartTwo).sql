---(Q1)Count of Bureau Records for Each Client

select A.SK_ID_CURR,COUNT(*) As record_count
from  application_train A
INNER JOIN
   bureau B ON  A.SK_ID_CURR =  B.SK_ID_CURR
Group by A.SK_ID_CURR;

---(Q2)Calculate the average credit amount.

ALTER TABLE previous_application
ALTER COLUMN AMT_CREDIT float; 

SELECT *FROM previous_application
WHERE AMT_CREDIT IS NOT NULL;
  
SELECT
 at.NAME_FAMILY_STATUS,
    AVG(CAST(pa.AMT_CREDIT AS numeric(18,2))) AS Average_Credit_Amount
FROM
    application_train at
INNER JOIN
    previous_application pa ON at.SK_ID_CURR = pa.SK_ID_CURR
GROUP BY
    at.NAME_FAMILY_STATUS;

---(Q3)Total Installment Amount Paid by Clients:

select SUM(AMT_PAYMENT) AS Total_installment_payment
FROM
    application_train at
INNER JOIN
    installments_payments ip ON at.SK_ID_CURR = ip.SK_ID_CURR
GROUP BY
    at. SK_ID_CURR;

----(Q4)Count of POS Cash Balance Records for Each Client:

select COUNT(MONTHS_BALANCE) AS POS_Cash_Balance_Records 
from application_train AT
Inner JOin 
POS_CASH_balance PC ON AT.SK_ID_CURR = PC.SK_ID_CURR
Group by AT.SK_ID_CURR;

----(Q5) Average Credit Card Balance by Family Status:

Alter Table credit_card_balance
Alter Column AMT_BALANCE float;

select AVG(AMT_BALANCE) AS Credit_Card_Balance
from application_train AT
inner join credit_card_balance CB ON AT.SK_ID_CURR = CB.SK_ID_CURR
Group by At.NAME_FAMILY_STATUS;

---(Q6) Average Previous Credit and Total Installments by Occupation Type:

select AVG(PA.AMT_CREDIT)AS previous_Credit_amount,
Sum(AMT_PAYMENT) AS Total_installments_paid,OCCUPATION_TYPE
from application_train AT
Inner Join previous_application PA ON AT.SK_ID_CURR = PA.SK_ID_CURR
Inner Join installments_payments IP ON AT.SK_ID_CURR = IP.SK_ID_CURR
Group by AT.OCCUPATION_TYPE;

---(Q7)Count of Bureau Balance Records for Each Client:

select COUNT(MONTHS_BALANCE) AS bureau_balance_records,at.SK_ID_CURR
from application_train at
inner join bureau b ON at.SK_ID_CURR = b.SK_ID_CURR
inner join bureau_balance bb ON b.SK_ID_BUREAU = bb.SK_ID_BUREAU
group by at.SK_ID_CURR;

---(Q8)Average Credit Card and POS Cash Monthly Balance by Education Type:

select AVG(cb.AMT_BALANCE) AS credit_card_balance,
AVG(pc.MONTHS_BALANCE) AS pos_cash_balance
from [dbo].[application_train] at
inner join [dbo].[credit_card_balance] cb 
ON at.SK_ID_CURR=cb.SK_ID_CURR
inner join [dbo].[POS_CASH_balance] pc
ON at.SK_ID_CURR=pc.SK_ID_CURR
group by at.NAME_EDUCATION_TYPE;
	   
--(Q9)Installments Paid and POS Cash Balance by Gender and Family Status:

select SUM(AMT_PAYMENT) AS installments_payments,
AVG(MONTHS_BALANCE) AS pos_cash_balance
from application_train at 
inner join installments_payments IP 
ON at.SK_ID_CURR=IP.SK_ID_CURR
inner join POS_CASH_balance PC 
ON at.SK_ID_CURR=PC.SK_ID_CURR
group by CODE_GENDER,NAME_FAMILY_STATUS

---(10)Previous Credit by Housing Type:

select AVG(p.AMT_CREDIT) AS previous_credit_amount
from application_train at
Inner Join [dbo].[bureau] b  
ON at.SK_ID_CURR=b.SK_ID_CURR
Inner Join [dbo].[previous_application] p
ON at.SK_ID_CURR=p.SK_ID_CURR
group by NAME_HOUSING_TYPE;


