CREATE TABLE adress (
 adress_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 street VARCHAR(500),
 city VARCHAR(500),
 zip VARCHAR(500),
 country VARCHAR(500)
);

ALTER TABLE adress ADD CONSTRAINT PK_adress PRIMARY KEY (adress_id);


CREATE TABLE instrument (
 instrument_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 brand VARCHAR(500),
 price VARCHAR(500),
 model VARCHAR(500),
 type VARCHAR(500),
 instrument VARCHAR(500),
 in_stock VARCHAR(500)
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (instrument_id);


CREATE TABLE pricing_scheme (
 pricing_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 enseble_price VARCHAR(500),
 sibling_discount VARCHAR(500)
);

ALTER TABLE pricing_scheme ADD CONSTRAINT PK_pricing_scheme PRIMARY KEY (pricing_scheme_id);


CREATE TABLE skill_level (
 skill_level_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 skill_level VARCHAR(500) NOT NULL
);

ALTER TABLE skill_level ADD CONSTRAINT PK_skill_level PRIMARY KEY (skill_level_id);


CREATE TABLE student (
 student_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 contact_person_phone_nr VARCHAR(500),
 first_name VARCHAR(500) NOT NULL,
 last_name VARCHAR(500) NOT NULL,
 person_number VARCHAR(12) NOT NULL,
 age VARCHAR(500) NOT NULL,
 phone_number VARCHAR(500) NOT NULL,
 email_adress VARCHAR(500) NOT NULL,
 adress_id INT
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (student_id);


CREATE TABLE teacher (
 teacher_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 can_teach_ensembles VARCHAR(10),
 is_available VARCHAR(10),
 first_name VARCHAR(500) NOT NULL,
 last_name VARCHAR(500) NOT NULL,
 person_number VARCHAR(12) NOT NULL,
 age VARCHAR(500) NOT NULL,
 phone_number VARCHAR(500) NOT NULL,
 email_adress VARCHAR(500) NOT NULL,
 adress_id INT
);

ALTER TABLE teacher ADD CONSTRAINT PK_teacher PRIMARY KEY (teacher_id);


CREATE TABLE can_teach_instrument (
 teacher_id INT NOT NULL,
 instrument VARCHAR(500) NOT NULL
);

ALTER TABLE can_teach_instrument ADD CONSTRAINT PK_can_teach_instrument PRIMARY KEY (teacher_id,instrument);


CREATE TABLE group_lesson_price (
 price VARCHAR(500) NOT NULL,
 pricing_scheme_id INT NOT NULL,
 skill_level_id INT NOT NULL
);

ALTER TABLE group_lesson_price ADD CONSTRAINT PK_group_lesson_price PRIMARY KEY (price,pricing_scheme_id,skill_level_id);


CREATE TABLE individual_lesson_price (
 price VARCHAR(500) NOT NULL,
 pricing_scheme_id INT NOT NULL,
 skill_level_id INT NOT NULL
);

ALTER TABLE individual_lesson_price ADD CONSTRAINT PK_individual_lesson_price PRIMARY KEY (price,pricing_scheme_id,skill_level_id);


CREATE TABLE lesson (
 lesson_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 room_id VARCHAR(500),
 lesson_type VARCHAR(500) NOT NULL,
 date VARCHAR(10) NOT NULL,
 time TIME(10) NOT NULL,
 instrument_type VARCHAR(500),
 genre VARCHAR(500),
 min_students VARCHAR(500),
 max_students VARCHAR(500),
 pricing_scheme_id INT NOT NULL,
 adress_id INT NOT NULL,
 teacher_id INT NOT NULL,
 skill_level_id INT NOT NULL
);

ALTER TABLE lesson ADD CONSTRAINT PK_lesson PRIMARY KEY (lesson_id);


CREATE TABLE rental (
 rental_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 starting_date VARCHAR(500),
 lease_period VARCHAR(500),
 wants_home_delivery VARCHAR(10),
 instrument_id INT NOT NULL,
 student_id INT
);

ALTER TABLE rental ADD CONSTRAINT PK_rental PRIMARY KEY (rental_id);


CREATE TABLE sibling_person_number (
 student_id INT NOT NULL,
 sibling_person_number VARCHAR(500) NOT NULL
);

ALTER TABLE sibling_person_number ADD CONSTRAINT PK_sibling_person_number PRIMARY KEY (student_id,sibling_person_number);


CREATE TABLE student_lesson (
 student_id INT NOT NULL,
 lesson_id INT NOT NULL
);

ALTER TABLE student_lesson ADD CONSTRAINT PK_student_lesson PRIMARY KEY (student_id,lesson_id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (adress_id) REFERENCES adress (adress_id);


ALTER TABLE teacher ADD CONSTRAINT FK_teacher_0 FOREIGN KEY (adress_id) REFERENCES adress (adress_id);


ALTER TABLE can_teach_instrument ADD CONSTRAINT FK_can_teach_instrument_0 FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id);


ALTER TABLE group_lesson_price ADD CONSTRAINT FK_group_lesson_price_0 FOREIGN KEY (pricing_scheme_id) REFERENCES pricing_scheme (pricing_scheme_id);
ALTER TABLE group_lesson_price ADD CONSTRAINT FK_group_lesson_price_1 FOREIGN KEY (skill_level_id) REFERENCES skill_level (skill_level_id);


ALTER TABLE individual_lesson_price ADD CONSTRAINT FK_individual_lesson_price_0 FOREIGN KEY (pricing_scheme_id) REFERENCES pricing_scheme (pricing_scheme_id);
ALTER TABLE individual_lesson_price ADD CONSTRAINT FK_individual_lesson_price_1 FOREIGN KEY (skill_level_id) REFERENCES skill_level (skill_level_id);


ALTER TABLE lesson ADD CONSTRAINT FK_lesson_0 FOREIGN KEY (pricing_scheme_id) REFERENCES pricing_scheme (pricing_scheme_id);
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_1 FOREIGN KEY (adress_id) REFERENCES adress (adress_id);
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_2 FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id);
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_3 FOREIGN KEY (skill_level_id) REFERENCES skill_level (skill_level_id);


ALTER TABLE rental ADD CONSTRAINT FK_rental_0 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id);
ALTER TABLE rental ADD CONSTRAINT FK_rental_1 FOREIGN KEY (student_id) REFERENCES student (student_id);


ALTER TABLE sibling_person_number ADD CONSTRAINT FK_sibling_person_number_0 FOREIGN KEY (student_id) REFERENCES student (student_id);


ALTER TABLE student_lesson ADD CONSTRAINT FK_student_lesson_0 FOREIGN KEY (student_id) REFERENCES student (student_id);
ALTER TABLE student_lesson ADD CONSTRAINT FK_student_lesson_1 FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id);