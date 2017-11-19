## Download
The Stack Overflow dump (Jan. 2016) used in the paper can be dowloaded from [here](http://....) (tgz, ~9GB). This is an external link that won't be downloaded through `git clone`,

### Or...
Given the size of the original Stack Overflow dump, the quickest way to obtain it is through the original torrent files, hosted at [archive.org](https://archive.org/download/stackexchange). The following are the files that must be imported to your local database.

* stackoverflow.com-Badges.7z
* stackoverflow.com-Comments.7z
* stackoverflow.com-PostHistory.7z
* stackoverflow.com-PostLinks.7z
* stackoverflow.com-Posts.7z
* stackoverflow.com-Tags.7z
* stackoverflow.com-Users.7z
* stackoverflow.com-Votes.7z

### Import
Check the following [Gist](https://gist.github.com/tundo91/1e074af39d90629252a7df3fc1066397) for an example of how to perform the import.
```sql
# Copyright (c) 2013 Georgios Gousios
# MIT-licensed
# [tundo91] 
# * Edited to import local XML files
# * Updated creat table procedures to support Sept.-12-2016 dataset dump version

create database stackoverflow DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
use stackoverflow;

create table Badges (
  Id INT NOT NULL PRIMARY KEY,
  UserId INT,
  Name VARCHAR(50),
  Date DATETIME,
  Class SMALLINT,
  TagBased BIT(64)
);

CREATE TABLE Comments (
    Id INT NOT NULL PRIMARY KEY,
    PostId INT NOT NULL,
    Score INT NOT NULL DEFAULT 0,
    Text TEXT,
    CreationDate DATETIME,
    UserDisplayName VARCHAR(30),
    UserId INT
);

CREATE TABLE PostHistory (
    Id INT NOT NULL PRIMARY KEY,
    PostHistoryTypeId SMALLINT NOT NULL,
    PostId INT NOT NULL,
    RevisionGUID VARCHAR(36) NOT NULL,
    CreationDate DATETIME NOT NULL,
    UserId INT,
    UserDisplayName VARCHAR(40),
    Comment VARCHAR(400),
    Text TEXT
);

CREATE TABLE PostLinks (
  Id INT NOT NULL PRIMARY KEY,
  CreationDate DATETIME DEFAULT NULL,
  PostId INT NOT NULL,
  RelatedPostId INT NOT NULL,
  LinkTypeId SMALLINT NOT NULL
);

CREATE TABLE Posts (
    Id INT NOT NULL PRIMARY KEY,
    PostTypeId TINYINT NOT NULL ,
    AcceptedAnswerId INT,
    ParentId INT,
    CreationDate DATETIME NOT NULL,
    DeletionDate DATETIME,
    Score INT NULL,
    ViewCount INT NULL,
    Body text NULL,
    OwnerUserId INT,
    OwnerDisplayName varchar(256),
    LastEditorUserId INT,
    LastEditorDisplayName VARCHAR(40),
    LastEditDate DATETIME,
    LastActivityDate DATETIME,
    Title varchar(256),
    Tags VARCHAR(256),
    AnswerCount INT DEFAULT 0,
    CommentCount INT DEFAULT 0,
    FavoriteCount INT DEFAULT 0,
    ClosedDate DATETIME,
    CommunityOwnedDate DATETIME
);

CREATE TABLE Tags (
  Id INT NOT NULL PRIMARY KEY,
  TagName VARCHAR(50) CHARACTER SET latin1 DEFAULT NULL,
  Count INT DEFAULT NULL,
  ExcerptPostId INT DEFAULT NULL,
  WikiPostId INT DEFAULT NULL
);

CREATE TABLE Users (
    Id INT NOT NULL PRIMARY KEY,
    Reputation INT NOT NULL,
    CreationDate DATETIME,
    DisplayName VARCHAR(40) NULL,
    LastAccessDate  DATETIME NOT NULL,
    WebsiteUrl VARCHAR(256) NULL,
    Location VARCHAR(256) NULL,
    AboutMe TEXT NULL,
    Views INT DEFAULT 0,
    UpVotes INT,
    DownVotes INT,
    ProfileImageUrl VARCHAR(200) NULL,
    EmailHash VARCHAR(32),
    Age INT NULL,
    AccountId INT NULL
);

CREATE TABLE Votes (
    Id INT NOT NULL PRIMARY KEY,
    PostId INT NOT NULL,
    VoteTypeId SMALLINT NOT NULL,
    UserId INT,
    CreationDate DATETIME,
    BountyAmount INT
);

load xml infile '/path/to.../Badges.xml'
into table Badges
rows identified by '<row>';

load xml infile '/path/to.../Comments.xml'
into table Comments
rows identified by '<row>';

load xml infile '/path/to.../PostHistory.xml'
into table PostHistory
rows identified by '<row>';

load xml infile '/path/to.../PostLinks.xml'
INTO TABLE PostLinks
ROWS IDENTIFIED BY '<row>';

load xml infile '/path/to.../Posts.xml'
into table Posts
rows identified by '<row>';

load xml infile '/path/to.../Tags.xml'
INTO TABLE Tags
ROWS IDENTIFIED BY '<row>';

load xml infile '/path/to.../Users.xml'
into table Users
rows identified by '<row>';

load xml infile '/path/to.../Votes.xml'
into table Votes
rows identified by '<row>';

create index Badges_idx_1 on Badges(UserId);
create index Comments_idx_1 on Comments(PostId);
create index Comments_idx_2 on Comments(UserId);
create index Post_history_idx_1 on PostHistory(PostId);
create index Post_history_idx_2 on PostHistory(UserId);
create index Posts_idx_1 on Posts(AcceptedAnswerId);
create index Posts_idx_2 on Posts(ParentId);
create index Posts_idx_3 on Posts(OwnerUserId);
create index Posts_idx_4 on Posts(LastEditorUserId);
create index Votes_idx_1 on Votes(PostId);
```
### CSV export
Once the dump is imported into MySQL, you can export all the answers in the DB through the following command.
```sql
select PQ.Id, PQ.Body, PQ.Title, PQ.Tags, PQ.AcceptedAnswerId, PQ.AnswerCount, PQ.CreationDate, PA.Id, PA.CreationDate, PA.Score, PA.Body
from Posts as PA, Posts as PQ   
where PA.PostTypeId = 2 and PA.ParentId = PQ.Id
order by PA.ParentId
INTO OUTFILE '/path/to/all_answers.csv' 
fields fields terminated by ';' enclosed by '"';
```
