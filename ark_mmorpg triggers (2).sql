/*
Module: MLDM193-01
Version: 1A
Project Name: MMORPG (ark_mmorpg)
Author: Lucinda Frohlich
Student Number: BE2010-0649
Start Date: 18.03.2019
End Date: 01.04.2019
*/

--using ark_mmorpg database
USE ark_mmorpg
GO

--creating trigger
CREATE TRIGGER tr_notify_player
ON player
AFTER INSERT
AS
PRINT 'New player inserted successfully.'
GO

--creating trigger
CREATE TRIGGER tr_notify_items
ON items
INSTEAD OF INSERT, DELETE, UPDATE
AS
	RAISERROR ('You cannot edit the information in that table',5,6);
	INSERT INTO errorLog
	VALUES (001,'USER TRIED TO EDIT TABLE ITEMS. TIME:' + CAST(GETDATE() AS VARCHAR))
GO
