

-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert Hospital Census file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_StarsMemberStatus]
    @ReportDate varchar(10)  ,
	@PatientName [varchar](50)  ,
	@PatientID [varchar](50)  ,
	@PatientDob varchar(10) ,
	@PatientPhone [varchar](12)  ,
	@PatientMobilePhone [varchar](12)  ,
	@PcpName [varchar](50)  ,
	@PcpNPI [varchar](20)  ,
	@PcpPracticeName [varchar](50)  ,
	@PCPAddress [varchar](100)  ,
	@PCPPhone [varchar](12)  ,
	@PcpTIN [varchar](12)  ,
	@PcpTINName [varchar](100)  ,
	@DateLastPcpVisit varchar(10)  ,
	@LastPCPVisitName [varchar](50)  ,
	@LastPcpVisitNPI [varchar](20)  ,
    @DiabetesStatus [varchar](50)  ,
    @DiabetesRetinalScreen [varchar](50)  ,
    @DateLastEyeExam [varchar](50)  ,
    @DiabetesKidneyMonitoring [varchar](50)  ,
    @DiabetesHba1cControl [varchar](50)  ,
    @DiabetesHba1cControlReason [varchar](50)  ,
    @DateLastA1c [varchar](50)  ,
    @LastA1CValue [varchar](50)  ,
    @LastA1CSource [varchar](50)  ,
    @ControllingBloodPressure [varchar](50)  , 
    @HypertensionDiagnosisDate varchar(10)  ,
    @ControllingBPReason [varchar](50)  ,
    @DateLastBPReading varchar(10)  ,
    @LastBPReadingValue [varchar](50)  ,
    @LastBPSource [varchar](50)  ,
    @ColorectalCancerScreening  [varchar](50)  ,
    @BreastCancerScreening [varchar](50)  ,
    @COAMedicationReview [varchar](50)  ,
    @COAFunctionalStatusAssessment [varchar](50)  ,
    @COAPainAssessment [varchar](50)  ,
    @DiabetesStatinUse [varchar](50)  ,
    @CardiovascularStatinUse [varchar](50)  ,
    @OsteoporosisManagementForWomenWithFracture [varchar](50)  ,
    @OMWFractureDate varchar(10)  ,
	@SrcFileName [varchar](100)  ,
	@FileDate varchar(10)  ,
	--[CreateDate] [datetime]  ,
	@CreateBy [varchar](100)  ,
	@OriginalFileName [varchar](100)  ,
	@LastUpdatedBy [varchar](100)  ,
	--[LastUpdatedDate] [datetime]  ,
	@DataDate varchar(10)
   
         
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
    INSERT INTO [adi].[DHTX_StarsMemberStatus]
    (
	   [ReportDate]
      ,[PatientName]
      ,[PatientID]
      ,[PatientDob]
      ,[PatientPhone]
      ,[PatientMobilePhone]
      ,[PcpName]
      ,[PcpNPI]
      ,[PcpPracticeName]
      ,[PCPAddress]
      ,[PCPPhone]
      ,[PcpTIN]
      ,[PcpTINName]
      ,[DateLastPcpVisit]
      ,[LastPCPVisitName]
      ,[LastPcpVisitNPI]
      ,[DiabetesStatus]
      ,[DiabetesRetinalScreen]
      ,[DateLastEyeExam]
      ,[DiabetesKidneyMonitoring]
      ,[DiabetesHba1cControl]
      ,[DiabetesHba1cControlReason]
      ,[DateLastA1c]
      ,[LastA1CValue]
      ,[LastA1CSource]
      ,[ControllingBloodPressure]
      ,[HypertensionDiagnosisDate]
      ,[ControllingBPReason]
      ,[DateLastBPReading]
      ,[LastBPReadingValue]
      ,[LastBPSource]
      ,[ColorectalCancerScreening]
      ,[BreastCancerScreening]
      ,[COAMedicationReview]
      ,[COAFunctionalStatusAssessment]
      ,[COAPainAssessment]
      ,[DiabetesStatinUse]
      ,[CardiovascularStatinUse]
      ,[OsteoporosisManagementForWomenWithFracture]
      ,[OMWFractureDate]
      ,[SrcFileName]
      ,[FileDate]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
	  ,LoadDate

	)
		
 VALUES   (

    CASE WHEN @ReportDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@ReportDate)
	END ,
	@PatientName   ,
	@PatientID   ,
    CASE WHEN @PatientDob   = ''
	THEN NULL
	ELSE CONVERT(DATE, @PatientDob )
	END ,
	@PatientPhone  ,
	@PatientMobilePhone  ,
	@PcpName   ,
	@PcpNPI ,
	@PcpPracticeName   ,
	@PCPAddress   ,
	@PCPPhone   ,
	@PcpTIN  ,
	@PcpTINName   ,
    CASE WHEN @DateLastPcpVisit   = ''
	THEN NULL
	ELSE CONVERT(DATE, @DateLastPcpVisit )
	END ,
	@LastPCPVisitName   ,
	@LastPcpVisitNPI  ,
    @DiabetesStatus   ,
    @DiabetesRetinalScreen   ,
    @DateLastEyeExam   ,
    @DiabetesKidneyMonitoring   ,
    @DiabetesHba1cControl   ,
    @DiabetesHba1cControlReason   ,
    CASE WHEN @DateLastA1c  = ''
	THEN NULL
	ELSE CONVERT(DATE, @DateLastA1c )
	END ,
    @LastA1CValue   ,
    @LastA1CSource   ,
    @ControllingBloodPressure   ,
    CASE WHEN @HypertensionDiagnosisDate   = ''
	THEN NULL
	ELSE CONVERT(DATE, @HypertensionDiagnosisDate )
	END ,
    
    @ControllingBPReason   ,
    CASE WHEN  @DateLastBPReading = ''
	THEN NULL
	ELSE CONVERT(DATE, @DateLastBPReading)
	END ,
    @LastBPReadingValue   ,
    @LastBPSource   ,
    @ColorectalCancerScreening    ,
    @BreastCancerScreening   ,
    @COAMedicationReview   ,
    @COAFunctionalStatusAssessment   ,
    @COAPainAssessment   ,
    @DiabetesStatinUse   ,
    @CardiovascularStatinUse   ,
    @OsteoporosisManagementForWomenWithFracture   ,
     CASE WHEN 	@OMWFractureDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @OMWFractureDate)
	END ,  
	@SrcFileName   ,
    CASE WHEN 	 @ReportDate    = ''
	THEN NULL
	ELSE CONVERT(DATE, 	 @ReportDate)
	END ,	
	GETDATE(),
	--[CreateDate] [datetime]  ,
	@CreateBy   ,
	@OriginalFileName   ,
	@LastUpdatedBy   ,
	GETDATE(),
	--[LastUpdatedDate] [datetime]  ,
    CASE WHEN  @ReportDate    = ''
	THEN NULL
	ELSE CONVERT(DATE, @ReportDate )
	END ,
	DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0)
	
)
END
END



