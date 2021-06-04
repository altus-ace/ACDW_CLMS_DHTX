

CREATE PROCEDURE [ast].[pls_01_DevotedMbrMembership] ---[ast].[pls_01_DevotedMbrMembership]'2021-04','2021-04-01',11
							(@EffectiveMonth VARCHAR(10), @DataDate DATE,@ClientKey INT)

AS

BEGIN
BEGIN TRAN
BEGIN TRY


BEGIN
		

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey11 INT = @ClientKey; 
					DECLARE @JobName VARCHAR(100) = 'Dev_ProcessIntoStagingFromAdi';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = '[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]'
					DECLARE @DestName VARCHAR(100) = 'ACECAREDW.[ast].[MbrStg2_MbrData]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
		--- DECLARE @EffectiveMonth VARCHAR(10) = '2021-03' DECLARE @DataDate DATE = '2021-03-01'
		IF OBJECT_ID('tempdb..#Devoted') IS NOT NULL DROP TABLE #Devoted
		SELECT			*  --Get candidate rows for member month processing
		INTO			#Devoted
		FROM			(
		SELECT			DISTINCT 
						[EligibilityMonthlyKey]
						,[SrcFileName]
						,[FileDate]
						,[DataDate]
						,[EffectiveMonth]
						,[MemberID]
						,[MBI]
						,[adi].[udf_ConvertToCamelCase]([MemberFirstName]) [MemberFirstName]
						,[MemberMiddleInitial]
						,[adi].[udf_ConvertToCamelCase]([MemberLastName]) [MemberLastName]
						,[MemberDOB]
						,[adi].[udf_ConvertToCamelCase]([MemberAddressLine1]) [MemberAddressLine1]
						,[adi].[udf_ConvertToCamelCase]([MemberAddressLine2]) [MemberAddressLine2]
						,[adi].[udf_ConvertToCamelCase]([MemberCity]) [MemberCity]
						,[MemberState]
						,[MemberZip]
						,[adi].[udf_ConvertToCamelCase]([MemberCounty]) [MemberCounty]
						,[lst].[fnStripNonNumericChar]([MemberPhone]) [MemberPhone]
						,[lst].[fnStripNonNumericChar]([MemberMobilePhone]) [MemberMobilePhone]
						,[adi].[udf_ConvertToCamelCase]([MemberEmail]) [MemberEmail]
						,[adi].[udf_ConvertToCamelCase]([MemberLanguage]) [MemberLanguage]
						,[MemberGender]
						,[MemberDeathDate]
						,[adi].[udf_ConvertToCamelCase]([PlanName]) [PlanName]
						,[CMSContractPBP]
						,[DualEligibleStatus]
						,[MemberESRDIndicator]
						,[adi].[udf_ConvertToCamelCase]([PcpFirstName]) [PcpFirstName]
						,[adi].[udf_ConvertToCamelCase]([PcpLastName])[PcpLastName]
						,[PcpNpi]
						,[DevotedPCPID]
						,[adi].[udf_ConvertToCamelCase]([PcpPracticeName])[PcpPracticeName]
						,REPLACE(PcpTIN,'-','') [PcpTIN]
						,[adi].[udf_ConvertToCamelCase]([PcpTINName]) [PcpTINName]
						,[adi].[udf_ConvertToCamelCase]([PcpAddressLine1]) [PcpAddressLine1]
						,[adi].[udf_ConvertToCamelCase]([PcpAddressLine2]) [PcpAddressLine2]
						,[adi].[udf_ConvertToCamelCase]([PcpCity]) [PcpCity]
						,[PcpState]
						,[adi].[udf_ConvertToCamelCase]([PcpCounty])[PcpCounty]
						,[PcpZipCode]
						,[PcpPhone]
						,[NewThisMonth] --MemberCurrentStatus
						,[MonthEndStatus]
						,CASE		WHEN MonthEndStatus IN (SELECT	Source
															FROM	lst.ListAceMapping
															WHERE	ClientKey = 11
															AND		Destination = 'MonthEndStatus'
															AND		Source <> ''
															) 
									THEN (SELECT EOMONTH(CONVERT(DATE,GETDATE()))) ELSE '2099-12-31'  
									END [plnClientPlanEndDate]
						,EnrollmentStartDate
						,EnrollmentEndDate
						,PCPStartDate
						,PCPEndDate
						,LineOfBusiness
						,ROW_NUMBER() OVER(PARTITION BY [MemberID],NewThisMonth,EffectiveMonth,[PlanName] 
											,[CMSContractPBP] ORDER BY EffectiveMonth DESC )RwCnt, Status
		FROM			[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly] a	
		WHERE			Status = 0 
		AND				DataDate = @DataDate
		AND				NewThisMonth IN (	SELECT	Source
											FROM	lst.ListAceMapping
											WHERE	ClientKey = 11
											AND		Destination = 'NewThisMonth'
										) 
		AND				EffectiveMonth = @EffectiveMonth
		AND				MemberDeathDate IS NULL
		AND				EnrollmentEndDate IS NULL

						)drv
	    WHERE			RwCnt =1

						
		/*				--Validation
						SELECT			MonthEndStatus,[NewThisMonth],[plnClientPlanEndDate],*
						FROM			#Devoted  a
						--WHERE			RwCnt > 1
						ORDER BY		a. [plnClientPlanEndDate]
						--AND				MonthEndStatus <> ''
		*/
						SELECT		@InpCnt = COUNT([EligibilityMonthlyKey])    
						FROM		#Devoted
						EXEC		amd.sp_AceEtlAudit_Open @AuditID = @AuditID OUTPUT
									, @AuditStatus = @JobStatus
									, @JobType = @JobType
									, @ClientKey = @ClientKey
									, @JobName = @JobName
									, @ActionStartTime = @ActionStart
									, @InputSourceName = @SrcName
									, @DestinationName = @DestName
									, @ErrorName = @ErrorName
									;
		 --- Update PCP EffectiveDate
		/* UPDATE			#Devoted
		 SET			prvClientEffective = EffectiveDate
		 FROM			#Devoted a
		 JOIN			(	SELECT MAX(DISTINCT EffectiveDate) EffectiveDate,NPI
							FROM [ACECAREDW].[dbo].[vw_AllClient_ProviderRoster]
							WHERE HealthPlan = 'DEVOTED'
							GROUP BY NPI
						)b
		ON				a.PcpNpi = b.NPI*/
			
