create database cmpe226team4;
use cmpe226team4;

CREATE TABLE IF NOT EXISTS `Users`(
	`Username` VARCHAR(20),
    `Password` VARCHAR(20),
    `Role` VARCHAR(10),
    PRIMARY KEY (Username)
);

CREATE TABLE IF NOT EXISTS `Player` (
  `Name` varchar(50) NOT NULL ,
  `Wkts` int(11) DEFAULT 0,
  `Role` varchar(30) NOT NULL DEFAULT 0,
  `Age` int(2) DEFAULT 15,
  `Balls` int(5) default 0,
  `BatAvg` decimal(6,3) DEFAULT 0,
  `BatStrRate` decimal(6,3) DEFAULT 0,
  `Maidens` int(11) DEFAULT 0, 
  `RunsGiven` int(11) DEFAULT 0,
  `Overs` int(11) DEFAULT 0,
  `6s` int(11) DEFAULT 0,
  `4s` int(11) DEFAULT 0,
  `BatHigh` int(3) DEFAULT 0,
  `BowlAvg` decimal(6,3) DEFAULT 0.0,
  `bowlecon` decimal(6,3) DEFAULT 0.0,
  `MoM` int(3) DEFAULT 0,
  `Runs` int(11) DEFAULT 0,
  `Innings` int(11) DEFAULT 0,
  `MatchesPlayed` int(11) DEFAULT 0,
   `PlaysFor` varchar(11) NOT NULL,
   PRIMARY KEY  (`Name`,`PlaysFor`)
);


CREATE TABLE IF NOT EXISTS `Team` (
  `Name` varchar(25) NOT NULL ,
  `Location` varchar(25) NOT NULL,
  `MatchesPlayed` int(5) default 0,
  `MatchesWon` int(5) default 0,
  `MatchesLost` int(5) default 0,
  `MatchesDrawn` int(5) default 0,
  `winp` decimal(5,2) default 0.0,
  PRIMARY KEY (`Name`)
  );
  
CREATE TABLE IF NOT EXISTS `Plays` (
  `MatchID` int(11),
  `T1Name` varchar(25) NOT NULL ,
  `T2Name` varchar(25) NOT NULL,
  `T2Overs` decimal(3,1) NOT NULL DEFAULT 0.0,
  `T1Overs` decimal(3,1) NOT NULL DEFAULT 0.0,
  `T1Score` int(2) NOT NULL DEFAULT 0,
  `T2Score` int(2) NOT NULL , 
  `T1Wkts` int(2) NOT NULL DEFAULT 0, 
  `T2Wkts` int(2) NOT NULL DEFAULT 0,
  `T1Extras` int(2) NOT NULL DEFAULT 0,
  `T2Extras` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`MatchID`, `T1Name`, `T2Name`)
  );
  
    
CREATE TABLE IF NOT EXISTS `Match` (
  `MatchId` int(11) NOT NULL  AUTO_INCREMENT,
  `Date` varchar(15) DEFAULT '01-01-2001',
  `Type` varchar(8) NOT NULL,
  `MoM` varchar(50) NOT NULL,
  `MoMTeam` varchar(25) NOT NULL,
  `Result` varchar(50) NOT NULL,
  `Venue` varchar(40) NOT NULL,
   PRIMARY KEY (`MatchId`)
   );

     
CREATE TABLE IF NOT EXISTS `Officials` (
  `Name` varchar(40) NOT NULL,
  `Sex` varchar(10) NOT NULL,
  `Age` int(2) DEFAULT 15,
  `Nationality` varchar(25) NOT NULL,
  `Role` varchar(20) NOT NULL,
   PRIMARY KEY (`Name`)
);

     
CREATE TABLE IF NOT EXISTS `Venue` (
  `Name` varchar(40) NOT NULL,
  `City` varchar(20) NOT NULL,
  `Country` varchar(25) NOT NULL,
  `Capacity` int(10) NOT NULL DEFAULT 0,
   PRIMARY KEY (`Name`,`City`,`Country`)
);


CREATE TABLE IF NOT EXISTS `TeamSupport` (
  `Name` varchar(40) NOT NULL,
  `Sex` varchar(2) NOT NULL,
  `DoB` int(2) DEFAULT 15,
  `Nationality` varchar(25) NOT NULL,
  `Role` varchar(20) NOT NULL,
   PRIMARY KEY (`Name`)
);


CREATE TABLE IF NOT EXISTS `UmpiresFor` (
	`UmpireName` varchar(50),
    `MatchID` int(11) NOT NULL,
    PRIMARY KEY(`UmpireName`, `MatchID`)
);


CREATE TABLE IF NOT EXISTS `CommentatesFor` (
	`CommentatorName` varchar(50),
    `MatchID` int(11),
    PRIMARY KEY(`CommentatorName`, `MatchID`)
);


