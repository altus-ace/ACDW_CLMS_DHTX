

CREATE PROCEDURE [adi].[ValidateMembership]

AS
		---Keep Updating
		---Data Count for respective Load
		SELECT		TOP 1 COUNT(*)RecCnt, DataDate,a.Status
					,a.LoadDate 
		INTO		#DataDate
		FROM		[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly] a
		GROUP BY	DataDate,a.Status ,a.LoadDate 
		ORDER BY	DataDate DESC ,a.LoadDate DESC

		/*Step 1 - Check for distinct values in the field NewthisMonth and MonthEndStatus*/

		DECLARE @LoadDate DATE = (SELECT	LoadDate
									FROM	#DataDate) 

		DECLARE @DataDate DATE = (SELECT	DataDate
									FROM	#DataDate) 

		DECLARE @EffectiveMonth VARCHAR(7) = (SELECT	DataDate
											FROM	#DataDate) 
		
		SELECT	@DataDate AS DataDate , @EffectiveMonth AS EffectiveMonth
				,@LoadDate AS LoadDate

		SELECT	DISTINCT NewThisMonth
		FROM	[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]
		WHERE	DataDate = @DataDate
		AND		EffectiveMonth = @EffectiveMonth

		

		SELECT	DISTINCT MonthEndStatus
		FROM	[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]
		WHERE	DataDate = @DataDate
		
		-- Total count of records after matched with lst PCP
		SELECT		COUNT(DISTINCT MemberID) TotalCntOfMembersToBeProcessed
		FROM		(SELECT		PcpNpi,MemberID,EffectiveMonth  
					 FROM		[adi].[DHTX_EligibilityMonthly]
					 WHERE		DataDate = @DataDate
					 AND		EffectiveMonth = @EffectiveMonth) a
		JOIN		(SELECT		DISTINCT NPI, AttribTIN
					 FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster (11,@DataDate,1) ) b
		ON			a.PcpNpi = b.NPI

		-- Total count of records after matched with lst PCP
		SELECT		COUNT(DISTINCT MemberID) AllCntOfMembersToBeProcessed
		FROM		(SELECT		PcpNpi,MemberID,EffectiveMonth  
					 FROM		[adi].[DHTX_EligibilityMonthly]
					 WHERE		DataDate = @DataDate
					 AND		EffectiveMonth = @EffectiveMonth) a
		LEFT JOIN		(SELECT		DISTINCT NPI, AttribTIN
					 FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster (11,@DataDate,1) ) b
		ON			a.PcpNpi = b.NPI

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
		JOIN		(	SELECT  DISTINCT NPI,AttribTIN 
						FROM    [ACECAREDW].adw.tvf_AllClient_ProviderRoster (11,@DataDate,1) pr
					    )pr
		ON			e.PCPNPI = pr.NPI
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
						FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster (11,@DataDate,1) 
					)pr  
		ON			e.PCPNPI = pr.NPI
		ORDER BY	MemberID

		-- Total members after matched with lst PCP
		SELECT		DISTINCT NPI,MemberID
		FROM		(SELECT		PcpNpi,MemberID,EffectiveMonth  
					 FROM		[adi].[DHTX_EligibilityMonthly]
					 WHERE		DataDate = @DataDate
					 AND		EffectiveMonth = @EffectiveMonth) a
		JOIN		(SELECT		DISTINCT NPI, AttribTIN
					 FROM		[ACECAREDW].adw.tvf_AllClient_ProviderRoster (11,@DataDate,1)  ) b
		ON			a.PcpNpi = b.NPI

		