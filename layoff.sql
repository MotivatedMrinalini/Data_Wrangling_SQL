-- Data Cleaning

show tables;
Select * 
From layoffs;



-- ***********************************************  COLUMN DESCRIPTION(COLUMN NAME : STAGE     ***************************************

/* STAGE(startup funding stages) COLUMN :
	
    
      *************************************      LAYMAN TERMS      ******************************
      
seed stage :	mostly startups which come on shark tank are seed staged and they come to angel investors which we see in the show										

Series:	investment to expand thebusiness										

Private Equity	when organiztions like CVC Capital Partners or Blackstone chip in . Eg the company now needs 10000 crore so these companies 
say that they will provide 1000 crore .Private equity basically raise money and help businesses. They are like middle man. 
The profit margin received by the
private equity firm from the new business is further devided : some amount is kept for them and some is returned to the firms via which money
was taken from the private equity company.										

Pre ipo	"Pre-IPO stands for ""pre-initial public offering"" and refers to the process of buying shares in a private company before it goes public.
(Companies use pre-IPO to raise capital for growth and expansion, settle debts, and build investor interest.)  …..

Pre-IPO investors are often private equity firms, hedge funds, and other institutions."										
ipo	company is now listed. Looking at the profit the company has made, the public can make  an informed decision whether or not to buy 										

post ipo	now its available for both buying and selling(trading)										

    
  *******************************************     FORMAL MEANING    **********************************************   
  
Pre-seed: The first stage of funding for a startup 
Seed: The first investment in a startup to get it started 
Series A: Used to finance the initial product development and launch 
Series B: Used to finance expansion, such as hiring new team members or opening new offices 
Series C: Used to finance further growth, such as expanding into new markets 
Series D, E, and so on: Additional funding rounds that may occur between Series C and IPO 
Private Equity:
Description: Investment from firms that may buy the company(stake /acquire) to improve it and then sell it or take it public again.

Pre-IPO Shares:

Pre-IPO shares are the shares of ownership in organisations that haven't submitted an IPO application yet. 
Accredited investors, institutional investors, private equity firms, and venture capitalists commonly buy these shares.
Buying pre-IPO shares allows investors to participate in a business at an early stage, with the possibility of significant
returns as the firm gets closer to its initial public offering.

# The founders or investors look for ways to exit the business. This can happen through:
	IPO (Initial Public Offering)
	Acquisition by another company

IPO : Initial Public Offering (IPO): The process of offering corporate shares to the general public
The final stage of a private corporation transitioning to a publicly traded company is the IPO stage. 
This is when the company issues new stocks to the general public, and public investors can now purchase shares in the business. 
This funding stage not only provides the company with a large amount of capital to continue to achieve its growth objectives, 
but it also opens up the opportunity for the public to invest in the company and potentially earn a return on its investment.



Acquired:
Description: The company is bought by another company, integrating into a larger business. can happen at any stage.

Subsidary:post aquiring. to keep it as a seperate entity or to merge the business is the decision to be taken.
 eg if carat lane under tanishq is merged people might buy cheaper ma=aterial of carat lane instead of tanishqq goods

Post-IPO Shares:

Shares that are eligible for trading on public stock exchanges after a successful initial public offering are referred to as post-IPO shares or 
listed shares. Institutional and individual investors can access these shares through the secondary market. The advantage of post-IPO shares is 
their liquidity, which enables buying and selling in accordance with the present market price. (Now we cannot just buy we can even sell or trade)

*/



-- ***********************  STEPS TO CLEAN THE DATA  ***********************
/*
	1.REMOVE DUPLICATES
    2.STANDARDIZE THE DATA
    3.NULL VALUES OR BLANK VALUES
    4.REMOVE ANY COLUMNS/rows
*/
-- ***********************  ***********************  ***********************
CREATE TABLE layoffs_staging
LIKE layoffs;

select * from layoffs_staging;


insert layoffs_staging
select * from layoffs;

select * from layoffs_staging;

describe layoffs_staging;

Select *,
row_number()over(partition by company,location, industry, total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions)  as row_num
from layoffs_staging;



with duplicate_cte as 
	(
Select *,
row_number()over(partition by company,location, industry, total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions)  as row_num
from layoffs_staging
    )
select * 
from duplicate_cte
where row_num>1;

/*select * 
from layoffs_staging
where company='Casper';*/

/*
with duplicate_cte as 
	(
Select *,
row_number()over(partition by company,location, industry, total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions)  as row_num
from layoffs_staging
    )
delete 
from duplicate_cte
where row_num>1;

-- Error Code: 1288. The target table duplicate_cte of the DELETE is not updatable	0.016 sec :: we can only read via SQL in mysql
*/

-- right click on layoffs_stagging and copy to clipboard ,manually rename it to  layoffs_staging2; add rownum column:-
CREATE TABLE `layoffs_staging2` (
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
select * from layoffs_staging2;

insert into layoffs_staging2
Select *,
row_number()over(partition by company,location, industry, total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions)  as row_num
from layoffs_staging;

select * from layoffs_staging2
where row_num>1;


Delete from layoffs_staging2
where row_num>1;

select * from layoffs_staging2;

-- standardizing data

select * from layoffs_staging2;
desc layoffs_staging2;
# date column is in text format and it doesn't seem right
select * from layoffs_staging2;
select `date` ,
STR_TO_DATE(`date`,'%m/%d/%Y')
from layoffs_staging2;


update layoffs_staging2
set `date` = STR_TO_DATE(`date`,'%m/%d/%Y');
select * from layoffs_staging2;
desc layoffs_staging2;
Alter table layoffs_staging2
modify column `date` Date;

#we see extra space towards the left in company column

select distinct(company)
from layoffs_staging2;

select distinct(trim(company))
from layoffs_staging2;

select company,trim(company)
from layoffs_staging2;

SET SQL_SAFE_UPDATES = 0; #disable the safe mode in a MySQL session to let update command work

update layoffs_staging2
set company=trim(company);

select company,trim(company)
from layoffs_staging2;

select distinct(industry)  # scan through this column and look for any standardization issue
from layoffs_staging2 
order by 1;
			#Crypto
			#Crypto Currency
			#CryptoCurrency
            
select * 
from layoffs_staging2
where industry like 'Crypto%' ; #on scanning through column 'industry' we see most industries are marked as crypto

update layoffs_staging2
set  industry='Crypto'
where industry like 'Crypto%';

select distinct(industry) 
from layoffs_staging2 
order by 1;


select * 
from layoffs_staging2 ;

select distinct(location) 
from layoffs_staging2 
order by 1;# no issue as such

select distinct(country) 
from layoffs_staging2 
order by 1; 
#United States
#United States.

select *
from layoffs_staging2 
where country like 'United States%'
; 

select distinct country,trim(trailing '.' from country)
from layoffs_staging2 
order by 1;

update layoffs_staging2
set  country=trim(trailing '.' from country)
where country like 'United States%';

select *
from layoffs_staging2 ;
-- ************** Null values


select *
from layoffs_staging2 ;
select *
from layoffs_staging2 
where total_laid_off is null;

select *
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

-- select *
-- from layoffs_staging2;

select distinct(industry)
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry is null or industry='';

update layoffs_staging2
set industry=null
where industry='';

select *
from layoffs_staging2
where company="Carvana";

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
						on t1.company=t2.company
                        where t1.industry is null 
                        and t2.industry is not null;
                        
Update layoffs_staging2 t1
join layoffs_staging2 t2
						on t1.company=t2.company
set t1.industry=t2.industry
                        where t1.industry is null 
                        and t2.industry is not null;
/*
1. Join
Original Tables:
t1 (the table being updated) and t2 (the table being joined).
Join View:
A temporary result set is created by joining t1 and t2 on the condition t1.company = t2.company.
This view includes all combinations of matching rows, resulting in multiple rows where t1 and t2 match by company.
Memory Update:
At this stage, there is no change to the memory; it's merely a virtual table representing the combinations of t1 and t2.
2. Filtering (WHERE)
Original Tables:
The filtering applies to both t1 and t2 based on the specified conditions.
Join View:
The WHERE clause filters the join view to include only rows where t1.industry is NULL and t2.industry is not NULL.
This results in a subset of the join view that identifies which rows can be updated. For example, if there’s one NULL in t1 and two
 "travel" entries in t2, 
both will be available for the update.
Memory Update:
The filtered view is created in memory, which indicates the rows that will be considered for the update, but no updates have occurred yet.
3. Setting (SET)
Original Tables:
The actual t1 table will be modified based on the results from the filtering.
Join View:
The values from t2.industry in the filtered join view are used to update the corresponding NULL entries in t1.industry.
Memory Update:
The SET clause updates the NULL entry in t1.industry to one of the non-null values from t2.industry (e.g., "travel"). This change is made
 directly to the original t1 table in memory.
*/
select *
from layoffs_staging2
where company like "Bally's%";
/*Bally's Interactive
Carvana
Juul
Airbnb*/
-- ######################################
select *
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

Delete
from layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2 ;
desc layoffs_staging2;

alter table layoffs_staging2
drop column row_num;






select *
from layoffs_staging2 ;
desc layoffs_staging2;
/*
We have checked if null vlues exist for any of the below , mostly it doesn't:::::
company            -->no null values
location            -->no null values
industry            -->1 null value (text data type)
total_laid_off			--> 378 null values (number data type)
percentage_laid_off			--> 423 null values(number data type)
date           -->1 null value  (date data type)
stage           -->5 null values
country           -->no null values
funds_raised_millions --> 165 null values(number data type)
*/
-- select country
-- from layoffs_staging2 
-- where country is null;

-- ************************* We have cleaned the data   *************************************
-- ******************EDA********************************


select *
from layoffs_staging2 ;



select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2 ;

select *
from layoffs_staging2 
where percentage_laid_off=1
order by total_laid_off desc;

select *
from layoffs_staging2 
where percentage_laid_off=1
order by funds_raised_millions desc;

select min(`date`),max(`date`)
from layoffs_staging2;

select company,sum(total_laid_off)
from layoffs_staging2 
group by company
order by 2 desc;

select industry,sum(total_laid_off)
from layoffs_staging2 
group by industry
order by 2 desc;

select country,sum(total_laid_off)
from layoffs_staging2 
group by country
order by 2 desc;

select stage,sum(total_laid_off)
from layoffs_staging2 
group by stage
order by 2 desc;

select YEAR(`date`),sum(total_laid_off)
from layoffs_staging2 
group by YEAR(`date`)
order by 1 desc;




#rolling total of layoffs( basis month)
select *
from layoffs_staging2 ;
select substring(`date`,1,7) as `Month` ,sum(total_laid_off)
from layoffs_staging2 
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc;

with rolling_total_cte as
(
select substring(`date`,1,7) as `Month` ,sum(total_laid_off) as total_off
from layoffs_staging2 
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc)
select `Month` , total_off,sum(total_off)over(order by `Month`) as rolling_total
from rolling_total_cte ;
/* understandiong order by within over()
SUM(spend) OVER (
     PARTITION BY product
     ORDER BY transaction_date) AS running_total
Here's what each SQL command in the window function is doing:

SUM(): SUM(spend) is a typical aggregate function
OVER: OVER required for window functions
PARTITION BY: makes each product it's own section / window,
ORDER BY: the data is ordered by transaction_date, and the running_total accumulates the sum across the current row and all subsequent rows of spend
ORDER BY: ORDER BY essentially sorts the data by the specified column, similar to an ORDER BY clause.
Without ORDER BY, each value would be a sum of all the spend values without its respective product.
*/


select company,YEAR(`date`),sum(total_laid_off)
from layoffs_staging2 
group by company,YEAR(`date`)
order by 3 desc;

with company_year(company,years,total_laid_off)as 
(
select company,YEAR(`date`),sum(total_laid_off)
from layoffs_staging2 
group by company,YEAR(`date`)
),
company_year_rank as(
select * ,dense_rank()over(partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
)
select * from company_year_rank
where ranking<=5;



