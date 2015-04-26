

DROP TABLE IF EXISTS `groups`;
CREATE TABLE "groups" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" longtext NOT NULL,
    UNIQUE (name)
);


DROP TABLE IF EXISTS `types`;
CREATE TABLE "types" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" longtext NOT NULL,
    "group_id" int(10) NOT NULL DEFAULT '0',
    FOREIGN KEY (group_id) REFERENCES groups(id),
    UNIQUE (name, group_id)
);


DROP TABLE IF EXISTS `accounts`;
CREATE TABLE "accounts" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" varchar(25) NOT NULL,
    "inactive" tinyint(3)  NOT NULL DEFAULT '0',
    "excluded" int(1)  NOT NULL DEFAULT '0',
    "priority" int(10)  NOT NULL DEFAULT '0',
    UNIQUE (name)
);

DROP TABLE IF EXISTS `locations`;
CREATE TABLE "locations" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" varchar(255),
    "latitude" double NOT NULL,
    "longitude" double NOT NULL,
    "address" text NOT NULL,
    UNIQUE(name)
);


DROP TABLE IF EXISTS `items`;
CREATE TABLE "items" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "account_id" int(10) NOT NULL,
    "type_id" int(10) NOT NULL,
    "location_id" int(10),
    "amount" double DEFAULT '0',
    "date" date NOT NULL,
    "comments" text,
    FOREIGN KEY (account_id) REFERENCES account(id),
    FOREIGN KEY (type_id) REFERENCES type(id),
    FOREIGN KEY (location_id) REFERENCES location(id)
);


DROP TABLE IF EXISTS `parse`;
CREATE TABLE "parse" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "model" VARCHAR(25) NOT NULL,
    "model_id" INTEGER,
    "parse_id" CHAR(10),
    "synced" BOOLEAN NOT NULL DEFAULT FALSE,
    "deleted" BOOLEAN NOT NULL DEFAULT FALSE,
    "updated_at" DATETIME,
    UNIQUE (model, model_id),
    UNIQUE (parse_id)
);

