﻿CREATE TABLE [adi].[DHTX_Capitation] (
    [DHTXCapitationKey]                                INT             IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                                      VARCHAR (100)   NULL,
    [FileDate]                                         DATE            NULL,
    [CreateDate]                                       DATETIME        DEFAULT (sysdatetime()) NULL,
    [CreateBy]                                         VARCHAR (100)   DEFAULT (suser_sname()) NULL,
    [OriginalFileName]                                 VARCHAR (100)   NULL,
    [LastUpdatedBy]                                    VARCHAR (100)   NULL,
    [LastUpdatedDate]                                  DATETIME        NULL,
    [DataDate]                                         DATE            NULL,
    [ContractId]                                       VARCHAR (50)    NULL,
    [RunDate]                                          DATE            NULL,
    [PaymentDate]                                      DATE            NULL,
    [Mbi]                                              VARCHAR (50)    NULL,
    [Surname]                                          VARCHAR (50)    NULL,
    [FirstInitial]                                     VARCHAR (50)    NULL,
    [GenderCode]                                       VARCHAR (10)    NULL,
    [BirthDate]                                        DATE            NULL,
    [AgeGroup]                                         VARCHAR (10)    NULL,
    [StateCountyCode]                                  VARCHAR (10)    NULL,
    [OoaIndicator]                                     VARCHAR (50)    NULL,
    [PartAEntitlement]                                 VARCHAR (50)    NULL,
    [PartBEntitlement]                                 VARCHAR (50)    NULL,
    [Hospice]                                          VARCHAR (50)    NULL,
    [Esrd]                                             VARCHAR (50)    NULL,
    [MspFlag]                                          VARCHAR (50)    NULL,
    [Institutional]                                    VARCHAR (50)    NULL,
    [Nhc]                                              VARCHAR (50)    NULL,
    [MedicaidStatusFlag]                               VARCHAR (10)    NULL,
    [LtiFlag]                                          VARCHAR (10)    NULL,
    [MedicaidIndicator]                                VARCHAR (10)    NULL,
    [PipDgc]                                           VARCHAR (50)    NULL,
    [DefaultRafCode]                                   VARCHAR (50)    NULL,
    [PartARiskScore]                                   VARCHAR (50)    NULL,
    [PartBRiskScore]                                   VARCHAR (50)    NULL,
    [NumberOfMonthsPartA]                              VARCHAR (10)    NULL,
    [NumberOfMonthsPartB]                              VARCHAR (10)    NULL,
    [AdjustmentReasonCode]                             VARCHAR (10)    NULL,
    [AdjustmentStartDate]                              DATE            NULL,
    [AdjustmentEndDate]                                DATE            NULL,
    [DemographicRatePartA]                             VARCHAR (10)    NULL,
    [DemographicRatePartB]                             VARCHAR (19)    NULL,
    [PaymentRatePartA]                                 DECIMAL (18, 2) NULL,
    [PaymentRatePartB]                                 DECIMAL (18, 2) NULL,
    [LisPremiumSubsidy]                                VARCHAR (10)    NULL,
    [EsrdMspFlag]                                      VARCHAR (10)    NULL,
    [MtmAddOn]                                         VARCHAR (10)    NULL,
    [MedicaidStatus]                                   VARCHAR (10)    NULL,
    [Raag]                                             VARCHAR (10)    NULL,
    [Prdib]                                            VARCHAR (10)    NULL,
    [DeMinimis]                                        VARCHAR (10)    NULL,
    [DualEnrollmentStatus]                             VARCHAR (10)    NULL,
    [PbpId]                                            VARCHAR (10)    NULL,
    [RaceCode]                                         VARCHAR (10)    NULL,
    [RafTypeCode]                                      VARCHAR (10)    NULL,
    [FrailtyIndicator]                                 VARCHAR (10)    NULL,
    [Orec]                                             VARCHAR (10)    NULL,
    [LagIndicator]                                     VARCHAR (10)    NULL,
    [SegmentNumber]                                    VARCHAR (10)    NULL,
    [EnrollmentSource]                                 VARCHAR (10)    NULL,
    [EghpFlag]                                         VARCHAR (10)    NULL,
    [PartCBasicPremiumPartA]                           VARCHAR (10)    NULL,
    [PartCBasicPremiumPartB]                           VARCHAR (10)    NULL,
    [RebateForCostSharingReductionPartA]               VARCHAR (10)    NULL,
    [RebateForCostSharingReductionPartB]               VARCHAR (10)    NULL,
    [RebateForOtherMandatorySupplementalBenefitsPartA] VARCHAR (10)    NULL,
    [RebateForOtherMandatorySupplementalBenefitsPartB] VARCHAR (10)    NULL,
    [RebateForPartBPremiumReductionPartA]              VARCHAR (10)    NULL,
    [RebateForPartBPremiumReductionPartB]              VARCHAR (10)    NULL,
    [RebateForPartDSupplementalBenefitsPartA]          VARCHAR (10)    NULL,
    [RebateForPartDSupplementalBenefitsPartB]          VARCHAR (10)    NULL,
    [TotalPartAPayment]                                DECIMAL (18, 2) NULL,
    [TotalPartBPayment]                                DECIMAL (18, 2) NULL,
    [TotalMaPayment]                                   DECIMAL (18, 2) NULL,
    [PartDRiskScore]                                   VARCHAR (10)    NULL,
    [PartDLowIncomeIndicator]                          VARCHAR (10)    NULL,
    [PartDLowIncomeMultiplier]                         VARCHAR (10)    NULL,
    [PartDLtiIndicator]                                VARCHAR (10)    NULL,
    [PartDLtiMultiplier]                               VARCHAR (10)    NULL,
    [RebateForPartDBasicPremiumReduction]              VARCHAR (10)    NULL,
    [PartDBasicPremium]                                DECIMAL (18, 2) NULL,
    [PartDDirectSubsidyAmount]                         DECIMAL (18, 2) NULL,
    [ReinsuranceSubsidyAmount]                         DECIMAL (18, 2) NULL,
    [LisCostSharingAmount]                             DECIMAL (18, 2) NULL,
    [TotalPartDPayment]                                DECIMAL (18, 2) NULL,
    [NumberOfMonthsPartD]                              VARCHAR (10)    NULL,
    [PacePremiumAddOn]                                 VARCHAR (10)    NULL,
    [PaceCostSharingAddOn]                             VARCHAR (10)    NULL,
    [PartCFrailtyScoreFactor]                          VARCHAR (10)    NULL,
    [MspFactor]                                        VARCHAR (10)    NULL,
    [MspAdjustmentAmountPartA]                         DECIMAL (18, 2) NULL,
    [MspAdjustmentAmountPartB]                         DECIMAL (18, 2) NULL,
    [MedicaidDualStatusCode]                           VARCHAR (10)    NULL,
    [PartDCoverageGapDiscountAmount]                   DECIMAL (18, 2) NULL,
    [PartDRafType]                                     VARCHAR (10)    NULL,
    [PartDRafCode]                                     VARCHAR (10)    NULL,
    [PartARiskAdjustedMonthlyRate]                     DECIMAL (18, 2) NULL,
    [PartBRiskAdjustedMonthlyRate]                     DECIMAL (18, 2) NULL,
    [PartDDirectSubsidyMonthlyRate]                    DECIMAL (18, 2) NULL,
    [CleanupId]                                        VARCHAR (10)    NULL,
    PRIMARY KEY CLUSTERED ([DHTXCapitationKey] ASC)
);

