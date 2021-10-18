


CREATE	PROCEDURE [ast].[pts_03_DevotedMbrMembershipAdiTableUpdate]@EffectiveMonth VARCHAR(7) -- [ast].[pts_03_DevotedMbrMembershipAdiTableUpdate] '2021-09'

AS

BEGIN
BEGIN TRAN
BEGIN TRY

			
BEGIN
			UPDATE  [adi].[DHTX_EligibilityMonthly] 
			SET		Status = CASE WHEN EffectiveMonth = @EffectiveMonth THEN 1
					ELSE 3 END
			WHERE	Status = 0



END



COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH


END

