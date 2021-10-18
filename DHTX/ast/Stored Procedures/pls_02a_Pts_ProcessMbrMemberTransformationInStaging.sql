

CREATE PROCEDURE [ast].[pls_02a_Pts_ProcessMbrMemberTransformationInStaging]-- '2021-09-01','2021-09-01' ROLLBACK
							(@MbrShipDataDate  DATE
							,@EffectiveDate DATE)

AS

BEGIN
BEGIN TRAN
BEGIN TRY
						DECLARE @AuditId INT;    
						DECLARE @JobStatus tinyInt = 1    
						DECLARE @JobType SmallInt = 9	  
						DECLARE @ClientKey INT	 = 22; 
						DECLARE @JobName VARCHAR(100) = 'Devoted_MbrMember';
						DECLARE @ActionStart DATETIME2 = GETDATE();
						DECLARE @SrcName VARCHAR(100) = 'adi.DHTX_EligibilityMonthly'
						DECLARE @DestName VARCHAR(100) = ''
						DECLARE @ErrorName VARCHAR(100) = 'NA';
						DECLARE @InpCnt INT = -1;
						DECLARE @OutCnt INT = -1;
						DECLARE @ErrCnt INT = -1;
	SELECT				@InpCnt = COUNT(m.EligibilityMonthlyKey)     --- select top 2 EffectiveMonth, *
	FROM				adi.DHTX_EligibilityMonthly  m
	WHERE				DataDate = @MbrShipDataDate 
	AND					m.DataDate = @MbrShipDataDate
	
	SELECT				@InpCnt, @MbrShipDataDate
	
	
	EXEC				amd.sp_AceEtlAudit_Open 
						@AuditID = @AuditID OUTPUT
						, @AuditStatus = @JobStatus
						, @JobType = @JobType
						, @ClientKey = @ClientKey
						, @JobName = @JobName
						, @ActionStartTime = @ActionStart
						, @InputSourceName = @SrcName
						, @DestinationName = @DestName
						, @ErrorName = @ErrorName
						;

		BEGIN			--- More unidentified biz rules to be built here
					---- DECLARE @EffectiveDate DATE = '2021-04-01'
					--Update MbrNPIFlg
					UPDATE ACECAREDW.ast.MbrStg2_MbrData
					SET MbrNPIFlg = (CASE WHEN prvNPI IS NULL THEN 0 ELSE 1 END)
					WHERE	EffectiveDate =  @EffectiveDate
					AND		DataDate =  @MbrShipDataDate
					AND		ClientKey = 11 
					AND		EffectiveDate = (SELECT MAX(EffectiveDate)
											  FROM ACECAREDW.ast.MbrStg2_MbrData 
												WHERE ClientKey = 11)

					--Update MbrPlnFlg
					UPDATE ACECAREDW.ast.MbrStg2_MbrData
					SET MbrPlnFlg = (CASE WHEN plnProductSubPlanName IS NULL THEN 0 ELSE 1 END)
					WHERE	EffectiveDate =  @EffectiveDate
					AND		DataDate =  @MbrShipDataDate
					AND		ClientKey = 11 
					AND		EffectiveDate = (SELECT MAX(EffectiveDate) 
												FROM ACECAREDW.ast.MbrStg2_MbrData 
													WHERE ClientKey = 11)
					
					--Update MbrFlgCount
					UPDATE ACECAREDW.ast.MbrStg2_MbrData
					SET MbrFlgCount = OutputResult  --- Select OutputResult,MbrFlgCount,*
					FROM	ACECAREDW.ast.MbrStg2_MbrData trg
					JOIN 	(SELECT CASE WHEN MbrCount >1 
										THEN MbrCount ELSE 1 END OutputResult
										,ClientSubscriberId
											FROM (
												SELECT	 COUNT(*) MbrCount
														,ClientSubscriberId
												FROM	 ACECAREDW.ast.MbrStg2_MbrData
												GROUP BY ClientSubscriberId
												)cnt
										)src
					ON		trg.ClientSubscriberId = src.ClientSubscriberId
					WHERE	ClientKey = 11 
					AND		EffectiveDate = (SELECT MAX(EffectiveDate) 
												FROM ACECAREDW.ast.MbrStg2_MbrData 
													WHERE ClientKey = 11)
					

					--Count for Npi
					SELECT	COUNT(*)
					FROM	ACECAREDW.[ast].[MbrStg2_MbrData]	-- 
					WHERE	DataDate = @MbrShipDataDate
					AND		EffectiveDate =  @EffectiveDate
					AND		MbrNPIFlg = 1
					AND		ClientKey = 11
					AND		EffectiveDate = (SELECT MAX(EffectiveDate) 
												FROM ACECAREDW.ast.MbrStg2_MbrData 
													WHERE ClientKey = 11)
						
					--Count for Pln
					SELECT	COUNT(*)
					FROM	ACECAREDW.[ast].[MbrStg2_MbrData]	-- 
					WHERE	DataDate =  @MbrShipDataDate
					AND		EffectiveDate =  @EffectiveDate
					AND		MbrPlnFlg = 1
					AND		ClientKey = 11
					AND		EffectiveDate = (SELECT MAX(EffectiveDate) 
												FROM ACECAREDW.ast.MbrStg2_MbrData 
													WHERE ClientKey = 11)

					--Summary
					SELECT	COUNT(*)RecCnt, stgRowStatus
							,MbrFlgCount,MbrNPIFlg,MbrPlnFlg
							,DataDate,EffectiveDate
					FROM	ACECAREDW.ast.MbrStg2_MbrData 
					WHERE	ClientKey = 11
					AND		EffectiveDate = (SELECT MAX(EffectiveDate) 
												FROM ACECAREDW.ast.MbrStg2_MbrData 
													WHERE ClientKey = 11)
					GROUP BY stgRowStatus
							 ,MbrFlgCount,MbrNPIFlg,MbrPlnFlg
							 ,DataDate,EffectiveDate
					ORDER BY DataDate DESC

	


		SET					@ActionStart  = GETDATE();
		SET					@JobStatus =2  
	    				
		EXEC				amd.sp_AceEtlAudit_Close 
							@Audit_Id = @AuditID
							, @ActionStopTime = @ActionStart
							, @SourceCount = @InpCnt		  
							, @DestinationCount = @OutCnt
							, @ErrorCount = @ErrCnt
							, @JobStatus = @JobStatus

		END			
		
COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH

END

