using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HiClass.Persistence.Migrations
{
    public partial class Initial : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Countries",
                columns: table => new
                {
                    CountryId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    Title = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Countries", x => x.CountryId);
                });

            migrationBuilder.CreateTable(
                name: "Disciplines",
                columns: table => new
                {
                    DisciplineId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    Title = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Disciplines", x => x.DisciplineId);
                });

            migrationBuilder.CreateTable(
                name: "Grades",
                columns: table => new
                {
                    GradeId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    GradeNumber = table.Column<int>(type: "integer", maxLength: 15, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Grades", x => x.GradeId);
                });

            migrationBuilder.CreateTable(
                name: "InstitutionTypes",
                columns: table => new
                {
                    InstitutionTypeId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    Title = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InstitutionTypes", x => x.InstitutionTypeId);
                });

            migrationBuilder.CreateTable(
                name: "Languages",
                columns: table => new
                {
                    LanguageId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    Title = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Languages", x => x.LanguageId);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    RoleId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    Title = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.RoleId);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    CityId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    Title = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    CountryId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.CityId);
                    table.ForeignKey(
                        name: "FK_Cities_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "CountryId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Institutions",
                columns: table => new
                {
                    InstitutionId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    Title = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Address = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: false),
                    CityId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Institutions", x => x.InstitutionId);
                    table.ForeignKey(
                        name: "FK_Institutions_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "CityId");
                });

            migrationBuilder.CreateTable(
                name: "InstitutionTypesInstitutions",
                columns: table => new
                {
                    InstitutionTypeId = table.Column<Guid>(type: "uuid", nullable: false),
                    InstitutionId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InstitutionTypesInstitutions", x => new { x.InstitutionTypeId, x.InstitutionId });
                    table.ForeignKey(
                        name: "FK_InstitutionTypesInstitutions_Institutions_InstitutionId",
                        column: x => x.InstitutionId,
                        principalTable: "Institutions",
                        principalColumn: "InstitutionId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_InstitutionTypesInstitutions_InstitutionTypes_InstitutionTy~",
                        column: x => x.InstitutionTypeId,
                        principalTable: "InstitutionTypes",
                        principalColumn: "InstitutionTypeId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    Email = table.Column<string>(type: "text", nullable: false),
                    PasswordHash = table.Column<byte[]>(type: "bytea", nullable: false),
                    PasswordSalt = table.Column<byte[]>(type: "bytea", nullable: false),
                    AccessToken = table.Column<string>(type: "text", nullable: true),
                    PasswordResetToken = table.Column<string>(type: "text", nullable: true),
                    ResetTokenExpires = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    PasswordResetCode = table.Column<string>(type: "text", nullable: true),
                    VerificationCode = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    IsCreatedAccount = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    IsVerified = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    IsInstitutionVerified = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    FirstName = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: true),
                    LastName = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: true),
                    IsATeacher = table.Column<bool>(type: "boolean", nullable: true),
                    IsAnExpert = table.Column<bool>(type: "boolean", nullable: true),
                    InstitutionId = table.Column<Guid>(type: "uuid", nullable: true),
                    CityId = table.Column<Guid>(type: "uuid", nullable: true),
                    CountryId = table.Column<Guid>(type: "uuid", nullable: true),
                    Rating = table.Column<double>(type: "numeric(3,2)", nullable: false, defaultValue: 0.0),
                    Description = table.Column<string>(type: "character varying(300)", maxLength: 300, nullable: true),
                    ImageUrl = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    BannerImageUrl = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    RegisteredAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "now()"),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    VerifiedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    LastOnlineAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "now()"),
                    DeletedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                    table.ForeignKey(
                        name: "FK_Users_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "CityId",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Users_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "CountryId",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Users_Institutions_InstitutionId",
                        column: x => x.InstitutionId,
                        principalTable: "Institutions",
                        principalColumn: "InstitutionId",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "Classes",
                columns: table => new
                {
                    ClassId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    GradeId = table.Column<Guid>(type: "uuid", nullable: false),
                    ImageUrl = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "now()"),
                    DeletedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Classes", x => x.ClassId);
                    table.ForeignKey(
                        name: "FK_Classes_Grades_GradeId",
                        column: x => x.GradeId,
                        principalTable: "Grades",
                        principalColumn: "GradeId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Classes_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserDisciplines",
                columns: table => new
                {
                    DisciplineId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserDisciplines", x => new { x.UserId, x.DisciplineId });
                    table.ForeignKey(
                        name: "FK_UserDisciplines_Disciplines_DisciplineId",
                        column: x => x.DisciplineId,
                        principalTable: "Disciplines",
                        principalColumn: "DisciplineId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserDisciplines_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserGrades",
                columns: table => new
                {
                    GradeId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserGrades", x => new { x.UserId, x.GradeId });
                    table.ForeignKey(
                        name: "FK_UserGrades_Grades_GradeId",
                        column: x => x.GradeId,
                        principalTable: "Grades",
                        principalColumn: "GradeId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserGrades_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserLanguages",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    LanguageId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserLanguages", x => new { x.UserId, x.LanguageId });
                    table.ForeignKey(
                        name: "FK_UserLanguages_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "LanguageId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserLanguages_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    RoleId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "RoleId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ClassDisciplines",
                columns: table => new
                {
                    DisciplineId = table.Column<Guid>(type: "uuid", nullable: false),
                    ClassId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ClassDisciplines", x => new { x.ClassId, x.DisciplineId });
                    table.ForeignKey(
                        name: "FK_ClassDisciplines_Classes_ClassId",
                        column: x => x.ClassId,
                        principalTable: "Classes",
                        principalColumn: "ClassId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ClassDisciplines_Disciplines_DisciplineId",
                        column: x => x.DisciplineId,
                        principalTable: "Disciplines",
                        principalColumn: "DisciplineId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ClassLanguages",
                columns: table => new
                {
                    LanguageId = table.Column<Guid>(type: "uuid", nullable: false),
                    ClassId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ClassLanguages", x => new { x.LanguageId, x.ClassId });
                    table.ForeignKey(
                        name: "FK_ClassLanguages_Classes_ClassId",
                        column: x => x.ClassId,
                        principalTable: "Classes",
                        principalColumn: "ClassId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ClassLanguages_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "LanguageId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Invitations",
                columns: table => new
                {
                    InvitationId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    UserSenderId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserReceiverId = table.Column<Guid>(type: "uuid", nullable: false),
                    ClassSenderId = table.Column<Guid>(type: "uuid", nullable: false),
                    ClassReceiverId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "now()"),
                    DateOfInvitation = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Status = table.Column<string>(type: "text", nullable: false, defaultValue: "Pending"),
                    InvitationText = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Invitations", x => x.InvitationId);
                    table.ForeignKey(
                        name: "FK_Invitations_Classes_ClassReceiverId",
                        column: x => x.ClassReceiverId,
                        principalTable: "Classes",
                        principalColumn: "ClassId");
                    table.ForeignKey(
                        name: "FK_Invitations_Classes_ClassSenderId",
                        column: x => x.ClassSenderId,
                        principalTable: "Classes",
                        principalColumn: "ClassId");
                    table.ForeignKey(
                        name: "FK_Invitations_Users_UserReceiverId",
                        column: x => x.UserReceiverId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                    table.ForeignKey(
                        name: "FK_Invitations_Users_UserSenderId",
                        column: x => x.UserSenderId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "Feedbacks",
                columns: table => new
                {
                    FeedbackId = table.Column<Guid>(type: "uuid", nullable: false, defaultValueSql: "gen_random_uuid()"),
                    InvitationId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserSenderId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserRecipientId = table.Column<Guid>(type: "uuid", nullable: false),
                    ClassSenderId = table.Column<Guid>(type: "uuid", nullable: false),
                    ClassReceiverId = table.Column<Guid>(type: "uuid", nullable: false),
                    WasTheJointLesson = table.Column<bool>(type: "boolean", nullable: false),
                    ReasonForNotConducting = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    FeedbackText = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    Rating = table.Column<short>(type: "SMALLINT", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Feedbacks", x => x.FeedbackId);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Classes_ClassReceiverId",
                        column: x => x.ClassReceiverId,
                        principalTable: "Classes",
                        principalColumn: "ClassId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Classes_ClassSenderId",
                        column: x => x.ClassSenderId,
                        principalTable: "Classes",
                        principalColumn: "ClassId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Invitations_InvitationId",
                        column: x => x.InvitationId,
                        principalTable: "Invitations",
                        principalColumn: "InvitationId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Users_UserRecipientId",
                        column: x => x.UserRecipientId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Users_UserSenderId",
                        column: x => x.UserSenderId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Disciplines",
                columns: new[] { "DisciplineId", "Title" },
                values: new object[,]
                {
                    { new Guid("09557099-43ee-478d-9c5c-ab66cde28588"), "Economics" },
                    { new Guid("0c88e9a3-f983-4edd-a39e-b55a79336352"), "Regional studies" },
                    { new Guid("10cf60af-5335-4bc2-af52-aefe65a5be55"), "Russian language" },
                    { new Guid("1abc9cd6-2139-440e-83c6-d67d54ac7b39"), "Music" },
                    { new Guid("1f41a7f5-7196-4d03-a49c-48affdc07716"), "Cultural exchange" },
                    { new Guid("34ebee0e-a3f2-4127-b554-f60f255d3ab9"), "Spanish as a foreign language" },
                    { new Guid("3b879215-b498-4b58-becc-6b4458cba53c"), "Astronomy" },
                    { new Guid("3c6f6b7f-f47c-4523-a6f9-24869336b088"), "Italian as a foreign language" },
                    { new Guid("4154f9b3-9eda-42cc-9f31-9f9ac7613ae8"), "Chinese as a foreign language" },
                    { new Guid("4f94bba2-0a3e-46f0-8a97-ed1ffecc5c81"), "Physics" },
                    { new Guid("4fd55b22-f8dc-4895-8426-2963e26234d4"), "Project-based learning" },
                    { new Guid("521881d5-3ed6-4f98-92e0-e43ff9431334"), "Vacation education" },
                    { new Guid("60206daf-7115-4dc1-89e3-7718bff2b288"), "Crafts" },
                    { new Guid("62b76391-1647-4088-b8dc-fc5f710f6afc"), "World art" },
                    { new Guid("658673ae-fa20-4aff-a73b-4d30dd45e976"), "English as a foreign language" },
                    { new Guid("7706190e-9a1d-414d-93ed-5e893b91cc01"), "German as a foreign language" },
                    { new Guid("799723fb-6f76-49d8-8b9a-1c5499148bf0"), "History" },
                    { new Guid("84a93d4a-bc5e-45e7-846b-a9d7dd8fae27"), "Social science" },
                    { new Guid("8ee83471-b752-4da1-b241-de580b6af2dd"), "Natural science" },
                    { new Guid("9efc3cff-455a-418c-a28a-d50614ef104e"), "Chemistry" },
                    { new Guid("aa62d79a-c78a-41da-a9bb-15b90b220f96"), "Biology" },
                    { new Guid("ab9e0229-48c8-49d2-999a-7af0bb37d43a"), "Fine arts" },
                    { new Guid("be984298-c6f4-473f-b984-9ee61efa8ee2"), "French as a foreign language" },
                    { new Guid("c96a70f5-275d-4b5a-9260-fd7e791dbf71"), "Mathematics" },
                    { new Guid("c993c589-9424-470c-8704-5bfa990740a5"), "Computer science" },
                    { new Guid("cf24ccee-ecfc-4604-9e77-757e0be8c27e"), "Russian literature" },
                    { new Guid("df7216b0-7ecb-47ce-b85b-ddb186330754"), "Technology" },
                    { new Guid("f97a1da5-4851-4b34-a1bf-ddb39c605fa9"), "Geography" }
                });

            migrationBuilder.InsertData(
                table: "Grades",
                columns: new[] { "GradeId", "GradeNumber" },
                values: new object[,]
                {
                    { new Guid("0f5887db-a186-4d38-ab5c-451ba3df9f87"), 2 },
                    { new Guid("179d2b0c-fe47-43d6-a2bb-0dbfa7dd4b7c"), 4 },
                    { new Guid("22876a40-ea33-41ca-b027-f6e84f8e089a"), 3 },
                    { new Guid("3e060df3-e993-4360-81ec-526bfd4300de"), 8 },
                    { new Guid("43fc7b25-7e5b-40fb-9ae8-2daf02cb1c65"), 9 },
                    { new Guid("52cdfa78-5ffe-4efd-9be0-65c33441c344"), 5 },
                    { new Guid("54e5c3fe-e1b7-479c-b122-317668d84867"), 12 },
                    { new Guid("caacefd8-fc3c-498c-948b-1ee64a6705c7"), 1 },
                    { new Guid("d6196793-8541-4568-b9b5-ed79db4663d6"), 11 },
                    { new Guid("e5f7a7be-9cd8-40fd-8e89-7ca24267590d"), 6 },
                    { new Guid("edefb369-d929-4ce3-9867-f759fe65fa5d"), 10 },
                    { new Guid("fa9b3948-5db2-4030-b550-b9f6526db511"), 7 }
                });

            migrationBuilder.InsertData(
                table: "InstitutionTypes",
                columns: new[] { "InstitutionTypeId", "Title" },
                values: new object[,]
                {
                    { new Guid("4f887a70-b6d3-4a94-a30b-b51bf5d750f3"), "School" },
                    { new Guid("e57afc06-6698-40e2-ac4f-599ebba14c2e"), "Lyceum" },
                    { new Guid("efe4663e-cda4-42c9-aca5-7c047a050282"), "Gymnasium" },
                    { new Guid("ff70890b-797b-431c-a019-fb3586da5036"), "College" }
                });

            migrationBuilder.InsertData(
                table: "Languages",
                columns: new[] { "LanguageId", "Title" },
                values: new object[,]
                {
                    { new Guid("08ffc2de-fd41-4746-8f44-2b1094cbeb7b"), "Hungarian" },
                    { new Guid("2bd7c6c4-fd62-4e43-a7c1-0cca723f22f8"), "German" },
                    { new Guid("321970b9-9162-4354-86f0-eea273eaac92"), "Belarusian" },
                    { new Guid("36bb06f4-9dc3-4824-8e80-d9685528d96e"), "Armenian" },
                    { new Guid("39374a1f-207f-4f52-b84e-f054da08888d"), "Tajik" },
                    { new Guid("409fae6a-0e64-456f-aa82-59ad3860d1e0"), "Spanish" },
                    { new Guid("4bac2286-3621-4aa0-b240-fc92bb52cd8c"), "Kyrgyz" },
                    { new Guid("4d88746d-9115-43c1-8e56-b0c37de89e97"), "Kazakh" },
                    { new Guid("5ce9f24b-c4b5-42eb-aa93-aaedc79bb25d"), "English" },
                    { new Guid("74f2bfcc-8fc4-44a0-b635-3096bbd29ac2"), "Italian" },
                    { new Guid("7c9cdd67-ab97-4b82-97ed-fc1cc859e40d"), "Ukrainian" },
                    { new Guid("7dbceb90-9f52-40e5-afff-086b069fba3b"), "Georgian" },
                    { new Guid("9d4cc8b9-6669-4e89-a989-fd6f2f91e9c3"), "Azerbaijani" },
                    { new Guid("d112b085-f98d-4e6e-b0e9-17d0bf8ba8bd"), "Portuguese" },
                    { new Guid("db9b3b01-575d-4ac0-a3bf-f3c98f240c5c"), "French" },
                    { new Guid("e4236f9a-4bc8-4865-b162-90d2540f999b"), "Russian" },
                    { new Guid("ea5615bf-b846-4b0e-aa46-3ba2fd817e08"), "Uzbek" }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "RoleId", "Title" },
                values: new object[,]
                {
                    { new Guid("0445c42a-4062-4040-b8e0-2f9f0b01bd4d"), "Admin" },
                    { new Guid("b3f26093-1a1f-4ff6-b610-37cc46e36ea2"), "Manager" },
                    { new Guid("f771c782-23b8-4ac7-9ee4-2b88475c6761"), "User" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CityId",
                table: "Cities",
                column: "CityId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CountryId",
                table: "Cities",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_ClassDisciplines_ClassId_DisciplineId",
                table: "ClassDisciplines",
                columns: new[] { "ClassId", "DisciplineId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ClassDisciplines_DisciplineId",
                table: "ClassDisciplines",
                column: "DisciplineId");

            migrationBuilder.CreateIndex(
                name: "IX_Classes_ClassId",
                table: "Classes",
                column: "ClassId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Classes_GradeId",
                table: "Classes",
                column: "GradeId");

            migrationBuilder.CreateIndex(
                name: "IX_Classes_UserId",
                table: "Classes",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ClassLanguages_ClassId",
                table: "ClassLanguages",
                column: "ClassId");

            migrationBuilder.CreateIndex(
                name: "IX_ClassLanguages_LanguageId_ClassId",
                table: "ClassLanguages",
                columns: new[] { "LanguageId", "ClassId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Countries_CountryId",
                table: "Countries",
                column: "CountryId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Disciplines_DisciplineId",
                table: "Disciplines",
                column: "DisciplineId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_ClassReceiverId",
                table: "Feedbacks",
                column: "ClassReceiverId");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_ClassSenderId",
                table: "Feedbacks",
                column: "ClassSenderId");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_FeedbackId",
                table: "Feedbacks",
                column: "FeedbackId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_InvitationId",
                table: "Feedbacks",
                column: "InvitationId");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_UserRecipientId",
                table: "Feedbacks",
                column: "UserRecipientId");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_UserSenderId",
                table: "Feedbacks",
                column: "UserSenderId");

            migrationBuilder.CreateIndex(
                name: "IX_Grades_GradeId",
                table: "Grades",
                column: "GradeId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Institutions_CityId",
                table: "Institutions",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Institutions_InstitutionId",
                table: "Institutions",
                column: "InstitutionId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_InstitutionTypes_InstitutionTypeId",
                table: "InstitutionTypes",
                column: "InstitutionTypeId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_InstitutionTypesInstitutions_InstitutionId",
                table: "InstitutionTypesInstitutions",
                column: "InstitutionId");

            migrationBuilder.CreateIndex(
                name: "IX_InstitutionTypesInstitutions_InstitutionTypeId_InstitutionId",
                table: "InstitutionTypesInstitutions",
                columns: new[] { "InstitutionTypeId", "InstitutionId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Invitations_ClassReceiverId",
                table: "Invitations",
                column: "ClassReceiverId");

            migrationBuilder.CreateIndex(
                name: "IX_Invitations_ClassSenderId",
                table: "Invitations",
                column: "ClassSenderId");

            migrationBuilder.CreateIndex(
                name: "IX_Invitations_InvitationId",
                table: "Invitations",
                column: "InvitationId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Invitations_UserReceiverId",
                table: "Invitations",
                column: "UserReceiverId");

            migrationBuilder.CreateIndex(
                name: "IX_Invitations_UserSenderId",
                table: "Invitations",
                column: "UserSenderId");

            migrationBuilder.CreateIndex(
                name: "IX_Languages_LanguageId",
                table: "Languages",
                column: "LanguageId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Roles_RoleId",
                table: "Roles",
                column: "RoleId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserDisciplines_DisciplineId",
                table: "UserDisciplines",
                column: "DisciplineId");

            migrationBuilder.CreateIndex(
                name: "IX_UserDisciplines_UserId_DisciplineId",
                table: "UserDisciplines",
                columns: new[] { "UserId", "DisciplineId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserGrades_GradeId",
                table: "UserGrades",
                column: "GradeId");

            migrationBuilder.CreateIndex(
                name: "IX_UserGrades_UserId_GradeId",
                table: "UserGrades",
                columns: new[] { "UserId", "GradeId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserLanguages_LanguageId",
                table: "UserLanguages",
                column: "LanguageId");

            migrationBuilder.CreateIndex(
                name: "IX_UserLanguages_UserId_LanguageId",
                table: "UserLanguages",
                columns: new[] { "UserId", "LanguageId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                table: "UserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_UserId_RoleId",
                table: "UserRoles",
                columns: new[] { "UserId", "RoleId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_CityId",
                table: "Users",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_CountryId",
                table: "Users",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_InstitutionId",
                table: "Users",
                column: "InstitutionId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_UserId",
                table: "Users",
                column: "UserId",
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ClassDisciplines");

            migrationBuilder.DropTable(
                name: "ClassLanguages");

            migrationBuilder.DropTable(
                name: "Feedbacks");

            migrationBuilder.DropTable(
                name: "InstitutionTypesInstitutions");

            migrationBuilder.DropTable(
                name: "UserDisciplines");

            migrationBuilder.DropTable(
                name: "UserGrades");

            migrationBuilder.DropTable(
                name: "UserLanguages");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "Invitations");

            migrationBuilder.DropTable(
                name: "InstitutionTypes");

            migrationBuilder.DropTable(
                name: "Disciplines");

            migrationBuilder.DropTable(
                name: "Languages");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "Classes");

            migrationBuilder.DropTable(
                name: "Grades");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Institutions");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Countries");
        }
    }
}
