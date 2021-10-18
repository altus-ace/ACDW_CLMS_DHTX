

CREATE PROCEDURE [ast].[pls_ProcessQM_AWV_MidYear] --'2021-09-15',11
					(@QMDate DATE,@ClientKey INT )

AS


SET NOCOUNT ON

	BEGIN

	BEGIN TRY
	BEGIN TRAN  
			
						DECLARE @AuditId INT;    
						DECLARE @JobStatus tinyInt = 1    
						DECLARE @JobType SmallInt = 9
						DECLARE @JobName VARCHAR(100) = 'DHTX_AWV';
						DECLARE @ActionStart DATETIME2 = GETDATE();
						DECLARE @SrcName VARCHAR(100) = 'ACECAREDW.adw.MbrMember'
						DECLARE @DestName VARCHAR(100) = 'ACECAREDW.[adw].[QM_ResultByMember_History]'
						DECLARE @ErrorName VARCHAR(100) = 'NA';
						DECLARE @InpCnt INT = -1;
						DECLARE @OutCnt INT = -1;
						DECLARE @ErrCnt INT = -1;
	SELECT				@InpCnt = COUNT(a.pstQM_ResultByMbr_HistoryKey)    
	FROM				ACECAREDW.ast.QM_ResultByMember_History  a
	WHERE				QMDate = @QMDate  
	AND					ClientKey = @ClientKey
	AND					QmMsrId LIKE '%AWV%'
	
	SELECT				@InpCnt, @QMDate
	
	
	EXEC				amd.sp_AceEtlAudit_Open 
						@AuditID = @AuditID OUTPUT
						, @AuditStatus = @JobStatus
						, @JobType = @JobType
						, @ClientKey = @ClientKey
						, @JobName = @JobName
						, @ActionStartTime = @ActionStart
						, @InputSourceName = @SrcName
						, @DestinationName = @DestName
						, @ErrorName = @ErrorName
						;
	CREATE TABLE		#OutputTbl (ID INT NOT NULL );
						IF OBJECT_ID('tempdb..#AWV') IS NOT NULL DROP TABLE #AWV

	CREATE TABLE		#AWV  ([pstQM_ResultByMbr_HistoryKey] [int] IDENTITY(1,1) NOT NULL,[astRowStatus] [varchar](20) NOT NULL,
								[srcFileName] [varchar](150) NULL,
								[adiTableName] [varchar](100) NOT NULL,	[adiKey] [int] NOT NULL,[LoadDate] [date] NOT NULL,	
								[CreateDate] [datetime] NOT NULL,
								[CreateBy] [varchar](50) NOT NULL,[ClientKey] [int] NOT NULL,[ClientMemberKey] [varchar](50) NOT NULL
								,Category [Varchar] (50)
								,[QmMsrId] [varchar](20) ,[QmCntCat] [varchar](10) ,[QMDate] [date] NULL
								, srcQMID VARCHAR(50))
	BEGIN
					/*Step 1: Identify and create newly enrolled member for AWV program*/ -- DECLARE @QMDATE DATE = '2021-09-15' DECLARE @ClientKey INT = 11
	INSERT INTO			#AWV([astRowStatus]
							, [srcFileName]
							, [adiTableName]
							, [adiKey]
							, [LoadDate]
							, [CreateDate]
								, [CreateBy]
								,[ClientKey]
								, [ClientMemberKey]
								, [QmMsrId]
								, [QmCntCat]
								, [QMDate]
								, srcQMID)   -- DECLARE @QMDATE DATE = '2021-09-15' DECLARE @ClientKey INT = 11
	SELECT		 DISTINCT 'Valid'					AS astRowStatus
				 ,'adw.MbrMember'				AS SrcFileName
				 ,'adw.MbrMember'				AS AdiTable
				 ,mbr.mbrMemberKey					AS AdiKey
				 ,mbr.LoadDate
				 ,mbr.CreatedDate
				 ,mbr.[CreatedBy]
				 ,mbr.ClientKey
				 ,mbr.ClientMemberKey
				 ,(	SELECT DISTINCT MeasureID
							--	,Source
							--,Destination
							--, careopps.Active
					FROM	lst.ListAceMapping acepln
					JOIN	lst.lstCareOpToPlan careopps
					ON		acepln. Destination = careopps.MeasureID
					WHERE	acepln.ClientKey = 11
					AND	IsActive = 1
					AND	careopps.ACTIVE = 'Y'	
					AND MeasureID = 'DHTX_AWV'			 
				)								AS QmMsrId
				 ,'DEN'							AS	 QmCntCat
				 ,@QMDATE
				 ,'DHTX_AWV'				AS srcQMID 
	FROM		ACECAREDW.adw.MbrMember mbr
	WHERE		ClientKey = @ClientKey 
	AND			DataDate = (SELECT MAX(DataDate)
							FROM ACECAREDW.adw.MbrMember
							WHERE	ClientKey = @ClientKey) 	

	UNION /*Union to get the COP*/
	
	SELECT		 DISTINCT 'Valid'						AS	astRowStatus
				 ,'adw.MbrMember'					AS SrcFileName
				 ,'adw.MbrMember'					AS AdiTable
				 ,mbr.mbrMemberKey						AS AdiKey
				 ,mbr.LoadDate
				 ,mbr.CreatedDate
				 ,mbr.[CreatedBy]
				 ,mbr.ClientKey
				 ,mbr.ClientMemberKey
				 ,(	SELECT DISTINCT MeasureID
					FROM	lst.ListAceMapping acepln
					JOIN	lst.lstCareOpToPlan careopps
					ON		acepln. Destination = careopps.MeasureID
					WHERE	acepln.ClientKey = 11
					AND	IsActive = 1
					AND	careopps.ACTIVE = 'Y'	
					AND MeasureID = 'DHTX_AWV'			 
				)										AS QmMsrId
				 ,'COP'									AS	 QmCntCat
				 ,@QMDATE
				 ,'DHTX_AWV'						AS srcQMID 
	FROM		ACECAREDW.adw.MbrMember mbr
	WHERE		ClientKey = @ClientKey 
	AND			DataDate = (SELECT MAX(DataDate)
							FROM ACECAREDW.adw.MbrMember
							WHERE	ClientKey = @ClientKey) 
	END	

	/*Step 2: Process into staging from adw.MbrMember for new members*/

	BEGIN
	INSERT INTO [ACECAREDW].ast.[QM_ResultByMember_History](  
				ClientKey
				,ClientMemberKey
				,QmMsrId
				,QmCntCat
				,QMDate
				,CreateDate
				,CreateBy
				,AdiKey
				,astRowStatus
				,adiTableName
				,LoadDate
				,srcFileName)
	SELECT		careopps.ClientKey							
				,careopps.ClientMemberKey						
				,careopps.QmMsrId
				,QmCntCat
				,QMDate
				,CreateDate
				,CreateBy
				,AdiKey
				,astRowStatus
				,adiTableName
				,LoadDate
				,srcFileName 
	FROM		#AWV careopps
	
	END
	
	/*Step 3: Process from staging into DW*/
	BEGIN
	INSERT	INTO[ACECAREDW].[adw].[QM_ResultByMember_History]
				(ClientKey
				,ClientMemberKey
				,QmMsrId
				,QmCntCat
				,QMDate
				,CreateDate
				,CreateBy
				,AdiKey)
	OUTPUT		inserted.QM_ResultByMbr_HistoryKey INTO #OutputTbl(ID)
	SELECT		ClientKey
				, ClientMemberKey
				,QmMsrId
				,QmCntCat
				,QMDate
				,CreateDate
				,CreateBy
				,AdiKey
	FROM		[ACECAREDW].[ast].[QM_ResultByMember_History]  
	WHERE		ClientKey = @ClientKey 
	AND			QMDate = @QMDate
	AND			astRowStatus = 'Valid'
	AND			QmMsrId LIKE '%AWV%'

	END

	/*Step 4: Update staging row status to exported*/
	BEGIN
		UPDATE  ACECAREDW.ast.QM_ResultByMember_History 
		SET	astRowStatus = 'Exported'
		WHERE	QMDate = @QMDate
		AND ClientKey = @ClientKey
		AND	astRowStatus = 'Valid'
		AND	QmMsrId LIKE '%AWV%'

	END
	
	SELECT				@OutCnt = COUNT(*) FROM #OutputTbl;
	SET					@ActionStart  = GETDATE();
	SET					@JobStatus =2  
	    				
	EXEC				amd.sp_AceEtlAudit_Close 
						@Audit_Id = @AuditID
						, @ActionStopTime = @ActionStart
						, @SourceCount = @InpCnt		  
						, @DestinationCount = @OutCnt
						, @ErrorCount = @ErrCnt
						, @JobStatus = @JobStatus

	COMMIT
	END TRY

	BEGIN CATCH
	EXECUTE [dbo].[usp_QM_Error_handler]
	END CATCH

	END    

	/*Validate*/

	SELECT	COUNT(*), QmMsrId,QmCntCat
	FROM	ACECAREDW.ast.QM_ResultByMember_History 
	WHERE ClientKey = @ClientKey
	AND QMDate = @QMDate
	AND QmMsrId LIKE '%AWV%'
	GROUP BY QmMsrId,QmCntCat
	ORDER BY QmMsrId,QmCntCat


	SELECT	COUNT(*), QmMsrId,QmCntCat
	FROM	ACECAREDW.adw.QM_ResultByMember_History
	WHERE ClientKey = @ClientKey
	AND QMDate = @QMDate
	AND QmMsrId LIKE '%AWV%' 
	GROUP BY QmMsrId,QmCntCat
	ORDER BY QmMsrId,QmCntCat


	