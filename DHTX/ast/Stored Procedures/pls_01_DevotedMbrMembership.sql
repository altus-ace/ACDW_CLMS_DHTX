

CREATE PROCEDURE [ast].[pls_01_DevotedMbrMembership] --- [ast].[pls_01_DevotedMbrMembership]'2021-10','2021-10-01',11
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
					DECLARE @RowStatus INT = 0
					--DECLARE @DataDate DATE = GETDATE() 
		BEGIN
		-- DECLARE @DataDate DATE = '2021-10-01' DECLARE @RowStatus INT = 0 DECLARE @ClientKey INT = 11
		IF OBJECT_ID('tempdb..#Prr') IS NOT NULL DROP TABLE #Prr
		CREATE TABLE #Prr(PrKey INT PRIMARY KEY IDENTITY(1,1),NPI VARCHAR(50),ClientNPI VARCHAR(50),AttribTIN VARCHAR(50),ClientTIN VARCHAR(50),MemberID VARCHAR(50))

		INSERT INTO #Prr(PrKey,NPI,ClientNPI,AttribTIN,ClientTIN,MemberID)
		EXECUTE [adi].[GetMbrNpiAndTin_DHTX]@DataDate, @RowStatus,@ClientKey
					
		END
		--- DECLARE @EffectiveMonth VARCHAR(10) = '2021-10' DECLARE @DataDate DATE = '2021-10-01' DECLARE @ClIENTkEY INT = 11
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
						,m.[MemberID]
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
						, (SELECT LobName
							FROM	lst.list_client
							WHERE	ClientKey = @ClientKey) LineOfBusiness
						,NPI
						,AttribTIN
						,lstpln.SourceValue
						,lstpln.TargetValue  AS plnProductPlan
						,lstSubPln.TargetValue AS plnProductSubPlanName
						,plnCsPln.TargetValue AS csPlnProductSubPlanName
						,ROW_NUMBER() OVER(PARTITION BY m.[MemberID],NewThisMonth,EffectiveMonth,[PlanName] 
											,[CMSContractPBP] ORDER BY EffectiveMonth DESC )RwCnt, Status ---  SELECT TOP 2 *
		FROM			[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly] m	
		LEFT JOIN		(SELECT	ClientKey, TargetSystem
								,SourceValue, TargetValue
								,ACTIVE
							FROM	lst.lstPlanMapping
							WHERE	ClientKey = 11
							AND	   ACTIVE = 'Y'
							AND		TargetSystem = 'ACDW_PLAN') lstPln /*Captures for PlanName*/
		ON				m.[CMSContractPBP] = lstPln.SourceValue 
		LEFT JOIN		(SELECT	ClientKey, TargetSystem
								,SourceValue, TargetValue
								,ACTIVE
							FROM	lst.lstPlanMapping
							WHERE	ClientKey = 11
							AND	   ACTIVE = 'Y'
							AND		TargetSystem = 'ACDW_SubPlan') lstSubPln /*Captures for SubGrpPlanName*/
		ON				m.[CMSContractPBP] = lstPln.SourceValue 
		LEFT JOIN		(SELECT	ClientKey, TargetSystem
								,SourceValue, TargetValue
								,ACTIVE
							FROM	lst.lstPlanMapping
							WHERE	ClientKey = 11
							AND	   ACTIVE = 'Y'
							AND		TargetSystem = 'CS_AHS') plnCsPln /*Captures for CsPlanName*/
		ON				m.[CMSContractPBP] = lstPln.SourceValue 
		LEFT JOIN       (		SELECT	NPI,s.AttribTIN
									,MemberID
									 FROM	#Prr s
							) pr
		ON				m.PcpNpi = pr.NPI
		AND				m.MemberID = pr.MemberID
		WHERE			Status = 0 
		AND				DataDate = @DataDate
		AND				NewThisMonth IN (	SELECT	Source
											FROM	lst.ListAceMapping
											WHERE	ClientKey = @ClientKey
											AND		Destination = 'NewThisMonth'
										) 
		AND				EffectiveMonth = @EffectiveMonth
		--AND				MemberDeathDate IS NULL
		--AND				EnrollmentEndDate IS NULL

						)drv
	    WHERE			RwCnt =1
		--  SELECT plnProductSubPlanName,PCPNPI,MEMBERID,* FROM #Devoted WHERE npi IS NULL 
						
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
						,[LOB]
						,[plnProductPlan]
						,[plnProductSubPlan]
						,[plnProductSubPlanName]
						,[CsplnProductSubPlanName]
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
						,MbrCity
						,EffectiveDate
						,srcNPI
						,srcPln
						) -- Declare @datadate date = '2020-09-06'
		OUTPUT			inserted.mbrStg2_MbrDataUrn INTO #OutputTbl(ID)
		SELECT			DISTINCT	    --1 Member / pcp select 
						src.[MemberID]											   AS [ClientSubscriberId]
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
						,NPI														AS [prvNPI]
						,AttribTIN													AS [prvTIN]
						,''															AS [prvAutoAssign]
						,PCPStartDate												AS [prvClientEffective]   
						,PCPEndDate													AS [prvClientExpiration]
						,LineOfBusiness												AS LOB
						,plnProductPlan												AS [plnProductPlan]
						,''															AS [plnProductSubPlan]
						,plnProductSubPlanName										AS [plnProductSubPlanName]
						,csPlnProductSubPlanName									AS [CsplnProductSubPlanName]
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
						,@DataDate													AS [EffectiveDate] 
						, PcpNpi													AS srcNPI
						, CMSContractPBP											AS srcPln --  select distinct src.MemberID,vw.MemberID,npi,pcpnpi,pcptin,attribtin
		FROM			#Devoted src 
				

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
						src.MemberID													AS [ClientMemberKey]
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
		

		--Invalidate records without NPI

		/*Update stgRowStatus for Validity in NPI and Plans*/

		BEGIN
		UPDATE	ACECAREDW.[ast].[MbrStg2_MbrData]	
		SET		stgRowStatus = (CASE WHEN  prvNPI IS NULL THEN 'Not Valid' 
									 WHEN plnProductPlan IS NULL THEN 'Not Valid'
									 ELSE 'Valid'
								END)
		WHERE	ClientKey = 11
		AND			DataDate = (SELECT  MAX(DataDate)
								FROM	ACECAREDW.ast.MbrStg2_MbrData
								WHERE	ClientKey = 11
									)
		END

		/*Update stgRowStatus in Mbr Address/Email/Phone Table*/ 
		BEGIN
		UPDATE		ACECAREDW.[ast].[MbrStg2_PhoneAddEmail]
		SET			stgRowStatus = m.stgRowStatus --- select m.AdiKey,ad.AdiKey, *
		FROM		ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] ad
		JOIN		(SELECT  MAX(DataDate) DataDate
										,AdiKey,stgRowStatus
								FROM	ACECAREDW.ast.MbrStg2_MbrData
								WHERE	ClientKey = 11
								AND		DataDate = @DataDate-- '2021-06-01'
								AND		stgRowStatus  = 'Not Valid' 
								GROUP BY AdiKey,stgRowStatus
									)m
		ON		   ad.AdiKey = m.AdiKey
		WHERE	   ad.DataDate = @DataDate --'2021-06-01'
		
		END



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

SELECT MstrMrnKey,stgRowStatus,* FROM ACECAREDW.[ast].[MbrStg2_MbrData]	
WHERE ClientKey = 11 AND loaddate = (SELECT MAX(LoadDate) FROM ACECAREDW.[ast].[MbrStg2_MbrData] WHERE ClientKey = 11)

SELECT * FROM ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] 
WHERE ClientKey = 11 and loaddate = (SELECT MAX(LoadDate) FROM ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] WHERE ClientKey = 11) 

*/




		