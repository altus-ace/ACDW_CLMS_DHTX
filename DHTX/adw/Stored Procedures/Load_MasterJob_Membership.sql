
CREATE PROCEDURE [adw].[Load_MasterJob_Membership] (@DataDate Date,@LoadDate DATE,@LoadType CHAR(1)
									,@ClientKey INT,@InsertCount INT,@UpdateCount INT,@TermCount INT
									,@EffectiveMonth VARCHAR(7), @EffectiveDate DATE
									,@adiDataDate DATE, @stgDataDate DATE
									)

AS
		/*Pre Validation*/
	BEGIN
			EXECUTE [adi].[ValidateMembership]
	END
			 -- Step 1 Process from src to stg
	BEGIN
				EXECUTE [ast].[pls_01_DevotedMbrMembership] @EffectiveMonth,@Datadate,@ClientKey;
	END
	
	
		--Step 2 Process mpi matches and updates
	BEGIN
	
		EXECUTE [ast].[pls_02_DevotedMbrMembershipRunMPI]@ClientKey;
	
	END
	
	 ----Step 2a Uppdate Member Metrics
	BEGIN

		EXECUTE [ast].[pls_02a_Pts_ProcessMbrMemberTransformationInStaging]
							@DataDate ,@EffectiveDate 
	END
	----- Update Source adi table
	BEGIN
	
		EXECUTE  [ast].[pts_03_DevotedMbrMembershipAdiTableUpdate]@EffectiveMonth
	END
	
			----Process MbrDimensions
	BEGIN
	
		EXECUTE	[adw].[Pdw_MbrDimension] @DataDate ,@LoadDate ,@LoadType 
				,@ClientKey ,@InsertCount ,@UpdateCount ,@TermCount 
	
	END

		--Step 4  Update row status in stg
	BEGIN
	
		EXECUTE [adw].[pus_10_UpdateStgRowStatus]@DataDate
	
	END

	/*5 Upload Failed Table*/

	BEGIN
	EXECUTE [adw].[pdw_Load_FailedMembership]@EffectiveDate;
	END


