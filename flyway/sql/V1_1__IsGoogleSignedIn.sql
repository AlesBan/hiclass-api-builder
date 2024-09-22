ALTER TABLE "Users"
ADD "IsGoogleSignedIn" boolean NOT NULL DEFAULT FALSE;

ALTER TABLE "Users"
ADD "IsPasswordSet" boolean NOT NULL DEFAULT FALSE;