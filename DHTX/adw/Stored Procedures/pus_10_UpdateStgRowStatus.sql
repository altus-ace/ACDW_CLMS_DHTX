

CREATE PROCEDURE [adw].[pus_10_UpdateStgRowStatus](@DataDate DATE)

AS

BEGIN 
		 
		 --To run after adw Process
		 
		 UPDATE		ACECAREDW.ast.MbrStg2_MbrData 
		 SET		stgRowStatus = 'Exported'
		 WHERE		ClientKey = 11
		 AND		stgRowStatus = 'Valid'
		 AND		DataDate = @DataDate

END

