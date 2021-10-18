
CREATE PROCEDURE [adw].[Pdw_MbrDimension] (@DataDate Date,@LoadDate DATE,@LoadType CHAR(1)
				,@ClientKey INT,@InsertCount INT,@UpdateCount INT,@TermCount INT)

AS

		BEGIN
		
		
		 --Process Mbr DW 
			--DECLARE @LoadDate DATE = '2021-06-01'
			--DECLARE @LoadType VARCHAR(5) = 'P'
			--DECLARE @ClientKey INT = 11
			--DECLARE @InsertCount INT = 1029
			--DECLARE @UpdateCount INT = 254
			--DECLARE @TermCount INT = 2
			EXECUTE ACECAREDW.[adw].[PdwMbr_01_LoadHistory]@LoadDate,@LoadType,@ClientKey,@InsertCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_02_LoadMember]@LoadDate,@ClientKey,@InsertCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_03_LoadDemo]@LoadDate,@ClientKey,@InsertCount,@UpdateCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_04_LoadPhone]@LoadDate,@LoadType,@ClientKey,@InsertCount,@UpdateCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_05_LoadAddress]@LoadDate,@ClientKey,@InsertCount,@UpdateCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_06_LoadPcp]@LoadDate,@ClientKey,@InsertCount,@UpdateCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_08_LoadPlan]@LoadDate,@ClientKey,@InsertCount,@UpdateCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_09_LoadCSPlan]@LoadDate,@ClientKey,@InsertCount,@UpdateCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_11_LoadEmail]@LoadDate,@ClientKey,@InsertCount,@UpdateCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_25_TermPlan]@LoadDate,@ClientKey,@TermCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_29_TermCsPlan]@LoadDate,@ClientKey,@TermCount
			EXECUTE ACECAREDW.[adw].[PdwMbr_30_TermPcp]@LoadDate,@ClientKey,@TermCount
			---	Write into Consolidated ME Table
			EXECUTE ACECAREDW.adw.pdwMbr_31_Load_MemberMonth_Consolidation @LoadDate,@ClientKey
		END


