-- Kategoriler tablosu
CREATE TABLE categories (
    category_id SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Üyeler tablosu
CREATE TABLE members (
    member_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    profile_picture VARCHAR(255),
    bio TEXT,
    level SMALLINT DEFAULT 1,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Eğitimler tablosu
CREATE TABLE courses (
    course_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    instructor VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    category_id SMALLINT REFERENCES categories(category_id),
    price DECIMAL(10, 2) DEFAULT 0.00,
    duration_hours SMALLINT,
    difficulty_level VARCHAR(20),
    thumbnail_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT valid_dates CHECK (end_date > start_date)
);

-- Katılımlar tablosu
CREATE TABLE enrollments (
    enrollment_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    member_id BIGINT NOT NULL REFERENCES members(member_id),
    course_id BIGINT NOT NULL REFERENCES courses(course_id),
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_status VARCHAR(20) DEFAULT 'ongoing',
    completed_date TIMESTAMP,
    progress_percentage SMALLINT DEFAULT 0,
    UNIQUE (member_id, course_id)
);

-- Sertifikalar tablosu
CREATE TABLE certificates (
    certificate_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    certificate_code VARCHAR(100) NOT NULL UNIQUE,
    issue_date DATE NOT NULL,
    course_id BIGINT NOT NULL REFERENCES courses(course_id),
    template_path VARCHAR(255),
    expiration_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sertifika Atamaları tablosu
CREATE TABLE certificate_assignments (
    assignment_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    member_id BIGINT NOT NULL REFERENCES members(member_id),
    certificate_id BIGINT NOT NULL REFERENCES certificates(certificate_id),
    assignment_date DATE DEFAULT CURRENT_DATE,
    UNIQUE (member_id, certificate_id)
);

-- Blog Gönderileri tablosu
CREATE TABLE blog_posts (
    post_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id BIGINT NOT NULL REFERENCES members(member_id),
    publication_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP,
    view_count INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT TRUE,
    slug VARCHAR(255) UNIQUE,
    featured_image VARCHAR(255)
);

-- Kullanıcı seviye geçmişi tablosu (opsiyonel)
CREATE TABLE member_level_history (
    history_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    member_id BIGINT NOT NULL REFERENCES members(member_id),
    previous_level SMALLINT NOT NULL,
    new_level SMALLINT NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_reason VARCHAR(100)
);

-- Eğitim değerlendirmeleri tablosu (opsiyonel)
CREATE TABLE course_reviews (
    review_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_id BIGINT NOT NULL REFERENCES courses(course_id),
    member_id BIGINT NOT NULL REFERENCES members(member_id),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (course_id, member_id)
);

-- Indexler
CREATE INDEX idx_member_email ON members(email);
CREATE INDEX idx_course_category ON courses(category_id);
CREATE INDEX idx_enrollment_member ON enrollments(member_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_certificate_course ON certificates(course_id);
CREATE INDEX idx_blog_post_author ON blog_posts(author_id);