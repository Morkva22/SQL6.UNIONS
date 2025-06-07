USE master
GO

IF DB_ID('Hospital') IS NOT NULL
    DROP DATABASE Hospital
    CREATE DATABASE Hospital

IF DB_ID ('Hospital') IS NULL
    CREATE DATABASE Hospital


USE Hospital
GO
-- Create a table with departments
CREATE TABLE Departments (
Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Building INT NOT NULL,
Financing MONEY NOT NULL DEFAULT(0),
Name nvarchar(100) NOT NULL UNIQUE,

CONSTRAINT CHK_Departments_Building CHECK (Building BETWEEN 1 AND 5),
CONSTRAINT CHK_Departments_Financing CHECK (Financing >= 0),
CONSTRAINT CHK_Departments_Name CHECK (Name <> '')
);
-- Create a table with diseases
CREATE TABLE Diseases (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT CHK_Diseases_Name CHECK (Name <> '')
);

-- Create a table with doctors
CREATE TABLE Doctors (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(MAX) NOT NULL,
    Salary MONEY NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,

    CONSTRAINT CHK_Doctors_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Doctors_Salary CHECK (Salary > 0),
    CONSTRAINT CHK_Doctors_Surname CHECK (Surname <> '')
);

-- Create a table with examinations
CREATE TABLE Examinations (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT CHK_Examinations_Name CHECK (Name <> '')
);