CREATE TABLE IF NOT EXISTS `Coaches` (
	`CoachName` varchar(50),
    `TeamName` varchar(25),
    `StartDate` date NOT NULL,
    `EndDate` date,
    PRIMARY KEY(`CoachName`, `TeamName`)
);


CREATE TABLE IF NOT EXISTS `TeamSelectorFor` (
	`SelectorName` varchar(50),
    `TeamName` varchar(25),
    `StartDate` date NOT NULL,
    `EndDate` date,
    PRIMARY KEY(`SelectorName`, `TeamName`)
);

ALTER TABLE `Player`
ADD FOREIGN KEY (PlaysFor) REFERENCES `Team`(Name)
on delete cascade 
on update cascade;


ALTER TABLE `Plays`
ADD FOREIGN KEY (MatchID) REFERENCES `Match`(MatchID)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (T1Name) REFERENCES `Team`(Name)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (T2Name) REFERENCES `Team`(Name)
on delete cascade 
on update cascade
;


ALTER TABLE `Match`
ADD FOREIGN KEY (Venue) REFERENCES `Venue`(Name)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (MoM) REFERENCES `Player`(Name)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (MoMTeam) REFERENCES `Player`(playsfor)
on delete cascade 
on update cascade
;


ALTER TABLE UmpiresFor
ADD FOREIGN KEY (UmpireName) REFERENCES `Officials`(Name)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (MatchID) REFERENCES `Match`(MatchID)
on delete cascade 
on update cascade;


ALTER TABLE CommentatesFor
ADD FOREIGN KEY (CommentatorName) REFERENCES `Officials`(Name)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (MatchID) REFERENCES `Match`(MatchID)
on delete cascade 
on update cascade;


ALTER TABLE Coaches
ADD FOREIGN KEY (CoachName) REFERENCES `TeamSupport`(Name)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (TeamName) REFERENCES `Team`(Name)
on delete cascade 
on update cascade;


ALTER TABLE TeamSelectorFor
ADD FOREIGN KEY (SelectorName) REFERENCES `TeamSupport`(Name)
on delete cascade 
on update cascade,
ADD FOREIGN KEY (TeamName) REFERENCES `Team`(Name)
on delete cascade 
on update cascade;

create TRIGGER innumsix BEFORE INSERT ON Player
FOR EACH ROW SET @num = @num + NEW.`6s`;


create TRIGGER upnumsix BEFORE UPDATE ON Player
FOR EACH ROW SET @num = @num + NEW.`6s`;


set @num = 0;


delimiter $$
create procedure updatePlayerBat()
begin
update player
set batavg = runs/innings, batstrrate = runs/balls;
end $$
delimiter ;

delimiter $$
create procedure updatePlayerBowl()
begin
update player
set bowlavg = runsgiven/wkts, bowlecon = runsgiven/overs;
end $$
delimiter ;

delimiter $$
create procedure toptotalruns()
begin
create view ttr as
select name, playsfor, runs
from player
order by runs desc
limit 10;
end$$
delimiter ;


delimiter $$
create procedure batavg()
begin
create view ba as
select name, playsfor, batavg
from player
order by batavg desc
limit 10;
end$$
delimiter ;


delimiter $$
create procedure highindi()
begin
create view hi as
select name, playsfor, bathigh
from player
order by bathigh desc
limit 10;
end$$
delimiter ;


delimiter $$
create procedure strrate()
begin
create view sr as
select name, playsfor, batstrrate
from player
order by batstrrate
limit 10;
end$$
delimiter ;


delimiter $$
create procedure mostwickets()
begin
create view mw as
select name, playsfor, wkts
from player
order by wkts
limit 10;
end$$
delimiter ;


delimiter $$
create procedure econrate()
begin
create view er as
select name, playsfor, bowlecon
from player
order by bowlecon
limit 10;
end$$
delimiter ;


delimiter $$
create procedure bowlingavg()
begin
create view boa as
select name, playsfor, bowlavg
from player
order by bowlavg
limit 10;
end$$
delimiter ;


delimiter $$
create procedure maidenovers()
begin
create view mo as
select name, playsfor, maidens
from player
order by maidens
limit 10;
end$$
delimiter ;

delimiter $$
create procedure mostwinsteams()
begin
create view mwt as
select name, matcheswon
from team
order by matcheswon
limit 10;
end$$
delimiter ;


delimiter $$
create procedure mostwinpteams()
begin
create view mwpt as
select name, winp
from team
order by winp
limit 10;
end$$
delimiter ;

delimiter $$
create procedure winpteam()
begin
update team
set winp=matcheswon/matchesplayed;
end$$
delimiter ;



#Added index for query performance
ALTER TABLE Player ADD INDEX (name);
