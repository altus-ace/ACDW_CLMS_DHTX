
CREATE PROCEDURE [ast].[plsDevCareoppsStarsAdherenceQualityReports] (
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
								[CreateBy] [varchar](50) NOT NULL,[ClientKey] [int] NOT NULL,[ClientMemberKey] [varchar](50) NOT NULL
								,Category [Varchar] (50),[MemberStatus][Varchar] (50) 
								,[QmMsrId] [varchar](20) NOT NULL,[QmCntCat] [varchar](10) NOT NULL,[QMDate] [date] NULL)
			--Inserting NUM
	BEGIN   --- DECLARE @QMDATE DATE = '2021-01-06' DECLARE @ClientKey INT = 11
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
		
	SELECT		astRowStatus,SrcFileName,AdiTableName,AdiKey,LoadDate,CreatedDate
				,[CreateBy],@ClientKey,PatientID,Category,MemberStatus,QM
				,MemberStatusCompliance,[QMDate]
	FROM		(
	SELECT		astRowStatus,SrcFileName,AdiTableName,AdiKey,LoadDate,CreatedDate
						,[CreateBy],ClientKey,PatientID,DataDate,PatientName,PatientDob,Category,MemberStatus
						,MemberStatusCompliance,PDC,RowStatus --,CLIENT_SUBSCRIBER_ID
						,@QMDATE AS QMDATE
			FROM		(
						SELECT		astRowStatus,SrcFileName,AdiTableName,AdiKey,LoadDate,CreatedDate
									,[CreateBy],ClientKey,PatientID,DataDate,PatientName,PatientDob,Category,MemberStatus
									,MemberStatusCompliance,PDC,RowStatus
						FROM (
									SELECT			DISTINCT 'P'											astRowStatus
									,SrcFileName															SrcFileName
									,'[adi].[DHTX_StarsAdherenceQualityReports]'							AdiTableName
									,StarsAdherenceEportKey													AdiKey
									,GETDATE()																LoadDate
									,[CreateDate]															CreatedDate
									,SUSER_NAME()															[CreateBy]
									,(SELECT ClientKey FROM lst.list_client WHERE ClientShortName = 'DHTX') ClientKey
									,PatientID																PatientID
									,DataDate																DataDate
									,PatientName															PatientName
									,PatientDob																PatientDob
									,Category																Category
									,MemberStatus															MemberStatus
									,'NUM'																	MemberStatusCompliance
									,PDC																	
									,RowStatus
									,ROW_NUMBER() OVER (PARTITION BY PatientID, Category, MemberStatus ORDER BY DataDate DESC) RwCnt
									FROM			ACDW_CLMS_DHTX.[adi].[DHTX_StarsAdherenceQualityReports] adi
									WHERE			RowStatus = 0
									AND				DataDate = @DataDate
									AND				Category IN ('diabetes','hypertension' ,'statins')
									AND				MemberStatus IN ('NA - Adherent and has a prescription','NA - Guaranteed Adherent','Monitor - Adherent but < 30 Days to GNA')
									AND				TRY_CONVERT(DECIMAL(5,2),PDC) >95
							)a
							WHERE RwCnt = 1
						)z
		LEFT JOIN		( SELECT	Client_Subscriber_ID 
						  FROM		ACECAREDW.dbo.vw_ActiveMembers 
						  WHERE		ClientKey = 11
						) vw
		ON				z.PatientID = vw.CLIENT_SUBSCRIBER_ID
		WHERE			vw.CLIENT_SUBSCRIBER_ID IS NOT NULL
						)src
	JOIN			(
	
					SELECT		QM
								,QM_DESC
								,LEFT(QM_DESC,CHARINDEX('-',QM_DESC,1) -1) QM_DESC1
								,AHR_QM_DESC 
					FROM		lst.LIST_QM_Mapping 
					WHERE		QM LIKE '%DHTX%' AND QM_DESC LIKE '%Adherent%' AND ACTIVE = 'Y')b
	ON				src.Category = b.QM_DESC1
	AND				src.MemberStatus <> 'NA'
	
	UNION 
		
	--Inserting COP
		
	SELECT		astRowStatus,SrcFileName,AdiTableName,AdiKey,LoadDate,CreatedDate
				,[CreateBy],ClientKey,PatientID,Category,MemberStatus,QM
				,MemberStatusCompliance,[QMDate]
	FROM		(
	SELECT		astRowStatus,SrcFileName,AdiTableName,AdiKey,LoadDate,CreatedDate
						,[CreateBy],ClientKey,PatientID,DataDate,PatientName,PatientDob,Category,MemberStatus
						,MemberStatusCompliance,PDC,RowStatus --,CLIENT_SUBSCRIBER_ID
						,@QMDATE AS QMDATE
			FROM		(
						SELECT		astRowStatus,SrcFileName,AdiTableName,AdiKey,LoadDate,CreatedDate
									,[CreateBy],ClientKey,PatientID,DataDate,PatientName,PatientDob,Category,MemberStatus
									,MemberStatusCompliance,PDC,RowStatus
						FROM (
									SELECT			DISTINCT 'P'											astRowStatus
									,SrcFileName															SrcFileName
									,'[adi].[DHTX_StarsAdherenceQualityReports]'							AdiTableName
									,StarsAdherenceEportKey													AdiKey
									,GETDATE()																LoadDate
									,[CreateDate]															CreatedDate
									,SUSER_NAME()															[CreateBy]
									,(SELECT ClientKey FROM lst.list_client WHERE ClientShortName = 'DHTX') ClientKey
									,PatientID																PatientID
									,DataDate																DataDate
									,PatientName															PatientName
									,PatientDob																PatientDob
									,Category																Category
									,MemberStatus															MemberStatus
									,'COP'																	MemberStatusCompliance
									,PDC																	
									,RowStatus
									,ROW_NUMBER() OVER (PARTITION BY PatientID, Category, MemberStatus ORDER BY DataDate DESC) RwCnt
									FROM			ACDW_CLMS_DHTX.[adi].[DHTX_StarsAdherenceQualityReports] adi
									WHERE			RowStatus = 0
									--AND				DataDate <= '2021-01-31' --Condition to be removed after the first Run
									AND				Category IN ('diabetes','hypertension' ,'statins')
									AND				MemberStatus IN ('Fill Needed - Non-Adherent (Last Claim Reversed)','Fill Needed - Non-Adherent','Needs New Prescription'
																	 ,'Fill Needed - Non-Adherent
																	 , Needs New" or  Prescription, and < 30 Days to GNA','"Monitor - Single Fill but Guaranteed Non-Adherent'
																	 ,'Fill Needed - Non-Adherent and < 30 Days to GNA'
																	 ,'NA - Adherent and has a prescription','NA - Guaranteed Adherent','Monitor - Adherent but < 30 Days to GNA')
									AND				TRY_CONVERT(DECIMAL(5,2),PDC) <95
							)a
							WHERE RwCnt = 1
						)z
		LEFT JOIN		( SELECT	Client_Subscriber_ID 
						  FROM		ACECAREDW.dbo.vw_ActiveMembers 
						  WHERE		ClientKey = 11
						) vw
		ON				z.PatientID = vw.CLIENT_SUBSCRIBER_ID
		WHERE			vw.CLIENT_SUBSCRIBER_ID IS NOT NULL
						)src
	JOIN			(
	
					SELECT		QM
								,QM_DESC
								,LEFT(QM_DESC,CHARINDEX('-',QM_DESC,1) -1) QM_DESC1
								,AHR_QM_DESC 
					FROM		lst.LIST_QM_Mapping 
					WHERE		QM LIKE '%DHTX%' AND QM_DESC LIKE '%Adherent%' AND ACTIVE = 'Y')b
	ON				src.Category = b.QM_DESC1
	AND				src.MemberStatus <> 'NA'
	

	END
	
	--Step 2 Create your DEN from src 1 the adherence report. 
	--A
	BEGIN

	INSERT INTO		#DevCareOpps([astRowStatus]
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
	
	SELECT			[astRowStatus],SrcFileName,[adiTableName], AdiKey,LoadDate,[CreateDate],[CreateBy]
					,ClientKey,[ClientMemberKey],[Category],[MemberStatus],[QmMsrId] --,QmCntCat
					,CASE WHEN QmCntCat = 'NUM' THEN 'DEN'
						WHEN QmCntCat = 'COP' THEN 'DEN'
						END QmCntCat
					,[QMDate]
	FROM			#DevCareOpps
	WHERE			adiTableName = '[adi].[DHTX_StarsAdherenceQualityReports]'

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
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate]
	FROM			#DevCareOpps
	
	END
	

	--Validation
	SELECT			COUNT(*)
					,[QmMsrId]
					,[QmCntCat]
	FROM			#DevCareOpps
	WHERE			adiTableName = '[adi].[DHTX_StarsAdherenceQualityReports]'
	GROUP BY		[QmMsrId]
					,[QmCntCat]
	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END

	-- EXECUTE [ast].[plsDevCareoppsStarsAdherenceQualityReports]'2021-05-15',11,'2021-05-03'

	/*
	SELECT		COUNT(*), DataDate,RowStatus 
	FROM		[adi].[DHTX_StarsAdherenceQualityReports]
	GROUP BY	DataDate,RowStatus 
	ORDER BY	DataDate DESC

	*/
	