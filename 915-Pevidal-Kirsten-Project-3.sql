/*PROJECT 3
  Name: Kirsten Pevidal
  Description: Recreate Queens College Course Schedule  for Spring 2019
*/
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [Process].[usp_TrackWorkFlow]
-- Create date: 05/11/2019
-- Description: Define the actions of the stored procedure
-- =============================================
create schema Process
create schema PkSequence

Go
create sequence PkSequence.WorkflowStepsSequenceObject AS INT MINVALUE 1;
create table Process.WorkflowSteps
(
		WorkFlowStepKey INT NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.WorkflowStepsSequenceObject) primary key,
		WorkFlowStepDescription NVARCHAR(100) NOT NULL,
		WorkFlowStepTableRowCount INT NULL DEFAULT (0),
		LastName varchar(30) NULL DEFAULT ('Pevidal'),
	    FirstName varchar(30) NULL DEFAULT ('Kirsten'),
		StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()),
		EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()),
		ClassTime CHAR(5) NULL DEFAULT ('09:15'),
        QmailEmailAddress varchar(50) NULL DEFAULT ('kirsten.pevidal08@qmail.cuny.edu')
)
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: Process.usp_TrackWorkFlow 
-- Create date: 05/11/2019
-- Description: insert workflow to table
-- =============================================
--
go
create procedure Process.usp_TrackWorkFlow 
   @StartTime DATETIME2,    
   @WorkFlowDescription NVARCHAR(100),     
   @WorkFlowStepTableRowCount int
