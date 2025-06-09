USE master
GO

IF DB_ID('Academy') IS NOT NULL
    DROP DATABASE Academy
    CREATE DATABASE Academy

IF DB_ID ('Academy') IS NULL
    CREATE DATABASE Academy


USE Academy
GO

-- Create a table with teachers
CREATE TABLE Teachers (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,

    CONSTRAINT CHK_Teachers_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Teachers_Surname CHECK (Surname <> '')
);

-- Create a table with assistants
CREATE TABLE Assistants (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    TeacherId INT NOT NULL,

    CONSTRAINT FK_Assistants_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

-- Create a table with curators
CREATE TABLE Curators (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    TeacherId INT NOT NULL,

    CONSTRAINT FK_Curators_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

-- Create a table with deans
CREATE TABLE Deans (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    TeacherId INT NOT NULL,

    CONSTRAINT FK_Deans_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

-- Create a table with heads
CREATE TABLE Heads (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    TeacherId INT NOT NULL,

    CONSTRAINT FK_Heads_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

-- Create a table with faculties
CREATE TABLE Faculties (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Building INT NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    DeanId INT NOT NULL,

    CONSTRAINT CHK_Faculties_Building CHECK (Building BETWEEN 1 AND 5),
    CONSTRAINT CHK_Faculties_Name CHECK (Name <> ''),

    CONSTRAINT FK_Faculties_Deans FOREIGN KEY (DeanId) REFERENCES Deans(Id)
);

-- Create a table with departments
CREATE TABLE Departments (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Building INT NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    FacultyId INT NOT NULL,
    HeadId INT NOT NULL,

    CONSTRAINT CHK_Departments_Building CHECK (Building BETWEEN 1 AND 5),
    CONSTRAINT CHK_Departments_Name CHECK (Name <> ''),

    CONSTRAINT FK_Departments_Faculties FOREIGN KEY (FacultyId) REFERENCES Faculties(Id),
    CONSTRAINT FK_Departments_Heads FOREIGN KEY (HeadId) REFERENCES Heads(Id)
);

-- Create a table with subjects
CREATE TABLE Subjects (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT CHK_Subjects_Name CHECK (Name <> '')
);

-- Create a table with lecture rooms
CREATE TABLE LectureRooms (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Building INT NOT NULL,
    Name NVARCHAR(10) NOT NULL UNIQUE,

    CONSTRAINT CHK_LectureRooms_Building CHECK (Building BETWEEN 1 AND 5),
    CONSTRAINT CHK_LectureRooms_Name CHECK (Name <> '')
);

-- Create a table with Lectures
CREATE TABLE Lectures (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,

    CONSTRAINT FK_Lectures_Subjects FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    CONSTRAINT FK_Lectures_Teachers FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

-- Create a table with schedules
CREATE TABLE Schedules (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Class INT NOT NULL,
    DayOfWeek INT NOT NULL,
    Week INT NOT NULL,
    LectureId INT NOT NULL,
    LectureRoomId INT NOT NULL,

    CONSTRAINT CHK_Schedules_Class CHECK (Class BETWEEN 1 AND 8),
    CONSTRAINT CHK_Schedules_DayOfWeek CHECK (DayOfWeek BETWEEN 1 AND 7),
    CONSTRAINT CHK_Schedules_Week CHECK (Week BETWEEN 1 AND 52),

    CONSTRAINT FK_Schedules_Lectures FOREIGN KEY (LectureId) REFERENCES Lectures(Id),
    CONSTRAINT FK_Schedules_LectureRooms FOREIGN KEY (LectureRoomId) REFERENCES LectureRooms (Id)
);

-- Create a table with groups
CREATE TABLE Groups (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(10) NOT NULL UNIQUE,
    Year INT NOT NULL,
    DepartmentId INT NOT NULL,

    CONSTRAINT CHK_Groups_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Groups_Year CHECK (Year BETWEEN 1 AND 5),

    CONSTRAINT FK_Groups_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

-- Create a table with groups curators
CREATE TABLE GroupsCurators (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,

    CONSTRAINT FK_GroupsCurators_Curators FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    CONSTRAINT FK_GroupsCurators_Groups FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

-- Create a table with groups lectures
CREATE TABLE GroupsLectures (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,

    CONSTRAINT FK_GroupsLectures_Groups FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    CONSTRAINT FK_GroupsLectures_Lectures FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

-- Execute the current batch of scripts
GO;

-- Insert data into Teachers
INSERT INTO Teachers (Name, Surname) VALUES
(N'Edward', N'Hopper'),
(N'Alex', N'Carmack'),
(N'Linda', N'Green'),
(N'John', N'Smith'),
(N'Anna', N'White'),
(N'Peter', N'Black');

-- Insert data into Assistants
INSERT INTO Assistants (TeacherId) VALUES
(3),
(4);

-- Insert data into Curators
INSERT INTO Curators (TeacherId) VALUES
(5);

-- Insert data into Deans
INSERT INTO Deans (TeacherId) VALUES
(1);

-- Insert data into Heads
INSERT INTO Heads (TeacherId) VALUES
(2),
(6);

-- Insert data into Faculties
INSERT INTO Faculties (Building, Name, DeanId) VALUES
(1, N'Computer Science', 1),
(2, N'Mathematics', 1);

-- Insert data into Departments
INSERT INTO Departments (Building, Name, FacultyId, HeadId) VALUES
(1, N'Software Development', 1, 1),
(2, N'Networks', 1, 2);

-- Insert data into Subjects
INSERT INTO Subjects (Name) VALUES
(N'Programming'),
(N'Algorithms'),
(N'Databases');

-- Insert data into LectureRooms
INSERT INTO LectureRooms (Building, Name) VALUES
(1, N'A311'),
(1, N'A104'),
(2, N'B201');

-- Insert data into Lectures
INSERT INTO Lectures (SubjectId, TeacherId) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert data into Schedules
INSERT INTO Schedules (Class, DayOfWeek, Week, LectureId, LectureRoomId) VALUES
(1, 1, 1, 1, 1),
(3, 3, 2, 2, 2),
(2, 2, 1, 3, 3);

-- Insert data into Groups
INSERT INTO Groups (Name, Year, DepartmentId) VALUES
(N'F505', 5, 1),
(N'F404', 4, 2);

-- Insert data into GroupsCurators
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
(1, 1);

-- Insert data into GroupsLectures
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
(1, 2),
(1, 3),
(2, 1);

-- Execute the current batch of scripts
GO;

-- Print the names of the classrooms where the teacher "Edward Hopper" lectures.
SELECT DISTINCT LR.Name AS [LectureRoomName] FROM Teachers AS T
JOIN Lectures L on L.TeacherId = T.Id
JOIN Schedules S on S.LectureId = S.LectureRoomId
JOIN LectureRooms LR on LR.Id = S.LectureRoomId
WHERE T.Name = N'Edward' AND T.Surname = N'Hopper';
GO;

-- Print the names of the assistants who lecture in the group "F505".
SELECT DISTINCT T.Name AS [AssistantName], T.Surname AS [AssistantSurname] FROM Groups AS Gr
JOIN GroupsLectures GL ON GL.GroupId = GL.LectureId
JOIN Lectures L ON L.Id = GL.LectureId
JOIN Teachers T ON T.Id = L.TeacherId
JOIN Assistants A ON A.TeacherId = T.Id
WHERE Gr.Name = N'F505';
GO;

-- Print the disciplines taught by the teacher "Alex Carmack" for the 5th year groups.
SELECT Sub.Name AS [Discipline's name] FROM Teachers AS Teach
JOIN Lectures AS Lect ON Lect.TeacherId = Teach.Id
JOIN GroupsLectures AS GrLect ON GrLect.LectureId = Lect.Id
JOIN Groups AS Gr ON Gr.Id = GrLect.GroupId
JOIN Subjects AS Sub ON Lect.SubjectId = Sub.Id
WHERE Teach.Name + N' ' + Teach.Surname = N'Alex Carmack' AND Gr.Year = 5
GO;

-- Print the names of teachers who do not give lectures on Monday.
SELECT DISTINCT T.Name + N' ' +  T.Surname AS [TeacherName] FROM Teachers AS T
WHERE T.Id NOT IN (SELECT L.TeacherId FROM Lectures AS L
JOIN Schedules AS S ON S.LectureId = L.Id
WHERE L.TeacherId = T.Id AND S.DayOfWeek = 1)
GO;

-- Print the names of the classrooms, indicating their buildings, which do not have lectures on Wednesday of the second week for the third pair.
SELECT LR.Name AS [Classroom's name], Building FROM LectureRooms AS LR
WHERE LR.Id NOT IN ( SELECT S.LectureRoomId FROM Schedules AS S WHERE S.DayOfWeek = 3 AND S.Week = 2 AND S.Class = 3)
GO;

-- Print the full names of the Computer Science faculty members who do not supervise the Software Development department groups.
SELECT T.Name + N' ' + T.Surname AS [Teacher name] FROM Teachers AS T
JOIN Heads AS H ON H.TeacherId = T.Id
JOIN Departments D ON D.HeadId = H.Id
JOIN Faculties F ON F.Id = D.FacultyId
WHERE F.Name = N'Computer Science' AND T.Id NOT IN (SELECT H1.TeacherId FROM Heads AS H1
JOIN Departments AS D1 ON D1.HeadId = H1.Id WHERE D1.Name = N'Software Development')
UNION
SELECT T.Name + N' ' + T.Surname AS [Teacher Name] FROM Teachers AS T
JOIN Deans AS Den ON Den.TeacherId = T.Id
JOIN Faculties AS F ON F.DeanId = Den.Id
WHERE F.Name = N'Computer Science' AND T.Id NOT IN ( SELECT H1.TeacherId FROM Heads AS H1
JOIN Departments AS D1 ON D1.HeadId = H1.Id WHERE D1.Name = N'Software Development')
GO;

-- Print the list of numbers of all buildings that are in the tables of faculties, departments and classrooms.
SELECT DISTINCT Building FROM Faculties
UNION
SELECT DISTINCT Building FROM Departments
UNION
SELECT DISTINCT Building FROM LectureRooms
GO;

-- Print the full names of the teachers in the following order: deans of faculties, heads of departments, teachers, curators, assistants.
SELECT T.Name + N' ' + T.Surname AS [Teacher name], 1 AS [1 - deans; 2 - heads; 3 - teachers; 4 - curators; 5 - assistants] FROM Deans AS D
JOIN Teachers AS T ON T.Id = D.TeacherId
UNION
SELECT Teach.Name + N' ' + Teach.Surname, 2 FROM Heads AS Head
JOIN Teachers AS Teach ON Teach.Id = Head.TeacherId
UNION
SELECT Teach.Name + N' ' + Teach.Surname, 3 FROM Teachers AS Teach
WHERE Teach.Id NOT IN (SELECT D.TeacherId FROM Deans AS D
UNION
SELECT TeacherId FROM Deans
UNION
SELECT TeacherId FROM Heads
UNION
SELECT TeacherId FROM Curators
UNION
SELECT TeacherId FROM Assistants)

UNION
SELECT T.Name + N' ' + T.Surname, 4 FROM Curators AS C
JOIN Teachers AS T ON T.Id = C.TeacherId
UNION
SELECT T.Name + N' ' + T.Surname, 5 FROM Assistants AS ass
JOIN Teachers AS T ON T.Id = ass.TeacherId
ORDER BY [1 - deans; 2 - heads; 3 - teachers; 4 - curators; 5 - assistants], [Teacher name];
GO;

-- Print the days of the week (without repetition) when there are classes in the classrooms "A311" and "A104" of building 6.
SELECT DISTINCT S.DayOfWeek FROM Schedules AS S
WHERE S.LectureRoomId IN (SELECT LR.Id FROM LectureRooms AS LR WHERE (LR.Name = N'A311' OR LR.Name = N'A104') AND LR.Building = 6)
GO;