/*
Module: MLDM193-01
Version: 1A
Project Name: MMORPG (ark_mmorpg)
Author: Lucinda Frohlich
Student Number: BE2010-0649
Start Date: 18.03.2019
End Date: 01/04/2019
*/

-- Using master database
USE MASTER
GO
PRINT 'Using master database' --prints a line

--deletes the database if it already exists
IF EXISTS (SELECT name FROM master.dbo.sysdatabases 
WHERE name = 'ark_mmorpg')
DROP DATABASE ark_mmorpg
GO

--creating the ark_mmorpg database
CREATE DATABASE ark_mmorpg
ON PRIMARY
(
	NAME = 'ark_mmorpg_data',
	FILENAME = 'C:\TSQL DATABASES\ark_mmorpg_data.mdf',
	SIZE = 5MB,
	FILEGROWTH = 10%
)
LOG ON
(
	NAME = 'ark_mmorpg_log',
	FILENAME = 'C:\TSQL DATABASES\ark_mmorpg_data.ldf',
	SIZE = 5MB,
	FILEGROWTH = 10%
)
GO
PRINT 'The ark_mmorpg database has been sucessfully created'--prints a line

--Using ark_mmorpg database
USE ark_mmorpg
GO
PRINT 'Using ark_mmorpg database' --prints a line

--creating player table
CREATE TABLE player
(
	playerID INT NOT NULL IDENTITY PRIMARY KEY, --auto-generated numbers
	firstName VARCHAR (30) NOT NULL,
	lastName VARCHAR (30) NOT NULL,
	email VARCHAR (50) NOT NULL UNIQUE,
	CONSTRAINT player_EMAIL_ADD CHECK (email LIKE '%_@_%._%'), --checking email format is correct
)
GO
PRINT 'The player table has been created successfully' --prints a line

--creating a Unique index of the player table
CREATE UNIQUE INDEX indx_player
ON player (playerID, email)
WITH IGNORE_DUP_KEY
GO
Print 'The player table has been successfully indexed' --prints a line

--creating the playerAccount table
CREATE TABLE playerAccount
(
	playerTag VARCHAR (30) NOT NULL PRIMARY KEY,
	accountStatus VARCHAR (10) NOT NULL,
	paymentDate DATE NOT NULL,
	expiryDate DATE NOT NULL, -- 30 days from date of payment
	playerRef INT NOT NULL IDENTITY REFERENCES player (playerID) --Foreign key
)
GO
PRINT 'The playerAccount table has been created succesfully' --prints a line

--creating a Unique index of the playerAccount table
CREATE UNIQUE INDEX indx_playerAccount
ON playerAccount (playerTag, accountStatus)
WITH IGNORE_DUP_KEY
GO
Print 'The playerAccount table has been successfully indexed' --prints a line

--creating playerCharacters table
CREATE TABLE characters
(
	characterID INT NOT NULL PRIMARY KEY,
	skillLevel INT NOT NULL,
	characterName VARCHAR (30) NOT NULL,
	team VARCHAR (30) NOT NULL,
	playerIden VARCHAR (30) NOT NULL REFERENCES playerAccount (playerTag) --Foreign key
)
GO
PRINT 'The characters table has been created successfully' --prints a line

--creating a Unique index of the characters table
CREATE UNIQUE INDEX indx_character
ON characters (characterID,skillLevel)
WITH IGNORE_DUP_KEY
GO
Print 'The characters table has been successfully indexed' --prints a line

--creating items table
CREATE TABLE items
(
	itemID INT NOT NULL IDENTITY PRIMARY KEY,
	itemName VARCHAR (30) NOT NULL
)
GO
PRINT 'The items table has been created successfully'

--creating a Unique index of the items table
CREATE UNIQUE INDEX indx_items
ON items (itemID, itemName)
WITH IGNORE_DUP_KEY
GO
PRINT 'The items table has been successfully indexed'

--creating the characterInventory table
CREATE TABLE inventorySlots
(
	slotID INT NOT NULL CHECK (slotID <= 8),
	stackQuantity INT NOT NULL,
	characterRef INT NOT NULL REFERENCES characters (characterID), --foreign key
	itemRef INT NOT NULL REFERENCES items (itemID), --foreign key
	PRIMARY KEY (itemRef, characterRef)
)
GO
PRINT 'The inventorySlots table successfully created'

--creating a Unique index of the inventorySlots table
CREATE UNIQUE INDEX indx_slots
ON inventorySlots (slotID,itemRef,stackQuantity)
WITH IGNORE_DUP_KEY
GO
PRINT 'The inventorySlots table has been successfully indexed'

--creating errorLog table
CREATE TABLE errorLog
(
	errorID INT NOT NULL IDENTITY PRIMARY KEY,
	errorType VARCHAR (50) NOT NULL,
	errorMessage VARCHAR (100) NOT NULL
)
GO
PRINT 'The errorLog Table has been successfully created'

