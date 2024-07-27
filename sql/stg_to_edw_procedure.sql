CREATE PROCEDURE STG.load_data_to_edw_procedure
AS
BEGIN
    -- Declare variables for procedure logs
    DECLARE @v_runtime DATETIME;
    DECLARE @v_status NVARCHAR(10);
    DECLARE @v_error_msg NVARCHAR(MAX);

    -- Set default values for declared variables
    SET @v_runtime = GETDATE();
    SET @v_status = 'SUCCESS';
    SET @v_error_msg = NULL;

    BEGIN TRY
        -- Log the start of the procedure execution
        INSERT INTO STG.procedure_logs (runtime, status, error_msg)
        VALUES (@v_runtime, 'START', 'Procedure execution started');

        -- Load data into dim_patients
        INSERT INTO EDW.dim_patients (
            patient_id,
            first_name,
            last_name,
            date_of_birth,
            gender,
            ethnicity,
            [address],
            contact_number,
            marital_status,
            insurance_provider,
            insurance_policy_number,
            emergency_contact_name,
            emergency_contact_relationship,
            emergency_contact_number
        )
        SELECT
            CAST(patient_id AS UNIQUEIDENTIFIER),
            first_name,
            last_name,
            CONVERT(DATE, date_of_birth, 103),
            gender,
            ethnicity,
            [address],
            contact_number,
            marital_status,
            insurance_provider,
            insurance_policy_number,
            emergency_contact_name,
            emergency_contact_relationship,
            emergency_contact_number
        FROM STG.patients_data;

        -- Load data into dim_doctors
        INSERT INTO EDW.dim_doctors (
            doctor_id,
            first_name,
            last_name,
            specialty,
            contact_number,
            email,
            department_id
        )
        SELECT
            CAST(doctor_id AS UNIQUEIDENTIFIER),
            first_name,
            last_name,
            specialty,
            contact_number,
            email,
            CAST(department_id AS INT)
        FROM STG.doctors_data;

        -- Load data into dim_departments
        INSERT INTO EDW.dim_departments (
            department_id,
            department_name,
            head_of_department,
            contact_number
        )
        SELECT
            CAST(department_id AS INT),
            department_name,
            head_of_department,
            contact_number
        FROM STG.departments_data;

        -- Create a Date CTE for loading dim_date
        WITH DATES_CTE AS
        (
            SELECT DISTINCT
                CONVERT(DATE, appointment_date, 103) AS [date],
                DATENAME(WEEKDAY, CONVERT(DATE, appointment_date, 103)) AS day_of_week,
                DATENAME(MONTH, CONVERT(DATE, appointment_date, 103)) AS [month],
                CASE
                    WHEN MONTH(CONVERT(DATE, appointment_date, 103)) IN (1, 2, 3) THEN 'Q1'
                    WHEN MONTH(CONVERT(DATE, appointment_date, 103)) IN (4, 5, 6) THEN 'Q2'
                    WHEN MONTH(CONVERT(DATE, appointment_date, 103)) IN (7, 8, 9) THEN 'Q3'
                    ELSE 'Q4'
                END AS [quarter],
                YEAR(CONVERT(DATE, appointment_date, 103)) AS [year]
            FROM STG.appointments_data
        )
        INSERT INTO EDW.dim_date (
            [date],
            day_of_week,
            [month],
            [quarter],
            [year]
        )
        SELECT
            [date],
            day_of_week,
            [month],
            [quarter],
            [year]
        FROM DATES_CTE;

        -- Load data into fact_medicalrecords
        INSERT INTO EDW.fact_medicalrecords (
            record_id,
            patient_id,
            department_id,
            admission_date,
            discharge_date,
            room_number,
            admission_reason,
            diagnosis,
            treatment_description,
            prescribed_medications,
            attending_physician
        )
        SELECT
            CAST(record_id AS UNIQUEIDENTIFIER),
            CAST(patient_id AS UNIQUEIDENTIFIER),
            CAST(department_id AS INT),
            CONVERT(DATE, admission_date, 103),
            CONVERT(DATE, discharge_date, 103),
            CAST(room_number AS INT),
            admission_reason,
            diagnosis,
            treatment_description,
            prescribed_medications,
            attending_physician
        FROM STG.medical_records_data;

        -- Load data into fact_imagingresults
        WITH IMAGING_CTE AS
        (
            SELECT
                ROW_NUMBER() OVER (ORDER BY imaging_type) AS imaging_key,
                result_id,
                patient_id,
                imaging_type,
                imaging_date,
                image_url,
                findings,
                radiologist_name,
                imaging_equipment,
                contrast_used
            FROM STG.imaging_results_data
        )
        INSERT INTO EDW.fact_imagingresults (
            result_id,
            patient_id,
            imaging_type,
            imaging_date,
            image_url,
            findings,
            radiologist_name,
            imaging_equipment,
            contrast_used
        )
        SELECT
            CAST(result_id AS UNIQUEIDENTIFIER),
            CAST(patient_id AS UNIQUEIDENTIFIER),
            imaging_type,
            CONVERT(DATE, imaging_date, 103),
            image_url,
            findings,
            radiologist_name,
            imaging_equipment,
            CAST(contrast_used AS NVARCHAR(5))
        FROM IMAGING_CTE;

        -- Load data into fact_labresults
        INSERT INTO EDW.fact_labresults (
            result_id,
            patient_id,
            test_name,
            test_date,
            test_result,
            reference_range,
            lab_technician,
            test_method,
            lab_location
        )
        SELECT
            CAST(result_id AS UNIQUEIDENTIFIER),
            CAST(patient_id AS UNIQUEIDENTIFIER),
            test_name,
            CONVERT(DATE, test_date, 103),
            test_result,
            reference_range,
            lab_technician,
            test_method,
            lab_location
        FROM STG.lab_results_data;

        -- Load data into fact_appointments
        INSERT INTO EDW.fact_appointments (
            appointment_id,
            patient_id,
            doctor_id,
            appointment_date,
            appointment_time,
            reason_for_visit
        )
        SELECT
            CAST(appointment_id AS UNIQUEIDENTIFIER),
            CAST(patient_id AS UNIQUEIDENTIFIER),
            CAST(doctor_id AS UNIQUEIDENTIFIER),
            CONVERT(DATE, appointment_date, 103),
            CONVERT(TIME, appointment_time),
            reason_for_visit
        FROM STG.appointments_data;

        -- Log the successful completion of the procedure
        INSERT INTO STG.procedure_logs (runtime, status, error_msg)
        VALUES (@v_runtime, @v_status, 'Procedure executed successfully');
    END TRY
    BEGIN CATCH
        -- Capture and handle the exception
        SET @v_status = 'FAILED';
        SET @v_error_msg = ERROR_MESSAGE();

        -- Log the failure of the procedure
        INSERT INTO STG.procedure_logs (runtime, status, error_msg)
        VALUES (@v_runtime, @v_status, @v_error_msg);
    END CATCH
END
GO
