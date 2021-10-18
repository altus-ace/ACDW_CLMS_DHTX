
CREATE PROCEDURE [adi].[ValidateCop]

AS

	SELECT		TOP 5 COUNT(*)RecCnt, DataDate
				, RowStatus,LoadDate
	FROM		[ACDW_CLMS_DHTX].[adi].[DHTX_PCPVIsit] 
	GROUP BY	DataDate,RowStatus,LoadDate
	ORDER BY	DataDate DESC,LoadDate DESC

	

	SELECT		TOP 5 COUNT(*)RecCnt, DataDate
				, Status,LoadDate
	FROM		ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus] 
	GROUP BY	DataDate,Status,LoadDate
	ORDER BY	DataDate DESC,LoadDate DESC
	

	SELECT		TOP 5 COUNT(*)RecCnt, DataDate
				, RowStatus,LoadDate
	FROM		[adi].[DHTX_StarsAdherenceQualityReports] 
	GROUP BY	DataDate,RowStatus,LoadDate
	ORDER BY	DataDate DESC,LoadDate DESC

	/*Validate AWV*/
	SELECT	PcpVisitInYear,MemberID
			,Destination
	FROM	[adi].[DHTX_PCPVIsit] adi
	LEFT JOIN	(SELECT Source, Destination
					 FROM lst.ListAceMapping 
					 WHERE ClientKey = 11 
					 AND IsActive = 1 
					 AND MappingTypeKey = 14
					 AND Destination = 'DHTX_AWV'
					)lst
	ON		'PcpVisitInYear' = Source
	WHERE	DataDate = (SELECT MAX(DataDate) 
						FROM [adi].[DHTX_PCPVIsit])


	/*Validate StarsMemberStatus*/
	SELECT	DISTINCT Measures, Source,Destination
	FROM 
		(
			SELECT	DataDate,[DiabetesRetinalScreen]
				   , [DiabetesKidneyMonitoring], [DiabetesHba1cControl]
					,[DiabetesStatinUse]--, [RheumatoidArthritisManagement] Termed
				   , [ControllingBloodPressure],[ControllingBPReason]
				   ,[ColorectalCancerScreening],[CardiovascularStatinUse]
			FROM	ACDW_CLMS_DHTX.[adi].[DHTX_StarsMemberStatus] -- A replacement for the new table
			WHERE	Status =   0 
			AND		DataDate = (SELECT MAX(DataDate) 
			FROM [adi].[DHTX_StarsMemberStatus])
		) AS cols
		UNPIVOT
				(
					MeasureCategory FOR Measures IN ( [DiabetesRetinalScreen], [DiabetesKidneyMonitoring], [DiabetesHba1cControl]
						,[DiabetesStatinUse], /*[RheumatoidArthritisManagement]*/ [ControllingBloodPressure],[ControllingBPReason]
						,[ColorectalCancerScreening],[CardiovascularStatinUse])
				) AS up	

	LEFT JOIN	(SELECT Source, Destination
					 FROM lst.ListAceMapping 
					 WHERE ClientKey = 11 
					 AND IsActive = 1 
					 AND MappingTypeKey = 14
					)lst
	ON		up.Measures = Source
	--WHERE	lst.Source IS NULL

	/*Validate QualityReports*/
	SELECT	DISTINCT Category
			,Destination,Source
	FROM	[adi].[DHTX_StarsAdherenceQualityReports]  adi
	LEFT JOIN	(SELECT Source, Destination
					 FROM lst.ListAceMapping 
					 WHERE ClientKey = 11 
					 AND IsActive = 1 
					 AND MappingTypeKey = 14
					)lst
	ON		adi.Category = lst.Source
	WHERE	DataDate = (SELECT MAX(DataDate) 
						FROM [adi].[DHTX_StarsAdherenceQualityReports])




	
	--SELECT		COUNT(*), QmMsrId,QmCntCat
	--FROM		ACECAREDW.adw.QM_ResultByMember_History
	--WHERE		QMDate = '2021-07-15'
	--AND			ClientKey = 11
	--GROUP BY	QmMsrId,QmCntCat
	--ORDER BY QmMsrId,QmCntCat

	--SELECT		COUNT(*), QmMsrId,QmCntCat
	--			,astRowStatus --- SELECT DISTINCT QMMSRID
	--FROM		ACECAREDW.ast.QM_ResultByMember_History
	--WHERE		QMDate = '2021-10-15'
	--AND			ClientKey = 11
	--GROUP BY	QmMsrId,QmCntCat,astRowStatus 
	--ORDER BY QmMsrId,QmCntCat