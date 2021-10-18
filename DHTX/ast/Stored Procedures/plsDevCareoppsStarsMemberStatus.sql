
CREATE PROCEDURE [ast].[plsDevCareoppsStarsMemberStatus](
					@QMDATE DATE
					,@ClientKey INT
					,@DataDate DATE)  
AS


	BEGIN
	BEGIN TRY
	BEGIN TRAN
					
	IF OBJECT_ID('tempdb..#DevCareOpps') IS NOT NULL DROP TABLE #DevCareOpps
	

	CREATE TABLE  #DevCareOpps  ([pstQM_ResultByMbr_HistoryKey] [int] IDENTITY(1,1) NOT NULL,[astRowStatus] [varchar](20) DEFAULT'P' NOT NULL,
								[srcFileName] [varchar](150) NULL,
								[adiTableName] [varchar](100) NOT NULL,	[adiKey] [int] NOT NULL,[LoadDate] [date] NOT NULL,	
								[CreateDate] [datetime] NOT NULL,
								[CreateBy] [varchar](50) NOT NULL,[ClientKey] [int] NULL,[ClientMemberKey] [varchar](50) NOT NULL
								,Category [Varchar] (50),[MemberStatus][Varchar] (50) 
								,[QmMsrId] [varchar](20) NOT NULL,[QmCntCat] [varchar](10) NOT NULL,[QMDate] [date] NULL
								, srcQMID VARCHAR(50))

			/*Unpivoting Columns and creating dataset from 
				ACDW_CLMS_DHTX.[adi].[DHTX_QualityReports]*/
	BEGIN										
						IF OBJECT_ID('tempdb..#Pvt') IS NOT NULL DROP TABLE #Pvt
											--  DECLARE @QMDATE DATE = '2021-09-15' DECLARE @DataDate DATE = '2021-09-06'
						SELECT		[astRowStatus],[srcFileName],AdiTableName,StarsMemberStatusKey,LoadDate,[CreateDate],[CreateBy]
									,ClientKey,PatientID,Measures,MeasureCategory
									,'' AS [QmMsrId]
									,[QmCntCat]
									,QMDATE
									,ROW_NUMBER() OVER(PARTITION BY PatientID, Measures ORDER BY DataDate DESC)RwCnt
									,DataDate 
									,Measures AS srcQMID
									INTO #Pvt
						FROM		(	
										SELECT	DISTINCT 'P' AS [astRowStatus],[srcFileName]
												,'[adi].[DHTX_StarsMemberStatus]' AdiTableName--A replacement for the old table '[adi].[DHTX_QualityReports]'
												,StarsMemberStatusKey,Getdate() LoadDate,Getdate()  [CreateDate]
												,SUSER_NAME()[CreateBy]
												,(SELECT ClientKey 
													FROM lst.list_client 
													WHERE ClientShortName = 'DHTX')  ClientKey
												,PatientID
												,Measures
												,MeasureCategory
												,'' [QmCntCat]
												, DataDate 
												, @QMDATE AS  QMDATE --  #QMDATE
										FROM 
												(
													SELECT	[srcFileName],StarsMemberStatusKey,DataDate,[CreateDate]
														   ,SUSER_NAME()[CreateBy],[PatientID],[DiabetesRetinalScreen]
														   , [DiabetesKidneyMonitoring], [DiabetesHba1cControl]
															,[DiabetesStatinUse]--, [RheumatoidArthritisManagement] Termed
														   , [ControllingBloodPressure],[ControllingBPReason]
														   ,[ColorectalCancerScreening],[CardiovascularStatinUse]
													FROM	ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus] -- A replacement for the new table
													WHERE	Status =   0 
													AND		DataDate = @DataDate
												) AS cols
										UNPIVOT
														(
															MeasureCategory FOR Measures IN ( [DiabetesRetinalScreen], [DiabetesKidneyMonitoring], [DiabetesHba1cControl]
																,[DiabetesStatinUse], /*[RheumatoidArthritisManagement]*/ [ControllingBloodPressure],[ControllingBPReason]
																,[ColorectalCancerScreening],[CardiovascularStatinUse])
														) AS up	
										WHERE			 MeasureCategory <> 'N/A'
										AND				 MeasureCategory NOT IN ('IN CONTROL','OUT OF CONTROL','') 
									)a 
	END
	-- SELECT * FROM #Pvt
	--SELECT * FROM #DevCareOpps where QmMsrId is null
	BEGIN
		/*Matching with all list tables for expected outcome*/
	INSERT INTO		#DevCareOpps(
					[astRowStatus]
					, [srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [Category]
					, [MemberStatus]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate]
					,srcQMID
					)

	SELECT			adi.[astRowStatus]
					,adi.[srcFileName]
					,adi.[AdiTableName]
					,adi.[StarsMemberStatusKey]
					,adi.[LoadDate]
					,adi.[CreateDate]
					,adi.[CreateBy]
					,adi.[ClientKey]
					,adi.[PatientID]				AS ClientMemberKey
					,adi.[Measures]					AS [Category]
					--,ace.[Source]
					,adi.[MeasureCategory]			AS [MemberStatus]
					,qm.[MeasureID] AS [QmMsrId]
					--,ace.[Destination]
					,'DEN' AS [QmCntCat]
					,adi.[QMDATE]
					,ace.Destination
					--,ROW_NUMBER()OVER(PARTITION BY [PatientID],[Measures],[MeasureCategory] ORDER BY QMDATE DESC)RwCnt
	FROM			#Pvt adi
				/*Matching records to retrieve candidate rows*/
	LEFT JOIN			(SELECT Source,Destination
						FROM lst.ListAceMapping
						WHERE	ClientKey = 11
						AND  IsActive = 1
						AND MappingTypeKey = 14) ace
	ON				adi.Measures = ace.Source
				/*Matching records against careop to plan to retrieve contracted measures*/
	LEFT JOIN			(SELECT DISTINCT MeasureID,MeasureDesc
						FROM lst.lstCareOpToPlan
						WHERE ClientKey = 11
						AND ACTIVE = 'Y'
						AND GETDATE() BETWEEN EffectiveDate AND ExpirationDate
					)qm
	ON				ace.Destination=qm.MeasureID
				/*Matching against active Members*/
	LEFT JOIN		 (SELECT CLIENT_SUBSCRIBER_ID,ClientKey 
					FROM ACECAREDW.dbo.vw_ActiveMembers
					WHERE clientKey = 11
					) vw
	ON				 adi.PatientID = vw.CLIENT_SUBSCRIBER_ID
	WHERE		   RwCnt = 1

	END			
	
	
	-- Create your Num and COP for quality.  select distinct memberstatus from #DevCareOpps
	BEGIN

	INSERT INTO		#DevCareOpps(
					[astRowStatus]
					, [srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					, [CreateBy]
					,[ClientKey]
					, [ClientMemberKey]
					,[Category]
					,[MemberStatus]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate]
					,srcQMID)
	SELECT			'P'
					,[srcFileName]
					,'[adi].[DHTX_StarsMemberStatus]'
					,[adiKey]
					,Getdate()
					,[CreateDate]
					,SUSER_NAME()[CreateBy]
					,11
					,ClientMemberKey
					, Category
					,MemberStatus
					,[QmMsrId]
					,CASE WHEN MemberStatus IN ('Closed Gap','Closed Gap - Official','Closed Gap - Display','') THEN 'NUM'
						WHEN MemberStatus IN ('Open Gap','NEED BP VALUE','Open Gap - Official','Open Gap - Display') THEN 'COP'  
						WHEN Category IN ('ControllingBloodPressure', 'ControllingBPReason') AND MemberStatus IN ('Open Gap','NEED BP VALUE') THEN 'Hypertension Management'
						ELSE 'Ukn'
						END QmCntCat
					,QMDate
					,srcQMID
	FROM			#DevCareOpps
	WHERE			adiTableName = '[adi].[DHTX_StarsMemberStatus]'	
	
	END

	-- Insert into staging

	BEGIN

	INSERT INTO		[ACECAREDW].[ast].[QM_ResultByMember_History](
					[astRowStatus]
					, [srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate]
					, srcQMID)
	
	SELECT			'Loaded'
					,[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					,[CreateBy]
					,[ClientKey]
					, [ClientMemberKey]
					,[QmMsrId]
					, [QmCntCat]
					, [QMDate]
					, srcQMID
	FROM			#DevCareOpps
	
	END

	--Validation
	SELECT			COUNT(*)
					,[QmMsrId]
					,[QmCntCat]
	FROM			#DevCareOpps
	WHERE			adiTableName = '[adi].[DHTX_StarsMemberStatus]'
	GROUP BY		[QmMsrId]
					,[QmCntCat]
	ORDER BY		[QmMsrId]
					,[QmCntCat]

	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END

	-- EXECUTE [ast].[plsDevCareoppsStarsMemberStatus]'2021-09-15',11,'2021-09-06'

	/*
	SELECT		COUNT(*), DataDate,Status 
	FROM		ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus]
	GROUP BY	DataDate,Status 
	ORDER BY	DataDate DESC
	*/
	
