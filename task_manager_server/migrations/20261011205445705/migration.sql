BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "projects" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "tasks" ADD COLUMN "projectId" bigint;

--
-- MIGRATION VERSION FOR task_manager
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('task_manager', '20261011205445705', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261011205445705', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
