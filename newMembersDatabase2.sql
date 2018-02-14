USE MASTER

/*Check for existing database named "conferences" if named database exists, then drop and re-create.
  Dropping the database deletes all associated tables in this database before recreating*/


if (select count(*) 
    from sys.databases where name = 'Conferences') > 0
BEGIN
		DROP DATABASE Conferences;
END

CREATE DATABASE Conferences;
GO
USE Conferences;

exec sp_changedbowner 'sa'

/*Creates tables & attributes with datatypes for the conferences database.
  Primary Key and Foreign Key Constraints have been included at the end of each table */

CREATE TABLE SubscriptionLevels
(                                                                                                     
SubscriptionID int not null IDENTITY(1, 1),
SubsciptionLevel varchar(75) not null,
RenewalAmtPrice smallmoney not null,
PRIMARY KEY (SubscriptionID)
)


CREATE TABLE Members
(
MemberID int not null IDENTITY(1, 1),
MemberNumber varchar (75) not null,
FirstName varchar(25) not null,
MiddleName varchar(25),
LastName varchar(25) not null,
Email varchar(35) not null,
Phone varchar(25) not null,
Gender varchar(10) not null,
JoinDate date not null,
BirthDate date not null,
Subscription varchar (25), 
SubscriptionID int not null,
CurrentFlag varchar (10) not null
PRIMARY KEY (MemberID),
CONSTRAINT FK_Subscriptionlevels FOREIGN KEY (SubscriptionID) REFERENCES SubscriptionLevels(SubscriptionID),
CHECK (CurrentFlag in ('Yes', 'No')),
CHECK (Subscription in ('Monthly', 'Quarterly', 'Yearly', 'Biennial', 'Free'))

)


CREATE TABLE MemberAddresses
(
AddressID int not null IDENTITY(1, 1),
MemberID int not null,
AddressLine1 varchar(50) not null,
AddressLine2 varchar(50),
City varchar(35) not null,
StateProvince varchar(25) not null,
ZipCode varchar(15) not null,
AddressType nvarchar(75) not null,
PRIMARY KEY (AddressID),
CONSTRAINT FK_MembersAddresses FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
)

CREATE TABLE MemberInterest
(
InterestID int not null IDENTITY(1, 1),
MemberID int not null,
Interest varchar(20) not null,
PRIMARY KEY (InterestID),
CONSTRAINT FK_MembersIntrest FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
)

CREATE TABLE MembersCCPayment
(
CCardID int not null IDENTITY(101, 1),
MemberID int not null,
CardType varchar(75) not null,
CardNumber varchar(30) not null,
SecCode varchar (3) not null,
CardExpiration date not null,
PRIMARY KEY (CCardID),
CONSTRAINT FK_MembersCCPayment FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
)

CREATE TABLE CCTransactions
(
TransactionID int not null IDENTITY(1001, 1),
CCardID int not null,
TransactionDate date not null,
Amount smallmoney not null,
CCResultCode varchar(15) not null,
PRIMARY KEY (TransactionID),
CONSTRAINT FK_CCTransactions FOREIGN KEY (CCardID) REFERENCES MembersCCPayment(CCardID),
CHECK (CCResultCode in ('Approved','Declined','Invalid Card'))
)


CREATE TABLE [Events]
(
EventID int not null IDENTITY(1, 1),
EventName varchar(100) not null,
EventDate date not null,
StartTime time(1) not null,
EndTime time(1) not null,
EventTitle varchar(1000) not null,
Lecturer varchar (25) not null,
Discription varchar (256) not null, 
Comments varchar(1000),
PRIMARY KEY (EventID),
)

CREATE TABLE MemberEvents
(
EventID int not null,
MemberID int not null,
Rating smallint not null,
Feedback varchar (25)
CONSTRAINT FK_MemberEvents1 FOREIGN KEY (EventID) REFERENCES [Events] (EventID),
CONSTRAINT FK_MemberEvents2 FOREIGN KEY (MemberID) REFERENCES Members (MemberID)
)

