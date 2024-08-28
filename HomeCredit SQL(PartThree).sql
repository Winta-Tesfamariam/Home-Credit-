create view HomeCreditView
as
select a.NAME_CONTRACT_TYPE
,CODE_GENDER
,FLAG_OWN_CAR
,FLAG_OWN_REALTY
,CNT_CHILDREN
,AMT_INCOME_TOTAL
,a.AMT_CREDIT
,a.AMT_ANNUITY
,NAME_INCOME_TYPE
,NAME_EDUCATION_TYPE
,NAME_FAMILY_STATUS,CREDIT_ACTIVE
,AMT_CREDIT_SUM
,CREDIT_TYPE
,p.NAME_CONTRACT_STATUS
,AMT_CREDIT_LIMIT_ACTUAL
,AMT_BALANCE
,AMT_PAYMENT_CURRENT

from [dbo].[application_train] a
join [dbo].[bureau] b ON a.SK_ID_CURR =b.SK_ID_CURR
join [dbo].[previous_application] p ON a.SK_ID_CURR =p.SK_ID_CURR
join [dbo].[POS_CASH_balance] pc ON a.SK_ID_CURR =pc.SK_ID_CURR
join [dbo].[credit_card_balance] cb ON a.SK_ID_CURR =cb.SK_ID_CURR
