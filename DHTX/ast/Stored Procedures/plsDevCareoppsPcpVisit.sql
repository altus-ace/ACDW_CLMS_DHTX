
CREATE PROCEDURE [ast].[plsDevCareoppsPcpVisit](
							@QMDATE DATE
							, @ClientKey INT
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
								,[QmMsrId] [varchar](20) NOT NULL,[QmCntCat] [varchar](10) NOT NULL,[QMDate] [date] NULL
								,COP VARCHAR(10), NUM VARCHAR(10), DEN VARCHAR(10),srcQMID VARCHAR(50))

	--Profiling for [adi].[DHTX_PCPVIsit]
	BEGIN			----  DECLARE @QMDATE DATE = '2021-09-15' DECLARE @DataDate DATE = '2021-09-06'
	INSERT INTO		#DevCareOpps(
					[srcFileName]
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
					, [COP]
					, [NUM]
					, [DEN]
					, srcQMID) -- DECLARE @QMDATE DATE = '2021-08-15' DECLARE @DataDate DATE = '2021-08-02'
	SELECT          SrcFileName,AdiTableName,DHTXPCPVisitKey,LoadDate,[CreateDate]
					,[CreateBy],ClientKey,MemberID,[Category],[MemberStatus],QM,[QmCntCat]
					,@QMDATE AS QMDATE, COP, NUM, DEN,srcQMID
	FROM			(
			SELECT			DISTINCT 'P'													astRowStatus
							,SrcFileName													
							,'[adi].[DHTX_PCPVIsit]' AdiTableName,CLIENT_SUBSCRIBER_ID
							,DHTXPCPVisitKey
							,GETDATE()LoadDate
							,[CreateDate]
							,SUSER_NAME()[CreateBy]
							,(SELECT ClientKey FROM lst.list_client WHERE ClientShortName = 'DHTX') ClientKey
							,MemberID
							,[Category]
							,[MemberStatus]
							,QM
							,'PopSet'							[QmCntCat]
							,DataDate
							,COP,NUM,DEN
							,srcQMID
			FROM			
							(	SELECT		DISTINCT'P' astRowStatus,SrcFileName
											,'[adi].[DHTX_PCPVIsit]' AS AdiTableName
											,DHTXPCPVisitKey
											,GETDATE() LoadDate
											,CreateDate
											,SUSER_NAME() CreatedBy
											,(SELECT ClientKey FROM lst.list_client WHERE ClientShortName = 'DHTX') ClientKey
											,MemberID
											,'PcpVisitInYear' AS Category
											,PcpVisitInYear AS MemberStatus
											,qm.MeasureID AS QM
											,'PopSet' [QmCntCat]
											,DataDate
											,CLIENT_SUBSCRIBER_ID
											, CASE WHEN PcpVisitInYear = 'N' THEN 'COP' ELSE PcpVisitInYear END COP
											, CASE WHEN PcpVisitInYear = 'Y' THEN 'NUM' ELSE PcpVisitInYear END NUM
											, CASE WHEN MemberID IS NOT NULL THEN 'DEN' END DEN
											, ace.Destination AS srcQMID
								FROM		[ACDW_CLMS_DHTX].[adi].[DHTX_PCPVIsit] src 
								/*Matching on lst Ace Mapping for common values*/
								LEFT JOIN		(SELECT Source, Destination
												FROM	AceMasterData.lst.ListAceMapping 
												WHERE ClientKey = 11
												AND		IsActive = 1
												AND MappingTypeKey = 14 
												)ace
								ON			'PcpVisitInYear' = ace.Source
								/* Matching on lst care op to plan to retrieve Measure IDs*/
								LEFT JOIN		(SELECT MeasureID,MeasureDesc 
												FROM AceMasterData.lst.lstCareOpToPlan 
												WHERE ClientKey = 11 
												AND ACTIVE = 'Y' 
												AND GETDATE() BETWEEN EffectiveDate AND ExpirationDate
												)qm
								ON			ace.Destination = qm.MeasureID
								/*Matching on ACtive Members to return active members for the month*/
								LEFT JOIN		ACECAREDW.dbo.vw_ActiveMembers vw
								ON			src.MemberID = vw.CLIENT_SUBSCRIBER_ID
								WHERE		src.RowStatus = 0
								AND			DataDate =@DataDate 
							)A
					)z
	
	END 
	--   SELECT * FROM #DevCareOpps
	-- Insert NUM  

	BEGIN
	INSERT INTO		#DevCareOpps(
					[srcFileName]
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
					, srcQMID)
	SELECT			srcFileName
					,AdiTableName
					,adiKey
					,LoadDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[Category]
					,[MemberStatus]
					,[QmMsrId]
					,NUM
					,[QMDate]
					,srcQMID
	FROM			(
	SELECT			DISTINCT astRowStatus, srcFileName, AdiTableName, adiKey, LoadDate, [CreateDate], [CreateBy], ClientKey, ClientMemberKey
					,[Category]	,[MemberStatus]	,[QmMsrId] ,NUM	,[QMDate]
					,ROW_NUMBER()OVER(PARTITION BY ClientMemberKey ORDER BY LoadDate)RwCnt,srcQMID
	FROM			#DevCareOpps
	WHERE			NUM IN ('NUM')
	AND				COP = 'Y'
	AND				adiTableName = '[adi].[DHTX_PCPVIsit]'
					)t
	WHERE			RwCnt = 1
	AND				MemberStatus <> 'N'

	
	END
	
	--- Insert DEN  
	BEGIN
	INSERT INTO		#DevCareOpps(
					[srcFileName]
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
	SELECT			DISTINCT srcFileName
					,AdiTableName
					,adiKey
					,LoadDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[Category]
					,[MemberStatus]
					,[QmMsrId]
					,[DEN]
					,[QMDate] 
					,srcQMID
	FROM			(
	SELECT			DISTINCT srcFileName, AdiTableName, adiKey, LoadDate, [CreateDate], [CreateBy], ClientKey, ClientMemberKey
					,[Category]	,[MemberStatus]	,[QmMsrId] 
					,CASE WHEN DEN = 'DEN' THEN DEN
						  WHEN DEN IS NULL THEN 'DEN'
						  END DEN	,[QMDate],srcQMID
					,ROW_NUMBER()OVER(PARTITION BY ClientMemberKey ORDER BY AdiKey DESC)RwCnt
	FROM			#DevCareOpps
	WHERE			adiTableName = '[adi].[DHTX_PCPVIsit]'
					)t
	WHERE			RwCnt = 1
	
	END

	--- Insert COP  
	BEGIN
	INSERT INTO		#DevCareOpps(
					[srcFileName]
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
	SELECT			DISTINCT srcFileName
					,AdiTableName
					,adiKey
					,LoadDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[Category]
					,[MemberStatus]
					,[QmMsrId]
					,[COP]
					,[QMDate] 
					,srcQMID
	FROM			(
	SELECT			DISTINCT srcFileName, AdiTableName, adiKey, LoadDate, [CreateDate], [CreateBy], ClientKey, ClientMemberKey
					,[Category]	,[MemberStatus]	,[QmMsrId] 
					,CASE WHEN COP = 'COP' THEN COP
						  WHEN COP IS NULL THEN 'COP'
						  END COP	,[QMDate],srcQMID
					,ROW_NUMBER()OVER(PARTITION BY ClientMemberKey ORDER BY AdiKey DESC)RwCnt
	FROM			#DevCareOpps
	WHERE			adiTableName = '[adi].[DHTX_PCPVIsit]'
					)t
	WHERE			RwCnt = 1
	AND				MemberStatus <>'Y'
	
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
					,srcQMID)
	
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
					,srcQMID
	FROM			#DevCareOpps
	WHERE			QmCntCat <> 'PopSet'
	
	END

	--Validation
	SELECT			COUNT(*)
					,[QmMsrId]
					,[QmCntCat]
	FROM			#DevCareOpps
	WHERE			QmCntCat <> 'PopSet'
	GROUP BY		[QmMsrId]
					,[QmCntCat]

	DROP TABLE #DevCareOpps

	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END

	-- EXECUTE [ast].[plsDevCareoppsPcpVisit]'2021-09-15',11,'2021-09-06'

	/*

	SELECT		COUNT(*), DataDate,RowStatus 
	FROM		[ACDW_CLMS_DHTX].[adi].[DHTX_PCPVIsit]
	GROUP BY	DataDate,RowStatus 
	ORDER BY	DataDate DESC

	*/
	
	
