create database ESports_Tournament_Management_Analysis;
use ESports_Tournament_Management_Analysis;
create table Tournaments(
 TournamentID int primary key,
 TournamentName varchar(100),
 StartDate date,
 EndDate date,
 Location varchar(100)
 );
 create table Teams(
  TeamID int primary key,
  TeamName varchar(100),
  CoachName varchar(100),
  Country varchar(100)
  );
  create table players(
    PlayerID int primary key,
    PlayerName varchar(100),
    TeamID int,
    Role varchar(50),
    Age int,
    Country varchar(50),
    foreign key (TeamID) references Teams(TeamID)
    );
    create table matches(
    MatchID int primary key,
    TournamentID int,
    MatchDate date,
    Team1ID int,
    Team2ID int,
    WinnerTeamID int,
    foreign key (TournamentID) references Tournaments(TournamentID),
    foreign key (Team1ID) references Teams(TeamID),
    foreign key (Team2ID) references Teams(TeamID),
    foreign key (WinnerTeamID) references Teams(TeamID)
    );
    create table scores(
     ScoreID INT PRIMARY KEY,
    MatchID INT,
    TeamID INT,
    Score INT,
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
CREATE TABLE PrizeMoney (
    TournamentID INT,
    TeamID INT,
    PrizeAmount DECIMAL(10, 2),
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
   -- Tournaments
INSERT INTO Tournaments (TournamentID, TournamentName, StartDate, EndDate, Location)
VALUES 
(1, 'Global E-Sports Cup', '2024-08-01', '2024-08-10', 'Los Angeles'),
(2, 'World Championship', '2024-09-01', '2024-09-15', 'New York');

-- Teams
INSERT INTO Teams (TeamID, TeamName, CoachName, Country)
VALUES 
(1, 'Team Alpha', 'John Doe', 'USA'),
(2, 'Team Bravo', 'Jane Smith', 'Canada'),
(3, 'Team Gamma', 'Amit Sharma', 'India'),
(4, 'Team Delta', 'Ravi Kumar', 'India');

-- Players
INSERT INTO Players (PlayerID, PlayerName, TeamID, Role, Age, Country)
VALUES 
(1, 'Alice', 1, 'Captain', 25, 'USA'),
(2, 'Bob', 1, 'Support', 22, 'USA'),
(3, 'Charlie', 2, 'Captain', 24, 'Canada'),
(4, 'David', 2, 'Support', 23, 'Canada'),
(5, 'Esha', 3, 'Captain', 26, 'India'),
(6, 'Faiz', 3, 'Support', 21, 'India'),
(7, 'Gita', 4, 'Captain', 27, 'India'),
(8, 'Hari', 4, 'Support', 22, 'India');

-- Matches
INSERT INTO Matches (MatchID, TournamentID, MatchDate, Team1ID, Team2ID, WinnerTeamID)
VALUES 
(1, 1, '2024-08-02', 1, 2, 1),
(2, 1, '2024-08-03', 3, 4, 3),
(3, 1, '2024-08-04', 1, 3, 1),
(4, 1, '2024-08-05', 2, 4, 4),
(5, 2, '2024-09-02', 1, 2, 2),
(6, 2, '2024-09-03', 3, 4, 4),
(7, 2, '2024-09-04', 1, 3, 3),
(8, 2, '2024-09-05', 2, 4, 2);

-- Scores
INSERT INTO Scores (ScoreID, MatchID, TeamID, Score)
VALUES 
(1, 1, 1, 3),
(2, 1, 2, 1),
(3, 2, 3, 2),
(4, 2, 4, 1),
(5, 3, 1, 2),
(6, 3, 3, 1),
(7, 4, 2, 1),
(8, 4, 4, 2),
(9, 5, 1, 1),
(10, 5, 2, 3),
(11, 6, 3, 2),
(12, 6, 4, 3),
(13, 7, 1, 1),
(14, 7, 3, 2),
(15, 8, 2, 3),
(16, 8, 4, 1);

INSERT INTO PrizeMoney (TournamentID, TeamID, PrizeAmount)
VALUES 
(1, 1, 50000.00),
(1, 2, 25000.00),
(2, 3, 40000.00),
(2, 4, 30000.00);
-- Top Performing Teams:
-- Identify the top-performing teams based on their total scores in a specific tournament 
select teams.TeamName,sum(scores.Score) as Total_Score
from scores
join teams on scores.TeamID = teams.TeamId
join matches on scores.MatchID = matches.MatchID
where matches.TournamentID =1
group by teams.TeamName
order by Total_Score desc;

-- Player Performance Metrics:
-- Calculate the average score per match for each player.
select players.PlayerName, avg(Scores.score) as AverageScore
from scores
join Players on scores.TeamID = players.TeamID
group by players.PlayerName
order by AverageScore desc;

-- Match Performance:
-- Find the highest-scoring match in the tournament.
select matches.MatchID , sum(scores.score) as TotalScore
from scores
join matches on scores.MatchID = matches.MatchId
where matches.TournamentID=1
group by matches.MatchID
order by TotalScore desc
limit 1;

-- Team Win Rate:
-- Calculate the win rate of each team in the tournament.
SELECT Teams.TeamName, 
       COUNT(Matches.WinnerTeamID) AS Wins,
       COUNT(Matches.MatchID) AS TotalMatches,
       (COUNT(Matches.WinnerTeamID) * 100.0 / COUNT(Matches.MatchID)) AS WinRate
FROM Teams
LEFT JOIN Matches ON Teams.TeamID = Matches.WinnerTeamID
WHERE Matches.TournamentID = 1
GROUP BY Teams.TeamName;

-- Player Participation:
-- List players who participated in the most matches.
SELECT Players.PlayerName, COUNT(Matches.MatchID) AS MatchesPlayed
FROM Players
JOIN Teams ON Players.TeamID = Teams.TeamID
JOIN Matches ON Teams.TeamID IN (Matches.Team1ID, Matches.Team2ID)
WHERE Matches.TournamentID = 1
GROUP BY Players.PlayerName
ORDER BY MatchesPlayed DESC;

-- Team Composition:
-- Determine the average age of players in each team.
select Teams.TeamName,avg(players.Age) as Average_Age
from players
join teams on players.TeamID = teams.TeamID
group by  teams.TeamName;

-- Match Outcomes:
-- Display the outcomes of all matches in the tournament.
SELECT Matches.MatchID, T1.TeamName AS Team1, T2.TeamName AS Team2, T3.TeamName AS Winner
FROM Matches
JOIN Teams T1 ON Matches.Team1ID = T1.TeamID
JOIN Teams T2 ON Matches.Team2ID = T2.TeamID
JOIN Teams T3 ON Matches.WinnerTeamID = T3.TeamID
WHERE Matches.TournamentID = 1;

-- Player Age Distribution:
-- Show the age distribution of players in the tournament.
SELECT Age, COUNT(PlayerID) AS NumberOfPlayers
FROM Players
GROUP BY Age
ORDER BY Age;

-- Total Points by Country:
-- Calculate the total points scored by teams from each country.
SELECT Teams.Country, SUM(Scores.Score) AS TotalScore
FROM Scores
JOIN Teams ON Scores.TeamID = Teams.TeamID
GROUP BY Teams.Country
ORDER BY TotalScore DESC;

-- Financial Report:
-- Assume we have a table for prize money distribution and generate a report.
SELECT Tournaments.TournamentName, Teams.TeamName, PrizeMoney.PrizeAmount
FROM PrizeMoney
JOIN Tournaments ON PrizeMoney.TournamentID = Tournaments.TournamentID
JOIN Teams ON PrizeMoney.TeamID = Teams.TeamID
WHERE Tournaments.TournamentID IN (1, 2);





