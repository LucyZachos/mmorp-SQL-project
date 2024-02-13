## MMORPG Database Project 🎮

### Overview

This academic project is a database system created for a Massively Multiplayer Online Role-Playing Game (MMORPG). The database is designed to handle various aspects of the game, including player information, character statistics, inventory management, and game events. The project utilizes SQL to create the database schema, tables, stored procedures, and triggers. 📊

### Database Schema

The database consists of the following main entities:

- **Players**: Contains information about the players, such as player ID, first name, last name, and email.
- **PlayerAccounts**: Manages player accounts, including player tag, account status, payment date, expiry date, and reference to the player.
- **Characters**: Stores details about the characters created by the players, including character ID, skill level, character name, team, and player reference.
- **Items**: Manages the items available in the game, with details such as item ID and item name.
- **InventorySlots**: Manages the inventory of each character, with details on slots, stack quantity, character reference, and item reference.
- **ErrorLog**: Logs errors encountered in the game, with details such as error ID, error type, and error message.

### Stored Procedures

The project includes various stored procedures to perform common tasks within the database, such as creating characters, updating inventory, and logging events. 🔄

### Triggers

Triggers are used to automatically perform actions in response to certain events in the database, such as updating a character's level and statistics when they reach a certain experience threshold. 🔧

### Usage

1. Create the database using the provided SQL scripts.
2. Populate the tables with sample data using INSERT statements.
3. Execute the stored procedures to perform actions such as creating characters, updating inventory, and logging events.
4. Monitor the database to observe the effects of the triggers on the data. 👀

### Contributors

This project was created as part of an academic assignment.👩‍💻