CREATE TABLE LoginInfo
(
    UserID INT IDENTITY(1,1) NOT NULL,
    LoginName NVARCHAR(40) NOT NULL,
    PasswordHash BINARY(64) NOT NULL,
    FirstName NVARCHAR(40) NULL,
    LastName NVARCHAR(40) NULL,
    CONSTRAINT [PK_User_UserID] PRIMARY KEY CLUSTERED (UserID ASC)
	
)
	
	


--==============================================INSERTS========================================================--

/*Subscrption Table data inlcludes the four subscription levels and the price for each associated subscription level*/

INSERT INTO SubscriptionLevels (SubsciptionLevel, RenewalAmtPrice)
VALUES ('Monthly', 9.99),('Quarterly', 27.00),('Annually', 99.00),('Biennial',189.00),('Free', 0.00)

/* The members table data contains both the memberID set to identity to be used as the primary key in addition to using the predetermined member number for reference information.
Furthermore, the members table includes a current flag bit that will be used for reference to check if customer is active used in the billing process to determine if subscription is active */

INSERT INTO Members (MemberNumber,FirstName, MiddleName, LastName, Email, Phone, Gender, JoinDate, BirthDate, Subscription, SubscriptionID, CurrentFlag)
	VALUES 
			('M0001', 'Otis',	'Brooke',	'Fallon',	'bfallon0@artisteer.com',	'818-873-3863',	'Male',	'2017-04-07', '1971-06-29','Monthly' ,'1', 'YES'), 
			('M0002', 'Katee',	'Virgie',	'Gepp',	'vgepp1@nih.gov',	'503-689-8066',	'Female',	'2017-11-29', '1972-04-03', 'Monthly', '1', 'YES'),
			('M0003', 'Lilla',	'Charmion',	'Eatttok',	'ceatttok2@google.com.br',	'210-426-7426',	'Female',	'2017-02-26','1975-12-13','Quarterly', '2', 'YES'),
			('M0004', 'Ddene',	'Shelba',	'Clapperton',	'sclapperton3@mapquest.com',	'716-674-1640',	'Female',	'2017-11-05', '1997-02-19','Quarterly', '2', 'YES'),
			('M0005', 'Audrye',	'Agathe',	'Dawks',	'adawks4@mlb.com',	'305-415-9419',	'Female',	'2016-01-15','1989-02-07','Monthly','1','YES'),
			('M0006', 'Fredi',	'Melisandra',	'Burgyn',	'mburgyn5@cbslocal.com',	'214-650-9837',	'Female',	'2017-03-13','1956-05-31','Yearly', '3', 'YES'),
			('M0007', 'Dimitri',	'Francisco',	'Bellino',	'fbellino6@devhub.com',	'937-971-1026',	'Male',	'2017-08-09', '1976-10-12','Monthly', '1','YES'),
			('M0008', 'Enrico',	'Cleve',	'Seeney',	'cseeney7@macromedia.com',	'407-445-6895',	'Male',	'2016-09-09', '1988-02-29','Yearly', '3', 'YES'),
			('M0009', 'Marylinda',	'Jenine',	'OSiaghail',	'josiaghail8@tuttocitta.it',	'206-484-6850',	'Female',	'2016-11-21','1965-02-06','Yearly','3','NO'),
			('M00010', 'Luce',	'Codi',	'Kovalski',	'ckovalski9@facebook.com',	'253-159-6773',	'Male',	'2017-12-22', '1978-03-31', 'Monthly','1', 'YES'),
			('M00011', 'Claiborn',	'Shadow',	'Baldinotti',	'sbaldinottia@discuz.net',	'253-141-4314',	'Male',	'2017-03-19', '1991-12-26','Monthly', '1', 'YES'),
			('M00012', 'Isabelle',	'Betty',	'Glossop',	'bglossopb@msu.edu',	'412-646-5145',	'Female',	'2016-04-25', '1965-02-17','Quarterly', '2', 'YES'),
			('M00013', 'Davina',	'Lira',	'Wither',	'lwitherc@smugmug.com',	'404-495-3676',	'Female',	'2016-03-21', '1957-12-16','Yearly', '3','YES'),
			('M00014', 'Panchito',	'Hashim',	'De Gregorio',	'hdegregoriod@a8.net',	'484-717-6750',	'Male',	'2017-01-27','1964-10-14','Monthly', '1','YES'),
			('M00015', 'Rowen',	'Arvin',	'Birdfield',	'abirdfielde@over-blog.com',	'915-299-3451',	'Male',	'2017-10-06', '1983-01-09','Monthly', '1','NO')

