-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportQualityReports]
 
	@SrcFileName varchar(100),
	@FileDate varchar(12),
	--CreateDate] [datetime] NULL,
	@CreateBy varchar(100) NULL,
	@OriginalFileName varchar(100),
	@LastUpdatedBy varchar(100),
	--@LastUpdatedDate varchar(),
	@DataDate varchar(12),

	@ReportDate varchar(10),
	@PatientName varchar(50),
	@PatientID varchar(20) ,
	@PatientDob varchar(10),
	@PcpName varchar(50),
	@PcpNpi varchar(20) ,
	@Practice varchar(50),
	@DateLastPcpVisit varchar(10),
	@DiabetesStatus varchar(10),
	@DiabetesRetina1Screen varchar(50) ,
	@DateLastEyeExam varchar(10),
	@DiabetesKidneyMonitoring varchar(50),
	@DiabetesHba1cControl varchar(50),
	@DiabetesHba1cControlReason varchar(50),
	@DateLastA1C varchar(50),
	@LastA1CValue varchar(50),
	@DiabetesStatinUse varchar(50) ,
	@RheumatoidArthritisManagement varchar(50) ,
	@DiabetesAdherence varchar(50),
	@DiabetesLastFillDate varchar(12),
	@DiabetesNextFillDate varchar(12),
	@DiabetesDaysSupply varchar(10),
	@DiabetesDrug varchar(50),
	@DiabetesSingleFill varchar(50) ,
	@HypertensionAdherence varchar(50),
	@HypertensionLastFillDate varchar(12),
	@HypertensionNextFillDate varchar(12),
	@HypertensionDaysSupply varchar(50),
	@HypertensionDrug varchar(50),
	@HypertensionSingleFill varchar(50) ,
	@CholesterolAdherence varchar(50) ,
	@CholesterolLastFillDate varchar(12),
	@CholesterolNextFillDate varchar(12),
	@CholesterolDaysSupply varchar(50),
	@CholesterolDrug varchar(50),
	@CholesterolSingleFill varchar(50) ,
	@PharmacyName varchar(20),
	@PharmacyAddress varchar(50),
	@PharmacyTelephoneNumber varchar(10)
	,@ControllingBloodPressure varchar(10)
     ,@ColorectalCancerScreening varchar(20)
     ,@CardiovascularStatinUse varchar(20),
    @PatientPhone [varchar](12) NULL,
	@PatientMobilePhone [varchar](12) NULL,
	@PcpTIN varchar(20),
	@LastPcpVisitName [varchar](50) NULL,
	@LastPcpVisitNPI [varchar](10) ,
	@HypertensionDiagnosisDate varchar(12) ,
	@ControllingBPReason [varchar](50) ,
	@DateLastBPReading varchar(12)
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
	-- DECLARE @FileNameDate varchar(100), @DateForFile DATE
	--SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)+1,charindex('.',@SrcFileName)-1)
	-- SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 8))
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
    INSERT INTO [adi].[DHTX_QualityReports]
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
	[PatientID] ,
	[PatientDob] ,
	[PcpName] ,
	[PcpNpi] ,
	[Practice] ,
	[DateLastPcpVisit] ,
	[DiabetesStatus] ,
	[DiabetesRetina1Screen] ,
	[DateLastEyeExam] ,
	[DiabetesKidneyMonitoring] ,
	[DiabetesHba1cControl] ,
	[DiabetesHba1cControlReason] ,
	[DateLastA1C] ,
	[LastA1CValue] ,
	[DiabetesStatinUse] ,
	[RheumatoidArthritisManagement] ,
	[DiabetesAdherence] ,
	[DiabetesLastFillDate] ,
	[DiabetesNextFillDate] ,
	[DiabetesDaysSupply] ,
	[DiabetesDrug] ,
	[DiabetesSingleFill] ,
	[HypertensionAdherence] ,
	[HypertensionLastFillDate] ,
	[HypertensionNextFillDate] ,
	[HypertensionDaysSupply] ,
	[HypertensionDrug] ,
	[HypertensionSingleFill] ,
	[CholesterolAdherence] ,
	[CholesterolLastFillDate] ,
	[CholesterolNextFillDate] ,
	[CholesterolDaysSupply] ,
	[CholesterolDrug] ,
	[CholesterolSingleFill] ,
	[PharmacyName] ,
	[PharmacyAddress] ,
	[PharmacyTelephoneNumber] ,
    [ControllingBloodPressure],
    [ColorectalCancerScreening],
    [CardiovascularStatinUse],
	[PatientPhone] ,
	[PatientMobilePhone] ,
	[PcpTIN] ,
	[LastPcpVisitName] ,
	[LastPcpVisitNPI] ,
	[HypertensionDiagnosisDate] ,
	[ControllingBPReason] ,
	[DateLastBPReading] 

	)
		
 VALUES   (
    
	@SrcFileName ,
	--CONVERT(DATE, substring(@SrcFileName,charindex('.', @SrcFileName)-17,10)),
	GETDATE(),
   -- CONVERT(date, substring(@SrcFileName,charindex('StarsMemberGapsFile',@SrcFileName)+20,10)),
	--CASE WHEN @FileDate = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @FileDate)
	--END,
	GETDATE(),
	--CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	GETDATE(),
	--CONVERT(DATE, substring(@SrcFileName,charindex('.', @SrcFileName)-17,10)),
  --  CONVERT(date, substring(@SrcFileName,charindex('StarsMemberGapsFile',@SrcFileName)+20,10)),

	--@LastUpdatedDate varchar(),
	--CASE WHEN @DataDate = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @DataDate)
	--END,
	CASE WHEN @ReportDate = ''
	THEN NULL
	ELSE CONVERT(DATE,   @ReportDate)
	END,
	@PatientName ,
	@PatientID ,
	CASE WHEN @PatientDob = ''
	THEN NULL
	ELSE CONVERT(DATE,@PatientDob)
	END,
	@PcpName ,
	@PcpNpi ,
	@Practice,
	CASE WHEN @DateLastPcpVisit = ''
	THEN NULL
	ELSE CONVERT(DATE, @DateLastPcpVisit)
	END,
	@DiabetesStatus ,
	@DiabetesRetina1Screen ,
	CASE WHEN @DateLastEyeExam  = ''
	THEN NULL
	ELSE CONVERT(DATE, @DateLastEyeExam )
	END,
	@DiabetesKidneyMonitoring ,
	@DiabetesHba1cControl ,
	@DiabetesHba1cControlReason ,
	CASE WHEN @DateLastA1C  = ''
	THEN NULL
	ELSE CONVERT(DATE, @DateLastA1C )
	END,
	@LastA1CValue ,
	@DiabetesStatinUse ,
	@RheumatoidArthritisManagement ,
	@DiabetesAdherence ,
	CASE WHEN @DiabetesLastFillDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DiabetesLastFillDate)
	END,
	CASE WHEN @DiabetesNextFillDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DiabetesNextFillDate )
	END,
	@DiabetesDaysSupply ,
	@DiabetesDrug ,
	@DiabetesSingleFill ,
	@HypertensionAdherence ,
	CASE WHEN @HypertensionLastFillDate  = ''
	THEN NULL
	ELSE CONVERT(DATE,@HypertensionLastFillDate)
	END,
	CASE WHEN @HypertensionNextFillDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @HypertensionNextFillDate)
	END,
	@HypertensionDaysSupply ,
	@HypertensionDrug ,
	@HypertensionSingleFill ,
	@CholesterolAdherence  ,
	CASE WHEN @CholesterolLastFillDate  = ''
	THEN NULL
	ELSE CONVERT(DATE, @CholesterolLastFillDate )
	END,
	CASE WHEN @CholesterolNextFillDate  = ''
	THEN NULL
	ELSE CONVERT(DATE, @CholesterolNextFillDate)
	END,
	@CholesterolDaysSupply ,
	@CholesterolDrug ,
	@CholesterolSingleFill ,
	@PharmacyName ,
	@PharmacyAddress ,
	@PharmacyTelephoneNumber 
	,@ControllingBloodPressure 
     ,@ColorectalCancerScreening 
     ,@CardiovascularStatinUse ,
	@PatientPhone ,
	@PatientMobilePhone,
	@PcpTIN,
	@LastPcpVisitName ,
	@LastPcpVisitNPI ,
	CASE 
	WHEN @HypertensionDiagnosisDate = '' THEN NULL
	WHEN @HypertensionDiagnosisDate = 'N/A' THEN NULL
	ELSE CONVERT(DATE, 	@HypertensionDiagnosisDate)
	END,
	@ControllingBPReason ,
	CASE WHEN @DateLastBPReading = ''
	THEN NULL
	ELSE CONVERT(date, @DateLastBPReading)
	END
)
END
END


--select CONVERT(DATE, substring('altusacenetwork_StarsMemberGapsFile_2020-03-23_135317.csv',charindex('.', 'altusacenetwork_StarsMemberGapsFile_2020-03-23_135317.csv')-17,10))

--charindex('.','altusacenetwork_StarsMemberGapsFile_2020-03-02_145314.csv')-2)

--select Convert(date, '2020-03-02')