-- Create a table with wards
CREATE TABLE Wards (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(20) NOT NULL UNIQUE,
    Places INT NOT NULL DEFAULT (1),
    DepartmentId INT NOT NULL,

    CONSTRAINT CHK_Wards_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Wards_Places CHECK (Places >= 1),

    CONSTRAINT FK_Wards_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

-- Create a table with doctors examinations
CREATE TABLE DoctorsExaminations (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Date DATE NOT NULL DEFAULT (GETDATE()),
    DiseaseId INT NOT NULL,
    DoctorId INT NOT NULL,
    ExaminationId INT NOT NULL,
    WardId INT NOT NULL,

    CONSTRAINT CHK_DoctorsExaminations_Date CHECK (Date <= CAST(GETDATE() AS DATE)),

    CONSTRAINT FK_DoctorsExaminations_Diseases FOREIGN KEY (DiseaseId) REFERENCES Diseases(Id),
    CONSTRAINT FK_DoctorsExaminations_Doctors FOREIGN KEY (DoctorId) REFERENCES Doctors(Id),
    CONSTRAINT FK_DoctorsExaminations_Examinations FOREIGN KEY (ExaminationId) REFERENCES Examinations(Id),
    CONSTRAINT FK_DoctorsExaminations_Ward FOREIGN KEY (WardId) REFERENCES Wards(Id)
);

-- Create a table with inters
CREATE TABLE Inters (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    DoctorId INT NOT NULL,

    CONSTRAINT FK_Inters_Doctors FOREIGN KEY (DoctorId) REFERENCES Doctors(Id)
);

-- Create a table with professors
CREATE TABLE Professors (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    DoctorId INT NOT NULL,

    CONSTRAINT FK_Professors FOREIGN KEY (DoctorId) REFERENCES Doctors(Id)
);

-- Execute the current batch of scripts
GO;

-- Insert data into Departments table
INSERT INTO Departments (Building, Financing, Name) VALUES
(1, 50000.00, 'Cardiology'),
(2, 75000.00, 'Neurology'),
(3, 60000.00, 'Pediatrics'),
(1, 80000.00, 'Oncology'),
(4, 45000.00, 'Orthopedics'),
(2, 65000.00, 'Emergency'),
(5, 70000.00, 'Surgery');

-- Insert data into Diseases table
INSERT INTO Diseases (Name) VALUES
(N'Flu'),
(N'COVID-19'),
(N'Cancer'),
(N'Migraine'),
(N'Fracture');

-- Insert data into Doctors table
INSERT INTO Doctors (Name, Salary, Surname) VALUES
(N'Thomas', 5000, N'Gerada'),
(N'Anthony', 5500, N'Davis'),
(N'Joshua', 4800, N'Bell'),
(N'Sarah', 5200, N'Johnson'),
(N'Michael', 5100, N'Smith'),
(N'Lisa', 4900, N'Brown'),
(N'Robert', 5300, N'Wilson'),
(N'Jennifer', 5800, N'Taylor');

-- Insert data into Examinations table
INSERT INTO Examinations (Name) VALUES
(N'Blood Test'),
(N'X-Ray'),
(N'MRI'),
(N'Vision Test'),
(N'Physio Session');

-- Insert data into Wards table
INSERT INTO Wards (Name, Places, DepartmentId) VALUES
(N'Ward A', 5, 1),   -- 5th building, 5 places
(N'Ward B', 20, 1),  -- 5th building, >15 places
(N'Ward C', 4, 1),   -- 5th building, <5 places
(N'Ward D', 6, 2),   -- 5th building, >=5 places
(N'Ward E', 2, 3),   -- 3rd building
(N'Ward F', 3, 3),   -- 3rd building
(N'Ward G', 7, 4),   -- 2nd building
(N'Ward H', 8, 5);   -- 1st building

-- Insert data into DoctorsExaminations table
INSERT INTO DoctorsExaminations (Date, DiseaseId, DoctorId, ExaminationId, WardId) VALUES
(GETDATE(), 1, 1, 1, 1), -- Thomas, Ward A, Ophthalmology
(GETDATE(), 2, 2, 2, 2), -- Anthony, Ward B, Ophthalmology
(DATEADD(DAY, -3, GETDATE()), 3, 3, 3, 4), -- Joshua, Ward D, Physiotherapy
(DATEADD(DAY, -10, GETDATE()), 4, 4, 4, 5), -- Sarah, Ward E, Cardiology (older than 1 week)
(GETDATE(), 5, 5, 5, 7), -- Michael, Ward G, Neurology
(GETDATE(), 1, 6, 1, 8), -- Lisa, Ward H, Oncology
(GETDATE(), 2, 7, 2, 1), -- Robert, Ward A, Ophthalmology
(GETDATE(), 3, 8, 3, 4); -- Jennifer, Ward D, Physiotherapy

-- Insert data into Inters table
INSERT INTO Inters (DoctorId) VALUES
(3), -- Joshua
(5); -- Michael

-- Insert data into Professors table
INSERT INTO Professors (DoctorId) VALUES
(4), -- Sarah
(7); -- Robert

-- Execute the current batch of scripts
GO;

-- Print the names and capacities of wards located in the 5th building with 5 or more beds, if there is at least one ward in this building with more than 15 beds.
SELECT W.Name, W.Places FROM Wards AS W
JOIN Departments D on W.DepartmentId = D.Id
WHERE D.Building = 5 AND W.Places >= 5

UNION

SELECT W.Name, W.Places FROM Wards AS W
JOIN Departments D on W.DepartmentId = D.Id
WHERE D.Building = 5 AND W.Places > 15
GO;

-- Print the names of the departments in which at least one examination was conducted in the last week.
SELECT DISTINCT D.Name FROM Departments AS D
JOIN Wards W on W.DepartmentId = D.Id
JOIN DoctorsExaminations DE on DE.WardId = W.Id
WHERE DE.Date >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))
GO;

-- Print the names of the diseases for which no examinations are conducted.
SELECT DISTINCT DI.Name AS [Disease Name] FROM Diseases AS DI
WHERE DI.Id NOT IN(SELECT DocExam1.DiseaseId FROM DoctorsExaminations AS DocExam1)
GO;

-- Print the full names of the doctors who do not conduct examinations.
SELECT DO.Name + N' ' + DO.Surname AS [Doctors Name] FROM Doctors AS DO
WHERE DO.Id NOT IN (SELECT DOExam.DoctorId FROM DoctorsExaminations AS DOExam)
GO;

-- Print the names of the departments that do not conduct examinations.
SELECT D.Name AS [Departments Name] FROM Departments AS D
WHERE D.Id NOT IN (SELECT DISTINCT W.DepartmentId FROM DoctorsExaminations AS DE
JOIN Wards AS W ON W.Id = DE.WardId)
GO;

