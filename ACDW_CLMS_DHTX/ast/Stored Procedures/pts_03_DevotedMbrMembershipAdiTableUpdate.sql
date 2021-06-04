


CREATE	PROCEDURE [ast].[pts_03_DevotedMbrMembershipAdiTableUpdate]

AS

BEGIN
BEGIN TRAN
BEGIN TRY

			
BEGIN
			UPDATE  [adi].[DHTX_EligibilityMonthly] 
			SET		Status = 1
			WHERE	Status = 0

END



COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH


END
