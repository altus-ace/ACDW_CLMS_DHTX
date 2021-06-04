﻿CREATE TABLE [adi].[DHTX_RiskAdjustment] (
    [DHTXRiskAdjustmentKey]    INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]              VARCHAR (100) NULL,
    [FileDate]                 DATE          NULL,
    [CreateDate]               DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                 VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]         VARCHAR (100) NULL,
    [LastUpdatedBy]            VARCHAR (100) NULL,
    [LastUpdatedDate]          DATETIME      NULL,
    [DataDate]                 DATE          NULL,
    [ReportDate]               DATE          NULL,
    [PatientName]              VARCHAR (50)  NULL,
    [PatientID]                VARCHAR (20)  NULL,
    [PatientDob]               DATE          NULL,
    [PcpName]                  VARCHAR (50)  NULL,
    [PcpNpi]                   VARCHAR (20)  NULL,
    [Practice]                 VARCHAR (50)  NULL,
    [DateLastPcpVisit]         DATE          NULL,
    [HccCode]                  VARCHAR (20)  NULL,
    [HccDescription]           VARCHAR (50)  NULL,
    [ModelVersion]             VARCHAR (10)  NULL,
    [HccStatus]                VARCHAR (10)  NULL,
    [DiagnosisCode]            VARCHAR (10)  NULL,
    [DiagnosisDateofService]   DATE          NULL,
    [DiagnosisProviderName]    VARCHAR (50)  NULL,
    [DiagnosisProviderNpi]     VARCHAR (20)  NULL,
    [DiagnosisCodedByPcpGroup] VARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([DHTXRiskAdjustmentKey] ASC)
);

