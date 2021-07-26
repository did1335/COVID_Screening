/*USE SQLSERV;
GO
-- 條件限制
ALTER TABLE patient ADD CHECK (born BETWEEN 1880 AND Datename(year,GetDate()));

-- 觸發程序
CREATE TRIGGER PATIENT_DEL ON patient
AFTER DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO release select * from deleted;
    END
    ELSE
        BEGIN
            ROLLBACK;
            THROW 50001, 'Cannot delete', 1;
        END
END;

-- 預存程序
CREATE PROCEDURE findhospital
@patient_name nvarchar(50)
AS
SELECT patient,hospital,distance_km FROM ranking WHERE (patient=@patient_name) AND (rn=1);

CREATE PROCEDURE hospital_sum
@hospital_name nvarchar(100)
AS
SELECT hospital,COUNT(patient) AS sum FROM ranking 
WHERE (hospital=@hospital_name) AND (rn=1) 
GROUP BY hospital;
*/

-- 解隔離名單(觸發程序測試)
/*INSERT INTO patient values ('45',N'解隔離1',1969,3,120.98,23.5)
DELETE FROM patient WHERE id='45';*/
SELECT * FROM release;
-- 距離病人最近的醫院
SELECT hospital,patient,distance_km FROM ranking WHERE rn=1 
ORDER BY hospital ASC, patient ASC;
-- 各醫院患者人數
SELECT hospital,COUNT(patient) AS pat_num  FROM ranking WHERE rn=1  
GROUP BY hospital
ORDER BY hospital ASC;
-- 病患查詢最近的指定醫院及其公里數(使用預存程序)
EXEC findhospital N'Nick';
-- 指定醫院採檢人數統計(使用預存程序)
EXEC hospital_sum N'Lienchiang County Hospital'