--creating a Unique index of the errorLog table
CREATE UNIQUE INDEX indx_errorLog
ON errorLog (errorID,errorMessage)
WITH IGNORE_DUP_KEY
GO
PRINT 'The errorLog table has been successfully indexed'

--populating the player table
INSERT INTO player(firstName,lastName,email) VALUES
	('Lucinda','Zachos','lucindazachos@gmail.com'),
	('Christos','Zachos','christzachos@gmail.com'),
	('Tasmin','Mackillican','tasminmac@gmail.com'),
	('Jay','Da Silva','jay_d_s@gmail.com'),
	('Lola','Frohlich','lolafrohlich@gmail.com'),
	('Peter','Frohlich','petefrohlich@gmail.com'),
	('Georgie','Savvas','g_saaaaavas@gmail.com'),
	('Gabriella','Zachos','gabzzachos@gmail.com'),
	('Pedro','Batista','pedrooooo@gmail.com'),
	('Jan','Venter','janventer007@gmail.com'),
	('Molly','Mckernan','mollymckernan@hotmail.com'),
	('Ryno','van Zyl','rynovanzyl@outlook.com'),
	('Nelly','Wiggett','nellywiggett@gmail.com'),
	('Eric','Aspeling','ericaspeling@gmail.com'),
	('Juanita','Gomes','juanitagomes@hotmail.com'),
	('Samantha','Sword','samsword@gmail.com'),
	('Cory','Wright','cwright@gmail.com'),
	('Ivan','Putin','ivanp@outlook.com'),
	('Katia','Silva','silverkat@gmail.com'),
	('Peter','Walker','petew@gmail.com'),
	('Hannes','Coetzee','coetzeeh@gmail.com'),
	('Miles','Smith','smithym@gmail.com'),
	('willem','Swart','willemswart@outlook.com'),
	('Armand','Rudolph','armandrudolph@gmail.com'),
	('Luca','Pino','lucapino23@gmail.com')
GO
PRINT 'player data has been inserted successfully' --prints a line

