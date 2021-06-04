-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportCapitation]
    @SrcFileName [varchar](100) ,
	@FileDate varchar(10) ,
	--[CreateDate] [datetime] NULL,
	@CreateBy varchar(100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10) ,
	@ContractId  varchar(50),
	@RunDate varchar(10) ,
	@PaymentDate varchar(10) ,
	@Mbi varchar(50) ,
	@Surname varchar(50),
	@FirstInitial varchar(50) ,
	@GenderCode [varchar](10) ,
	@BirthDate varchar(10),
	@AgeGroup [varchar](10) ,
	@StateCountyCode [varchar](10) ,
	@OoaIndicator  varchar(50),
	@PartAEntitlement varchar(50),
	@PartBEntitlement varchar(50),
	@Hospice varchar(50) ,
	@Esrd varchar(50),
	@MspFlag  varchar(50),
	@Institutional varchar(50),
	@Nhc varchar(50),
	@MedicaidStatusFlag [varchar](10),
	@LtiFlag [varchar](10) ,
	@MedicaidIndicator [varchar](10),
	@PipDgc  varchar(50),
	@DefaultRafCode  varchar(50),
	@PartARiskScore varchar(50),
	@PartBRiskScore  varchar(50),
	@NumberOfMonthsPartA [varchar](10) ,
	@NumberOfMonthsPartB [varchar](10) ,
	@AdjustmentReasonCode [varchar](10) ,
	@AdjustmentStartDate varchar(10),
	@AdjustmentEndDate varchar(10),
	@DemographicRatePartA [varchar](10) ,
	@DemographicRatePartB  varchar(19),
	@PaymentRatePartA varchar(50) ,
	@PaymentRatePartB varchar(50),
	@LisPremiumSubsidy [varchar](10) ,
	@EsrdMspFlag [varchar](10),
	@MtmAddOn [varchar](10) ,
	@MedicaidStatus [varchar](10) ,
	@Raag [varchar](10) ,
	@Prdib [varchar](10) ,
	@DeMinimis [varchar](10) ,
	@DualEnrollmentStatus [varchar](10),
	@PbpId [varchar](10) ,
	@RaceCode [varchar](10) ,
	@RafTypeCode [varchar](10),
	@FrailtyIndicator [varchar](10) ,
	@Orec [varchar](10) ,
	@LagIndicator [varchar](10) ,
	@SegmentNumber [varchar](10) ,
	@EnrollmentSource [varchar](10) ,
	@EghpFlag [varchar](10) ,
	@PartCBasicPremiumPartA [varchar](10) ,
	@PartCBasicPremiumPartB [varchar](10) ,
	@RebateForCostSharingReductionPartA [varchar](10) ,
	@RebateForCostSharingReductionPartB [varchar](10) ,
	@RebateForOtherMandatorySupplementalBenefitsPartA [varchar](10),
	@RebateForOtherMandatorySupplementalBenefitsPartB [varchar](10) ,
	@RebateForPartBPremiumReductionPartA [varchar](10) ,
	@RebateForPartBPremiumReductionPartB [varchar](10) ,
	@RebateForPartDSupplementalBenefitsPartA [varchar](10) ,
	@RebateForPartDSupplementalBenefitsPartB [varchar](10),
	@TotalPartAPayment varchar(50) ,
	@TotalPartBPayment varchar(50) ,
	@TotalMaPayment varchar(50),
	@PartDRiskScore varchar(50),
	@PartDLowIncomeIndicator [varchar](10),
	@PartDLowIncomeMultiplier [varchar](10) ,
	@PartDLtiIndicator [varchar](10) ,
	@PartDLtiMultiplier [varchar](10) ,
	@RebateForPartDBasicPremiumReduction [varchar](10) ,
	@PartDBasicPremium varchar(50),
	@PartDDirectSubsidyAmount varchar(50),
	@ReinsuranceSubsidyAmount varchar(50),
	@LisCostSharingAmount varchar(50) ,
	@TotalPartDPayment varchar(50) ,
	@NumberOfMonthsPartD [varchar](10) ,
	@PacePremiumAddOn [varchar](10) ,
	@PaceCostSharingAddOn [varchar](10) ,
	@PartCFrailtyScoreFactor [varchar](10) ,
	@MspFactor [varchar](10) ,
	@MspAdjustmentAmountPartA varchar(50),
	@MspAdjustmentAmountPartB varchar(50) ,
	@MedicaidDualStatusCode [varchar](10),
	@PartDCoverageGapDiscountAmount varchar(50),
	@PartDRafType [varchar](10) ,
	@PartDRafCode [varchar](10) ,
	@PartARiskAdjustedMonthlyRate varchar(50),
	@PartBRiskAdjustedMonthlyRate varchar(50) ,
	@PartDDirectSubsidyMonthlyRate varchar(50) ,
	@CleanupId [varchar](10) 

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
--	DECLARE @FileNameDate varchar(100), @DateForFile DATE
--	SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)+1,charindex('.',@SrcFileName)-1)
---	SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 8))
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
    INSERT INTO [adi].[DHTX_Capitation]
    (
    [SrcFileName] ,
	[FileDate] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[ContractId] ,
	[RunDate] ,
	[PaymentDate] ,
	[Mbi] ,
	[Surname] ,
	[FirstInitial] ,
	[GenderCode] ,
	[BirthDate] ,
	[AgeGroup] ,
	[StateCountyCode],
	[OoaIndicator] ,
	[PartAEntitlement] ,
	[PartBEntitlement] ,
	[Hospice] ,
	[Esrd] ,
	[MspFlag] ,
	[Institutional] ,
	[Nhc] ,
	[MedicaidStatusFlag] ,
	[LtiFlag] ,
	[MedicaidIndicator] ,
	[PipDgc] ,
	[DefaultRafCode] ,
	[PartARiskScore] ,
	[PartBRiskScore] ,
	[NumberOfMonthsPartA] ,
	[NumberOfMonthsPartB] ,
	[AdjustmentReasonCode] ,
	[AdjustmentStartDate] ,
	[AdjustmentEndDate] ,
	[DemographicRatePartA] ,
	[DemographicRatePartB] ,
	[PaymentRatePartA] ,
	[PaymentRatePartB] ,
	[LisPremiumSubsidy] ,
	[EsrdMspFlag] ,
	[MtmAddOn] ,
	[MedicaidStatus] ,
	[Raag] ,
	[Prdib] ,
	[DeMinimis] ,
	[DualEnrollmentStatus] ,
	[PbpId] ,
	[RaceCode] ,
	[RafTypeCode] ,
	[FrailtyIndicator] ,
	[Orec] ,
	[LagIndicator] ,
	[SegmentNumber] ,
	[EnrollmentSource] ,
	[EghpFlag] ,
	[PartCBasicPremiumPartA] ,
	[PartCBasicPremiumPartB] ,
	[RebateForCostSharingReductionPartA] ,
	[RebateForCostSharingReductionPartB] ,
	[RebateForOtherMandatorySupplementalBenefitsPartA] ,
	[RebateForOtherMandatorySupplementalBenefitsPartB] ,
	[RebateForPartBPremiumReductionPartA] ,
	[RebateForPartBPremiumReductionPartB] ,
	[RebateForPartDSupplementalBenefitsPartA] ,
	[RebateForPartDSupplementalBenefitsPartB] ,
	[TotalPartAPayment] ,
	[TotalPartBPayment] ,
	[TotalMaPayment] ,
	[PartDRiskScore] ,
	[PartDLowIncomeIndicator] ,
	[PartDLowIncomeMultiplier] ,
	[PartDLtiIndicator] ,
	[PartDLtiMultiplier] ,
	[RebateForPartDBasicPremiumReduction] ,
	[PartDBasicPremium] ,
	[PartDDirectSubsidyAmount] ,
	[ReinsuranceSubsidyAmount] ,
	[LisCostSharingAmount] ,
	[TotalPartDPayment] ,
	[NumberOfMonthsPartD] ,
	[PacePremiumAddOn] ,
	[PaceCostSharingAddOn] ,
	[PartCFrailtyScoreFactor] ,
	[MspFactor] ,
	[MspAdjustmentAmountPartA] ,
	[MspAdjustmentAmountPartB] ,
	[MedicaidDualStatusCode] ,
	[PartDCoverageGapDiscountAmount] ,
	[PartDRafType] ,
	[PartDRafCode] ,
	[PartARiskAdjustedMonthlyRate] ,
	[PartBRiskAdjustedMonthlyRate] ,
	[PartDDirectSubsidyMonthlyRate] ,
	[CleanupId] 

	)
		
 VALUES   (
    
    @SrcFileName ,
	@FileDate ,
	GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate ,
	@ContractId  ,
	@RunDate ,
	@PaymentDate  ,
	@Mbi  ,
	@Surname ,
	@FirstInitial ,
	@GenderCode  ,
	@BirthDate ,
	@AgeGroup  ,
	@StateCountyCode  ,
	@OoaIndicator  ,
	@PartAEntitlement ,
	@PartBEntitlement ,
	@Hospice  ,
	@Esrd ,
	@MspFlag  ,
	@Institutional ,
	@Nhc ,
	@MedicaidStatusFlag ,
	@LtiFlag  ,
	@MedicaidIndicator ,
	@PipDgc  ,
	@DefaultRafCode  ,
	@PartARiskScore ,
	@PartBRiskScore  ,
	@NumberOfMonthsPartA  ,
	@NumberOfMonthsPartB  ,
	@AdjustmentReasonCode  ,
	@AdjustmentStartDate ,
	@AdjustmentEndDate ,
	@DemographicRatePartA  ,
	@DemographicRatePartB ,
	CASE WHEN 	@PaymentRatePartA = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), 	@PaymentRatePartA)
	END ,	
	CASE WHEN @PaymentRatePartB = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @PaymentRatePartB)
	END ,	
	@LisPremiumSubsidy  ,
	@EsrdMspFlag ,
	@MtmAddOn  ,
	@MedicaidStatus  ,
	@Raag  ,
	@Prdib  ,
	@DeMinimis  ,
	@DualEnrollmentStatus  ,
	@PbpId  ,
	@RaceCode  ,
	@RafTypeCode  ,
	@FrailtyIndicator  ,
	@Orec  ,
	@LagIndicator ,
	@SegmentNumber  ,
	@EnrollmentSource  ,
	@EghpFlag  ,
	@PartCBasicPremiumPartA  ,
	@PartCBasicPremiumPartB  ,
	@RebateForCostSharingReductionPartA  ,
	@RebateForCostSharingReductionPartB  ,
	@RebateForOtherMandatorySupplementalBenefitsPartA  ,
	@RebateForOtherMandatorySupplementalBenefitsPartB  ,
	@RebateForPartBPremiumReductionPartA ,
	@RebateForPartBPremiumReductionPartB  ,
	@RebateForPartDSupplementalBenefitsPartA  ,
	@RebateForPartDSupplementalBenefitsPartB ,
	CASE WHEN @TotalPartAPayment = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @TotalPartAPayment )
	END ,
	CASE WHEN @TotalPartBPayment = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @TotalPartBPayment)
	END ,
	CASE WHEN @TotalMaPayment  = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @TotalMaPayment)
	END ,
	@PartDRiskScore ,
	@PartDLowIncomeIndicator ,
	@PartDLowIncomeMultiplier ,
	@PartDLtiIndicator  ,
	@PartDLtiMultiplier ,
    @RebateForPartDBasicPremiumReduction  ,
	CASE WHEN @PartDBasicPremium = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @PartDBasicPremium )
	END ,
	CASE WHEN @PartDDirectSubsidyAmount   = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @PartDDirectSubsidyAmount )
	END ,
	CASE WHEN @ReinsuranceSubsidyAmount  = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @ReinsuranceSubsidyAmount)
	END ,
	CASE WHEN @LisCostSharingAmount  = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @LisCostSharingAmount )
	END ,
	CASE WHEN @TotalPartDPayment = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @TotalPartDPayment)
	END ,
	@NumberOfMonthsPartD  ,
	@PacePremiumAddOn  ,
	@PaceCostSharingAddOn,
	@PartCFrailtyScoreFactor  ,
	@MspFactor ,
	CASE WHEN @MspAdjustmentAmountPartA = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @MspAdjustmentAmountPartA)
	END ,
	CASE WHEN @MspAdjustmentAmountPartB = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2),@MspAdjustmentAmountPartB)
	END ,
	@MedicaidDualStatusCode ,
	CASE WHEN @PartDCoverageGapDiscountAmount  = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2),@PartDCoverageGapDiscountAmount )
	END ,
    @PartDRafType ,
	@PartDRafCode ,
	CASE WHEN @PartARiskAdjustedMonthlyRate = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @PartARiskAdjustedMonthlyRate)
	END ,
	CASE WHEN 	@PartBRiskAdjustedMonthlyRate   = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2), @PartBRiskAdjustedMonthlyRate)
	END ,
	CASE WHEN @PartDDirectSubsidyMonthlyRate = ''
	THEN NULL
	ELSE CONVERT(decimal(18,2) , @PartDDirectSubsidyMonthlyRate)
	END ,
	@CleanupId 
)
END
END