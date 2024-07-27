SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- appointments
CREATE TABLE [STG].[appointments_data](
	[appointment_id] [nvarchar](max) NULL,
	[patient_id] [nvarchar](max) NULL,
	[doctor_id] [nvarchar](max) NULL,
	[appointment_date] [nvarchar](max) NULL,
	[appointment_time] [nvarchar](max) NULL,
	[reason_for_visit] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- departments
CREATE TABLE [STG].[departments_data](
	[department_id] [nvarchar](max) NULL,
	[department_name] [nvarchar](max) NULL,
	[head_of_department] [nvarchar](max) NULL,
	[contact_number] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- doctors
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[doctors_data](
	[doctor_id] [nvarchar](max) NULL,
	[first_name] [nvarchar](max) NULL,
	[last_name] [nvarchar](max) NULL,
	[specialty] [nvarchar](max) NULL,
	[contact_number] [nvarchar](max) NULL,
	[email] [nvarchar](max) NULL,
	[department_id] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- imaging results
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[imaging_results_data](
	[result_id] [nvarchar](max) NULL,
	[patient_id] [nvarchar](max) NULL,
	[imaging_type] [nvarchar](max) NULL,
	[imaging_date] [nvarchar](max) NULL,
	[image_url] [nvarchar](max) NULL,
	[findings] [nvarchar](max) NULL,
	[radiologist_name] [nvarchar](max) NULL,
	[imaging_equipment] [nvarchar](max) NULL,
	[contrast_used] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- lab results
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[lab_results_data](
	[result_id] [nvarchar](max) NULL,
	[patient_id] [nvarchar](max) NULL,
	[test_name] [nvarchar](max) NULL,
	[test_date] [nvarchar](max) NULL,
	[test_result] [nvarchar](max) NULL,
	[reference_range] [nvarchar](max) NULL,
	[lab_technician] [nvarchar](max) NULL,
	[test_method] [nvarchar](max) NULL,
	[lab_location] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
-- medical records

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[medical_records_data](
	[record_id] [nvarchar](max) NULL,
	[patient_id] [nvarchar](max) NULL,
	[admission_date] [nvarchar](max) NULL,
	[discharge_date] [nvarchar](max) NULL,
	[diagnosis] [nvarchar](max) NULL,
	[treatment_description] [nvarchar](max) NULL,
	[prescribed_medications] [nvarchar](max) NULL,
	[attending_physician] [nvarchar](max) NULL,
	[department_id] [nvarchar](max) NULL,
	[room_number] [nvarchar](max) NULL,
	[admission_reason] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
-- trial participants

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[participants_data](
	[participant_id] [nvarchar](max) NULL,
	[trial_id] [nvarchar](max) NULL,
	[patient_id] [nvarchar](max) NULL,
	[enrollment_date] [nvarchar](max) NULL,
	[participant_status] [nvarchar](max) NULL,
	[consent_date] [nvarchar](max) NULL,
	[withdrawal_date] [nvarchar](max) NULL,
	[withdrawal_reason] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
-- patients
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[patients_data](
	[patient_id] [nvarchar](max) NULL,
	[first_name] [nvarchar](max) NULL,
	[last_name] [nvarchar](max) NULL,
	[date_of_birth] [nvarchar](max) NULL,
	[gender] [nvarchar](max) NULL,
	[ethnicity] [nvarchar](max) NULL,
	[address] [nvarchar](max) NULL,
	[contact_number] [nvarchar](max) NULL,
	[marital_status] [nvarchar](max) NULL,
	[insurance_provider] [nvarchar](max) NULL,
	[insurance_policy_number] [nvarchar](max) NULL,
	[emergency_contact_name] [nvarchar](max) NULL,
	[emergency_contact_relationship] [nvarchar](max) NULL,
	[emergency_contact_number] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- trials

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[trials_data](
	[trial_id] [nvarchar](max) NULL,
	[trial_name] [nvarchar](max) NULL,
	[principal_investigator] [nvarchar](max) NULL,
	[start_date] [nvarchar](max) NULL,
	[end_date] [nvarchar](max) NULL,
	[trial_description] [nvarchar](max) NULL,
	[funding_source] [nvarchar](max) NULL,
	[trial_phase] [nvarchar](max) NULL,
	[ethical_approval_number] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

