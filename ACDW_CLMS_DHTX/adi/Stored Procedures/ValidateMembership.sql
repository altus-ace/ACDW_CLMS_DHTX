

CREATE PROCEDURE [adi].[ValidateMembership]

AS
		---Keep Updating
		---Data Count for respective Load
		SELECT		COUNT(*)RecCnt, DataDate,a.Status 
		FROM		[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly] a
		GROUP BY	DataDate,a.Status 
		ORDER BY	DataDate DESC

		/*Step 1 - Check for distinct values in the field NewthisMonth and MonthEndStatus*/


		DECLARE @DataDate DATE = '2021-05-01'
		DECLARE @EffectiveMonth VARCHAR(20) = '2021-05'


		SELECT	DISTINCT NewThisMonth
		FROM	[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]
		WHERE	DataDate = @DataDate

		SELECT	DISTINCT MonthEndStatus
		FROM	[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]
		WHERE	DataDate = @DataDate
		--- Candidate Records to process
		SELECT		* 
		FROM		(
						SELECT		MemberID,EffectiveMonth,DataDate,NewThisMonth,CMSContractPBP
									,MonthEndStatus,a.PcpNpi
						FROM		adi.DHTX_EligibilityMonthly a
						WHERE		DataDate = @DataDate
						AND			EffectiveMonth = @EffectiveMonth
						AND			NewThisMonth IN (	SELECT	Source
														FROM	lst.ListAceMapping
														WHERE	ClientKey = 11
														AND		Destination = 'NewThisMonth'
													) 
						AND			MonthEndStatus = ''
						AND MemberDeathDate IS NULL
						AND	EnrollmentEndDate IS NULL
					)e
		JOIN		(	SELECT  DISTINCT NPI,HealthPlan, EffectiveDate,ExpirationDate--,TIN 
						FROM    [ACECAREDW].[dbo].[vw_AllClient_ProviderRoster] s
					    WHERE	HealthPlan = 'DEVOTED' 
						AND		@DataDate BETWEEN EffectiveDate AND ExpirationDate 
						--ORDER BY s.NPI
					   
					 )vw  
		ON			e.PCPNPI = vw.NPI
		ORDER BY	MemberID

		--To test with the new provider roster
		SELECT		* 
		FROM		(
						SELECT		MemberID,EffectiveMonth,DataDate,NewThisMonth,CMSContractPBP
									,MonthEndStatus,a.PcpNpi
						FROM		adi.DHTX_EligibilityMonthly a
						WHERE		DataDate = @DataDate
						AND			EffectiveMonth = @EffectiveMonth
						AND			NewThisMonth IN (	SELECT	Source
														FROM	lst.ListAceMapping
														WHERE	ClientKey = 11
														AND		Destination = 'NewThisMonth'
													) 
						AND			MonthEndStatus = ''
						AND MemberDeathDate IS NULL
						AND	EnrollmentEndDate IS NULL
					)e
		JOIN		(	SELECT		*
						FROM		(
						SELECT		NPI, s.AttribTIN, s.NpiHpEffectiveDate,s.NpiHpExpirationDate
									,s.TinHPEffectiveDate,s.TinHPExpirationDate
									,ROW_NUMBER()OVER(PARTITION BY NPI ORDER BY RowEffectiveDate)RwCnt
						FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster_History(11,GETDATE()) s
						WHERE		(@DataDate BETWEEN NpiHpEffectiveDate AND NpiHpExpirationDate
						AND			@DataDate BETWEEN TinHPEffectiveDate AND TinHPExpirationDate)
						AND			IsActive = 1
									) src
						WHERE		RwCnt = 1
					)vw  
		ON			e.PCPNPI = vw.NPI
		ORDER BY	MemberID


		----- New roster
		SELECT		*
		FROM		(
						SELECT		NPI, s.AttribTIN, s.NpiHpEffectiveDate,s.NpiHpExpirationDate
									,s.TinHPEffectiveDate,s.TinHPExpirationDate
									,ROW_NUMBER()OVER(PARTITION BY NPI ORDER BY RowEffectiveDate)RwCnt
						FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster_History(11,GETDATE()) s
						WHERE		(GETDATE() BETWEEN NpiHpEffectiveDate AND NpiHpExpirationDate
						AND			GETDATE() BETWEEN TinHPEffectiveDate AND TinHPExpirationDate)
						AND			IsActive = 1
					) src
		WHERE		RwCnt = 1  -- 355

		--- Old roster

		SELECT		DISTINCT NPI,HealthPlan, EffectiveDate,ExpirationDate--,TIN 
		FROM		[ACECAREDW].[dbo].[vw_AllClient_ProviderRoster] s
		WHERE		HealthPlan = 'DEVOTED' 
		AND			'2021-05-01' BETWEEN EffectiveDate AND ExpirationDate
		ORDER BY	NPI
		----

		--- Distinct Field of New this Month
		SELECT		DISTINCT NewThisMonth
		FROM		adi.DHTX_EligibilityMonthly
		WHERE		DataDate = @DataDate
		AND			EffectiveMonth = @EffectiveMonth
		---Values in lookUpTable for NewThisMonth
		SELECT	Source
		FROM	lst.ListAceMapping
		WHERE	ClientKey = 11
		AND		Destination = 'NewThisMonth'

		
		-- Total count of records after matched with lst PCP
		SELECT		COUNT(DISTINCT MemberID) TotalCntOfMembersToBeProcessed
		FROM		(SELECT		PcpNpi,MemberID,EffectiveMonth  
					 FROM		[adi].[DHTX_EligibilityMonthly]
					 WHERE		DataDate = @DataDate
					 AND		EffectiveMonth = @EffectiveMonth) a
		JOIN		(SELECT		DISTINCT NPI, TIN
					 FROM		ACECAREDW.dbo.vw_AllClient_ProviderRoster
					 WHERE		CalcClientKey = 11 ) b
		ON			a.PcpNpi = b.NPI
		
		-- Total members after matched with lst PCP
		SELECT		DISTINCT NPI,MemberID
		FROM		(SELECT		PcpNpi,MemberID,EffectiveMonth  
					 FROM		[adi].[DHTX_EligibilityMonthly]
					 WHERE		DataDate = @DataDate
					 AND		EffectiveMonth = @EffectiveMonth) a
		JOIN		(SELECT		DISTINCT NPI, TIN
					 FROM		ACECAREDW.dbo.vw_AllClient_ProviderRoster
					 WHERE		CalcClientKey = 11 ) b
		ON			a.PcpNpi = b.NPI

			--SELECT * 
			--FROM	ACECAREDW.ast.MbrStg2_MbrData
			--WHERE	ClientKey = 11
			--AND		DataDate = '2021-04-01'

		--SELECT * 
		--FROM	ACECAREDW.ast.MbrStg2_PhoneAddEmail
		--WHERE	ClientKey = 11
		--AND		DataDate = '2021-04-01'

		select * from adi.DHTX_EligibilityMonthly where DataDate = '2021-05-01' 
		and EffectiveMonth = '2021-05'
		AND MemberDeathDate IS NULL
		AND	EnrollmentEndDate IS NULL
		order by MemberID

		SELECT distinct PcpNpi,npi,MemberID FROM (
		select * from adi.DHTX_EligibilityMonthly where DataDate = '2021-05-01'
		and EffectiveMonth = '2021-05'
		) a
		join [ACECAREDW].adw.tvf_AllClient_ProviderRoster_History(11,GETDATE()) b
		on a.PcpNpi = b.NPI
		where b.IsActive = 1