/* The address table data includes the address for each of the members..included is the address type column to identify if the address is used for mailing or billing purposes. */

INSERT INTO MemberAddresses (MemberID, AddressLine1, AddressLine2, City, StateProvince, ZipCode, AddressType)
	VALUES 
			('1', '020 New Castle Way',	null,	'Port Washington',	'New York',	'11054', 'Mailing'),
			('2', '8 Corry Parkway', null,	'Newton',	'Massachusetts',	'2458',  'Mailing'),
			('3', '39426 Stone Corner Drive',	null,	'Peoria',	'Illinois',	'61605', 'Mailing'),
			('4', '921 Granby Junction',	null,	'Oklahoma City',	'Oklahoma',	'73173', 'Mailing'),
			('5', '77 Butternut Parkway',	null,	'Saint Paul',	'Minnesota',	'55146', 'Mailing'),
			('6', '821 Ilene Drive',	null,	'Odessa',	'Texas',	'79764', 'Mailing'),
			('7', '1110 Johnson Court',	null,	'Rochester',	'New York',	'14624', 'Mailing'),
			('8', '6 Canary Hill',	null,	'Tallahassee',	'Florida',	'32309', 'Mailing'),
			('9', '9 Buhler Lane',	null,	'Bismarck',	'North Dakota',	'58505', 'Mailing'),  
			('10', '99 Northwestern Pass',	null,	'Midland',	'Texas',	'79710', 'Mailing'),
			('11', '69 Spenser Hill',	null,	'Provo',	'Utah',	'84605','Mailing'),
			('12', '3234 Kings Court',	null,	'Tacoma',	'Washington',	'98424', 'Mailing'),
			('13', '3 Lakewood Gardens Circle',	null,	'Columbia',	'South Carolina',	'29225','Mailing'),
			('14', '198 Muir Parkway',	null,	'Fairfax',	'Virginia',	'22036', 'Mailing'),
			('15', '258 Jenna Drive',	null,	'Pensacola',	'Florida',	'32520', 'Mailing')

--Associates members with personal interests 

INSERT INTO MemberInterest (MemberID, Interest)
	VALUES 
			('1',	'Acting'),
			('1',	'Video Games'),
			('1',	'Crossword Puzzles'),
			('2',	'Calligraphy'),
			('3',	'Movies'),
			('3',	'Restaurants'),
			('3',	'Woodworking'),
			('4',	'Juggling'),
			('4',	'Quilting'),
			('5',	'Electronics'),
			('6',	'Sewing'),
			('6',	'Cooking'),
			('6',	'Movies'),
			('7',	'Botany'),
			('7',	'Skating'),
			('8',	'Dancing'),
			('8',	'Coffee'),
			('8',	'Foreign Languages'),
			('9',	'Fashion'),
			('10',	'Woodworking'),
			('11',	'Homebrewing'),
			('11',	'Geneology'),
			('11',	'Movies'),
			('11',	'Scrapbooking'),
			('12',	'Surfing'),
			('12',	'Amateur Radio'),
			('13',	'Computers'),
			('14',	'Writing'),
			('14',	'Singing'),
			('15',	'Reading'),
			('15',	'Pottery')

--Members Credit Card Information

