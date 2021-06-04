
CREATE PROCEDURE [ast].[plsDevCareoppsStarsMemberStatus](
					@QMDATE DATE
					,@ClientKey INT
					,@DataDate DATE)  
AS


	BEGIN
	BEGIN TRY
	BEGIN TRAN
					--  DECLARE @QMDATE DATE = '2021-01-06'
	IF OBJECT_ID('tempdb..#DevCareOpps') IS NOT NULL DROP TABLE #DevCareOpps
	

	CREATE TABLE  #DevCareOpps  ([pstQM_ResultByMbr_HistoryKey] [int] IDENTITY(1,1) NOT NULL,[astRowStatus] [varchar](20) DEFAULT'P' NOT NULL,
								[srcFileName] [varchar](150) NULL,
								[adiTableName] [varchar](100) NOT NULL,	[adiKey] [int] NOT NULL,[LoadDate] [date] NOT NULL,	
								[CreateDate] [datetime] NOT NULL,
								[CreateBy] [varchar](50) NOT NULL,[ClientKey] [int] NOT NULL,[ClientMemberKey] [varchar](50) NOT NULL
								,Category [Varchar] (50),[MemberStatus][Varchar] (50) 
								,[QmMsrId] [varchar](20) NOT NULL,[QmCntCat] [varchar](10) NOT NULL,[QMDate] [date] NULL)

--Unpivoting Columns and creating dataset from ACDW_CLMS_DHTX.[adi].[DHTX_QualityReports]
	BEGIN
	
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
					, [QMDate])

	SELECT			[astRowStatus]
					,[srcFileName]
					,[AdiTableName]
					,[StarsMemberStatusKey]
					,[LoadDate]
					,[CreateDate]
					,[CreateBy]
					,@ClientKey
					,[PatientID]				AS ClientMemberKey
					,[Measures]					AS [Category]
					,[MeasureCategory]			AS [MemberStatus]
					,[QmMsrId]
					,[QmCntCat]
					,@QMDATE					AS QMDATE
	FROM			(

						SELECT		[astRowStatus],[srcFileName],AdiTableName,StarsMemberStatusKey,LoadDate,[CreateDate],[CreateBy]
									,ClientKey,PatientID,Measures,MeasureCategory,[QmMsrId]
									,[QmCntCat]
									,@QMDATE AS QMDATE
									,ROW_NUMBER() OVER(PARTITION BY PatientID, Measures ORDER BY DataDate DESC)RwCnt
									,DataDate
						FROM		(	
											SELECT	DISTINCT 'P' AS [astRowStatus],[srcFileName]
													,'[adi].[DHTX_StarsMemberStatus]' AdiTableName--A replacement for the old table '[adi].[DHTX_QualityReports]'
													,StarsMemberStatusKey,Getdate() LoadDate,Getdate()  [CreateDate]
													,SUSER_NAME()[CreateBy]
													,(SELECT ClientKey FROM lst.list_client WHERE ClientShortName = 'DHTX')  ClientKey
													,PatientID,Measures,MeasureCategory
													,CASE	
													 WHEN Measures LIKE '%DiabetesRetina%' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC LIKE '%DiabetesRetina%' AND ClientKey = 11 AND ACTIVE = 'Y')
													 WHEN Measures ='DiabetesKidneyMonitoring' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='DiabetesKidneyMonitoring' AND ClientKey = 11 AND ACTIVE = 'Y')
													 WHEN Measures ='DiabetesHba1cControl' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='DiabetesHba1cControl' AND ClientKey = 11 AND ACTIVE = 'Y')
													 WHEN Measures ='DiabetesStatinUse' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='DiabetesStatinUse' AND ClientKey = 11 AND ACTIVE = 'Y')
													 --WHEN Measures ='RheumatoidArthritisManagement' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='RheumatoidArthritisManagement') Termed
													 WHEN Measures ='ControllingBloodPressure' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='ControllingBloodPressure' AND ClientKey = 11 AND ACTIVE = 'Y')
													 WHEN Measures ='ControllingBPReason' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='ControllingBPReason' AND ClientKey = 11 AND ACTIVE = 'Y')
													 WHEN Measures ='ColorectalCancerScreening' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='Colorectal Cancer Screening' AND ClientKey = 11 AND ACTIVE = 'Y')
													 WHEN Measures ='CardiovascularStatinUse' THEN (SELECT QM FROM lst.LIST_QM_Mapping WHERE QM_DESC ='SPC-Statins Therapy for Patients with CVD' AND ClientKey = 11 AND ACTIVE = 'Y')
													 END [QmMsrId]   
													,'DEN' [QmCntCat], DataDate
													--,@QMDATE QMDATE
											FROM 
													(
															 SELECT		[srcFileName],StarsMemberStatusKey,DataDate,[CreateDate]
																		,SUSER_NAME()[CreateBy],[PatientID],[DiabetesRetinalScreen]
																		, [DiabetesKidneyMonitoring], [DiabetesHba1cControl]
															 			,[DiabetesStatinUse]--, [RheumatoidArthritisManagement] Termed
																		, [ControllingBloodPressure],[ControllingBPReason]
																		,[ColorectalCancerScreening],[CardiovascularStatinUse]
															 FROM		ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus] -- A replacement for the new table
															 WHERE		Status =   0 
															 AND		DataDate = @DataDate
													) AS cols
											UNPIVOT
															(
																MeasureCategory FOR Measures IN ( [DiabetesRetinalScreen], [DiabetesKidneyMonitoring], [DiabetesHba1cControl]
																	,[DiabetesStatinUse], /*[RheumatoidArthritisManagement]*/ [ControllingBloodPressure],[ControllingBPReason]
																	,[ColorectalCancerScreening],[CardiovascularStatinUse])
															) AS up
											LEFT JOIN			ACECAREDW.dbo.vw_ActiveMembers vw
											ON					UP.PatientID = vw.CLIENT_SUBSCRIBER_ID
											WHERE				CLIENT_SUBSCRIBER_ID IS NOT NULL		
											AND					MeasureCategory <> 'N/A'
											AND					MeasureCategory NOT IN ('IN CONTROL','OUT OF CONTROL','')
									)a
				)z
	WHERE		RwCnt = 1

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
					, [QMDate])
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
					, [QMDate])
	
	SELECT			'Exported'
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

	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END

	-- EXECUTE [ast].[plsDevCareoppsStarsMemberStatus]'2021-03-06',11,'2021-03-15'

	/*
	SELECT		COUNT(*), DataDate,Status 
	FROM		ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus]
	GROUP BY	DataDate,Status 
	ORDER BY	DataDate DESC
	*/
	