-- DRUG DATABASE
-- Tebles: Doctor, Drug, Drugavailability, Drugmanufacturer, Drugstatus, Patient, Pharmacy, Prescription, Prescriptiondetails, Price, Pricechangehistory

-- Creating the DrugManufacturer table
CREATE TABLE DrugManufacturer (
    CompanyID INT PRIMARY KEY,
    Name VARCHAR(255),
    ContactNumber VARCHAR(20)
);

-- Creating the Doctor table
CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Specialization VARCHAR(255),
    ContactNumber VARCHAR(20)
);

-- Creating the Patient table
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Address VARCHAR(255),
    ContactNumber VARCHAR(20)
);

-- Creating the Drug table
CREATE TABLE Drug (
    DrugID INT PRIMARY KEY,
    CompanyID INT,
    Stock INT,
    ExpirationDate DATE,
    Name VARCHAR(255),
    FOREIGN KEY (CompanyID) REFERENCES DrugManufacturer(CompanyID)
);

-- Creating the Price table
CREATE TABLE Price (
    CostPrice DECIMAL(10, 2) PRIMARY KEY,
    PreviousPrice DECIMAL(10, 2),
    DrugID INT,
    FOREIGN KEY (DrugID) REFERENCES Drug(DrugID)
);

-- Creating the Pharmacy table
CREATE TABLE Pharmacy (
    PharmacyID INT PRIMARY KEY,
    Name VARCHAR(255),
    ContactNumber VARCHAR(20),
    CityName VARCHAR(255)
);

-- Creating the DrugAvailability table
CREATE TABLE DrugAvailability (
    DrugAvailabilityID INT PRIMARY KEY,
    DrugID INT,
    PharmacyID INT,
    Stock INT,
    AvailabilityDate DATE,
    FOREIGN KEY (DrugID) REFERENCES Drug(DrugID),
    FOREIGN KEY (PharmacyID) REFERENCES Pharmacy(PharmacyID)
);

-- Creating the DrugStatus table
CREATE TABLE DrugStatus (
    PrescribeID INT PRIMARY KEY,
    PharmacyID INT,
    Availability VARCHAR(255),
    FOREIGN KEY (PharmacyID) REFERENCES Pharmacy(PharmacyID)
);

-- Creating the Prescription table
CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    PrescriptionDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

-- Creating the PrescriptionDetails table
CREATE TABLE PrescriptionDetails (
    PrescriptionDetailID INT PRIMARY KEY,
    PrescriptionID INT,
    DrugID INT,
    Quantity INT,
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID),
    FOREIGN KEY (DrugID) REFERENCES Drug(DrugID)
);

-- Creating the PriceChangeHistory table
CREATE TABLE PriceChangeHistory (
    ChangeID INT PRIMARY KEY AUTO_INCREMENT,
    DrugID INT,
    NewPrice DECIMAL(10, 2),
    ChangeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_price_change (DrugID, NewPrice),
    FOREIGN KEY (DrugID) REFERENCES Drug(DrugID)
);



-- Adding data 
INSERT INTO DrugManufacturer (CompanyID, Name, ContactNumber)
VALUES
    (1, 'PharmaCorp', '123-456-789'),
    (2, 'MediLab', '987-654-321'),
    (3, 'InnoMed Solutions', '555-123-456');

INSERT INTO Doctor (DoctorID, FirstName, LastName, Specialization, ContactNumber)
VALUES
    (1, 'John', 'Doe', 'Cardiologist', '111-222-333'),
    (2, 'Jane', 'Smith', 'Pediatrician', '444-555-666'),
    (3, 'Eva', 'Brown', 'Dermatologist', '333-555-888');

