-- Enums
CREATE TYPE subject_requirement_type AS ENUM ('essential', 'optional');
CREATE TYPE college_type_enum AS ENUM ('Public', 'Private', 'Other');

-- Base tables
CREATE TABLE career_cluster (
  career_cluster_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE stream (
  stream_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE subject (
  subject_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE skill (
  skill_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE career_job_opportunity (
  job_id SERIAL PRIMARY KEY,
  job_title VARCHAR(255) NOT NULL
);

CREATE TABLE entrance_exam (
  exam_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT
);

-- Career Path
CREATE TABLE career_path (
  career_path_id SERIAL PRIMARY KEY,
  career_cluster_id INT REFERENCES career_cluster(career_cluster_id) ON DELETE SET NULL,
  stream_id INT REFERENCES stream(stream_id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  highlights TEXT,
  type VARCHAR(100)
);

-- Junctions
CREATE TABLE career_path_subjects (
  career_path_id INT REFERENCES career_path(career_path_id) ON DELETE CASCADE,
  subject_id INT REFERENCES subject(subject_id) ON DELETE CASCADE,
  requirement subject_requirement_type DEFAULT 'essential',
  PRIMARY KEY (career_path_id, subject_id)
);

CREATE TABLE career_path_tags (
  id SERIAL PRIMARY KEY,
  career_path_id INT REFERENCES career_path(career_path_id) ON DELETE CASCADE,
  tag VARCHAR(255) NOT NULL
);

CREATE TABLE career_path_skills (
  career_path_id INT REFERENCES career_path(career_path_id) ON DELETE CASCADE,
  skill_id INT REFERENCES skill(skill_id) ON DELETE CASCADE,
  PRIMARY KEY (career_path_id, skill_id)
);

-- College / Course entities
CREATE TABLE college (
  college_id SERIAL PRIMARY KEY,
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
  course_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  duration VARCHAR(100),
  description TEXT
);

CREATE TABLE college_courses (
  college_id INT REFERENCES college(college_id) ON DELETE CASCADE,
  course_id INT REFERENCES course(course_id) ON DELETE CASCADE,
  seats INT,
  fees DECIMAL(10,2),
  scholarship_details TEXT,
  course_page_url VARCHAR(512),
  PRIMARY KEY (college_id, course_id)
);

CREATE TABLE college_course_job (
  job_id INT REFERENCES career_job_opportunity(job_id) ON DELETE CASCADE,
  college_id INT REFERENCES college(college_id) ON DELETE CASCADE,
  course_id INT REFERENCES course(course_id) ON DELETE CASCADE,
  PRIMARY KEY (job_id, college_id, course_id)
);

CREATE TABLE course_skills (
  course_id INT REFERENCES course(course_id) ON DELETE CASCADE,
  skill_id INT REFERENCES skill(skill_id) ON DELETE CASCADE,
  PRIMARY KEY (course_id, skill_id)
);

CREATE TABLE course_entrance_exams (
  course_id INT REFERENCES course(course_id) ON DELETE CASCADE,
  exam_id INT REFERENCES entrance_exam(exam_id) ON DELETE CASCADE,
  PRIMARY KEY (course_id, exam_id)
);