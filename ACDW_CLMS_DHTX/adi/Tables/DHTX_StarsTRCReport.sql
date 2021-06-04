﻿CREATE TABLE [adi].[DHTX_StarsTRCReport] (
    [StarsTRCReportKey]                  INT           IDENTITY (1, 1) NOT NULL,
    [ReportDate]                         DATE          NULL,
    [PatientName]                        VARCHAR (50)  NULL,
    [PatientID]                          VARCHAR (50)  NULL,
    [PatientDob]                         DATE          NULL,
    [PatientPhone]                       VARCHAR (12)  NULL,
    [PatientMobilePhone]                 VARCHAR (12)  NULL,
    [PcpName]                            VARCHAR (50)  NULL,
    [PcpNPI]                             VARCHAR (12)  NULL,
    [PcpPracticeName]                    VARCHAR (50)  NULL,
    [PCPAddress]                         VARCHAR (50)  NULL,
    [PCPPhone]                           VARCHAR (12)  NULL,
    [PcpTIN]                             VARCHAR (12)  NULL,
    [PcpTINName]                         VARCHAR (50)  NULL,
    [AdmissionDate]                      DATE          NULL,
    [DischargeDate]                      DATE          NULL,
    [FacilityName]                       VARCHAR (50)  NULL,
    [DateAdmissionNotification]          DATE          NULL,
    [DateDischargeNotification]          DATE          NULL,
    [MrpPatientEngagementDeadline]       VARCHAR (50)  NULL,
    [DaysToMRPPatientEngagementDeadline] VARCHAR (10)  NULL,
    [PatientEngagementPostDischarge]     VARCHAR (50)  NULL,
    [PatientEngagementPostDischargeDate] DATE          NULL,
    [MrpActionNeeded]                    VARCHAR (50)  NULL,
    [MrpClaimSubmitted]                  VARCHAR (50)  NULL,
    [MrpClaimServiceDate]                DATE          NULL,
    [MRPMedicalRecordReceived]           VARCHAR (50)  NULL,
    [MRPMedicalRecordServiceDate]        DATE          NULL,
    [MRPCompletedByHealthPlan]           VARCHAR (50)  NULL,
    [HealthPlanMRPCompletionDate]        DATE          NULL,
    [SrcFileName]                        VARCHAR (100) NULL,
    [FileDate]                           DATE          NULL,
    [CreateDate]                         DATETIME      DEFAULT (sysdatetime()) NULL,
    [CreateBy]                           VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [OriginalFileName]                   VARCHAR (100) NULL,
    [LastUpdatedBy]                      VARCHAR (100) DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]                    DATETIME      DEFAULT (sysdatetime()) NULL,
    [DataDate]                           DATE          NULL,
    [Status]                             CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([StarsTRCReportKey] ASC)
);

