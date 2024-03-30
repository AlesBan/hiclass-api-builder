CREATE TABLE "Countries"
(
    "CountryId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title"     text NOT NULL,
    CONSTRAINT "PK_Countries" PRIMARY KEY ("CountryId")
);


CREATE TABLE "Disciplines"
(
    "DisciplineId" uuid                  NOT NULL DEFAULT (gen_random_uuid()),
    "Title"        character varying(30) NOT NULL,
    CONSTRAINT "PK_Disciplines" PRIMARY KEY ("DisciplineId")
);


CREATE TABLE "Grades"
(
    "GradeId"     uuid    NOT NULL DEFAULT (gen_random_uuid()),
    "GradeNumber" integer NOT NULL,
    CONSTRAINT "PK_Grades" PRIMARY KEY ("GradeId")
);


CREATE TABLE "InstitutionTypes"
(
    "InstitutionTypeId" uuid                  NOT NULL DEFAULT (gen_random_uuid()),
    "Title"             character varying(20) NOT NULL,
    CONSTRAINT "PK_InstitutionTypes" PRIMARY KEY ("InstitutionTypeId")
);


CREATE TABLE "Languages"
(
    "LanguageId" uuid                  NOT NULL DEFAULT (gen_random_uuid()),
    "Title"      character varying(30) NOT NULL,
    CONSTRAINT "PK_Languages" PRIMARY KEY ("LanguageId")
);


CREATE TABLE "Roles"
(
    "RoleId" uuid                  NOT NULL DEFAULT (gen_random_uuid()),
    "Title"  character varying(30) NOT NULL,
    CONSTRAINT "PK_Roles" PRIMARY KEY ("RoleId")
);


CREATE TABLE "Cities"
(
    "CityId"    uuid                  NOT NULL DEFAULT (gen_random_uuid()),
    "Title"     character varying(30) NOT NULL,
    "CountryId" uuid                  NOT NULL,
    CONSTRAINT "PK_Cities" PRIMARY KEY ("CityId"),
    CONSTRAINT "FK_Cities_Countries_CountryId" FOREIGN KEY ("CountryId") REFERENCES "Countries" ("CountryId") ON DELETE CASCADE
);


CREATE TABLE "Institutions"
(
    "InstitutionId" uuid                   NOT NULL DEFAULT (gen_random_uuid()),
    "Title"         character varying(50)  NOT NULL,
    "Address"       character varying(150) NOT NULL,
    "CityId"        uuid NULL,
    CONSTRAINT "PK_Institutions" PRIMARY KEY ("InstitutionId"),
    CONSTRAINT "FK_Institutions_Cities_CityId" FOREIGN KEY ("CityId") REFERENCES "Cities" ("CityId")
);


CREATE TABLE "InstitutionTypesInstitutions"
(
    "InstitutionTypeId" uuid NOT NULL,
    "InstitutionId"     uuid NOT NULL,
    CONSTRAINT "PK_InstitutionTypesInstitutions" PRIMARY KEY ("InstitutionTypeId", "InstitutionId"),
    CONSTRAINT "FK_InstitutionTypesInstitutions_Institutions_InstitutionId" FOREIGN KEY ("InstitutionId") REFERENCES "Institutions" ("InstitutionId") ON DELETE CASCADE,
    CONSTRAINT "FK_InstitutionTypesInstitutions_InstitutionTypes_InstitutionTy~" FOREIGN KEY ("InstitutionTypeId") REFERENCES "InstitutionTypes" ("InstitutionTypeId") ON DELETE CASCADE
);


