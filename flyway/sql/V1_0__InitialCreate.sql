CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

CREATE TABLE "Countries" (
    "CountryId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title" character varying(50) NOT NULL,
    CONSTRAINT "PK_Countries" PRIMARY KEY ("CountryId")
);

CREATE TABLE "Devices" (
    "DeviceId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "DeviceToken" character varying(255) NOT NULL,
    CONSTRAINT "PK_Devices" PRIMARY KEY ("DeviceId")
);

CREATE TABLE "Disciplines" (
    "DisciplineId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title" character varying(30) NOT NULL,
    CONSTRAINT "PK_Disciplines" PRIMARY KEY ("DisciplineId")
);

CREATE TABLE "Grades" (
    "GradeId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "GradeNumber" integer NOT NULL,
    CONSTRAINT "PK_Grades" PRIMARY KEY ("GradeId")
);

CREATE TABLE "Institutions" (
    "InstitutionId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title" character varying(50) NOT NULL,
    "Address" character varying(150) NOT NULL,
    CONSTRAINT "PK_Institutions" PRIMARY KEY ("InstitutionId")
);

CREATE TABLE "InstitutionTypes" (
    "InstitutionTypeId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title" character varying(20) NOT NULL,
    CONSTRAINT "PK_InstitutionTypes" PRIMARY KEY ("InstitutionTypeId")
);

CREATE TABLE "Languages" (
    "LanguageId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title" character varying(30) NOT NULL,
    CONSTRAINT "PK_Languages" PRIMARY KEY ("LanguageId")
);

CREATE TABLE "Roles" (
    "RoleId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title" character varying(20) NOT NULL,
    CONSTRAINT "PK_Roles" PRIMARY KEY ("RoleId")
);

CREATE TABLE "Cities" (
    "CityId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "Title" character varying(30) NOT NULL,
    "CountryId" uuid NOT NULL,
    CONSTRAINT "PK_Cities" PRIMARY KEY ("CityId"),
    CONSTRAINT "FK_Cities_Countries_CountryId" FOREIGN KEY ("CountryId") REFERENCES "Countries" ("CountryId") ON DELETE CASCADE
);

CREATE TABLE "InstitutionTypesInstitutions" (
    "InstitutionTypeId" uuid NOT NULL,
    "InstitutionId" uuid NOT NULL,
    CONSTRAINT "PK_InstitutionTypesInstitutions" PRIMARY KEY ("InstitutionTypeId", "InstitutionId"),
    CONSTRAINT "FK_InstitutionTypesInstitutions_Institutions_InstitutionId" FOREIGN KEY ("InstitutionId") REFERENCES "Institutions" ("InstitutionId") ON DELETE CASCADE,
    CONSTRAINT "FK_InstitutionTypesInstitutions_InstitutionTypes_InstitutionTy~" FOREIGN KEY ("InstitutionTypeId") REFERENCES "InstitutionTypes" ("InstitutionTypeId") ON DELETE CASCADE
);

CREATE TABLE "Users" (
    "UserId" uuid NOT NULL,
    "Email" text NOT NULL,
    "IsGoogleSignedIn" boolean NOT NULL DEFAULT FALSE,
    "IsPasswordSet" boolean NOT NULL DEFAULT FALSE,
    "PasswordHash" bytea NOT NULL,
    "PasswordSalt" bytea NOT NULL,
    "PasswordResetCode" character(6) NULL,
    "VerificationCode" character varying(10) NULL,
    "IsCreatedAccount" boolean NOT NULL DEFAULT FALSE,
    "IsVerified" boolean NOT NULL DEFAULT FALSE,
    "IsInstitutionVerified" boolean NOT NULL DEFAULT FALSE,
    "FirstName" character varying(40) NULL DEFAULT '',
    "LastName" character varying(40) NULL DEFAULT '',
    "IsATeacher" boolean NULL,
    "IsAnExpert" boolean NULL,
    "InstitutionId" uuid NULL,
    "CityId" uuid NULL,
    "CountryId" uuid NULL,
    "Rating" numeric(3,2) NOT NULL DEFAULT 0.0,
    "Description" character varying(300) NULL DEFAULT '',
    "ImageUrl" character varying(255) NULL DEFAULT '',
    "BannerImageUrl" character varying(255) NULL DEFAULT '',
    "RegisteredAt" timestamp with time zone NOT NULL DEFAULT (now()),
    "CreatedAt" timestamp with time zone NULL DEFAULT (now()),
    "VerifiedAt" timestamp with time zone NULL,
    "LastOnlineAt" timestamp with time zone NOT NULL DEFAULT (now()),
    "DeletedAt" timestamp with time zone NULL,
    CONSTRAINT "PK_Users" PRIMARY KEY ("UserId"),
    CONSTRAINT "FK_Users_Cities_CityId" FOREIGN KEY ("CityId") REFERENCES "Cities" ("CityId") ON DELETE SET NULL,
    CONSTRAINT "FK_Users_Countries_CountryId" FOREIGN KEY ("CountryId") REFERENCES "Countries" ("CountryId") ON DELETE SET NULL,
    CONSTRAINT "FK_Users_Institutions_InstitutionId" FOREIGN KEY ("InstitutionId") REFERENCES "Institutions" ("InstitutionId") ON DELETE SET NULL
);