-- Print the names of doctors who are interns.
SELECT D.Name + N' ' + D.Surname AS [Intern Name] FROM Inters AS I
JOIN Doctors D on D.Id = I.DoctorId
GO;

-- Print the names of interns whose rates are higher than the rate of at least one of the doctors.
SELECT D.Name + N' ' + D.Surname AS [Interns Name] FROM Inters AS I
JOIN Doctors D on D.Id = I.DoctorId
WHERE D.Salary > ANY (SELECT D1.Salary FROM Doctors AS D1)
GO;

-- Print the names of the wards whose capacity is greater than the capacity of each ward in the 3rd building.
SELECT W.Name AS [Ward Name] FROM Wards AS W
WHERE W.Places > ALL(SELECT W1.Places FROM Wards AS W1
JOIN Departments AS D ON D.Id = W1.DepartmentId
WHERE D.Building = 3)

UNION

SELECT W.Name FROM Wards AS W
JOIN Departments AS D1 ON D1.Id = W.DepartmentId
WHERE D1.Building <> 3
GO;

-- Print the names of the doctors who perform examinations in the departments "Ophthalmology" and "Physiotherapy".
SELECT D.Name + N' ' + D.Surname AS [Doctor Name] FROM Doctors AS D
WHERE D.ID IN(SELECT DE.DoctorId FROM DoctorsExaminations AS DE
JOIN Doctors AS D1 ON D1.Id = DE.DoctorId
JOIN Wards AS W1 ON W1.Id = DE.WardId
JOIN Departments Dep on Dep.Id = W1.Id
WHERE Dep.Name IN (N'Ophthalmology', N'Physiotherapy')
)
GO;

-- Print the names of the departments where interns and professors work, along with the names of the interns and professors.
SELECT DISTINCT DE.Name AS [Departments Name], DO.Name + N' ' + DO.Surname AS [Doctor Name], N'Intern' AS [Role] FROM Inters AS I
JOIN Doctors AS DO ON DO.Id = I.DoctorId
JOIN DoctorsExaminations AS DEXAM ON DEXAM.DoctorId = DO.Id
JOIN Wards AS W ON W.Id = DEXAM.WardId
JOIN Departments AS DE ON DE.Id = W.DepartmentId

UNION

SELECT DISTINCT DE.Name AS [Departments name], DO.Name + N' ' + DO.Surname AS [Doctor name], N'Professor' AS [Role] FROM Professors AS Prof
JOIN Doctors AS DO ON DO.Id = Prof.DoctorId = DO.Id
JOIN DoctorsExaminations AS DEXAM ON DEXAM.DoctorId = DO.Id
JOIN Wards AS W ON W.Id = DEXAM.WardId
JOIN Departments AS DE ON DE.Id = W.DepartmentId
GO;

-- Print the full names of the doctors and the departments in which they conduct examinations, if the department has a funding fund of more than 20000.
SELECT DISTINCT DE.Name AS [Department Name], DO.Name + N' ' + DO.Surname AS [Doctor Name] FROM DoctorsExaminations AS DExam
JOIN Doctors AS DO ON DO.Id = DExam.DoctorId
JOIN Wards AS W ON W.Id = DExam.WardId
JOIN Departments AS DE ON DE.Id = W.DepartmentId
WHERE DE.Financing > 20000

-- Print the name of the department in which the doctor with the highest salary is examined.
SELECT DO.Name + N' ' + DO.Surname AS [Doctor's full name], DE.Name AS [Department's name], DO.Salary AS [Doctor's sallary] FROM DoctorsExaminations AS DExam
JOIN Wards AS W ON W.Id = DExam.WardId
JOIN Departments AS DE ON DE.Id = W.DepartmentId
JOIN Doctors AS DO ON DO.Id = DExam.DoctorId
WHERE DO.Salary = (
    SELECT MAX(DO.Salary) FROM Doctors AS DO
)
GO;

-- Print the names of the diseases and the number of examinations for them.
SELECT DISTINCT DI.Name AS [Disease name], COUNT(DEXAM.DiseaseId) AS [Number of examinations] FROM Diseases AS DI
JOIN DoctorsExaminations AS DEXAM ON DEXAM.DiseaseId = DI.Id
GROUP BY DI.Name
GO;
