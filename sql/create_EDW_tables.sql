-- Create dim_patients table
CREATE TABLE EDW.dim_patients (
    patient_id UNIQUEIDENTIFIER PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    date_of_birth DATE,
    gender NVARCHAR(10),
    ethnicity NVARCHAR(20),
    [address] NVARCHAR(255),
    contact_number NVARCHAR(20),
    marital_status NVARCHAR(20),
    insurance_provider NVARCHAR(50),
    insurance_policy_number NVARCHAR(20),
    emergency_contact_name NVARCHAR(50),
    emergency_contact_relationship NVARCHAR(20),
    emergency_contact_number NVARCHAR(20)
);
GO

-- Create dim_doctors table
CREATE TABLE EDW.dim_doctors (
    doctor_id UNIQUEIDENTIFIER PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    specialty NVARCHAR(50),
    contact_number NVARCHAR(20),
    email NVARCHAR(100),
    department_id INT
);
GO

-- Create dim_departments table
CREATE TABLE EDW.dim_departments (
    department_id INT PRIMARY KEY,
    department_name NVARCHAR(50),
    head_of_department NVARCHAR(50),
    contact_number NVARCHAR(20)
);
GO

-- Create dim_date table
CREATE TABLE EDW.dim_date (
    [date] DATE PRIMARY KEY,
    day_of_week NVARCHAR(10),
    [month] NVARCHAR(10),
    [quarter] NVARCHAR(10),
    [year] INT
);
GO


-- Create fact_medicalrecords table
CREATE TABLE EDW.fact_medicalrecords (
    record_id UNIQUEIDENTIFIER PRIMARY KEY,
    patient_id UNIQUEIDENTIFIER,
    doctor_id UNIQUEIDENTIFIER,
    department_id INT,
    admission_date DATE,
    discharge_date DATE,
    room_number INT,
    admission_reason NVARCHAR(255),
    diagnosis NVARCHAR(255),
    treatment_description NVARCHAR(MAX),
    prescribed_medications NVARCHAR(255),
    attending_physician NVARCHAR(100)
);
GO

-- Create fact_imagingresults table
CREATE TABLE EDW.fact_imagingresults (
    result_id UNIQUEIDENTIFIER PRIMARY KEY,
    patient_id UNIQUEIDENTIFIER,
    imaging_type NVARCHAR(50),
    imaging_date DATE,
    image_url NVARCHAR(255),
    findings NVARCHAR(MAX),
    radiologist_name NVARCHAR(50),
    imaging_equipment NVARCHAR(50),
    contrast_used NVARCHAR(5)
);
GO

-- Create fact_labresults table
CREATE TABLE EDW.fact_labresults (
    result_id UNIQUEIDENTIFIER PRIMARY KEY,
    patient_id UNIQUEIDENTIFIER,
    test_name NVARCHAR(100),
    test_date DATE,
    test_result NVARCHAR(255),
    reference_range NVARCHAR(50),
    lab_technician NVARCHAR(50),
    test_method NVARCHAR(50),
    lab_location NVARCHAR(100)
);
GO

-- Create fact_appointments table
CREATE TABLE EDW.fact_appointments (
    appointment_id UNIQUEIDENTIFIER PRIMARY KEY,
    patient_id UNIQUEIDENTIFIER,
    doctor_id UNIQUEIDENTIFIER,
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit NVARCHAR(255)
);
GO
