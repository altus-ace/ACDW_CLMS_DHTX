-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_PharmacyClaims]
       @SrcFileName varchar(100)
      ,@FileDate varchar(10)
    --  ,@CreateDate varchar(100)
      ,@CreateBy varchar(50)
      ,@OriginalFileName varchar(100)
      ,@LastUpdatedBy varchar(50)
--      ,@LastUpdatedDate varchar(100)

      ,@DataDate varchar(10)
      ,@DevotedID varchar(50)
      ,@MemberFirstName varchar(20)
      ,@MemberLastName varchar(20)
      ,@MemberBirthDate varchar(10)
      ,@MemberMedicareID varchar(50)
      ,@ClaimNumber varchar(50)
      ,@DateFilled varchar(20)
      ,@DatePaid varchar(20)
      ,@TotalPaidAmount varchar(10)
      ,@MemberPaidAmount varchar(10)
      ,@PlanPaidAmount varchar(10)
      ,@PrescriberIDType varchar(10)
      ,@PrescriberID varchar(50)
      ,@PrescriberFirstName varchar(50)
      ,@PrescriberLastName varchar(20)
      ,@PrescriberAddress varchar(50)
      ,@PrescriberAddressCity varchar(20)
      ,@PrescriberAddressZip varchar(10)
      ,@PharmacyIDType varchar(10)
      ,@PharmacyID varchar(20)
      ,@PharmacyName varchar(50)
      ,@PharmacyAddressLine1 varchar(500)
      ,@PharmacyAddressLine2 varchar(50)
      ,@PharmacyAddressCity varchar(20)
      ,@PharmacyAddressState varchar(20)
      ,@PharmacyAddressZip varchar(10)
      ,@ProductNDC varchar(50)
      ,@ProductName varchar(50)
      ,@ClaimStatus varchar(10)
      ,@QuantityDispensed varchar(10)
      ,@DaysSupply varchar(10)
      ,@FormularyTier varchar(50)
      ,@FillNumber varchar(50)
      ,@NumberOfRefills varchar(10)
      ,@PcpNPI varchar(50)
      ,@PcpFirstName varchar(20)
      ,@PcpLastName varchar(10)
      ,@DevotedPCPID varchar(20)
      ,@PcpAddressLine1 varchar(500)
      ,@PcpAddressLine2 varchar(50)
      ,@PcpAddressCity varchar(20)
      ,@PcpAddressState varchar(10)
      ,@PcpAddressCounty varchar(20)
      ,@PcpAddressZip varchar(10)
	  ,@PcpGroupID varchar(20)
	  ,	@PcpPracticeName [varchar](100)
	,@PCPPhone [varchar](20) 
	,@PcpTIN [varchar](12)
	,@PcpTINName [varchar](50) 
	,@IsGenericProduct [char](1)
	,@GenericProductName [varchar](50) 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF


	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
	--DECLARE @FileNameDate varchar(100), @DateForFile DATE
	--SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)+1,charindex('.',@SrcFileName)-1)
	--SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 8))
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
    INSERT INTO [adi].[DHTX_PharmacyClaims]
    (
     [SrcFileName]
      ,[FileDate]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
	  , ReportDate
      ,[DevotedID]
      ,[MemberFirstName]
      ,[MemberLastName]
      ,[MemberBirthDate]
      ,[MemberMedicareID]
      ,[ClaimNumber]
      ,[DateFilled]
      ,[DatePaid]
      ,[TotalPaidAmount]
      ,[MemberPaidAmount]
      ,[PlanPaidAmount]
      ,[PrescriberIDType]
      ,[PrescriberID]
      ,[PrescriberFirstName]
      ,[PrescriberLastName]
      ,[PrescriberAddress]
      ,[PrescriberAddressCity]
      ,[PrescriberAddressZip]
      ,[PharmacyIDType]
      ,[PharmacyID]
      ,[PharmacyName]
      ,[PharmacyAddressLine1]
      ,[PharmacyAddressLine2]
      ,[PharmacyAddressCity]
      ,[PharmacyAddressState]
      ,[PharmacyAddressZip]
      ,[ProductNDC]
      ,[ProductName]
      ,[ClaimStatus]
      ,[QuantityDispensed]
      ,[DaysSupply]
      ,[FormularyTier]
      ,[FillNumber]
      ,[NumberOfRefills]
      ,[PcpNPI]
      ,[PcpFirstName]
      ,[PcpLastName]
      ,[DevotedPCPID]
      ,[PcpAddressLine1]
      ,[PcpAddressLine2]
      ,[PcpAddressCity]
      ,[PcpAddressState]
      ,[PcpAddressCounty]
      ,[PcpAddressZip]
      ,[PcpGroupID]
      ,[PcpPracticeName]
      ,[PCPPhone]
      ,[PcpTIN]
      ,[PcpTINName]
      ,[IsGenericProduct]
      ,[GenericProductName]
	)
		
 VALUES   (
       @SrcFileName  
      ,CONVERT(DATE,@DataDate)
	  --,@FileDate  
      ,GETDATE()
      ,@CreateBy  
      ,@OriginalFileName  
      ,@LastUpdatedBy  
      ,GETDATE()
	  ,CONVERT(DATE,@DataDate)
  --     ,CASE WHEN  = ''
	 --   THEN NULL
		--ELSE CONVERT(DATE, @DataDate) 
		--END
	 ,CONVERT(DATE,@DataDate)
      ,@DevotedID  
      ,@MemberFirstName  
      ,@MemberLastName  
      ,CASE WHEN @MemberBirthDate = ''
	   THEN NULL
	   ELSE CONVERT(DATE, @MemberBirthDate) 
	   END
      ,@MemberMedicareID  
      ,@ClaimNumber  
      ,CASE WHEN @DateFilled  = ''
	   THEN NULL
	   ELSE CONVERT(DATE, @DateFilled ) 
	   END
      ,CASE WHEN @DatePaid = ''
	   THEN NULL
	   ELSE CONVERT(DATE,@DatePaid ) 
	   END
      ,CASE WHEN @TotalPaidAmount = ''
	   THEN NULL
	   ELSE CONVERT(numeric(18,2),@TotalPaidAmount) 
	   END
      ,CASE WHEN @MemberPaidAmount = ''
	   THEN NULL
	   ELSE CONVERT(numeric(18,2), @MemberPaidAmount) 
	   END
      ,CASE WHEN @PlanPaidAmount  = ''
	   THEN NULL
	   ELSE CONVERT(numeric(18,2), @PlanPaidAmount) 
	   END
      ,@PrescriberIDType  
      ,@PrescriberID  
      ,@PrescriberFirstName  
      ,@PrescriberLastName  
      ,@PrescriberAddress  
      ,@PrescriberAddressCity  
      ,@PrescriberAddressZip  
      ,@PharmacyIDType  
      ,@PharmacyID  
      ,@PharmacyName  
      ,@PharmacyAddressLine1  
      ,@PharmacyAddressLine2  
      ,@PharmacyAddressCity  
      ,@PharmacyAddressState  
      ,@PharmacyAddressZip  
      ,@ProductNDC  
      ,@ProductName  
      ,@ClaimStatus  
      ,CASE WHEN @QuantityDispensed = ''
	   THEN NULL
	   ELSE CONVERT(decimal(5,2), @QuantityDispensed) 
	   END
      ,CASE WHEN @DaysSupply = ''
	   THEN NULL
	   ELSE CONVERT(INT, @DaysSupply) 
	   END	     
      ,@FormularyTier  
      ,@FillNumber 
      ,CASE WHEN @NumberOfRefills  = ''
	   THEN NULL
	   ELSE CONVERT(INT,@NumberOfRefills) 
	   END		   
      ,@PcpNPI  
      ,@PcpFirstName  
      ,@PcpLastName  
      ,@DevotedPCPID  
      ,@PcpAddressLine1  
      ,@PcpAddressLine2  
      ,@PcpAddressCity  
      ,@PcpAddressState  
      ,@PcpAddressCounty  
      ,@PcpAddressZip 
	  ,@PcpGroupID  
	  	  ,	@PcpPracticeName 
	,@PCPPhone 
	,@PcpTIN 
	,@PcpTINName 
	,@IsGenericProduct 
	,@GenericProductName 
)
END
END