/*
Module: MLDM193-01
Version: 1A
Project Name: MMORPG (ark_mmorpg)
Author: Lucinda Frohlich
Student Number: BE2010-0649
Start Date: 18.03.2019
End Date: 01.04.2019
*/

--using ark_mmorpg
USE ark_mmorpg
GO

--creating stored procedure spRegister
CREATE PROCEDURE spRegister
@firstname VARCHAR (30),
@lastName VARCHAR (30),
@email VARCHAR (50)
AS
IF EXISTS (SELECT *
	FROM player
	WHERE @firstname = firstName)
	BEGIN
		PRINT 'Player already exists. New account could not be created at this time'
	END
ELSE
	BEGIN
		INSERT INTO player (firstName, lastName, email)
		VALUES (@firstname, @lastName, @email)
		PRINT 'New player account has been created.'
	END
GO

EXEC spRegister 'bob', 'smith', 'bobs@gmail.com' --executing stored procedure spRegister

--creating stored procedure spAddTime
CREATE PROCEDURE spAddTime
@playertag VARCHAR (30),
@lengthOfTime INT
AS
IF EXISTS (SELECT playerAccount.playerTag
	FROM playerAccount
	WHERE @playertag = playerTag)
	BEGIN
		UPDATE playerAccount
		SET paymentDate = DATEADD(DAY, + @lengthOfTime, GETDATE())
		WHERE playerAccount.playerTag = @playertag
		PRINT '30 days of play have been added to your account. Please enjoy your gaming experience.'
	END
ELSE PRINT 'Player does not exist.'
GO

EXEC spAddTime 'themoth',30 --executing stored procedure spAddTime
GO


--creating stored procedure spAddItem
CREATE PROCEDURE spAddItem
@stackquantity INT,
@itemRef INT,
@characterRef INT
AS
	BEGIN
		DECLARE @emptySlot INT
	IF EXISTS (SELECT slotID
		FROM inventorySlots
		WHERE characterRef = @characterRef AND itemRef = @itemRef)
		BEGIN
			UPDATE inventorySlots
			SET stackQuantity = stackQuantity + @stackquantity
			WHERE itemRef = @itemRef AND characterRef = @characterRef
			PRINT 'Item quantity has been updated.'
		END
	ELSE
		BEGIN
			IF EXISTS (SELECT TOP 1 slotID = @emptySlot
			FROM inventorySlots
			WHERE itemRef IS NULL AND characterRef = @characterRef)
			BEGIN
				UPDATE inventorySlots
				SET itemRef = @itemRef, stackQuantity = @stackquantity
				WHERE slotID = @emptySlot
			END
	ELSE
		BEGIN
			RAISERROR ('You do not have enough space in your inventory for any new items.',16,1)
		END
			END
		END
GO

EXEC spAddItem 4,3,5 --executing stored procedure spAddItem
GO
	
--creating stored procedure spAddChar	
CREATE PROCEDURE spAddChar
@playerTag VARCHAR (30),
@characterName VARCHAR (30),
@skillLevel INT = 1
AS
	IF EXISTS (SELECT playerAccount.playerTag, characters.skillLevel
		FROM playerAccount, characters
		WHERE @playerTag = playerTag AND @skillLevel = skillLevel)
		BEGIN
			INSERT INTO characters (characterName, skillLevel)
			VALUES (@characterName, @skillLevel)
			PRINT 'New character added to your account.'
		END
GO

EXEC spAddChar 'Zachonious''Nuggets',1 --executing stored procedure spSendLetter

--creating stored procedure spSendLetter
CREATE PROCEDURE spSendLetter
AS
	BEGIN
		DECLARE @playerTag VARCHAR (30)
		DECLARE @paymentDate DATE
		DECLARE @expiryDate DATE
		DECLARE @print INT
		SET @print = 0
		DECLARE printCustomers CURSOR
		FOR SELECT playerTag, paymentDate,expiryDate
			FROM playerAccount
			FOR READ ONLY
		OPEN printCustomers
					FETCH FROM printCustomers INTO @playerTag, @paymentDate, @expiryDate
					WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT ''
				PRINT 'Hi  ' + @playerTag
				PRINT ''
				PRINT 'We hope you are enjoying your Ark gaming account.'
				PRINT 'Please let us know if you are satisfied with your gamine expeirence or if you have any suggestions for us on how to improve'
				PRINT 'Your latest:' +CAST (DATEDIFF(DAY, @paymentDate,@expiryDate) AS VARCHAR)
				PRINT 'Should you wish to receieve the latest news about ARK please subscribe to our newsletter.'
				PRINT 'Regards, The Dev Team'
				PRINT ''
				FETCH FROM printCustomers INTO @playerTag, @paymentDate, @expiryDate
			END
			CLOSE printCustomers
		DEALLOCATE printCustomers
	END
GO


EXEC spSendLetter
GO