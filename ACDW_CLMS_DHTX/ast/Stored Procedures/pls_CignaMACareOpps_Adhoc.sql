

CREATE PROCEDURE [ast].[pls_CignaMACareOpps_Adhoc](@QMDATE DATE, @ClientKey INT)  --- [ast].[pls_CignaMACareOpps_Adhoc]'2021-02-08',12
AS


	BEGIN
	BEGIN TRY
	BEGIN TRAN
					

	BEGIN

	--Insert into staging
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
	
	SELECT			DISTINCT 'Exported'
					,[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					,[CreateBy]
					,@ClientKey
					, [ClientSubscriberId]
					,[MeasureID]
					, CASE WHEN ClientSubscriberId IS NOT NULL THEN 'DEN'  END QmCntCat
					, [DataDate]
	FROM			ACECAREDW.ast.MbrStg2_MbrData   a
	JOIN			(	SELECT		ClientKey, MeasureID 
						FROM		lst.lstCareOpToPlan
						WHERE		ClientKey = @ClientKey
						AND			MeasureID = 'Cigna_MA_360')  b
	ON				a.ClientKey = 12 and b.ClientKey = 12
	AND				a.DataDate =  @QMDATE -- '2021-02-08'  --- 

	UNION

	SELECT			DISTINCT 'Exported'
					,[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					,[CreateBy]
					,@ClientKey
					, [ClientSubscriberId]
					,[MeasureID]
					, CASE WHEN ClientSubscriberId IS NOT NULL THEN 'COP'  END QmCntCat
					, [DataDate]
	FROM			ACECAREDW.ast.MbrStg2_MbrData   a
	JOIN			(	SELECT		ClientKey, MeasureID 
						FROM		lst.lstCareOpToPlan
						WHERE		ClientKey = @ClientKey
						AND			MeasureID = 'Cigna_MA_360')  b
	ON				a.ClientKey = 12 and b.ClientKey = 12
	AND				a.DataDate =   @QMDATE --'2021-02-08'  ---
	
	END


	BEGIN
			--Insert into DW

	INSERT	INTO		[ACECAREDW].[adw].[QM_ResultByMember_History]
						(ClientKey, ClientMemberKey,QmMsrId,QmCntCat,QMDate,CreateDate,CreateBy,AdiKey)
	SELECT				ClientKey
						,ClientMemberKey
						,QmMsrId
						,QmCntCat
						,QMDate
						,CreateDate
						,CreateBy
						,AdiKey
	FROM				[ACECAREDW].[ast].[QM_ResultByMember_History]  
	WHERE				ClientKey = @ClientKey 
	AND					QMDate = @QMDate
	END

	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END


	
