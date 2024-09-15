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

INSERT INTO "Countries" ("CountryId", "Title")
VALUES ('6ead4fb4-7204-4e3a-820c-2933e3f48d9f', 'Russia');
INSERT INTO "Countries" ("CountryId", "Title")
VALUES ('fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', 'Belarus');

INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('05cd0d9c-463d-4593-81bf-2d19f569d807', 'Spanish as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('1885a957-adb8-4350-8653-1882cea4d876', 'Vacation education');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('1b2c7f47-0507-4dab-8044-1984e1808dea', 'Chinese as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('2096cd80-4c8d-4cc6-83dc-fd831de3e680', 'Chemistry');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('2ea8670f-e417-452b-984c-b043c11b49b4', 'Russian language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('4308f3f6-a3d6-4027-80e5-9d2db284b998', 'Mathematics');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('56656709-bd6d-49b1-a603-aa25e2be0067', 'Geography');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('646c491d-e4dc-4378-b3a7-70f69410f888', 'Cultural exchange');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('65784bac-4b3f-4c91-ac76-9bd5ea10a976', 'Economics');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('6eb07f2e-6178-4b0b-9628-84772c6beee4', 'Natural science');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('76d0222d-f73c-49fa-b5a0-4be2796ec471', 'French as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('7efacd8a-acef-4392-a525-206868b48318', 'English as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('80f5db8c-5cad-49bd-8a7e-0258c43cabd2', 'Russian literature');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('81f2d6b7-55a6-455c-b4cf-64809d8387bc', 'Fine arts');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('8260ba1c-e0fc-4f8d-8ea2-09e7195a5e9b', 'Italian as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('8d86f2e4-e299-4d71-a947-68a83701dbba', 'World art');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('8e1d151a-f51a-47b4-ba74-32a2b3397c58', 'Project-based learning');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('94c2051e-02ac-4488-b483-6dfe68f74bda', 'Technology');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('995cb81a-ec3b-4617-a35e-17892de5f49b', 'Social science');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('ab3a804a-dae5-48d8-b3dc-e8fb8d9ae791', 'Astronomy');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('bc85dc99-5e18-4659-93a7-f75ae4ff3418', 'Music');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('cad17c1c-2757-4de3-8ca6-72171b142e53', 'Physics');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('dabd5b72-7d42-451f-8bac-fe8a5ef8da3c', 'Computer science');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('dca92fce-a927-4033-ad8d-e9ba403635c9', 'Regional studies');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('e008b1db-d3cf-4613-b17a-37a982a22e03', 'German as a foreign language');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('e4f89ee6-d64f-45ed-8d82-a544595168e8', 'Biology');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('e94db376-f261-4de8-9af7-9819dfcd6f09', 'Crafts');
INSERT INTO "Disciplines" ("DisciplineId", "Title")
VALUES ('f6e68e98-f1e1-4fd8-b245-b6552d62e516', 'History');

INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('170ef561-249a-4399-a0cf-b32b002bfcd1', 11);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 8);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('72b2af8a-037a-4dbc-9885-64e0f5a3da3b', 3);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('9064f323-8254-4181-80c8-fd79f24d76a5', 1);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('90a467cb-6ad1-44c4-9a59-30b8a05b0f7d', 12);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', 9);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('92c73250-790f-4ec4-872e-9d3a66c06414', 2);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('9ccb966b-867f-4c77-84a1-5a85b20e3fb2', 7);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', 5);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('d50cf999-46a9-467e-b77b-6ad6b4e67416', 6);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('db61f833-bd64-439d-ad5b-d2f37b8beeff', 10);
INSERT INTO "Grades" ("GradeId", "GradeNumber")
VALUES ('ede355e4-d17f-47e8-8680-8f876ea06890', 4);

INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('0101e66d-d12f-4257-b3e4-f1d38ef50385', 'Gymnasium');
INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('0e39e820-b74f-4691-95d9-2eefa0948b08', 'School');
INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('8a8431c1-e8dd-4216-b001-e6e3e4a1cece', 'College');
INSERT INTO "InstitutionTypes" ("InstitutionTypeId", "Title")
VALUES ('eb7da4d5-7419-4b90-9908-d1b50d3d6cce', 'Lyceum');

INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('03a0ca7a-0f44-4352-bdf0-8d16df97fe23', 'Belarus, Minsk', 'OsdtSPBwgpyYYW');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('10e93aa9-cbee-438b-905c-afa017b36497', 'Belarus, Minsk', 'MjvSdfOXFnrbUZ');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('3bbd73e0-caae-421f-93fe-06c800417bbb', 'Russia, Moscow', 'NbFpTOfIHbmNNR');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('3e954988-1fd4-44e4-b2d6-6a9958786fe0', 'Russia, Moscow', 'XuoeYUCvpejNWR');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('4023ebd2-992c-49a0-bc14-d6a6ca5c710c', 'Belarus, Minsk', 'kOexBsihnNXADe');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('457ae4a0-8488-47de-8b2a-8f0667971741', 'Russia, Moscow', 'aZSMdEeavQgMjn');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('465442a0-c6ea-4ed0-b738-d0c24d68e244', 'Russia, Moscow', 'JNoytszrrNUnYN');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('49620d4f-3e1d-4c64-9ebd-9625a3ef18ed', 'Belarus, Minsk', 'WDAHNxBmenPWsU');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('532ff952-4707-48eb-bebd-e99f2824bde9', 'Belarus, Minsk', 'WiBMAqSVvrOnaO');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('54b405a4-91f4-41db-ae49-fb03d96a2ba6', 'Belarus, Minsk', 'IJlOunIrbJbPNL');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('5a1ae1e4-e73e-411f-94e9-e71f9facf449', 'Belarus, Minsk', 'zwzmrpVBiKZOqU');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('5cbdc5f2-e53f-4c90-aae6-0c933888b0ec', 'Russia, Moscow', 'vBPmZCJHkDaBzT');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('62e817f4-823b-4195-a4c5-8fc935bf11a8', 'Russia, Moscow', 'ugeOjvZnRparzf');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('649db981-5ffe-43ee-8706-69c499e760f1', 'Belarus, Minsk', 'ehDaxMPtPjFuXo');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('68739bd0-e965-4f9a-ab2c-bc8c4d59f748', 'Russia, Moscow', 'TszQlhFuiCIUsT');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('7169c5a3-ac79-458b-b2c2-d71234b9e00b', 'Russia, Moscow', 'yvJhcWtapwweVW');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('7264e080-8b97-448c-9b4c-80ada63c6fa6', 'Belarus, Minsk', 'ukUqGlYUjMZwBZ');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('7a6473f4-db63-49c9-955f-2d3d8d419106', 'Belarus, Minsk', 'ljRJtBWwZoZMsf');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('89cc7fe8-9d21-4de5-b105-7f43d59f2910', 'Russia, Moscow', 'sWvnGBkcNKmoya');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('8dcdec00-e10e-4f9a-84bf-b32d51b07875', 'Belarus, Minsk', 'RgELjoeKqjXlxk');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('9961ba83-e4da-4359-834b-2a84f236f645', 'Belarus, Minsk', 'rcFkbLcRIgyphM');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('9acfe6ce-1451-4b5c-ba2c-df00d957d903', 'Belarus, Minsk', 'ISeaMkiJHLgiih');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('a1b05331-7a50-48b4-8a66-4915bafad8ae', 'Belarus, Minsk', 'GFBRxlBsDEXAZf');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('a685d09a-49e5-4ee9-85ac-8d723e22d0a0', 'Belarus, Minsk', 'nQICZvPIWWkfuE');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('ac63bd6b-ae08-46f0-907e-6a75bbb6e3bd', 'Russia, Moscow', 'KlZnaKNwLQjdAQ');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('b0ee766b-154d-4288-a910-ec92d930bb5e', 'Russia, Moscow', 'NiBDtYZCIRSnXk');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('b1272eed-ea89-43ce-bcaa-2adc71ceec57', 'Belarus, Minsk', 'nFlXvJQOjQZjXJ');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('bb5ed775-a3fc-4714-9ede-7312d224d669', 'Belarus, Minsk', 'wquaoKSuevdjbE');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('bc6d3bdc-99a8-4192-9c29-b16faa5bca57', 'Russia, Moscow', 'snLiJpTZOvQJDZ');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('c0e2cb0f-03b9-4937-822c-0c9366aee38d', 'Belarus, Minsk', 'BJsYVkcrxCFYCX');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('d1953cb8-0197-41b2-bcac-8c3b64aa2622', 'Belarus, Minsk', 'RflTrwPFsJMfcS');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('d7c17830-afbe-45eb-a853-4825e75e828c', 'Belarus, Minsk', 'nAxTXhQhUicsLb');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('db6be08c-c217-4f02-b880-eaace9b78615', 'Russia, Moscow', 'lPAdCiutilyTvn');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('df5bed6a-1fbe-4deb-877a-b1a8141ba729', 'Belarus, Minsk', 'OfQljClCgtTYmi');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('e86c8780-e568-4000-8351-09dfcb155466', 'Russia, Moscow', 'UcHAMKIhqgOvKQ');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('e984c875-7108-47dc-b011-88c9561f91f0', 'Russia, Moscow', 'wiuWIzYBIMFeAs');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('e9e96a58-7c74-48d0-b09d-280b5fb69e93', 'Russia, Moscow', 'PSaTHEWTkTOsAE');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('f3e2ac2d-037b-4079-a8a1-64e9a61851e3', 'Belarus, Minsk', 'xmOieALCfkYpzi');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('f74b0161-2699-4acd-a5c8-c98c657de8f9', 'Russia, Moscow', 'yBIIZNtMSewErH');
INSERT INTO "Institutions" ("InstitutionId", "Address", "Title")
VALUES ('f874382d-ab6c-49b6-852b-8872c9977daa', 'Belarus, Minsk', 'ZPFrXyMnTlFJBB');

INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('019004e0-41c7-4a21-89db-e3c540fa753b', 'Georgian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('12f951d4-0e5e-42e1-aa58-579371c3ee92', 'Belarusian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('21c520f5-0b8f-4018-ab3e-94d996bf167e', 'Portuguese');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('275cadea-af03-4a3d-8637-bc091a12e320', 'Hungarian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', 'Tajik');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('2afe12f5-351b-48b7-8c4e-8b0a0d6da016', 'Russian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('3503299f-c3d3-4b9c-b58c-f8b24a4b73b1', 'Ukrainian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('668f2340-e6e4-41c0-97dc-80e8c3957f46', 'Uzbek');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('73640749-040c-4706-a6d6-654304f27e28', 'French');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('7453f6b8-474b-47ca-9142-3a1a6645da6b', 'German');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('813cb9d6-b5e4-43ec-87a5-f0dbdc673874', 'Spanish');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('932b2828-192f-4188-b3ed-c9279c3e3d97', 'Armenian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('961c1956-6d79-4f1b-a91c-1dbf94849f6b', 'Italian');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('be5eaf87-7df1-4ea8-8aeb-7143ea9b27d2', 'Azerbaijani');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('c387f063-49b4-4d9f-bdfa-0dcb2a66f7a7', 'Kyrgyz');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('e7b9f0b6-c11e-46ba-93aa-da75604b5c40', 'English');
INSERT INTO "Languages" ("LanguageId", "Title")
VALUES ('e8db68a4-cd49-497d-994d-2c56626305dd', 'Kazakh');

INSERT INTO "Roles" ("RoleId", "Title")
VALUES ('40a6b594-6a75-4b80-a7ad-ecd50a252289', 'Admin');
INSERT INTO "Roles" ("RoleId", "Title")
VALUES ('493472a4-73f7-445c-a7f2-ee9936714f3a', 'User');
INSERT INTO "Roles" ("RoleId", "Title")
VALUES ('bbf6be92-c58b-4782-8df8-d029bbc4f1c0', 'Manager');

INSERT INTO "Cities" ("CityId", "CountryId", "Title")
VALUES ('4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', 'Moscow');
INSERT INTO "Cities" ("CityId", "CountryId", "Title")
VALUES ('9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', 'Minsk');

INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('12400cfe-40ce-40d9-bd1f-fcd3b304b844', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user18@example.com', 'nmrMge', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'b0ee766b-154d-4288-a910-ec92d930bb5e', TRUE, FALSE, TRUE, TRUE, 'VRrFsYrS', BYTEA E'\\xF2F3FE1903F248BE7BA98753ECD4F587CC045BAD237C4CF690180E36FFB1B56AEF603CFC482F6D069442F4B80170028E510676E17A4E7EF07C33E202DFE9FB7E', '', BYTEA E'\\xAB7E565215EB6B72B8F055018EECAAC2C8F72AF0661D252BE7AEF2EA1BD20156EE90FB17A284AC44A02EF6B45FD77A7CE6B46ECB03844EFE6985DB2DFFBC1BE97C187D57D4E5AB5C068D6378C20321E933BF024BECE1BDCC8002BEE6F65CBF0DAAF0E77741BD4C2BCC20059BFB64B7E4DC1222BBC607F3A455D74E2D81EEA02D', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('1ca9a342-8a19-44fc-add3-d86fd5dc03c8', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user24@example.com', 'xnyYaX', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '54b405a4-91f4-41db-ae49-fb03d96a2ba6', TRUE, FALSE, TRUE, TRUE, 'TZHpinJP', BYTEA E'\\x0A79B863F0B3D0DEAAB8CD4E949E5BCC9C635384AFCE84147E40AC27AE6EE42B2BE8A96C5F0855D6A1A257DEC5BC7C8AB3852A57CF643493AE9779C760EF64B1', '', BYTEA E'\\x07F6B5688EE671A514EC932D3B9EE3210BBB92FB8DAD83D572F00B948800CCD65BD888B5F05F9C38D128842A02AB5F8F68F51ECE3BC69D09CCAF1BC1EE6B69A1813F6990231CB9134AC08C4A666654D64132E016BB740634BE4CAFD69A85A5C3CA5C4C27A1D4EA2AF0B1245418981996ADD07D97083379F2C3400697996C8FC3', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('213947a9-6ba6-4d30-b3fc-be0709ae44f0', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user30@example.com', 'hHbKmB', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'a1b05331-7a50-48b4-8a66-4915bafad8ae', TRUE, FALSE, TRUE, TRUE, 'ESQLbpei', BYTEA E'\\x3535B5258D930A3FDCD0D010959D941A3929D4E3619AD81B9EA69E5D871F6EC10481D293B94C057461B48746EE2EA59845D9BB68A6835993473EBC05E9EC0635', '', BYTEA E'\\x72039CE614CE5C887CCA85833439F8F158E59E542E322E0264C93FB5D3387B418908592878DB1ACD6A38C5D48F4C8BB6FA8D180F62678CB8D727669A6E06159E9BC21587A6C17F7971DEC5582D64871A835B3B90D728930D88EEE1CB05B9FB75F32D4ABBB449EFA6AE02EC336817E78CD2FFC57D4840086C0FC7FC1D7B82F880', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('221c3b60-2d38-480f-9434-65489bafd990', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user2@example.com', 'gFimeA', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '649db981-5ffe-43ee-8706-69c499e760f1', TRUE, FALSE, TRUE, TRUE, 'cZBQLjKx', BYTEA E'\\x557D32A2ADAFD5208751D0E4B8FF814C2331CCAFA5FEA5DA66AF6BFD8B70EBC8B774530525CB8C286CE58C34C5B3ABEBEFC6205DFD11826198DC4BDA938027CF', '', BYTEA E'\\xFE901BF75233834E9ED783597DD49AD34B9B88252F7E729B8D5EB6FCAFEC49EE8F1828D6EB75BB4996E7A91C0EAC1FA350C414887B854FE8E1A1C41D91C85F1F591EB9A67E4C499E1F9D897C4F3CDC331E1031E4DB89B8023D827AB2882C373EDC0DA570BB830159991891654310C95CDFC69C995DA8FE12156448C61A749A41', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('43bd1e19-b2e1-41ed-aa33-72389c353568', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user1@example.com', 'eInnFD', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'b1272eed-ea89-43ce-bcaa-2adc71ceec57', FALSE, TRUE, TRUE, TRUE, 'HHUQFpDd', BYTEA E'\\x63CDF5A193DD31E90FF1FC01F53C1480055D656E6C14094D28EABE741A03A3E726B354D038CE808C06E351572DA1B024CDF2F72B1F831A579F230BF4B032A9BC', '', BYTEA E'\\xD979D292750D6B17375F9C752ADCE41CAD11A5FD2304BD4F262553529EF1272FA738CC30D57134D6F6B65DA1211EE9F14E57D90E790C0968D81A9BF5F2803275ECF77EB8A097DA12B6825688FF49C6A2608F2CA02EE3BB1287E2DFA10A4E457DBA98199D1592846F59EE71527952562F6DB0D33CCABF29B254D63DE0653939F3', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('4460d7bb-7a3f-4efe-8ed8-1898663ab02f', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user10@example.com', 'PGzDkX', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'e984c875-7108-47dc-b011-88c9561f91f0', TRUE, FALSE, TRUE, TRUE, 'jaWRZgfM', BYTEA E'\\x54829611A91783610A733391C2332F3B238B36DE448951EEAEE896C03D39D430DDA72453E3FBB0A831A605D973C612E7A5F5BFD400B4355930A92FFE79A84E5E', '', BYTEA E'\\xCF17AD57B59A62C65F99F06C558514CA25A970E6A7DCFAE86B13B4FF718C40D463F9DD4327B8B691FB791308A012BFBD6117D239527EC23222DF74E1147751F69438DBEA0E2C10CF7783B42BC85E1110F3B2EA8A1DF877A5332319B662E1B40610D316FC5B271F128421D4531895FEA2DB1DE55AB44F9BE2A996032A68180730', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('46c42cdf-89a2-40de-ba90-c8b70a9448d9', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user39@example.com', 'YnNlbO', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'd7c17830-afbe-45eb-a853-4825e75e828c', FALSE, TRUE, TRUE, TRUE, 'DiVomEZU', BYTEA E'\\xD313716D00DF77D90DCD0BC1A1A09B7579C579486F6178A1FB0306618520E9840FE1B52236729F25B054911F924B253E885F48E56F33D06F81128AC92D8F31E0', '', BYTEA E'\\x5784BECDDCB4A84613462654D2ECDD68E01808563281D7DCAF512E894354ACF1EB0C24DE6C1191C36A0B88E5DB4AD718711A033D4FDE6CB76159CAAFE239FE95A2420CCEC504E843A60E91D4F9A34BE3A2262F8AD505C1796446D309CAAFDDFCFDC0A50437A2DF83CB3C21D4B1782359928668E34E022B6FCC04E2F6B837AE63', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('5029829f-5709-45e2-97bb-918e62aec7e0', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user27@example.com', 'WPsTWc', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'e86c8780-e568-4000-8351-09dfcb155466', TRUE, FALSE, TRUE, TRUE, 'TFLUZdOa', BYTEA E'\\x87D70131A2989C09D8058F280F7B235F34DE19DC6D66E4B1910257738FCD01F5E1A61E1FD95F507A70C19CEF824F52F1E0C4E005DDCC72B4FA1CE218B665C2F7', '', BYTEA E'\\x452740DC33EB98B89CBD061C49BC28E2FAD3CB12F2C2CC53834F6C0D819ACC550786CADCF4BB2B5C197ACD40E370FA3613BDA19A8FC883F8ADB50B63A913D18E0255A18B1E721623E87B1BFF47C754BA2CD18D85E35EBE128BAA86E6242C31A5F91C72E1D272137D902F1DBE68423DBA33F15B1270943344269E16C29691D555', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('53f2e5e6-370f-4242-bfe5-bb9f84551566', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user8@example.com', 'oOcaZL', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'a685d09a-49e5-4ee9-85ac-8d723e22d0a0', TRUE, FALSE, TRUE, TRUE, 'qJYDjuuM', BYTEA E'\\x42825BF6176EE8FB8BC8CF9D5B49078C87302644BFBDCD58A0B05AC7DFE0E42670930F9472D125E2E1036EBDA0F32BDC3823B65FBD3C66AA2D624E3629B29CF6', '', BYTEA E'\\xE0297C4B2B0DAC16278E532133097D7614DABE6A58E9AF88FA1004AE46D90E5D7719DB4E1A0DA5F2D311B7EFE27441D2C4D3C9A539B76C52127418B84F0B95DEB7B9C4E99C7ECA4B105878738E0B7E8C29DB8164A6FC587E614FD58AB4AB8C8640189D2CF301F7D229E343F7EB74BAB8DF6436B95075513FD0B942E0A19C54F2', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('58237089-bcee-4ae1-86e4-08358fbe2d09', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user20@example.com', 'bLevba', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'f874382d-ab6c-49b6-852b-8872c9977daa', TRUE, FALSE, TRUE, TRUE, 'PAmMZWUZ', BYTEA E'\\xDA9CED96BC0874BBDCACE009FF827516BEE6DCE508941846E9B838845155A8AF52D5B33099A9D40E0CA1669F04686CE3C4BFE7D7DF93C258332AC1AE751E1000', '', BYTEA E'\\x738B5E5342566C0C7F601F47D3E1FE57644CE111B58B2AD6543CE482CBB2B555021FCE84256B45DF9CE3D9DFB84BB21FA9E5F87DE148045FEBDE6C9103BCD7748DF2D666EB722C42222240F820C08693F86C66B552A23C63EC2CF54AF4023CDA3A243D9C822218565120A43446A5F3CB181D6DEAEFE33CB698B6ED63FCE428CE', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('5ed6cd35-bb0e-4b19-8743-400d3eca47e9', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user19@example.com', 'XHgSil', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '465442a0-c6ea-4ed0-b738-d0c24d68e244', FALSE, TRUE, TRUE, TRUE, 'wPehXBhU', BYTEA E'\\x6D007044B14B582184A0250D1DCF792F2FEF22C104BF8312B89F6448D95B344051432B64EE4AFB6A89E1DAA46E8E1992BC08B47375FBFDC548E40DC204ACD497', '', BYTEA E'\\x9B9953D515E00FDEB32E14CBAF9B483E82537C9B2C8C0FA23E5C99C9B698D24B775A47147714C1BC96DA8BBB0D9ED5D121FFC09CB80EE1BDAF1B85AA685116BEF185981FD9D233DEA96ECB9A915D2752D452F5DF52896C44EBF2EB6F1BA164B382FDACEAEFDF92AD821DB268C44808779273453BCFD22BDB6220C466E555E764', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('5f1f5980-c72e-4e1c-adbf-ca0a06e0bb68', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user35@example.com', 'vIIEqX', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'db6be08c-c217-4f02-b880-eaace9b78615', TRUE, TRUE, TRUE, TRUE, 'zyATeeuV', BYTEA E'\\x83F5255E5C8F5CF0FF8D33E74786B9D3FE572A2068F451CB9C85C4D5682F11C359F14634E262EB8DAFDE8A23726F5F60BE72EC279607CF91DE3849AC8C9B480F', '', BYTEA E'\\x87FD27D29A738BB9425AEDD024672E76116CE155577C64550495D95637C9DDEA8F57442263287FE479ED66718A49B4CC18C63BB88E6AA10D13FE7C095404DEE7B103B0344C4928321563A02362164A923A1FBF7F60132843A0604CD8B68E08995F0D52B00EAA8E722DC9920ECB5D79165FC95B9D36A54B5CCAB5FF089B1E653E', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('62e296a7-97ed-4b51-b470-fed15a8022f0', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user40@example.com', 'AtPbfz', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'bb5ed775-a3fc-4714-9ede-7312d224d669', TRUE, FALSE, TRUE, TRUE, 'NCvfBqmd', BYTEA E'\\xBB35439B4D507518E29D52EB3E79590BA3124EB4FAA8631BBBE625A3D56A8D15655D225255EE6E348E2D402660186132996CD0AD064C270D8AECA01FC4C93A22', '', BYTEA E'\\x162ED971F1637D8FC8C9A5D04D0BFCE3A9EC9B9A8150634108393EAC6D56F94753959BCC544D3EB118D4CF36342D2257AAC09FA992714289EA3E49D00EB2EABAB7F6D6FF23E85F88D07F5F0C289083401B9E1F105E6B4A59429B9B346EC954FFA74B6089ECDCDBC9AA2895452C761D64923E752D858E4AC21DFA045058EFC6DA', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('64d42629-f589-4275-88fc-1fd94e365607', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user14@example.com', 'AcPdAU', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'e9e96a58-7c74-48d0-b09d-280b5fb69e93', TRUE, FALSE, TRUE, TRUE, 'SFBErTun', BYTEA E'\\x7D32710EBC692B36C9A3407B317D3C71E4C897C398F66F8A1141DE189092247F86AEE7CDC6CD798D32425892BE1B1A1010BFF1A07CDEBC5129191B7DA730CA76', '', BYTEA E'\\x2A2563E32EC0A005B733A9649811693BC8184AF2ECC714F09DCC6414D5983ECE6C24E6DF6F6A493DD6872F58BC5D0746EE1ED96BF1C4C3C185764A8DB7451B13680FF60629D0A517F3F3473D1C65EF621C72E6838E69A6AAA07E03ACA83D986E089FD7BB362618298DAFB23404E02BD4496D6BD27D9D12F1D6583D9BE142CEA0', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('69eb82d2-b073-4358-8732-f102ae3bcc5e', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user37@example.com', 'HKFclg', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '3e954988-1fd4-44e4-b2d6-6a9958786fe0', TRUE, FALSE, TRUE, TRUE, 'uMFpfzgT', BYTEA E'\\x1290656A25B82868B48B1CAF4FC8BAC56882560B709B502481EB49FDF259DDDAD9A36B0A6A406DE81800AF4A20F83413D88447B51423F6BD1CBCB5786E4D6028', '', BYTEA E'\\xBCA0D32880609B8E7FAE0C5E50E40EC1369ED311E307FFF9CD11B1BD6A1BE8E0B8047E52FB2DE941117475895A0E87820F48C41E47B0377855355A705E8F09533D27691F610CB3AFFE007A2CE5F8FED7631D96389257FEE665DA14EB582F15B49888D349A735BCB5313D90116EB6FB342C270CDE361B2491F23C1FC22314F6BE', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('6d111e4b-bbb2-4228-9756-eb6c7bd70c6a', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user13@example.com', 'zQKmlH', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'ac63bd6b-ae08-46f0-907e-6a75bbb6e3bd', TRUE, FALSE, TRUE, TRUE, 'inHiacyc', BYTEA E'\\x54E602C93B6C1389A142455B86D8511E14496CD2EF02900AD61E3D503BAE283D81B2C8773DA73F3442CF604193DBA741CB728E5A2623DF48822A7E112EDC143C', '', BYTEA E'\\x8DCEA5588A36F4AB4E828AB01611F10D31E082904B0181417CFDC32FEA52DAF3404608C1099D68B4B204F289DB2DF243C32D66A2402EE03635A38B1F5EAEE7770F93965C93C4146316136F2DCC2A712C4BC10F73C943FDEA341D1DE14C4FF48BAA5D74178FF8329E1E7B9AB6BD14F445752083598AA340D98901A070726A847A', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('8346298d-56f7-489e-a3ef-b2d1f64304a5', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user15@example.com', 'Rbxram', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'bc6d3bdc-99a8-4192-9c29-b16faa5bca57', TRUE, FALSE, TRUE, TRUE, 'eqldnlVm', BYTEA E'\\x04EFE8EE1FF20833E01EB4D4A51B17080FAEBEACD6D0019CCAC420B3B4C7BD3ECF2DF890B3C43B5350BAF28DE8A780DB3D3934102763C09F19018DFD31EB7AEE', '', BYTEA E'\\x784BB6D7BD878A026F00609C439EE21945E65753E82F6D8B0F119E903C77BEB1D22AA86A3E971FAFD8FB71D0DC848B7E38708AE74C7523B452DA2CE1C963769EAA6D960E35145DB1BEE9950A5ACF3BE9F85248A5AA1FBBC87D604CBF0A6851D2E5CD6CD81D1046F7620F54C9E459ACF0A329BDE87D558DEB917E08AE5BAF0DAF', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('87d0113f-6dee-4a84-a517-6c6cd62b740e', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user7@example.com', 'ireDVC', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '62e817f4-823b-4195-a4c5-8fc935bf11a8', TRUE, FALSE, TRUE, TRUE, 'MUzmBSKw', BYTEA E'\\xAF2FE4345062AF02725D7AC4593CF319D1578609976BA969288E22DE870A6ABE7B12F6EB567B1A3D653FAF4B24BBD9824E9291D8756D4BC05E310E14D000E155', '', BYTEA E'\\x9E12A256C23872090A95A93DF3CD91BEB53FE5D9071B1B560CF394E20A0B8D31AFC88B5E977CB560DDFD919E6D250EA5849B788C1A802234D66E1F517ED312B387EBEDC351CAFA9D8332ED2E9A6A6F801BDDB4C6841C6F9B548ED5DE5BDB027D90449077291F2EA8109477690314579A23205321A8F3C880F63E8B0C3216B202', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('88dd3791-b862-4191-b414-1936a60c2736', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user34@example.com', 'piwJEz', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'c0e2cb0f-03b9-4937-822c-0c9366aee38d', TRUE, FALSE, TRUE, TRUE, 'wzqKSliA', BYTEA E'\\x96C89772898A5C0E9FA12778A1CB55977AB06B12C1ADCA2E098F04E1AD13069AA289E71295F6CCA969140A931F17A98A645C872C6473884274CCCD576A161ED0', '', BYTEA E'\\x9BD3A385F7C9889B20FB6C1FC3744FCC0A3C42A1B2886E1C3C5F6D7D702C683BF19BF5113F8298CB772F8EF5D67BEC34FF14A50370F4004B684F8CEB6E113FD25D176C3DCBDF3519D740F28A4EEBCD666BDCF327BAD10E26F846039D7B1866007F5B7CFC5D90CA7488D375DB07BD9E159E222C2A2A3A2B400AC805BB0696993C', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('8f7fd375-05a0-4fd4-a14a-c64dd03e8b22', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user26@example.com', 'IUUXxN', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '7264e080-8b97-448c-9b4c-80ada63c6fa6', FALSE, TRUE, TRUE, TRUE, 'ybuBdRiZ', BYTEA E'\\xC00339C8D239E0983C868CE9104C2F19C3C1DE21E39999B7F3CEE14CC3F76ADF241B4D69EB296A8F7F7605007550E7B0AD7C3881BF850F485914F9E3846AF6D2', '', BYTEA E'\\xC14E44424AF270F7EEE0FD66A9A04EFB7F2243BA0F70072A43B057172A9221D70BE63F0A854B50D2058626DADF331973B184CA19C6016ABD8EFC6EFAA5DC4AAEA75FB02F6E4D74EED93C44CAA224C8E8551C0FB66D6BC1FFBF8C38A219B1E66C39EDCF5CA653225419772633803B77A70E69F9A3089E479114FF4AE4138041DE', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('9469e471-a979-4a6b-bfeb-ee19837ba80f', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user16@example.com', 'dwoeWy', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '10e93aa9-cbee-438b-905c-afa017b36497', TRUE, FALSE, TRUE, TRUE, 'ZNTHKqTd', BYTEA E'\\x7BD08586584BCAAF8B12712C0FD0AC366DB2778C8C9AFEA6795875FFA0049676F39485C8D0FAB32B88092B3E42C06E22ACFDDB9BE3038839517165B6D3CCDDCC', '', BYTEA E'\\x666B1E38FDCB0091837EDA75A0E09442632B6B8D259E4EBC95077BB6194589BA75E55599082994338F75421F060E46761A7F0CD54EF4C1DC81583D708A5D74E6167BDB5D074DF36EE8FA6DAFB396EB11767CD47C74F02842C40C48B4047F2E2C6765CD20288853095AEAA407BF370CACB831539EC120DF2608CC7A991517093D', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('9ced880c-2005-4ac6-902f-95b14a5e43f7', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user29@example.com', 'HHmVVJ', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '4023ebd2-992c-49a0-bc14-d6a6ca5c710c', TRUE, TRUE, TRUE, TRUE, 'ZtZSvunM', BYTEA E'\\x3B29071C562C43E061E1509DCA9D72250CB7EC0A52FC5E6D9F6FBD84C3CB01C2D8CD594756E9491EB22F10EFF28F5A8B50D2B6F3A5C9EA5F421A71601E58A626', '', BYTEA E'\\x94E99623CE407225ED8287268F7551AEC89E4EA8306A4973C5B64DA7461AFDE2E0C47276A581F27A784D403D19FB6E74E86222245E055EE16000C66EF680F851D08C5EE4502744B3F9FC745DE7E5DDC75BF468FCF2AB94C20E3325FC6EBE5EE09F2DFCE8AD570554EC4592A65BA2B7E3BAB2DB48FAF8B2586D18216C4E49D0C7', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('b516c293-f72e-473c-9068-84c67eec12e0', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user23@example.com', 'bUUaXZ', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '7a6473f4-db63-49c9-955f-2d3d8d419106', TRUE, FALSE, TRUE, TRUE, 'SRuxVKzO', BYTEA E'\\x1AA9266694E5EF12BC0A9FC53DEA9B4F6945B45AE69CA964494F7D04A57D97907C28331B54714D01BB9B592D33D5AC6DC16A80A1B7302E580A494DB771F0AB99', '', BYTEA E'\\x14970D9EFF0C28386759BFE40425EC464DB0F560E6144E55CAD08B91E5C380B54CDF28054CF7421F05034DFC1A183B47AE6D486B1FB1712A1DE8A722CE1B15CA65D030AEBAD82519F0CA55E883846DFF2139B22C67F01C20FC05DABD50FEA3E3B07883C308E763BC5B97647ABB89DADD5C7391C1B8220C35C6BEE50CC2BDB6DD', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('b9172795-206c-45de-9d6c-d6efe3453804', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user4@example.com', 'tPtqjA', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '5a1ae1e4-e73e-411f-94e9-e71f9facf449', TRUE, FALSE, TRUE, TRUE, 'JBiaZbus', BYTEA E'\\xCFAE7E84C39C41B9A6DF00BD304DCC06543B9D8E6499445B7E8E9AE3A43334226F94B7AFAD8918B520196F0301A95AAD1AA0AD52000AF6EBFDD85DEF6975075E', '', BYTEA E'\\x8437C15156697D73A07BBFD13E24D36D70032D790ECE8E151077256AEB851B4CC897B53402E09EE6E1C0F166E4A4DA52E2D79D0B2169212CABD05F95A362E026281F60C0A8E4EE2D2A4CB55BB586B23DA27D6083075FFDBB75E9A509DD549E7DED4BCBE327F1BA8B60D4C7697519C32CD6CF8BD576A136A706E4695CA7D0FA77', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('c6fe2dea-7de9-459e-b9b9-f8730ff968b8', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user22@example.com', 'DAEEXc', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '9acfe6ce-1451-4b5c-ba2c-df00d957d903', TRUE, FALSE, TRUE, TRUE, 'pdkRrfeV', BYTEA E'\\x72E16EF06527FE56864A43DAD4751FD7295DC9BFDEEC95D401A9BADED68545E0BBA5D6A48F1D0EAF5E2E0BD7A0B278837F44E28B8B2EEB526C58BEB3C54CD54C', '', BYTEA E'\\x7D70ED339378330BEC6A423A643B4870F60FA2337760DDE569155D50DF455C212E99BFDC0B19C639BA0293255D274BBAC59DF8AF44E4E6713F007471B917750D65C0BC85DD00526F3425568FFA50360735BDBAF4E707038D8C4FCDCF4AC37116DBC295E18465CFE51373FB60E61A7155AAAF041B7F69626AAD57B2A4374748E8', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('c98fd898-7c24-4e89-9c52-938368e78b89', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user36@example.com', 'kpBRzC', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '68739bd0-e965-4f9a-ab2c-bc8c4d59f748', TRUE, FALSE, TRUE, TRUE, 'GfSJlKQQ', BYTEA E'\\x117C6CC28CCB6C408DD3682E2AEC5174FA79FCBD477DA900E7E6F4B4EBE421E09DBB7FCD51B47348EE71143ADD0E4754C3DC1EF84D23A5DDC1ADE79137EC56C1', '', BYTEA E'\\x7EDB580B1B0630C3E0EFE719CD2EEC287AB111282035C0F331CD1AFC0F93DC1BF3AA4EC3195C16940BE55E32B3B5FFD3501A098479D598465E4FAACAE7A1DD764A11F46F2BD534DF2284F34ED5B06B35829F5DB2ADCEB8A9FDE0E3448ED9A69780593EE31DDADB173126E9C3CC272CB49D498044128148BECEB61E647242AE3C', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('cba8404a-ec60-454a-b1c0-f62c582f90be', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user12@example.com', 'MmoAZV', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '457ae4a0-8488-47de-8b2a-8f0667971741', TRUE, FALSE, TRUE, TRUE, 'mpoVngng', BYTEA E'\\xC4D66F4747E3C4720DA30E1ABE999A63099B3EAF23993F4CDB89BEC09A733BA2655E1666D9E8883E5E358231B0876B83B09E910F32FC1298728049C460C71244', '', BYTEA E'\\x708ECE99A7DB600AAA4D06DDB76BC2C6B667277EEA5478DD7A18F9D720ECC6F3F434A438C011439C4228EBF4F1A03E54F5494C216E2EF103E29DCE9AD74164A4CED6C959E6F68E232E4AC98237A3AD7A7721BC9BE72FDAF5CE9EAF5F657507D2C74819C6165C2ADE12E4BFE95B23A1A7D496DA40E9DF3BC72EB79D3273085108', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('ce71afda-a3b6-436f-8a6d-a0d02ef58d07', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user28@example.com', 'DRzmZn', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '49620d4f-3e1d-4c64-9ebd-9625a3ef18ed', TRUE, FALSE, TRUE, TRUE, 'sAjZQcfR', BYTEA E'\\xDFC59FA5402FE321CFDB97092EC62618F848D8D73B577F30DC2F3A086F0DD1D2CFDAA3C7C6A8D47357927997225A3A5A2A08275839CDF90F49A9BE27BAEFEFC3', '', BYTEA E'\\x0508CF853904415F5C564B0DC1F8A7082D18D557E369842AAE9DE663BCF8AF713BF61F5BA8A714554C82E73FB2843164B0D420C1CB150E27B2A59B14E6867FBF39927997AF40179267A4DE3BC3A1B5A73D502DF5E753B7D68EF0E8CCF0E86A179BBB97A9C5C24D3BF05DA824C37820A025CBB9A4F03F4B645A457F7E33A519FE', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('cf7f3bb0-c592-4b96-af10-9448952f438a', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user11@example.com', 'VjnUkD', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '5cbdc5f2-e53f-4c90-aae6-0c933888b0ec', TRUE, FALSE, TRUE, TRUE, 'EqytJUTN', BYTEA E'\\x09D89DDE49FB6530A00EA4909C0857C742B11A9F651AFBAD88E8D59AC426819FDC103595C3C2B19743F32A23CD1D9AB6CC9F506B7669CD7B9EB4EB6CBB99D212', '', BYTEA E'\\x84AB24428756A9BEF6F4A802ACF39C3FEF4E9DE889D1D5D28184404143A69587F7813F21477CAF7BC521B08985E8C97C95527F3E966CF2B7EEDB10D0CB7059F6173E892794D1AF01CA929A725FB29E3794C6F86CFD47A80D359F1545C62AC674F876574DDB812115819EE47DF19F2720A3493D7940BE034C28EF4116B6E59648', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('d11106e4-0993-4be1-8056-1f3c17c165d9', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user31@example.com', 'eNvcbE', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '9961ba83-e4da-4359-834b-2a84f236f645', TRUE, FALSE, TRUE, TRUE, 'pPDGphWx', BYTEA E'\\xFABB4C5B20BA93C0A37571E3BFB3549F344DB04AAB36E850586F8BD0AA4F57492DE9C875147C0C5BE78F1085D83CEBD86389A62EACE67E6FB7BE37686C42AC90', '', BYTEA E'\\xD3C4B99AE8BA6CF42D5AA1D09E2FD768DE490DBF514466F76070D9A7F8BA519C038A3EF6DF969BE1B6B915F52644D8E99EB06D86E0B21BDDC78E3C9D2E2AC836A9F3600FE018C9F44B6389A6274A9473D10DD83713ECAF081ACF16B74A4E0A47D49689F017132CC929419E9B3D2BEAFDFCBE47B8B137321E63D80EA1F284757C', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('d23aaa6d-8ae4-4929-89df-aff436d6d4ad', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user25@example.com', 'MQMnMU', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '7169c5a3-ac79-458b-b2c2-d71234b9e00b', TRUE, TRUE, TRUE, TRUE, 'TtXGLfWw', BYTEA E'\\xAFABF155906BEE7E79E4B2D7771760F85DC375C370373BE6D712BAA815C21644C621E0F610B2123F5543B7B0BF786434AE0E00A79CF593DF2A6862400ABB1FCE', '', BYTEA E'\\x569737A7CA6AFD312D21A6B4918DB4A3B6916C718D3921B41617A8310CCA5097C881D86F50C4F8EF357303D1485DBE5BE46185C775E39ABAF242EC072935FB1AA4D8E4558AE0A900B2DC1265B7082508E7C339D84C076B8AEBB97AD62D8872A00D4E7B6FE5F87AB92B5FB96CB62FC540C0BEA93B0163757A6521E174BAC6878F', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('d8f94cd4-b7fe-4aa9-ae62-9c6c84a09a04', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user5@example.com', 'uMFYsd', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'f74b0161-2699-4acd-a5c8-c98c657de8f9', TRUE, FALSE, TRUE, TRUE, 'AhryrAOa', BYTEA E'\\x48B82A4239410936873AC725919C9958F44403F4B3403629D8A0AB139338F2331D01FB4C6EBB23F7BAB53AF02F10A4CD1C9A0BA8938FD99D643A0A6603550155', '', BYTEA E'\\x4E39966D378FA26700BE52839271F3C4F573378D90F58AA9C0535A42BF6E5B26F83BA7BEC905F22E00FA843E3EC0E50D9F33088379E132160FAA52C2245CAE7EEE0061D0870CB3B860BF5EF9A5190E855B887FC8CFDF55A1967771108B6CFD2C0A58A14E61DF61EBB7316F5F0FED4368895C757CFA0FF9912966F30EA5A220C5', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('dc0015d4-40c8-4df1-bc98-732d9578052c', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user32@example.com', 'egEoMs', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '8dcdec00-e10e-4f9a-84bf-b32d51b07875', TRUE, FALSE, TRUE, TRUE, 'gcnLhiFG', BYTEA E'\\xDE1462C0F15A1CCDAEC927F8242B24BBAC474491BE1F75BF9D54D6CE5359D97129CF7A5337AF2A4C1EA7225EB07073023F1F575E805A7E1374B33AB224FE80F9', '', BYTEA E'\\x0B47D844548D9734EA9714418DCFE7F5AFE437B8D747B4297ED71E2F7917827FF322E99122B91B83DB5BB1C6AC62D2043D4369C2218DD674767BE513BCAEB0FF4ED6B9225A2EA58E0A9941E43784F7B6473820E3F97D3D13E51ABFE690C3F14C023F55227C0171106B463F55B5862DC2AEB524295305E0BD47942446C597AF89', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('dcff9331-5516-43f0-b1dc-bfb4aeaf58fb', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user21@example.com', 'yKvDDD', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'f3e2ac2d-037b-4079-a8a1-64e9a61851e3', TRUE, FALSE, TRUE, TRUE, 'oVOYpCrY', BYTEA E'\\xFE715AC67F203010BC5A6CB9435A8A15BD2FFB46F1D2F95C466F010CDD3E3CFD1CEC4FAB4B2D24FDE9EEA9EAF0DB3674B006864F198915117DD57E50942A9A25', '', BYTEA E'\\x37E1B9820656D1BD0DD6B45036FF4F09B24C72B0B74772280E3988FE0464333B2B49ED303E857A8D7D1088441333E1EA9D32AA0239FF0C4084C5378E550FC6288E476956E03693D5AE2565585ECF56EE7F71007CFA7E2CFF1040A452189883D67D9D507104AE0D4A77922D1D7D6D5EA689404EF4911728A147DBADAE875A63AE', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('dd8e49dc-375e-4c92-b300-8c1379268859', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user6@example.com', 'QXeDAx', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '03a0ca7a-0f44-4352-bdf0-8d16df97fe23', TRUE, TRUE, TRUE, TRUE, 'YOGJbwOW', BYTEA E'\\xB97DDC03E2C513231F33F2F6C0E9D3248B59C24233D98E4C365BF0D8B7C009BD35950F83474752A453428B8572507C60DC2AF794C37527912903C3590D67EA5E', '', BYTEA E'\\x0F7C17E73EF6CBBEA559EF21D5A9BA19D1705ACEAA3CB36E5ECAFDEED6510571C1ADD3260600DEA49AF7118BE6336299B565D4C7E9AEC10E3ACB1B75FC683475ECDB19570C8E187C926CCFBCF14DE95EC8C126388CE916853FFF65CFAB5E7DA0D35E5EEA7444D1508BA25009B6E8295A316648B0393AF4C28C55260A619E14AD', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('df8c916d-91eb-4617-86ac-3cd0f2f19d9c', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user33@example.com', 'yIVOKf', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '3bbd73e0-caae-421f-93fe-06c800417bbb', TRUE, FALSE, TRUE, TRUE, 'yQmUemWl', BYTEA E'\\x2F5D506DD6AAB36CFBE5422F1489ED8A048E830539A1197D9FE48FE3FD232EC80B5E5CE37F27D8FF62FD2EE501F738177B484F5A63185C486CAFD36B06A62BCA', '', BYTEA E'\\xEF4264AFAFB260065C9AF6BF98C76231D575F71222EDD15749594D6EF76B42CE3EEC5B03F1EA2C1779ED961E26EB137347E51735B5A76F69EEF6383BD1992AD5592D4D9F91081C8206A896726EBCFBBFC3F7E96FB8323C77B695ECF80541A84A4540251A3C854F74A2B48F09D86C47C5B2568E847817203C44CE21D1B5DDC4E4', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('e942f859-b646-46ed-a815-ce9a1efa24ca', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user38@example.com', 'aZoRog', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'df5bed6a-1fbe-4deb-877a-b1a8141ba729', FALSE, TRUE, TRUE, TRUE, 'WMOqqkDu', BYTEA E'\\xC8B3E804889B58FC575BA01BA2C1FCA2126055A00A87BA30D380199CA0B76C3FF3EC169E8C2B73D809473A382086C5900252FDA99897185A27692C119D3217A6', '', BYTEA E'\\x45086DCC074BF733259CD5995E0B4FF1D31E354D5C324E448D4DCBDB43A8C36297B0FDBB2EC3F159E16CF5219AADE529D737097E450AC01D98BC860A37279E24D0C5726416587683DBE919D9A036D1DB3843BD34DA29DB5095749BE96F54C13610D1382990B7222C9D5E7B5FFC5ECF63E9D155EC0C7477600E24D2126D86E847', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('ee539cc3-aeb2-4678-a93b-070e4a0513de', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user17@example.com', 'XiRqqe', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', 'd1953cb8-0197-41b2-bcac-8c3b64aa2622', FALSE, TRUE, TRUE, TRUE, 'OkMwtGzN', BYTEA E'\\x9D71EFFE6583BAB954800B344E0FA185706545C496F3936B0603A074054824BAC8DB1F8615D42A76A00695C0BDD8D3B0B9F46C450B9109C1A9048469B033CFB9', '', BYTEA E'\\x0D191E94E83FE299697B826D58D4801A8FC53334F884D404C8459D1A931050CA790532B87171BC65824A5645B11172AD32E0F9DED29A0B3AD798D6688CA7306C0C781385C2138E8E4401179A037CE10B3B208CFC5D69D4623FA4D685AFB9074798144E4B6564396D5F73301263BC3FF8EE3CEAF40AB60453B9B148B02FB10F95', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('f2824989-11ef-46e8-a589-dcddc46b16e8', '', '4d50204c-0fa1-40d2-afa3-2c7bca7b62d3', '6ead4fb4-7204-4e3a-820c-2933e3f48d9f', NULL, '', 'user9@example.com', 'GSzYpS', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '89cc7fe8-9d21-4de5-b105-7f43d59f2910', TRUE, FALSE, TRUE, TRUE, 'nDWIcRVO', BYTEA E'\\x750D23C39E1A7045AD59AB1D29D64462F618577AA6182EE7466585BA70A62C90D3ADA28D3617407F75BA3BA2DB64F051677E00D90AD8B4266ED9A3DCED12B09D', '', BYTEA E'\\xBC0D378F4831CD6E1C280D753C94B37BEDBC2E3EF0A7C1C5C17E3342F26DD27F59B40C54C4B867F68370BBD9E83E76AB6D49F75C023FB7AC3A93D2A69B75554005B0E46A3EBA71470C587C49A1E4E2185B3DEBB1216AA67527C72AD8A8BFC6D7EE1479C4FFB910D3EE063D2D51E0D07E75F184F98DE5217B7D5CA5937AA19AC1', '', NULL);
INSERT INTO "Users" ("UserId", "BannerImageUrl", "CityId", "CountryId", "DeletedAt", "Description", "Email", "FirstName", "ImageUrl", "InstitutionId", "IsATeacher", "IsAnExpert", "IsCreatedAccount", "IsVerified", "LastName", "PasswordHash", "PasswordResetCode", "PasswordSalt", "VerificationCode", "VerifiedAt")
VALUES ('f4db019a-56aa-4097-905c-c6dc818b53b8', '', '9d0bb36f-017e-4454-a00a-36a6ba9413e1', 'fb6560eb-c7c4-483f-9dfe-fe5dc381e5b8', NULL, '', 'user3@example.com', 'sOwCcR', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/Female-Teacher.png', '532ff952-4707-48eb-bebd-e99f2824bde9', TRUE, FALSE, TRUE, TRUE, 'GchvibRW', BYTEA E'\\x19381FB0189EB04DCEFB8C822AB801F715C3964F1F2D35164FECC2DBBA8CDE0F869A91B8AED597226031565A46954EEDAEC73FC197EE432B526BBB119A057A0C', '', BYTEA E'\\x85E1A0598AEA54D6A55CFCE09E14F04430E0F15D9833D7CCE89B9216BD6CCA7243AB78B302D1A3A787660E4D32DBB1B04C993BE0E7B118ED9DCAEA579A8F1C9D8F1827620A89D9C2670DBF8CB6F7A5404687A69B03B46B83CA3CBB66AD7E479CB93A59D19C6B6ED5BD1D389F4E1D688C91A05CE51092BC8383AA4B3A8D6178DC', '', NULL);

INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('02dceed7-64de-48fe-8e2f-e267b6390a60', '81f2d6b7-55a6-455c-b4cf-64809d8387bc', '9ccb966b-867f-4c77-84a1-5a85b20e3fb2', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of oOcaZL', '53f2e5e6-370f-4242-bfe5-bb9f84551566');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('06756903-314e-4a10-8166-8706abf43b34', '6eb07f2e-6178-4b0b-9628-84772c6beee4', '92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of WPsTWc', '5029829f-5709-45e2-97bb-918e62aec7e0');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('06cfe889-2ca1-446b-ab45-b7b21577ad4e', '81f2d6b7-55a6-455c-b4cf-64809d8387bc', '92c73250-790f-4ec4-872e-9d3a66c06414', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of QXeDAx', 'dd8e49dc-375e-4c92-b300-8c1379268859');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('0c5aa6f1-47a3-49b2-8b3e-011819fa515f', '76d0222d-f73c-49fa-b5a0-4be2796ec471', 'db61f833-bd64-439d-ad5b-d2f37b8beeff', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of piwJEz', '88dd3791-b862-4191-b414-1936a60c2736');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('0d9bed28-e21d-425f-b570-2207e847ea82', '995cb81a-ec3b-4617-a35e-17892de5f49b', 'db61f833-bd64-439d-ad5b-d2f37b8beeff', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of XHgSil', '5ed6cd35-bb0e-4b19-8743-400d3eca47e9');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('211f4760-9287-4b90-9a89-09cf279f8bfc', '7efacd8a-acef-4392-a525-206868b48318', '170ef561-249a-4399-a0cf-b32b002bfcd1', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of gFimeA', '221c3b60-2d38-480f-9434-65489bafd990');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('2568258e-6243-495b-b033-bfe0d95d6834', '8e1d151a-f51a-47b4-ba74-32a2b3397c58', '92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of xnyYaX', '1ca9a342-8a19-44fc-add3-d86fd5dc03c8');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('2cb9094a-5259-4e88-a9c2-98414b90cd01', 'dabd5b72-7d42-451f-8bac-fe8a5ef8da3c', 'd50cf999-46a9-467e-b77b-6ad6b4e67416', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of HKFclg', '69eb82d2-b073-4358-8732-f102ae3bcc5e');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('3ee4ef39-6b7f-41c7-9eba-2ac3add2c8a1', '2096cd80-4c8d-4cc6-83dc-fd831de3e680', '90a467cb-6ad1-44c4-9a59-30b8a05b0f7d', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of yIVOKf', 'df8c916d-91eb-4617-86ac-3cd0f2f19d9c');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('41f7e3b9-783d-4306-9946-898d3973976d', 'f6e68e98-f1e1-4fd8-b245-b6552d62e516', '3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of hHbKmB', '213947a9-6ba6-4d30-b3fc-be0709ae44f0');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('576a092e-f0ba-4382-86f9-98db7da3e3c0', 'f6e68e98-f1e1-4fd8-b245-b6552d62e516', '92c73250-790f-4ec4-872e-9d3a66c06414', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of MQMnMU', 'd23aaa6d-8ae4-4929-89df-aff436d6d4ad');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('5ff68b32-b507-4657-bab1-ce19401229bc', '1885a957-adb8-4350-8653-1882cea4d876', 'b002b544-99e2-475c-a26d-ee13f9f73239', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of AcPdAU', '64d42629-f589-4275-88fc-1fd94e365607');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('6982f732-83bb-4fe5-951c-6b65def5da35', '995cb81a-ec3b-4617-a35e-17892de5f49b', 'b002b544-99e2-475c-a26d-ee13f9f73239', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of zQKmlH', '6d111e4b-bbb2-4228-9756-eb6c7bd70c6a');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('71860a30-5091-4243-9068-c84d70c2d2a5', 'bc85dc99-5e18-4659-93a7-f75ae4ff3418', '3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of egEoMs', 'dc0015d4-40c8-4df1-bc98-732d9578052c');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('780d250b-1d89-46ab-9531-0ee48201aa61', '2096cd80-4c8d-4cc6-83dc-fd831de3e680', '9ccb966b-867f-4c77-84a1-5a85b20e3fb2', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of vIIEqX', '5f1f5980-c72e-4e1c-adbf-ca0a06e0bb68');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('7b7e0d84-3e51-48ca-a6d8-496ea1588aba', '80f5db8c-5cad-49bd-8a7e-0258c43cabd2', '92c73250-790f-4ec4-872e-9d3a66c06414', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of dwoeWy', '9469e471-a979-4a6b-bfeb-ee19837ba80f');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('7d11ade3-f988-4fbe-9b0e-822d721cfcf1', 'bc85dc99-5e18-4659-93a7-f75ae4ff3418', '3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of MmoAZV', 'cba8404a-ec60-454a-b1c0-f62c582f90be');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('8644fb15-2368-4656-a2ff-24fda8ad77d3', '8e1d151a-f51a-47b4-ba74-32a2b3397c58', '3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of eInnFD', '43bd1e19-b2e1-41ed-aa33-72389c353568');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('905854a9-e36d-4f3c-8db5-a7f80ce0440b', 'cad17c1c-2757-4de3-8ca6-72171b142e53', '72b2af8a-037a-4dbc-9885-64e0f5a3da3b', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of ireDVC', '87d0113f-6dee-4a84-a517-6c6cd62b740e');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('9b6fb937-a61e-4114-9492-c48f4a932c7d', '2096cd80-4c8d-4cc6-83dc-fd831de3e680', '9064f323-8254-4181-80c8-fd79f24d76a5', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of XiRqqe', 'ee539cc3-aeb2-4678-a93b-070e4a0513de');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('abf9f4c0-7b81-416c-9111-10ead1ac0a44', 'bc85dc99-5e18-4659-93a7-f75ae4ff3418', 'b002b544-99e2-475c-a26d-ee13f9f73239', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of IUUXxN', '8f7fd375-05a0-4fd4-a14a-c64dd03e8b22');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('b1abebc4-706f-49f7-a4d5-60ec976135c7', '8e1d151a-f51a-47b4-ba74-32a2b3397c58', 'b002b544-99e2-475c-a26d-ee13f9f73239', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of yKvDDD', 'dcff9331-5516-43f0-b1dc-bfb4aeaf58fb');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('b5c15d81-5216-4dc3-baff-b20bb647fdc1', '646c491d-e4dc-4378-b3a7-70f69410f888', '92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of YnNlbO', '46c42cdf-89a2-40de-ba90-c8b70a9448d9');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('bff587df-179a-4f8c-9b75-8de721d0a756', '6eb07f2e-6178-4b0b-9628-84772c6beee4', '72b2af8a-037a-4dbc-9885-64e0f5a3da3b', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of bUUaXZ', 'b516c293-f72e-473c-9068-84c67eec12e0');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('c23d5906-3263-4115-9134-2bfccf81a315', '76d0222d-f73c-49fa-b5a0-4be2796ec471', 'd50cf999-46a9-467e-b77b-6ad6b4e67416', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of Rbxram', '8346298d-56f7-489e-a3ef-b2d1f64304a5');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('c3befa37-332d-4763-969b-fa614f45f282', '646c491d-e4dc-4378-b3a7-70f69410f888', '170ef561-249a-4399-a0cf-b32b002bfcd1', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of uMFYsd', 'd8f94cd4-b7fe-4aa9-ae62-9c6c84a09a04');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('c859c488-249d-48f9-b5e6-99264a1f6c09', '6eb07f2e-6178-4b0b-9628-84772c6beee4', '92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of DAEEXc', 'c6fe2dea-7de9-459e-b9b9-f8730ff968b8');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('cb8a2a41-34c2-4eee-9539-db99b6cc0bc1', '94c2051e-02ac-4488-b483-6dfe68f74bda', 'b002b544-99e2-475c-a26d-ee13f9f73239', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of AtPbfz', '62e296a7-97ed-4b51-b470-fed15a8022f0');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('cf8ed7b2-d3f5-44ce-bd6c-dc9ae7fd55cd', '56656709-bd6d-49b1-a603-aa25e2be0067', '72b2af8a-037a-4dbc-9885-64e0f5a3da3b', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of eNvcbE', 'd11106e4-0993-4be1-8056-1f3c17c165d9');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('d473c1b0-ac7a-4b40-9f04-89dc4c0b8a70', '6eb07f2e-6178-4b0b-9628-84772c6beee4', 'b002b544-99e2-475c-a26d-ee13f9f73239', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of VjnUkD', 'cf7f3bb0-c592-4b96-af10-9448952f438a');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('d75ed578-009f-4440-a41f-d4a40948e135', '65784bac-4b3f-4c91-ac76-9bd5ea10a976', '92c73250-790f-4ec4-872e-9d3a66c06414', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of aZoRog', 'e942f859-b646-46ed-a815-ce9a1efa24ca');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('dcce1eef-47ba-4ead-ad6a-8e3b578154e4', 'e4f89ee6-d64f-45ed-8d82-a544595168e8', '170ef561-249a-4399-a0cf-b32b002bfcd1', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of bLevba', '58237089-bcee-4ae1-86e4-08358fbe2d09');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('dfc595a5-e88f-420d-b2c7-0bbe5baf8d04', '1b2c7f47-0507-4dab-8044-1984e1808dea', '92c73250-790f-4ec4-872e-9d3a66c06414', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of sOwCcR', 'f4db019a-56aa-4097-905c-c6dc818b53b8');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('e050120c-3e14-4be0-9361-ef9103753be1', 'e4f89ee6-d64f-45ed-8d82-a544595168e8', '92c73250-790f-4ec4-872e-9d3a66c06414', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of kpBRzC', 'c98fd898-7c24-4e89-9c52-938368e78b89');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('e324f9ec-738c-48e1-b5e7-4b18e2eec819', '65784bac-4b3f-4c91-ac76-9bd5ea10a976', '3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of GSzYpS', 'f2824989-11ef-46e8-a589-dcddc46b16e8');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('e98eaa42-75ef-482c-a197-74c4879a5c2e', 'bc85dc99-5e18-4659-93a7-f75ae4ff3418', '9ccb966b-867f-4c77-84a1-5a85b20e3fb2', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of PGzDkX', '4460d7bb-7a3f-4efe-8ed8-1898663ab02f');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('ed37dfd7-0080-4d28-9563-a0d35726f195', 'bc85dc99-5e18-4659-93a7-f75ae4ff3418', '72b2af8a-037a-4dbc-9885-64e0f5a3da3b', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of nmrMge', '12400cfe-40ce-40d9-bd1f-fcd3b304b844');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('f5f8da37-ee70-4674-85b2-c22c8386e625', 'f6e68e98-f1e1-4fd8-b245-b6552d62e516', 'b002b544-99e2-475c-a26d-ee13f9f73239', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of HHmVVJ', '9ced880c-2005-4ac6-902f-95b14a5e43f7');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('fa94019f-5bd5-43c3-9817-93bb4970f03a', '646c491d-e4dc-4378-b3a7-70f69410f888', 'db61f833-bd64-439d-ad5b-d2f37b8beeff', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of DRzmZn', 'ce71afda-a3b6-436f-8a6d-a0d02ef58d07');
INSERT INTO "Classes" ("ClassId", "DisciplineId", "GradeId", "ImageUrl", "Title", "UserId")
VALUES ('fe58ed9b-944c-42cb-a9b9-f55b8aa17a97', '6eb07f2e-6178-4b0b-9628-84772c6beee4', 'db61f833-bd64-439d-ad5b-d2f37b8beeff', 'https://s3.eu-north-1.amazonaws.com/hiclass.images/default/default-class.jpg', 'Class of tPtqjA', 'b9172795-206c-45de-9d6c-d6efe3453804');

INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('bc85dc99-5e18-4659-93a7-f75ae4ff3418', '12400cfe-40ce-40d9-bd1f-fcd3b304b844');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('8e1d151a-f51a-47b4-ba74-32a2b3397c58', '1ca9a342-8a19-44fc-add3-d86fd5dc03c8');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('f6e68e98-f1e1-4fd8-b245-b6552d62e516', '213947a9-6ba6-4d30-b3fc-be0709ae44f0');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('7efacd8a-acef-4392-a525-206868b48318', '221c3b60-2d38-480f-9434-65489bafd990');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('8e1d151a-f51a-47b4-ba74-32a2b3397c58', '43bd1e19-b2e1-41ed-aa33-72389c353568');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('bc85dc99-5e18-4659-93a7-f75ae4ff3418', '4460d7bb-7a3f-4efe-8ed8-1898663ab02f');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('646c491d-e4dc-4378-b3a7-70f69410f888', '46c42cdf-89a2-40de-ba90-c8b70a9448d9');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('6eb07f2e-6178-4b0b-9628-84772c6beee4', '5029829f-5709-45e2-97bb-918e62aec7e0');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('81f2d6b7-55a6-455c-b4cf-64809d8387bc', '53f2e5e6-370f-4242-bfe5-bb9f84551566');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('e4f89ee6-d64f-45ed-8d82-a544595168e8', '58237089-bcee-4ae1-86e4-08358fbe2d09');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('995cb81a-ec3b-4617-a35e-17892de5f49b', '5ed6cd35-bb0e-4b19-8743-400d3eca47e9');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('2096cd80-4c8d-4cc6-83dc-fd831de3e680', '5f1f5980-c72e-4e1c-adbf-ca0a06e0bb68');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('94c2051e-02ac-4488-b483-6dfe68f74bda', '62e296a7-97ed-4b51-b470-fed15a8022f0');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('1885a957-adb8-4350-8653-1882cea4d876', '64d42629-f589-4275-88fc-1fd94e365607');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('dabd5b72-7d42-451f-8bac-fe8a5ef8da3c', '69eb82d2-b073-4358-8732-f102ae3bcc5e');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('995cb81a-ec3b-4617-a35e-17892de5f49b', '6d111e4b-bbb2-4228-9756-eb6c7bd70c6a');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('76d0222d-f73c-49fa-b5a0-4be2796ec471', '8346298d-56f7-489e-a3ef-b2d1f64304a5');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('cad17c1c-2757-4de3-8ca6-72171b142e53', '87d0113f-6dee-4a84-a517-6c6cd62b740e');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('76d0222d-f73c-49fa-b5a0-4be2796ec471', '88dd3791-b862-4191-b414-1936a60c2736');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('bc85dc99-5e18-4659-93a7-f75ae4ff3418', '8f7fd375-05a0-4fd4-a14a-c64dd03e8b22');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('80f5db8c-5cad-49bd-8a7e-0258c43cabd2', '9469e471-a979-4a6b-bfeb-ee19837ba80f');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('f6e68e98-f1e1-4fd8-b245-b6552d62e516', '9ced880c-2005-4ac6-902f-95b14a5e43f7');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('6eb07f2e-6178-4b0b-9628-84772c6beee4', 'b516c293-f72e-473c-9068-84c67eec12e0');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('6eb07f2e-6178-4b0b-9628-84772c6beee4', 'b9172795-206c-45de-9d6c-d6efe3453804');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('6eb07f2e-6178-4b0b-9628-84772c6beee4', 'c6fe2dea-7de9-459e-b9b9-f8730ff968b8');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('e4f89ee6-d64f-45ed-8d82-a544595168e8', 'c98fd898-7c24-4e89-9c52-938368e78b89');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('bc85dc99-5e18-4659-93a7-f75ae4ff3418', 'cba8404a-ec60-454a-b1c0-f62c582f90be');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('646c491d-e4dc-4378-b3a7-70f69410f888', 'ce71afda-a3b6-436f-8a6d-a0d02ef58d07');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('6eb07f2e-6178-4b0b-9628-84772c6beee4', 'cf7f3bb0-c592-4b96-af10-9448952f438a');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('56656709-bd6d-49b1-a603-aa25e2be0067', 'd11106e4-0993-4be1-8056-1f3c17c165d9');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('f6e68e98-f1e1-4fd8-b245-b6552d62e516', 'd23aaa6d-8ae4-4929-89df-aff436d6d4ad');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('646c491d-e4dc-4378-b3a7-70f69410f888', 'd8f94cd4-b7fe-4aa9-ae62-9c6c84a09a04');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('bc85dc99-5e18-4659-93a7-f75ae4ff3418', 'dc0015d4-40c8-4df1-bc98-732d9578052c');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('8e1d151a-f51a-47b4-ba74-32a2b3397c58', 'dcff9331-5516-43f0-b1dc-bfb4aeaf58fb');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('81f2d6b7-55a6-455c-b4cf-64809d8387bc', 'dd8e49dc-375e-4c92-b300-8c1379268859');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('2096cd80-4c8d-4cc6-83dc-fd831de3e680', 'df8c916d-91eb-4617-86ac-3cd0f2f19d9c');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('65784bac-4b3f-4c91-ac76-9bd5ea10a976', 'e942f859-b646-46ed-a815-ce9a1efa24ca');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('2096cd80-4c8d-4cc6-83dc-fd831de3e680', 'ee539cc3-aeb2-4678-a93b-070e4a0513de');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('65784bac-4b3f-4c91-ac76-9bd5ea10a976', 'f2824989-11ef-46e8-a589-dcddc46b16e8');
INSERT INTO "UserDisciplines" ("DisciplineId", "UserId")
VALUES ('1b2c7f47-0507-4dab-8044-1984e1808dea', 'f4db019a-56aa-4097-905c-c6dc818b53b8');

INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('72b2af8a-037a-4dbc-9885-64e0f5a3da3b', '12400cfe-40ce-40d9-bd1f-fcd3b304b844');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', '1ca9a342-8a19-44fc-add3-d86fd5dc03c8');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('3ed67139-d83e-453a-a3d1-61cfa5e34eb3', '213947a9-6ba6-4d30-b3fc-be0709ae44f0');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('170ef561-249a-4399-a0cf-b32b002bfcd1', '221c3b60-2d38-480f-9434-65489bafd990');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('3ed67139-d83e-453a-a3d1-61cfa5e34eb3', '43bd1e19-b2e1-41ed-aa33-72389c353568');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('9ccb966b-867f-4c77-84a1-5a85b20e3fb2', '4460d7bb-7a3f-4efe-8ed8-1898663ab02f');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', '46c42cdf-89a2-40de-ba90-c8b70a9448d9');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', '5029829f-5709-45e2-97bb-918e62aec7e0');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('9ccb966b-867f-4c77-84a1-5a85b20e3fb2', '53f2e5e6-370f-4242-bfe5-bb9f84551566');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('170ef561-249a-4399-a0cf-b32b002bfcd1', '58237089-bcee-4ae1-86e4-08358fbe2d09');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('db61f833-bd64-439d-ad5b-d2f37b8beeff', '5ed6cd35-bb0e-4b19-8743-400d3eca47e9');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('9ccb966b-867f-4c77-84a1-5a85b20e3fb2', '5f1f5980-c72e-4e1c-adbf-ca0a06e0bb68');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', '62e296a7-97ed-4b51-b470-fed15a8022f0');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', '64d42629-f589-4275-88fc-1fd94e365607');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('d50cf999-46a9-467e-b77b-6ad6b4e67416', '69eb82d2-b073-4358-8732-f102ae3bcc5e');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', '6d111e4b-bbb2-4228-9756-eb6c7bd70c6a');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('d50cf999-46a9-467e-b77b-6ad6b4e67416', '8346298d-56f7-489e-a3ef-b2d1f64304a5');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('72b2af8a-037a-4dbc-9885-64e0f5a3da3b', '87d0113f-6dee-4a84-a517-6c6cd62b740e');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('db61f833-bd64-439d-ad5b-d2f37b8beeff', '88dd3791-b862-4191-b414-1936a60c2736');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', '8f7fd375-05a0-4fd4-a14a-c64dd03e8b22');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92c73250-790f-4ec4-872e-9d3a66c06414', '9469e471-a979-4a6b-bfeb-ee19837ba80f');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', '9ced880c-2005-4ac6-902f-95b14a5e43f7');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('72b2af8a-037a-4dbc-9885-64e0f5a3da3b', 'b516c293-f72e-473c-9068-84c67eec12e0');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('db61f833-bd64-439d-ad5b-d2f37b8beeff', 'b9172795-206c-45de-9d6c-d6efe3453804');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92bad9dd-d791-499b-97c0-8b0c5ea7e1b4', 'c6fe2dea-7de9-459e-b9b9-f8730ff968b8');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92c73250-790f-4ec4-872e-9d3a66c06414', 'c98fd898-7c24-4e89-9c52-938368e78b89');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'cba8404a-ec60-454a-b1c0-f62c582f90be');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('db61f833-bd64-439d-ad5b-d2f37b8beeff', 'ce71afda-a3b6-436f-8a6d-a0d02ef58d07');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', 'cf7f3bb0-c592-4b96-af10-9448952f438a');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('72b2af8a-037a-4dbc-9885-64e0f5a3da3b', 'd11106e4-0993-4be1-8056-1f3c17c165d9');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92c73250-790f-4ec4-872e-9d3a66c06414', 'd23aaa6d-8ae4-4929-89df-aff436d6d4ad');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('170ef561-249a-4399-a0cf-b32b002bfcd1', 'd8f94cd4-b7fe-4aa9-ae62-9c6c84a09a04');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'dc0015d4-40c8-4df1-bc98-732d9578052c');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('b002b544-99e2-475c-a26d-ee13f9f73239', 'dcff9331-5516-43f0-b1dc-bfb4aeaf58fb');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92c73250-790f-4ec4-872e-9d3a66c06414', 'dd8e49dc-375e-4c92-b300-8c1379268859');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('90a467cb-6ad1-44c4-9a59-30b8a05b0f7d', 'df8c916d-91eb-4617-86ac-3cd0f2f19d9c');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92c73250-790f-4ec4-872e-9d3a66c06414', 'e942f859-b646-46ed-a815-ce9a1efa24ca');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('9064f323-8254-4181-80c8-fd79f24d76a5', 'ee539cc3-aeb2-4678-a93b-070e4a0513de');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('3ed67139-d83e-453a-a3d1-61cfa5e34eb3', 'f2824989-11ef-46e8-a589-dcddc46b16e8');
INSERT INTO "UserGrades" ("GradeId", "UserId")
VALUES ('92c73250-790f-4ec4-872e-9d3a66c06414', 'f4db019a-56aa-4097-905c-c6dc818b53b8');

INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('2afe12f5-351b-48b7-8c4e-8b0a0d6da016', '12400cfe-40ce-40d9-bd1f-fcd3b304b844');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('961c1956-6d79-4f1b-a91c-1dbf94849f6b', '1ca9a342-8a19-44fc-add3-d86fd5dc03c8');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('c387f063-49b4-4d9f-bdfa-0dcb2a66f7a7', '213947a9-6ba6-4d30-b3fc-be0709ae44f0');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', '221c3b60-2d38-480f-9434-65489bafd990');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('019004e0-41c7-4a21-89db-e3c540fa753b', '43bd1e19-b2e1-41ed-aa33-72389c353568');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('be5eaf87-7df1-4ea8-8aeb-7143ea9b27d2', '4460d7bb-7a3f-4efe-8ed8-1898663ab02f');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('e8db68a4-cd49-497d-994d-2c56626305dd', '46c42cdf-89a2-40de-ba90-c8b70a9448d9');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('c387f063-49b4-4d9f-bdfa-0dcb2a66f7a7', '5029829f-5709-45e2-97bb-918e62aec7e0');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', '53f2e5e6-370f-4242-bfe5-bb9f84551566');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('73640749-040c-4706-a6d6-654304f27e28', '58237089-bcee-4ae1-86e4-08358fbe2d09');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', '5ed6cd35-bb0e-4b19-8743-400d3eca47e9');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('3503299f-c3d3-4b9c-b58c-f8b24a4b73b1', '5f1f5980-c72e-4e1c-adbf-ca0a06e0bb68');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', '62e296a7-97ed-4b51-b470-fed15a8022f0');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('275cadea-af03-4a3d-8637-bc091a12e320', '64d42629-f589-4275-88fc-1fd94e365607');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('7453f6b8-474b-47ca-9142-3a1a6645da6b', '69eb82d2-b073-4358-8732-f102ae3bcc5e');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('019004e0-41c7-4a21-89db-e3c540fa753b', '6d111e4b-bbb2-4228-9756-eb6c7bd70c6a');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('3503299f-c3d3-4b9c-b58c-f8b24a4b73b1', '8346298d-56f7-489e-a3ef-b2d1f64304a5');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('961c1956-6d79-4f1b-a91c-1dbf94849f6b', '87d0113f-6dee-4a84-a517-6c6cd62b740e');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('be5eaf87-7df1-4ea8-8aeb-7143ea9b27d2', '88dd3791-b862-4191-b414-1936a60c2736');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('73640749-040c-4706-a6d6-654304f27e28', '8f7fd375-05a0-4fd4-a14a-c64dd03e8b22');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('21c520f5-0b8f-4018-ab3e-94d996bf167e', '9469e471-a979-4a6b-bfeb-ee19837ba80f');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('019004e0-41c7-4a21-89db-e3c540fa753b', '9ced880c-2005-4ac6-902f-95b14a5e43f7');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', 'b516c293-f72e-473c-9068-84c67eec12e0');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('e8db68a4-cd49-497d-994d-2c56626305dd', 'b9172795-206c-45de-9d6c-d6efe3453804');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', 'c6fe2dea-7de9-459e-b9b9-f8730ff968b8');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('932b2828-192f-4188-b3ed-c9279c3e3d97', 'c98fd898-7c24-4e89-9c52-938368e78b89');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('7453f6b8-474b-47ca-9142-3a1a6645da6b', 'cba8404a-ec60-454a-b1c0-f62c582f90be');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('961c1956-6d79-4f1b-a91c-1dbf94849f6b', 'ce71afda-a3b6-436f-8a6d-a0d02ef58d07');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('932b2828-192f-4188-b3ed-c9279c3e3d97', 'cf7f3bb0-c592-4b96-af10-9448952f438a');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('3503299f-c3d3-4b9c-b58c-f8b24a4b73b1', 'd11106e4-0993-4be1-8056-1f3c17c165d9');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('932b2828-192f-4188-b3ed-c9279c3e3d97', 'd23aaa6d-8ae4-4929-89df-aff436d6d4ad');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('7453f6b8-474b-47ca-9142-3a1a6645da6b', 'd8f94cd4-b7fe-4aa9-ae62-9c6c84a09a04');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('be5eaf87-7df1-4ea8-8aeb-7143ea9b27d2', 'dc0015d4-40c8-4df1-bc98-732d9578052c');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('e8db68a4-cd49-497d-994d-2c56626305dd', 'dcff9331-5516-43f0-b1dc-bfb4aeaf58fb');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('c387f063-49b4-4d9f-bdfa-0dcb2a66f7a7', 'dd8e49dc-375e-4c92-b300-8c1379268859');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('73640749-040c-4706-a6d6-654304f27e28', 'df8c916d-91eb-4617-86ac-3cd0f2f19d9c');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('019004e0-41c7-4a21-89db-e3c540fa753b', 'e942f859-b646-46ed-a815-ce9a1efa24ca');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('3503299f-c3d3-4b9c-b58c-f8b24a4b73b1', 'ee539cc3-aeb2-4678-a93b-070e4a0513de');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('932b2828-192f-4188-b3ed-c9279c3e3d97', 'f2824989-11ef-46e8-a589-dcddc46b16e8');
INSERT INTO "UserLanguages" ("LanguageId", "UserId")
VALUES ('28613b16-b899-4e20-8bf0-7189a9233182', 'f4db019a-56aa-4097-905c-c6dc818b53b8');

INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('6982f732-83bb-4fe5-951c-6b65def5da35', '019004e0-41c7-4a21-89db-e3c540fa753b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('8644fb15-2368-4656-a2ff-24fda8ad77d3', '019004e0-41c7-4a21-89db-e3c540fa753b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('d75ed578-009f-4440-a41f-d4a40948e135', '019004e0-41c7-4a21-89db-e3c540fa753b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('f5f8da37-ee70-4674-85b2-c22c8386e625', '019004e0-41c7-4a21-89db-e3c540fa753b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('7b7e0d84-3e51-48ca-a6d8-496ea1588aba', '21c520f5-0b8f-4018-ab3e-94d996bf167e');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('5ff68b32-b507-4657-bab1-ce19401229bc', '275cadea-af03-4a3d-8637-bc091a12e320');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('02dceed7-64de-48fe-8e2f-e267b6390a60', '28613b16-b899-4e20-8bf0-7189a9233182');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('0d9bed28-e21d-425f-b570-2207e847ea82', '28613b16-b899-4e20-8bf0-7189a9233182');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('211f4760-9287-4b90-9a89-09cf279f8bfc', '28613b16-b899-4e20-8bf0-7189a9233182');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('bff587df-179a-4f8c-9b75-8de721d0a756', '28613b16-b899-4e20-8bf0-7189a9233182');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('c859c488-249d-48f9-b5e6-99264a1f6c09', '28613b16-b899-4e20-8bf0-7189a9233182');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('cb8a2a41-34c2-4eee-9539-db99b6cc0bc1', '28613b16-b899-4e20-8bf0-7189a9233182');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('dfc595a5-e88f-420d-b2c7-0bbe5baf8d04', '28613b16-b899-4e20-8bf0-7189a9233182');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('ed37dfd7-0080-4d28-9563-a0d35726f195', '2afe12f5-351b-48b7-8c4e-8b0a0d6da016');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('780d250b-1d89-46ab-9531-0ee48201aa61', '3503299f-c3d3-4b9c-b58c-f8b24a4b73b1');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('9b6fb937-a61e-4114-9492-c48f4a932c7d', '3503299f-c3d3-4b9c-b58c-f8b24a4b73b1');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('c23d5906-3263-4115-9134-2bfccf81a315', '3503299f-c3d3-4b9c-b58c-f8b24a4b73b1');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('cf8ed7b2-d3f5-44ce-bd6c-dc9ae7fd55cd', '3503299f-c3d3-4b9c-b58c-f8b24a4b73b1');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('3ee4ef39-6b7f-41c7-9eba-2ac3add2c8a1', '73640749-040c-4706-a6d6-654304f27e28');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('abf9f4c0-7b81-416c-9111-10ead1ac0a44', '73640749-040c-4706-a6d6-654304f27e28');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('dcce1eef-47ba-4ead-ad6a-8e3b578154e4', '73640749-040c-4706-a6d6-654304f27e28');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('2cb9094a-5259-4e88-a9c2-98414b90cd01', '7453f6b8-474b-47ca-9142-3a1a6645da6b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('7d11ade3-f988-4fbe-9b0e-822d721cfcf1', '7453f6b8-474b-47ca-9142-3a1a6645da6b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('c3befa37-332d-4763-969b-fa614f45f282', '7453f6b8-474b-47ca-9142-3a1a6645da6b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('576a092e-f0ba-4382-86f9-98db7da3e3c0', '932b2828-192f-4188-b3ed-c9279c3e3d97');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('d473c1b0-ac7a-4b40-9f04-89dc4c0b8a70', '932b2828-192f-4188-b3ed-c9279c3e3d97');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('e050120c-3e14-4be0-9361-ef9103753be1', '932b2828-192f-4188-b3ed-c9279c3e3d97');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('e324f9ec-738c-48e1-b5e7-4b18e2eec819', '932b2828-192f-4188-b3ed-c9279c3e3d97');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('2568258e-6243-495b-b033-bfe0d95d6834', '961c1956-6d79-4f1b-a91c-1dbf94849f6b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('905854a9-e36d-4f3c-8db5-a7f80ce0440b', '961c1956-6d79-4f1b-a91c-1dbf94849f6b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('fa94019f-5bd5-43c3-9817-93bb4970f03a', '961c1956-6d79-4f1b-a91c-1dbf94849f6b');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('0c5aa6f1-47a3-49b2-8b3e-011819fa515f', 'be5eaf87-7df1-4ea8-8aeb-7143ea9b27d2');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('71860a30-5091-4243-9068-c84d70c2d2a5', 'be5eaf87-7df1-4ea8-8aeb-7143ea9b27d2');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('e98eaa42-75ef-482c-a197-74c4879a5c2e', 'be5eaf87-7df1-4ea8-8aeb-7143ea9b27d2');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('06756903-314e-4a10-8166-8706abf43b34', 'c387f063-49b4-4d9f-bdfa-0dcb2a66f7a7');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('06cfe889-2ca1-446b-ab45-b7b21577ad4e', 'c387f063-49b4-4d9f-bdfa-0dcb2a66f7a7');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('41f7e3b9-783d-4306-9946-898d3973976d', 'c387f063-49b4-4d9f-bdfa-0dcb2a66f7a7');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('b1abebc4-706f-49f7-a4d5-60ec976135c7', 'e8db68a4-cd49-497d-994d-2c56626305dd');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('b5c15d81-5216-4dc3-baff-b20bb647fdc1', 'e8db68a4-cd49-497d-994d-2c56626305dd');
INSERT INTO "ClassLanguages" ("ClassId", "LanguageId")
VALUES ('fe58ed9b-944c-42cb-a9b9-f55b8aa17a97', 'e8db68a4-cd49-497d-994d-2c56626305dd');

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
VALUES ('20240825204049_Initial', '6.0.26');

COMMIT;

