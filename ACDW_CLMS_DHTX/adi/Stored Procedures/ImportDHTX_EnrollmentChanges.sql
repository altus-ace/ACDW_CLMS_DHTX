﻿-- =============================================
-- Author:		Bing Yu
-- Create date: 01/11/2021
-- Description:	Insert Enrollment changes file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_EnrollmentChanges]
	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	--@CreateDate datetime ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100) ,
	--@LastUpdatedDate datetime ,
	@DataDate varchar(10) ,
    @ReportDate varchar(10) ,
    @EffectiveDate VARCHAR(10),
    @FutureChange VARCHAR(10) ,

    @MemberID VARCHAR(10) ,
    @MBI VARCHAR(50) ,
    @MemberFirstName VARCHAR(50) ,
    @MemberMiddleInitial VARCHAR(20) ,
    @MemberLastName VARCHAR(50) ,
    @MemberDOB varchar(10) ,
    @MemberAddressLine1 VARCHAR(50) ,
    @MemberAddressLine2 VARCHAR(50) ,
    @MemberCity VARCHAR(50) ,
    @MemberState VARCHAR(50) ,
    @MemberZip VARCHAR(10) ,
    @MemberPhone VARCHAR(12) ,
    @MemberMobilePhone VARCHAR(12) ,
    @MemberEmail VARCHAR(50) ,
    @PcpFirstName VARCHAR(50) ,
    @PcpLastName VARCHAR(50) ,
    @PcpNPI VARCHAR(12) ,
    @PcpPracticeName VARCHAR(50) ,
    @PCPAddress VARCHAR(50) ,
    @PCPPhone  VARCHAR(50) ,
	@PcpTIN VARCHAR(12) ,
    @PcpTINName VARCHAR(50) ,
    @DevotedPlan VARCHAR(50) ,
    @DevotedPlanName VARCHAR(50) ,
    @EnrollmentEndDate varchar(10) ,
    @DisenrollmentProcessDate DATE ,
    @DisenrollmentSourceID VARCHAR(50) ,
    @DisenrollmentPlanLeftTo VARCHAR(50) ,
    @DisenrollmentReasonCode VARCHAR(50) ,
    @DisenrollmentReason VARCHAR(50) ,
    @VoluntaryDisenrollment VARCHAR(50) 
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
 --   IF @RecordExist = 0
	--BEGIN
   -- IF (@Devoted_Member_ID != '' and @SrcFileName NOT LIKE '%DisenrollmentReport%')
	BEGIN
    -- Insert statements 
    INSERT INTO [adi].[DHTX_EnrollmentChanges]
    ( 
      
       [SrcFileName]
      ,[FileDate]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
      ,[ReportDate]
      ,[EffectiveDate]
      ,[FutureChange]
      
      ,[MemberID]
      ,[MBI]
      ,[MemberFirstName]
      ,[MemberMiddleInitial]
      ,[MemberLastName]
      ,[MemberDOB]
      ,[MemberAddressLine1]
      ,[MemberAddressLine2]
      ,[MemberCity]
      ,[MemberState]
      ,[MemberZip]
      ,[MemberPhone]
      ,[MemberMobilePhone]
      ,[MemberEmail]
      ,[PcpFirstName]
      ,[PcpLastName]
      ,[PcpNPI]
      ,[PcpPracticeName]
      ,[PCPAddress]
      ,[PCPPhone]
      ,[PcpTIN]
      ,[PcpTINName]
      ,[DevotedPlan]
      ,[DevotedPlanName]
      ,[EnrollmentEndDate]
      ,[DisenrollmentProcessDate]
      ,[DisenrollmentSourceID]
      ,[DisenrollmentPlanLeftTo]
      ,[DisenrollmentReasonCode]
      ,[DisenrollmentReason]
      ,[VoluntaryDisenrollment]
      
	)
		
 VALUES   (
 	@SrcFileName  ,
	CASE WHEN @FileDate = ''
	THEN NULL
	ELSE CONVERT(DATE,
	@FileDate)
	END  ,
	GETDATE(),
	--@CreateDate datetime ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy  ,
	GETDATE(),
	--@LastUpdatedDate datetime ,
	CASE WHEN @DataDate  = ''
	THEN NULL
	ELSE CONVERT(DATE,
	@DataDate )
	END  ,
	CASE WHEN   @ReportDate   = ''
	THEN NULL
	ELSE CONVERT(DATE,
	  @ReportDate )
	END  , 
   
    @EffectiveDate ,
    @FutureChange  ,

    @MemberID  ,
    @MBI  ,
    @MemberFirstName  ,
    @MemberMiddleInitial  ,
    @MemberLastName  ,
    CASE WHEN  @MemberDOB  = ''
	THEN NULL
	ELSE CONVERT(DATE,
	 @MemberDOB)
	END  , 
    @MemberAddressLine1  ,
    @MemberAddressLine2  ,
    @MemberCity  ,
    @MemberState  ,
    @MemberZip  ,
    @MemberPhone  ,
    @MemberMobilePhone  ,
    @MemberEmail  ,
    @PcpFirstName  ,
    @PcpLastName  ,
    @PcpNPI  ,
    @PcpPracticeName  ,
    @PCPAddress  ,
    @PCPPhone   ,
	@PcpTIN  ,
    @PcpTINName  ,
    @DevotedPlan  ,
    @DevotedPlanName  ,
    CASE WHEN @EnrollmentEndDate  = ''
	THEN NULL
	ELSE CONVERT(DATE,
	@EnrollmentEndDate )
	END  , 
    CASE WHEN @DisenrollmentProcessDate  = ''
	THEN NULL
	ELSE CONVERT(DATE,
	@DisenrollmentProcessDate)
	END  ,     
    @DisenrollmentSourceID  ,
    @DisenrollmentPlanLeftTo  ,
    @DisenrollmentReasonCode  ,
    @DisenrollmentReason  ,
    @VoluntaryDisenrollment  
 )
END
END