INSERT INTO Patient (PatientID, FirstName, LastName, Address, ContactNumber)
VALUES
    (1, 'Alice', 'Johnson', '123 Main St', '777-888-999'),
    (2, 'Bob', 'Miller', '456 Oak St', '111-222-333'),
    (3, 'Charlie', 'Brown', '789 Pine St', '555-777-888'),
    (4, 'Eva', 'Anderson', '101 Elm St', '999-888-777'),
    (5, 'Sophie', 'Lee', '123 Oak St', '555-666-777');

INSERT INTO Drug (DrugID, CompanyID, Stock, ExpirationDate, Name)
VALUES
    (1, 1, 100, '2023-01-01', 'Aspirin'),
    (2, 2, 50, '2024-02-01', 'Cough Syrup'),
    (3, 2, 40, '2024-05-01', 'Antibiotic X');

INSERT INTO Price (CostPrice, PreviousPrice, DrugID)
VALUES
    (5.00, 6.00, 1),
    (10.00, 12.00, 2),
    (8.50, 10.00, 3);

INSERT INTO Pharmacy (PharmacyID, Name, ContactNumber, CityName)
VALUES
    (1, 'City Pharmacy', '555-111-222', 'Metropolis'),
    (2, 'Suburb Drugstore', '333-444-555', 'Suburbia'),
    (3, 'PharmCity', '777-999-111', 'MediTown');

INSERT INTO DrugAvailability (DrugAvailabilityID, DrugID, PharmacyID, Stock, AvailabilityDate)
VALUES
    (1, 1, 1, 50, '2023-01-01'),
    (2, 2, 2, 30, '2024-02-01'),
    (3, 3, 3, 20, '2023-03-01');

INSERT INTO DrugStatus (PrescribeID, PharmacyID, Availability)
VALUES
    (1, 1, 'Available'),
    (2, 2, 'Out of stock'),
    (3, 3, 'Available');

INSERT INTO Prescription (PrescriptionID, PatientID, DoctorID, PrescriptionDate)
VALUES
    (1, 1, 1, '2023-01-15'),
    (2, 2, 2, '2024-02-15'),
    (3, 3, 1, '2023-03-20'),
    (4, 4, 1, '2023-04-05'),
    (5, 4, 2, '2023-04-07'),
    (6, 2, 1, '2021-05-15');

INSERT INTO PrescriptionDetails (PrescriptionDetailID, PrescriptionID, DrugID, Quantity)
VALUES
    (1, 1, 1, 2),
    (2, 2, 2, 1),
    (3, 3, 1, 1),
    (4, 3, 2, 1),
    (5, 4, 1, 2),
    (6, 5, 2, 1),
    (7, 2, 1, 5);


   
-- Selecting information about patients, doctors, and prescribed drugs
SELECT
    Pr.PatientID, 
    CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName, 
    CONCAT(Doc.FirstName, ' ', Doc.LastName) AS DoctorFullName, 
    GROUP_CONCAT(D.Name) AS DrugNames 
FROM
    Prescription Pr
JOIN PrescriptionDetails PD ON PD.PrescriptionID = Pr.PrescriptionID 
JOIN Patient P ON Pr.PatientID = P.PatientID 
JOIN Doctor Doc ON Pr.DoctorID = Doc.DoctorID 
JOIN Drug D ON PD.DrugID = D.DrugID 
GROUP BY
    Pr.PatientID, Doc.DoctorID, Pr.PrescriptionID, PatientFullName, DoctorFullName; 
    
    
    
-- Function returning a list of drugs available in a given pharmacy:
CREATE FUNCTION GetDrugsInPharmacy(pharmacyID INT) RETURNS VARCHAR(255)
BEGIN
    DECLARE drugList VARCHAR(255);
    SELECT GROUP_CONCAT(D.Name) INTO drugList
    FROM DrugAvailability DA
    JOIN Drug D ON DA.DrugID = D.DrugID
    WHERE DA.PharmacyID = pharmacyID;
    RETURN drugList;
END;

-- Calling the GetDrugsInPharmacy function for the pharmacy with PharmacyID equal to 1
SELECT GetDrugsInPharmacy(1) AS DrugListForPharmacy1;

