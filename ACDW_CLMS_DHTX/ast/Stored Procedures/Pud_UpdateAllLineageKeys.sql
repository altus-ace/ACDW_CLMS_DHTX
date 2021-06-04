

CREATE PROCEDURE ast.Pud_UpdateAllLineageKeys

AS
	UPDATE	[ACDW_CLMS_DHTX].[adi].[DHTX_PCPVIsit]
	SET		RowStatus = 1
	WHERE	RowStatus = 0 


	UPDATE	ACDW_CLMS_DHTX.[adi].[DHTX_StarsAdherenceQualityReports]
	SET		RowStatus = 1
	WHERE	RowStatus = 0 

	UPDATE	ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus]
	SET		Status = 1
	WHERE	Status = 0 