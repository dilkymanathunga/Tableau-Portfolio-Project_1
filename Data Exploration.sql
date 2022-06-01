/* Covid 19 Data Exploration 

Skills used - Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select * from PortfolioProject..CovidDeaths where continent is not null order by 3,4

--select data that we are going to be starting with

select location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths where continent
is not null order by 1,2

--Total cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from 
PortfolioProject..CovidDeaths where location like '%state%' and continent is not null order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location, date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected from PortfolioProject..
CovidDeaths order by 1,2

-- Countries with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths group by location, population order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths where continent is not null
group by location order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select continent, MAX(cast(total_deaths as int))  as TotalDeathCount from PortfolioProject..CovidDeaths
where continent is not null group by continent order by TotalDeathCount desc

-- GLOBAL NUMBERS

select SUM(new_cases)as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths where continent is not null order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations))
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date where dea.continent is not
null order by 2,3 
--error

-- Using CTE to perform Calculation on Partition By in previous query
