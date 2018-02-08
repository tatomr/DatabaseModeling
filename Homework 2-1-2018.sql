USE MASTER
if (select count(*) 
    from sys.databases where name = 'Conferences') > 0
BEGIN
		DROP DATABASE Conferences;
END

CREATE DATABASE Conferences;
GO
USE Conferences;

exec sp_changedbowner 'sa'

CREATE TABLE SubscriptionLevels
(
SubscriptionID int not null IDENTITY(1, 1),
[Description] varchar(75) not null,
RenewalAmtPrice smallmoney not null
PRIMARY KEY (SubscriptionID)
)


CREATE TABLE Members
(
MemberID int not null IDENTITY(1, 1),
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
CurrentFlag bit not null
PRIMARY KEY (MemberID),
CONSTRAINT FK_Subscriptionlevels FOREIGN KEY (SubscriptionID) REFERENCES SubscriptionLevels(SubscriptionID),
CHECK (Subscription in ('Monthly', 'Quarterly', 'Yearly', 'Biennial'))

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


CREATE TABLE Host
(
HostID int not null IDENTITY(1, 1),
FirstName varchar(50) not null,
MiddleName varchar(50),
LastName varchar(50) not null,
Email varchar(30) not null,
Phone varchar(15) not null,
Gender varchar(10) not null,
StartDate date not null,
CurrentFlag bit not null,
BirthDate date not null,
PRIMARY KEY (HostID)
)

CREATE TABLE HostAddress
(
AddressID int not null IDENTITY(1, 1),
HostID int not null,
AddressLine1 varchar(50) not null,
AddressLIne2 varchar(50),
City varchar(35) not null,
StateProvince varchar(25) not null,
PostalCode varchar(15) not null,
PRIMARY KEY (AddressID),
CONSTRAINT FK_HostNotSupplied FOREIGN KEY (HostID)
REFERENCES Host(HostID)
)

CREATE TABLE [Events]
(
EventID int not null IDENTITY(1, 1),
HostID int not null,
EventName varchar(100) not null,
EventDate date not null,
StartTime time(1) not null,
EndTime time(1) not null,
EventTitle varchar(1000) not null,
Lecturer varchar (25) not null,
Discription varchar (256) not null, 
Comments varchar(1000),
PRIMARY KEY (EventID),
CONSTRAINT FK_Events FOREIGN KEY (HostID) REFERENCES Host (HostID)
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


--==============================================INSERTS========================================================--

INSERT INTO SubscriptionLevels ([Description], RenewalAmtPrice)
VALUES ('2 Year Plan', 189.00), ('1 Year Plan', 99.00), ('Quarterly', 27.00), ('Monthly', 9.99)



INSERT INTO Members (FirstName, MiddleName, LastName, Email, Phone, Gender, JoinDate, BirthDate, Subscription, SubscriptionID, CurrentFlag)
	VALUES 
			('Otis',	'Brooke',	'Fallon',	'bfallon0@artisteer.com',	'818-873-3863',	'Male',	'2017-04-07', '1971-06-29','Monthly' ,'4', '1'), 
			('Katee',	'Virgie',	'Gepp',	'vgepp1@nih.gov',	'503-689-8066',	'Female',	'2017-11-29', '1972-04-03', 'Monthly', '4', '1'),
			('Lilla',	'Charmion',	'Eatttok',	'ceatttok2@google.com.br',	'210-426-7426',	'Female',	'2017-02-26','1975-12-13','Quarterly', '3', '1'),
			('Ddene',	'Shelba',	'Clapperton',	'sclapperton3@mapquest.com',	'716-674-1640',	'Female',	'2017-11-05', '1997-02-19','Quarterly', '3', '1'),
			('Audrye',	'Agathe',	'Dawks',	'adawks4@mlb.com',	'305-415-9419',	'Female',	'2016-01-15','1989-02-07','Monthly','4','1'),
			('Fredi',	'Melisandra',	'Burgyn',	'mburgyn5@cbslocal.com',	'214-650-9837',	'Female',	'2017-03-13','1956-05-31','Yearly', '2', '1'),
			('Dimitri',	'Francisco',	'Bellino',	'fbellino6@devhub.com',	'937-971-1026',	'Male',	'2017-08-09', '1976-10-12','Monthly', '4','1'),
			('Enrico',	'Cleve',	'Seeney',	'cseeney7@macromedia.com',	'407-445-6895',	'Male',	'2016-09-09', '1988-02-29','Yearly', '2', '1'),
			('Marylinda',	'Jenine',	'OSiaghail',	'josiaghail8@tuttocitta.it',	'206-484-6850',	'Female',	'2016-11-21','1965-02-06','Yearly','2','1'),
			('Luce',	'Codi',	'Kovalski',	'ckovalski9@facebook.com',	'253-159-6773',	'Male',	'2017-12-22', '1978-03-31', 'Monthly','4', '1'),
			('Claiborn',	'Shadow',	'Baldinotti',	'sbaldinottia@discuz.net',	'253-141-4314',	'Male',	'2017-03-19', '1991-12-26','Monthly', '4', '0'),
			('Isabelle',	'Betty',	'Glossop',	'bglossopb@msu.edu',	'412-646-5145',	'Female',	'2016-04-25', '1965-02-17','Quarterly', '3', '1'),
			('Davina',	'Lira',	'Wither',	'lwitherc@smugmug.com',	'404-495-3676',	'Female',	'2016-03-21', '1957-12-16','Yearly', '2','1'),
			('Panchito',	'Hashim',	'De Gregorio',	'hdegregoriod@a8.net',	'484-717-6750',	'Male',	'2017-01-27','1964-10-14','Monthly', '4','0'),
			('Rowen',	'Arvin',	'Birdfield',	'abirdfielde@over-blog.com',	'915-299-3451',	'Male',	'2017-10-06', '1983-01-09','Monthly', '4','1')

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



INSERT INTO Host (FirstName, MiddleName, LastName, Email, Phone, Gender, StartDate, CurrentFlag, BirthDate)
	VALUES ('Tiffany',	'Watt',	'Smith',	'tiffanywatt2@gmail.com',	'352-123-4567',	'Female',	'2016-01-01',	'1',	'1974-04-13'),
('Simon',	null,	'Sinek',	'simon2@gmail.com',	'352-542-1234',	'Male',	'2016-01-01',	'1',	'1983-12-12'),
('Dan',	null,	'Pink',	'dan2@gmail.com',	'352-929-0101',	'Male',	'2016-01-01',	'1',	'1989-02-03'),
('Elizabeth',	null,	'Gilbert',	'elizabeth2@gmail.com',	'352-112-1212',	'Female',	'2016-01-01',	'1',	'1964-07-01'),
('Andrew',	null,	'Comeau',	'andrew2@gmail.com',	'352-313-3142',	'Male',	'2016-01-01',	'1',	'1991-09-12')

INSERT INTO HostAddress (HostID, AddressLine1, AddressLIne2, City, StateProvince, PostalCode)
	VALUES (1, '942 76th Street', null, 'Ocala', 'Florida', '34470'),
			(2, '832 Magnolia Avenue', null, 'Ocala', 'Florida', '34470'),
			(3, '11234 98th Circle', null, 'Ocala', 'Florida', '34470'),
			(4, '903 Highway 441', null, 'Ocala', 'Florida', '34470'),
			(5, '1337 Programming Street', null, 'Ocala', 'Florida', '34470')

INSERT INTO [Events] (HostID, EventName, EventDate, StartTime, EndTime, EventTitle, Lecturer, Discription, Comments)
	VALUES ('1',	'The History of Human Emotions',	'2017-01-12',	'12:00',	'2:00',	'History of human emotions','Tiffany Watt Smith',' A brief view of Westen Philosophy of Emotions', 'I was impressed with Plato''s philosophy of human emotions'),
('2',	'How Great Leaders Inspire Action',	'2017-02-22',	'12:00',	'1:00',	'How great leaders inspire action','Simon Sinek', 'I introdution to critical business skill for the 21 century','I thought the theory on Competative Advantage was an eye opener'),
('3',	'The Puzzle of Motivation',	'2017-03-05',	'12:00',	'3:00',	'Motivational', 'Dan Pink', 'How to maintain a positive attitude in the face of negative situations', 'Motivate people'),
('4',	'Your Elusive Creative Genius',	'2017-04-16',	'12:00',	'2:00',	'Learn to become a genius!','Elizabeth Gilbert', 'A brief intoroduction into Aristotle''s Logic Methods', 'Thinking Skills'),
('5',	'Why are Programmers So Smart?',	'2017-05-01',	'12:00',	'2:30',	'Overview of how smart programmers are','Andrew Comeau', 'An introduction to skills needed for success in a programming career','Programmers are awesome')

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

---A complete contact list for current members

GO
CREATE VIEW MemberContactList
AS
SELECT CONCAT(FirstName, ', ', LastName) AS [Member's Full Name], a.AddressLine1, a.AddressLine2,
			a.City, a.StateProvince, a.ZipCode, m.Phone, m.Email
FROM Members m
INNER JOIN MemberAddresses a 
ON m.MemberID = a.MemberID
GO

---An e-mail list
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

-- Identify expired credit cards
CREATE VIEW ExpiredCards
AS
SELECT *
FROM MembersCCPayment
WHERE CardExpiration < GETDATE()

-- Method is needed to scan for current members

CREATE VIEW Subscription_Renewals
 AS 
 select M.MemberID, M.Firstname, M.Lastname, M.Joindate,s.[Description], s.RenewalAmtPrice, MCCI.CCID
 FROM Members M
 INNER JOIN SubscriptionLevels s
 ON s.SubscriptionID = m.SubscriptionID
  INNER JOIN MembersCCPayment MCCI
 ON M.MemberID = MCCI.Memberid
 WHERE S.Active = 1 
 and datepart(day, Joindate) = datepart(day, getdate()) 
 AND S.[description] = 'Monthly'


			---------Stored Procedures----------

--- The monthly income from member renewals
GO

CREATE PROCEDURE sp_RenewalIncome
	
	@StartDate date,
	@EndDate date
	AS
	BEGIN
SELECT sum (t.Amount) [Income]
FROM CCTransactions t
WHERE t.TransactionDate between @StartDate and @EndDate

END 

GO

/* test---- exec sp_RenewalIncome '2016-01-15', '2016-01-28' */


--Member sign-ups per month over a given time
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

/* exec sp_SignUpCount '2016-03-01', '2016-03-31' */


---Attendance per event over a given time
GO

CREATE PROCEDURE sp_EventAttendance
	
	@StartDate date,
	@EndDate date
	AS
	BEGIN
SELECT e.EventID, count(memberid) [Attendence], e.EventName, e.EventDate
FROM MemberEvents a
INNER JOIN [Events] e
ON e.EventID = a.EventID
WHERE e.EventDate BETWEEN @StartDate AND @EndDate
GROUP BY e.EventID, e.EventName, e.EventDate

END 
GO