-- Calling the GetDrugsInPharmacy function for the pharmacy with PharmacyID equal to 2
SELECT GetDrugsInPharmacy(2) AS DrugListForPharmacy2;



-- Function returning the number of prescriptions issued by a specific doctor:
CREATE FUNCTION GetPrescriptionCountForDoctor(doctorID INT) RETURNS INT
BEGIN
    DECLARE prescriptionCount INT;
    SELECT COUNT(*) INTO prescriptionCount
    FROM Prescription
    WHERE DoctorID = doctorID;
    RETURN prescriptionCount;
END;
    
-- Calling the GetPrescriptionCountForDoctor function for the doctor with DoctorID equal to 1
SELECT GetPrescriptionCountForDoctor(1) AS PrescriptionCountForDoctor1;

-- Calling the GetPrescriptionCountForDoctor function for the doctor with DoctorID equal to 2
SELECT GetPrescriptionCountForDoctor(2) AS PrescriptionCountForDoctor2;



-- Function returning the total cost of drugs for a specific patient:
CREATE FUNCTION GetTotalCostForPatient(patientID INT) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE totalCost DECIMAL(10, 2);
    SELECT SUM(Drg.CostPrice * PD.Quantity) INTO totalCost
    FROM Prescription Pr
    JOIN PrescriptionDetails PD ON PD.PrescriptionID = Pr.PrescriptionID
    JOIN Drug D ON PD.DrugID = D.DrugID
    JOIN Price Drg ON D.DrugID = Drg.DrugID
    WHERE Pr.PatientID = patientID;
    RETURN totalCost;
END;

-- Calling the GetTotalCostForPatient function for the patient with PatientID equal to 1
SELECT GetTotalCostForPatient(1) AS TotalCostForPatient1;

-- Calling the GetTotalCostForPatient function for the patient with PatientID equal to 2
SELECT GetTotalCostForPatient(2) AS TotalCostForPatient2;
 


-- Function returning the average number of drugs prescribed to a patient by all doctors
CREATE FUNCTION GetAverageDrugsPerPatient() RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE averageDrugs DECIMAL(10, 2);
    SELECT AVG(drugCount) INTO averageDrugs
    FROM (
        SELECT COUNT(PD.DrugID) AS drugCount
        FROM PrescriptionDetails PD
        JOIN Prescription Pr ON PD.PrescriptionID = Pr.PrescriptionID
        GROUP BY PD.PrescriptionID, Pr.PatientID
    ) AS DrugCounts;
    RETURN averageDrugs;
END;

-- Calling the GetAverageDrugsPerPatient function
SELECT GetAverageDrugsPerPatient() AS AverageDrugsPerPatient;



-- Procedure that updates the quantity of a drug in a pharmacy
CREATE PROCEDURE UpdateDrugAvailability(
    IN drugID INT,
    IN pharmacyID INT,
    IN newStock INT
)
BEGIN
    UPDATE DrugAvailability
    SET Stock = newStock
    WHERE DrugID = drugID AND PharmacyID = pharmacyID;
END;

-- Calling the UpdateDrugAvailability procedure with specified parameters
CALL UpdateDrugAvailability(1, 1, 75);
    


-- Procedure for updating the price of a drug
CREATE PROCEDURE UpdateDrugPrice(
    IN drugID INT,
    IN newCostPrice DECIMAL(10, 2)
)
BEGIN
    DECLARE existingRecordCount INT;

    -- Check if a record with the given DrugID already exists
    SELECT COUNT(*) INTO existingRecordCount
    FROM PriceChangeHistory
    WHERE DrugID = drugID;

    -- If a record exists, update it; otherwise, insert a new one
    IF existingRecordCount > 0 THEN
        UPDATE PriceChangeHistory
        SET NewPrice = newCostPrice, ChangeDate = CURRENT_TIMESTAMP
        WHERE DrugID = drugID;
    ELSE
        INSERT INTO PriceChangeHistory (DrugID, NewPrice)
        VALUES (drugID, newCostPrice);
    END IF;
