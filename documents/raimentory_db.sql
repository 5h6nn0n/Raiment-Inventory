DROP DATABASE IF EXISTS raimentory_db;
CREATE DATABASE IF NOT EXISTs raimentory_db;
USE raimentory_db;

CREATE TABLE ACCOUNT (
account_id  INT     NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
full_name   VARCHAR(50) NOT NULL,
username    VARCHAR(20)      NOT NULL ,
hashed_pass VARCHAR(20) NOT NULL, 
about_bio   TEXT,
admin_pin   TINYINT,
UNIQUE INDEX username (username)
);

CREATE TABLE ACTIVITY_LOG (
log_id      INT     NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
account_id INT      NOT NULL     ,
action_taken ENUM('Create', 'Read', 'Update', 'Delete', 'Archive') NOT NULL,
table_name ENUM('Account', 'Measurement', 'My Closet', 'Sell Closet', 'Shipping') NOT NULL,
table_row INT   NOT NULL,
before_json JSON,
after_json JSON,
diff_json JSON,
occured_at TIMESTAMP,
INDEX account_id (account_id),
FOREIGN KEY (account_id) REFERENCES ACCOUNT (account_id)
);

CREATE TABLE MEASUREMENT (
measurement_id  INT NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
account_id  INT     NOT NULL,
measurement_name VARCHAR(20)    NOT NULL,
measurement_value DECIMAL(5,2) NOT NULL,
unit_type ENUM('IN', 'CM', 'FT') NOT NULL DEFAULT 'IN'
);

CREATE TABLE PARENT_CATEGORY (
p_category_id       INT     NOT NULL AUTO_INCREMENT PRIMARY KEY,
p_category_name VARCHAR(50) NOT NULL
);

CREATE TABLE CHILD_CATEGORY (
c_category_id   INT NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
p_category_id   INT NOT NULL     ,
c_category_name VARCHAR(50) NOT NULL, 
INDEX p_category_id (p_category_id),
FOREIGN KEY (p_category_id) REFERENCES PARENT_CATEGORY (p_category_id)

);

CREATE TABLE MY_CLOSET (
item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
account_id INT NOT NULL  ,
p_category_id INT NOT NULL  ,
item_title VARCHAR(50) NOT NULL,
item_desc TEXT NOT NULL,
amt_paid DECIMAL(6,2),
msrp        DECIMAL(6,2),
materials VARCHAR(50),
labeled_size ENUM('XXS/00', 'XS/0', 'S/2-4', 'M/6-8', 'L/10-12', 'XL/14-16', 'XXL/18+') NOT NULL, 
size_type ENUM('Regular', 'Petite', 'Tall', 'Plus', 'Kids') NOT NULL    DEFAULT 'Regular',
year_acquired   YEAR,
emotional_index INT,
status ENUM('Keep', 'Sell') NOT NULL DEFAULT 'Keep',
brand_name  VARCHAR(50) NOT NULL,
image_url VARCHAR(255),
INDEX account_id (account_id),
INDEX p_category_id (p_category_id),
FOREIGN KEY (account_id) REFERENCES ACCOUNT (account_id),
FOREIGN KEY (p_category_id) REFERENCES PARENT_CATEGORY (p_category_id)

);

CREATE TABLE PLATFORM (
platform_id     INT     NOT NULL    AUTO_INCREMENT PRIMARY KEY,
platform_name   VARCHAR(20)  NOT  NULL, 
standard_fee    DECIMAL(4,2)    NOT NULL,
boosted_fee     DECIMAL(4,2)    NOT NULL
);

CREATE TABLE SHIPPING (
shipping_id     INT     NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
platform_id INT NOT NULL,
parcel_size    ENUM('XXS', 'XS', 'S', 'M', 'L', 'XL')    NOT NULL, 
shipping_rate DECIMAL(5,2)  NOT NULL
);

CREATE TABLE SELL_CLOSET (
sell_id     INT     NOT NULL     AUTO_INCREMENT     PRIMARY KEY,
item_id INT NOT NULL    ,
date_listed DATE NOT NULL,
list_price   DECIMAL(6,2) NOT NULL,
discount_applied DECIMAL(4,2) DEFAULT 00.00,
min_price DECIMAL(6,2),
mark_status ENUM('Draft', 'Listed', 'Sold', 'Donated', 'Gift') NOT NULL DEFAULT 'Listed' ,
item_condition ENUM('NWT', 'Like New', 'Excellent', 'Good', 'Fair') NOT NULL,
quality_tier INT NOT NULL,
era VARCHAR(20),
style_market TEXT,
is_boosted BOOLEAN NOT NULL DEFAULT 0,
UNIQUE INDEX item_id (item_id),
FOREIGN KEY (item_id) REFERENCES MY_CLOSET (item_id)

);

CREATE TABLE SELL_PLATFORM (
sp_join_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
sell_id INT NOT NULL  ,
platform_id INT NOT NULL  ,
INDEX sell_id (sell_id),
INDEX platform_id (platform_id),
FOREIGN KEY (sell_id) REFERENCES SELL_CLOSET (sell_id),
FOREIGN KEY (platform_id) REFERENCES PLATFORM (platform_id)

);


CREATE TABLE SELL_MEASUREMENT (
sm_join_id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
measurement_id INT NOT NULL  ,
sell_id INT NOT NULL ,
INDEX measurement_id (measurement_id),
INDEX sell_id (sell_id),
FOREIGN KEY (measurement_id) REFERENCES MEASUREMENT (measurement_id),
FOREIGN KEY (sell_id) REFERENCES SELL_CLOSET (sell_id)

);



CREATE USER IF NOT EXISTS 'mgs_user'@'localhost'
IDENTIFIED BY 'pa55word';

GRANT SELECT, INSERT, UPDATE, DELETE
ON *
TO 'mgs_user'@'localhost';
