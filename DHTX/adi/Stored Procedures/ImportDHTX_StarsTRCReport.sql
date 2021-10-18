-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert  file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_StarsTRCReport]
    @ReportDate varchar(10) ,
	@PatientName [varchar](50) ,
	@PatientID [varchar](50) ,
	@PatientDob varchar(10),
	@PatientPhone [varchar](12) ,
	@PatientMobilePhone [varchar](12) ,
	@PcpName [varchar](50) ,
	@PcpNPI [varchar](12) ,
	@PcpPracticeName [varchar](50) ,
	@PCPAddress [varchar](50) ,
	@PCPPhone [varchar](12) ,
	@PcpTIN [varchar](12) ,
	@PcpTINName [varchar](50) ,
	@AdmissionDate VARCHAR(10) ,
	@DischargeDate varchar(10) ,
	@FacilityName [varchar](50) ,
	@DateAdmissionNotification varchar(10) ,
	@DateDischargeNotification varchar(10) ,
	@MrpPatientEngagementDeadline [varchar](50) ,
	@DaysToMRPPatientEngagementDeadline varchar(10) ,
	@PatientEngagementPostDischarge [varchar](50) ,
	@PatientEngagementPostDischargeDate varchar(10) ,
	@MrpActionNeeded [varchar](50) ,
	@MrpClaimSubmitted [varchar](50) ,
	@MrpClaimServiceDate varchar(10) ,
	@MRPMedicalRecordReceived [varchar](50) ,
	@MRPMedicalRecordServiceDate varchar(10) ,
	@MRPCompletedByHealthPlan [varchar](50) ,
	@HealthPlanMRPCompletionDate varchar(10) ,
	@SrcFileName [varchar](100),
	@FileDate varchar(10),
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	BEGIN
    -- Insert statements 
    INSERT INTO adi.DHTX_StarsTRCReport
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
      ,[AdmissionDate]
      ,[DischargeDate]
      ,[FacilityName]
      ,[DateAdmissionNotification]
      ,[DateDischargeNotification]
      ,[MrpPatientEngagementDeadline]
      ,[DaysToMRPPatientEngagementDeadline]
      ,[PatientEngagementPostDischarge]
      ,[PatientEngagementPostDischargeDate]
      ,[MrpActionNeeded]
      ,[MrpClaimSubmitted]
      ,[MrpClaimServiceDate]
      ,[MRPMedicalRecordReceived]
      ,[MRPMedicalRecordServiceDate]
      ,[MRPCompletedByHealthPlan]
      ,[HealthPlanMRPCompletionDate]
      ,[SrcFileName]
      ,[FileDate]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
      

	)
		
 VALUES   (
    CASE WHEN @ReportDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @ReportDate)
	END  ,
	@PatientName  ,
	@PatientID  ,
    CASE WHEN @PatientDob  = ''
	THEN NULL
	ELSE CONVERT(DATE,@PatientDob )
	END,
	@PatientPhone  ,
	@PatientMobilePhone  ,
	@PcpName  ,
	@PcpNPI  ,
	@PcpPracticeName  ,
	@PCPAddress  ,
	@PCPPhone  ,
	@PcpTIN  ,
	@PcpTINName  ,
    CASE WHEN @AdmissionDate  = ''
	THEN NULL
	ELSE CONVERT(DATE,@AdmissionDate )
	END,	 
    CASE WHEN @DischargeDate  = ''
	THEN NULL
	ELSE CONVERT(DATE,@DischargeDate )
	END,
	@FacilityName  ,
	@DateAdmissionNotification  ,
	@DateDischargeNotification  ,
	@MrpPatientEngagementDeadline  ,
	@DaysToMRPPatientEngagementDeadline  ,
	@PatientEngagementPostDischarge  ,
	 
    CASE WHEN @PatientEngagementPostDischargeDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@PatientEngagementPostDischargeDate )
	END, 
	@MrpActionNeeded  ,
    @MrpClaimSubmitted,
    CASE WHEN @MrpClaimServiceDate  = ''
	THEN NULL
	ELSE CONVERT(DATE,@MrpClaimServiceDate )
	END, 
	@MRPMedicalRecordReceived  ,
    CASE WHEN 	@MRPMedicalRecordServiceDate = ''
	THEN NULL
	ELSE CONVERT(DATE, 	@MRPMedicalRecordServiceDate)
	END,  
	@MRPCompletedByHealthPlan  ,
    CASE WHEN @HealthPlanMRPCompletionDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @HealthPlanMRPCompletionDate)
	END,  
	@SrcFileName ,
    CASE WHEN @ReportDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @ReportDate)
	END  ,
	--@FileDate ,
	GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy  ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NULL,
	--@DataDate 
    CASE WHEN @ReportDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @ReportDate)
	END        


)
END
END