CREATE TABLE "Users"
(
    "UserId"                uuid                     NOT NULL,
    "Email"                 text                     NOT NULL,
    "PasswordHash"          bytea                    NOT NULL,
    "PasswordSalt"          bytea                    NOT NULL,
    "AccessToken"           text NULL,
    "PasswordResetToken"    text NULL,
    "ResetTokenExpires"     timestamp with time zone NULL,
    "PasswordResetCode"     text NULL,
    "VerificationCode"      character varying(10) NULL,
    "IsCreatedAccount"      boolean                  NOT NULL DEFAULT FALSE,
    "IsVerified"            boolean                  NOT NULL DEFAULT FALSE,
    "IsInstitutionVerified" boolean                  NOT NULL DEFAULT FALSE,
    "FirstName"             character varying(40) NULL,
    "LastName"              character varying(40) NULL,
    "IsATeacher"            boolean NULL,
    "IsAnExpert"            boolean NULL,
    "InstitutionId"         uuid NULL,
    "CityId"                uuid NULL,
    "CountryId"             uuid NULL,
    "Rating"                numeric(3, 2)            NOT NULL DEFAULT 0.0,
    "Description"           character varying(300) NULL,
    "ImageUrl"              character varying(255) NULL,
    "BannerImageUrl"        character varying(255) NULL,
    "RegisteredAt"          timestamp with time zone NOT NULL DEFAULT (now()),
    "CreatedAt"             timestamp with time zone NULL,
    "VerifiedAt"            timestamp with time zone NULL,
    "LastOnlineAt"          timestamp with time zone NOT NULL DEFAULT (now()),
    "DeletedAt"             timestamp with time zone NULL,
    CONSTRAINT "PK_Users" PRIMARY KEY ("UserId"),
    CONSTRAINT "FK_Users_Cities_CityId" FOREIGN KEY ("CityId") REFERENCES "Cities" ("CityId") ON DELETE SET NULL,
    CONSTRAINT "FK_Users_Countries_CountryId" FOREIGN KEY ("CountryId") REFERENCES "Countries" ("CountryId") ON DELETE SET NULL,
    CONSTRAINT "FK_Users_Institutions_InstitutionId" FOREIGN KEY ("InstitutionId") REFERENCES "Institutions" ("InstitutionId") ON DELETE SET NULL
);