END;

-- Calling the UpdateDrugPrice procedure with specified parameters
CALL UpdateDrugPrice(1, 8.50);

-- Displaying the contents of the PriceChangeHistory table
SELECT * FROM PriceChangeHistory;



-- Procedure marking a prescription as fulfilled
CREATE PROCEDURE MarkPrescriptionAsFulfilled(
    IN prescriptionID INT
)
BEGIN
    UPDATE Prescription
    SET IsFulfilled = 1
    WHERE PrescriptionID = prescriptionID;
END;

-- Adding the IsFulfilled column to the Prescription table
ALTER TABLE Prescription
ADD COLUMN IsFulfilled TINYINT DEFAULT 0;

-- Example: Mark the prescription with PrescriptionID equal to 1 as fulfilled
CALL MarkPrescriptionAsFulfilled(1);

-- Displaying the updated Prescription record
SELECT * FROM Prescription WHERE PrescriptionID = 1;



-- View combining information about patients, doctors, and prescribed drugs
CREATE VIEW PatientPrescriptionInfo AS
SELECT
    Pr.PatientID,
    CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName,
    CONCAT(Doc.FirstName, ' ', Doc.LastName) AS DoctorFullName,
    GROUP_CONCAT(D.Name) AS DrugNames,
    SUM(Drg.CostPrice * PD.Quantity) AS TotalCost
FROM
    Prescription Pr
JOIN PrescriptionDetails PD ON PD.PrescriptionID = Pr.PrescriptionID
JOIN Patient P ON Pr.PatientID = P.PatientID
JOIN Doctor Doc ON Pr.DoctorID = Doc.DoctorID
JOIN Drug D ON PD.DrugID = D.DrugID
JOIN Price Drg ON D.DrugID = Drg.DrugID
GROUP BY
    Pr.PatientID, Doc.DoctorID, Pr.PrescriptionID;
   
-- Displaying the PatientPrescriptionInfo view
SELECT * FROM PatientPrescriptionInfo;


   
-- View with information about drug availability in pharmacies
CREATE VIEW DrugAvailabilityInfo AS
SELECT
    D.Name AS DrugName,
    P.Name AS PharmacyName,
    DA.Stock,
    DA.AvailabilityDate
FROM
    DrugAvailability DA
JOIN Drug D ON DA.DrugID = D.DrugID
JOIN Pharmacy P ON DA.PharmacyID = P.PharmacyID;

-- Displaying the DrugAvailabilityInfo view
SELECT * FROM DrugAvailabilityInfo;



-- View with information about drugs, their prices, and manufacturers
CREATE VIEW DrugInfo AS
SELECT
    D.DrugID,
    D.Name AS DrugName,
    D.Stock,
    D.ExpirationDate,
    Drg.CostPrice,
    DM.Name AS ManufacturerName
FROM
    Drug D
JOIN Price Drg ON D.DrugID = Drg.DrugID
JOIN DrugManufacturer DM ON D.CompanyID = DM.CompanyID;

-- Displaying the DrugInfo view
SELECT * FROM DrugInfo;



-- View combining information about patients, doctors, drugs, prescriptions, and drug availability in pharmacies
CREATE VIEW PatientPrescriptionDrugAvailability AS
SELECT
    Pr.PatientID,
    CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName,
    CONCAT(Doc.FirstName, ' ', Doc.LastName) AS DoctorFullName,
    GROUP_CONCAT(D.Name) AS DrugNames,
    SUM(Drg.CostPrice * PD.Quantity) AS TotalCost,
    DA.Stock AS DrugStock,
    DA.AvailabilityDate
FROM
    Prescription Pr
