
-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportPCPVisit]
    @ReportDate VARCHAR(10),
	@MemberID [varchar](50) ,
	@MemberFirstName [varchar](50),
	@MemberLastName [varchar](50),
	@MemberDOB VARCHAR(10),
	@PcpFirstName [varchar](50),
	@PcpLastName [varchar](50),
	@PcpNpi [varchar](20),
	@PcpTIN [varchar](20),
	@PcpAddress [varchar](100) ,
	@PcpPracticeName [varchar](50),
	@ComprehensiveVisitInYear varchar(10) ,
	@LastComprehensiveVisitDate varchar(10),
	@PcpVisitInLast3Months varchar(10),
	@PcpVisitInYear varchar(10),
	@LastPcpVisitDate VARCHAR(10) NULL,
	@LastPcpVisitFirstName [varchar](50),
	@LastPcpVisitLastName [varchar](50),
	@LastPcpVisitNPI [varchar](20) ,
	@LastPcpVisitDiagnoses [varchar](50),
    @MemberAddress [varchar](100) ,
	@MemberPhone [varchar](12) ,
	@PcpPhone [varchar](12) ,
	@PcpTinName [varchar](100) ,
	@MemberMobilePhone [varchar](12),
 	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	@DataDate varchar(10),
	--@CreateDate  ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100)
--	@LastUpdatedDate varchar(100)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
	--DECLARE @FileNameDate varchar(100), @DateForFile DATE
--	SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)+1,charindex('.',@SrcFileName)-1)
--	SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 8))
	--SET @DataDate = SUBSTRING(@FileNameDate, 1, 8)
	--SET @FileDate =  SUBSTRING(@FileNameDate, 1, 8)
	--SET @RecordExist = (SELECT COUNT(*) 
	--FROM adi.[CopWlcTxM]
	--WHERE SrcFileName = @SrcFileName)

 --   IF @RecordExist = 0
	--BEGIN
   -- IF (@Devoted_Member_ID != '' )
	BEGIN
    -- Insert statements 
    INSERT INTO [adi].[DHTX_PCPVIsit]
    (
	[ReportDate] ,
	[MemberID] ,
	[MemberFirstName] ,
	[MemberLastName] ,
	[MemberDOB] ,
	[PcpFirstName] ,
	[PcpLastName] ,
	[PcpNpi] ,
	[PcpTIN] ,
	[PcpAddress] ,
	[PcpPracticeName] ,
	[ComprehensiveVisitInYear] ,
	[LastComprehensiveVisitDate] ,
	[PcpVisitInLast3Months] ,
	[PcpVisitInYear] ,
	[LastPcpVisitDate] ,
	[LastPcpVisitFirstName] ,
	[LastPcpVisitLastName] ,
	[LastPcpVisitNPI] ,
	[LastPcpVisitDiagnoses] 
	  ,[MemberAddress]
      ,[MemberPhone]
      ,[PcpPhone]
      ,[PcpTinName]
      ,[MemberMobilePhone],
	[SrcFileName] ,
	[FileDate] ,
	[DataDate],
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	LoadDate

	)
		
 VALUES   (
    
	@ReportDate ,
	@MemberID  ,
	@MemberFirstName ,
	@MemberLastName ,
	CASE WHEN @MemberDOB = ''
	THEN NULL
	ELSE CONVERT(DATE, @MemberDOB) 
	END,
	@PcpFirstName ,
	@PcpLastName ,
	@PcpNpi ,
	@PcpTIN ,
	@PcpAddress  ,
	@PcpPracticeName ,
	@ComprehensiveVisitInYear ,
	@LastComprehensiveVisitDate ,
	@PcpVisitInLast3Months ,
	@PcpVisitInYear ,
	@LastPcpVisitDate ,
	@LastPcpVisitFirstName ,
	@LastPcpVisitLastName ,
	@LastPcpVisitNPI  ,
	@LastPcpVisitDiagnoses ,
	@MemberAddress ,
	@MemberPhone ,
	@PcpPhone  ,
	@PcpTinName  ,
	@MemberMobilePhone,
 	@SrcFileName  ,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	--CONVERT(date,substring(@SrcFileName,charindex('PCPVisit',@SrcFileName)+9,10)),
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @ReportDate)
	END,
	--CONVERT(date,substring(@SrcFileName,charindex('PCPVisit',@SrcFileName)+9,10)),
	GETDATE(),
	--@CreateDate  ,,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0)

	
)
END
END


