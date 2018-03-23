
CREATE TABLE [Dormitories]
( 
	[DormitoryNumber]    int  NOT NULL ,
	[Address]            varchar()  NULL ,
	[PhoneNumber]        char(12)  NULL ,
	[CommandantNameSurname] char(18)  NULL 
)
go

ALTER TABLE [Dormitories]
	ADD CONSTRAINT [XPKDormitories] PRIMARY KEY  CLUSTERED ([DormitoryNumber] ASC)
go

CREATE TABLE [Faculties]
( 
	[Name]               varchar()  NULL ,
	[DeaneryPhoneNumber] int  NULL ,
	[DeanNameSurname]    char(50)  NULL ,
	[FacultyID]          int  NOT NULL 
)
go

ALTER TABLE [Faculties]
	ADD CONSTRAINT [XPKFaculties] PRIMARY KEY  CLUSTERED ([FacultyID] ASC)
go

CREATE TABLE [Groups]
( 
	[GroupCipher]        varchar()  NULL ,
	[FacultyCode]        int  NULL ,
	[GroupID]            int  NOT NULL 
)
go

ALTER TABLE [Groups]
	ADD CONSTRAINT [XPKGroups] PRIMARY KEY  CLUSTERED ([GroupID] ASC)
go

CREATE TABLE [PersonalCard]
( 
	[CardID]             int  NOT NULL ,
	[NameSurname]        varchar()  NULL ,
	[DateOfBirth]        date  NULL ,
	[RoomNumber]         int  NOT NULL ,
	[ParentsAddress]     char(50)  NULL ,
	[FacultyID]          int  NOT NULL ,
	[GroupID]            int  NOT NULL 
)
go

ALTER TABLE [PersonalCard]
	ADD CONSTRAINT [XPKPersonalCard] PRIMARY KEY  CLUSTERED ([CardID] ASC)
go

CREATE TABLE [Rooms]
( 
	[RoomNumber]         int  NOT NULL ,
	[DormitoryNumber]    int  NOT NULL ,
	[PlacesQuantity]     int  NULL 
)
go

ALTER TABLE [Rooms]
	ADD CONSTRAINT [XPKRooms] PRIMARY KEY  CLUSTERED ([RoomNumber] ASC)
go


