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
 model VARCHAR(500),
 type VARCHAR(500),
 quantity_in_stock VARCHAR(500)
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (instrument_id);


CREATE TABLE person (
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 first_name VARCHAR(500) NOT NULL,
 last_name VARCHAR(500) NOT NULL,
 person_number VARCHAR(12) NOT NULL,
 phone_number VARCHAR(500) NOT NULL,
 email_adress VARCHAR(500) NOT NULL,
 adress_id INT GENERATED ALWAYS AS IDENTITY NOT NULL
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (person_id);


CREATE TABLE pricing_scheme (
 pricing_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 enseble_price VARCHAR(500),
 sibling_discount VARCHAR(500)
);

ALTER TABLE pricing_scheme ADD CONSTRAINT PK_pricing_scheme PRIMARY KEY (pricing_scheme_id);


CREATE TABLE student (
 student_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 contact_person_phone_nr VARCHAR(500),
 rental_price_this_month VARCHAR(500),
 pricing_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (student_id,person_id);


CREATE TABLE teacher (
 teacher_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 can_teach_ensembles VARCHAR(10),
 is_available VARCHAR(10)
);

ALTER TABLE teacher ADD CONSTRAINT PK_teacher PRIMARY KEY (teacher_id,person_id);


CREATE TABLE can_teach_instrument (
 teacher_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument VARCHAR(500) NOT NULL
);

ALTER TABLE can_teach_instrument ADD CONSTRAINT PK_can_teach_instrument PRIMARY KEY (teacher_id,person_id,instrument);


CREATE TABLE group_lesson_price (
 pricing_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 price VARCHAR(500) NOT NULL,
 skill_level VARCHAR(500) NOT NULL
);

ALTER TABLE group_lesson_price ADD CONSTRAINT PK_group_lesson_price PRIMARY KEY (pricing_scheme_id,price,skill_level);


CREATE TABLE individual_lesson_price (
 pricing_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 price VARCHAR(500) NOT NULL,
 skill_level VARCHAR(500) NOT NULL
);

ALTER TABLE individual_lesson_price ADD CONSTRAINT PK_individual_lesson_price PRIMARY KEY (pricing_scheme_id,price,skill_level);


CREATE TABLE lesson (
 lesson_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 pricing_scheme_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 room_id VARCHAR(500),
 lesson_type VARCHAR(500) NOT NULL,
 date VARCHAR(10) NOT NULL,
 time TIMESTAMP(10) NOT NULL,
 genre VARCHAR(500),
 min_students VARCHAR(500),
 max_students VARCHAR(500),
 instrument_type VARCHAR(500),
 skill_level VARCHAR(500),
 teacher_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_id INT GENERATED ALWAYS AS IDENTITY,
 adress_id INT GENERATED ALWAYS AS IDENTITY NOT NULL
);

ALTER TABLE lesson ADD CONSTRAINT PK_lesson PRIMARY KEY (lesson_id);


CREATE TABLE rental (
 rental_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 starting_date VARCHAR(500),
 lease_period VARCHAR(500),
 wants_home_delivery VARCHAR(10),
 instrument_type VARCHAR(500) NOT NULL,
 rental_price VARCHAR(500),
 instrument_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 student_id INT GENERATED ALWAYS AS IDENTITY,
 person_id INT GENERATED ALWAYS AS IDENTITY
);

ALTER TABLE rental ADD CONSTRAINT PK_rental PRIMARY KEY (rental_id);


CREATE TABLE sibling_person_number (
 student_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 sibling_person_number VARCHAR(500) NOT NULL
);

ALTER TABLE sibling_person_number ADD CONSTRAINT PK_sibling_person_number PRIMARY KEY (student_id,person_id,sibling_person_number);


CREATE TABLE student_lesson (
 lesson_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 student_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL
);

ALTER TABLE student_lesson ADD CONSTRAINT PK_student_lesson PRIMARY KEY (lesson_id,student_id,person_id);


ALTER TABLE person ADD CONSTRAINT FK_person_0 FOREIGN KEY (adress_id) REFERENCES adress (adress_id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (person_id);
ALTER TABLE student ADD CONSTRAINT FK_student_1 FOREIGN KEY (pricing_scheme_id) REFERENCES pricing_scheme (pricing_scheme_id);


ALTER TABLE teacher ADD CONSTRAINT FK_teacher_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE can_teach_instrument ADD CONSTRAINT FK_can_teach_instrument_0 FOREIGN KEY (teacher_id,person_id) REFERENCES teacher (teacher_id,person_id);


ALTER TABLE group_lesson_price ADD CONSTRAINT FK_group_lesson_price_0 FOREIGN KEY (pricing_scheme_id) REFERENCES pricing_scheme (pricing_scheme_id);


ALTER TABLE individual_lesson_price ADD CONSTRAINT FK_individual_lesson_price_0 FOREIGN KEY (pricing_scheme_id) REFERENCES pricing_scheme (pricing_scheme_id);


ALTER TABLE lesson ADD CONSTRAINT FK_lesson_0 FOREIGN KEY (pricing_scheme_id) REFERENCES pricing_scheme (pricing_scheme_id);
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_1 FOREIGN KEY (teacher_id,person_id) REFERENCES teacher (teacher_id,person_id);
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_2 FOREIGN KEY (adress_id) REFERENCES adress (adress_id);


ALTER TABLE rental ADD CONSTRAINT FK_rental_0 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id);
ALTER TABLE rental ADD CONSTRAINT FK_rental_1 FOREIGN KEY (student_id,person_id) REFERENCES student (student_id,person_id);


ALTER TABLE sibling_person_number ADD CONSTRAINT FK_sibling_person_number_0 FOREIGN KEY (student_id,person_id) REFERENCES student (student_id,person_id);


ALTER TABLE student_lesson ADD CONSTRAINT FK_student_lesson_0 FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id);
ALTER TABLE student_lesson ADD CONSTRAINT FK_student_lesson_1 FOREIGN KEY (student_id,person_id) REFERENCES student (student_id,person_id);


