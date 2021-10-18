

CREATE PROCEDURE [ast].[z_stg_01_DevotedMbrMemberLoad]
							(@DataDate Date)

AS

BEGIN
BEGIN TRAN
BEGIN TRY


BEGIN
		
		IF OBJECT_ID('tempdb..#Devoted') IS NOT NULL DROP TABLE #Devoted
		SELECT			* 
		INTO			#Devoted
		FROM			(
		SELECT			DISTINCT [Devoted_Member_ID],[Member_First_Name], [Member_Last_Name], [Member_Date_Of_Birth]
						,[Member_Gender], [MBI_or_HICN]
						,ROW_NUMBER() OVER(PARTITION BY [Devoted_Member_ID],[Member_First_Name], [Member_Last_Name]
						,			  [Member_Date_Of_Birth],[Member_Gender], [CMS_Contract_PBP]
									  ORDER BY [PCP_Effective_Date] DESC
						) RwCnt
						, [Member_HICNs], [CMS_Contract_PBP]
						, [Member_Dual_Eligible_Flag], [Practice_Name], [Devoted_PCP_ID], [PCP_Name]
						, [Coverage_Effective_Date], [Coverage_End_Date],[PCP_Effective_Date], [PCP_End_Date]--1XP5AP6ER53
						,[Member_Status]
						,Member_Language,SrcFileName,MembershipEnrollmentKey,FileDate
						, [CreateDate], [DataDate], [PCP_NPI], [Plan_Name]
						,Member_Phone,Member_Address_Line_1,Member_Address_Line_2
						,Member_City
						,Member_State
						,Member_Zip
						,Member_County
		FROM			[ACDW_CLMS_DHTX].[adi].[DHTX_MembershipEnrollment]	
		WHERE			DataDate = @DataDate --'2020-09-06' --
		AND				Coverage_Effective_Date <= CONVERT(DATE,GETDATE()) --eliminates future enrollment
		AND				(Coverage_End_Date IS NULL OR  Coverage_End_Date >= CONVERT(DATE,GETDATE()) )  --where a column has a value than null
						)drv
	    WHERE			RwCnt =1

		
END

BEGIN		
		--Load Members Demos
		INSERT INTO		ACECAREDW.[ast].[MbrStg2_MbrData]					
						(	[ClientSubscriberId] 
						,[ClientKey]																				
						,[MstrMrnKey]		
						,[mbrLastName]
						,[mbrFirstName]
						,[mbrGENDER]
						,[mbrDob]
						,[HICN]
						,[MBI]
						,[mbrPrimaryLanguage]
						,[prvNPI]
						,[prvTIN]
						,[prvAutoAssign]
						,[prvClientEffective]
						,[prvClientExpiration]
						,[plnProductPlan]
						,[plnProductSubPlan]
						,[plnProductSubPlanName]
						,[plnMbrIsDualCoverage]
						,[Member_Dual_Eligible_Flag] 
						,[plnClientPlanEffective]
						,[SrcFileName]
						,[AdiTableName]
						,[AdiKey]
						,[stgRowStatus]
						,[LoadDate]
						,[DataDate]
						,[plnClientPlanEndDate]
						,[MbrState]) -- Declare @datadate date = '2020-09-06'
		SELECT			DISTINCT	    --1 Member / pcp select 
						[Devoted_Member_ID]
						,(SELECT ClientKey FROM [AceMasterData].[lst].[List_Client] WHERE ClientShortName = 'DHTX')
						,000
						,[Member_Last_Name]
						,[Member_First_Name]
						,[Member_Gender]
						,[Member_Date_Of_Birth]
						,[Member_HICNs]
						,[MBI_or_HICN]
						,[Member_Language]
						,[PCP_NPI]
						,''
						,''
						,[PCP_Effective_Date]
						,[PCP_End_Date]
						,'Medicare Adv (MA)' 
						,[CMS_Contract_PBP] 
						,[Plan_Name]
						,0
						,[Member_Dual_Eligible_Flag]
						,[Coverage_Effective_Date]
						,[SrcFileName]
						,'ACDW_CLMS_DHTX.adi.DHTX_MembershipEnrollment'
						,[MembershipEnrollmentKey]
						,'Valid'		
						,FileDate
						,src.DataDate	 
						,[Coverage_End_Date]
						,Member_State
		FROM			#Devoted src
		JOIN			[ACECAREDW].adw.fctProviderRoster vw--[ACECAREDW].[dbo].[vw_AllClient_ProviderRoster] vw 
		ON				src.PCP_NPI = vw.NPI
		WHERE			HealthPlan = 'DEVOTED' 
		--AND				@DataDate BETWEEN RowEffectiveDate AND RowExpirationDate
		ORDER BY		Devoted_Member_ID

END

BEGIN
				--Load Members Email, addresses and Phone

		INSERT INTO		ACECAREDW.[ast].[MbrStg2_PhoneAddEmail]
						(							 
						[ClientMemberKey]
						,[SrcFileName]
						,[LoadType]
						,[LoadDate]
						,[DataDate]
						,[AdiTableName]
						,[AdiKey]
						,[lstPhoneTypeKey]
						,[PhoneNumber]
						,[PhoneCarrierType]
						,[PhoneIsPrimary]
						,[lstAddressTypeKey] --RETRIEVE VALUES FROM SELECT * FROM lst.lstAddressType
						,[AddAddress1]
						,[AddAddress2]
						,[AddCity]
						,[AddState]
						,[AddZip]
						,[AddCounty]
						,[lstEmailTypeKey]
						,[EmailAddress]
						,[EmailIsPrimary]
						,[stgRowStatus]
						,[ClientKey]
						,[AddState])--  DECLARE @DATE DATE = GETDATE()
		SELECT			DISTINCT																
						Devoted_Member_ID
						,SrcFileName
						,'P'
						,FileDate
						,src.DataDate
						,'ACDW_CLMS_DHTX.adi.DHTX_MembershipEnrollment'
						,MembershipEnrollmentKey
						,1
						,Member_Phone
						,NULL
						,NULL
						,1		
						,Member_Address_Line_1
						,Member_Address_Line_2
						,Member_City
						,Member_State
						,Member_Zip
						,Member_County
						,0
						,''
						,0
						,'Valid'
						,(SELECT ClientKey FROM [AceMasterData].[lst].[List_Client] WHERE ClientShortName = 'DHTX')
						,Member_State
		FROM			#Devoted src
		JOIN			[ACECAREDW].adw.fctProviderRoster vw--[ACECAREDW].[dbo].[vw_AllClient_ProviderRoster] vw 
		ON				src.PCP_NPI = vw.NPI
		WHERE			HealthPlan = 'DEVOTED' 
		--AND				@DATE BETWEEN RowEffectiveDate AND RowExpirationDate
		ORDER BY		Devoted_Member_ID
END


COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH

END



/*
select * from ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] 
where ClientKey = 11 and loaddate = (select MAX(LoadDate) from ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] where ClientKey = 11) 

select * from ACECAREDW.[ast].[MbrStg2_MbrData]	
where ClientKey = 11 and loaddate = (select MAX(LoadDate) from ACECAREDW.[ast].[MbrStg2_MbrData] where ClientKey = 11)
*/