INSERT INTO MembersCCPayment (MemberID, CardType, CardNumber, SecCode, CardExpiration)
	VALUES ('1',	'AmericanExpress',	'337941553240515', '405', '2019-09-01'),
		   ('2',	'Visa',	'4041372553875903', '305','2020-01-01'),
		   ('3',	'Visa',	'4041593962566', '205','2019-03-01'),
           ('4',	'JCB',	'3559478087149594', '105','2019-04-01'),
		   ('5',	'JCB',	'3571066026049076',	'505', '2018-07-01'),
	       ('6',	'Diners-Club-Carte-Blanche','30423652701879', '605','2018-05-01'),
		   ('7',	'JCB',	'3532950215393858', '705', '2019-02-01'),
		   ('8',	'JCB',	'3569709859937370','805', '2019-03-01'),
		   ('9',	'JCB',	'3529188090740670','905', '2019-05-01'),
		   ('10',	'JCB',	'3530142576111598', '906', '2019-11-01'),
		   ('11',	'MasterCard',	'5108756299877313', '907', '2018-07-01'),
		   ('12',	'JCB',	'3543168150106220', '908','2018-06-01'),
		   ('13',	'JCB',	'3559166521684728', '909', '2019-10-01'),
		   ('14',	'Diners-Club-Carte-Blanche', '30414677064054', '910','2018-06-01'),
		   ('15',	'JCB',	'3542828093985763', '911','2020-03-01')

/* The credit card transaction table data includes all of the transactions associated with each member up to the present time.
The credit Card ID is used to to associate the members and transaction. In addition, it includes both approved, declined and invalid  
transaction data that may be used in a query for identifying which members have a valid payment method, expired cards etc... */

