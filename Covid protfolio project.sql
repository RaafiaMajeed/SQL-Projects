 SELECT *
 FROM PortfolioProjectSQL..CovidDeaths$
 WHERE continent is not NULL
 ORDER BY 3,4

 --SELECT * 
 --FROM PortfolioProjectSQL..CovidVaccinations$
 --ORDER BY 3,4


 --Lets select the data which i am going to use
  SELECT location,date,total_cases,new_cases,total_deaths,population
  FROM PortfolioProjectSQL..CovidDeaths$
  WHERE continent is not NULL
  ORDER BY 1,2

  --LETS LOOK AT TOTAL CASES VS TOTAL Deaths
 -- We need to convert the columns data type from nvarchar to float using Convert function
 ---using the followng querry we can find out the death rate percentage from covid in Pakistan

  SELECT location, date, total_cases, total_deaths,
  (Cast(total_deaths as float) / cast(total_cases as float)*100) AS death_percentage
  FROM PortfolioProjectSQL..CovidDeaths$
  WHERE location ='Pakistan'
  order by 1,2

  ---- lets look at total cases w.r.t to popultion which gives percentage of population who got Covid

  SELECT location, date, total_cases, population,
  (cast(total_cases as float) / cast(population as float)*100) AS case_percentage
  FROM PortfolioProjectSQL..CovidDeaths$
  order by 1,2

  ---looking at coutries with highest infection rate w.r.t poulation
  SELECT location, population, MAX(total_cases) as Highest_infection_number,
 MAX((CAST(total_cases as float) / cast(population as float)*100)) AS infected_population_percentage
  FROM PortfolioProjectSQL..CovidDeaths$
  GROUP BY Location,population
  order by infected_population_percentage DESC


  ---hIGHEST DEATH Number BY CUNTRY 
  SELECT location,  MAX(total_deaths) as Highest_death_number
  from PortfolioProjectSQL..CovidDeaths$
  WHERE continent is not NULL
  GROUP BY location
  Order by Highest_death_number desc
   
  --- looking at data with highest death rate per poulation
 SELECT location, population, MAX(total_deaths) as Highest_death_number,
 MAX((CONVERT(FLOAT, total_deaths) / CONVERT(FLOAT, population)*100)) AS death_percentage
  FROM PortfolioProjectSQL..CovidDeaths$
  GROUP BY Location,population
  order by Highest_death_number DESC

  ---lets group the things by continent
  SELECT continent,  MAX(total_deaths) as Highest_death_number
  from PortfolioProjectSQL..CovidDeaths$
  WHERE continent is not NULL
  GROUP BY continent
  Order by Highest_death_number desc

  ---- lets show the continents with death counts per population
  SELECT continent,  MAX(total_deaths) as Highest_death_number
  from PortfolioProjectSQL..CovidDeaths$
  WHERE continent is not NULL
  GROUP BY continent
  Order by Highest_death_number desc


  ---	global numbers
   --in order to avoid divide by zero error we are using case 



  SELECT date,SUM(CAST(new_cases AS INT)) AS total_new_cases, SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS INT)) <> 0 THEN
            (SUM(CAST(new_deaths AS INT)) * 100.0) / SUM(CAST(new_cases AS INT))
        ELSE NULL
    END AS death_percentage
FROM PortfolioProjectSQL..CovidDeaths$
WHERE continent IS NOT NULL
GROUP by date
Order by 1,2;

-------------------------------------------------------
--lets find out population vs those who got vaccinated 
---------------------------------------------------------

SELECT death.continent,death.location,death.date,death.population,vac.new_vaccinations
, sum(cast (vac.new_vaccinations as bigint)) over (Partition by death.location order by death.location,death.date) as Rollingpeoplevaccinated
--, Rollingpeoplevaccinated/death.population/100
from PortfolioProjectSQL..CovidDeaths$ as death
JOIN PortfolioProjectSQL..CovidVaccinations$ as vac
   on death.location=vac.location
   and death.date=vac.date
where death.continent is not null
order by 2,3


---------------lets use CTE--------------------------------------------------------------------------

With population_vs_vacc (Continent,Location,Date,population,new_vaccinations, Rollingpeoplevaccinated) 
as
(
SELECT death.continent,death.location,death.date,death.population,vac.new_vaccinations,
sum(cast (vac.new_vaccinations as bigint)) over (Partition by death.location order by death.location,death.date) as Rollingpeoplevaccinated
--, Rollingpeoplevaccinated/death.population/100
from PortfolioProjectSQL..CovidDeaths$ as death
JOIN PortfolioProjectSQL..CovidVaccinations$ as vac
   on death.location=vac.location
   and death.date=vac.date
where death.continent is not null
--order by 2,3
)
SELECT *, (Rollingpeoplevaccinated/population)*100
FROM population_vs_vacc

--------------Using Temp table to calculate percentage of population vaccinated
DROP TABLE IF exists #Percentpopulationvaccinated
CREATE TABLE #Percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new__vaccinations numeric,
Rollingpeoplevaccinated numeric
)

insert into #Percentpopulationvaccinated
SELECT death.continent,death.location,death.date,death.population,vac.new_vaccinations,
sum(cast (vac.new_vaccinations as bigint)) over (Partition by death.location order by death.location,death.date) as Rollingpeoplevaccinated
--, Rollingpeoplevaccinated/death.population/100
from PortfolioProjectSQL..CovidDeaths$ as death
JOIN PortfolioProjectSQL..CovidVaccinations$ as vac
   on death.location=vac.location
   and death.date=vac.date
where death.continent is not null
--order by 2,3
SELECT *, (Rollingpeoplevaccinated/population)*100
FROM #Percentpopulationvaccinated

------ creating view to store data to be used later for visualization

Create view PercentPopulationVaccinated as

SELECT death.continent,death.location,death.date,death.population,vac.new_vaccinations,
sum(cast (vac.new_vaccinations as bigint)) over (Partition by death.location order by death.location,death.date) as Rollingpeoplevaccinated
--, Rollingpeoplevaccinated/death.population/100
from PortfolioProjectSQL..CovidDeaths$ as death
JOIN PortfolioProjectSQL..CovidVaccinations$ as vac
   on death.location=vac.location
   and death.date=vac.date
where death.continent is not null