as
insert into Process.WorkflowSteps(WorkFlowStepDescription, WorkFlowStepTableRowCount, StartingDateTime)
values (@WorkFlowDescription, @WorkFlowStepTableRowCount, @StartTime);
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: Process.usp_ShowWorkflowSteps 
-- Create date: 05/11/2019
-- Description: view workflow table
-- =============================================
--
go;
CREATE or Alter PROCEDURE Process.usp_ShowWorkflowSteps
AS
BEGIN
set nocount on;
select * from process.WorkflowSteps
END;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [Process].TruncateTable
-- Create date: 05/11/2019
-- Description: Stored procedure to truncate all tables
-- =============================================
--
create or alter procedure [Process].TruncateTable
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	--truncate table Process.WorkflowSteps;
	truncate table [College].DepartmentOfInstructor
	truncate table [College].Department
	truncate table [College].Instructors
	truncate table [college].Course
	truncate table [class].BuildingLocation
	truncate table [CLASS].[RoomLocation]
	truncate table [class].ModeOfInstruction
	truncate table [class].Class
	truncate table [dbo].Spring2019CourseDatabase
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Truncate Course Database Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [Process].[DropForeignKeys]
-- Create date: 05/11/2019
-- Description: Stored procedure to drop all FKs
-- =============================================
--
create or alter procedure [Process].[DropForeignKeys]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();
		alter table [COLLEGE].[Department]  drop constraint [FK_College_Department]
			alter table [COLLEGE].[Instructors] drop constraint [FK_College_Instructors]
				alter table [COLLEGE].[Course] drop constraint [FK_College_Course]
					alter table [Class].[RoomLocation] drop constraint [FK_CLASS_buildingLocation]
						alter table [CLass].[Class] drop constraint [FK_CLASS_CourseName] 
							alter table [CLass].[Class] drop constraint [FK_CLASS_Instructor]
								alter table [CLass].[Class] drop constraint [FK_CLASS_ClassroomLocation] 									
									alter table [CLass].[Class] drop constraint [FK_CLASS_ModeOfInstruction]
										alter table dbo.Spring2019CourseDatabase drop constraint [FK_DBO_CourseName]
											alter table dbo.Spring2019CourseDatabase drop constraint [FK_DBO_Instructor]
												alter table dbo.Spring2019CourseDatabase drop constraint [FK_DBO_ClassroomLocation]
													alter table dbo.Spring2019CourseDatabase drop constraint [FK_DBO_ModeOfInstruction]
														alter table dbo.Spring2019CourseDatabase drop constraint [FK_DBO_Class]
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Drop FKs from tables', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [Process].[AddForeignKeys]
-- Create date: 05/11/2019
-- Description: Stored procedure to add FKs to all table
-- =============================================
--
create or alter procedure [Process].[AddForeignKeys]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();
--Foreign key DepartmentOfInstructor-> Departments
ALTER TABLE [COLLEGE].[Department]  WITH CHECK 
ADD  CONSTRAINT [FK_College_Department] FOREIGN KEY([DepartmentKey])
references [COLLEGE].[DepartmentOfInstructor] ([DepartmentKey])
--Foreign key DepartmentOfInstructor-> Instructors
ALTER TABLE [COLLEGE].[Instructors]  WITH CHECK 
ADD  CONSTRAINT [FK_College_Instructors] FOREIGN KEY([DepartmentKey])
references [COLLEGE].[DepartmentOfInstructor] ([DepartmentKey])
--Foreign key Department-> Course
ALTER TABLE [COLLEGE].[Course]  WITH CHECK 
ADD  CONSTRAINT [FK_College_Course] FOREIGN KEY([DepartmentKey])
references [COLLEGE].[Department] ([NameOfTheDepartment])
--Foreign key BldgLocation-> RoomLocation
ALTER TABLE [CLASS].[RoomLocation] WITH CHECK
ADD CONSTRAINT [FK_CLASS_buildingLocation] FOREIGN KEY ([BuildingAbbv]) 
REFERENCES [CLASS].[buildingLocation]([BuildingAbbrv]);
--Foreign key Course-> Class
ALTER TABLE [CLASS].[class] WITH CHECK
ADD CONSTRAINT [FK_CLASS_CourseName] FOREIGN KEY ([CourseName]) 
REFERENCES [College].[Course]([Coursename]);
--Foreign key Instructors-> Class
ALTER TABLE [CLASS].[class] WITH CHECK
ADD CONSTRAINT [FK_CLASS_Instructor] FOREIGN KEY ([InstructorKey]) 
REFERENCES [College].[Instructors]([InstructorKey]);
--Foreign key RoomLocation-> Class
ALTER TABLE [CLASS].[class] WITH NOCHECK
ADD CONSTRAINT [FK_CLASS_ClassroomLocation] FOREIGN KEY ([ClassroomLocation]) 
REFERENCES [Class].[RoomLocation] ([LocationOfRoom])
--Foreign key ModeOfInstruction-> Class
ALTER TABLE [CLASS].[class] WITH CHECK
ADD CONSTRAINT [FK_CLASS_ModeOfInstruction] FOREIGN KEY ([ModeOfInstructionKey]) 
REFERENCES [CLass].[ModeOfInstruction] ([ModeOfInstructionKey])
--Foreign key Class-> Spring2019CourseDatabase
ALTER TABLE dbo.Spring2019CourseDatabase WITH CHECK
ADD CONSTRAINT [FK_DBO_CourseName] FOREIGN KEY ([CourseName]) 
REFERENCES [Class].[CLass]([Coursename]);
--Foreign key Class-> Spring2019CourseDatabase
ALTER TABLE dbo.Spring2019CourseDatabase WITH CHECK
ADD CONSTRAINT [FK_DBO_Instructor] FOREIGN KEY ([InstructorKey]) 
REFERENCES [Class].[Class]([InstructorKey]);
--Foreign key Class-> Spring2019CourseDatabase
ALTER TABLE dbo.Spring2019CourseDatabase WITH CHECK
ADD CONSTRAINT [FK_DBO_ClassroomLocation] FOREIGN KEY ([ClassroomLocation]) 
REFERENCES [Class].[Class] ([ClassroomLocation])
--Foreign key Class-> Spring2019CourseDatabase
ALTER TABLE dbo.Spring2019CourseDatabase WITH CHECK
ADD CONSTRAINT [FK_DBO_ModeOfInstruction] FOREIGN KEY ([ModeOfInstructionKey]) 
REFERENCES [CLass].[Class] ([ModeOfInstructionKey])
--Foreign key Class-> Spring2019CourseDatabase
ALTER TABLE dbo.Spring2019CourseDatabase WITH CHECK
ADD CONSTRAINT [FK_DBO_Class] FOREIGN KEY ([ClassKey]) 
REFERENCES [Class].[Class] ([ClassKey])

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'ADD FKs from tables', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COLLEGE].[DepartmentOfInstructor]
-- Create date: 05/11/2019
-- Description: Segregate Tables using College Schema and Class Schema
-- =============================================
--
GO
CREATE SCHEMA [COLLEGE]
GO
CREATE SCHEMA [CLASS]
--Create Departments and their Instructors Table
CREATE TABLE [COLLEGE].[DepartmentOfInstructor]
(	[DepartmentKey] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[NameOfTheDepartment] [nvarchar](50) NOT NULL,
	[InstructorName] [nvarchar](50) DEFAULT ('Mr. John Smith')  null,
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
)
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COllEGE].[LoadDepartmentOfInstructor]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Department of Instructor Table
-- =============================================
--
go
create or alter procedure [COllEGE].[LoadDepartmentOfInstructor]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [COLLEGE].[DepartmentOfInstructor]
		([NameofTheDepartment],[InstructorName])