JOIN PrescriptionDetails PD ON PD.PrescriptionID = Pr.PrescriptionID
JOIN Patient P ON Pr.PatientID = P.PatientID
JOIN Doctor Doc ON Pr.DoctorID = Doc.DoctorID
JOIN Drug D ON PD.DrugID = D.DrugID
JOIN Price Drg ON D.DrugID = Drg.DrugID
JOIN DrugAvailability DA ON D.DrugID = DA.DrugID
GROUP BY
    Pr.PatientID, Doc.DoctorID, Pr.PrescriptionID, DA.Stock, DA.AvailabilityDate;
   
-- Displaying the PatientPrescriptionDrugAvailability view
SELECT * FROM PatientPrescriptionDrugAvailability;



-- Trigger for automatically updating drug availability upon prescription fulfillment
CREATE TRIGGER UpdateDrugAvailabilityOnPrescriptionFulfillment
AFTER INSERT ON PrescriptionDetails
FOR EACH ROW
BEGIN
    DECLARE fulfilled INT;

    -- Check if the prescription is fulfilled
    SELECT IsFulfilled INTO fulfilled
    FROM Prescription
    WHERE PrescriptionID = NEW.PrescriptionID;

    -- If the prescription is fulfilled, update drug availability
    IF fulfilled = 1 THEN
        UPDATE DrugAvailability
        SET Stock = Stock - NEW.Quantity
        WHERE DrugID = NEW.DrugID;
    END IF;
END;

-- Displaying the initial DrugAvailability for DrugID = 1
SELECT * FROM DrugAvailability WHERE DrugID = 1;

-- Example: Inserting a fulfilled prescription
INSERT INTO Prescription (PrescriptionID, PatientID, DoctorID, PrescriptionDate, IsFulfilled)
VALUES (7, 1, 1, '2024-01-25', 1);

-- Example: Adding prescription details
INSERT INTO PrescriptionDetails (PrescriptionDetailID, PrescriptionID, DrugID, Quantity)
VALUES (8, 7, 1, 3);

-- Displaying the updated DrugAvailability for DrugID = 1
SELECT * FROM DrugAvailability WHERE DrugID = 1;



-- Trigger to track changes in drug price
CREATE TRIGGER TrackDrugPriceChanges
AFTER UPDATE ON Price
FOR EACH ROW
BEGIN
    IF OLD.CostPrice <> NEW.CostPrice THEN
        INSERT INTO PriceChangeHistory (DrugID, NewPrice, ChangeDate)
        SELECT NEW.DrugID, MAX(NEW.CostPrice), NOW()
        FROM Price
        WHERE DrugID = NEW.DrugID
        GROUP BY DrugID;
    END IF;
END;

-- Example: Updating the price of a drug (DrugID = 1) to a new value
UPDATE Price
SET CostPrice = 11.50
WHERE DrugID = 1;

-- Checking the price change history for DrugID = 1
SELECT * FROM PriceChangeHistory WHERE DrugID = 1;




-- Trigger for notifying about out-of-stock drugs
CREATE TRIGGER NotifyOutOfStock
BEFORE UPDATE ON DrugAvailability
FOR EACH ROW
BEGIN
    IF NEW.Stock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Out of stock for the drug in the pharmacy';
    END IF;
END;

-- Example: Checking the current stock of the drug for DrugID = 1 before the update
SELECT Stock FROM DrugAvailability WHERE DrugID = 1;

-- Example: Updating the stock of the drug for DrugID = 1 to a negative value
UPDATE DrugAvailability SET Stock = -5 WHERE DrugID = 1;



-- (Indexing) Adding indexes to the DrugAvailability table
CREATE INDEX idx_DrugAvailability_DrugID ON DrugAvailability (DrugID);
CREATE INDEX idx_DrugAvailability_PharmacyID ON DrugAvailability (PharmacyID);
CREATE INDEX idx_DrugAvailability_AvailabilityDate ON DrugAvailability (AvailabilityDate);








    