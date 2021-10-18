-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportCensus]
 	
    @DevotedMemberID varchar(50),
	@EpisodeID varchar(50),
	@MBI_HICN varchar(10) ,
	@MemberFirstName varchar(20),
	@MemberMiddleInitial varchar(20),
	@MemberLastName varchar(20),
	@MemberDateOfBirth varchar(12),
	@CurrentlyAssignedGroup varchar(10),
	@PCP_NPI varchar(20),
	@PCPName varchar(50) ,
	@PCPCounty varchar(20),
	@Devoted_PCP_ID varchar(20) ,
	@AdmissionLevelCare varchar(10),
	@AdmissionDate varchar(12),
	@DischargeDate varchar(12),
	@FacilityName varchar(50) ,
	@FacilityNPI varchar(50),
	@Diagnosis varchar(10),
	@PatientComplaint varchar(1000) ,
	@AuthNumbe varchar(20) ,
	@AuthorizationRequestReceivedDate varchar(12),
	@RequestingProvider_FacilityNPI varchar(20),
	@RequestingProvider_FacilityName varchar(100) ,	
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
    INSERT INTO [adi].[DHTX_Census]
    (
	[DevotedMemberID],
	[EpisodeID] ,
	[MBI_HICN] ,
	[MemberFirstName] ,
	[MemberMiddleInitial] ,
	[MemberLastName],
	[MemberDateOfBirth] ,
	[CurrentlyAssignedGroup] ,
	[PCP_NPI] ,
	[PCPName] ,
	[PCPCounty] ,
	[Devoted_PCP_ID] ,
	[AdmissionLevelCare] ,
	[AdmissionDate],
	[DischargeDate] ,
	[FacilityName] ,
	[FacilityNPI] ,
	[Diagnosis] ,
	[PatientComplaint] ,
	[AuthNumbe] ,
	[AuthorizationRequestReceivedDate],
	[RequestingProvider_FacilityNPI] ,
	[RequestingProvider_FacilityName] ,
	[SrcFileName] ,
	[FileDate] ,
	[DataDate],
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] 

	)
		
 VALUES   (
    
	@DevotedMemberID ,
	@EpisodeID ,
	@MBI_HICN  ,
	@MemberFirstName ,
	@MemberMiddleInitial ,
	@MemberLastName ,
	CASE WHEN @MemberDateOfBirth = ''
	THEN NULL
	ELSE CONVERT(DATE, @MemberDateOfBirth)
	END,
	@CurrentlyAssignedGroup ,
	@PCP_NPI ,
	@PCPName  ,
	@PCPCounty ,
	@Devoted_PCP_ID ,
	@AdmissionLevelCare ,
	CASE WHEN @AdmissionDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @AdmissionDate)
	END,
	CASE WHEN @DischargeDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DischargeDate)
	END,
	@FacilityName ,
	@FacilityNPI ,
	@Diagnosis ,
	@PatientComplaint  ,
	@AuthNumbe ,
	CASE WHEN @AuthorizationRequestReceivedDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@AuthorizationRequestReceivedDate) 
	END,
	@RequestingProvider_FacilityNPI ,
	@RequestingProvider_FacilityName  ,	
	@SrcFileName  ,
	-- altusacenetwork_HospitalCensus_2021-01-01.csv
	CONVERT(DATE, @FileDate),
	--@FileDate ,
	CONVERT(DATE, @DataDate),
	--@DataDate ,
	GETDATE(),
	--@CreateDate  ,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE()
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