select  [Course (hr, crd)], instructor from Uploadfile.CoursesSpring2019

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Department Of Instructor Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COLLEGE].[Department]
-- Create date: 05/11/2019
-- Description: Create Department Table
-- =============================================
--
GO
CREATE TABLE [COLLEGE].[Department]
(
	[NameOfTheDepartment] [nvarchar](50) NOT NULL PRIMARY KEY,
	[ChairmanOfTheDepartment] [nvarchar](50) DEFAULT ('Mr. John Smith') NULL,
	[DepartmentKey] int not null,
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
) 
--Set default FK for Department table
ALTER TABLE [COLLEGE].[Department]  WITH CHECK 
ADD  CONSTRAINT [FK_College_Department] FOREIGN KEY([DepartmentKey])
references [COLLEGE].[DepartmentOfInstructor] ([DepartmentKey])
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COLLEGE].[LoadDepartment]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Department Table
-- =============================================
--
go
create or alter procedure [COLLEGE].[LoadDepartment]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [COLLEGE].[Department]
		([NameofTheDepartment],[departmentkey])

	select DISTINCT LEFT(orig.[NameOfTheDepartment], charindex(' ', orig.[NameOfTheDepartment])) as DepartmentName,
	max(orig.departmentkey)
	from college.DepartmentOfInstructor as orig
	group by LEFT(orig.[NameOfTheDepartment], charindex(' ', orig.[NameOfTheDepartment]))


	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Department Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COLLEGE].[Instructors]
