use HomeCredit
go
-------Primary Key and NOT NULL Constraints---------
----(1)Ensure Sk_Id_curr is Not NULL for application_train
Alter Table application_train
Alter Column SK_ID_CURR INT NOT NULL;

--- Create Primary Key for application_train
Alter Table application_train
Add Constraint pk_SK_ID Primary Key(SK_ID_CURR);

----(2)Ensure SK_ID_BUREAU is Not NULL for BUREAU Table
Alter Table bureau
Alter Column SK_ID_BUREAU INT NOT NULL;

Alter Table bureau
Alter Column [SK_ID_CURR] INT NOT NULL;

--- Create Primary Key for BUREAU Table
Alter Table bureau
Add Constraint pk_bureau Primary Key(SK_ID_BUREAU);

----(3)Ensure SK_ID_PREV is Not NULL for previous_application Table
Alter Table previous_application
Alter Column SK_ID_PREV INT NOT NULL;

--- Create Primary Key for previous_application Table
Alter Table previous_application 
Add Constraint pk_previous_application Primary Key(SK_ID_PREV);

----(4)Ensure SK_ID_CURR,SK_ID_PREV,NUM_INSTALMENT_NUMBER,DAYS_INSTALMENT,
--NUM_INSTALMENT_VERSION,DAYS_ENTRY_PAYMENT,AMT_INSTALMENT, AMT_PAYMENT is Not NULL for previous_application Table

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN SK_ID_CURR INT NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN SK_ID_PREV INT NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN NUM_INSTALMENT_NUMBER INT NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN DAYS_INSTALMENT float NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN NUM_INSTALMENT_VERSION float NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN DAYS_ENTRY_PAYMENT float  NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN AMT_INSTALMENT float  NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN AMT_PAYMENT float  NOT NULL;

--- Create Primary Key for installments_payments Table

ALTER TABLE installments_payments
ADD CONSTRAINT PK_installments PRIMARY KEY (SK_ID_CURR, SK_ID_PREV, NUM_INSTALMENT_NUMBER, DAYS_INSTALMENT, AMT_PAYMENT, AMT_INSTALMENT, DAYS_ENTRY_PAYMENT, NUM_INSTALMENT_VERSION);

----(5)Ensure SK_ID_CURR,SK_ID_PREV,MONTHS_BALANCE for POS_CASH_balance Table

Alter Table POS_CASH_balance
Alter column SK_ID_PREV Int Not Null;

Alter Table POS_CASH_balance
Alter column SK_ID_CURR Int Not Null;

Alter Table POS_CASH_balance
Alter column MONTHS_BALANCE Int Not Null;

--- Create Primary Key for POS_CASH_balance Table
ALTER TABLE POS_CASH_balance
ADD CONSTRAINT PK_POS_CASH_balance PRIMARY KEY(SK_ID_PREV,SK_ID_CURR,MONTHS_BALANCE)

----(6)Ensure SK_ID_PREV,SK_ID_CURR,MONTHS_BALANCE for credit_card_balance
Alter Table credit_card_balance
Alter column SK_ID_PREV Int NOt Null;

Alter Table  credit_card_balance
Alter column SK_ID_CURR Int Not Null;

Alter Table credit_card_balance
ALter column MONTHS_BALANCE Int Not NUll;

--- Create Primary Key for credit_card_balance
ALTER TABLE credit_card_balance
ADD CONSTRAINT PK_credit_card_balance PRIMARY KEY(SK_ID_PREV,SK_ID_CURR,MONTHS_BALANCE)

----(7)Ensure SK_ID_BUREAU,MONTHS_BALANCE for bureau_balance
Alter Table bureau_balance
Alter Column SK_ID_BUREAU Int Not Null;

Alter Table bureau_balance
Alter Column MONTHS_BALANCE Int Not Null;

--- Create Primary Key for bureau_balance

Alter Table bureau_balance
ADD CONSTRAINT PK_bureau_balance PRIMARY KEY(SK_ID_BUREAU,MONTHS_BALANCE)

  -----Foreign Key Constraints and Data Integrity--------
  
  ---(Q1)Identify orphaned records
Select * from bureau b
Left join application_train a ON b.SK_ID_CURR = a.SK_ID_CURR
where a.SK_ID_CURR is NULL;

-- Delete Orphaned records
Delete from bureau
where SK_ID_CURR NOT IN(select SK_ID_CURR from application_train);

