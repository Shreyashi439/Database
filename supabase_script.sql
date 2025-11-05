
CREATE TYPE subject_requirement_type AS ENUM ('essential', 'optional');
CREATE TYPE college_type_enum AS ENUM ('Public', 'Private', 'Other');


CREATE TABLE career_cluster (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE stream (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE subject (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE skill (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE career_job_opportunity (
  id SERIAL PRIMARY KEY,
  job_title VARCHAR(255) NOT NULL
);

CREATE TABLE entrance_exam (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT
);


CREATE TABLE career_path (
  id SERIAL PRIMARY KEY,
  career_cluster_id INT REFERENCES career_cluster(id) ON DELETE SET NULL,
  stream_id INT REFERENCES stream(id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  highlights TEXT,
  type VARCHAR(100)
);


CREATE TABLE career_path_subjects (
  id SERIAL PRIMARY KEY,
  career_path_id INT REFERENCES career_path(id) ON DELETE CASCADE,
  subject_id INT REFERENCES subject(id) ON DELETE CASCADE,
  requirement subject_requirement_type DEFAULT 'essential',
  UNIQUE (career_path_id, subject_id)
);

CREATE TABLE career_path_tags (
  id SERIAL PRIMARY KEY,
  career_path_id INT REFERENCES career_path(id) ON DELETE CASCADE,
  tag VARCHAR(255) NOT NULL
);

CREATE TABLE career_path_skills (
  id SERIAL PRIMARY KEY,
  career_path_id INT REFERENCES career_path(id) ON DELETE CASCADE,
  skill_id INT REFERENCES skill(id) ON DELETE CASCADE,
  UNIQUE (career_path_id, skill_id)
);


CREATE TABLE college (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  location VARCHAR(255),
  address TEXT,
  email VARCHAR(255),
  phone VARCHAR(100),
  website VARCHAR(255),
  ratings DECIMAL(3,2),
  type college_type_enum,
  state VARCHAR(255),
  scholarship_details TEXT
);

CREATE TABLE course (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  duration VARCHAR(100),
  description TEXT
);

CREATE TABLE college_courses (
  id SERIAL PRIMARY KEY,
  college_id INT REFERENCES college(id) ON DELETE CASCADE,
  course_id INT REFERENCES course(id) ON DELETE CASCADE,
  seats INT,
  fees DECIMAL(10,2),
  scholarship_details TEXT,
  course_page_url VARCHAR(512),
  UNIQUE (college_id, course_id)
);

CREATE TABLE college_course_job (
  id SERIAL PRIMARY KEY,
  job_id INT REFERENCES career_job_opportunity(id) ON DELETE CASCADE,
  college_id INT REFERENCES college(id) ON DELETE CASCADE,
  course_id INT REFERENCES course(id) ON DELETE CASCADE,
  UNIQUE (job_id, college_id, course_id)
);

CREATE TABLE course_skills (
  id SERIAL PRIMARY KEY,
  course_id INT REFERENCES course(id) ON DELETE CASCADE,
  skill_id INT REFERENCES skill(id) ON DELETE CASCADE,
  UNIQUE (course_id, skill_id)
);

CREATE TABLE course_entrance_exams (
  id SERIAL PRIMARY KEY,
  course_id INT REFERENCES course(id) ON DELETE CASCADE,
  exam_id INT REFERENCES entrance_exam(id) ON DELETE CASCADE,
  UNIQUE (course_id, exam_id)
);