INSERT INTO CCTransactions (CCardID, TransactionDate, Amount, CCResultCode)
	VALUES  ('105',	'2016-01-15',	'9.99',	'Approved'),
		    ('105',	'2016-01-16',	'9.99',	'Approved'),
			('105',	'2016-01-17',	'9.99',	'Approved'),
			('113',	'2016-01-18',	'99',	'Approved'),
			('105',	'2016-01-19',	'9.99',	'Approved'),
			('113',	'2016-01-20',	'99',	'Approved'),
			('112',	'2016-01-21',	'27',	'Approved'),
			('105',	'2016-01-22',	'9.99',	'Approved'),
			('105',	'2016-01-23',	'9.99',	'Approved'),
			('105',	'2016-01-24',	'9.99',	'Approved'),
			('112',	'2016-01-25',	'27',	'Approved'),
			('105',	'2016-01-26',	'9.99',	'Approved'),
			('108',	'2016-01-27',	'99',	'Approved'),
			('105',	'2016-01-28',	'9.99',	'Approved'),
			('105',	'2016-01-29',	'9.99',	'Approved'),
			('112',	'2016-01-30',	'27',	'Approved'),
			('105',	'2016-01-31',	'9.99',	'Approved'),
			('109',	'2016-02-01',	'99',	'Approved'),
			('105',	'2016-02-02',	'9.99',	'Approved'),
			('105',	'2016-02-03',	'9.99',	'Approved'),
			('112',	'2016-02-04',	'27',	'Approved'),
			('114',	'2016-02-05',	'9.99',	'Approved'),
			('105',	'2016-02-06',	'9.99',	'Approved'),
			('103',	'2016-02-07',	'27',	'Approved'),
			('114',	'2016-02-08',	'9.99',	'Approved'),
			('106',	'2016-02-09',	'99',	'Approved'),
			('105',	'2016-02-10',	'9.99',	'Approved'),
			('111',	'2016-02-11',	'9.99',	'Approved'),
			('114',	'2016-02-12',	'9.99',	'Approved'),
			('101',	'2016-02-13',	'9.99',	'Approved'),
			('105',	'2016-02-14',	'9.99',	'Approved'),
			('111',	'2016-02-15',	'9.99',	'Approved'),
			('112',	'2016-02-16',	'27',	'Approved'),
			('114',	'2016-02-17',	'9.99',	'Approved'),
			('101',	'2016-02-18',	'9.99',	'Approved'),
			('105',	'2016-02-19',	'9.99',	'Approved'),
			('111',	'2016-02-20',	'9.99',	'Approved'),
			('103',	'2016-02-21',	'27',	'Approved'),
			('114',	'2016-02-22',	'9.99',	'Approved'),
			('101',	'2016-02-23',	'9.99',	'Declined'),
			('101',	'2016-02-24',	'9.99',	'Approved'),
			('105',	'2016-02-25',	'9.99',	'Approved'),
			('111',	'2016-02-26',	'9.99',	'Approved'),
			('114',	'2016-02-27',	'9.99',	'Approved'),
			('101',	'2016-02-28',	'9.99',	'Approved'),
			('105',	'2016-02-29',	'9.99',	'Approved'),
			('111',	'2016-03-01',	'9.99',	'Declined'),
			('111',	'2016-03-02',	'9.99',	'Approved'),
			('112',	'2016-03-03',	'27',	'Approved'),
			('114',	'2016-03-04',	'9.99',	'Approved'),
			('101',	'2016-03-05',	'9.99',	'Approved'),
			('107',	'2016-03-06',	'9.99',	'Approved'),
			('105',	'2016-03-07',	'9.99',	'Approved'),
			('111',	'2016-03-08',	'9.99',	'Approved'),
			('103',	'2016-03-09',	'27',	'Approved'),
			('114',	'2016-03-10',	'9.99',	'Approved'),
			('101',	'2016-03-11',	'9.99',	'Approved'),
			('107',	'2016-03-12',	'9.99',	'Approved'),
			('108',	'2016-03-13',	'99',	'Approved'),
			('105',	'2016-03-14',	'9.99',	'Approved'),
			('111',	'2016-03-15',	'9.99',	'Approved'),
			('114',	'2016-03-16',	'9.99',	'Approved'),
			('115',	'2016-03-17',	'9.99',	'Invalid Card'),
			('101',	'2016-03-18',	'9.99',	'Approved'),
			('107',	'2016-03-19',	'9.99',	'Approved'),
			('105',	'2016-03-20',	'9.99',	'Approved'),
			('111',	'2016-03-21',	'9.99',	'Approved'),
			('112',	'2016-03-22',	'27',	'Approved'),
			('114',	'2016-03-23',	'9.99',	'Approved'),
			('104',	'2016-03-24',	'27',	'Approved'),
			('101',	'2016-03-25',	'9.99',	'Approved'),
			('107',	'2016-03-26',	'9.99',	'Approved'),
			('105',	'2016-03-27',	'9.99',	'Approved'),
			('111',	'2016-03-28',	'9.99',	'Approved'),
			('103',	'2016-03-29',	'27',	'Declined'),
			('103',	'2016-03-30',	'27',	'Approved'),
			('114',	'2016-03-31',	'9.99',	'Approved'),
			('102',	'2016-04-01',	'9.99',	'Approved'),
			('101',	'2016-04-02',	'9.99',	'Approved'),
			('107',	'2016-04-03',	'9.99',	'Approved'),
			('105',	'2016-04-04',	'9.99',	'Approved'),
			('111',	'2016-04-05',	'9.99',	'Approved'),
			('110',	'2016-04-06',	'9.99',	'Approved'),
			('114',	'2016-04-07',	'9.99',	'Approved'),
			('102',	'2016-04-08',	'9.99',	'Approved'),
			('101',	'2016-04-09',	'9.99',	'Approved'),
			('107',	'2016-04-10',	'9.99',	'Approved'),
			('105',	'2016-04-11',	'9.99',	'Approved'),
			('111',	'2016-04-12',	'9.99',	'Approved'),
			('110',	'2016-04-13',	'9.99',	'Approved'),
			('112',	'2016-04-14',	'27',	'Approved'),
			('114',	'2016-04-15',	'9.99',	'Approved')

/* The Events data includes event names, lecturer and other important info related to each event. */


INSERT INTO [Events] (EventName, EventDate, StartTime, EndTime, EventTitle, Lecturer, Discription, Comments)
	VALUES ('The History of Human Emotions',	'2017-01-12',	'12:00',	'2:00',	'History of human emotions','Tiffany Watt Smith',' A brief view of Westen Philosophy of Emotions', 'I was impressed with Plato''s philosophy of human emotions'),