END

BEGIN		
		--Load Members Demos
		CREATE TABLE		#OutputTbl (ID INT NOT NULL );
		INSERT INTO		ACECAREDW.[ast].[MbrStg2_MbrData]					
						([ClientSubscriberId] 
						,[ClientKey]																				
						,[MstrMrnKey]		
						,[mbrLastName]
						,[mbrFirstName]
						,[MbrMiddleName]
						,[mbrGENDER]
						,[mbrDob]
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
						,[MbrState]
						,[MemberStatus]
						,[MemberOriginalEffectiveDate]
						,MbrCity) -- Declare @datadate date = '2020-09-06'
		OUTPUT			inserted.mbrStg2_MbrDataUrn INTO #OutputTbl(ID)
		SELECT			DISTINCT	    --1 Member / pcp select 
						[MemberID]													AS [ClientSubscriberId]
						,(		SELECT	ClientKey 
								FROM	[AceMasterData].[lst].[List_Client] 
								WHERE	ClientShortName = 'DHTX'					
						 )															AS [ClientKey]
						,000														AS [MstrMrnKey]										
						,[MemberLastName]											AS [mbrLastName]
						,[MemberFirstName]											AS [mbrFirstName]
						,[MemberMiddleInitial]										AS [MbrMiddleName]
						,[MemberGender]												AS [mbrGENDER]
						,[MemberDOB]												AS [mbrDob]
						,[MBI]														AS [MBI]
						,[MemberLanguage]											AS [mbrPrimaryLanguage]
						,[PCPNPI]													AS [prvNPI]
						,[PcpTIN]													AS [prvTIN]
						,''															AS [prvAutoAssign]
						,PCPStartDate												AS [prvClientEffective]   
						,PCPEndDate													AS [prvClientExpiration]
						,LineOfBusiness												AS [plnProductPlan]
						,[CMSContractPBP]											AS [plnProductSubPlan]
						,[PlanName]													AS [plnProductSubPlanName]
						,0															AS [plnMbrIsDualCoverage]				
						,[DualEligibleStatus]										AS [Member_Dual_Eligible_Flag]
						,EnrollmentStartDate										AS [plnClientPlanEffective]
						,[SrcFileName]												AS [SrcFileName]
						,'[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]'			AS [AdiTableName]
						,[EligibilityMonthlyKey]									AS [AdiKey]
						,'Valid'													AS [stgRowStatus]
						,FileDate													AS [LoadDate]
						,src.DataDate												AS [DataDate]
						,[plnClientPlanEndDate]										AS [plnClientPlanEndDate] --Derived
						,MemberState												AS [MbrState]
						,NewThisMonth												AS [MemberStatus]
						,EnrollmentStartDate										AS [MemberOriginalEffectiveDate]
						,MemberCity													AS [MbrCity]
		FROM			#Devoted src
		JOIN			(SELECT		*
						FROM		(
									 SELECT	NPI,s.AttribTIN
									 		,s.NpiHpEffectiveDate
									 		,s.NpiHpExpirationDate
									 		,s.TinHPEffectiveDate
									 		,s.TinHPExpirationDate
									 		,ROW_NUMBER()OVER(PARTITION BY NPI ORDER BY RowEffectiveDate)RwCnt
									 FROM	[ACECAREDW].adw.tvf_AllClient_ProviderRoster_History(11,GETDATE()) s
									 WHERE	(@DataDate BETWEEN NpiHpEffectiveDate AND NpiHpExpirationDate
									 AND		@DataDate BETWEEN TinHPEffectiveDate AND TinHPExpirationDate)
									 AND		IsActive = 1
													
									) src
									WHERE		RwCnt = 1
						) vw  
		ON				src.PCPNPI = vw.NPI
		ORDER BY		MemberID

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
						,[ClientKey])--  DECLARE @DATE DATE = GETDATE()
		SELECT			DISTINCT																
						MemberID													AS [ClientMemberKey]
						,SrcFileName												AS [SrcFileName]
						,'P'														AS [LoadType]
						,FileDate													AS [LoadDate]
						,src.DataDate												AS [DataDate]
						,'[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]'			AS [AdiTableName]
						,[EligibilityMonthlyKey]									AS [AdiKey]
						,1															AS [lstPhoneTypeKey]
						,MemberPhone												AS [PhoneNumber]
						,NULL														AS [PhoneCarrierType]
						,NULL														AS [PhoneIsPrimary]
						,1															AS [lstAddressTypeKey]
						,MemberAddressLine1											AS [AddAddress1]
						,MemberAddressLine2											AS [AddAddress2]
						,MemberCity													AS [AddCity]
						,MemberState												AS [AddState]
						,MemberZip													AS [AddZip]
						,MemberCounty												AS [AddCounty]
						,0															AS [lstEmailTypeKey]
						,MemberEmail												AS [EmailAddress]
						,0															AS [EmailIsPrimary]
						,'Valid'													AS [stgRowStatus]
						,(	SELECT	ClientKey 
							FROM	[lst].[List_Client]
							WHERE	ClientShortName = 'DHTX'
						 )															AS [ClientKey]
		FROM			#Devoted src
		JOIN			(SELECT		*
						FROM		(
									 SELECT	NPI,s.AttribTIN
									 		,s.NpiHpEffectiveDate
									 		,s.NpiHpExpirationDate
									 		,s.TinHPEffectiveDate
									 		,s.TinHPExpirationDate
									 		,ROW_NUMBER()OVER(PARTITION BY NPI ORDER BY RowEffectiveDate)RwCnt
									 FROM	[ACECAREDW].adw.tvf_AllClient_ProviderRoster_History(11,GETDATE()) s
									 WHERE	(@DataDate BETWEEN NpiHpEffectiveDate AND NpiHpExpirationDate
									 AND		@DataDate BETWEEN TinHPEffectiveDate AND TinHPExpirationDate)
									 AND		IsActive = 1
													
									) src
									WHERE		RwCnt = 1
						)vw --[ACECAREDW].adw.fctProviderRoster vw--
		ON				src.PCPNPI = vw.NPI
		ORDER BY		MemberID


					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				amd.sp_AceEtlAudit_Close @Audit_Id = @AuditID
																, @ActionStopTime = @ActionStart
																, @SourceCount = @InpCnt
																, @DestinationCount = @OutCnt
																, @ErrorCount = @ErrCnt	
																, @JobStatus = @JobStatus


					DROP TABLE #Devoted
					DROP TABLE #OutputTbl
END


COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH

END



/*

SELECT MstrMrnKey,* FROM ACECAREDW.[ast].[MbrStg2_MbrData]	
WHERE ClientKey = 11 AND loaddate = (SELECT MAX(LoadDate) FROM ACECAREDW.[ast].[MbrStg2_MbrData] WHERE ClientKey = 11)

SELECT * FROM ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] 
WHERE ClientKey = 11 and loaddate = (SELECT MAX(LoadDate) FROM ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] WHERE ClientKey = 11) 

*/




		