-- Create date: 05/11/2019
-- Description: Create Instructors Table
-- =============================================
--
GO
CREATE TABLE [COLLEGE].[Instructors]
(
	[InstructorKey] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[InstructorFullName] [nvarchar](50) null,
	[InstructorFirstName] [nvarchar](50) NULL,
	[InstructorLastName] [nvarchar](50) null,
	[DepartmentKey] [int] null,
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
)
--Set default FK for Instructor Table
ALTER TABLE [COLLEGE].[Instructors]  WITH CHECK 
ADD  CONSTRAINT [FK_College_Instructors] FOREIGN KEY([DepartmentKey])
references [COLLEGE].[DepartmentOfInstructor] ([DepartmentKey])
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COllEGE].[LoadInstructors]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Instructor Table
-- =============================================
-- 
go
create or alter procedure [COllEGE].[LoadInstructors]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [COLLEGE].[Instructors]
		([InstructorFullName], [instructorfirstname],[instructorlastname],[DepartmentKey])
		select  distinct d.[InstructorName],
				case
				when instructorname='' then 'No'
				when instructorname=',' then 'No'
				else SUBSTRING(d.[InstructorName], charindex(',',d.[InstructorName])+2,LEN(d.[InstructorName])-charindex(',', d.[InstructorName])) 
		
		end as FirstName,
		case
		when instructorname='' then 'Instructor'
		when instructorname=',' then 'Instructor'
		else 
		SUBSTRING(d.[InstructorName],1,  charindex(',',d.[InstructorName]+',')-1) 
		end as lastname,
		max(departmentKey)
		from [college].DepartmentOfInstructor as d
		group by d.InstructorName

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Instructor Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COLLEGE].[Course]
-- Create date: 05/11/2019
-- Description: Create Course table
-- =============================================
--
GO
CREATE TABLE [COLLEGE].[Course]
(
	[CourseName] [nvarchar](30) PRIMARY KEY not null,
	[HoursPerWeek] [nvarchar](30) not null,
	[CourseCredit] [nvarchar](30) not null,
	[CourseDescription] [nvarchar](50) not null,
	[DepartmentKey] [nvarchar](50) not null,	
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
)
--Set default FK for Course Table
ALTER TABLE [COLLEGE].[Course]  WITH CHECK 
ADD  CONSTRAINT [FK_College_Course] FOREIGN KEY([DepartmentKey])
references [COLLEGE].[Department] ([NameOfTheDepartment])
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [COllEGE].[LoadCourse]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Course Table
-- =============================================
--
create or alter procedure [COllEGE].[LoadCourse]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [COLLEGE].[Course]
		([CourseName],[DepartmentKey],[CourseDescription],[HoursPerWeek],[CourseCredit])
	
	select  DISTINCT LEFT(orig.[Course (hr, crd)],CharIndex(' ', orig.[Course (hr, crd)], CharIndex(' ', orig.[Course (hr, crd)]) + 1)) As coursename,
			d.NameOfTheDepartment,
			orig.Description,
			SUBSTRING(orig.[Course (hr, crd)],CHARINDEX('(',orig.[Course (hr, crd)])+1,1)  as HoursPerWeek,
			SUBSTRING(orig.[Course (hr, crd)],CHARINDEX(',',orig.[Course (hr, crd)])+1,2)  as CourseCredit
	from Uploadfile.CoursesSpring2019 as orig
	inner join [College].department as d
	 on LEFT(orig.[Course (hr, crd)], charindex(' ', orig.[Course (hr, crd)])) = d.[NameOfTheDepartment]

	 select distinct [Course (hr, crd)] from Uploadfile.CoursesSpring2019

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Course Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [CLASS].[BuildingLocation]
-- Create date: 05/11/2019
-- Description: Create Building Location Table
-- =============================================
--
CREATE TABLE [CLASS].[BuildingLocation]
(

    [BuildingAbbrv]	NVARCHAR(50) NOT NULL PRIMARY KEY,
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
);
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [CLASS].[LoadBuildingLocation]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Building Location table	
-- =============================================
--
create or alter procedure [CLASS].[LoadBuildingLocation]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	INSERT INTO [CLASS].[BuildingLocation]
	([BuildingAbbrv])
	SELECT distinct LEFT(orig.[location], charindex(' ', orig.[location])) as [Building Abbreviation]
	FROM [Uploadfile].[CoursesSpring2019] as orig

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Building Location Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [CLASS].[RoomLocation]
-- Create date: 05/11/2019
-- Description: Create Room Location Table
-- =============================================
--
CREATE TABLE [CLASS].[RoomLocation]
(
[LocationOfRoom]			NVARCHAR(50) NOT NULL PRIMARY KEY,
[RoomNumber]				Nvarchar(50) NOT NULL,
[BuildingAbbv]				nvarchar(50) not null,
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
);
--Set default Fk for Room Location table
ALTER TABLE [CLASS].[RoomLocation] WITH CHECK
ADD CONSTRAINT [FK_CLASS_buildingLocation] FOREIGN KEY ([BuildingAbbv]) 
REFERENCES [CLASS].[buildingLocation]([BuildingAbbrv]);;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [CLASS].[LoadRoomLocation]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Room Location Table
-- =============================================
--
create or alter procedure [CLASS].[LoadRoomLocation]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	INSERT INTO [CLASS].[RoomLocation]
	([LocationOfRoom],[roomnumber],[BuildingAbbv])

	select 
	distinct orig.location as RoomLocation,
	right(orig.location, charindex(' ',reverse(orig.location))) as roomnumber,
			b.buildingabbrv
	FROM [QueensCollegeSchedulSpring2019].[Uploadfile].[CoursesSpring2019] as orig
	inner join [class].buildinglocation as b
	on LEFT(orig.[location], charindex(' ', orig.[location]))=b.buildingabbrv;

	--select distinct location from uploadfile.CoursesSpring2019 

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Room Location Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [CLASS].[ModeOfInstruction]
-- Create date: 05/11/2019
-- Description: Create Mode of Instruction Table
-- =============================================
--
 CREATE TABLE [CLASS].[ModeOfInstruction]
