BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "tasks" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text,
    "isCompleted" boolean NOT NULL DEFAULT false,
    "priority" bigint NOT NULL DEFAULT 0,
    "dueDate" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "tasks_completed_idx" ON "tasks" USING btree ("isCompleted");


--
-- MIGRATION VERSION FOR task_manager
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('task_manager', '20261011173237704', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261011173237704', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