--- Add foreign key Constraint
Alter Table bureau
Add constraint FK_bureau_application_train
FOREIGN KEY (SK_ID_CURR)
References application_train(SK_ID_CURR);

---(Q2)Identify orphaned records
Select * from previous_application P
Left join application_train a ON p.SK_ID_CURR = a.SK_ID_CURR
where a.SK_ID_CURR is NULL;

-- Delete Orphaned records
Delete from previous_application
where SK_ID_CURR NOT IN(select SK_ID_CURR from application_train);

--- Add foreign key Constraint
Alter Table previous_application
Add constraint FK_previous_application_application_train
FOREIGN KEY (SK_ID_CURR)
References application_train(SK_ID_CURR);

---(Q3)Identify orphaned records
Select * from installments_payments I
Left join application_train a ON I.SK_ID_CURR = a.SK_ID_CURR
where a.SK_ID_CURR is NULL;

Select * from installments_payments I
Left join previous_application P ON I.SK_ID_PREV = P.SK_ID_PREV
where P.SK_ID_PREV is NULL;


-- Delete Orphaned records
Delete from installments_payments
where SK_ID_CURR NOT IN(select SK_ID_CURR from application_train);

Delete from installments_payments
where SK_ID_PREV NOT IN(select SK_ID_PREV from previous_application);


--- Add foreign key Constraint
Alter Table installments_payments
Add constraint FK_installments_payments_application_train 
FOREIGN KEY (SK_ID_CURR)
References application_train(SK_ID_CURR);
Alter Table installments_payments
Add constraint  FK_installments_payments_previous_application
FOREIGN KEY (SK_ID_PREV)
References previous_application(SK_ID_PREV);

---(Q4)Identify orphaned records
Select * from POS_CASH_balance P
Left join application_train a ON P.SK_ID_CURR = a.SK_ID_CURR
where a.SK_ID_CURR is NULL;

Select * from POS_CASH_balance P
Left join previous_application pr ON P.SK_ID_PREV = P.SK_ID_PREV
where Pr.SK_ID_PREV is NULL;


-- Delete Orphaned records
Delete from POS_CASH_balance
where SK_ID_CURR NOT IN(select SK_ID_CURR from application_train);

Delete from POS_CASH_balance
where SK_ID_PREV NOT IN(select SK_ID_PREV from previous_application);


--- Add foreign key Constraint
Alter Table POS_CASH_balance
Add constraint FK_POS_CASH_balance_application_train 
FOREIGN KEY (SK_ID_CURR)
References application_train(SK_ID_CURR);
Alter Table POS_CASH_balance
Add constraint  FK_POS_CASH_balance_previous_application
FOREIGN KEY (SK_ID_PREV)
References previous_application(SK_ID_PREV);

---(Q5)Identify orphaned records
Select * from credit_card_balance C
Left join application_train a ON C.SK_ID_CURR = a.SK_ID_CURR
where a.SK_ID_CURR is NULL;

Select * from credit_card_balance C
Left join previous_application p ON C.SK_ID_PREV = P.SK_ID_PREV
where P.SK_ID_PREV is NULL;


-- Delete Orphaned records
Delete from credit_card_balance
where SK_ID_CURR NOT IN(select SK_ID_CURR from application_train);

Delete from credit_card_balance
where SK_ID_PREV NOT IN(select SK_ID_PREV from previous_application);


--- Add foreign key Constraint
Alter Table credit_card_balance
Add constraint FK_credit_card_balance_application_train 
FOREIGN KEY (SK_ID_CURR)
References application_train(SK_ID_CURR);
Alter Table credit_card_balance
Add constraint  FK_credit_card_balance_previous_application
FOREIGN KEY (SK_ID_PREV)
References previous_application(SK_ID_PREV);

---(Q6)Identify orphaned records
Select * from bureau_balance B
Left join bureau bu ON B.SK_ID_BUREAU = bu.SK_ID_BUREAU
where bu.SK_ID_BUREAU is NULL;

-- Delete Orphaned records

Delete from bureau_balance
where SK_ID_BUREAU NOT IN(select SK_ID_BUREAU from bureau_balance);

--- Add foreign key Constraint
Alter Table bureau_balance
Add constraint FK_bureau_balance_bureau 
FOREIGN KEY (SK_ID_BUREAU)
References bureau(SK_ID_BUREAU);