('How Great Leaders Inspire Action',	'2017-02-22',	'12:00',	'1:00',	'How great leaders inspire action','Simon Sinek', 'Introdution to critical business skill for the 21 century','I thought the theory on Competative Advantage was an eye opener'),
('The Puzzle of Motivation',	'2017-03-05',	'12:00',	'3:00',	'Motivational', 'Dan Pink', 'How to maintain a positive attitude in the face of negative situations', 'Motivate people'),
('Your Elusive Creative Genius',	'2017-04-16',	'12:00',	'2:00',	'Learn to become a genius!','Elizabeth Gilbert', 'A brief introduction into Aristotle''s Logic Methods', 'Thinking Skills'),
('Why are Programmers So Smart?',	'2017-05-01',	'12:00',	'2:30',	'Overview of how smart programmers are','Andrew Comeau', 'An introduction to skills needed for success in a programming career','Programmers are awesome')

INSERT INTO MemberEvents (EventID, MemberID, Rating)
	VALUES	(1, 1, 1),
			(2, 1, 1),
			(3, 1, 1),
			(4, 1, 1),
			(5, 1, 1),
			(1, 2, 1),
			(2, 2, 0),
			(3, 2, 1),
			(4, 2, 1),
			(5, 2, 0),
			(1, 3, 1),
			(2, 3, 1),
			(3, 3, 1),
			(4, 3, 0),
			(5, 3, 1),
			(1, 4, 1),
			(2, 4, 1),
			(3, 4, 1),
			(4, 4, 1),
			(5, 4, 1),
			(1, 5, 1),
			(2, 5, 1),
			(3, 5, 1),
			(4, 5, 1),
			(5, 5, 0),
			(1, 6, 1),
			(2, 6, 0),
			(3, 6, 1),
			(4, 6, 1),
			(5, 6, 0),
			(1, 7, 0),
			(2, 7, 1),
			(3, 7, 1),
			(4, 7, 1),
			(5, 7, 0),
			(1, 8, 1),
			(2, 8, 1),
			(3, 8, 1),
			(4, 8, 1),
			(5, 8, 0),
			(1, 9, 0),
			(2, 9, 1),
			(3, 9, 1),
			(4, 9, 1),
			(5, 9, 0),
			(1, 10, 1),
			(2, 10, 1),
			(3, 10, 0),
			(4, 10, 0),
			(5, 10, 0),
			(1, 11, 1),
			(2, 11, 1),
			(3, 11, 0),
			(4, 11, 0),
			(5, 11, 0),
			(1, 12, 1),
			(2, 12, 0),
			(3, 12, 1),
			(4, 12, 1),
			(5, 12, 1),
			(1, 13, 1),
			(2, 13, 1),
			(3, 13, 0),
			(4, 13, 0),
			(5, 13, 1),
			(1, 14, 0),
			(2, 14, 1),
			(3, 14, 1),
			(4, 14, 1),
			(5, 14, 0),
			(1, 15, 1),
			(2, 15, 1),
			(3, 15, 1),
			(4, 15, 1),
			(5, 15, 0)



                   ------------Views------------------