ALTER TABLE [PersonalCard]
	ADD CONSTRAINT [R_3] FOREIGN KEY ([FacultyID]) REFERENCES [Faculties]([FacultyID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PersonalCard]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([GroupID]) REFERENCES [Groups]([GroupID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [PersonalCard]
	ADD CONSTRAINT [R_6] FOREIGN KEY ([RoomNumber]) REFERENCES [Rooms]([RoomNumber])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Rooms]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([DormitoryNumber]) REFERENCES [Dormitories]([DormitoryNumber])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_Dormitories ON Dormitories FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Dormitories */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Dormitories  Rooms on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001113f", PARENT_OWNER="", PARENT_TABLE="Dormitories"
    CHILD_OWNER="", CHILD_TABLE="Rooms"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="DormitoryNumber" */
    IF EXISTS (
      SELECT * FROM deleted,Rooms
      WHERE
        /*  %JoinFKPK(Rooms,deleted," = "," AND") */
        Rooms.DormitoryNumber = deleted.DormitoryNumber
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Dormitories because Rooms exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Dormitories ON Dormitories FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Dormitories */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insDormitoryNumber int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Dormitories  Rooms on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012b9a", PARENT_OWNER="", PARENT_TABLE="Dormitories"
    CHILD_OWNER="", CHILD_TABLE="Rooms"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="DormitoryNumber" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(DormitoryNumber)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Rooms
      WHERE
        /*  %JoinFKPK(Rooms,deleted," = "," AND") */
        Rooms.DormitoryNumber = deleted.DormitoryNumber
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Dormitories because Rooms exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Faculties ON Faculties FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Faculties */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Faculties  PersonalCard on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00011353", PARENT_OWNER="", PARENT_TABLE="Faculties"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="FacultyID" */
    IF EXISTS (
      SELECT * FROM deleted,PersonalCard
      WHERE
        /*  %JoinFKPK(PersonalCard,deleted," = "," AND") */
        PersonalCard.FacultyID = deleted.FacultyID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Faculties because PersonalCard exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Faculties ON Faculties FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Faculties */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insFacultyID int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Faculties  PersonalCard on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012f8e", PARENT_OWNER="", PARENT_TABLE="Faculties"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="FacultyID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(FacultyID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PersonalCard
      WHERE
        /*  %JoinFKPK(PersonalCard,deleted," = "," AND") */
        PersonalCard.FacultyID = deleted.FacultyID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Faculties because PersonalCard exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Groups ON Groups FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Groups */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Groups  PersonalCard on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000102dd", PARENT_OWNER="", PARENT_TABLE="Groups"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="GroupID" */
    IF EXISTS (
      SELECT * FROM deleted,PersonalCard
      WHERE
        /*  %JoinFKPK(PersonalCard,deleted," = "," AND") */
        PersonalCard.GroupID = deleted.GroupID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Groups because PersonalCard exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Groups ON Groups FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Groups */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insGroupID int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Groups  PersonalCard on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012ac6", PARENT_OWNER="", PARENT_TABLE="Groups"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="GroupID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(GroupID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PersonalCard
      WHERE
        /*  %JoinFKPK(PersonalCard,deleted," = "," AND") */
        PersonalCard.GroupID = deleted.GroupID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Groups because PersonalCard exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PersonalCard ON PersonalCard FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PersonalCard */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Rooms  PersonalCard on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000395c0", PARENT_OWNER="", PARENT_TABLE="Rooms"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="RoomNumber" */
    IF EXISTS (SELECT * FROM deleted,Rooms
      WHERE
        /* %JoinFKPK(deleted,Rooms," = "," AND") */
        deleted.RoomNumber = Rooms.RoomNumber AND
        NOT EXISTS (
          SELECT * FROM PersonalCard
          WHERE
            /* %JoinFKPK(PersonalCard,Rooms," = "," AND") */
            PersonalCard.RoomNumber = Rooms.RoomNumber
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PersonalCard because Rooms exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Groups  PersonalCard on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Groups"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="GroupID" */
    IF EXISTS (SELECT * FROM deleted,Groups
      WHERE
        /* %JoinFKPK(deleted,Groups," = "," AND") */
        deleted.GroupID = Groups.GroupID AND
        NOT EXISTS (
          SELECT * FROM PersonalCard
          WHERE
            /* %JoinFKPK(PersonalCard,Groups," = "," AND") */
            PersonalCard.GroupID = Groups.GroupID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PersonalCard because Groups exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Faculties  PersonalCard on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Faculties"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="FacultyID" */
    IF EXISTS (SELECT * FROM deleted,Faculties
      WHERE
        /* %JoinFKPK(deleted,Faculties," = "," AND") */
        deleted.FacultyID = Faculties.FacultyID AND
        NOT EXISTS (
          SELECT * FROM PersonalCard
          WHERE
            /* %JoinFKPK(PersonalCard,Faculties," = "," AND") */
            PersonalCard.FacultyID = Faculties.FacultyID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PersonalCard because Faculties exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_PersonalCard ON PersonalCard FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PersonalCard */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insCardID int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Rooms  PersonalCard on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0003fe2f", PARENT_OWNER="", PARENT_TABLE="Rooms"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="RoomNumber" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(RoomNumber)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Rooms
        WHERE
          /* %JoinFKPK(inserted,Rooms) */
          inserted.RoomNumber = Rooms.RoomNumber
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PersonalCard because Rooms does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Groups  PersonalCard on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Groups"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="GroupID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(GroupID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Groups
        WHERE
          /* %JoinFKPK(inserted,Groups) */
          inserted.GroupID = Groups.GroupID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PersonalCard because Groups does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Faculties  PersonalCard on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Faculties"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="FacultyID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(FacultyID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Faculties
        WHERE
          /* %JoinFKPK(inserted,Faculties) */
          inserted.FacultyID = Faculties.FacultyID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PersonalCard because Faculties does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Rooms ON Rooms FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Rooms */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Rooms  PersonalCard on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00024db4", PARENT_OWNER="", PARENT_TABLE="Rooms"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="RoomNumber" */
    IF EXISTS (
      SELECT * FROM deleted,PersonalCard
      WHERE
        /*  %JoinFKPK(PersonalCard,deleted," = "," AND") */
        PersonalCard.RoomNumber = deleted.RoomNumber
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Rooms because PersonalCard exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Dormitories  Rooms on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dormitories"
    CHILD_OWNER="", CHILD_TABLE="Rooms"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="DormitoryNumber" */
    IF EXISTS (SELECT * FROM deleted,Dormitories
      WHERE
        /* %JoinFKPK(deleted,Dormitories," = "," AND") */
        deleted.DormitoryNumber = Dormitories.DormitoryNumber AND
        NOT EXISTS (
          SELECT * FROM Rooms
          WHERE
            /* %JoinFKPK(Rooms,Dormitories," = "," AND") */
            Rooms.DormitoryNumber = Dormitories.DormitoryNumber
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Rooms because Dormitories exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Rooms ON Rooms FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Rooms */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insRoomNumber int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Rooms  PersonalCard on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002857c", PARENT_OWNER="", PARENT_TABLE="Rooms"
    CHILD_OWNER="", CHILD_TABLE="PersonalCard"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="RoomNumber" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(RoomNumber)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PersonalCard
      WHERE
        /*  %JoinFKPK(PersonalCard,deleted," = "," AND") */
        PersonalCard.RoomNumber = deleted.RoomNumber
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Rooms because PersonalCard exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Dormitories  Rooms on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Dormitories"
    CHILD_OWNER="", CHILD_TABLE="Rooms"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="DormitoryNumber" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(DormitoryNumber)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Dormitories
        WHERE
          /* %JoinFKPK(inserted,Dormitories) */
          inserted.DormitoryNumber = Dormitories.DormitoryNumber
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Rooms because Dormitories does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