CREATE TABLE "Classes"
(
    "ClassId"   uuid                     NOT NULL,
    "UserId"    uuid                     NOT NULL,
    "Title"     character varying(40)    NOT NULL,
    "GradeId"   uuid                     NOT NULL,
    "ImageUrl"  character varying(200) NULL,
    "CreatedAt" timestamp with time zone NOT NULL DEFAULT (now()),
    "DeletedAt" timestamp with time zone NULL,
    CONSTRAINT "PK_Classes" PRIMARY KEY ("ClassId"),
    CONSTRAINT "FK_Classes_Grades_GradeId" FOREIGN KEY ("GradeId") REFERENCES "Grades" ("GradeId") ON DELETE CASCADE,
    CONSTRAINT "FK_Classes_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);


CREATE TABLE "UserDisciplines"
(
    "DisciplineId" uuid NOT NULL,
    "UserId"       uuid NOT NULL,
    CONSTRAINT "PK_UserDisciplines" PRIMARY KEY ("UserId", "DisciplineId"),
    CONSTRAINT "FK_UserDisciplines_Disciplines_DisciplineId" FOREIGN KEY ("DisciplineId") REFERENCES "Disciplines" ("DisciplineId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserDisciplines_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);


CREATE TABLE "UserGrades"
(
    "GradeId" uuid NOT NULL,
    "UserId"  uuid NOT NULL,
    CONSTRAINT "PK_UserGrades" PRIMARY KEY ("UserId", "GradeId"),
    CONSTRAINT "FK_UserGrades_Grades_GradeId" FOREIGN KEY ("GradeId") REFERENCES "Grades" ("GradeId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserGrades_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);


CREATE TABLE "UserLanguages"
(
    "UserId"     uuid NOT NULL,
    "LanguageId" uuid NOT NULL,
    CONSTRAINT "PK_UserLanguages" PRIMARY KEY ("UserId", "LanguageId"),
    CONSTRAINT "FK_UserLanguages_Languages_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES "Languages" ("LanguageId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserLanguages_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);


CREATE TABLE "UserRoles"
(
    "UserId" uuid NOT NULL,
    "RoleId" uuid NOT NULL,
    CONSTRAINT "PK_UserRoles" PRIMARY KEY ("UserId", "RoleId"),
    CONSTRAINT "FK_UserRoles_Roles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "Roles" ("RoleId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserRoles_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);


CREATE TABLE "ClassDisciplines"
(
    "DisciplineId" uuid NOT NULL,
    "ClassId"      uuid NOT NULL,
    CONSTRAINT "PK_ClassDisciplines" PRIMARY KEY ("ClassId", "DisciplineId"),
    CONSTRAINT "FK_ClassDisciplines_Classes_ClassId" FOREIGN KEY ("ClassId") REFERENCES "Classes" ("ClassId") ON DELETE CASCADE,
    CONSTRAINT "FK_ClassDisciplines_Disciplines_DisciplineId" FOREIGN KEY ("DisciplineId") REFERENCES "Disciplines" ("DisciplineId") ON DELETE CASCADE
);


CREATE TABLE "ClassLanguages"
(
    "LanguageId" uuid NOT NULL,
    "ClassId"    uuid NOT NULL,
    CONSTRAINT "PK_ClassLanguages" PRIMARY KEY ("LanguageId", "ClassId"),
    CONSTRAINT "FK_ClassLanguages_Classes_ClassId" FOREIGN KEY ("ClassId") REFERENCES "Classes" ("ClassId") ON DELETE CASCADE,
    CONSTRAINT "FK_ClassLanguages_Languages_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES "Languages" ("LanguageId") ON DELETE CASCADE
);


CREATE TABLE "Invitations"
(
    "InvitationId"     uuid                     NOT NULL DEFAULT (gen_random_uuid()),
    "UserSenderId"     uuid                     NOT NULL,
    "UserReceiverId"   uuid                     NOT NULL,
    "ClassSenderId"    uuid                     NOT NULL,
    "ClassReceiverId"  uuid                     NOT NULL,
    "CreatedAt"        timestamp with time zone NOT NULL DEFAULT (now()),
    "DateOfInvitation" timestamp with time zone NOT NULL,
    "Status"           text                     NOT NULL DEFAULT 'Pending',
    "InvitationText"   character varying(255) NULL,
    CONSTRAINT "PK_Invitations" PRIMARY KEY ("InvitationId"),
    CONSTRAINT "FK_Invitations_Classes_ClassReceiverId" FOREIGN KEY ("ClassReceiverId") REFERENCES "Classes" ("ClassId"),
    CONSTRAINT "FK_Invitations_Classes_ClassSenderId" FOREIGN KEY ("ClassSenderId") REFERENCES "Classes" ("ClassId"),
    CONSTRAINT "FK_Invitations_Users_UserReceiverId" FOREIGN KEY ("UserReceiverId") REFERENCES "Users" ("UserId"),
    CONSTRAINT "FK_Invitations_Users_UserSenderId" FOREIGN KEY ("UserSenderId") REFERENCES "Users" ("UserId")
);


CREATE TABLE "Feedbacks"
(
    "FeedbackId"             uuid    NOT NULL DEFAULT (gen_random_uuid()),
    "InvitationId"           uuid    NOT NULL,
    "UserSenderId"           uuid    NOT NULL,
    "UserRecipientId"        uuid    NOT NULL,
    "ClassSenderId"          uuid    NOT NULL,
    "ClassReceiverId"        uuid    NOT NULL,
    "WasTheJointLesson"      boolean NOT NULL,
    "ReasonForNotConducting" character varying(255) NULL,
    "FeedbackText"           character varying(255) NULL,
    "Rating"                 SMALLINT NULL,
    "CreatedAt" timestamp with time zone NOT NULL DEFAULT (now()),
    CONSTRAINT "PK_Feedbacks" PRIMARY KEY ("FeedbackId"),
    CONSTRAINT "FK_Feedbacks_Classes_ClassReceiverId" FOREIGN KEY ("ClassReceiverId") REFERENCES "Classes" ("ClassId") ON DELETE CASCADE,
    CONSTRAINT "FK_Feedbacks_Classes_ClassSenderId" FOREIGN KEY ("ClassSenderId") REFERENCES "Classes" ("ClassId") ON DELETE CASCADE,
    CONSTRAINT "FK_Feedbacks_Invitations_InvitationId" FOREIGN KEY ("InvitationId") REFERENCES "Invitations" ("InvitationId") ON DELETE CASCADE,
    CONSTRAINT "FK_Feedbacks_Users_UserRecipientId" FOREIGN KEY ("UserRecipientId") REFERENCES "Users" ("UserId") ON DELETE CASCADE,
    CONSTRAINT "FK_Feedbacks_Users_UserSenderId" FOREIGN KEY ("UserSenderId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE UNIQUE INDEX "IX_Cities_CityId" ON "Cities" ("CityId");


CREATE INDEX "IX_Cities_CountryId" ON "Cities" ("CountryId");


CREATE UNIQUE INDEX "IX_ClassDisciplines_ClassId_DisciplineId" ON "ClassDisciplines" ("ClassId", "DisciplineId");


CREATE INDEX "IX_ClassDisciplines_DisciplineId" ON "ClassDisciplines" ("DisciplineId");


CREATE UNIQUE INDEX "IX_Classes_ClassId" ON "Classes" ("ClassId");


CREATE INDEX "IX_Classes_GradeId" ON "Classes" ("GradeId");


CREATE INDEX "IX_Classes_UserId" ON "Classes" ("UserId");


CREATE INDEX "IX_ClassLanguages_ClassId" ON "ClassLanguages" ("ClassId");


CREATE UNIQUE INDEX "IX_ClassLanguages_LanguageId_ClassId" ON "ClassLanguages" ("LanguageId", "ClassId");


CREATE UNIQUE INDEX "IX_Countries_CountryId" ON "Countries" ("CountryId");


CREATE UNIQUE INDEX "IX_Disciplines_DisciplineId" ON "Disciplines" ("DisciplineId");


CREATE INDEX "IX_Feedbacks_ClassReceiverId" ON "Feedbacks" ("ClassReceiverId");


CREATE INDEX "IX_Feedbacks_ClassSenderId" ON "Feedbacks" ("ClassSenderId");


CREATE UNIQUE INDEX "IX_Feedbacks_FeedbackId" ON "Feedbacks" ("FeedbackId");


CREATE INDEX "IX_Feedbacks_InvitationId" ON "Feedbacks" ("InvitationId");


CREATE INDEX "IX_Feedbacks_UserRecipientId" ON "Feedbacks" ("UserRecipientId");


CREATE INDEX "IX_Feedbacks_UserSenderId" ON "Feedbacks" ("UserSenderId");


CREATE UNIQUE INDEX "IX_Grades_GradeId" ON "Grades" ("GradeId");


CREATE INDEX "IX_Institutions_CityId" ON "Institutions" ("CityId");


CREATE UNIQUE INDEX "IX_Institutions_InstitutionId" ON "Institutions" ("InstitutionId");


CREATE UNIQUE INDEX "IX_InstitutionTypes_InstitutionTypeId" ON "InstitutionTypes" ("InstitutionTypeId");


CREATE INDEX "IX_InstitutionTypesInstitutions_InstitutionId" ON "InstitutionTypesInstitutions" ("InstitutionId");


CREATE UNIQUE INDEX "IX_InstitutionTypesInstitutions_InstitutionTypeId_InstitutionId" ON "InstitutionTypesInstitutions" ("InstitutionTypeId", "InstitutionId");


CREATE INDEX "IX_Invitations_ClassReceiverId" ON "Invitations" ("ClassReceiverId");


CREATE INDEX "IX_Invitations_ClassSenderId" ON "Invitations" ("ClassSenderId");


CREATE UNIQUE INDEX "IX_Invitations_InvitationId" ON "Invitations" ("InvitationId");


CREATE INDEX "IX_Invitations_UserReceiverId" ON "Invitations" ("UserReceiverId");


CREATE INDEX "IX_Invitations_UserSenderId" ON "Invitations" ("UserSenderId");


CREATE UNIQUE INDEX "IX_Languages_LanguageId" ON "Languages" ("LanguageId");


CREATE UNIQUE INDEX "IX_Roles_RoleId" ON "Roles" ("RoleId");


CREATE INDEX "IX_UserDisciplines_DisciplineId" ON "UserDisciplines" ("DisciplineId");


CREATE UNIQUE INDEX "IX_UserDisciplines_UserId_DisciplineId" ON "UserDisciplines" ("UserId", "DisciplineId");


CREATE INDEX "IX_UserGrades_GradeId" ON "UserGrades" ("GradeId");


CREATE UNIQUE INDEX "IX_UserGrades_UserId_GradeId" ON "UserGrades" ("UserId", "GradeId");


CREATE INDEX "IX_UserLanguages_LanguageId" ON "UserLanguages" ("LanguageId");


CREATE UNIQUE INDEX "IX_UserLanguages_UserId_LanguageId" ON "UserLanguages" ("UserId", "LanguageId");


CREATE INDEX "IX_UserRoles_RoleId" ON "UserRoles" ("RoleId");


CREATE UNIQUE INDEX "IX_UserRoles_UserId_RoleId" ON "UserRoles" ("UserId", "RoleId");


CREATE INDEX "IX_Users_CityId" ON "Users" ("CityId");


CREATE INDEX "IX_Users_CountryId" ON "Users" ("CountryId");


CREATE INDEX "IX_Users_InstitutionId" ON "Users" ("InstitutionId");


CREATE UNIQUE INDEX "IX_Users_UserId" ON "Users" ("UserId");