--A complete contact list for current members with name, physical mailing address, phone number and e-mail.
GO
CREATE VIEW MemberContactList
AS
SELECT CONCAT(FirstName, ', ', LastName) AS [Member's Full Name], a.AddressLine1, a.AddressLine2,
			a.City, a.StateProvince, a.ZipCode, m.Phone, m.Email
FROM Members m
INNER JOIN MemberAddresses a 
ON m.MemberID = a.MemberID
GO
---An e-mail list with the member name and e-mail.
CREATE VIEW MemberEmailList
AS
SELECT CONCAT (Firstname, ', ', Lastname) AS [Member's Full Name], Email
FROM Members
GO

-- A list of members who are celebrating their birthday this month
CREATE VIEW MemberBirthdays
AS
SELECT CONCAT (Firstname, ', ', Lastname) [Member's Full Name],  BirthDate
FROM Members
WHERE DATENAME(month, Birthdate) = DATENAME(month, getdate())
GO
--Scheduled billing of members on the appropriate anniversary of the date they joined
GO
 /* The UNION ALL command is used in combination with the CREATE VIEW command
 to combine the information so be referenced in the stored procedure to identify members who need to be charged for renewal.*/
 CREATE VIEW MembersRenewal
AS
/*This query is used to get information on monthly subscribers who's subscription expired on prior to or equal to today's date 
  by using the the Member ID and checking the current date against the join dates, and only for active members, and members with the Subscription type 'Monthly'*/
SELECT m.MemberID, m.Joindate AS 'Join Date', s.RenewalAmtPrice AS 'Subscription Price',
c.CCardID
FROM Members m
JOIN SubscriptionLevels s
ON m.subscriptionID = s.SubscriptionID
JOIN MembersCCPayment c
ON m.MemberID = c.MemberID
JOIN CCTransactions t
ON c.CCardID = t.CCardID
WHERE m.currentFlag = 'YES' AND s.SubscriptionID = 1 AND s.SubsciptionLevel = 'Monthly' AND (DATEADD(MONTH, 1, m.JoinDate) <=GETDATE())
AND t.CCResultCode ='APPROVED' 
GROUP BY m.MemberID, m.JoinDate, c.CCardID, s.RenewalAmtPrice
   
UNION ALL
/*This view is used to get information on quarterly subscribers who's subscription expired on prior to or equal to today's date 
  by using the the Member ID and checking the current date against the join dates, and only for active members, and members with the Subscription type 'Quarterly'*/
SELECT m.MemberID, m.Joindate AS 'Join Date', s.RenewalAmtPrice AS 'Subscription Price',
c.CCardID
FROM Members m
JOIN SubscriptionLevels s
ON m.subscriptionID = s.SubscriptionID
JOIN MembersCCPayment c
ON m.MemberID = c.MemberID
JOIN CCTransactions t
ON c.CCardID = t.CCardID
WHERE m.currentFlag = 'YES' AND s.SubscriptionID = 2 AND s.SubsciptionLevel = 'Quarterly'AND (DATEADD(MONTH, 3, m.JoinDate) <=GETDATE())
AND t.CCResultCode ='APPROVED' 
GROUP BY m.MemberID, m.JoinDate, c.CCardID, s.RenewalAmtPrice
UNION ALL
/*This view is used to get information on yearly subscribers who's subscription expired on prior to or equal to today's date 
  by using the the Member ID and checking the current date against the join dates, and only for active members, and members with the Subscription type 'Yearly'*/
SELECT m.MemberID, m.Joindate AS 'Join Date', s.RenewalAmtPrice AS 'Subscription Price',
c.CCardID
FROM Members m
JOIN SubscriptionLevels s
ON m.subscriptionID = s.SubscriptionID
JOIN MembersCCPayment c
ON m.MemberID = c.MemberID
JOIN CCTransactions t
ON c.CCardID = t.CCardID
WHERE m.currentFlag = 'YES' AND s.SubscriptionID = 3 AND  m.subscription = 'Yearly' AND (DATEADD(YEAR, 1, m.JoinDate) <=GETDATE())
AND t.CCResultCode ='APPROVED' 
GROUP BY m.MemberID, m.JoinDate, c.CCardID, s.RenewalAmtPrice
UNION ALL
/*This view is used to get information on Biennial subscribers who's subscription expired on prior to or equal to today's date 
  by using the the Member ID and checking the current date against the join dates, and only for active members, and members with the Subscription type Biennial'*/
SELECT m.MemberID, m.Joindate AS 'Join Date', s.RenewalAmtPrice AS 'Subscription Price',
c.CCardID
FROM Members m
JOIN SubscriptionLevels s
ON m.subscriptionID = s.SubscriptionID
JOIN MembersCCPayment c
ON m.MemberID = c.MemberID
JOIN CCTransactions t
ON c.CCardID = t.CCardID
WHERE m.currentFlag = 'YES' AND s.SubscriptionID = 4 AND m.subscription = 'Biennial' AND (DATEADD(YEAR, 2, m.JoinDate) <=GETDATE())
AND t.CCResultCode ='APPROVED' 
GROUP BY m.MemberID, m.JoinDate, c.CCardID, s.RenewalAmtPrice

GO
/* The create procedure command here creates a stored procedure that references the MembersRenewal View used 
   to identifying members who subscription have expired...The stored procedure renews the the top 1 memeber and 
   must be manually ran until all expired members have been renewed */
CREATE PROCEDURE sp_MembersRenewal
AS
BEGIN
	IF EXISTS (SELECT * FROM MembersRenewal)
	BEGIN
		INSERT INTO TRANSACTIONS (CCardID, TransactionDate, RenewalAmtPrice, CCResultCode)
		VALUES(
				
				(SELECT TOP 1 CCardID FROM RenewalAmtPrice),
				(SELECT CAST(GETDATE()AS DATE)),
				(SELECT TOP 1 RenewalAmtPrice FROM MembersRenewal),
				'pending') 
		END
	END          


--Identify expired credit cards before it tries to bill to them.
GO
CREATE VIEW ExpiredCards
AS
SELECT *
FROM MembersCCPayment
WHERE CardExpiration < GETDATE()

-- The company's monthly income from member payments over a given time frame.
GO
CREATE PROCEDURE sp_RenewalIncome
	
	@StartDate date,
	@EndDate date
	AS
	BEGIN
SELECT SUM (t.Amount) [Income]
FROM CCTransactions t
WHERE t.TransactionDate BETWEEN @StartDate AND @EndDate
END 

--Test the RenewalIncome Stored Procedure---- exec sp_RenewalIncome '2016-01-15', '2016-01-28'
--GO

--New member sign-ups per month over a given time frame.
GO
CREATE PROCEDURE sp_SignUpCount
	
	@StartDate date,
	@EndDate date
	AS
	BEGIN
SELECT COUNT (memberid) [Signup Count]
FROM Members
WHERE JoinDate between @StartDate and @EndDate
END 
GO
--Test the sp_SignUpCount Stored Procedure exec sp_SignUpCount '2016-03-01', '2016-03-31' */

-- Attendance per event over a given time frame. (Number of members at each event.)
GO
CREATE PROCEDURE sp_EventAttendance
	
	@StartDate date,
	@EndDate date
	AS
	BEGIN
SELECT e.EventID, COUNT(memberid) [Attendence], e.EventName, e.EventDate
FROM MemberEvents a
INNER JOIN [Events] e
ON e.EventID = a.EventID
WHERE e.EventDate BETWEEN @StartDate AND @EndDate
GROUP BY e.EventID, e.EventName, e.EventDate
END 
GO

--Test the sp_SignUpCount Stored Procedure----EXEC sp_EventAttendance '2016-03-01', '2017-03-31'

SELECT * FROM MembersRenewal


GO
CREATE PROCEDURE dbo.uspAddUser
    @pLogin NVARCHAR(50), 
    @pPassword NVARCHAR(50),
    @pFirstName NVARCHAR(40) = NULL, 
    @pLastName NVARCHAR(40) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    BEGIN

        INSERT INTO LoginInfo (LoginName, PasswordHash, FirstName, LastName)
        VALUES(@pLogin, HASHBYTES('SHA2_512', @pPassword), @pFirstName, @pLastName)

    END 
 
END

GO
DECLARE @responseMessage NVARCHAR(250)

EXEC dbo.uspAddUser
          @pLogin = 'bfallon0@artisteer.com',
          @pPassword = '818',
          @pFirstName = 'Otis',
          @pLastName = 'Fallon',
          @responseMessage=@responseMessage OUTPUT

SELECT *
FROM LoginInfo

-----Exercies 2/13/2018


Create View EventsToDate
WITH SCHEMABINDING 
AS

SELECT e.EventName, e.Discription, e.Lecturer, count (m.rating) AS Attendance 
FROM dbo.Events e
INNER JOIN dbo.MemberEvents m
ON e.EventID = m.EventID
WHERE e.EventDate <= GETDATE() AND Rating = 1
GROUP BY e.EventName, e.Lecturer, e.Discription,  E.EventDate

-- ALTER TABLE dbo.Events ALTER COLUMN EventName BIGINT;
/*The object 'EventsToDate' is dependent on column 'EventName'.
ALTER TABLE ALTER COLUMN EventName failed because one or more objects access this column.*/

SELECT *
FROM Members
WHERE CurrentFlag = 'YES'
Inner Join 
FROM [dbo].[MembersRenewal]