(
	[ModeOfInstructionKey]	INT	IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[NameOfTheInstruction]	NVARCHAR(50),
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
);
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [CLASS].[LoadModeOfInstruction]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Mode of Instruction Table
-- =============================================
--
create or alter procedure [CLASS].[LoadModeOfInstruction]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	INSERT INTO [CLASS].[ModeOfInstruction]
	([Name of the Instruction])
	SELECT distinct

	[Mode of Instruction]

		FROM [QueensCollegeSchedulSpring2019].[Uploadfile].[CoursesSpring2019]

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Mode of Instruction Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [CLASS].[Class]
-- Create date: 05/11/2019
-- Description: Create Class table
-- =============================================
--
 CREATE TABLE [CLASS].[Class]
(
	[ClassKey] int IDENTITY(1,1) not null primary key,
	[ClassCode]	INT NOT NULL,
	[SectionNumber] NVARCHAR(50) NOT NULL,
	[CourseName] [nvarchar](30)  null,
	[InstructorName] nvarchar(50)  null,
	[DayOfClasses] nvarchar(50)  null,
	[ClassCapacity] nvarchar(50)  null,
	[ClassroomLocation] nvarchar(50)  null,
	[InstructionType] nvarchar(50) null,
	[InstructorKey] int  null,
	[ModeOfInstructionKey] int  null,

	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
);
--Set default FKs for Class table
ALTER TABLE [CLASS].[class] WITH CHECK
ADD CONSTRAINT [FK_CLASS_CourseName] FOREIGN KEY ([CourseName]) 
REFERENCES [College].[Course]([Coursename]);

ALTER TABLE [CLASS].[class] WITH CHECK
ADD CONSTRAINT [FK_CLASS_Instructor] FOREIGN KEY ([InstructorKey]) 
REFERENCES [College].[Instructors]([InstructorKey]);

ALTER TABLE [CLASS].[class] WITH CHECK
ADD CONSTRAINT [FK_CLASS_ClassroomLocation] FOREIGN KEY ([ClassroomLocation]) 
REFERENCES [College].[RoomLocation] ([LocationOfRoom])

ALTER TABLE [CLASS].[class] WITH CHECK
ADD CONSTRAINT [FK_CLASS_ModeOfInstruction] FOREIGN KEY ([ModeOfInstructionKey]) 
REFERENCES [College].[ModeOfInstruction] ([ModeOfInstructionKey])
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [Class].[LoadClass]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Class table
-- =============================================
--
create or alter procedure [Class].[LoadClass]
as
begin
	set nocount on;
declare @CurrentTime datetime2 = SYSDATETIME();
insert into [Class].[Class]
([ClassCode],[SectionNumber],[CourseName], [InstructorName], [DayOfClasses], [ClassCapacity],[ClassroomLocation],[InstructionType],InstructorKey,[ModeOfInstructionKey] )

