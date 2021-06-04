

CREATE PROCEDURE [adw].[pus_10_UpdateStgRowStatus](@adiDataDate DATE, @stgDataDate DATE)

AS

BEGIN 
		 
		 --To run after adw Process
		 
		 UPDATE		ACECAREDW.ast.MbrStg2_MbrData 
		 SET		stgRowStatus = 'Exported'
		 WHERE		ClientKey = 11
		 AND		stgRowStatus = 'Valid'
		 AND		DataDate = @stgDataDate

END

BEGIN

		---Update adi table status

	UPDATE	[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]
	SET		Status = 1
	WHERE	DataDate = @adiDataDate

END