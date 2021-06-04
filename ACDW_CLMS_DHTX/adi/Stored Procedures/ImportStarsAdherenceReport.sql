-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportStarsAdherenceReport]
 
	@SrcFileName varchar(100),
	@FileDate varchar(12),
	--CreateDate] [datetime] NULL,
	@CreateBy varchar(100) NULL,
	@OriginalFileName varchar(100),
	@LastUpdatedBy varchar(100),
	--@LastUpdatedDate varchar(),
	@DataDate varchar(12),
	@ReportDate varchar(12),
    @PatientName varchar(100),
    @PatientID varchar(50),
    @PatientDob varchar(12) ,
    @PcpName varchar(100) ,
    @PcpNpi varchar(20),
    @Practice varchar(20) ,
    @Category varchar(20),
    @MemberStatus varchar(500),
    @NextFillDueDate varchar(12) ,
    @LastFilledMedication varchar(50),
    @LastFillDate varchar(12),
    @Needs90DaySupply VARCHAR(20) ,
    @DaysUntilGNA varchar(10),
    @PrescriberName varchar(100),
    @PrescriberPhoneNumber varchar(20),
    @PharmacyName varchar(50) ,
    @PharmacyPhoneNumber varchAR(12) ,
    @PharmacyAddress VARCHAR(100),
	@PatientPhone varchar(12),
	@PatientMobilePhone [varchar](12),
	@PcpTIN [varchar](20),
	@RefillsLeft [varchar](10) ,
	@DaysMissedInYear [varchar](10) ,
	@DevotedPharmacyTeamNote [varchar](500),
	@PcpPracticeName [varchar](100) ,
	@PcpAddress [varchar](100),
	@PcpPhone [varchar](20) ,
	@PcpTinName [varchar](100) ,
	@LastFillDaySupply [varchar](10) ,
	@PDC [varchar](50),
	@FirstFillDate varchar(10),
	@NumberOfFills [varchar](10)
	
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FileNameDate varchar(100), @DateForFile DATE

	
  --  SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)-17 ,charindex('.',@SrcFileName)-1) 
--	SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 10)) 

	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
--	DECLARE @FileNameDate varchar(100), @DateForFile DATE
--SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)+1,charindex('.',@SrcFileName)-1)
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
    INSERT INTO [adi].[DHTX_StarsAdherenceQualityReports]
    (
	[SrcFileName] ,
	[FileDate] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[ReportDate] ,
    [PatientName] ,
    PatientID ,
    PatientDob ,
    PcpName ,
    PcpNpi ,
    Practice ,
    Category ,
    MemberStatus ,
    NextFillDueDate ,
    LastFilledMedication ,
    LastFillDate ,
    Needs90DaySupply ,
    DaysUntilGNA ,
    PrescriberName ,
    PrescriberPhoneNumber,
    PharmacyName,
    PharmacyPhoneNumber,
    PharmacyAddress, 
	[PatientPhone] ,
	[PatientMobilePhone] ,
	[PcpTIN] ,
	[RefillsLeft] ,
	[DaysMissedInYear] ,
	[DevotedPharmacyTeamNote]  ,
	[PcpPracticeName]
      ,[PcpAddress]
      ,[PcpPhone]
      ,[PcpTinName]
      ,[LastFillDaySupply]
      ,[PDC]
      ,[FirstFillDate]
      ,[NumberOfFills]

	)
		
 VALUES   (
    
	@SrcFileName ,
	--@FileDate ,
	CONVERT(DATE, SUBSTRING(@SrcFileName,32,10)),
	--CONVERT(DATE, substring(@SrcFileName,charindex('StarsAdherence',@SrcFileName)+15,10)),
	--@DateForFile,
	GETDATE(),
	--CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	CONVERT(DATE, SUBSTRING(@SrcFileName,32,10)),
--	CONVERT(DATE, substring(@SrcFileName,charindex('StarsAdherence',@SrcFileName)+15,10)),
	--GETDATE(),
	--@LastUpdatedDate varchar(),
	--@DataDate ,
	--@DateForFile,

	CASE WHEN @ReportDate  = ''
	THEN NULL
	ELSE CONVERT(DATE, @ReportDate) 
	END,
    @PatientName ,
    @PatientID ,
	CASE WHEN @PatientDob = ''
	THEN NULL
	ELSE CONVERT(DATE, @PatientDob) 
	END,
    @PcpName ,
    @PcpNpi ,
    @Practice ,
    @Category ,
    @MemberStatus ,
	CASE WHEN @NextFillDueDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @NextFillDueDate) 
	END,
    @LastFilledMedication ,
    CASE WHEN @LastFillDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @LastFillDate) 
	END,
    @Needs90DaySupply ,
    CASE WHEN 	@DaysUntilGNA = ''
	THEN NULL
	ELSE CONVERT(INT,@DaysUntilGNA)
	END ,
    @PrescriberName ,
    @PrescriberPhoneNumber ,
    @PharmacyName  ,
    @PharmacyPhoneNumber ,
    @PharmacyAddress ,
	@PatientPhone ,
	@PatientMobilePhone ,
	@PcpTIN ,
	@RefillsLeft  ,
	@DaysMissedInYear ,
	@DevotedPharmacyTeamNote,
	@PcpPracticeName  ,
	@PcpAddress ,
	@PcpPhone ,
	@PcpTinName  ,
	@LastFillDaySupply ,
	@PDC ,
	CASE WHEN @FirstFillDate = ''
	THEN NULL
	ELSE CONVERT(DATE,
	@FirstFillDate )
	END,
	@NumberOfFills 
	
)
END
END


--SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 8)) 
--SET 
--Select  substring('altusacenetwork_StarsAdherenceReport_2020-02-03_130831.csv',charindex('.','altusacenetwork_StarsAdherenceReport_2020-02-03_130831.csv')- 17,charindex('.','altusacenetwork_StarsAdherenceReport_2020-02-03_130831.csv')-1) 
--SELECT charindex('.','altusacenetwork_StarsAdherenceReport_2020-02-03_130831.csv') - 10

--Select convert(date, SUBSTRING('2020-02-03_130831.csv', 1, 10)) 