select  orig.Code,
		orig.sec,
		c.coursename,
		case
		when
		i.InstructorFirstName='no' and orig.code='' then ''
		when
		i.InstructorFirstName='no' and orig.code<>'' then 'No Instructor'
		else
  concat(i.InstructorFirstName, ' ',i.InstructorLastName)
  end
   as InstructorName,
  case
  when
  orig.time = '' then ''
  when
  orig.time = '-' then 'No Assigned date'
  else
  concat(orig.time,' every ',orig.day) 
  end
  as [DayOfClasses],
  case
  when
  orig.enrolled='' and orig.limit='' then ''
  else
  concat(orig.Enrolled, ' of ', orig.Limit) 
  end
  as ClassCapacity,
  case
  when
	rl.LocationOfRoom='' and code='' then ''
  when 
  rl.locationofroom='' and code<>'' then 'No Assigned Location'
  else
  rl.locationofroom
  end
  as
  RoomLocation,
  case
  when
  moi.[Name of the Instruction]='' and orig.code<>'' then 'None' 
  else
  moi.[name of the instruction]
  end as
  [Instruction Type],
  case
  when
		orig.code='' then null
  else
  i.InstructorKey
  end as InstructorKey,
  case	
  when
		orig.code='' then null
  else
		moi.ModeOfInstructionKey
		end as [ModeOfInstructionKey]

from Uploadfile.CoursesSpring2019 as orig
  join college.course as c
on LEFT(orig.[Course (hr, crd)],CharIndex(' ', orig.[Course (hr, crd)], CharIndex(' ', orig.[Course (hr, crd)]) + 1)) = c.CourseName
  join college.instructors as i
on orig.Instructor=i.instructorFullName
  join class.RoomLocation as rl
on orig.Location = rl.LocationOfRoom
  join class.ModeOfInstruction as moi
on orig.[Mode of Instruction] = moi.[Name of the Instruction]


exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Class Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: dbo.Spring2019CourseDatabase
-- Create date: 05/11/2019
-- Description: Create Spring2019CourseDatabase
-- =============================================
--
create table dbo.Spring2019CourseDatabase
(
	[CourseDatabaseKey] int IDENTITY(1,1) Primary key not null,
	[Semester] [varchar](15) NULL DEFAUlT('Spring 2019'),
	[Section] NVARCHAR(50) NOT NULL,
	[ClassCode]	INT NULL,
	[Course (hr, crd)] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[Day] [varchar](50) NULL,
	[Time] [varchar](50) NULL,
	[Instructor] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[Enrolled] [varchar](50) NULL,
	[Limit] [varchar](50) NULL,
	[Mode of Instruction] [varchar](50) NULL,
	[ClassKey] int null ,
	[ClassroomLocation] nvarchar(50)  null,
	[ModeOfInstructionKey] int  null,
    [CourseName] [nvarchar](30)  null,
	[InstructorKey] int  null,
	[ClassTime] char(5)  null Default('9:15'),
	[LastName] varchar(30) DEFAULT ('Pevidal') not null,
	[FirstName] varchar(30)  DEFAULT ('Kirsten') not null,
	QmailEmailAddress varchar(50)  DEFAULT ('kirsten.pevidal08@qmail.cuny.edu') not null,
	DateAdded datetime2 default sysdatetime() not null,
    DateOfLastUpdate datetime2 default sysdatetime() not null,
	AuthorizedUserId int null default ('08')
);
--Set default FKs for Spring2019CourseDatabase table
ALTER TABLE dbo.Spring2019CourseDatabase WITH CHECK
ADD CONSTRAINT [FK_DBO_Class] FOREIGN KEY ([ClassKey]) 
REFERENCES [Class].[Class] ([ClassKey])
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: dbo.[LoadSpring2019CourseDatabase]
-- Create date: 05/11/2019
-- Description: Stored procedure to load Spring2019CourseDatabase table
-- =============================================
--
create or alter procedure dbo.[LoadSpring2019CourseDatabase]
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into dbo.Spring2019CourseDatabase
	([Section],[ClassCode],[Course (hr, crd)],[Description],[Day],[Time],[Instructor],[Location],[Enrolled],[Limit],[Mode of Instruction],[ClassKey],[ClassroomLocation],[ModeOfInstructionKey],[CourseName],[InstructorKey])
	select orig.SectionNumber, 
	case
	when
	orig.classcode='' then null
	else
	orig.classcode
	end 
	as [ClassCode],
	case
	when
	c.coursename='' then ''
	else
	concat(c.coursename,' ','(',c.HoursPerWeek,', ',c.CourseCredit,')') 
	end
	as [Course (hr, crd)],
	c.CourseDescription,
	case
	when orig.dayofclasses= 'No assigned date' then 'No assigned day'
	else
	SUBSTRING(orig.DayOfClasses, charindex('every ',orig.DayOfClasses)+6,LEN(orig.DayOfClasses)-charindex('every ',orig.DayOfClasses))
	end as Day,
	case
	when orig.dayofclasses= 'No assigned date' then 'No assigned time'
	else
	LEFT(orig.DayOfClasses, charindex('M every', orig.DayOfClasses))
	end as [Time],
	case
	when
	orig.instructorname='No instructor' then 'No instructor'
	when orig.instructorname='' then ''
	else
		concat(SUBSTRING(orig.instructorname, charindex(' ',orig.instructorname)+1,LEN(orig.instructorname)-charindex(' ',orig.instructorname)),', ',
			LEFT(orig.instructorname, charindex(' ', orig.instructorname)-1))
	end as [InstructorName],
	orig.ClassroomLocation,
	LEFT(orig.ClassCapacity, charindex(' ', orig.ClassCapacity)) as Enrolled,
	SUBSTRING(orig.classcapacity, charindex('of',orig.classcapacity)+3,LEN(orig.classcapacity)-charindex(' ',orig.classcapacity)) as [Limit],
	orig.InstructionType,
	case
	when
	orig.classcode='' then null
	else
	orig.ClassKey
	end
	as [ClassKey],
	orig.[ClassroomLocation],orig.[ModeOfInstructionKey],orig.[CourseName],[InstructorKey]
	from [class].[class] as orig
	join college.course as c
	on orig.CourseName=c.CourseName
	order by orig.classkey

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Spring2019CourseDatabase Table', @WorkFlowStepTableRowCount = @@RowCount;
end;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: [College].[LoadCourseDatabase]
-- Create date: 05/11/2019
-- Description: Create stored procedure 'LoadCourseDatabse' that will load all loadProcedures
-- =============================================
--
create or alter procedure [College].[LoadCourseDatabase]
as
begin
	declare @CurrentTime datetime2 = SYSDATETIME();
	-- Drop foreign keys before truncation
	exec [Process].[DropForeignKeys]
	-- Truncate star schema data
	exec [Process].TruncateTable

    -- Load the star schema
	exec [College].LoadDepartmentOfInstructor
	exec [College].LoadDepartment
	exec [College].LoadInstructors
	exec [college].LoadCourse
	exec [class].LoadBuildingLocation
	exec [CLASS].[LoadRoomLocation]
	exec [class].LoadModeOfInstruction
	exec [class].loadClass
	exec [dbo].LoadSpring2019CourseDatabase
	
	-- Recreate foreign keys after schema loading
	exec [Process].[AddForeignKeys]
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Course Database', @WorkFlowStepTableRowCount = @@RowCount;
end;

--Test program
truncate table [Process].WorkflowSteps
ALTER SEQUENCE PkSequence.WorkflowStepsSequenceObject RESTART WITH 1 ;  
exec [College].[LoadCourseDatabase]
exec Process.usp_ShowWorkflowSteps

select * from dbo.Spring2019CourseDatabase
--select * from class.class where
