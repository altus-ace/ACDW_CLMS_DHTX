
CREATE PROCEDURE [adw].[Load_MasterJob_DevotedMembership] (@DataDate Date,@LoadDate DATE,@LoadType CHAR(1)
									,@ClientKey INT,@InsertCount INT,@UpdateCount INT,@TermCount INT
									,@EffectiveMonth VARCHAR(10)
									,@adiDataDate DATE, @stgDataDate DATE)

AS
			 -- Step 1 Process from src to stg
	BEGIN
				EXECUTE [ast].[pls_01_DevotedMbrMembership] @EffectiveMonth,@Datadate,@ClientKey;
	END
	
	
		--Step 2 Process mpi matches and updates
	BEGIN
	
		EXECUTE [ast].[pls_02_DevotedMbrMembershipRunMPI]@ClientKey;
	
	END
	
	----- Update Source adi table
	BEGIN
	
		EXECUTE  [ast].[pts_03_DevotedMbrMembershipAdiTableUpdate]
	END
	
			----Process MbrDimensions
	BEGIN
	
		EXECUTE	[adw].[Pdw_MbrDimension] @DataDate ,@LoadDate ,@LoadType 
				,@ClientKey ,@InsertCount ,@UpdateCount ,@TermCount 
	
	END

		--Step 4  Update row status in stg
	BEGIN
	
		EXECUTE [adw].[pus_10_UpdateStgRowStatus]@adiDataDate, @stgDataDate
	
	END

	--Step 5 load into MemberMonth Tables
	BEGIN
		EXECUTE [adw].[pdwMbr_31_Load_MemberMonth_Consolidation] @LoadDate, @ClientKey
					
	END
