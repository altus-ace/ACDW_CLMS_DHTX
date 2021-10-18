	CREATE PROCEDURE [adw].[pdw_COP] (
								@QMDate DATE
								, @ClientKey INT) --[adw].[pdwCOP_Devoted]'2021-09-15',11
	AS
	 
SET NOCOUNT ON
	BEGIN
	
	BEGIN TRY
	BEGIN TRAN

	
	---Insert into Data Warehouse
	INSERT	INTO	[ACECAREDW].[adw].[QM_ResultByMember_History]
					(ClientKey
					, ClientMemberKey
					,QmMsrId
					,QmCntCat
					,QMDate
					,CreateDate
					,CreateBy
					,AdiKey)
	SELECT			ClientKey
					, ClientMemberKey
					,QmMsrId
					,QmCntCat
					,QMDate
					,CreateDate
					,CreateBy
					,AdiKey
	FROM			[ACECAREDW].[ast].[QM_ResultByMember_History]  
	WHERE			ClientKey = @ClientKey 
	AND				QMDate = @QMDate
	AND				astRowStatus = 'Valid'

	
	


	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END    

	

	