--populating the playerAccount table
INSERT INTO playerAccount (playerTag,accountStatus,paymentDate,expiryDate) VALUES
	('Lucy_Z28', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())), --Gets payment date and adds 30 days for the renewal date
	('Zachoniouss', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('Tazzie24', 'Blocked', DATEADD(DAY, -40, GETDATE()),DATEADD(DAY, -12, GETDATE())), --Gets last payment date and subtracts -12 since the account expired
	('JC_Sealteam6', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('Lolita17', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('ForestGump002', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('georgeS', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('Bear1994', 'Blocked', DATEADD(DAY, -45,  GETDATE()), DATEADD(DAY, -17, GETDATE())),
	('WarMachine', 'Blocked', DATEADD(DAY, -40, GETDATE()),DATEADD(DAY, -12, GETDATE())),
	('BondJamesBond', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('themoth', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())), --Gets payment date and adds 30 days for the renewal date
	('RhinoPunch', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('NellyThere', 'Blocked', DATEADD(DAY, -39, GETDATE()),DATEADD(DAY, -11, GETDATE())), --Gets last payment date and subtracts -12 since the account expired
	('EricTheStrong', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('Nita1990', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('SammySlayer', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('Corerupted', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('IvanTheTerrible', 'Blocked', DATEADD(DAY, -55,  GETDATE()), DATEADD(DAY, -27, GETDATE())),
	('KittyKatKlaws', 'Blocked', DATEADD(DAY, -34, GETDATE()),DATEADD(DAY, -6, GETDATE())),
	('ButteredToast', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('BakedBeans', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('Kilometers', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE())),
	('WillIAM23', 'Blocked', DATEADD(DAY, -30,  GETDATE()), DATEADD(DAY, -2, GETDATE())),
	('ArmedandDangerous', 'Blocked', DATEADD(DAY, -38, GETDATE()),DATEADD(DAY, -10, GETDATE())),
	('LuckyLuca', 'Open', GETDATE(), DATEADD(DAY, +30, GETDATE()))
GO
PRINT 'playerAccount data has been inserted successfully' --prints a line

--populating the characters table
INSERT INTO characters (characterID, skillLevel,characterName,team,playerIden) VALUES
	(1,27,'Helena','Explorers Guild','Lucy_Z28'),
	(2,107,'Ragnar','Divers Guild','Zachoniouss'),
	(3,55,'Neebs','Farmers Guild','JC_Sealteam6'),
	(4,80,'Kratos','Raiders Guild','Zachoniouss'),
	(5,2,'Ginger','Breeders Guild','Lolita17'),
	(6,111,'Rowena','Raiders Guild','Lucy_Z28'),
	(7,31,'Pushkin','Raiders Guild','WarMachine'),
	(8,29,'Raia','Explorers Guild','Lucy_Z28'),
	(9,117,'Rusty','Divers Guild','RhinoPunch'),
	(10,56,'Diana','Farmers Guild','ButteredToast'),
	(11,82,'Boris','Raiders Guild','LuckyLuca'),
	(12,21,'Skye','Breeders Guild','SammySlayer'),
	(13,15,'Mei-Yin','Raiders Guild','themoth'),
	(14,3,'Sir Edmund','Raiders Guild','WarMachine'),
	(15,59,'Santiago','Farmers Guild','themoth'),
	(16,86,'John Doe','Raiders Guild','IvanTheTerrible'),
	(17,12,'Imamu','Breeders Guild','KittyKatKlaws'),
	(18,149,'Trent','Raiders Guild','WillIAM23'),
	(19,31,'Emilia','Raiders Guild','Nita1990'),
	(20,13,'Lindsey','Raiders Guild','Nita1990')
GO
PRINT 'character data has been inserted successfully' --prints a line

--populating the items table
INSERT INTO items (itemName) VALUES
	('Wood'),
	('Metal Axe'),
	('Metal Pike'),
	('Simple Rifle'),
	('Crossbow'),
	('Arrows'),
	('Simple Rifle Ammo'),
	('Stone'),
	('Thatch'),
	('Fibre'),
	('Metal'),
	('Sap'),
	('Compass'),
	('Fishing Rod'),
	('GPS'),
	('Spyglass'),
	('C4 Charge'),
	('Flame Arrows'),
	('Grappling Hook'),
	('Rocket Propelled Grenade'),
	('Gunpowder'),
	('Sparkpowder'),
	('Charcoal'),
	('Chitin'),
	('Keratin'),
	('Hide'),
	('Element'),
	('Metal Chestpiece'),
	('Metal Helmet'),
	('Metal Gauntlets'),
	('Metal Leggings'),
	('Metal Boots'),
	('Tranq Darts'),
	('Sulphur'),
	('Polymer'),
	('Silica Pearls')
GO
PRINT 'items data has been inserted successfully' --prints a line

--populating the inventory table
INSERT INTO inventorySlots (slotID,stackQuantity,characterRef,itemRef) VALUES
	(1,2,1,1),
	(2,2,1,2),
	(3,5,1,3),
	(4,2,1,4),
	(5,3,1,5),
	(6,13,1,6),
	(7,1,1,7),
	(8,1,1,8),
	(1,5,2,9),
	(2,10,2,1),
	(3,5,2,11),
	(4,2,2,12),
	(1,3,3,13),
	(2,1,3,14),
	(1,2,4,15),
	(1,1,5,16),
	(1,20,6,17),
	(1,10,7,18),
	(1,5,8,19),
	(2,2,8,20),
	(1,1,9,21),
	(1,1,10,22),
	(1,2,11,23),
	(1,1,12,24),
	(1,10,13,25)
GO
PRINT 'inventorySlots data has been inserted successfully'

--populating the errorLog table
INSERT INTO errorLog (errorType,errorMessage) VALUES
	('Account Error','Your account time has lapsed. Please purchase more or contact support'),
	('Email Error','This email adress is already in use. Please use a different email address to sign-up.'),
	('PlayerTag Error','This playerTag is already taken. Please try again using a different combination.'),
	('Slot Error','Your inventory is full. Please ensure you have open slots before trying to pick up any other items'),
	('Tribe Error','Please leave your current tribe before attempting to join another.')
GO
PRINT 'errorLog data has been inserted successfully'


USE ark_mmorpg
GO

CREATE VIEW vwBlockedAccounts
AS
	SELECT playerAccount.playerTag, playerAccount.accountStatus,playerAccount.paymentDate, playerAccount.expiryDate
	FROM playerAccount
	WHERE accountStatus = 'Blocked'
GO

--retrieving the information from vwBlockedAccounts
SELECT* FROM vwBlockedAccounts
GO

--creating view vwTopSkill
CREATE VIEW vwTopSkill
AS
	SELECT playerAccount.playerTag, player.email, playerAccount.accountStatus, characters.characterName, characters.skillLevel
	FROM characters
	JOIN playerAccount
	ON playerAccount.playerRef = characters.characterID
	JOIN player
	ON playerAccount.playerRef = player.playerID
GO

--retrieving the information from vwTopSkill
SELECT TOP 20 * FROM vwTopSkill
ORDER BY skillLevel DESC 
GO

--creating view vwTopStackedItems
CREATE VIEW vwTopStackedItems
AS
	SELECT characters.characterName,items.itemName, inventorySlots.stackQuantity
	FROM items
	JOIN characters
	ON characters.characterID = items.itemID
	JOIN inventorySlots
	ON characters.characterID = inventorySlots.itemRef
GO

--retrieving the information from vwTopStackedItems
SELECT TOP 20 * FROM vwTopStackedItems
ORDER BY stackQuantity DESC
GO

--creating view vwPopItems
CREATE VIEW vwPopItems
AS
	SELECT items.itemName,inventorySlots.stackQuantity,characters.characterName
	FROM inventorySlots
	JOIN items
	ON inventorySlots.itemRef = items.itemID
	JOIN characters
	ON inventorySlots.slotID = characters.characterID
GO

SELECT TOP 5 * FROM vwPopItems
ORDER BY stackQuantity DESC
GO


