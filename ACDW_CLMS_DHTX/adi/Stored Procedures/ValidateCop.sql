
CREATE PROCEDURE adi.ValidateCop

AS

	SELECT		COUNT(*)RecCnt, DataDate
				, RowStatus
	FROM		[ACDW_CLMS_DHTX].[adi].[DHTX_PCPVIsit]
	GROUP BY	DataDate,RowStatus
	ORDER BY	DataDate DESC


	SELECT		COUNT(*)RecCnt, DataDate
				, Status
	FROM		ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus]
	GROUP BY	DataDate,Status
	ORDER BY	DataDate DESC
	

	SELECT		COUNT(*)RecCnt, DataDate
				, RowStatus
	FROM		[adi].[DHTX_StarsAdherenceQualityReports]
	GROUP BY	DataDate,RowStatus
	ORDER BY	DataDate DESC

	SELECT		*
	FROM		ACECAREDW.ast.QM_ResultByMember_History
	WHERE		QMDate = '2021-04-06'
	AND			ClientKey = 11