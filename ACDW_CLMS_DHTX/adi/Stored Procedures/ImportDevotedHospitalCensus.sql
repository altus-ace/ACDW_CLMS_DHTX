
-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert Hospital Census file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDevotedHospitalCensus]
 	@SrcFileName varchar (100)  ,
	@FileDate varchar(10)  ,
--	@CreateDate datetime   ,
	@CreateBy varchar (100)  ,
	@OriginalFileName varchar (100)  ,
	@LastUpdatedBy varchar (100)  ,
	--@LastUpdatedDate datetime   ,
	@DataDate varchar(10)   ,
	@ReportDate varchar(10),
	@DevotedID varchar (50)  ,
	@AuthorizationNumber varchar (50)  ,
	@MBI varchar (50)  ,
	@MemberFirstName varchar (50)  ,
	@MemberMiddleInitial varchar (20)  ,
	@MemberLastName varchar (50)  ,
	@MemberDOB varchar(10)   ,
	@PcpName varchar (50)  ,
	@PcpNPI varchar (15)  ,
	@PcpPracticeName varchar (20)  ,
	@PCPAddress varchar (100)  ,
	@PCPPhone varchar (20)  ,
	@PcpTIN varchar (20)  ,
	@PcpTINName varchar (50)  ,
	@AdmissionLevelofCare varchar (20)  ,
	@AdmissionDate varchar(10)   ,
	@AdmissionDiagnosis varchar (1000)  ,
	@AdmissionDiagnosisDescription varchar (5000)  ,
	@FacilityName varchar (100)  ,
	@FacilityNPI varchar (20)  ,
	@DischargeDate varchar(10)  ,
	@DischargeDiagnosis varchar (100)  ,
	@DischargeDisposition varchar (50)  ,
	@AuthorizationRequestReceivedDate varchar(10)   ,
	@RequestingProviderFacilityNPI varchar (20)  ,
	@RequestingProviderFacilityName varchar (20)  ,
	@CensusSource varchar (20)  ,
	@OtherAuthorizations varchar (20)  ,
	@ClaimNumbers varchar (500)  
   
         
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
    INSERT INTO [adi].[DHTX_HospitalCensus]
    (
	   [SrcFileName]
      ,[FileDate]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
	  ,ReportDate
      ,[DevotedID]
      ,[AuthorizationNumber]
      ,[MBI]
      ,[MemberFirstName]
      ,[MemberMiddleInitial]
      ,[MemberLastName]
      ,[MemberDOB]
      ,[PcpName]
      ,[PcpNPI]
      ,[PcpPracticeName]
      ,[PCPAddress]
      ,[PCPPhone]
      ,[PcpTIN]
      ,[PcpTINName]
      ,[AdmissionLevelofCare]
      ,[AdmissionDate]
      ,[AdmissionDiagnosis]
      ,[AdmissionDiagnosisDescription]
      ,[FacilityName]
      ,[FacilityNPI]
      ,[DischargeDate]
      ,[DischargeDiagnosis]
      ,[DischargeDisposition]
      ,[AuthorizationRequestReceivedDate]
      ,[RequestingProviderFacilityNPI]
      ,[RequestingProviderFacilityName]
      ,[CensusSource]
      ,[OtherAuthorizations]
      ,[ClaimNumbers]
      

	)
		
 VALUES   (

    @SrcFileName ,
	CASE WHEN @ReportDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@ReportDate)
	END   ,
    GETDATE(),	
	--@Create,
	@CreateBy   ,
	@OriginalFileName   ,
	@LastUpdatedBy   ,
	GETDATE(),
	--@LastUpd time   ,
	CASE WHEN @ReportDate   = ''
	THEN NULL
	ELSE CONVERT(DATE,@ReportDate)
	END   ,
	CASE WHEN @ReportDate   = ''
	THEN NULL
	ELSE CONVERT(DATE,@ReportDate)
	END   ,	
	@DevotedID   ,
	@AuthorizationNumber   ,
	@MBI   ,
	@MemberFirstName   ,
	@MemberMiddleInitial   ,
	@MemberLastName   ,
	CASE WHEN @MemberDOB    = ''
	THEN NULL
	ELSE CONVERT(DATE, @MemberDOB )
	END   ,	
	@PcpName   ,
	@PcpNPI ,
	@PcpPracticeName   ,
	@PCPAddress   ,
	@PCPPhone   ,
	@PcpTIN   ,
	@PcpTINName   ,
	@AdmissionLevelofCare   ,
	CASE WHEN @AdmissionDate   = ''
	THEN NULL
	ELSE CONVERT(DATE, @AdmissionDate)
	END   ,	
	@AdmissionDiagnosis   ,
	@AdmissionDiagnosisDescription   ,
	@FacilityName   ,
	@FacilityNPI   ,
	CASE WHEN @DischargeDate   = ''
	THEN NULL
	ELSE CONVERT(DATE, @DischargeDate)
	END   ,
	@DischargeDiagnosis   ,
	@DischargeDisposition   ,
	CASE WHEN @AuthorizationRequestReceivedDate   = ''
	THEN NULL
	ELSE CONVERT(DATE, @AuthorizationRequestReceivedDate )
	END   ,
	@RequestingProviderFacilityNPI   ,
	@RequestingProviderFacilityName   ,
	@CensusSource   ,
	@OtherAuthorizations   ,
	@ClaimNumbers   
    

	---@LastUpdatedDate
/**
	@SrcFileName ,
	@DateForFile,
	--CASE WHEN 	@FileDate  = ''
	--then NULL
	--Else CONVERT(date, 	@FileDate)
	--END ,
	--CASE WHEN 	@DataDate  = ''
	--then NULL
	--Else CONVERT(date, 	@DataDate)
	--END ,
	@DateForFile,
	GETDATE(),
	--@CreateDate  ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy ,
	GETDATE()
	--@LastUpdatedDate 
	**/
)
END
END


