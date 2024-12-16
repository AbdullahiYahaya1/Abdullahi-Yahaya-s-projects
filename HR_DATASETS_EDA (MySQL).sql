select *
from hr_table;
create table hr_table_staging
like hr_table;

insert hr_table_staging
select *
from hr_table;

select dob
from hr_table_staging;

update  hr_table_staging
set dob = str_to_date( dob, '%m/%d/%Y');

alter table hr_table_staging
modify dob date;

select dateofhire,dateoftermination,LastPerformanceReview_Date
from hr_table_staging;

update hr_table_staging
set dateofhire = str_to_date(dateofhire, '%m/%d/%Y');
update hr_table_staging
set 
LastPerformanceReview_Date = str_to_date(LastPerformanceReview_Date, '%m/%d/%Y');

alter table hr_table_staging
modify dateofhire date, modify LastPerformanceReview_Date date;
alter table hr_table_staging
modify zip int;

alter table hr_table_staging
rename column ï»¿Employee_Name to Employee_Name;
select Department, trim(department) Departments
from hr_table_staging;

update hr_table_staging
set department = trim(department);

select MarriedID, count(MarriedID)
from hr_table_staging
group by MarriedID;

select MaritalstatusID,MaritalDesc, count(MaritalstatusID)
from hr_table_staging
group by MaritalStatusID,MaritalDesc;

select deptid,Department, count(Department) Total_employees_in_departments
from hr_table_staging
group by deptid, Department;

select *
from hr_table_staging
where DeptID = 5;

update hr_table_staging
set deptid= 4
where deptid = 1 and department = 'Software Engineering';

update hr_table_staging
set deptid = 5
where deptid = 6 and department = 'Production';

select genderid,sex, count(GenderID) Sum_of_gender
from hr_table_staging
group by GenderID,sex;

select PerformanceScore,sex, count(sex) Sum_of_gender
from hr_table_staging
group by PerformanceScore,sex;

select RecruitmentSource,PerformanceScore, count(RecruitmentSource),EmpSatisfaction, sum(EmpSatisfaction)
from hr_table_staging
group by RecruitmentSource,PerformanceScore,EmpSatisfaction;

CREATE TABLE `hr_table_staging2` (
  `Employee_Name` text,
  `EmpID` int DEFAULT NULL,
  `MarriedID` int DEFAULT NULL,
  `MaritalStatusID` int DEFAULT NULL,
  `GenderID` int DEFAULT NULL,
  `EmpStatusID` int DEFAULT NULL,
  `DeptID` int DEFAULT NULL,
  `PerfScoreID` int DEFAULT NULL,
  `FromDiversityJobFairID` int DEFAULT NULL,
  `Salary` int DEFAULT NULL,
  `Termd` int DEFAULT NULL,
  `PositionID` int DEFAULT NULL,
  `Position` text,
  `State` text,
  `zip` int DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `Sex` text,
  `MaritalDesc` text,
  `CitizenDesc` text,
  `HispanicLatino` text,
  `RaceDesc` text,
  `dateofhire` date DEFAULT NULL,
  `DateofTermination` text,
  `TermReason` text,
  `EmploymentStatus` text,
  `Department` text,
  `ManagerName` text,
  `ManagerID` int DEFAULT NULL,
  `RecruitmentSource` text,
  `PerformanceScore` text,
  `EngagementSurvey` double DEFAULT NULL,
  `EmpSatisfaction` int DEFAULT NULL,
  `SpecialProjectsCount` int DEFAULT NULL,
  `LastPerformanceReview_Date` date DEFAULT NULL,
  `DaysLateLast30` int DEFAULT NULL,
  `Absences` int DEFAULT NULL,
  `yearofhire` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert hr_table_staging2
select *, year(dateofhire) 
from hr_table_staging;

select yearofhire, max(yearofhire)
from hr_table_staging2
group by yearofhire
order by max(yearofhire) desc;

with hr_cte as
(
select EmpID, Employee_Name, sex, yearofhire,
case 
when `yearofhire`  between 2015 and 2019 then 'Reg_insurance'
when `yearofhire` <= 2014 then 'need_demograph_update' else 'new_employee'

end as New_emp_status
from hr_table_staging2)

select *
from hr_cte
where new_emp_status = 'need_demograph_update';

select Employee_Name, specialprojectscount
from hr_table_staging
order by specialprojectscount asc;

select RaceDesc,  avg(Salary), sum(Salary)
from hr_table_staging
group by RaceDesc;

with hr_cte2 as(
select EmpID, Employee_Name, Sex, salary,
case
when EmpSatisfaction = 5 and EmploymentStatus = 'active' then Salary*0.2

end as Bonus
from hr_table_staging)


select*
from hr_cte2
where Bonus is not null






