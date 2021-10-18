CREATE  PROCEDURE [adw].[Load_Pdw_MasterLoad_Cop] (@QMDate DATE, @ClientKey INT,@DataDate DATE) --[adw].[Load_Pdw_MasterLoad_CopDevoted]'2021-06-15',11,'2021-06-01'
AS
	--DECLARE @DataDate DATE ='2021-06-07'
	--DECLARE @QMDate DATE = '2021-06-15';
	--DECLARE @ClientKey INT = 11
	DECLARE @InsertCount INT;
	DECLARE	@SourceCount INT;
    DECLARE @QueryCount INT				= 0;    
    DECLARE @Audit_ID INT				= 0;
   -- DECLARE @ClientKey INT				=11;
    DECLARE @qmFx VARCHAR(100);
    DECLARE @Destination VARCHAR(100)	='ast.QM_ResultByMember_History';
    DECLARE @JobName VARCHAR(100)		= '[ast].[Load_Pdw_MasterLoad_CopDevoted]';
    DECLARE @StartTime DATETIME2;
	DECLARE @OutputTbl Table (ID INT);
	INSERT INTO @OutputTbl (ID)
	SELECT  (pstQM_ResultByMbr_HistoryKey) FROM ACECAREDW.ast.QM_ResultByMember_History WHERE CLIENTKEY = 11 
	SELECT @SourceCount = COUNT(*) FROM @OutputTbl 
	
	   -- Audit Status     1	In process,     2	Success,    3	Fail-- Job Type        4	Move File,    5	ETL Data,     6	Export Data
   /* 
   ***The logging calls is called inside the QM Procedure 
   ***Set Open logging
   ***Set Close logging
   */
   /*Pre Validation*/
   BEGIN
	EXECUTE [adi].[ValidateCop]
   END

	BEGIN

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'ast.QM_ResultByMember_History '; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [ast].[plsDevCareoppsPcpVisit] @QMDate, @ClientKey,@DataDate
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  

END

BEGIN

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'ast.QM_ResultByMember_History '; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [ast].[plsDevCareoppsStarsMemberStatus] @QMDate ,@ClientKey,@DataDate
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  

END

BEGIN

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'ast.QM_ResultByMember_History '; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [ast].[plsDevCareoppsStarsAdherenceQualityReports] @QMDate ,@ClientKey,@DataDate	
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  

END

BEGIN
	EXECUTE ast.Pud_UpdateAllLineageKeys
END


BEGIN

EXECUTE [ast].[pstCopValidateStaging]@QMDATE,@ClientKey

END

BEGIN

	DECLARE @Destination1 VARCHAR(100)	= '[adw].[QM_ResultByMember_History]';
	DECLARE @OutputTbl2 Table (ID INT);
	DECLARE	@SourceCount2 INT;
	INSERT INTO @OutputTbl2 (ID)
	SELECT  COUNT(QM_ResultByMbr_HistoryKey) FROM ACECAREDW.adw.QM_ResultByMember_History WHERE CLIENTKEY = 11 
	SELECT @SourceCount2 = COUNT(*) FROM @OutputTbl2 

	SET @StartTime = GETDATE();	   
	SET @qmFx = '[adw].[QM_ResultByMember_History]'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination1, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [adw].[pdw_COP] @QMDate,@ClientKey
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount2, @DestinationCount = @SourceCount2,@ErrorCount = @@ERROR;  


END


