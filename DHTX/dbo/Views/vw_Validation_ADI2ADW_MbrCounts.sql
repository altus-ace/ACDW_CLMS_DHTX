

-----------------------------
/****COmpare the count of mbrs from ADI to ADW 

Use data date as 6th of the month.
Use Getdate() today <= the PCP, Mbr coverage effecitive dates
Use Getdate() today >= PCP, Mbr coverage End dates

*****/
CREATE VIEW [dbo].[vw_Validation_ADI2ADW_MbrCounts]
AS
SELECT DISTINCT 
       Devoted_Member_ID
       --PCP_NPI, 
       --PCP_Effective_Date, 
       --PCP_End_Date, 
       --Coverage_Effective_Date, 
       --Coverage_End_Date
FROM ACDW_CLMS_DHTX.[adi].[DHTX_MembershipEnrollment] a
     JOIN acecaredw.dbo.vw_AllClient_ProviderRoster b ON b.npi = a.PCP_NPI and HealthPlan = 'Devoted'
WHERE a.datadate = DATEADD(DAY, 5, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
and ISNULL(Coverage_End_Date,'12/31/2099') >= GETDATE()
and ISNULL(PCP_End_Date,'12/31/2099') >= GETDATE()
and ISNULL(ExpirationDate,'12/31/2099') >= GETDATE()
and Coverage_Effective_Date <= GETDATE()
and PCP_Effective_Date <= GETDATE()

