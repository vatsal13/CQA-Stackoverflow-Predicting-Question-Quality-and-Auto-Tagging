  CREATE TABLE `math_se_posts_20120401_2_weeks` (
    `Id` int(11) NOT NULL,
    `PostTypeId` tinyint(4) DEFAULT NULL,
    `AcceptedAnswerId` int(11) DEFAULT NULL,
    `ParentId` int(11) DEFAULT NULL,
    `CreationDate` datetime DEFAULT NULL,
    `DeletionDate` datetime DEFAULT NULL,
    `Score` int(11) DEFAULT NULL,
    `ViewCount` int(11) DEFAULT NULL,
    `Body` text,
    `OwnerUserId` int(11) DEFAULT NULL,
    `OwnerDisplayName` varchar(40) DEFAULT NULL,
    `LastEditorUserId` int(11) DEFAULT NULL,
    `LastEditorDisplayName` varchar(40) DEFAULT NULL,
    `LastEditDate` datetime DEFAULT NULL,
    `LastActivityDate` datetime DEFAULT NULL,
    `Title` varchar(250) DEFAULT NULL,
    `Tags` varchar(250) DEFAULT NULL,
    `AnswerCount` int(11) DEFAULT NULL,
    `CommentCount` int(11) DEFAULT NULL,
    `FavoriteCount` int(11) DEFAULT NULL,
    `ClosedDate` datetime DEFAULT NULL,
    `CommunityOwnedDate` datetime DEFAULT NULL,
    PRIMARY KEY (`Id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


  insert into math_se_posts_20120401_2_weeks
  SELECT * FROM sml_project_new.math_se_posts_20120401 where CreationDate > '2012-02-15 23:09:06' limit 0,100000;

CREATE TABLE `math_se_posts_20130531_new` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into math_se_posts_20130531_new
SELECT * FROM sml_project_new.math_se_posts_20120401 where Id IN (select Id from math_se_posts_20120401_2_weeks);

-------------------------------------------------------------------------------------------------------------------

use sml_project_new;

create table good_votes (
   PostId int,
   VoteCount int
);

insert into good_votes
select PostId,count(*) from `math_se_votes_20130531` where VoteTypeId IN (1, 5, 2)
group by PostId;


create table bad_votes (
   PostId int,
   VoteCount int
);

insert into bad_votes
select PostId,count(*) from math_se_votes_20130531 where VoteTypeId IN (10, 3, 4, 12)
group by PostId;


CREATE TABLE `posts_gvotes` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   GoodVoteCount int,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `posts_gvotes`
select a.*, b.VoteCount
from `math_se_posts_20130531_new` a
left join good_votes b
on (a.Id = b.PostId);

CREATE TABLE `posts_gvotes_bvotes` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   GoodVoteCount int,
   BadVoteCount int,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `posts_gvotes_bvotes`
select a.*, b.VoteCount
from `posts_gvotes` a
left join bad_votes b
on (a.Id = b.PostId);

drop table good_votes;
drop table bad_votes;
drop table posts_gvotes;

set sql_safe_updates = 0;

update posts_gvotes_bvotes
set GoodVoteCount = 0
where GoodVoteCount is null;

update posts_gvotes_bvotes
set BadVoteCount = 0
where BadVoteCount is null;

CREATE TABLE `posts_gvotes_minus_bvotes` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   GoodMinusBadVoteCount int,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


insert into `posts_gvotes_minus_bvotes`
SELECT `Id`,
    `PostTypeId`,
    `AcceptedAnswerId`,
    `ParentId`,
    `CreationDate`,
    `DeletionDate`,
    `Score`,
    `ViewCount`,
    `Body`,
    `OwnerUserId`,
    `OwnerDisplayName`,
    `LastEditorUserId`,
    `LastEditorDisplayName`,
    `LastEditDate`,
    `LastActivityDate`,
    `Title`,
    `Tags`,
    `AnswerCount`,
    `CommentCount`,
    `FavoriteCount`,
    `ClosedDate`,
    `CommunityOwnedDate`,
     `GoodVoteCount` -  `BadVoteCount` `Difference`
FROM `posts_gvotes_bvotes`;

CREATE TABLE `posts_ratio` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   GoodBadVotesRatio decimal(10,3),
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

update posts_gvotes_minus_bvotes
set ViewCount = 1
where ViewCount is null;
update posts_gvotes_minus_bvotes
set ViewCount = 1
where ViewCount = 0;

insert into `posts_ratio`
SELECT `Id`,
    `PostTypeId`,
    `AcceptedAnswerId`,
    `ParentId`,
    `CreationDate`,
    `DeletionDate`,
    `Score`,
    `ViewCount`,
    `Body`,
    `OwnerUserId`,
    `OwnerDisplayName`,
    `LastEditorUserId`,
    `LastEditorDisplayName`,
    `LastEditDate`,
    `LastActivityDate`,
    `Title`,
    `Tags`,
    `AnswerCount`,
    `CommentCount`,
    `FavoriteCount`,
    `ClosedDate`,
    `CommunityOwnedDate`,
     `GoodMinusBadVoteCount` / `ViewCount`
FROM `posts_gvotes_minus_bvotes`;


CREATE TABLE `posts_label` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   label bit,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `posts_label`
SELECT `Id`,
    `PostTypeId`,
    `AcceptedAnswerId`,
    `ParentId`,
    `CreationDate`,
    `DeletionDate`,
    `Score`,
    `ViewCount`,
    `Body`,
    `OwnerUserId`,
    `OwnerDisplayName`,
    `LastEditorUserId`,
    `LastEditorDisplayName`,
    `LastEditDate`,
    `LastActivityDate`,
    `Title`,
    `Tags`,
    `AnswerCount`,
    `CommentCount`,
    `FavoriteCount`,
    `ClosedDate`,
    `CommunityOwnedDate`,
     `GoodBadVotesRatio` > 0.01
FROM `posts_ratio`;

drop table `posts_gvotes_bvotes`;
drop table `posts_gvotes_minus_bvotes`;
drop table `posts_ratio`;

select count(*) from posts_label where label = 0;

----------------------------------------------------------------------------------------------------------------------------

CREATE TABLE `posts_label_bal` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   label bit,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `posts_label_bal`
select * from posts_label where label = 0;

insert into `posts_label_bal`
select * from posts_label where label = 1 LIMIT 1, 624;

CREATE TABLE `posts_label_2012` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   label bit,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

delete from math_se_posts_20120401_2_weeks
where Id not in (select Id from posts_label_bal);

insert into posts_label_2012
select a.*, b.label
from `math_se_posts_20120401_2_weeks` a
left join posts_label b
on (a.Id = b.Id)

drop table posts_label;
drop table posts_label_bal;

CREATE TABLE `posts_label_rep` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   label bit,
   Reputation decimal(10,4),
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into posts_label_rep
select a.*, LN(b.Reputation)
from posts_label_2012 a
left join `math_se_users_20120401` b
on (a.OwnerUserId = b.Id);

create table users_question_count (
 UserId int(11),
 QuestionCount int
);

insert into users_question_count
select OwnerUserId, count(*)
from `math_se_posts_20120401`
group by OwnerUserId;

CREATE TABLE `posts_label_rep_qcount` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
   label bit,
   Reputation decimal(10,4),
   QuestionCount decimal(10,4),
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into posts_label_rep_qcount
select a.*, LN(b.QuestionCount)
from posts_label_rep a
left join users_question_count b
on (a.OwnerUserId = b.UserId);


CREATE TABLE `comment_count_high_rep` (
  `PostId` INT NOT NULL,
  `High_Rep_Comment_Count` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`PostId`));

  INSERT INTO `comment_count_high_rep`
  SELECT PostId, count(*) FROM `math_se_comments_20120401` where UserId in (SELECT Id FROM `math_se_users_20120401` where Reputation > 5000)
  group by PostId;

CREATE TABLE `posts_label_rep_qcount_hirepcomcount` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `posts_label_rep_qcount_hirepcomcount`
select a.*, b.`High_Rep_Comment_Count`
from posts_label_rep_qcount a
left join `comment_count_high_rep` b
on (a.Id = b.PostId);

update posts_label_rep_qcount_hirepcomcount
set `High_Rep_Comment_Count` = 0
where `High_Rep_Comment_Count` is null;

CREATE TABLE `comment_count` (
  `PostId` int(11) NOT NULL,
  `Comment_Count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PostId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `comment_count`
select PostId, count(*)
from `math_se_comments_20120401`
group by PostId;

CREATE TABLE `posts_label_rep_qcount_hirepcomcount_totcomcount` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  `Total_Comment_Count` int(10) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `posts_label_rep_qcount_hirepcomcount_totcomcount`
select a.*, b.`Comment_Count`
from posts_label_rep_qcount_hirepcomcount a
left join `comment_count` b
on (a.Id = b.PostId);

update `posts_label_rep_qcount_hirepcomcount_totcomcount`
set `Total_Comment_Count` = 0
where `Total_Comment_Count` is null;

create table post_earliest_comments (
PostId int not null default 0,
EarliestCommentDate DATETIME not null
);

insert into post_earliest_comments
SELECT PostId, min(CreationDate) FROM `math_se_comments_20120401`
group by PostId;


CREATE TABLE `posts_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  `Total_Comment_Count` int(10) DEFAULT NULL,
  `Create_Minus_Earliest_Comment`bigint DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


insert into posts_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom
select a.*, b.EarliestCommentDate - a.CreationDate
from posts_label_rep_qcount_hirepcomcount_totcomcount a
left join post_earliest_comments b
on (a.Id = b.PostId);

DROP TABLE `sml_project_new`.`comment_count_high_rep`,`sml_project_new`.`post_earliest_comments`, `sml_project_new`.`posts_label_2012`, `sml_project_new`.`posts_label_rep_qcount`, `sml_project_new`.`posts_label_rep`, `sml_project_new`.`posts_label_rep_qcount_hirepcomcount_totcomcount`, `sml_project_new`.`posts_label_rep_qcount_hirepcomcount`;

SELECT max(Create_Minus_Earliest_Comment) FROM sml_project_new.posts_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom;


update posts_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom
set Create_Minus_Earliest_Comment = 113002015
where Create_Minus_Earliest_Comment is null;

create table posts_and_tags (
	Id int(11) Primary Key,
    Title varchar(250),
    tags varchar(250)
)

CREATE TABLE `questions_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  `Total_Comment_Count` int(10) DEFAULT NULL,
  `Create_Minus_Earliest_Comment` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into questions_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom
select * from posts_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom
where PostTypeId=1;

create table tenp1 (
 Id int Primary Key,
 AnswerId int,
 MaxScore int,
 Lenght int
);

insert into tenp1
select a.Id, b.Id, Max(b.Score), LENGTH(b.Body)
from `questions_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom` a
left join `math_se_posts_20120401` b
on (b.ParentId = a.Id)
group by a.Id limit 0, 10000;


CREATE TABLE `questions_final_1` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  `Total_Comment_Count` int(10) DEFAULT NULL,
  `Create_Minus_Earliest_Comment` bigint(20) DEFAULT NULL,
  `Max_Score_length` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into questions_final_1
select a.*, b. Lenght
from questions_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom a
left join tenp1 b
on (a.Id = b.Id);


drop table questions_label_rep_qcnt_hirpcmcnt_tococnt_difcreearlcom;

update questions_final_1
set Max_Score_length = 0
where Max_Score_length is null;

create table temp2 (
 Id int primary key,
 temp int
);

insert into temp2
select a.Id, count(b.Id)
from tenp1 a left join `math_se_comments_20120401` b
on (a.AnswerId = b.PostId)
group by a.Id, a.AnswerId ;

CREATE TABLE `questions_final_2` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  `Total_Comment_Count` int(10) DEFAULT NULL,
  `Create_Minus_Earliest_Comment` bigint(20) DEFAULT NULL,
  `Max_Score_length` int DEFAULT NULL,
  `Max_Score_Num_Comments` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into questions_final_2
select a.*, b.temp
from questions_final_1 a
left join temp2 b
on (a.Id = b.Id);

CREATE TABLE `questions_final_2_bal` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  `Total_Comment_Count` int(10) DEFAULT NULL,
  `Create_Minus_Earliest_Comment` bigint(20) DEFAULT NULL,
  `Max_Score_length` int DEFAULT NULL,
  `Max_Score_Num_Comments` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into questions_final_2_bal
select * from questions_final_2
where label = 1 LIMIT 1, 224;

insert into questions_final_2_bal
select * from questions_final_2
where label = 0;


CREATE TABLE `questions_final_3` (
  `Id` int(11) NOT NULL,
  `PostTypeId` tinyint(4) DEFAULT NULL,
  `AcceptedAnswerId` int(11) DEFAULT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `CreationDate` datetime DEFAULT NULL,
  `DeletionDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `ViewCount` int(11) DEFAULT NULL,
  `Body` text,
  `OwnerUserId` int(11) DEFAULT NULL,
  `OwnerDisplayName` varchar(40) DEFAULT NULL,
  `LastEditorUserId` int(11) DEFAULT NULL,
  `LastEditorDisplayName` varchar(40) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `LastActivityDate` datetime DEFAULT NULL,
  `Title` varchar(250) DEFAULT NULL,
  `Tags` varchar(250) DEFAULT NULL,
  `AnswerCount` int(11) DEFAULT NULL,
  `CommentCount` int(11) DEFAULT NULL,
  `FavoriteCount` int(11) DEFAULT NULL,
  `ClosedDate` datetime DEFAULT NULL,
  `CommunityOwnedDate` datetime DEFAULT NULL,
  `label` bit(1) DEFAULT NULL,
  `user_rep` decimal(10,4) DEFAULT NULL,
  `user_ques_count` decimal(10,4) DEFAULT NULL,
  `High_Rep_Comment_Count` int(10) DEFAULT NULL,
  `Total_Comment_Count` int(10) DEFAULT NULL,
  `Create_Minus_Earliest_Comment` bigint(20) DEFAULT NULL,
  `Max_Score_length` int DEFAULT NULL,
  `Max_Score_Num_Comments` int DEFAULT NULL,
  `Sentiment` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into questions_final_3
select a.*, b.Sentiment
from questions_final_2_bal a
left join sentiment b
on (a.Id = b.Id);

create table sml_project_new.doctopic1606 (
 `Id` int(11) NOT NULL PRIMARY KEY, `Topic1` double DEFAULT NUL,
  `Topic2` double DEFAULT NULL,
  `Topic3` double DEFAULT NULL,
  `Topic4` double DEFAULT NULL,
  `Topic5` double DEFAULT NULL,
  `Topic6` double DEFAULT NULL,
  `Topic7` double DEFAULT NULL,
  `Topic8` double DEFAULT NULL,
  `Topic9` double DEFAULT NULL,
  `Topic10` double DEFAULT NULL);

  CREATE TABLE `questions_final_4` (
    `Id` int(11) NOT NULL,
    `AnswerCount` int(11) DEFAULT NULL,
    `user_rep` decimal(10,4) DEFAULT NULL,
    `user_ques_count` decimal(10,4) DEFAULT NULL,
    `High_Rep_Comment_Count` int(10) DEFAULT NULL,
    `Total_Comment_Count` int(10) DEFAULT NULL,
    `Max_Score_length` int DEFAULT NULL,
    `Max_Score_Num_Comments` int DEFAULT NULL,
    `Sentiment` int(11) DEFAULT NULL,
    `Topic1` double DEFAULT NULL,
    `Topic2` double DEFAULT NULL,
    `Topic3` double DEFAULT NULL,
    `Topic4` double DEFAULT NULL,
    `Topic5` double DEFAULT NULL,
    `Topic6` double DEFAULT NULL,
    `Topic7` double DEFAULT NULL,
    `Topic8` double DEFAULT NULL,
    `Topic9` double DEFAULT NULL,
    `Topic10` double DEFAULT NULL,
    `label` bit(1) DEFAULT NULL,
    PRIMARY KEY (`Id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

  insert into questions_final_4
  select a.Id, a.AnswerCount, a.user_rep, a.user_ques_count, a.High_Rep_Comment_Count, a.Total_Comment_Count, a.Max_Score_length, a.Max_Score_Num_Comments, a.Sentiment,
  b.`Topic1`, b.`Topic2`,     b.`Topic3`,    b.`Topic4`,    b.`Topic5`,    b.`Topic6`,
      b.`Topic7`,    b.`Topic8`,    b.`Topic9`,    b.`Topic10`,a.label
  from questions_final_3 a left join doctopic1606 b
  on (a.Id = b.Id);

  update questions_final_4
  set AnswerCount = 0
  where AnswerCount is null;

  update questions_final_4
set user_rep = 0
where user_rep is null;

update questions_final_4
set Sentiment = 1
where Sentiment is null;
