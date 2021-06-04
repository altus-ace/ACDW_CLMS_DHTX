-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportQualitySupplementalData]
 
	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	@DataDate varchar(10),
	--@CreateDate  ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100),
	@LastUpdatedDate varchar(100)
         
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
	DECLARE @FileNameDate varchar(100), @DateForFile DATE
	SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)+1,charindex('.',@SrcFileName)-1)
	SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 8))
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
    INSERT INTO [adi].[DHTX_QualitySupplementalData]
    (

	
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
)
END
END