CREATE TABLE "Classes" (
    "ClassId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "Title" character varying(40) NOT NULL,
    "GradeId" uuid NOT NULL,
    "ImageUrl" character varying(200) NULL DEFAULT '',
    "CreatedAt" timestamp with time zone NOT NULL DEFAULT (now()),
    "DisciplineId" uuid NOT NULL,
    CONSTRAINT "PK_Classes" PRIMARY KEY ("ClassId"),
    CONSTRAINT "FK_Classes_Disciplines_DisciplineId" FOREIGN KEY ("DisciplineId") REFERENCES "Disciplines" ("DisciplineId") ON DELETE CASCADE,
    CONSTRAINT "FK_Classes_Grades_GradeId" FOREIGN KEY ("GradeId") REFERENCES "Grades" ("GradeId") ON DELETE CASCADE,
    CONSTRAINT "FK_Classes_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Notifications" (
    "NotificationId" uuid NOT NULL,
    "UserReceiverId" uuid NOT NULL,
    "Type" integer NOT NULL,
    "Status" integer NOT NULL,
    "Message" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    "ReadAt" timestamp with time zone NULL,
    "IsDeleted" boolean NOT NULL,
    "DeletedAt" timestamp with time zone NULL,
    CONSTRAINT "PK_Notifications" PRIMARY KEY ("NotificationId"),
    CONSTRAINT "FK_Notifications_Users_UserReceiverId" FOREIGN KEY ("UserReceiverId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "UserDevices" (
    "UserId" uuid NOT NULL,
    "DeviceId" uuid NOT NULL,
    "RefreshToken" text NULL,
    "IsActive" boolean NOT NULL,
    "LastActive" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_UserDevices" PRIMARY KEY ("UserId", "DeviceId"),
    CONSTRAINT "FK_UserDevices_Devices_DeviceId" FOREIGN KEY ("DeviceId") REFERENCES "Devices" ("DeviceId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserDevices_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "UserDisciplines" (
    "DisciplineId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    CONSTRAINT "PK_UserDisciplines" PRIMARY KEY ("UserId", "DisciplineId"),
    CONSTRAINT "FK_UserDisciplines_Disciplines_DisciplineId" FOREIGN KEY ("DisciplineId") REFERENCES "Disciplines" ("DisciplineId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserDisciplines_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "UserGrades" (
    "GradeId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    CONSTRAINT "PK_UserGrades" PRIMARY KEY ("UserId", "GradeId"),
    CONSTRAINT "FK_UserGrades_Grades_GradeId" FOREIGN KEY ("GradeId") REFERENCES "Grades" ("GradeId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserGrades_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "UserLanguages" (
    "UserId" uuid NOT NULL,
    "LanguageId" uuid NOT NULL,
    CONSTRAINT "PK_UserLanguages" PRIMARY KEY ("UserId", "LanguageId"),
    CONSTRAINT "FK_UserLanguages_Languages_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES "Languages" ("LanguageId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserLanguages_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "UserRoles" (
    "UserId" uuid NOT NULL,
    "RoleId" uuid NOT NULL,
    CONSTRAINT "PK_UserRoles" PRIMARY KEY ("UserId", "RoleId"),
    CONSTRAINT "FK_UserRoles_Roles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "Roles" ("RoleId") ON DELETE CASCADE,
    CONSTRAINT "FK_UserRoles_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "ClassLanguages" (
    "LanguageId" uuid NOT NULL,
    "ClassId" uuid NOT NULL,
    CONSTRAINT "PK_ClassLanguages" PRIMARY KEY ("LanguageId", "ClassId"),
    CONSTRAINT "FK_ClassLanguages_Classes_ClassId" FOREIGN KEY ("ClassId") REFERENCES "Classes" ("ClassId") ON DELETE CASCADE,
    CONSTRAINT "FK_ClassLanguages_Languages_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES "Languages" ("LanguageId") ON DELETE CASCADE
);

CREATE TABLE "Invitations" (
    "InvitationId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "UserSenderId" uuid NOT NULL,
    "UserRecipientId" uuid NOT NULL,
    "ClassSenderId" uuid NOT NULL,
    "ClassRecipientId" uuid NULL,
    "CreatedAt" timestamp with time zone NOT NULL DEFAULT (now()),
    "DateOfInvitation" timestamp with time zone NOT NULL,
    "Type" integer NOT NULL,
    "Status" text NOT NULL,
    "InvitationText" character varying(255) NULL,
    CONSTRAINT "PK_Invitations" PRIMARY KEY ("InvitationId"),
    CONSTRAINT "FK_Invitations_Classes_ClassRecipientId" FOREIGN KEY ("ClassRecipientId") REFERENCES "Classes" ("ClassId") ON DELETE CASCADE,
    CONSTRAINT "FK_Invitations_Classes_ClassSenderId" FOREIGN KEY ("ClassSenderId") REFERENCES "Classes" ("ClassId") ON DELETE CASCADE,
    CONSTRAINT "FK_Invitations_Users_UserRecipientId" FOREIGN KEY ("UserRecipientId") REFERENCES "Users" ("UserId") ON DELETE CASCADE,
    CONSTRAINT "FK_Invitations_Users_UserSenderId" FOREIGN KEY ("UserSenderId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

CREATE TABLE "Feedbacks" (
    "FeedbackId" uuid NOT NULL DEFAULT (gen_random_uuid()),
    "InvitationId" uuid NOT NULL,
    "UserFeedbackSenderId" uuid NOT NULL,
    "UserFeedbackReceiverId" uuid NOT NULL,
    "WasTheJointLesson" boolean NOT NULL,
    "ReasonForNotConducting" character varying(255) NULL,
    "FeedbackText" character varying(255) NULL,
    "Rating" SMALLINT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Feedbacks" PRIMARY KEY ("FeedbackId"),
    CONSTRAINT "FK_Feedbacks_Invitations_InvitationId" FOREIGN KEY ("InvitationId") REFERENCES "Invitations" ("InvitationId") ON DELETE CASCADE,
    CONSTRAINT "FK_Feedbacks_Users_UserFeedbackReceiverId" FOREIGN KEY ("UserFeedbackReceiverId") REFERENCES "Users" ("UserId") ON DELETE CASCADE,
    CONSTRAINT "FK_Feedbacks_Users_UserFeedbackSenderId" FOREIGN KEY ("UserFeedbackSenderId") REFERENCES "Users" ("UserId") ON DELETE CASCADE
);

INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('015fa99f-240f-417c-be8e-d7c439121174', 'Chemistry');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('12a5942f-9853-454c-baf7-96e232389935', 'Russian language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('1752f8ea-2cc0-4068-8a2c-d4a1e640503f', 'German as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('17804eaa-5545-43ff-999a-322b3eeae281', 'Technology');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('2885cc04-9a6d-4e27-b195-873fb9ed6006', 'Mathematics');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('295166c1-e0fc-405e-ab7f-ce8ccfb98f9f', 'Physics');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('438b29e7-7009-44a2-8746-c33e1bc4fd05', 'Vacation education');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('4c616c7f-ab5d-4813-a751-3b2a18470971', 'Crafts');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('5533de6f-51dc-4c9b-b38e-5f10f03ad259', 'Project-based learning');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('5e1d1e46-7be8-4f67-8041-f52850f08d6f', 'History');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('6e609695-3277-4572-82fb-d4f8f7ddaf47', 'Astronomy');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('71d49552-0957-44a8-96ae-dd0ec109b7a9', 'Computer science');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('73944100-895d-4adf-9932-657d43476888', 'French as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('78bd3361-7a78-4dcc-98e9-9c5071facfee', 'Fine arts');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('89e95ed1-8088-4340-ab37-1386de70fdd8', 'Geography');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('9e12b5c1-2aa5-4568-940e-db882e03e2e5', 'Music');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('a4a3b902-14e9-41c5-bdca-19440b896845', 'Chinese as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('bc71607b-a8e3-4bc8-9e59-23ce339a454c', 'Italian as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('c8f9ca19-5b8d-43d0-804c-225ef2c27050', 'Natural science');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('cec8688b-4d51-4bad-b8b1-561203ad02f6', 'Economics');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('d4216af8-f6de-4b10-b3a0-b8b5ec2357b7', 'Russian literature');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('d9f732c2-370f-4536-8385-e9028ceb0f00', 'English as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('da2a943c-8ea5-4ada-a6b4-12b14a9ac641', 'Regional studies');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('e3fc8b5a-bc11-4ab4-bb40-d7503d7de16a', 'World art');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('e843df9f-97aa-484e-8695-42628efe3c10', 'Spanish as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('eb196ec4-35b4-463c-b29d-a41dbec7c3b3', 'Social science');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('f243d0b6-9462-4190-ba6d-b2b54433d512', 'Biology');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('ff71d771-57a7-437a-a6ad-d81b7df8849c', 'Cultural exchange');

INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('1253bf02-ead4-4b35-932e-e8bd142c6787', 12);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('26da8ff8-4eae-4b1d-af1a-0e5aecdf6ff0', 6);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('3bf4b91d-cf09-4b4d-8f2f-1e967f36ef23', 2);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('6340d28b-2407-4bf5-9cd7-9881bdf35897', 8);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('791daf36-d1c5-4453-9bfe-2f509894f43f', 1);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('8a2ec320-60a0-4938-8ff5-99adbdfaee6e', 9);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('8e2f9809-ca64-4c0b-be9d-93dcbadf32a7', 5);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('91b147da-00e6-403f-9656-3c1ce0ea1f7b', 10);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('a96f0ada-2a48-4792-a13f-0875c17a54ba', 4);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('ada13721-da9a-48ef-bb10-99c2ac3ab1a5', 3);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('b929ed6f-9fd2-44ef-bc38-7c291ac994bf', 11);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('d61fd4f1-352a-4e7f-a0c2-5d7ada20570e', 7);

INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('43cee2fb-f464-4f21-8b1b-a1edc6539a15', 'School');
INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('4f3a52f2-2371-4419-a7cd-cd84ebe6f7f0', 'College');
INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('cf2df748-eb5a-4291-a7f5-4a117560e937', 'Gymnasium');
INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('f102524a-ed03-4bd1-a166-a6b135ebb79d', 'Lyceum');

INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('05c314f5-89ec-4399-8e22-8758b261a788', 'Kazakh');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('3e72e330-b845-4eb0-84a2-c9072185bd9e', 'Spanish');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('4580a4ce-d0d7-490c-a084-522a3429fa3f', 'Belarusian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('5f4c4bbc-5c03-4b9b-b54e-db0930717e1f', 'Uzbek');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('70ac3a7a-6a0a-47a9-b350-d7bb69058c45', 'Georgian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('72ce4328-7613-4d9c-b606-378f0441c207', 'Portuguese');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('8650489d-76a1-482a-aa73-db1c61e85010', 'Tajik');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('8ab2784d-53fb-4f0c-be8d-ea0bce40ec61', 'Azerbaijani');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('9b3bac73-5c09-4adf-adfb-87f371b3cc3f', 'English');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('a2de0434-2f8f-4166-be19-3d76f5f83fd9', 'Italian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('a463d76a-cbc1-4914-a0ce-dac72dbba114', 'Hungarian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('a663abf7-d16c-4277-a996-9ff9415567a5', 'French');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('b60d1166-529b-4697-88bf-bd28fae6b742', 'Russian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('bde87ad8-a036-4385-b44d-b78c5ebb4f85', 'Armenian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('c2d2bbb9-4140-4ff1-979d-47da41e7d79b', 'Ukrainian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('c429260b-9a74-4b3d-a803-6bea12f1dac6', 'Kyrgyz');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('ccad397e-ed67-4872-9b01-05666b29d1dd', 'German');

INSERT INTO "Roles" ("RoleId", "Title")
VALUES ('20c55b58-455b-4987-8aea-2f368d30a439', 'User');
INSERT INTO "Roles" ("RoleId", "Title")
VALUES ('7465fbc8-4249-4191-9747-3a52b6fe12f9', 'Manager');
INSERT INTO "Roles" ("RoleId", "Title")
VALUES ('78c327b2-118d-49de-a6f3-f17614a0f900', 'Admin');

CREATE UNIQUE INDEX "IX_Cities_CityId" ON "Cities" ("CityId");

CREATE INDEX "IX_Cities_CountryId" ON "Cities" ("CountryId");

CREATE UNIQUE INDEX "IX_Cities_Title_CountryId" ON "Cities" ("Title", "CountryId");

CREATE UNIQUE INDEX "IX_Classes_ClassId" ON "Classes" ("ClassId");

CREATE INDEX "IX_Classes_DisciplineId" ON "Classes" ("DisciplineId");

CREATE INDEX "IX_Classes_GradeId" ON "Classes" ("GradeId");

CREATE INDEX "IX_Classes_UserId" ON "Classes" ("UserId");

CREATE INDEX "IX_ClassLanguages_ClassId" ON "ClassLanguages" ("ClassId");

CREATE UNIQUE INDEX "IX_ClassLanguages_LanguageId_ClassId" ON "ClassLanguages" ("LanguageId", "ClassId");

CREATE UNIQUE INDEX "IX_Countries_CountryId" ON "Countries" ("CountryId");

CREATE UNIQUE INDEX "IX_Countries_Title" ON "Countries" ("Title");

CREATE UNIQUE INDEX "IX_Devices_DeviceId" ON "Devices" ("DeviceId");

CREATE UNIQUE INDEX "IX_Devices_DeviceToken" ON "Devices" ("DeviceToken");

CREATE UNIQUE INDEX "IX_Disciplines_DisciplineId" ON "Disciplines" ("DisciplineId");

CREATE UNIQUE INDEX "IX_Feedbacks_FeedbackId" ON "Feedbacks" ("FeedbackId");

CREATE INDEX "IX_Feedbacks_InvitationId" ON "Feedbacks" ("InvitationId");

CREATE INDEX "IX_Feedbacks_UserFeedbackReceiverId" ON "Feedbacks" ("UserFeedbackReceiverId");

CREATE INDEX "IX_Feedbacks_UserFeedbackSenderId" ON "Feedbacks" ("UserFeedbackSenderId");

CREATE UNIQUE INDEX "IX_Grades_GradeId" ON "Grades" ("GradeId");

CREATE UNIQUE INDEX "IX_Grades_GradeNumber" ON "Grades" ("GradeNumber");

CREATE UNIQUE INDEX "IX_Institutions_InstitutionId" ON "Institutions" ("InstitutionId");

CREATE UNIQUE INDEX "IX_InstitutionTypes_InstitutionTypeId" ON "InstitutionTypes" ("InstitutionTypeId");

CREATE INDEX "IX_InstitutionTypesInstitutions_InstitutionId" ON "InstitutionTypesInstitutions" ("InstitutionId");

CREATE UNIQUE INDEX "IX_InstitutionTypesInstitutions_InstitutionTypeId_InstitutionId" ON "InstitutionTypesInstitutions" ("InstitutionTypeId", "InstitutionId");

CREATE INDEX "IX_Invitations_ClassRecipientId" ON "Invitations" ("ClassRecipientId");

CREATE INDEX "IX_Invitations_ClassSenderId" ON "Invitations" ("ClassSenderId");

CREATE UNIQUE INDEX "IX_Invitations_InvitationId" ON "Invitations" ("InvitationId");

CREATE INDEX "IX_Invitations_UserRecipientId" ON "Invitations" ("UserRecipientId");

CREATE INDEX "IX_Invitations_UserSenderId" ON "Invitations" ("UserSenderId");

CREATE UNIQUE INDEX "IX_Languages_LanguageId" ON "Languages" ("LanguageId");

CREATE INDEX "IX_Notifications_UserReceiverId" ON "Notifications" ("UserReceiverId");

CREATE UNIQUE INDEX "IX_Roles_RoleId" ON "Roles" ("RoleId");

CREATE INDEX "IX_UserDevices_DeviceId" ON "UserDevices" ("DeviceId");

CREATE UNIQUE INDEX "IX_UserDevices_UserId_DeviceId" ON "UserDevices" ("UserId", "DeviceId");

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

CREATE UNIQUE INDEX "IX_Users_Email" ON "Users" ("Email");

CREATE INDEX "IX_Users_InstitutionId" ON "Users" ("InstitutionId");

CREATE UNIQUE INDEX "IX_Users_UserId" ON "Users" ("UserId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20240922132400_Initial', '6.0.26');

COMMIT;

