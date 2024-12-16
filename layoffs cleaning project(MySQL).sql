-- DATA CLEANING PROJECT
select*
from layoffs;

create table layoff_staging
like layoffs;

insert into layoff_staging
select *
from layoffs;

select *
from layoff_staging;

-- removing duplicate
with cte_staging as 
(
select *,
row_number() over( partition by company, location,industry,total_laid_off,percentage_laid_off,stage,`date`,stage,country,funds_raised_millions) row_num
from layoff_staging
)
select * 
from cte_staging
where row_num >1;


CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert layoff_staging2
select *,
row_number() over( partition by company, location,industry,total_laid_off,percentage_laid_off,stage,`date`,stage,country,funds_raised_millions) row_num
from layoff_staging;

delete 
from layoff_staging2
where row_num > 1;

-- STANDARDIZING
select company, trim(company)
from layoff_staging2;

update layoff_staging2
set  company = trim(company);

select distinct industry
from layoff_staging2
order by  industry asc;

update layoff_staging2
set  industry= 'cryto currency'
where industry like 'crypt%';

select distinct country
from layoff_staging2
order by  country asc;

update layoff_staging2
set  country= 'United States'
where country like 'United State%';

select *
from layoff_staging2;

update layoff_staging2
set `date` = str_to_date (`date`,'%m/%d/%Y');
alter table layoff_staging2
modify `date` date;

delete
from layoff_staging2
where total_laid_off is null and percentage_laid_off is null;

alter table layoff_staging2
drop row_num;

select *
from layoff_staging2









