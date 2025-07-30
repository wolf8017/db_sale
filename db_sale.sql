/*
DROP DATABASE IF EXISTS db_sale;
CREATE DATABASE db_sale DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  */
USE db_sale;
ALTER DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Drop tables trong thứ tự ngược lại để tránh lỗi foreign key
DROP TABLE IF EXISTS contact_messages;
DROP TABLE IF EXISTS newsletter_subscribers;
DROP TABLE IF EXISTS trust_badges;
DROP TABLE IF EXISTS popups;
DROP TABLE IF EXISTS notification_bars;
DROP TABLE IF EXISTS social_media;
DROP TABLE IF EXISTS footer_links;
DROP TABLE IF EXISTS footer_sections;
DROP TABLE IF EXISTS homepage_stats;
DROP TABLE IF EXISTS testimonials;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS article_categories;
DROP TABLE IF EXISTS featured_items;
DROP TABLE IF EXISTS featured_sections;
DROP TABLE IF EXISTS banners;
DROP TABLE IF EXISTS banner_positions;
DROP TABLE IF EXISTS hero_sliders;
DROP TABLE IF EXISTS navigation_menus;
DROP TABLE IF EXISTS site_settings;

-- Drop views nếu có
DROP VIEW IF EXISTS active_banners;
DROP VIEW IF EXISTS featured_content;

-- Drop procedures nếu có
DROP PROCEDURE IF EXISTS GetHomepageData;
DROP PROCEDURE IF EXISTS GetFooterData;
DROP PROCEDURE IF EXISTS GetNavigationMenu;

-- =============================
-- BẢNG MENU ĐIỀU HƯỚNG (NAVIGATION_MENUS)
-- =============================
CREATE TABLE navigation_menus
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    slug          VARCHAR(150) NOT NULL UNIQUE,
    url           VARCHAR(255),
    icon          VARCHAR(100) COMMENT 'CSS class hoặc tên icon',
    parent_id     INT         DEFAULT NULL,
    position      VARCHAR(50) DEFAULT 'header' COMMENT 'header, footer, sidebar, mobile',
    display_order INT         DEFAULT 0,
    is_megamenu   TINYINT(1)  DEFAULT 0 COMMENT '1: có submenu lớn, 0: submenu thường',
    target        VARCHAR(20) DEFAULT '_self',
    created_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status        TINYINT(1)  DEFAULT 1,
    FOREIGN KEY (parent_id) REFERENCES navigation_menus (id),
    INDEX idx_position_order (position, display_order)
);

-- =============================
-- BẢNG CẤU HÌNH WEBSITE (SITE_SETTINGS)
-- =============================
CREATE TABLE site_settings
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    setting_key   VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    setting_type  VARCHAR(50)  DEFAULT 'text' COMMENT 'text, number, boolean, json, file',
    description   TEXT,
    group_name    VARCHAR(100) DEFAULT 'general',
    display_order INT          DEFAULT 0,
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================
-- BẢNG SLIDER/CAROUSEL TRANG CHỦ (HERO_SLIDERS)
-- =============================
CREATE TABLE hero_sliders
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    title            VARCHAR(255) NOT NULL,
    subtitle         VARCHAR(255),
    description      TEXT,
    image_desktop    VARCHAR(500) NOT NULL,
    image_mobile     VARCHAR(500),
    image_alt        VARCHAR(255) COMMENT 'Alt text cho SEO',
    background_color VARCHAR(20),
    text_color       VARCHAR(20),

    -- Button configuration
    button_text      VARCHAR(100),
    button_url       VARCHAR(255),
    button_style     VARCHAR(50) DEFAULT 'primary' COMMENT 'primary, secondary, outline',
    button_target    VARCHAR(20) DEFAULT '_self',

    -- Display settings
    display_order    INT         DEFAULT 0,
    animation_type   VARCHAR(50) DEFAULT 'fade' COMMENT 'fade, slide, zoom, none',
    slide_duration   INT         DEFAULT 5000 COMMENT 'Thời gian hiển thị (ms)',

    -- Scheduling
    start_date       TIMESTAMP    NULL,
    end_date         TIMESTAMP    NULL,

    -- Device targeting
    show_on_desktop  TINYINT(1)  DEFAULT 1,
    show_on_mobile   TINYINT(1)  DEFAULT 1,
    show_on_tablet   TINYINT(1)  DEFAULT 1,

    created_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status           TINYINT(1)  DEFAULT 1,

    INDEX idx_display (status, start_date, end_date, display_order)
);

-- =============================
-- BẢNG SECTION NỔI BẬT (FEATURED_SECTIONS)
-- =============================
CREATE TABLE IF NOT EXISTS featured_sections
(
    id                   INT PRIMARY KEY AUTO_INCREMENT,
    section_key          VARCHAR(100) NOT NULL UNIQUE COMMENT 'Key để identify section',
    title                VARCHAR(255) NOT NULL,
    subtitle             VARCHAR(255),
    description          TEXT,

    -- Layout settings
    layout_type          VARCHAR(50)  DEFAULT 'grid' COMMENT 'grid, carousel, list, masonry',
    items_per_row        INT          DEFAULT 4,
    max_items            INT          DEFAULT 8,

    -- Display settings
    show_view_all        TINYINT(1)   DEFAULT 1,
    view_all_text        VARCHAR(100) DEFAULT 'Xem tất cả',
    view_all_url         VARCHAR(255),

    -- Design
    background_color     VARCHAR(20),
    background_image     VARCHAR(500),
    text_align           VARCHAR(20)  DEFAULT 'left' COMMENT 'left, center, right',

    -- Position
    page_position        VARCHAR(50)  DEFAULT 'homepage' COMMENT 'homepage, category, product',
    display_order        INT          DEFAULT 0,

    -- Responsive
    mobile_items_per_row INT          DEFAULT 2,
    tablet_items_per_row INT          DEFAULT 3,

    created_at           TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status               TINYINT(1)   DEFAULT 1,

    INDEX idx_page_order (page_position, display_order)
);

-- =============================
-- BẢNG ITEM TRONG SECTION NỔI BẬT (FEATURED_ITEMS)
-- =============================
CREATE TABLE featured_items
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    section_id       INT          NOT NULL,
    title            VARCHAR(255) NOT NULL,
    subtitle         VARCHAR(255),
    description      TEXT,
    image_url        VARCHAR(500),
    link_url         VARCHAR(500),
    link_target      VARCHAR(20) DEFAULT '_self',

    -- Badge/Label
    badge_text       VARCHAR(50) COMMENT 'NEW, HOT, SALE, etc.',
    badge_color      VARCHAR(20),
    badge_background VARCHAR(20),

    -- Display
    display_order    INT         DEFAULT 0,

    -- Design
    background_color VARCHAR(20),
    text_color       VARCHAR(20),

    created_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status           TINYINT(1)  DEFAULT 1,

    FOREIGN KEY (section_id) REFERENCES featured_sections (id) ON DELETE CASCADE,
    INDEX idx_section_order (section_id, display_order)
);

DROP TABLE IF EXISTS featured_section_items;
-- =============================
-- BẢNG LIÊN KẾT SECTION NỔI BẬT VỚI CONTENT (FEATURED_SECTION_ITEMS)
-- =============================
CREATE TABLE featured_section_items
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    section_id    INT         NOT NULL,
    item_type     VARCHAR(50) NOT NULL COMMENT 'product, category, banner, article',
    item_id       INT         NOT NULL,
    display_order INT       DEFAULT 0,
    custom_title  VARCHAR(255) COMMENT 'Tiêu đề tùy chỉnh nếu khác với item gốc',
    custom_image  VARCHAR(500) COMMENT 'Hình ảnh tùy chỉnh nếu khác với item gốc',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES featured_sections (id)
);

-- =============================
-- BẢNG VỊ TRÍ BANNER (BANNER_POSITIONS)
-- =============================
CREATE TABLE banner_positions
(
    id                 INT PRIMARY KEY AUTO_INCREMENT,
    code               VARCHAR(50)  NOT NULL UNIQUE COMMENT 'Mã vị trí (dùng trong code)',
    name               VARCHAR(100) NOT NULL COMMENT 'Tên hiển thị vị trí',
    description        TEXT COMMENT 'Mô tả vị trí',
    max_banners        INT         DEFAULT 5 COMMENT 'Số lượng banner tối đa có thể hiển thị cùng lúc',
    recommended_width  INT COMMENT 'Chiều rộng khuyến nghị (px)',
    recommended_height INT COMMENT 'Chiều cao khuyến nghị (px)',
    layout_type        VARCHAR(50) DEFAULT 'single' COMMENT 'single, carousel, grid',
    created_at         TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status             TINYINT(1)  DEFAULT 1
);

-- =============================
-- BẢNG BANNER (BANNERS)
-- =============================
CREATE TABLE banners
(
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    position_code       VARCHAR(50)  NOT NULL,
    title               VARCHAR(255) NOT NULL COMMENT 'Tiêu đề banner',
    description         TEXT COMMENT 'Mô tả chi tiết banner',

    -- Images
    image_desktop       VARCHAR(500) NOT NULL,
    image_mobile        VARCHAR(500),
    image_alt           VARCHAR(255),

    -- Link settings
    link_url            VARCHAR(500),
    link_target         VARCHAR(20)           DEFAULT '_self',

    -- Display priority
    priority            INT          NOT NULL DEFAULT 0 COMMENT 'Độ ưu tiên hiển thị (số càng cao càng ưu tiên)',
    display_order       INT          NOT NULL DEFAULT 0 COMMENT 'Thứ tự sắp xếp trong cùng vị trí',

    -- Scheduling
    start_date          TIMESTAMP    NULL,
    end_date            TIMESTAMP    NULL,

    -- Targeting
    show_for_guests     TINYINT(1)            DEFAULT 1,
    show_for_users      TINYINT(1)            DEFAULT 1,
    device_type         VARCHAR(20)           DEFAULT 'all' COMMENT 'all, desktop, mobile, tablet',

    -- Design
    banner_type         VARCHAR(50)           DEFAULT 'image' COMMENT 'image, video, html',
    animation_type      VARCHAR(50)           DEFAULT 'none' COMMENT 'none, fade, slide, zoom',
    background_color    VARCHAR(20),
    text_color          VARCHAR(20),

    -- Text overlay
    overlay_title       VARCHAR(255),
    overlay_subtitle    VARCHAR(255),
    overlay_button_text VARCHAR(100),
    overlay_position    VARCHAR(50)           DEFAULT 'center' COMMENT 'left, center, right, top-left, etc.',

    -- Statistics
    view_count          INT                   DEFAULT 0,
    click_count         INT                   DEFAULT 0,

    created_at          TIMESTAMP             DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status              TINYINT(1)            DEFAULT 1,

    FOREIGN KEY (position_code) REFERENCES banner_positions (code),
    INDEX idx_position_priority (position_code, priority DESC, display_order ASC),
    INDEX idx_status_dates (status, start_date, end_date)
);

-- =============================
-- BẢNG DANH MỤC BÀI VIẾT (ARTICLE_CATEGORIES)
-- =============================
CREATE TABLE article_categories
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    name             VARCHAR(100) NOT NULL,
    slug             VARCHAR(150) NOT NULL UNIQUE,
    description      TEXT,
    image_url        VARCHAR(500),
    parent_id        INT        DEFAULT NULL,
    display_order    INT        DEFAULT 0,

    -- SEO
    meta_title       VARCHAR(255),
    meta_description VARCHAR(500),

    created_at       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status           TINYINT(1) DEFAULT 1,

    FOREIGN KEY (parent_id) REFERENCES article_categories (id),
    INDEX idx_parent_order (parent_id, display_order)
);

-- =============================
-- BẢNG BÀI VIẾT (ARTICLES)
-- =============================
CREATE TABLE articles
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    category_id      INT,
    title            VARCHAR(255) NOT NULL,
    slug             VARCHAR(255) NOT NULL UNIQUE,
    excerpt          TEXT,
    content          LONGTEXT     NOT NULL,
    featured_image   VARCHAR(500),

    -- Publishing
    author_name      VARCHAR(100) DEFAULT 'Admin',
    published_at     TIMESTAMP    NULL,

    -- Statistics
    view_count       INT          DEFAULT 0,
    reading_time     INT COMMENT 'Thời gian đọc (phút)',

    -- Featured
    is_featured      TINYINT(1)   DEFAULT 0,
    is_trending      TINYINT(1)   DEFAULT 0,
    featured_order   INT          DEFAULT 0,

    -- SEO
    meta_title       VARCHAR(255),
    meta_description VARCHAR(500),
    meta_keywords    VARCHAR(500),

    created_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status           TINYINT(1)   DEFAULT 1,

    FOREIGN KEY (category_id) REFERENCES article_categories (id),
    INDEX idx_published (status, published_at DESC),
    INDEX idx_featured (is_featured, featured_order),
    INDEX idx_category (category_id, published_at DESC)
);

-- =============================
-- BẢNG ĐÁNH GIÁ KHÁCH HÀNG (TESTIMONIALS)
-- =============================
CREATE TABLE testimonials
(
    id                INT PRIMARY KEY AUTO_INCREMENT,
    customer_name     VARCHAR(100) NOT NULL,
    customer_avatar   VARCHAR(500),
    customer_title    VARCHAR(255) COMMENT 'Chức danh/công ty',
    customer_location VARCHAR(100),

    -- Content
    rating            TINYINT CHECK (rating BETWEEN 1 AND 5),
    title             VARCHAR(255),
    content           TEXT         NOT NULL,

    -- Display
    is_featured       TINYINT(1) DEFAULT 0,
    display_order     INT        DEFAULT 0,

    -- Design
    background_color  VARCHAR(20),
    text_color        VARCHAR(20),

    created_at        TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status            TINYINT(1) DEFAULT 1,

    INDEX idx_featured_order (is_featured, display_order)
);

-- =============================
-- BẢNG THỐNG KÊ TRANG CHỦ (HOMEPAGE_STATS)
-- =============================
CREATE TABLE homepage_stats
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    stat_key         VARCHAR(50)  NOT NULL UNIQUE,
    stat_value       VARCHAR(100) NOT NULL,
    stat_label       VARCHAR(255) NOT NULL,
    stat_description TEXT,

    -- Icon/Image
    icon             VARCHAR(100),
    icon_color       VARCHAR(20),
    image_url        VARCHAR(500),

    -- Display
    display_order    INT         DEFAULT 0,
    is_animated      TINYINT(1)  DEFAULT 1,
    animation_type   VARCHAR(50) DEFAULT 'countup' COMMENT 'countup, fadein, slideup',

    -- Design
    background_color VARCHAR(20),
    text_color       VARCHAR(20),

    created_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status           TINYINT(1)  DEFAULT 1,

    INDEX idx_display_order (display_order)
);

-- =============================
-- BẢNG FOOTER SECTIONS (FOOTER_SECTIONS)
-- =============================
CREATE TABLE footer_sections
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    section_title   VARCHAR(100) NOT NULL,
    section_type    VARCHAR(50) DEFAULT 'links' COMMENT 'links, contact, social, newsletter, custom',
    column_position INT         DEFAULT 1 COMMENT 'Cột số mấy trong footer',
    display_order   INT         DEFAULT 0,

    -- Custom content for non-link sections
    custom_content  TEXT,

    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status          TINYINT(1)  DEFAULT 1,

    INDEX idx_column_order (column_position, display_order)
);

-- =============================
-- BẢNG FOOTER LINKS (FOOTER_LINKS)
-- =============================
CREATE TABLE footer_links
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    section_id    INT          NOT NULL,
    title         VARCHAR(255) NOT NULL,
    url           VARCHAR(500) NOT NULL,
    icon          VARCHAR(100),
    target        VARCHAR(20) DEFAULT '_self',
    display_order INT         DEFAULT 0,

    created_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status        TINYINT(1)  DEFAULT 1,

    FOREIGN KEY (section_id) REFERENCES footer_sections (id) ON DELETE CASCADE,
    INDEX idx_section_order (section_id, display_order)
);

-- =============================
-- BẢNG SOCIAL MEDIA (SOCIAL_MEDIA)
-- =============================
CREATE TABLE social_media
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    platform       VARCHAR(50)  NOT NULL COMMENT 'facebook, twitter, instagram, youtube, tiktok, discord, telegram',
    platform_name  VARCHAR(100) NOT NULL,
    url            VARCHAR(500) NOT NULL,
    icon           VARCHAR(100),
    color          VARCHAR(20) COMMENT 'Brand color of platform',
    follower_count VARCHAR(50),
    display_order  INT        DEFAULT 0,

    created_at     TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status         TINYINT(1) DEFAULT 1,

    INDEX idx_display_order (display_order)
);

-- =============================
-- BẢNG NOTIFICATION BAR (NOTIFICATION_BARS)
-- =============================
CREATE TABLE notification_bars
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    message          TEXT      NOT NULL,
    message_type     VARCHAR(50) DEFAULT 'info' COMMENT 'info, success, warning, error, promotion',

    -- Design
    background_color VARCHAR(20) DEFAULT '#007bff',
    text_color       VARCHAR(20) DEFAULT '#ffffff',

    -- Button
    button_text      VARCHAR(100),
    button_url       VARCHAR(500),
    button_target    VARCHAR(20) DEFAULT '_self',

    -- Behavior
    is_dismissible   TINYINT(1)  DEFAULT 1,
    is_sticky        TINYINT(1)  DEFAULT 0,
    position         VARCHAR(50) DEFAULT 'top' COMMENT 'top, bottom, fixed-top, fixed-bottom',

    -- Scheduling
    start_date       TIMESTAMP NULL,
    end_date         TIMESTAMP NULL,

    -- Priority
    display_order    INT         DEFAULT 0,

    created_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status           TINYINT(1)  DEFAULT 1,

    INDEX idx_active_order (status, start_date, end_date, display_order)
);

-- =============================
-- BẢNG POPUPS (POPUPS)
-- =============================
CREATE TABLE popups
(
    id                      INT PRIMARY KEY AUTO_INCREMENT,
    title                   VARCHAR(255) NOT NULL,
    content                 TEXT         NOT NULL,

    -- Type and trigger
    popup_type              VARCHAR(50) DEFAULT 'promotion' COMMENT 'promotion, newsletter, announcement, cookie, survey',
    trigger_type            VARCHAR(50) DEFAULT 'time' COMMENT 'time, exit_intent, scroll, click, page_count',
    trigger_value           INT COMMENT 'Giá trị trigger (giây, %, số trang)',

    -- Media
    image_url               VARCHAR(500),
    video_url               VARCHAR(500),

    -- Buttons
    primary_button_text     VARCHAR(100),
    primary_button_url      VARCHAR(500),
    primary_button_action   VARCHAR(50) DEFAULT 'redirect' COMMENT 'redirect, close, submit',
    secondary_button_text   VARCHAR(100),
    secondary_button_action VARCHAR(50) DEFAULT 'close',

    -- Design
    position                VARCHAR(50) DEFAULT 'center' COMMENT 'center, bottom-right, top-banner, fullscreen',
    size                    VARCHAR(50) DEFAULT 'medium' COMMENT 'small, medium, large, fullwidth',
    background_color        VARCHAR(20),
    text_color              VARCHAR(20),

    -- Behavior
    display_frequency       VARCHAR(50) DEFAULT 'once_per_session' COMMENT 'always, once_per_session, once_per_day, once_per_week',
    auto_close_delay        INT         DEFAULT 0 COMMENT 'Tự động đóng sau X giây (0 = không tự đóng)',

    -- Targeting
    target_pages            TEXT COMMENT 'JSON array của pages để hiển thị',
    exclude_pages           TEXT COMMENT 'JSON array của pages loại trừ',
    show_for_mobile         TINYINT(1)  DEFAULT 1,
    show_for_desktop        TINYINT(1)  DEFAULT 1,

    -- Scheduling
    start_date              TIMESTAMP    NULL,
    end_date                TIMESTAMP    NULL,

    -- Statistics
    view_count              INT         DEFAULT 0,
    click_count             INT         DEFAULT 0,
    conversion_count        INT         DEFAULT 0,

    created_at              TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status                  TINYINT(1)  DEFAULT 1,

    INDEX idx_active (status, start_date, end_date)
);

-- =============================
-- BẢNG TRUST BADGES (TRUST_BADGES)
-- =============================
CREATE TABLE trust_badges
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    name             VARCHAR(100) NOT NULL,
    description      TEXT,
    image_url        VARCHAR(500) NOT NULL,
    image_alt        VARCHAR(255),

    -- Link
    link_url         VARCHAR(500),
    link_target      VARCHAR(20) DEFAULT '_blank',

    -- Category
    badge_type       VARCHAR(50) COMMENT 'security, payment, certificate, award, partner',

    -- Display
    display_order    INT         DEFAULT 0,
    show_on_homepage TINYINT(1)  DEFAULT 1,
    show_on_footer   TINYINT(1)  DEFAULT 1,
    show_on_checkout TINYINT(1)  DEFAULT 1,

    created_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status           TINYINT(1)  DEFAULT 1,

    INDEX idx_display_order (display_order),
    INDEX idx_type_order (badge_type, display_order)
);

-- =============================
-- BẢNG ĐĂNG KÝ NHẬN TIN (NEWSLETTER_SUBSCRIBERS)
-- =============================
CREATE TABLE newsletter_subscribers
(
    id                   INT PRIMARY KEY AUTO_INCREMENT,
    email                VARCHAR(255) NOT NULL UNIQUE,
    name                 VARCHAR(100),

    -- Subscription details
    subscribed_at        TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    unsubscribed_at      TIMESTAMP    NULL,
    status               TINYINT(1)  DEFAULT 1 COMMENT '1: active, 0: unsubscribed',

    -- Source tracking
    source               VARCHAR(100) COMMENT 'homepage, footer, popup, product_page',
    ip_address           VARCHAR(45),
    user_agent           TEXT,

    -- Preferences
    preferred_categories TEXT COMMENT 'JSON array of interested categories',
    frequency            VARCHAR(50) DEFAULT 'weekly' COMMENT 'daily, weekly, monthly'
);

-- =============================
-- BẢNG LIÊN HỆ (CONTACT_MESSAGES)
-- =============================
CREATE TABLE contact_messages
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL,
    phone         VARCHAR(20),
    subject       VARCHAR(255),
    message       TEXT         NOT NULL,

    -- Categorization
    category      VARCHAR(100) DEFAULT 'general' COMMENT 'general, support, sales, partnership, complaint',
    priority      VARCHAR(20)  DEFAULT 'normal' COMMENT 'low, normal, high, urgent',

    -- Tracking
    ip_address    VARCHAR(45),
    user_agent    TEXT,
    source_page   VARCHAR(500),

    -- Status
    status        TINYINT      DEFAULT 0 COMMENT '0: new, 1: read, 2: in_progress, 3: replied, 4: closed',
    replied_at    TIMESTAMP    NULL,
    replied_by    VARCHAR(100),
    reply_message TEXT,

    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_status_created (status, created_at DESC),
    INDEX idx_category_status (category, status)
);

-- =============================
-- VIEW BANNER ĐANG HOẠT ĐỘNG (ACTIVE_BANNERS)
-- =============================
CREATE VIEW active_banners AS
SELECT b.*,
       bp.name as position_name,
       bp.max_banners,
       bp.layout_type
FROM banners b
         JOIN banner_positions bp ON b.position_code = bp.code
WHERE b.status = 1
  AND (b.start_date IS NULL OR b.start_date <= NOW())
  AND (b.end_date IS NULL OR b.end_date >= NOW())
  AND bp.status = 1;

-- =============================
-- VIEW NỘI DUNG NỔI BẬT (FEATURED_CONTENT)
-- =============================
CREATE VIEW featured_content AS
SELECT 'article'                    as content_type,
       a.id,
       a.title,
       a.slug,
       a.excerpt                    as description,
       a.featured_image             as image_url,
       CONCAT('/articles/', a.slug) as url,
       a.published_at               as date_created,
       a.featured_order             as display_order
FROM articles a
WHERE a.status = 1
  AND a.is_featured = 1
  AND a.published_at <= NOW()

UNION ALL

SELECT 'section_item' as content_type,
       fi.id,
       fi.title,
       fs.section_key as slug,
       fi.description,
       fi.image_url,
       fi.link_url    as url,
       fi.created_at  as date_created,
       fi.display_order
FROM featured_items fi
         JOIN featured_sections fs ON fi.section_id = fs.id
WHERE fi.status = 1
  AND fs.status = 1;

-- =============================
-- PROCEDURE LẤY DỮ LIỆU TRANG CHỦ (GETHOMEPAGEDATA)
-- =============================
DELIMITER //
CREATE PROCEDURE GetHomepageData()
BEGIN
    -- Hero sliders
    SELECT *
    FROM hero_sliders
    WHERE status = 1
      AND (start_date IS NULL OR start_date <= NOW())
      AND (end_date IS NULL OR end_date >= NOW())
    ORDER BY display_order;

    -- Featured sections với items
    SELECT fs.*,
           JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'id', fi.id,
                           'title', fi.title,
                           'subtitle', fi.subtitle,
                           'description', fi.description,
                           'image_url', fi.image_url,
                           'link_url', fi.link_url,
                           'badge_text', fi.badge_text,
                           'badge_color', fi.badge_color
                   )
           ) as items
    FROM featured_sections fs
             LEFT JOIN featured_items fi ON fs.id = fi.section_id AND fi.status = 1
    WHERE fs.status = 1
      AND fs.page_position = 'homepage'
    GROUP BY fs.id, fs.display_order
    ORDER BY fs.display_order;

    -- Danh mục sản phẩm nổi bật
    SELECT pc.id,
           pc.name,
           pc.slug,
           pc.description,
           pc.image_url,
           pc.icon,
           pc.display_order,
           pc.is_featured,
           pc.show_on_homepage,
           -- Thông tin danh mục cha
           parent.name                                                       as parent_name,
           parent.slug                                                       as parent_slug,
           -- Đếm số lượng danh mục con
           (SELECT COUNT(*) FROM product_categories WHERE parent_id = pc.id) as subcategory_count
    FROM product_categories pc
             LEFT JOIN product_categories parent ON pc.parent_id = parent.id
    WHERE pc.status = 1
      AND (pc.is_featured = 1 OR pc.show_on_homepage = 1)
    ORDER BY pc.display_order;

    -- Latest articles
    SELECT *
    FROM articles
    WHERE status = 1
      AND published_at <= NOW()
    ORDER BY published_at DESC
    LIMIT 6;

    -- Featured testimonials
    SELECT *
    FROM testimonials
    WHERE status = 1
      AND is_featured = 1
    ORDER BY display_order
    LIMIT 3;

    -- Homepage stats
    SELECT *
    FROM homepage_stats
    WHERE status = 1
    ORDER BY display_order;

    -- Trust badges
    SELECT *
    FROM trust_badges
    WHERE status = 1
      AND show_on_homepage = 1
    ORDER BY display_order;

    -- Active notification bars
    SELECT *
    FROM notification_bars
    WHERE status = 1
      AND (start_date IS NULL OR start_date <= NOW())
      AND (end_date IS NULL OR end_date >= NOW())
    ORDER BY display_order;
END //
DELIMITER ;

-- =============================
-- PROCEDURE LẤY DỮ LIỆU FOOTER (GETFOOTERDATA)
-- =============================
DELIMITER //
CREATE PROCEDURE GetFooterData()
BEGIN
    -- Footer sections với links
    SELECT fs.*,
           JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'id', fl.id,
                           'title', fl.title,
                           'url', fl.url,
                           'icon', fl.icon,
                           'target', fl.target
                   )
           ) as links
    FROM footer_sections fs
             LEFT JOIN footer_links fl ON fs.id = fl.section_id AND fl.status = 1
    WHERE fs.status = 1
    GROUP BY fs.id, fs.column_position, fs.display_order
    ORDER BY fs.column_position, fs.display_order;

    -- Social media
    SELECT *
    FROM social_media
    WHERE status = 1
    ORDER BY display_order;

    -- Trust badges for footer
    SELECT *
    FROM trust_badges
    WHERE status = 1
      AND show_on_footer = 1
    ORDER BY display_order;
END //
DELIMITER ;

-- =============================
-- PROCEDURE LẤY MENU ĐIỀU HƯỚNG (GETNAVIGATIONMENU)
-- =============================
DELIMITER //
CREATE PROCEDURE GetNavigationMenu(IN menu_position VARCHAR(50))
BEGIN
    SELECT m1.id,
           m1.name,
           m1.slug,
           m1.url,
           m1.icon,
           m1.target,
           m1.is_megamenu,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'id', m2.id,
                                   'name', m2.name,
                                   'slug', m2.slug,
                                   'url', m2.url,
                                   'icon', m2.icon,
                                   'target', m2.target
                           )
                   )
            FROM navigation_menus m2
            WHERE m2.parent_id = m1.id
              AND m2.status = 1
            ORDER BY m2.display_order) as children
    FROM navigation_menus m1
    WHERE m1.parent_id IS NULL
      AND m1.position = menu_position
      AND m1.status = 1
    ORDER BY m1.display_order;
END //
DELIMITER ;

DROP TABLE IF EXISTS users;
-- =============================
-- BẢNG NGƯỜI DÙNG (USERS)
-- =============================
CREATE TABLE users
(
    id                    INT PRIMARY KEY AUTO_INCREMENT,                                                              -- Unique user ID, auto-incremented
    username              VARCHAR(100) NOT NULL UNIQUE,                                                                -- Username, required and unique
    password              VARCHAR(255) NOT NULL,                                                                       -- Password (hashed), required
    email                 VARCHAR(255) NOT NULL UNIQUE,                                                                -- Email, required and unique

    -- Social login
    google_id             VARCHAR(50) UNIQUE,                                                                          -- Google user ID (nếu đăng nhập Google)

    -- Phân quyền
    role                  ENUM ('customer', 'admin', 'staff')   DEFAULT 'customer',
    permissions           JSON,

    -- Xác thực 2 bước
    two_factor_enabled    TINYINT(1)                            DEFAULT 0,                                             -- 0: Disabled, 1: Enabled
    two_factor_secret     VARCHAR(32),                                                                                 -- Secret key for 2FA (if enabled)

    -- Optional profile fields
    full_name             VARCHAR(255),                                                                                -- Full name (optional)
    phone                 VARCHAR(20),                                                                                 -- Phone number (optional)
    gender                ENUM ('Nam', 'Nữ', 'Khác')            DEFAULT 'Khác',                                        -- Gender (optional, default 'Khác')
    avatar                VARCHAR(500),                                                                                -- Avatar image URL (optional)
    address               TEXT,                                                                                        -- Address (optional)
    city                  VARCHAR(100),                                                                                -- City (optional)
    district              VARCHAR(100),                                                                                -- District (optional)
    ward                  VARCHAR(100),                                                                                -- Ward (optional)
    postal_code           VARCHAR(20),                                                                                 -- Postal code (optional)

    -- Account balance and payment tracking
    balance               DECIMAL(15, 2)                        DEFAULT 0 COMMENT 'Current account balance',
    total_spent           DECIMAL(15, 2)                        DEFAULT 0 COMMENT 'Total amount paid by user',

    -- Timestamps
    created_at            TIMESTAMP                             DEFAULT CURRENT_TIMESTAMP,                             -- Record creation time
    updated_at            TIMESTAMP                             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    deleted_at            TIMESTAMP    NULL,                                                                           -- Soft delete timestamp (NULL if not deleted)


    -- Trạng thái
    status                ENUM ('active', 'inactive', 'banned') DEFAULT 'active',
    email_verified        TINYINT(1)                            DEFAULT 0 COMMENT '0: Chưa xác minh, 1: Đã xác minh',  -- Email verification status (0: Not verified, 1: Verified

    -- Tracking cơ bản
    last_login_at         TIMESTAMP    NULL,                                                                           -- Last login timestamp
    registration_ip       VARCHAR(45),                                                                                 -- IP address at registration
    failed_login_attempts INT                                   DEFAULT 0,
    last_failed_login     TIMESTAMP    NULL,
    locked_until          TIMESTAMP    NULL,

    -- Referral đơn giản
    referral_code         VARCHAR(20) UNIQUE,                                                                          -- Unique referral code for user
    referred_by           INT,                                                                                         -- User ID of the referrer (NULL if not referred by anyone) COMMENT 'ID của người giới thiệu (NULL nếu không có)'

    FOREIGN KEY (referred_by) REFERENCES users (id) ON DELETE SET NULL,

    -- Indexes
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_status (status),
    INDEX idx_role (role),
    INDEX idx_balance (balance),
    INDEX idx_referral_code (referral_code),
    INDEX idx_last_login (last_login_at),
    INDEX idx_created_at (created_at),
    INDEX idx_city_district (city, district)
);

DROP TRIGGER IF EXISTS trg_suspend_user_before_failed_logins;

DELIMITER $$
CREATE TRIGGER trg_suspend_user_before_failed_logins
    BEFORE UPDATE
    ON users
    FOR EACH ROW
BEGIN
    IF NEW.failed_login_attempts = 5 THEN
        SET NEW.status = 'inactive';
    END IF;
END$$
DELIMITER ;

-- =============================
-- BẢNG LỊCH SỬ HÀNH VI VI PHẠM/QUẢN TRỊ NGƯỜI DÙNG (USER_VIOLATION_LOGS)
-- =============================
CREATE TABLE user_violation_logs
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    user_id    INT                                                                                           NOT NULL, -- User bị tác động
    action     ENUM ('deletion', 'banned', 'unbanned', 'unlock', 'suspend', 'unsuspend', 'warning', 'other') NOT NULL,
    old_status ENUM ('active', 'inactive', 'banned') DEFAULT NULL,                                                     -- Trạng thái trước (giống bảng users)
    new_status ENUM ('active', 'inactive', 'banned') DEFAULT NULL,                                                     -- Trạng thái sau (giống bảng users)
    reason     VARCHAR(500),                                                                                           -- Lý do (nếu có)
    admin_id   INT,                                                                                                    -- Ai thực hiện hành động (admin/staff)
    created_at TIMESTAMP                             DEFAULT CURRENT_TIMESTAMP,
    extra_info TEXT,                                                                                                   -- Thông tin bổ sung (nếu cần)
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (admin_id) REFERENCES users (id)
);

CREATE INDEX idx_user_action ON user_violation_logs (user_id, action, created_at);

-- =============================
-- BẢNG DANH MỤC SẢN PHẨM (PRODUCT_CATEGORIES)
-- =============================
DROP TABLE IF EXISTS product_categories;
CREATE TABLE product_categories
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    name             VARCHAR(100) NOT NULL COMMENT 'Tên danh mục',
    slug             VARCHAR(150) NOT NULL UNIQUE COMMENT 'URL friendly name',
    parent_id        INT        DEFAULT NULL COMMENT 'Danh mục cha (NULL nếu là danh mục gốc)',
    description      TEXT COMMENT 'Mô tả danh mục',
    image_url        VARCHAR(500) COMMENT 'Ảnh đại diện danh mục',
    icon             VARCHAR(100) COMMENT 'Icon danh mục (CSS class)',

    -- Hiển thị
    display_order    INT        DEFAULT 0 COMMENT 'Thứ tự hiển thị',
    is_featured      TINYINT(1) DEFAULT 0 COMMENT '1: nổi bật, 0: bình thường',
    show_on_homepage TINYINT(1) DEFAULT 0 COMMENT '1: hiển thị trang chủ, 0: không hiển thị',

    -- SEO
    meta_title       VARCHAR(255) COMMENT 'Title cho SEO',
    meta_description VARCHAR(500) COMMENT 'Description cho SEO',
    meta_keywords    VARCHAR(500) COMMENT 'Keywords cho SEO',

    -- Trạng thái
    status           TINYINT(1) DEFAULT 1 COMMENT '1: active, 0: inactive',

    -- Timestamps
    created_at       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Foreign key
    FOREIGN KEY (parent_id) REFERENCES product_categories (id) ON DELETE SET NULL,

    -- Indexes
    INDEX idx_parent (parent_id),
    INDEX idx_slug (slug),
    INDEX idx_display_order (display_order),
    INDEX idx_status (status)
);

-- =============================
-- VIEW DANH MỤC SẢN PHẨM (PRODUCT_CATEGORY_VIEW)
-- =============================
DROP VIEW IF EXISTS product_category_view;
CREATE VIEW product_category_view AS
SELECT pc.id,
       pc.name,
       pc.slug,
       pc.description,
       pc.image_url,
       pc.icon,
       pc.display_order,
       pc.is_featured,
       pc.show_on_homepage,
       pc.meta_title,
       pc.meta_description,
       pc.meta_keywords,
       pc.status,
       pc.created_at,
       pc.updated_at,
       -- Thông tin danh mục cha
       parent.name                                                       as parent_name,
       parent.slug                                                       as parent_slug,
       parent.icon                                                       as parent_icon,
       -- Đếm số lượng danh mục con
       (SELECT COUNT(*) FROM product_categories WHERE parent_id = pc.id) as subcategory_count
FROM product_categories pc
         LEFT JOIN product_categories parent ON pc.parent_id = parent.id
WHERE pc.status = 1;

-- =============================
-- BẢNG TAG SẢN PHẨM (PRODUCT_TAGS)
-- =============================
DROP TABLE IF EXISTS product_tags;
CREATE TABLE product_tags
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(100) NOT NULL UNIQUE COMMENT 'Tên tag/nhãn',
    slug       VARCHAR(150) NOT NULL UNIQUE COMMENT 'URL friendly name',
    created_at TIMESTAMP             DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status     TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1: active, 0: inactive'
);

-- =============================
-- BẢNG SẢN PHẨM (PRODUCTS)
-- =============================
DROP TABLE IF EXISTS products;
CREATE TABLE products
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    slug        VARCHAR(255) NOT NULL UNIQUE,
    category_id INT          NOT NULL,
    description TEXT,
    image_url   VARCHAR(500),
    status      TINYINT(1) DEFAULT 1 COMMENT "1: active, 0: inactive",
    total_stock INT        DEFAULT 0 COMMENT 'Tổng tồn kho (cộng từ các package)',
    total_sold  INT        DEFAULT 0 COMMENT 'Tổng đã bán (cộng từ các package)',
    created_at  TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_categories (id),
    INDEX idx_slug (slug),
    INDEX idx_category (category_id),
    INDEX idx_status (status)
);

-- =============================
-- BẢNG GÓI SẢN PHẨM (PRODUCT_PACKAGES)
-- =============================
DROP TABLE IF EXISTS product_packages;
CREATE TABLE product_packages
(
    id                INT PRIMARY KEY AUTO_INCREMENT,
    product_id        INT            NOT NULL,
    name              VARCHAR(255)   NOT NULL,
    description       TEXT,
    price             DECIMAL(15, 2) NOT NULL,
    old_price         DECIMAL(15, 2),
    duration_days     INT,
    percent_off       DECIMAL(5, 2) GENERATED ALWAYS AS (
        IF(old_price IS NOT NULL AND old_price > 0 AND price < old_price, 100 * (old_price - price) / old_price, 0)
        ) STORED,
    stock_quantity    INT                     DEFAULT 0 COMMENT 'Số lượng tồn kho còn lại',
    sold_count        INT                     DEFAULT 0 COMMENT 'Số lượng đã bán',
    details           TEXT COMMENT 'Thông tin chi tiết về gói sản phẩm',
    note              TEXT COMMENT 'Lưu ý riêng cho từng gói sản phẩm',

    -- Loại gói sản phẩm
    package_type      ENUM ('sale', 'rental') DEFAULT 'sale' COMMENT 'sale: bán đứt, rental: cho thuê',

    -- Thông tin VAT và cách tính (1% cho sale, 5% cho rental)
    vat_rate          DECIMAL(4, 3)  NOT NULL DEFAULT 0.01 COMMENT 'Tỷ lệ VAT áp dụng cho gói này (lấy từ vat_settings)',
    status            TINYINT(1)              DEFAULT 1, -- 1: active, 0: inactive
    max_cart_quantity TINYINT(1)              DEFAULT 0 COMMENT 'Số lượng tối đa cho phép trong giỏ hàng (0: không giới hạn, 1: không cho phép thêm nhiều hơn 1)',
    created_at        TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP               DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_name (name),
    INDEX idx_status (status),
    INDEX idx_price (price),
    INDEX idx_percent_off (percent_off)
);

-- =============================
-- BẢNG CẤU HÌNH VAT (VAT_SETTINGS)
-- =============================
DROP TABLE IF EXISTS vat_settings;
CREATE TABLE vat_settings
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    package_type ENUM('sale', 'rental') NOT NULL UNIQUE COMMENT 'Loại gói sản phẩm',
    vat_rate     DECIMAL(4, 3) NOT NULL COMMENT 'Tỷ lệ VAT (0.01 = 1%, 0.05 = 5%)',
    description  VARCHAR(255) COMMENT 'Mô tả',
    is_active    TINYINT(1) DEFAULT 1 COMMENT '1: active, 0: inactive',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_package_type (package_type),
    INDEX idx_is_active (is_active)
);

-- Thêm dữ liệu mặc định cho VAT
INSERT INTO vat_settings (package_type, vat_rate, description, is_active) VALUES
('sale', 0.01, 'VAT cho hàng hóa (bán key/tài khoản)', 1),
('rental', 0.05, 'VAT cho dịch vụ (cho thuê tài khoản)', 1);

-- =============================
-- BẢNG VOUCHER (VOUCHERS)
-- =============================
DROP TABLE IF EXISTS vouchers;
CREATE TABLE vouchers
(
    id                 INT PRIMARY KEY AUTO_INCREMENT,
    code               VARCHAR(50)                NOT NULL UNIQUE,    -- Mã voucher
    description        VARCHAR(255),
    discount_type      ENUM ('amount', 'percent') NOT NULL DEFAULT 'amount',
    discount_value     DECIMAL(15, 2)             NOT NULL DEFAULT 0,
    min_order_value    DECIMAL(15, 2)                      DEFAULT 0, -- Giá trị đơn hàng tối thiểu để áp dụng
    max_discount_value DECIMAL(15, 2),                                -- Giá trị giảm tối đa (nếu là percent)
    start_date         TIMESTAMP                           DEFAULT CURRENT_TIMESTAMP,
    end_date           TIMESTAMP,
    usage_limit        INT                                 DEFAULT 0, -- 0: không giới hạn, >0: số lần sử dụng tối đa
    used_count         INT                                 DEFAULT 0, -- Đã sử dụng bao nhiêu lần
    status             TINYINT(1)                          DEFAULT 1, -- 1: active, 0: inactive
    created_at         TIMESTAMP                           DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP                           DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_status (status),
    INDEX idx_start_end (start_date, end_date),
    INDEX idx_discount_type (discount_type),
    INDEX idx_min_order_value (min_order_value),
    INDEX idx_used_count (used_count)
);

-- Thêm CHECK constraint cho bảng vouchers
ALTER TABLE vouchers
    ADD CONSTRAINT chk_voucher_percent CHECK (
        (discount_type = 'percent' AND discount_value > 0 AND discount_value <= 100)
            OR
        (discount_type = 'amount' AND discount_value > 0)
        );

-- =============================
-- BẢNG VOUCHER ÁP DỤNG CHO SẢN PHẨM/GÓI (VOUCHER_APPLIES)
-- =============================
DROP TABLE IF EXISTS voucher_applies;
CREATE TABLE voucher_applies
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    voucher_id INT NOT NULL,
    package_id INT,
    min_price  DECIMAL(15, 2) DEFAULT 0, -- Giá sản phẩm tối thiểu để áp dụng
    max_price  DECIMAL(15, 2),           -- Giá sản phẩm tối đa để áp dụng (nếu có)
    FOREIGN KEY (voucher_id) REFERENCES vouchers (id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    INDEX idx_voucher (voucher_id),
    INDEX idx_package (package_id),
    INDEX idx_min_max_price (min_price, max_price)
);

-- =============================
-- BẢNG THUỘC TÍNH SẢN PHẨM (PRODUCT_ATTRIBUTES)
-- =============================
DROP TABLE IF EXISTS product_attributes;
CREATE TABLE product_attributes
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    package_id INT          NOT NULL,
    attr_name  VARCHAR(100) NOT NULL,
    attr_value VARCHAR(255) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    INDEX idx_package (package_id),
    INDEX idx_attr_name (attr_name)
);

-- =============================
-- BẢNG ĐÁNH GIÁ SẢN PHẨM (PRODUCT_REVIEWS)
-- =============================
DROP TABLE IF EXISTS product_reviews;
CREATE TABLE product_reviews
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    package_id  INT     NOT NULL,
    user_id     INT,
    rating      TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    INDEX idx_package (package_id),
    INDEX idx_user (user_id),
    INDEX idx_rating (rating)
);

-- =============================
-- BẢNG FAQ SẢN PHẨM (PRODUCT_FAQS)
-- =============================
DROP TABLE IF EXISTS product_faqs;
CREATE TABLE product_faqs
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    package_id    INT  NOT NULL,
    question      TEXT NOT NULL,
    answer        TEXT,
    display_order INT DEFAULT 0,
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    INDEX idx_package (package_id)
);

-- =============================
-- BẢNG TÀI LIỆU SẢN PHẨM (PRODUCT_DOCUMENTS)
-- =============================
DROP TABLE IF EXISTS product_documents;
CREATE TABLE product_documents
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    package_id INT          NOT NULL,
    doc_name   VARCHAR(255) NOT NULL,
    doc_url    VARCHAR(500) NOT NULL,
    doc_type   VARCHAR(50),
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    INDEX idx_package (package_id)
);

-- =============================
-- BẢNG SẢN PHẨM LIÊN QUAN (PRODUCT_RELATED)
-- =============================
DROP TABLE IF EXISTS product_related;
CREATE TABLE product_related
(
    id                 INT PRIMARY KEY AUTO_INCREMENT,
    package_id         INT NOT NULL,
    related_package_id INT NOT NULL,
    relation_type      ENUM ('related', 'upsell', 'cross-sell') DEFAULT 'related',
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    FOREIGN KEY (related_package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    INDEX idx_package (package_id),
    INDEX idx_related (related_package_id)
);

-- =============================
-- BẢNG LIÊN KẾT TAG VỚI GÓI SẢN PHẨM (PRODUCT_TAG_MAP)
-- =============================
DROP TABLE IF EXISTS product_tag_map;
CREATE TABLE product_tag_map
(
    package_id INT NOT NULL,
    tag_id     INT NOT NULL,
    PRIMARY KEY (package_id, tag_id),
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES product_tags (id) ON DELETE CASCADE
);

-- =============================
-- BẢNG ĐƠN HÀNG (ORDERS)
-- =============================
DROP TABLE IF EXISTS orders;
CREATE TABLE orders
(
    id              INT PRIMARY KEY AUTO_INCREMENT,                                                                                       -- Khóa chính, tự tăng
    user_id         INT            NOT NULL,                                                                                              -- Khách hàng đặt đơn (FK users)
    order_code      VARCHAR(50) UNIQUE,                                                                                                   -- Mã đơn hàng duy nhất, cho phép NULL để trigger tự sinh
    status          ENUM ('pending', 'paid', 'completed', 'cancelled', 'refunded') DEFAULT 'pending',                                     -- Trạng thái đơn
    total_amount    DECIMAL(15, 2) NOT NULL,                                                                                              -- Tổng tiền trước giảm giá
    discount_amount DECIMAL(15, 2)                                                 DEFAULT 0,                                             -- Tổng giảm giá
    final_amount    DECIMAL(15, 2) NOT NULL,                                                                                              -- Số tiền phải thanh toán
    payment_status  ENUM ('unpaid', 'paid', 'refunded')                            DEFAULT 'unpaid',                                      -- Trạng thái thanh toán
    note            TEXT,                                                                                                                 -- Ghi chú đơn hàng
    created_at      TIMESTAMP                                                      DEFAULT CURRENT_TIMESTAMP,                             -- Thời gian tạo đơn
    updated_at      TIMESTAMP                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Thời gian cập nhật
    FOREIGN KEY (user_id) REFERENCES users (id),
    INDEX idx_user (user_id),
    INDEX idx_status (status)
);

-- =============================
-- BẢNG CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)
-- =============================
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items
(
    id           INT PRIMARY KEY AUTO_INCREMENT,    -- Khóa chính
    order_id     INT            NOT NULL,           -- FK orders
    package_id   INT            NOT NULL,           -- FK product_packages
    product_name VARCHAR(255)   NOT NULL,           -- Tên sản phẩm tại thời điểm đặt
    quantity     INT            NOT NULL DEFAULT 1, -- Số lượng
    unit_price   DECIMAL(15, 2) NOT NULL,           -- Giá 1 đơn vị
    total_price  DECIMAL(15, 2) NOT NULL,           -- Tổng giá trước giảm giá
    discount     DECIMAL(15, 2)          DEFAULT 0, -- Giảm giá dòng này
    final_price  DECIMAL(15, 2) NOT NULL,           -- Giá sau giảm giá
    extra_info   TEXT COMMENT 'Thông tin bổ sung (tài khoản, email, mật khẩu, custom input, v.v.)',
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES product_packages (id),
    INDEX idx_order (order_id)
);

-- =============================
-- BẢNG GIAO DỊCH THANH TOÁN (PAYMENT_TRANSACTIONS)
-- =============================
DROP TABLE IF EXISTS payment_transactions;
CREATE TABLE payment_transactions
(
    id               INT PRIMARY KEY AUTO_INCREMENT,                                                                          -- Khóa chính
    order_id         INT            NOT NULL,                                                                                 -- Đơn hàng liên quan (FK orders)
    payment_method   VARCHAR(50)    NOT NULL,                                                                                 -- Phương thức thanh toán (momo, bank, ...)
    amount           DECIMAL(15, 2) NOT NULL,                                                                                 -- Số tiền giao dịch
    transaction_code VARCHAR(100),                                                                                            -- Mã giao dịch từ cổng thanh toán
    status           ENUM ('pending', 'success', 'failed', 'refunded') DEFAULT 'pending',                                     -- Trạng thái giao dịch
    created_at       TIMESTAMP                                         DEFAULT CURRENT_TIMESTAMP,                             -- Thời gian tạo giao dịch
    updated_at       TIMESTAMP                                         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Thời gian cập nhật trạng thái
    note             TEXT,                                                                                                    -- Ghi chú giao dịch
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_status (status)
);

-- =============================
-- BẢNG LỊCH SỬ TRẠNG THÁI ĐƠN HÀNG (ORDER_STATUS_LOGS)
-- =============================
DROP TABLE IF EXISTS order_status_logs;
CREATE TABLE order_status_logs
(
    id         INT PRIMARY KEY AUTO_INCREMENT,                                  -- Khóa chính
    order_id   INT         NOT NULL,                                            -- Đơn hàng liên quan (FK orders)
    old_status VARCHAR(50),                                                     -- Trạng thái cũ
    new_status VARCHAR(50) NOT NULL,                                            -- Trạng thái mới
    note       TEXT,                                                            -- Ghi chú thay đổi
    changed_by INT,                                                             -- Người thay đổi (user_id hoặc staff_id)
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Thời gian thay đổi
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users (id),
    INDEX idx_order (order_id)
);

-- =============================
-- BẢNG VOUCHER ĐƠN HÀNG (ORDER_VOUCHERS)
-- =============================
DROP TABLE IF EXISTS order_vouchers;
CREATE TABLE order_vouchers
(
    id         INT PRIMARY KEY AUTO_INCREMENT,      -- Khóa chính
    order_id   INT            NOT NULL,             -- Đơn hàng liên quan (FK orders)
    voucher_id INT            NOT NULL,             -- Voucher áp dụng (FK vouchers)
    code       VARCHAR(50)    NOT NULL,             -- Mã voucher
    discount   DECIMAL(15, 2) NOT NULL,             -- Số tiền giảm giá
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Thời gian áp dụng
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (voucher_id) REFERENCES vouchers (id),
    INDEX idx_order (order_id)
);

-- =============================
-- TRIGGER TỰ ĐỘNG SINH ORDER_CODE (TRG_GENERATE_ORDER_CODE)
-- =============================
/*
-- Format: yyMMdd + 7 ký tự ngẫu nhiên (A-Z, 0-9)
-- Ví dụ: 250606S7CUJ4A
-- Đảm bảo order_code là duy nhất nhờ UNIQUE constraint
-- Xác suất trùng lặp cực thấp, phù hợp cho hệ thống < 1000 đơn/ngày
-- Nếu trùng sẽ báo lỗi duplicate key (rất hiếm gặp)

-- Xóa trigger sinh order_code nếu đã tồn tại (tránh lỗi khi chạy lại file)
*/
DROP TRIGGER IF EXISTS trg_generate_order_code;

DELIMITER $$
CREATE TRIGGER trg_generate_order_code
    BEFORE INSERT
    ON orders
    FOR EACH ROW
BEGIN
    IF NEW.order_code IS NULL OR NEW.order_code = '' THEN
        SET NEW.order_code = CONCAT(
                DATE_FORMAT(NOW(), '%y%m%d'),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
                SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1)
                             );
    END IF;
END$$
DELIMITER ;

-- =============================
-- BẢNG TÀI KHOẢN GỐC SẢN PHẨM (PRODUCT_ACCOUNTS)
-- =============================
DROP TABLE IF EXISTS product_accounts;
CREATE TABLE product_accounts
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    package_id INT NOT NULL,
    username   VARCHAR(255),
    password   VARCHAR(255),
    code       VARCHAR(255),
    extra_info TEXT,     -- Thông tin khác ngoài các trường cung cấp trên
    expired_at DATETIME, -- Thời hạn thực sự của tài khoản gốc
    status     ENUM ('available', 'sold', 'reserved', 'expired', 'error') DEFAULT 'available',
    created_at TIMESTAMP                                                  DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP                                                  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    INDEX idx_package (package_id),
    INDEX idx_status (status),
    INDEX idx_expired (expired_at)
);

-- =============================
-- BẢNG LỊCH SỬ THUÊ TÀI KHOẢN (ACCOUNT_RENTALS)
-- =============================
DROP TABLE IF EXISTS account_rentals;
CREATE TABLE account_rentals
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    account_id    INT      NOT NULL, -- Tài khoản thực tế
    order_item_id INT      NOT NULL, -- Liên kết với order_items
    rental_start  DATETIME NOT NULL, -- Thời gian bắt đầu thuê
    rental_end    DATETIME NOT NULL, -- Thời gian kết thúc thuê (hết hạn thuê)
    status        ENUM ('active', 'expired', 'returned') DEFAULT 'active',
    created_at    TIMESTAMP                              DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP                              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES product_accounts (id) ON DELETE CASCADE,
    FOREIGN KEY (order_item_id) REFERENCES order_items (id) ON DELETE CASCADE,
    INDEX idx_account (account_id),
    INDEX idx_order_item (order_item_id),
    INDEX idx_status (status)
);

-- =============================
-- BẢNG PHIÊN GIỎ HÀNG (CART_SESSIONS)
-- =============================
DROP TABLE IF EXISTS cart_sessions;
CREATE TABLE cart_sessions
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    user_id       INT,          -- NULL nếu là guest
    session_token VARCHAR(100), -- Dùng cho guest, unique
    created_at    TIMESTAMP                                 DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP                                 DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status        ENUM ('active', 'abandoned', 'converted') DEFAULT 'active',
    ip_address    VARCHAR(45),
    user_agent    TEXT COMMENT 'Thông tin user agent của trình duyệt',
    FOREIGN KEY (user_id) REFERENCES users (id),
    UNIQUE KEY uq_session_token (session_token)
);

-- =============================
-- BẢNG CHI TIẾT GIỎ HÀNG (CART_ITEMS)
-- =============================
DROP TABLE IF EXISTS cart_items;
CREATE TABLE cart_items
(
    id         INT PRIMARY KEY AUTO_INCREMENT,                                     -- Khóa chính
    cart_id    INT NOT NULL,                                                       -- FK cart_sessions
    package_id INT NOT NULL,                                                       -- FK product_packages
    quantity   INT NOT NULL DEFAULT 1,                                             -- Số lượng
    added_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,                             -- Thời gian thêm vào giỏ
    updated_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Thời gian cập nhật
    FOREIGN KEY (cart_id) REFERENCES cart_sessions (id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES product_packages (id)
);

-- =============================
-- BẢNG VOUCHER ÁP DỤNG CHO GIỎ HÀNG (CART_VOUCHERS)
-- =============================
DROP TABLE IF EXISTS cart_vouchers;
CREATE TABLE cart_vouchers
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    cart_id    INT         NOT NULL,                -- Liên kết với cart_sessions
    voucher_id INT         NOT NULL,                -- Liên kết với vouchers
    code       VARCHAR(50) NOT NULL,                -- Mã voucher
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Thời gian áp dụng
    FOREIGN KEY (cart_id) REFERENCES cart_sessions (id) ON DELETE CASCADE,
    FOREIGN KEY (voucher_id) REFERENCES vouchers (id),
    UNIQUE KEY uq_cart_voucher (cart_id, voucher_id)
);

-- =============================
-- BẢNG LỊCH SỬ BIẾN ĐỘNG SỐ DƯ (USER_BALANCE_LOGS)
-- =============================
DROP TABLE IF EXISTS user_balance_logs;
CREATE TABLE user_balance_logs
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    user_id       INT            NOT NULL,
    change_amount DECIMAL(15, 2) NOT NULL, -- Số tiền thay đổi (+/-)
    new_balance   DECIMAL(15, 2) NOT NULL, -- Số dư sau giao dịch
    description   VARCHAR(255),            -- Mô tả (ví dụ: "Nạp tiền qua MoMo", "Thanh toán đơn hàng #1234", ...)
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- =============================
-- BẢNG TÀI KHOẢN NGÂN HÀNG (BANK_ACCOUNTS)
-- =============================
DROP TABLE IF EXISTS bank_accounts;
CREATE TABLE bank_accounts
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    bank_name      VARCHAR(100) NOT NULL, -- Tên ngân hàng (VD: MB Bank)
    account_number VARCHAR(50)  NOT NULL, -- Số tài khoản
    account_holder VARCHAR(255) NOT NULL, -- Tên chủ tài khoản
    branch         VARCHAR(100),          -- Chi nhánh
    status         TINYINT(1) DEFAULT 1,  -- 1: Hiện, 0: Ẩn
    created_at     TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    index idx_bank_name (bank_name),
    index idx_account_number (account_number),
    index idx_account_holder (account_holder)
);

-- =============================
-- BẢNG GIAO DỊCH NẠP TIỀN (DEPOSIT_TRANSACTIONS)
-- =============================
DROP TABLE IF EXISTS deposit_transactions;
CREATE TABLE deposit_transactions
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    user_id          INT            NOT NULL,                               -- Người nạp tiền
    bank_account_id  INT            NOT NULL,                               -- Tài khoản nhận (FK bank_accounts)
    amount           DECIMAL(15, 2) NOT NULL,                               -- Số tiền nạp
    transfer_content VARCHAR(255)   NOT NULL,                               -- Nội dung chuyển khoản (gắn với QR động)
    transaction_code VARCHAR(100),                                          -- Mã giao dịch ngân hàng (nếu có, dùng để đối soát)
    status           ENUM ('pending','success','failed') DEFAULT 'pending', -- Trạng thái xử lý
    created_at       TIMESTAMP                           DEFAULT CURRENT_TIMESTAMP,
    processed_at     TIMESTAMP      NULL,                                   -- Thời gian xử lý (NULL nếu chưa xử lý)
    note             TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (bank_account_id) REFERENCES bank_accounts (id),

    index idx_user (user_id),
    index idx_bank_account (bank_account_id)
);

-- =============================
-- TRIGGER CẬP NHẬT SỐ DƯ USER KHI GHI LOG BIẾN ĐỘNG SỐ DƯ
-- =============================
DROP TRIGGER IF EXISTS trg_update_user_balance_after_log;
DELIMITER $$
CREATE TRIGGER trg_update_user_balance_after_log
    AFTER INSERT
    ON user_balance_logs
    FOR EACH ROW
BEGIN
    UPDATE users
    SET balance = NEW.new_balance
    WHERE id = NEW.user_id;
END$$
DELIMITER ;

-- =============================
-- BẢNG LỊCH SỬ HOẠT ĐỘNG NGƯỜI DÙNG (USER_ACTIVITY_LOGS)
-- =============================
DROP TABLE IF EXISTS user_activity_logs;
CREATE TABLE user_activity_logs
(
    id            INT PRIMARY KEY AUTO_INCREMENT,                                                     -- Khóa chính, tự tăng
    user_id       INT         NOT NULL,                                                               -- ID người dùng thực hiện hành động (FK users)
    activity_type VARCHAR(50) NOT NULL COMMENT 'login, logout, update_profile, change_password, ...', -- Loại hoạt động
    activity_desc VARCHAR(255) COMMENT 'Mô tả chi tiết hoạt động (nếu có)',                           -- Mô tả chi tiết hoạt động
    ip_address    VARCHAR(45) COMMENT 'Địa chỉ IP thực hiện',                                         -- Địa chỉ IP
    user_agent    TEXT COMMENT 'Thông tin trình duyệt, thiết bị',                                     -- User agent
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian thực hiện',                  -- Thời gian thực hiện
    FOREIGN KEY (user_id) REFERENCES users (id),                                                      -- Khóa ngoại tới bảng users
    INDEX idx_user (user_id),                                                                         -- Index cho user_id
    INDEX idx_type (activity_type),                                                                   -- Index cho activity_type
    INDEX idx_created_at (created_at)                                                                 -- Index cho created_at
);

-- =============================
-- BẢNG YÊU THÍCH SẢN PHẨM/GÓI (FAVORITES)
-- =============================
DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    user_id    INT NOT NULL,           -- Người dùng yêu thích
    package_id INT NOT NULL,           -- Gói sản phẩm được yêu thích
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_package (user_id, package_id) -- Mỗi user chỉ được thích 1 package 1 lần
);

-- =============================
-- BẢNG BÌNH LUẬN SẢN PHẨM/GÓI (PRODUCT_COMMENTS)
-- =============================
DROP TABLE IF EXISTS product_comments;
CREATE TABLE product_comments
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    package_id  INT NOT NULL,           -- Gói sản phẩm được bình luận
    user_id     INT,                    -- Người bình luận (NULL nếu là khách)
    comment     TEXT NOT NULL,          -- Nội dung bình luận
    parent_id   INT DEFAULT NULL,       -- Bình luận cha (cho phép trả lời)
    rating      TINYINT CHECK (rating BETWEEN 1 AND 5), -- Đánh giá kèm bình luận (nếu có)
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status      TINYINT(1) DEFAULT 1,   -- 1: hiển thị, 0: ẩn
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    FOREIGN KEY (parent_id) REFERENCES product_comments (id) ON DELETE CASCADE,
    INDEX idx_package (package_id),
    INDEX idx_user (user_id),
    INDEX idx_parent (parent_id)
);

-- =============================
-- BẢNG HÓA ĐƠN BÁN HÀNG (INVOICES)
-- =============================
DROP TABLE IF EXISTS invoices;
CREATE TABLE invoices
(
    id              INT PRIMARY KEY AUTO_INCREMENT,                    -- Khóa chính
    invoice_code    VARCHAR(50)    NOT NULL UNIQUE,                    -- Mã hóa đơn (có thể tự sinh, duy nhất)
    order_id        INT            NOT NULL,                           -- Đơn hàng liên quan (FK orders, chỉ xuất hóa đơn khi orders.status = 'completed')
    user_id         INT            NOT NULL,                           -- Người mua (FK users)
    issued_date     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Ngày xuất hóa đơn
    total_amount    DECIMAL(15, 2) NOT NULL,                           -- Tổng tiền hóa đơn (trước thuế)
    vat_rate        DECIMAL(4, 3)  NOT NULL,                           -- Tỷ lệ VAT áp dụng (lấy từ vat_settings)
    tax_amount      DECIMAL(15, 2) NOT NULL,                           -- Số tiền VAT
    final_amount    DECIMAL(15, 2) NOT NULL,                           -- Tổng tiền phải trả (sau thuế)
    is_vat_included TINYINT(1)              DEFAULT 0,                 -- 0: giá chưa gồm VAT, 1: đã gồm VAT
    buyer_name      VARCHAR(255),                                      -- Tên người mua (có thể lấy từ profile hoặc nhập tay)
    buyer_address   VARCHAR(500),                                      -- Địa chỉ người mua
    buyer_tax_code  VARCHAR(50),                                       -- Mã số thuế người mua (nếu có)
    note            TEXT,                                              -- Ghi chú hóa đơn
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id),
    INDEX idx_order (order_id),
    INDEX idx_user (user_id)
);
--
-- HƯỚNG DẪN SỬ DỤNG TRƯỜNG VAT:
--  - vat_rate: Lấy từ bảng vat_settings theo package_type
--  - is_vat_included = 0 (giá chưa gồm VAT):
--      tax_amount = total_amount * vat_rate
--      final_amount = total_amount + tax_amount
--  - is_vat_included = 1 (giá đã gồm VAT):
--      tax_amount = final_amount * vat_rate / (1 + vat_rate)
--      total_amount = final_amount - tax_amount

-- =============================
-- PROCEDURE TỰ ĐỘNG TÍNH VAT VÀ TẠO HÓA ĐƠN (CREATEINVOICEFORORDER)
-- =============================
DROP PROCEDURE IF EXISTS CreateInvoiceForOrder;
DELIMITER //
CREATE PROCEDURE CreateInvoiceForOrder(IN p_order_id INT)
BEGIN
    DECLARE v_status VARCHAR(50);
    DECLARE v_user_id INT;
    DECLARE v_package_type VARCHAR(10);
    DECLARE v_total_amount DECIMAL(15,2);
    DECLARE v_vat_rate DECIMAL(4,3);
    DECLARE v_tax_amount DECIMAL(15,2);
    DECLARE v_final_amount DECIMAL(15,2);
    DECLARE v_is_vat_included TINYINT(1) DEFAULT 1;
    DECLARE v_invoice_code VARCHAR(50);
    DECLARE v_count_types INT;
    DECLARE v_buyer_name VARCHAR(255);
    DECLARE v_buyer_address VARCHAR(500);

    -- Kiểm tra trạng thái đơn hàng
    SELECT status, user_id INTO v_status, v_user_id FROM orders WHERE id = p_order_id;
    IF v_status != 'completed' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chỉ xuất hóa đơn cho đơn hàng đã hoàn thành (completed)';
    END IF;

    -- Kiểm tra loại package trong đơn hàng
    SELECT COUNT(DISTINCT pp.package_type)
      INTO v_count_types
    FROM order_items oi
    JOIN product_packages pp ON oi.package_id = pp.id
    WHERE oi.order_id = p_order_id;

    IF v_count_types > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đơn hàng có cả bán và cho thuê, cần tách hóa đơn hoặc xử lý thủ công';
    END IF;

    -- Lấy loại package và tổng tiền (đã gồm VAT)
    SELECT MAX(pp.package_type), SUM(oi.final_price)
      INTO v_package_type, v_total_amount
    FROM order_items oi
    JOIN product_packages pp ON oi.package_id = pp.id
    WHERE oi.order_id = p_order_id;

    -- Xác định VAT rate (lấy từ bảng cấu hình)
    SET v_vat_rate = GetVatRate(v_package_type);

    -- Tách VAT từ giá đã gồm VAT
    SET v_tax_amount = v_total_amount * v_vat_rate / (1 + v_vat_rate);
    SET v_final_amount = v_total_amount;
    SET v_total_amount = v_total_amount - v_tax_amount;
    SET v_is_vat_included = 1;

    -- Sinh mã hóa đơn (HD + yyMMdd + 6 ký tự ngẫu nhiên)
    SET v_invoice_code = CONCAT(
        'HD',
        DATE_FORMAT(NOW(), '%y%m%d'),
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1),
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', FLOOR(1 + (RAND() * 36)), 1)
    );

    -- Lấy thông tin người mua
    SELECT full_name, address INTO v_buyer_name, v_buyer_address FROM users WHERE id = v_user_id;

    -- Tạo bản ghi hóa đơn
    INSERT INTO invoices (
        invoice_code, order_id, user_id, issued_date, total_amount, vat_rate, tax_amount, final_amount, is_vat_included, buyer_name, buyer_address
    ) VALUES (
        v_invoice_code, p_order_id, v_user_id, NOW(), v_total_amount, v_vat_rate, v_tax_amount, v_final_amount, v_is_vat_included, v_buyer_name, v_buyer_address
    );
END //
DELIMITER ;

-- call CreateInvoiceForOrder(2); -- Thay 1 bằng ID đơn hàng thực tế để tạo hóa đơn

-- =============================
-- PROCEDURE ĐĂNG NHẬP VỚI GOOGLE (GOOGLE_LOGIN)
-- =============================
DROP PROCEDURE IF EXISTS GoogleLogin;
DELIMITER //
CREATE PROCEDURE GoogleLogin(
    IN p_google_id VARCHAR(50),
    IN p_email VARCHAR(255),
    IN p_full_name VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT DEFAULT NULL;
    DECLARE v_existing_email INT DEFAULT 0;
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';

    -- Xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET v_result_code = -1;
            SET v_message = 'Database error occurred';
            SELECT v_result_code as result_code, v_message as message, NULL as user_data;
        END;

    START TRANSACTION;

    -- Kiểm tra user đã tồn tại với Google ID này chưa
    SELECT id INTO v_user_id
    FROM users
    WHERE google_id = p_google_id AND status = 1
    LIMIT 1;

    IF v_user_id IS NOT NULL THEN
        -- User đã tồn tại với Google ID, cập nhật thông tin và đăng nhập
        UPDATE users
        SET
            email = p_email,
            full_name = COALESCE(p_full_name, full_name),
            last_login_at = NOW(),
            updated_at = NOW()
        WHERE id = v_user_id;

        SET v_result_code = 1;
        SET v_message = 'Login successful';

    ELSE
        -- Kiểm tra email đã tồn tại với tài khoản thường chưa
        SELECT COUNT(*) INTO v_existing_email
        FROM users
        WHERE email = p_email AND google_id IS NULL AND status = 1;

        IF v_existing_email > 0 THEN
            -- Email đã tồn tại với tài khoản thường, liên kết với Google
            UPDATE users
            SET
                google_id = p_google_id,
                full_name = COALESCE(p_full_name, full_name),
                last_login_at = NOW(),
                updated_at = NOW()
            WHERE email = p_email AND google_id IS NULL AND status = 1;

            SELECT id INTO v_user_id FROM users WHERE email = p_email AND google_id = p_google_id;
            SET v_result_code = 2;
            SET v_message = 'Account linked with Google successfully';

        ELSE
            -- Tạo tài khoản mới
            INSERT INTO users (
                username,
                password,
                email,
                google_id,
                full_name,
                role,
                last_login_at,
                created_at
            ) VALUES (
                         CONCAT('google_', SUBSTRING(p_google_id, 1, 20)), -- Tạo username từ Google ID
                         '', -- Password trống cho Google login
                         p_email,
                         p_google_id,
                         p_full_name,
                         'customer',
                         NOW(),
                         NOW()
                     );

            SET v_user_id = LAST_INSERT_ID();
            SET v_result_code = 3;
            SET v_message = 'Account created and logged in successfully';
        END IF;
    END IF;

    COMMIT;

    -- Trả về kết quả
    SELECT
        v_result_code as result_code,
        v_message as message,
        JSON_OBJECT(
                'user_id', u.id,
                'username', u.username,
                'email', u.email,
                'full_name', u.full_name,
                'role', u.role,
                'google_id', u.google_id,
                'last_login', u.last_login_at
        ) as user_data
    FROM users u
    WHERE u.id = v_user_id;

END //
DELIMITER ;

-- =============================
-- PROCEDURE ĐĂNG KÝ USER BÌNH THƯỜNG (REGISTER_USER)
-- =============================
DROP PROCEDURE IF EXISTS RegisterUser;
DELIMITER //
CREATE PROCEDURE RegisterUser(
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255),
    IN p_full_name VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT DEFAULT NULL;
    DECLARE v_username_exists INT DEFAULT 0;
    DECLARE v_email_exists INT DEFAULT 0;
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';

    -- Xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET v_result_code = -1;
            SET v_message = 'Database error occurred';
            SELECT v_result_code as result_code, v_message as message, NULL as user_data;
        END;

    START TRANSACTION;

    -- Validate input
    IF p_username IS NULL OR LENGTH(TRIM(p_username)) = 0 THEN
        SET v_result_code = -2;
        SET v_message = 'Username is required';
    ELSEIF p_email IS NULL OR LENGTH(TRIM(p_email)) = 0 THEN
        SET v_result_code = -3;
        SET v_message = 'Email is required';
    ELSEIF p_password IS NULL OR LENGTH(TRIM(p_password)) < 6 THEN
        SET v_result_code = -4;
        SET v_message = 'Password must be at least 6 characters';
    ELSEIF p_email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
        SET v_result_code = -5;
        SET v_message = 'Invalid email format';
    ELSE
        -- Kiểm tra username đã tồn tại chưa
        SELECT COUNT(*) INTO v_username_exists
        FROM users
        WHERE username = p_username AND status = 1;

        -- Kiểm tra email đã tồn tại chưa
        SELECT COUNT(*) INTO v_email_exists
        FROM users
        WHERE email = p_email AND status = 1;

        IF v_username_exists > 0 THEN
            SET v_result_code = -6;
            SET v_message = 'Username already exists';
        ELSEIF v_email_exists > 0 THEN
            SET v_result_code = -7;
            SET v_message = 'Email already exists';
        ELSE
            -- Tạo tài khoản mới
            INSERT INTO users (
                username,
                password,
                email,
                full_name,
                role,
                created_at
            ) VALUES (
                         TRIM(p_username),
                         p_password, -- Password đã được hash từ phía application
                         TRIM(p_email),
                         TRIM(p_full_name),
                         'customer',
                         NOW()
                     );

            SET v_user_id = LAST_INSERT_ID();
            SET v_result_code = 1;
            SET v_message = 'User registered successfully';
        END IF;
    END IF;

    IF v_result_code = 1 THEN
        COMMIT;

        -- Trả về thông tin user mới tạo
        SELECT
            v_result_code as result_code,
            v_message as message,
            JSON_OBJECT(
                    'user_id', u.id,
                    'username', u.username,
                    'email', u.email,
                    'full_name', u.full_name,
                    'role', u.role,
                    'created_at', u.created_at
            ) as user_data
        FROM users u
        WHERE u.id = v_user_id;
    ELSE
        ROLLBACK;
        SELECT v_result_code as result_code, v_message as message, NULL as user_data;
    END IF;

END //
DELIMITER ;

-- =============================
-- PROCEDURE ĐĂNG NHẬP USER CẬP NHẬT (LOGIN_USER)
-- =============================
DROP PROCEDURE IF EXISTS LoginUser;

DELIMITER //
CREATE PROCEDURE LoginUser(
    IN p_username_or_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT DEFAULT NULL;
    DECLARE v_stored_password VARCHAR(255) DEFAULT '';
    DECLARE v_user_role ENUM('customer', 'admin', 'staff') DEFAULT 'customer';
    DECLARE v_user_status ENUM('active', 'banned', 'inactive') DEFAULT 'active';
    DECLARE v_deleted_at TIMESTAMP DEFAULT NULL;
    DECLARE v_login_attempts INT DEFAULT 0;
    DECLARE v_locked_until TIMESTAMP DEFAULT NULL;
    DECLARE v_last_failed_login TIMESTAMP DEFAULT NULL;
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';
    DECLARE v_lock_duration INT DEFAULT 24; -- 24 giờ
    DECLARE v_max_attempts INT DEFAULT 5;

    -- Xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET v_result_code = -1;
        SET v_message = 'Database error occurred';
        SELECT v_result_code as result_code, v_message as message, NULL as user_data;
    END;

    START TRANSACTION;

    -- Validate input
    IF p_username_or_email IS NULL OR LENGTH(TRIM(p_username_or_email)) = 0 THEN
        SET v_result_code = -2;
        SET v_message = 'Username or email is required';
    ELSEIF p_password IS NULL OR LENGTH(TRIM(p_password)) = 0 THEN
        SET v_result_code = -3;
        SET v_message = 'Password is required';
    ELSE
        -- Tìm user theo username hoặc email
        SELECT
            id,
            password,
            role,
            status,
            deleted_at,
            failed_login_attempts,
            locked_until,
            last_failed_login
        INTO
            v_user_id,
            v_stored_password,
            v_user_role,
            v_user_status,
            v_deleted_at,
            v_login_attempts,
            v_locked_until,
            v_last_failed_login
        FROM users
        WHERE (username = p_username_or_email OR email = p_username_or_email)
          AND google_id IS NULL -- Chỉ tài khoản thường
        LIMIT 1;

        IF v_user_id IS NULL THEN
            SET v_result_code = -4;
            SET v_message = 'User not found';

        ELSEIF v_deleted_at IS NOT NULL THEN
            SET v_result_code = -5;
            SET v_message = 'Account has been deleted';

        ELSEIF v_user_status = 'banned' THEN
            SET v_result_code = -6;
            SET v_message = 'Account has been banned';

        ELSEIF v_user_status = 'inactive' THEN
            SET v_result_code = -7;
            SET v_message = 'Account is inactive';

        ELSEIF v_locked_until IS NOT NULL AND v_locked_until > NOW() THEN
            SET v_result_code = -8;
            SET v_message = CONCAT('Account is temporarily locked until ', DATE_FORMAT(v_locked_until, '%Y-%m-%d %H:%i:%s'));

        ELSEIF v_stored_password != p_password THEN
            -- Mật khẩu sai, tăng số lần thử
            SET v_login_attempts = v_login_attempts + 1;

            -- Nếu đạt số lần thử tối đa, khóa tài khoản
            IF v_login_attempts >= v_max_attempts THEN
                UPDATE users
                SET
                    failed_login_attempts = v_login_attempts,
                    last_failed_login = NOW(),
                    locked_until = DATE_ADD(NOW(), INTERVAL v_lock_duration HOUR),
                    updated_at = NOW()
                WHERE id = v_user_id;

                SET v_result_code = -9;
                SET v_message = CONCAT('Account temporarily locked for ', v_lock_duration, ' hours due to too many failed login attempts');
            ELSE
                -- Cập nhật số lần thử
                UPDATE users
                SET
                    failed_login_attempts = v_login_attempts,
                    last_failed_login = NOW(),
                    updated_at = NOW()
                WHERE id = v_user_id;

                SET v_result_code = -10;
                SET v_message = CONCAT('Invalid password. ', (v_max_attempts - v_login_attempts), ' attempts remaining');
            END IF;

        ELSE
            -- Đăng nhập thành công
            -- Reset số lần thử và cập nhật last_login
            UPDATE users
            SET
                failed_login_attempts = 0,
                last_failed_login = NULL,
                locked_until = NULL,
                last_login_at = NOW(),
                updated_at = NOW()
            WHERE id = v_user_id;

            SET v_result_code = 1;

            -- Thông báo khác nhau theo role
            CASE v_user_role
                WHEN 'admin' THEN
                    SET v_message = 'Admin login successful';
                WHEN 'staff' THEN
                    SET v_message = 'Staff login successful';
                ELSE
                    SET v_message = 'Customer login successful';
            END CASE;
        END IF;
    END IF;

    IF v_result_code = 1 THEN
        COMMIT;

        -- Trả về thông tin user với phân quyền
        SELECT
            v_result_code as result_code,
            v_message as message,
            JSON_OBJECT(
                'user_id', u.id,
                'username', u.username,
                'email', u.email,
                'full_name', u.full_name,
                'role', u.role,
                'status', u.status,
                'permissions', u.permissions,
                'last_login', u.last_login_at,
                'two_factor_enabled', u.two_factor_enabled,
                'role_display', CASE u.role
                    WHEN 'admin' THEN 'Quản trị viên'
                    WHEN 'staff' THEN 'Nhân viên'
                    ELSE 'Khách hàng'
                END
            ) as user_data
        FROM users u
        WHERE u.id = v_user_id;
    ELSE
        ROLLBACK;
        SELECT v_result_code as result_code, v_message as message, NULL as user_data;
    END IF;

END //
DELIMITER ;

/*
CALL GoogleLogin('google_user_id_123', 'user@gmail.com', 'John Doe');

CALL RegisterUser('john_doe', 'john@example.com', 'hashed_password', 'John Doe');

CALL LoginUser('john_doe', 'hashed_password');
*/

-- =============================
-- PROCEDURE ĐỔI MẬT KHẨU NGƯỜI DÙNG (KHÔNG CẦN MẬT KHẨU CŨ)
-- =============================

-- Xóa procedure nếu đã tồn tại (tránh lỗi khi chạy lại file)
DROP PROCEDURE IF EXISTS ChangeUserPassword;

-- Tạo procedure đổi mật khẩu người dùng
DELIMITER //
CREATE PROCEDURE ChangeUserPassword(
    IN p_user_id INT,
    IN p_new_password VARCHAR(255),
    IN p_repeat_password VARCHAR(255)
)
BEGIN
    -- Biến dùng cho xử lý logic và trả kết quả
    DECLARE v_stored_password VARCHAR(255) DEFAULT '';
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';

    -- Xử lý lỗi SQL (rollback và trả về lỗi)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET v_result_code = -99;
            SET v_message = 'Database error occurred';
            SELECT v_result_code AS result_code, v_message AS message;
        END;

    START TRANSACTION;

    -- Lấy mật khẩu hiện tại của user (chỉ lấy user đang active)
    SELECT password
    INTO v_stored_password
    FROM users
    WHERE id = p_user_id
      AND status = 'active'
    LIMIT 1;

    -- Kiểm tra user tồn tại
    IF ROW_COUNT() = 0 THEN
        SET v_result_code = -1;
        SET v_message = 'User not found or not active';
        -- Kiểm tra độ dài mật khẩu mới
    ELSEIF p_new_password IS NULL OR LENGTH(p_new_password) < 8 THEN
        SET v_result_code = -2;
        SET v_message = 'Password must be at least 8 characters';
        -- Kiểm tra nhập lại mật khẩu
    ELSEIF p_new_password != p_repeat_password THEN
        SET v_result_code = -3;
        SET v_message = 'Passwords do not match';
        -- Kiểm tra mật khẩu mới không được trùng mật khẩu cũ (nếu mật khẩu cũ không rỗng)
    ELSEIF v_stored_password != '' AND p_new_password = v_stored_password THEN
        SET v_result_code = -4;
        SET v_message = 'New password must be different from the old password';
        -- Kiểm tra mật khẩu phải có ít nhất 1 số hoặc 1 ký tự đặc biệt
    ELSEIF p_new_password NOT REGEXP '[0-9!@#$%^&*(),.?":{}|<>]' THEN
        SET v_result_code = -5;
        SET v_message = 'Password must contain at least one number or special character';
    ELSE
        -- Cập nhật mật khẩu mới
        UPDATE users
        SET password   = p_new_password,
            updated_at = NOW()
        WHERE id = p_user_id;

        SET v_result_code = 1;
        SET v_message = 'Password changed successfully';
    END IF;

    IF v_result_code = 1 THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;

    -- Trả về kết quả
    SELECT v_result_code AS result_code, v_message AS message;
END //
DELIMITER ;

/*-- Ví dụ gọi procedure đổi mật khẩu

CALL ChangeUserPassword(1, 'new_password123', 'new_password123');
-- Kết quả trả về:
-- result_code: 1 (thành công)
-- message: 'Password changed successfully'

CALL ChangeUserPassword(1, 'short', 'short');

 */

-- =============================
-- PROCEDURE CẬP NHẬT THÔNG TIN NGƯỜI DÙNG (CHỈ UPDATE TRƯỜNG KHÁC NULL)
-- =============================

DROP PROCEDURE IF EXISTS UpdateUserProfile;

DELIMITER //
CREATE PROCEDURE UpdateUserProfile(
    IN p_user_id INT,
    IN p_full_name VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_gender ENUM('Nam', 'Nữ', 'Khác'),
    IN p_city VARCHAR(100),
    IN p_district VARCHAR(100),
    IN p_ward VARCHAR(100),
    IN p_address TEXT,
    IN p_avatar VARCHAR(500)
)
BEGIN
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';

    -- Xử lý lỗi SQL (rollback và trả về lỗi)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET v_result_code = -99;
            SET v_message = 'Database error occurred';
            SELECT v_result_code AS result_code, v_message AS message;
        END;

    START TRANSACTION;

    -- Kiểm tra user tồn tại và active
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = p_user_id AND status = 'active') THEN
        SET v_result_code = -1;
        SET v_message = 'User not found or not active';
    ELSE
        -- Cập nhật từng trường nếu truyền vào khác NULL
        IF p_full_name IS NOT NULL THEN
            UPDATE users SET full_name = p_full_name, updated_at = NOW() WHERE id = p_user_id;
        END IF;
        IF p_phone IS NOT NULL THEN
            UPDATE users SET phone = p_phone, updated_at = NOW() WHERE id = p_user_id;
        END IF;
        IF p_gender IS NOT NULL THEN
            UPDATE users SET gender = p_gender, updated_at = NOW() WHERE id = p_user_id;
        END IF;
        IF p_city IS NOT NULL THEN
            UPDATE users SET city = p_city, updated_at = NOW() WHERE id = p_user_id;
        END IF;
        IF p_district IS NOT NULL THEN
            UPDATE users SET district = p_district, updated_at = NOW() WHERE id = p_user_id;
        END IF;
        IF p_ward IS NOT NULL THEN
            UPDATE users SET ward = p_ward, updated_at = NOW() WHERE id = p_user_id;
        END IF;
        IF p_address IS NOT NULL THEN
            UPDATE users SET address = p_address, updated_at = NOW() WHERE id = p_user_id;
        END IF;
        IF p_avatar IS NOT NULL THEN
            UPDATE users SET avatar = p_avatar, updated_at = NOW() WHERE id = p_user_id;
        END IF;

        SET v_result_code = 1;
        SET v_message = 'Profile updated successfully';
    END IF;

    IF v_result_code = 1 THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;

    SELECT v_result_code AS result_code, v_message AS message;
END //
DELIMITER ;

/* Ví dụ gọi procedure cập nhật thông tin người dùng
CALL UpdateUserProfile(
    1,
    'Nguyễn Văn B', -- full_name (update)
    NULL,           -- phone (giữ nguyên)
    NULL,           -- gender (giữ nguyên)
    'Hà Nội',       -- city (update)
    NULL,           -- district (giữ nguyên)
    NULL,           -- ward (giữ nguyên)
    NULL,           -- address (giữ nguyên)
    NULL            -- avatar (giữ nguyên)
);
 */

-- =============================
-- PROCEDURE RESET LOGIN ATTEMPTS (RESET_LOGIN_ATTEMPTS)
-- =============================
DELIMITER //
CREATE PROCEDURE ResetLoginAttempts(
    IN p_user_id INT,
    IN p_admin_id INT,
    IN p_reason VARCHAR(500)
)
BEGIN
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';
    DECLARE v_old_status ENUM('active', 'inactive', 'banned');

    -- Xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET v_result_code = -1;
            SET v_message = 'Database error occurred';
            SELECT v_result_code as result_code, v_message as message;
        END;

    START TRANSACTION;

    -- Lấy status hiện tại
    SELECT status INTO v_old_status
    FROM users
    WHERE id = p_user_id AND deleted_at IS NULL;

    -- Reset login attempts
    UPDATE users
    SET
        failed_login_attempts = 0,
        last_failed_login = NULL,
        locked_until = NULL,
        updated_at = NOW()
    WHERE id = p_user_id AND deleted_at IS NULL;

    IF ROW_COUNT() > 0 THEN
        -- Ghi log vào bảng user_violation_logs
        INSERT INTO user_violation_logs (
            user_id, action, old_status, new_status, reason, admin_id, created_at
        ) VALUES (
            p_user_id,
            'unlock',
            v_old_status,
            v_old_status, -- Trạng thái không đổi, chỉ mở khóa
            p_reason,
            p_admin_id,
            NOW()
        );

        SET v_result_code = 1;
        SET v_message = 'Login attempts reset and account unlocked successfully';
        COMMIT;
    ELSE
        SET v_result_code = -2;
        SET v_message = 'User not found or already deleted';
        ROLLBACK;
    END IF;

    SELECT v_result_code as result_code, v_message as message;

END //
DELIMITER ;

-- =============================
-- PROCEDURE CHANGE USER STATUS (CHANGE_USER_STATUS)
-- =============================
DELIMITER //
CREATE PROCEDURE ChangeUserStatus(
    IN p_user_id INT,
    IN p_status ENUM('active', 'banned', 'inactive'),
    IN p_admin_id INT,
    IN p_reason VARCHAR(500)
)
BEGIN
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';
    DECLARE v_old_status ENUM('active', 'banned', 'inactive');

    -- Xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET v_result_code = -1;
            SET v_message = 'Database error occurred';
            SELECT v_result_code as result_code, v_message as message;
        END;

    START TRANSACTION;

    -- Lấy status hiện tại
    SELECT status INTO v_old_status
    FROM users
    WHERE id = p_user_id AND deleted_at IS NULL;

    IF v_old_status IS NULL THEN
        SET v_result_code = -2;
        SET v_message = 'User not found or already deleted';
    ELSE
        -- Cập nhật status
        UPDATE users
        SET
            status = p_status,
            failed_login_attempts = 0,
            locked_until = NULL,
            updated_at = NOW()
        WHERE id = p_user_id;

        -- Ghi log vào bảng user_violation_logs
        INSERT INTO user_violation_logs (
            user_id, action, old_status, new_status, reason, admin_id, created_at
        ) VALUES (
            p_user_id,
            CASE
                WHEN p_status = 'banned' THEN 'banned'
                WHEN p_status = 'active' AND v_old_status = 'banned' THEN 'unbanned'
                WHEN p_status = 'inactive' THEN 'suspend'
                WHEN p_status = 'active' AND v_old_status = 'inactive' THEN 'unsuspend'
                ELSE 'other'
            END,
            v_old_status,
            p_status,
            p_reason,
            p_admin_id,
            NOW()
        );

        SET v_result_code = 1;
        SET v_message = CONCAT('User status changed from ', v_old_status, ' to ', p_status);
        COMMIT;
    END IF;

    SELECT v_result_code as result_code, v_message as message;

END //
DELIMITER ;

-- =============================
-- PROCEDURE SOFT DELETE USER (SOFT_DELETE_USER)
-- =============================
DELIMITER //
CREATE PROCEDURE SoftDeleteUser(
    IN p_user_id INT,
    IN p_admin_id INT,
    IN p_reason VARCHAR(500)
)
BEGIN
    DECLARE v_result_code INT DEFAULT 0;
    DECLARE v_message VARCHAR(255) DEFAULT '';
    DECLARE v_old_status ENUM('active', 'inactive', 'banned');

    -- Xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET v_result_code = -1;
            SET v_message = 'Database error occurred';
            SELECT v_result_code as result_code, v_message as message;
        END;

    START TRANSACTION;

    -- Lấy status hiện tại
    SELECT status INTO v_old_status
    FROM users
    WHERE id = p_user_id AND deleted_at IS NULL;

    -- Soft delete user
    UPDATE users
    SET
        deleted_at = NOW(),
        status = 'inactive',
        failed_login_attempts = 0,
        locked_until = NULL,
        updated_at = NOW()
    WHERE id = p_user_id AND deleted_at IS NULL;

    IF ROW_COUNT() > 0 THEN
        -- Ghi log vào bảng user_violation_logs
        INSERT INTO user_violation_logs (
            user_id, action, old_status, new_status, reason, admin_id, created_at
        ) VALUES (
            p_user_id,
            'deletion',
            v_old_status,
            'inactive',
            p_reason,
            p_admin_id,
            NOW()
        );

        SET v_result_code = 1;
        SET v_message = 'User deleted successfully';
        COMMIT;
    ELSE
        SET v_result_code = -2;
        SET v_message = 'User not found or already deleted';
        ROLLBACK;
    END IF;

    SELECT v_result_code as result_code, v_message as message;

END //
DELIMITER ;

/*
-- Mở khóa tài khoản cho customer03 (bị khóa do đăng nhập sai nhiều lần)
-- Tham số: user_id, admin_id, reason
CALL ResetLoginAttempts(
    9,                                           -- user_id (customer03)
    2,                                           -- admin_id (admin01)
    'Mở khóa theo yêu cầu qua email xác thực'    -- reason
);

-- Mở khóa tài khoản cho customer05 (bị khóa do đăng nhập sai quá 5 lần)
CALL ResetLoginAttempts(
    5,                                           -- user_id (customer05)
    7,                                           -- admin_id (admin02)
    'Xác minh danh tính qua CMND'                -- reason
);

-- Khóa tài khoản (ban) customer04 do vi phạm điều khoản
-- Tham số: user_id, status mới, admin_id, reason
CALL ChangeUserStatus(
    8,                                           -- user_id (customer04)
    'banned',                                    -- status mới (active/inactive/banned)
    2,                                           -- admin_id (admin01)
    'Vi phạm điều khoản sử dụng mục 3.2'         -- reason
);

-- Mở khóa tài khoản (unban) staff02 sau khi xác minh
CALL ChangeUserStatus(
    6,                                           -- user_id (staff02)
    'active',                                    -- status mới (active/inactive/banned)
    7,                                           -- admin_id (admin02)
    'Đã xác minh không vi phạm, phục hồi tài khoản' -- reason
);

-- Tạm khóa tài khoản (suspend) customer02 do nghi ngờ gian lận
CALL ChangeUserStatus(
    4,                                           -- user_id (customer02)
    'inactive',                                  -- status mới (active/inactive/banned)
    3,                                           -- admin_id (staff01)
    'Tạm khóa để điều tra giao dịch đáng ngờ'    -- reason
);

-- Xóa mềm tài khoản customer04 theo yêu cầu của người dùng
-- Tham số: user_id, admin_id, reason
CALL SoftDeleteUser(
    8,                                           -- user_id (customer04)
    2,                                           -- admin_id (admin01)
    'Người dùng yêu cầu xóa tài khoản'           -- reason
);

-- Xóa mềm tài khoản staff02 do không còn làm việc
CALL SoftDeleteUser(
    6,                                           -- user_id (staff02)
    7,                                           -- admin_id (admin02)
    'Nhân viên đã nghỉ việc'                     -- reason
);
*/

-- =============================
-- STORED PROCEDURES CRUD CHO PRODUCT_CATEGORIES
-- =============================

-- CREATE - Tạo danh mục sản phẩm mới
DELIMITER //
DROP PROCEDURE IF EXISTS CreateProductCategory//
CREATE PROCEDURE CreateProductCategory(
    IN p_name VARCHAR(100),
    IN p_slug VARCHAR(150),
    IN p_parent_id INT,
    IN p_description TEXT,
    IN p_image_url VARCHAR(500),
    IN p_icon VARCHAR(100),
    IN p_display_order INT,
    IN p_is_featured TINYINT(1),
    IN p_show_on_homepage TINYINT(1),
    IN p_meta_title VARCHAR(255),
    IN p_meta_description VARCHAR(500),
    IN p_meta_keywords VARCHAR(500),
    IN p_status TINYINT(1)
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra slug đã tồn tại chưa
    IF EXISTS(SELECT 1 FROM product_categories WHERE slug = p_slug) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slug đã tồn tại trong hệ thống';
    END IF;

    -- Kiểm tra parent_id có tồn tại không (nếu được cung cấp)
    IF p_parent_id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM product_categories WHERE id = p_parent_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danh mục cha không tồn tại';
    END IF;

    INSERT INTO product_categories (name, slug, parent_id, description, image_url, icon,
                                    display_order, is_featured, show_on_homepage,
                                    meta_title, meta_description, meta_keywords, status)
    VALUES (p_name, p_slug, p_parent_id, p_description, p_image_url, p_icon,
            IFNULL(p_display_order, 0), IFNULL(p_is_featured, 0), IFNULL(p_show_on_homepage, 0),
            p_meta_title, p_meta_description, p_meta_keywords, IFNULL(p_status, 1));
    COMMIT;
    SELECT LAST_INSERT_ID() as category_id, 'Tạo danh mục thành công' as message;
END//

-- READ - Lấy thông tin danh mục theo ID
DROP PROCEDURE IF EXISTS GetProductCategoryById//
CREATE PROCEDURE GetProductCategoryById(
    IN p_id INT
)
BEGIN
    SELECT pc.id,
           pc.name,
           pc.slug,
           pc.parent_id,
           pc.description,
           pc.image_url,
           pc.icon,
           pc.display_order,
           pc.is_featured,
           pc.show_on_homepage,
           pc.meta_title,
           pc.meta_description,
           pc.meta_keywords,
           pc.status,
           pc.created_at,
           pc.updated_at,
           parent.name                                                              as parent_name,
           parent.slug                                                              as parent_slug,
           (SELECT COUNT(*) FROM product_categories WHERE parent_id = pc.id)        as subcategory_count,
           (SELECT COUNT(*) FROM products WHERE category_id = pc.id AND status = 1) as product_count
    FROM product_categories pc
             LEFT JOIN product_categories parent ON pc.parent_id = parent.id
    WHERE pc.id = p_id;
END//

-- READ - Lấy danh sách tất cả danh mục (không phân trang)
DROP PROCEDURE IF EXISTS GetProductCategories//
CREATE PROCEDURE GetProductCategories(
    IN p_parent_id INT,
    IN p_status TINYINT(1),
    IN p_is_featured TINYINT(1),
    IN p_show_on_homepage TINYINT(1)
)
BEGIN
    SELECT pc.id,
           pc.name,
           pc.slug,
           pc.parent_id,
           pc.description,
           pc.image_url,
           pc.icon,
           pc.display_order,
           pc.is_featured,
           pc.show_on_homepage,
           pc.meta_title,
           pc.meta_description,
           pc.meta_keywords,
           pc.status,
           pc.created_at,
           pc.updated_at,
           parent.name                                                              as parent_name,
           parent.slug                                                              as parent_slug,
           (SELECT COUNT(*) FROM product_categories WHERE parent_id = pc.id)        as subcategory_count,
           (SELECT COUNT(*) FROM products WHERE category_id = pc.id AND status = 1) as product_count
    FROM product_categories pc
             LEFT JOIN product_categories parent ON pc.parent_id = parent.id
    WHERE (p_parent_id IS NULL OR pc.parent_id = p_parent_id)
      AND (p_status IS NULL OR pc.status = p_status)
      AND (p_is_featured IS NULL OR pc.is_featured = p_is_featured)
      AND (p_show_on_homepage IS NULL OR pc.show_on_homepage = p_show_on_homepage)
    ORDER BY pc.display_order ASC, pc.name ASC;
END//

-- READ - Lấy danh sách danh mục có phân trang (sử dụng dynamic SQL)
DROP PROCEDURE IF EXISTS GetProductCategoriesPaginated//
CREATE PROCEDURE GetProductCategoriesPaginated(
    IN p_parent_id INT,
    IN p_status TINYINT(1),
    IN p_is_featured TINYINT(1),
    IN p_show_on_homepage TINYINT(1),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SET @limit_val = IFNULL(p_limit, 50);
    SET @offset_val = IFNULL(p_offset, 0);

    SET @sql = 'SELECT
        pc.id,
        pc.name,
        pc.slug,
        pc.parent_id,
        pc.description,
        pc.image_url,
        pc.icon,
        pc.display_order,
        pc.is_featured,
        pc.show_on_homepage,
        pc.meta_title,
        pc.meta_description,
        pc.meta_keywords,
        pc.status,
        pc.created_at,
        pc.updated_at,
        parent.name as parent_name,
        parent.slug as parent_slug,
        (SELECT COUNT(*) FROM product_categories WHERE parent_id = pc.id) as subcategory_count,
        (SELECT COUNT(*) FROM products WHERE category_id = pc.id AND status = 1) as product_count
    FROM product_categories pc
    LEFT JOIN product_categories parent ON pc.parent_id = parent.id
    WHERE 1=1';

    IF p_parent_id IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND pc.parent_id = ', p_parent_id);
    END IF;

    IF p_status IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND pc.status = ', p_status);
    END IF;

    IF p_is_featured IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND pc.is_featured = ', p_is_featured);
    END IF;

    IF p_show_on_homepage IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND pc.show_on_homepage = ', p_show_on_homepage);
    END IF;

    SET @sql = CONCAT(@sql, ' ORDER BY pc.display_order ASC, pc.name ASC LIMIT ', @limit_val, ' OFFSET ', @offset_val);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- 4. UPDATE - Cập nhật thông tin danh mục
DROP PROCEDURE IF EXISTS UpdateProductCategory//
CREATE PROCEDURE UpdateProductCategory(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_slug VARCHAR(150),
    IN p_parent_id INT,
    IN p_description TEXT,
    IN p_image_url VARCHAR(500),
    IN p_icon VARCHAR(100),
    IN p_display_order INT,
    IN p_is_featured TINYINT(1),
    IN p_show_on_homepage TINYINT(1),
    IN p_meta_title VARCHAR(255),
    IN p_meta_description VARCHAR(500),
    IN p_meta_keywords VARCHAR(500),
    IN p_status TINYINT(1)
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_current_slug VARCHAR(150);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra danh mục có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM product_categories WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danh mục không tồn tại';
    END IF;

    -- Lấy slug hiện tại
    SELECT slug INTO v_current_slug FROM product_categories WHERE id = p_id;

    -- Kiểm tra slug mới có trùng với danh mục khác không
    IF p_slug != v_current_slug AND EXISTS(SELECT 1 FROM product_categories WHERE slug = p_slug AND id != p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slug đã tồn tại trong hệ thống';
    END IF;

    -- Kiểm tra parent_id có tồn tại không (nếu được cung cấp)
    IF p_parent_id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM product_categories WHERE id = p_parent_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danh mục cha không tồn tại';
    END IF;

    -- Kiểm tra không thể set parent_id = chính id của nó
    IF p_parent_id = p_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể đặt danh mục làm cha của chính nó';
    END IF;

    UPDATE product_categories
    SET name             = IFNULL(p_name, name),
        slug             = IFNULL(p_slug, slug),
        parent_id        = p_parent_id,
        description      = p_description,
        image_url        = p_image_url,
        icon             = p_icon,
        display_order    = IFNULL(p_display_order, display_order),
        is_featured      = IFNULL(p_is_featured, is_featured),
        show_on_homepage = IFNULL(p_show_on_homepage, show_on_homepage),
        meta_title       = p_meta_title,
        meta_description = p_meta_description,
        meta_keywords    = p_meta_keywords,
        status           = IFNULL(p_status, status),
        updated_at       = CURRENT_TIMESTAMP
    WHERE id = p_id;
    COMMIT;
    SELECT p_id as category_id, 'Cập nhật danh mục thành công' as message;
END//

-- 5. DELETE - Xóa mềm danh mục (set status = 0)
DROP PROCEDURE IF EXISTS SoftDeleteProductCategory//
CREATE PROCEDURE SoftDeleteProductCategory(
    IN p_id INT,
    IN p_admin_id INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_subcategory_count INT DEFAULT 0;
    DECLARE v_product_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra danh mục có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM product_categories WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danh mục không tồn tại';
    END IF;

    -- Kiểm tra có danh mục con không
    SELECT COUNT(*)
    INTO v_subcategory_count
    FROM product_categories
    WHERE parent_id = p_id
      AND status = 1;

    IF v_subcategory_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa danh mục có danh mục con';
    END IF;

    -- Kiểm tra có sản phẩm không
    SELECT COUNT(*)
    INTO v_product_count
    FROM products
    WHERE category_id = p_id
      AND status = 1;

    IF v_product_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa danh mục có sản phẩm';
    END IF;

    -- Xóa mềm danh mục
    UPDATE product_categories
    SET status     = 0,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    -- Ghi log hoạt động (nếu có bảng logs)
    -- INSERT INTO admin_activity_logs (admin_id, action, target_type, target_id, reason, created_at)
    -- VALUES (p_admin_id, 'soft_delete', 'product_category', p_id, p_reason, CURRENT_TIMESTAMP);

    COMMIT;
    SELECT p_id as category_id, 'Xóa danh mục thành công' as message;
END//

-- 6. DELETE - Xóa cứng danh mục (chỉ dành cho admin)
DROP PROCEDURE IF EXISTS HardDeleteProductCategory//
CREATE PROCEDURE HardDeleteProductCategory(
    IN p_id INT,
    IN p_admin_id INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_subcategory_count INT DEFAULT 0;
    DECLARE v_product_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra danh mục có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM product_categories WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danh mục không tồn tại';
    END IF;

    -- Kiểm tra có danh mục con không
    SELECT COUNT(*)
    INTO v_subcategory_count
    FROM product_categories
    WHERE parent_id = p_id;

    IF v_subcategory_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa danh mục có danh mục con';
    END IF;

    -- Kiểm tra có sản phẩm không
    SELECT COUNT(*)
    INTO v_product_count
    FROM products
    WHERE category_id = p_id;

    IF v_product_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa danh mục có sản phẩm';
    END IF;

    -- Xóa cứng danh mục
    DELETE FROM product_categories WHERE id = p_id;

    -- Ghi log hoạt động (nếu có bảng logs)
    -- INSERT INTO admin_activity_logs (admin_id, action, target_type, target_id, reason, created_at)
    -- VALUES (p_admin_id, 'hard_delete', 'product_category', p_id, p_reason, CURRENT_TIMESTAMP);

    COMMIT;
    SELECT p_id as category_id, 'Xóa vĩnh viễn danh mục thành công' as message;
END//

-- 7. Utility - Lấy cây danh mục (hierarchical)
DROP PROCEDURE IF EXISTS GetCategoryTree//
CREATE PROCEDURE GetCategoryTree(
    IN p_parent_id INT,
    IN p_max_depth INT
)
BEGIN
    WITH RECURSIVE category_tree AS (
        -- Base case: lấy danh mục gốc
        SELECT id,
               name,
               slug,
               parent_id,
               description,
               image_url,
               icon,
               display_order,
               is_featured,
               show_on_homepage,
               status,
               created_at,
               updated_at,
               0                        as depth,
               CAST(name AS CHAR(1000)) as path
        FROM product_categories
        WHERE parent_id IS NULL
           OR parent_id = IFNULL(p_parent_id, parent_id)

        UNION ALL

        -- Recursive case: lấy danh mục con
        SELECT pc.id,
               pc.name,
               pc.slug,
               pc.parent_id,
               pc.description,
               pc.image_url,
               pc.icon,
               pc.display_order,
               pc.is_featured,
               pc.show_on_homepage,
               pc.status,
               pc.created_at,
               pc.updated_at,
               ct.depth + 1,
               CONCAT(ct.path, ' > ', pc.name)
        FROM product_categories pc
                 INNER JOIN category_tree ct ON pc.parent_id = ct.id
        WHERE ct.depth < IFNULL(p_max_depth, 10))
    SELECT id,
           name,
           slug,
           parent_id,
           description,
           image_url,
           icon,
           display_order,
           is_featured,
           show_on_homepage,
           status,
           created_at,
           updated_at,
           depth,
           path,
           (SELECT COUNT(*) FROM products WHERE category_id = category_tree.id AND status = 1) as product_count
    FROM category_tree
    WHERE status = 1
    ORDER BY depth, display_order, name;
END//

-- 8. Utility - Cập nhật thứ tự hiển thị
DROP PROCEDURE IF EXISTS UpdateCategoryDisplayOrder//
CREATE PROCEDURE UpdateCategoryDisplayOrder(
    IN p_category_orders JSON
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_length INT;
    DECLARE v_category_id INT;
    DECLARE v_display_order INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    SET v_length = JSON_LENGTH(p_category_orders);

    WHILE v_i < v_length
        DO
            SET v_category_id = JSON_UNQUOTE(JSON_EXTRACT(p_category_orders, CONCAT('$[', v_i, '].id')));
            SET v_display_order = JSON_UNQUOTE(JSON_EXTRACT(p_category_orders, CONCAT('$[', v_i, '].display_order')));

            UPDATE product_categories
            SET display_order = v_display_order,
                updated_at    = CURRENT_TIMESTAMP
            WHERE id = v_category_id;

            SET v_i = v_i + 1;
        END WHILE;
    COMMIT;
    SELECT 'Cập nhật thứ tự hiển thị thành công' as message;
END//

DELIMITER ;

-- =============================
-- EXAMPLES - Ví dụ sử dụng các procedures
-- =============================

/*
-- 1. Tạo danh mục mới
CALL CreateProductCategory(
    'Điện thoại di động',           -- name
    'dien-thoai-di-dong',          -- slug
    NULL,                          -- parent_id (danh mục gốc)
    'Các sản phẩm điện thoại di động thông minh', -- description
    '/images/categories/phone.jpg', -- image_url
    'fas fa-mobile-alt',           -- icon
    1,                             -- display_order
    1,                             -- is_featured
    1,                             -- show_on_homepage
    'Điện thoại di động - Smartphone chính hãng', -- meta_title
    'Mua điện thoại di động chính hãng với giá tốt nhất', -- meta_description
    'điện thoại, smartphone, di động', -- meta_keywords
    1                              -- status
);

-- 2. Lấy thông tin danh mục theo ID
CALL GetProductCategoryById(1);

-- 3. Lấy danh sách danh mục (không phân trang)
CALL GetProductCategories(
    NULL,  -- parent_id (NULL = tất cả)
    1,     -- status (1 = active)
    NULL,  -- is_featured (NULL = tất cả)
    NULL   -- show_on_homepage (NULL = tất cả)
);

-- 3b. Lấy danh sách danh mục (có phân trang)
CALL GetProductCategoriesPaginated(
    NULL,  -- parent_id (NULL = tất cả)
    1,     -- status (1 = active)
    NULL,  -- is_featured (NULL = tất cả)
    NULL,  -- show_on_homepage (NULL = tất cả)
    10,    -- limit
    0      -- offset
);

-- 4. Cập nhật danh mục
CALL UpdateProductCategory(
    1,                             -- id
    'Điện thoại thông minh',       -- name mới
    'dien-thoai-thong-minh',      -- slug mới
    NULL,                          -- parent_id
    'Các sản phẩm điện thoại thông minh cao cấp', -- description mới
    '/images/categories/smartphone.jpg', -- image_url mới
    'fas fa-mobile-alt',           -- icon
    1,                             -- display_order
    1,                             -- is_featured
    1,                             -- show_on_homepage
    'Điện thoại thông minh - Smartphone cao cấp', -- meta_title
    'Mua điện thoại thông minh cao cấp với giá tốt', -- meta_description
    'điện thoại thông minh, smartphone cao cấp', -- meta_keywords
    1                              -- status
);

-- 5. Xóa mềm danh mục
CALL SoftDeleteProductCategory(
    1,                             -- category_id
    2,                             -- admin_id
    'Danh mục không còn sử dụng'   -- reason
);

-- 6. Lấy cây danh mục
CALL GetCategoryTree(NULL, 3);

-- 7. Cập nhật thứ tự hiển thị
CALL UpdateCategoryDisplayOrder(
    '[{"id": 1, "display_order": 1}, {"id": 2, "display_order": 2}, {"id": 3, "display_order": 3}]'
);
*/

-- =============================
-- STORED PROCEDURES CHO BẢNG PRODUCTS
-- =============================

-- 1. TRIGGER: Tự động cập nhật total_stock và total_sold của products
DELIMITER //

-- Trigger cập nhật total_stock và total_sold khi product_packages thay đổi
DROP TRIGGER IF EXISTS update_product_totals_after_package_insert//
CREATE TRIGGER update_product_totals_after_package_insert
    AFTER INSERT ON product_packages
    FOR EACH ROW
BEGIN
    UPDATE products
    SET total_stock = (
        SELECT COALESCE(SUM(stock_quantity), 0)
        FROM product_packages
        WHERE product_id = NEW.product_id AND status = 1
    ),
    total_sold = (
        SELECT COALESCE(SUM(sold_count), 0)
        FROM product_packages
        WHERE product_id = NEW.product_id AND status = 1
    )
    WHERE id = NEW.product_id;
END//

DROP TRIGGER IF EXISTS update_product_totals_after_package_update//
CREATE TRIGGER update_product_totals_after_package_update
    AFTER UPDATE ON product_packages
    FOR EACH ROW
BEGIN
    UPDATE products
    SET total_stock = (
        SELECT COALESCE(SUM(stock_quantity), 0)
        FROM product_packages
        WHERE product_id = NEW.product_id AND status = 1
    ),
    total_sold = (
        SELECT COALESCE(SUM(sold_count), 0)
        FROM product_packages
        WHERE product_id = NEW.product_id AND status = 1
    )
    WHERE id = NEW.product_id;
END//

DROP TRIGGER IF EXISTS update_product_totals_after_package_delete//
CREATE TRIGGER update_product_totals_after_package_delete
    AFTER DELETE ON product_packages
    FOR EACH ROW
BEGIN
    UPDATE products
    SET total_stock = (
        SELECT COALESCE(SUM(stock_quantity), 0)
        FROM product_packages
        WHERE product_id = OLD.product_id AND status = 1
    ),
    total_sold = (
        SELECT COALESCE(SUM(sold_count), 0)
        FROM product_packages
        WHERE product_id = OLD.product_id AND status = 1
    )
    WHERE id = OLD.product_id;
END//

-- 2. FUNCTION: Kiểm tra category có active không
DROP FUNCTION IF EXISTS IsCategoryActive//
CREATE FUNCTION IsCategoryActive(p_category_id INT)
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count
    FROM product_categories
    WHERE id = p_category_id AND status = 1;

    RETURN v_count > 0;
END//

-- 3. FUNCTION: Lấy VAT rate theo package type
DROP FUNCTION IF EXISTS GetVatRate//
CREATE FUNCTION GetVatRate(p_package_type VARCHAR(10))
RETURNS DECIMAL(4,3)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_vat_rate DECIMAL(4,3) DEFAULT 0.01;
    
    SELECT vat_rate INTO v_vat_rate
    FROM vat_settings 
    WHERE package_type = p_package_type AND is_active = 1
    LIMIT 1;
    
    -- Nếu không tìm thấy, trả về mặc định
    IF v_vat_rate IS NULL THEN
        SET v_vat_rate = IF(p_package_type = 'rental', 0.05, 0.01);
    END IF;
    
    RETURN v_vat_rate;
END//

-- 4. FUNCTION: Tạo slug tự động từ tên sản phẩm
DROP FUNCTION IF EXISTS GenerateProductSlug//
CREATE FUNCTION GenerateProductSlug(p_name VARCHAR(255))
RETURNS VARCHAR(255)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_slug VARCHAR(255);
    DECLARE v_counter INT DEFAULT 0;
    DECLARE v_final_slug VARCHAR(255);

    -- Tạo slug cơ bản
    SET v_slug = LOWER(p_name);
    SET v_slug = REPLACE(v_slug, ' ', '-');
    SET v_slug = REPLACE(v_slug, 'à', 'a');
    SET v_slug = REPLACE(v_slug, 'á', 'a');
    SET v_slug = REPLACE(v_slug, 'ả', 'a');
    SET v_slug = REPLACE(v_slug, 'ã', 'a');
    SET v_slug = REPLACE(v_slug, 'ạ', 'a');
    SET v_slug = REPLACE(v_slug, 'ă', 'a');
    SET v_slug = REPLACE(v_slug, 'ằ', 'a');
    SET v_slug = REPLACE(v_slug, 'ắ', 'a');
    SET v_slug = REPLACE(v_slug, 'ẳ', 'a');
    SET v_slug = REPLACE(v_slug, 'ẵ', 'a');
    SET v_slug = REPLACE(v_slug, 'ặ', 'a');
    SET v_slug = REPLACE(v_slug, 'â', 'a');
    SET v_slug = REPLACE(v_slug, 'ầ', 'a');
    SET v_slug = REPLACE(v_slug, 'ấ', 'a');
    SET v_slug = REPLACE(v_slug, 'ẩ', 'a');
    SET v_slug = REPLACE(v_slug, 'ẫ', 'a');
    SET v_slug = REPLACE(v_slug, 'ậ', 'a');
    SET v_slug = REPLACE(v_slug, 'è', 'e');
    SET v_slug = REPLACE(v_slug, 'é', 'e');
    SET v_slug = REPLACE(v_slug, 'ẻ', 'e');
    SET v_slug = REPLACE(v_slug, 'ẽ', 'e');
    SET v_slug = REPLACE(v_slug, 'ẹ', 'e');
    SET v_slug = REPLACE(v_slug, 'ê', 'e');
    SET v_slug = REPLACE(v_slug, 'ề', 'e');
    SET v_slug = REPLACE(v_slug, 'ế', 'e');
    SET v_slug = REPLACE(v_slug, 'ể', 'e');
    SET v_slug = REPLACE(v_slug, 'ễ', 'e');
    SET v_slug = REPLACE(v_slug, 'ệ', 'e');
    SET v_slug = REPLACE(v_slug, 'ì', 'i');
    SET v_slug = REPLACE(v_slug, 'í', 'i');
    SET v_slug = REPLACE(v_slug, 'ỉ', 'i');
    SET v_slug = REPLACE(v_slug, 'ĩ', 'i');
    SET v_slug = REPLACE(v_slug, 'ị', 'i');
    SET v_slug = REPLACE(v_slug, 'ò', 'o');
    SET v_slug = REPLACE(v_slug, 'ó', 'o');
    SET v_slug = REPLACE(v_slug, 'ỏ', 'o');
    SET v_slug = REPLACE(v_slug, 'õ', 'o');
    SET v_slug = REPLACE(v_slug, 'ọ', 'o');
    SET v_slug = REPLACE(v_slug, 'ô', 'o');
    SET v_slug = REPLACE(v_slug, 'ồ', 'o');
    SET v_slug = REPLACE(v_slug, 'ố', 'o');
    SET v_slug = REPLACE(v_slug, 'ổ', 'o');
    SET v_slug = REPLACE(v_slug, 'ỗ', 'o');
    SET v_slug = REPLACE(v_slug, 'ộ', 'o');
    SET v_slug = REPLACE(v_slug, 'ơ', 'o');
    SET v_slug = REPLACE(v_slug, 'ờ', 'o');
    SET v_slug = REPLACE(v_slug, 'ớ', 'o');
    SET v_slug = REPLACE(v_slug, 'ở', 'o');
    SET v_slug = REPLACE(v_slug, 'ỡ', 'o');
    SET v_slug = REPLACE(v_slug, 'ợ', 'o');
    SET v_slug = REPLACE(v_slug, 'ù', 'u');
    SET v_slug = REPLACE(v_slug, 'ú', 'u');
    SET v_slug = REPLACE(v_slug, 'ủ', 'u');
    SET v_slug = REPLACE(v_slug, 'ũ', 'u');
    SET v_slug = REPLACE(v_slug, 'ụ', 'u');
    SET v_slug = REPLACE(v_slug, 'ư', 'u');
    SET v_slug = REPLACE(v_slug, 'ừ', 'u');
    SET v_slug = REPLACE(v_slug, 'ứ', 'u');
    SET v_slug = REPLACE(v_slug, 'ử', 'u');
    SET v_slug = REPLACE(v_slug, 'ữ', 'u');
    SET v_slug = REPLACE(v_slug, 'ự', 'u');
    SET v_slug = REPLACE(v_slug, 'ỳ', 'y');
    SET v_slug = REPLACE(v_slug, 'ý', 'y');
    SET v_slug = REPLACE(v_slug, 'ỷ', 'y');
    SET v_slug = REPLACE(v_slug, 'ỹ', 'y');
    SET v_slug = REPLACE(v_slug, 'ỵ', 'y');
    SET v_slug = REPLACE(v_slug, 'đ', 'd');

    -- Loại bỏ ký tự đặc biệt
    SET v_slug = REGEXP_REPLACE(v_slug, '[^a-z0-9-]', '');
    SET v_slug = REGEXP_REPLACE(v_slug, '-+', '-');
    SET v_slug = TRIM(BOTH '-' FROM v_slug);

    -- Kiểm tra slug đã tồn tại chưa và thêm số nếu cần
    SET v_final_slug = v_slug;
    WHILE EXISTS(SELECT 1 FROM products WHERE slug = v_final_slug) DO
        SET v_counter = v_counter + 1;
        SET v_final_slug = CONCAT(v_slug, '-', v_counter);
    END WHILE;

    RETURN v_final_slug;
END//

-- 4. CREATE - Tạo sản phẩm mới
DROP PROCEDURE IF EXISTS CreateProduct//
CREATE PROCEDURE CreateProduct(
    IN p_name VARCHAR(255),
    IN p_slug VARCHAR(255),
    IN p_category_id INT,
    IN p_description TEXT,
    IN p_image_url VARCHAR(500),
    IN p_status TINYINT(1)
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_final_slug VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra category có tồn tại và active không
    IF NOT IsCategoryActive(p_category_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danh mục không tồn tại hoặc không hoạt động';
    END IF;

    -- Tạo slug tự động nếu không được cung cấp
    IF p_slug IS NULL OR p_slug = '' THEN
        SET v_final_slug = GenerateProductSlug(p_name);
    ELSE
        -- Kiểm tra slug đã tồn tại chưa
        IF EXISTS(SELECT 1 FROM products WHERE slug = p_slug) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slug đã tồn tại trong hệ thống';
        END IF;
        SET v_final_slug = p_slug;
    END IF;

    -- Thêm sản phẩm mới
    INSERT INTO products (name, slug, category_id, description, image_url, status, total_stock, total_sold)
    VALUES (p_name, v_final_slug, p_category_id, p_description, p_image_url, IFNULL(p_status, 1), 0, 0);

    COMMIT;
    SELECT LAST_INSERT_ID() as product_id, v_final_slug as slug, 'Tạo sản phẩm thành công' as message;
END//

-- 5. READ - Lấy thông tin sản phẩm theo ID
DROP PROCEDURE IF EXISTS GetProductById//
CREATE PROCEDURE GetProductById(
    IN p_id INT
)
BEGIN
    SELECT p.id,
           p.name,
           p.slug,
           p.category_id,
           p.description,
           p.image_url,
           p.status,
           p.total_stock,
           p.total_sold,
           p.created_at,
           p.updated_at,
           -- Thông tin category
           pc.name as category_name,
           pc.slug as category_slug,
           pc.status as category_status,
           -- Thống kê packages
           (SELECT COUNT(*) FROM product_packages WHERE product_id = p.id AND status = 1) as active_packages_count,
           (SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) as min_price,
           (SELECT MAX(price) FROM product_packages WHERE product_id = p.id AND status = 1) as max_price,
           -- Thống kê đánh giá (tổng hợp từ tất cả packages)
           (SELECT COUNT(*) FROM product_reviews pr
            JOIN product_packages pp ON pr.package_id = pp.id
            WHERE pp.product_id = p.id) as review_count,
           (SELECT AVG(pr.rating) FROM product_reviews pr
            JOIN product_packages pp ON pr.package_id = pp.id
            WHERE pp.product_id = p.id) as avg_rating
    FROM products p
    LEFT JOIN product_categories pc ON p.category_id = pc.id
    WHERE p.id = p_id;
END//

-- 6. READ - Lấy danh sách sản phẩm với phân trang và bộ lọc
DROP PROCEDURE IF EXISTS GetProducts//
CREATE PROCEDURE GetProducts(
    IN p_category_id INT,
    IN p_status TINYINT(1),
    IN p_search_keyword VARCHAR(255),
    IN p_min_price DECIMAL(15,2),
    IN p_max_price DECIMAL(15,2),
    IN p_sort_by VARCHAR(50), -- 'name', 'price_asc', 'price_desc', 'created_at', 'total_sold'
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    DECLARE v_sql TEXT DEFAULT '';
    DECLARE v_where_clause TEXT DEFAULT 'WHERE 1=1';
    DECLARE v_order_clause TEXT DEFAULT 'ORDER BY p.created_at DESC';

    -- Xây dựng WHERE clause
    IF p_category_id IS NOT NULL THEN
        SET v_where_clause = CONCAT(v_where_clause, ' AND p.category_id = ', p_category_id);
    END IF;

    IF p_status IS NOT NULL THEN
        SET v_where_clause = CONCAT(v_where_clause, ' AND p.status = ', p_status);
    END IF;

    IF p_search_keyword IS NOT NULL AND p_search_keyword != '' THEN
        SET v_where_clause = CONCAT(v_where_clause, ' AND (p.name LIKE ''%', p_search_keyword, '%'' OR p.description LIKE ''%', p_search_keyword, '%'')');
    END IF;

    -- Lọc theo giá (dựa trên min_price của packages)
    IF p_min_price IS NOT NULL THEN
        SET v_where_clause = CONCAT(v_where_clause, ' AND (SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) >= ', p_min_price);
    END IF;

    IF p_max_price IS NOT NULL THEN
        SET v_where_clause = CONCAT(v_where_clause, ' AND (SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) <= ', p_max_price);
    END IF;

    -- Xây dựng ORDER BY clause
    CASE p_sort_by
        WHEN 'name' THEN SET v_order_clause = 'ORDER BY p.name ASC';
        WHEN 'price_asc' THEN SET v_order_clause = 'ORDER BY min_price ASC';
        WHEN 'price_desc' THEN SET v_order_clause = 'ORDER BY min_price DESC';
        WHEN 'total_sold' THEN SET v_order_clause = 'ORDER BY p.total_sold DESC';
        WHEN 'created_at' THEN SET v_order_clause = 'ORDER BY p.created_at DESC';
        ELSE SET v_order_clause = 'ORDER BY p.created_at DESC';
    END CASE;

    -- Xây dựng câu query chính
    SET v_sql = CONCAT(
        'SELECT p.id, p.name, p.slug, p.category_id, p.description, p.image_url, p.status, ',
        'p.total_stock, p.total_sold, p.created_at, p.updated_at, ',
        'pc.name as category_name, pc.slug as category_slug, ',
        '(SELECT COUNT(*) FROM product_packages WHERE product_id = p.id AND status = 1) as active_packages_count, ',
        '(SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) as min_price, ',
        '(SELECT MAX(price) FROM product_packages WHERE product_id = p.id AND status = 1) as max_price, ',
        '(SELECT COUNT(*) FROM product_reviews pr JOIN product_packages pp ON pr.package_id = pp.id WHERE pp.product_id = p.id) as review_count, ',
        '(SELECT AVG(pr.rating) FROM product_reviews pr JOIN product_packages pp ON pr.package_id = pp.id WHERE pp.product_id = p.id) as avg_rating ',
        'FROM products p ',
        'LEFT JOIN product_categories pc ON p.category_id = pc.id ',
        v_where_clause, ' ',
        v_order_clause
    );

    -- Thêm LIMIT và OFFSET
    IF p_limit IS NOT NULL THEN
        SET v_sql = CONCAT(v_sql, ' LIMIT ', IFNULL(p_limit, 20));
        IF p_offset IS NOT NULL THEN
            SET v_sql = CONCAT(v_sql, ' OFFSET ', IFNULL(p_offset, 0));
        END IF;
    END IF;

    SET @sql_query = v_sql;
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- 7. UPDATE - Cập nhật thông tin sản phẩm
DROP PROCEDURE IF EXISTS UpdateProduct//
CREATE PROCEDURE UpdateProduct(
    IN p_id INT,
    IN p_name VARCHAR(255),
    IN p_slug VARCHAR(255),
    IN p_category_id INT,
    IN p_description TEXT,
    IN p_image_url VARCHAR(500),
    IN p_status TINYINT(1)
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_current_slug VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra sản phẩm có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM products WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sản phẩm không tồn tại';
    END IF;

    -- Kiểm tra category nếu được cung cấp
    IF p_category_id IS NOT NULL AND NOT IsCategoryActive(p_category_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danh mục không tồn tại hoặc không hoạt động';
    END IF;

    -- Kiểm tra slug nếu được cung cấp
    IF p_slug IS NOT NULL THEN
        SELECT slug INTO v_current_slug FROM products WHERE id = p_id;
        IF p_slug != v_current_slug AND EXISTS(SELECT 1 FROM products WHERE slug = p_slug) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slug đã tồn tại trong hệ thống';
        END IF;
    END IF;

    -- Cập nhật sản phẩm
    UPDATE products
    SET name = IFNULL(p_name, name),
        slug = IFNULL(p_slug, slug),
        category_id = IFNULL(p_category_id, category_id),
        description = IFNULL(p_description, description),
        image_url = IFNULL(p_image_url, image_url),
        status = IFNULL(p_status, status),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    COMMIT;
    SELECT p_id as product_id, 'Cập nhật sản phẩm thành công' as message;
END//

-- 8. DELETE - Xóa mềm sản phẩm (set status = 0)
DROP PROCEDURE IF EXISTS SoftDeleteProduct//
CREATE PROCEDURE SoftDeleteProduct(
    IN p_id INT,
    IN p_admin_id INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_package_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra sản phẩm có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM products WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sản phẩm không tồn tại';
    END IF;

    -- Kiểm tra có packages active không
    SELECT COUNT(*) INTO v_package_count
    FROM product_packages
    WHERE product_id = p_id AND status = 1;

    IF v_package_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa sản phẩm vì còn có gói sản phẩm đang hoạt động';
    END IF;

    -- Xóa mềm sản phẩm
    UPDATE products
    SET status = 0,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;

    -- Log việc xóa (nếu có bảng log)
    -- INSERT INTO product_logs (product_id, admin_id, action, reason, created_at)
    -- VALUES (p_id, p_admin_id, 'soft_delete', p_reason, CURRENT_TIMESTAMP);

    COMMIT;
    SELECT p_id as product_id, 'Xóa sản phẩm thành công' as message;
END//

-- 9. DELETE - Xóa vĩnh viễn sản phẩm
DROP PROCEDURE IF EXISTS HardDeleteProduct//
CREATE PROCEDURE HardDeleteProduct(
    IN p_id INT,
    IN p_admin_id INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_order_count INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra sản phẩm có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM products WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sản phẩm không tồn tại';
    END IF;

    -- Kiểm tra có đơn hàng liên quan không
    SELECT COUNT(*) INTO v_order_count
    FROM order_items oi
    JOIN product_packages pp ON oi.package_id = pp.id
    WHERE pp.product_id = p_id;

    IF v_order_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa vĩnh viễn sản phẩm vì có đơn hàng liên quan';
    END IF;

    -- Xóa các bảng liên quan (CASCADE sẽ tự động xóa)
    DELETE FROM products WHERE id = p_id;

    COMMIT;
    SELECT p_id as product_id, 'Xóa vĩnh viễn sản phẩm thành công' as message;
END//

-- 10. UTILITY - Lấy sản phẩm theo category (bao gồm category con)
DROP PROCEDURE IF EXISTS GetProductsByCategory//
CREATE PROCEDURE GetProductsByCategory(
    IN p_category_id INT,
    IN p_include_subcategories BOOLEAN,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    DECLARE v_sql TEXT;

    IF p_include_subcategories THEN
        -- Lấy sản phẩm từ category và tất cả category con
        SET v_sql = CONCAT(
            'SELECT DISTINCT p.id, p.name, p.slug, p.category_id, p.description, p.image_url, ',
            'p.status, p.total_stock, p.total_sold, p.created_at, p.updated_at, ',
            'pc.name as category_name, pc.slug as category_slug, ',
            '(SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) as min_price, ',
            '(SELECT MAX(price) FROM product_packages WHERE product_id = p.id AND status = 1) as max_price ',
            'FROM products p ',
            'JOIN product_categories pc ON p.category_id = pc.id ',
            'WHERE p.status = 1 AND pc.status = 1 AND (',
            'pc.id = ', p_category_id, ' OR pc.parent_id = ', p_category_id,
            ') ORDER BY p.created_at DESC'
        );
    ELSE
        -- Chỉ lấy sản phẩm từ category được chỉ định
        SET v_sql = CONCAT(
            'SELECT p.id, p.name, p.slug, p.category_id, p.description, p.image_url, ',
            'p.status, p.total_stock, p.total_sold, p.created_at, p.updated_at, ',
            'pc.name as category_name, pc.slug as category_slug, ',
            '(SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) as min_price, ',
            '(SELECT MAX(price) FROM product_packages WHERE product_id = p.id AND status = 1) as max_price ',
            'FROM products p ',
            'JOIN product_categories pc ON p.category_id = pc.id ',
            'WHERE p.status = 1 AND pc.status = 1 AND p.category_id = ', p_category_id,
            ' ORDER BY p.created_at DESC'
        );
    END IF;

    -- Thêm LIMIT và OFFSET
    IF p_limit IS NOT NULL THEN
        SET v_sql = CONCAT(v_sql, ' LIMIT ', IFNULL(p_limit, 20));
        IF p_offset IS NOT NULL THEN
            SET v_sql = CONCAT(v_sql, ' OFFSET ', IFNULL(p_offset, 0));
        END IF;
    END IF;

    SET @sql_query = v_sql;
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- 11. UTILITY - Đếm số lượng sản phẩm theo các điều kiện
DROP PROCEDURE IF EXISTS CountProducts//
CREATE PROCEDURE CountProducts(
    IN p_category_id INT,
    IN p_status TINYINT(1),
    IN p_search_keyword VARCHAR(255),
    IN p_min_price DECIMAL(15,2),
    IN p_max_price DECIMAL(15,2)
)
BEGIN
    DECLARE v_sql TEXT DEFAULT 'SELECT COUNT(*) as total_count FROM products p LEFT JOIN product_categories pc ON p.category_id = pc.id WHERE 1=1';

    IF p_category_id IS NOT NULL THEN
        SET v_sql = CONCAT(v_sql, ' AND p.category_id = ', p_category_id);
    END IF;

    IF p_status IS NOT NULL THEN
        SET v_sql = CONCAT(v_sql, ' AND p.status = ', p_status);
    END IF;

    IF p_search_keyword IS NOT NULL AND p_search_keyword != '' THEN
        SET v_sql = CONCAT(v_sql, ' AND (p.name LIKE ''%', p_search_keyword, '%'' OR p.description LIKE ''%', p_search_keyword, '%'')');
    END IF;

    IF p_min_price IS NOT NULL THEN
        SET v_sql = CONCAT(v_sql, ' AND (SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) >= ', p_min_price);
    END IF;

    IF p_max_price IS NOT NULL THEN
        SET v_sql = CONCAT(v_sql, ' AND (SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) <= ', p_max_price);
    END IF;

    SET @sql_query = v_sql;
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

-- 12. UTILITY - Quản lý mối quan hệ Products-Packages (1-N)
DROP PROCEDURE IF EXISTS CreateProductWithPackages//
CREATE PROCEDURE CreateProductWithPackages(
    IN p_product_name VARCHAR(255),
    IN p_product_slug VARCHAR(255),
    IN p_category_id INT,
    IN p_product_description TEXT,
    IN p_product_image_url VARCHAR(500),
    IN p_product_status TINYINT(1),
    IN p_packages_json JSON -- Array of package objects
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_product_id INT;
    DECLARE v_package_count INT DEFAULT 0;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_package_name VARCHAR(255);
    DECLARE v_package_price DECIMAL(15,2);
    DECLARE v_package_old_price DECIMAL(15,2);
    DECLARE v_package_stock INT;
    DECLARE v_package_type VARCHAR(10);
    DECLARE v_package_description TEXT;
    DECLARE v_vat_rate DECIMAL(4,3);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Tạo product trước
    CALL CreateProduct(p_product_name, p_product_slug, p_category_id,
                      p_product_description, p_product_image_url, p_product_status);

    SET v_product_id = LAST_INSERT_ID();

    -- Thêm các packages
    IF p_packages_json IS NOT NULL THEN
        SET v_package_count = JSON_LENGTH(p_packages_json);

        WHILE v_i < v_package_count DO
            SET v_package_name = JSON_UNQUOTE(JSON_EXTRACT(p_packages_json, CONCAT('$[', v_i, '].name')));
            SET v_package_price = JSON_UNQUOTE(JSON_EXTRACT(p_packages_json, CONCAT('$[', v_i, '].price')));
            SET v_package_old_price = JSON_UNQUOTE(JSON_EXTRACT(p_packages_json, CONCAT('$[', v_i, '].old_price')));
            SET v_package_stock = JSON_UNQUOTE(JSON_EXTRACT(p_packages_json, CONCAT('$[', v_i, '].stock_quantity')));
            SET v_package_type = JSON_UNQUOTE(JSON_EXTRACT(p_packages_json, CONCAT('$[', v_i, '].package_type')));
            SET v_package_description = JSON_UNQUOTE(JSON_EXTRACT(p_packages_json, CONCAT('$[', v_i, '].description')));

            -- Tính VAT rate dựa trên package_type (lấy từ bảng cấu hình)
            SET v_vat_rate = GetVatRate(IFNULL(v_package_type, 'sale'));

            INSERT INTO product_packages (
                product_id, name, description, price, old_price,
                stock_quantity, package_type, vat_rate, status
            ) VALUES (
                v_product_id, v_package_name, v_package_description,
                v_package_price, v_package_old_price, IFNULL(v_package_stock, 0),
                IFNULL(v_package_type, 'sale'), v_vat_rate, 1
            );

            SET v_i = v_i + 1;
        END WHILE;
    END IF;

    COMMIT;
    SELECT v_product_id as product_id, 'Tạo sản phẩm và packages thành công' as message;
END//

-- 13. UTILITY - Lấy product với tất cả packages
DROP PROCEDURE IF EXISTS GetProductWithPackages//
CREATE PROCEDURE GetProductWithPackages(
    IN p_product_id INT
)
BEGIN
    -- Lấy thông tin product
    SELECT p.id,
           p.name,
           p.slug,
           p.category_id,
           p.description,
           p.image_url,
           p.status,
           p.total_stock,
           p.total_sold,
           p.created_at,
           p.updated_at,
           pc.name as category_name,
           pc.slug as category_slug,
           -- Thống kê packages
           (SELECT COUNT(*) FROM product_packages WHERE product_id = p.id) as total_packages,
           (SELECT COUNT(*) FROM product_packages WHERE product_id = p.id AND status = 1) as active_packages,
           (SELECT MIN(price) FROM product_packages WHERE product_id = p.id AND status = 1) as min_price,
           (SELECT MAX(price) FROM product_packages WHERE product_id = p.id AND status = 1) as max_price,
           (SELECT AVG(price) FROM product_packages WHERE product_id = p.id AND status = 1) as avg_price
    FROM products p
    LEFT JOIN product_categories pc ON p.category_id = pc.id
    WHERE p.id = p_product_id;

    -- Lấy tất cả packages của product
    SELECT pp.id,
           pp.name,
           pp.description,
           pp.price,
           pp.old_price,
           pp.percent_off,
           pp.duration_days,
           pp.stock_quantity,
           pp.sold_count,
           pp.details,
           pp.note,
           pp.package_type,
           pp.vat_rate,
           pp.status,
           pp.max_cart_quantity,
           pp.created_at,
           pp.updated_at,
           -- Tính toán thêm
           (pp.price * pp.vat_rate) as vat_amount,
           (pp.price + (pp.price * pp.vat_rate)) as final_price,
           -- Thống kê đánh giá riêng cho từng package
           (SELECT COUNT(*) FROM product_reviews WHERE package_id = pp.id) as package_review_count,
           (SELECT AVG(rating) FROM product_reviews WHERE package_id = pp.id) as package_avg_rating,
           (SELECT MIN(rating) FROM product_reviews WHERE package_id = pp.id) as package_min_rating,
           (SELECT MAX(rating) FROM product_reviews WHERE package_id = pp.id) as package_max_rating
    FROM product_packages pp
    WHERE pp.product_id = p_product_id
    ORDER BY pp.price ASC, pp.created_at DESC;
END//

-- 14. UTILITY - Cập nhật package và tự động cập nhật product totals
DROP PROCEDURE IF EXISTS UpdatePackage//
CREATE PROCEDURE UpdatePackage(
    IN p_package_id INT,
    IN p_name VARCHAR(255),
    IN p_description TEXT,
    IN p_price DECIMAL(15,2),
    IN p_old_price DECIMAL(15,2),
    IN p_stock_quantity INT,
    IN p_package_type VARCHAR(10),
    IN p_status TINYINT(1)
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_product_id INT;
    DECLARE v_vat_rate DECIMAL(4,3);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra package có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM product_packages WHERE id = p_package_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Package không tồn tại';
    END IF;

    -- Lấy product_id
    SELECT product_id INTO v_product_id FROM product_packages WHERE id = p_package_id;

    -- Tính VAT rate (lấy từ bảng cấu hình)
    SET v_vat_rate = GetVatRate(IFNULL(p_package_type, 'sale'));

    -- Cập nhật package
    UPDATE product_packages
    SET name = IFNULL(p_name, name),
        description = IFNULL(p_description, description),
        price = IFNULL(p_price, price),
        old_price = p_old_price,
        stock_quantity = IFNULL(p_stock_quantity, stock_quantity),
        package_type = IFNULL(p_package_type, package_type),
        vat_rate = v_vat_rate,
        status = IFNULL(p_status, status),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_package_id;

    -- Trigger sẽ tự động cập nhật product totals

    COMMIT;
    SELECT p_package_id as package_id, v_product_id as product_id, 'Cập nhật package thành công' as message;
END//

-- 15. UTILITY - Xóa package và cập nhật product
DROP PROCEDURE IF EXISTS DeletePackage//
CREATE PROCEDURE DeletePackage(
    IN p_package_id INT,
    IN p_soft_delete BOOLEAN -- TRUE: soft delete, FALSE: hard delete
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_product_id INT;
    DECLARE v_order_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra package có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM product_packages WHERE id = p_package_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Package không tồn tại';
    END IF;

    -- Lấy product_id
    SELECT product_id INTO v_product_id FROM product_packages WHERE id = p_package_id;

    IF p_soft_delete THEN
        -- Soft delete: chỉ set status = 0
        UPDATE product_packages SET status = 0, updated_at = CURRENT_TIMESTAMP WHERE id = p_package_id;
    ELSE
        -- Hard delete: kiểm tra có order liên quan không
        SELECT COUNT(*) INTO v_order_count FROM order_items WHERE package_id = p_package_id;

        IF v_order_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa package vì có đơn hàng liên quan';
        END IF;

        DELETE FROM product_packages WHERE id = p_package_id;
    END IF;

    -- Trigger sẽ tự động cập nhật product totals

    COMMIT;
    SELECT p_package_id as package_id, v_product_id as product_id, 'Xóa package thành công' as message;
END//

-- 16. UTILITY - Thống kê chi tiết về products và packages
DROP PROCEDURE IF EXISTS GetProductPackageStats//
CREATE PROCEDURE GetProductPackageStats(
    IN p_category_id INT,
    IN p_package_type VARCHAR(10)
)
BEGIN
    SELECT
        p.id as product_id,
        p.name as product_name,
        p.slug as product_slug,
        pc.name as category_name,
        p.status as product_status,

        -- Thống kê packages
        COUNT(pp.id) as total_packages,
        COUNT(CASE WHEN pp.status = 1 THEN 1 END) as active_packages,
        COUNT(CASE WHEN pp.package_type = 'sale' THEN 1 END) as sale_packages,
        COUNT(CASE WHEN pp.package_type = 'rental' THEN 1 END) as rental_packages,

        -- Thống kê giá
        MIN(CASE WHEN pp.status = 1 THEN pp.price END) as min_price,
        MAX(CASE WHEN pp.status = 1 THEN pp.price END) as max_price,
        AVG(CASE WHEN pp.status = 1 THEN pp.price END) as avg_price,

        -- Thống kê tồn kho
        SUM(CASE WHEN pp.status = 1 THEN pp.stock_quantity ELSE 0 END) as total_stock,
        SUM(CASE WHEN pp.status = 1 THEN pp.sold_count ELSE 0 END) as total_sold,

        -- Thống kê doanh thu ước tính
        SUM(CASE WHEN pp.status = 1 THEN (pp.sold_count * pp.price) ELSE 0 END) as estimated_revenue,

        p.created_at,
        p.updated_at

    FROM products p
    LEFT JOIN product_categories pc ON p.category_id = pc.id
    LEFT JOIN product_packages pp ON p.id = pp.product_id
    WHERE 1=1
        AND (p_category_id IS NULL OR p.category_id = p_category_id)
        AND (p_package_type IS NULL OR pp.package_type = p_package_type)
    GROUP BY p.id, p.name, p.slug, pc.name, p.status, p.created_at, p.updated_at
    ORDER BY estimated_revenue DESC, p.name ASC;
END//

-- 17. UTILITY - Kiểm tra tính nhất quán dữ liệu products-packages
DROP PROCEDURE IF EXISTS ValidateProductPackageConsistency//
CREATE PROCEDURE ValidateProductPackageConsistency()
BEGIN
    -- Kiểm tra products có total_stock/total_sold không khớp với packages
    SELECT
        p.id,
        p.name,
        p.total_stock as product_total_stock,
        p.total_sold as product_total_sold,
        COALESCE(SUM(CASE WHEN pp.status = 1 THEN pp.stock_quantity ELSE 0 END), 0) as calculated_stock,
        COALESCE(SUM(CASE WHEN pp.status = 1 THEN pp.sold_count ELSE 0 END), 0) as calculated_sold,
        -- Kiểm tra có lệch không
        CASE
            WHEN p.total_stock != COALESCE(SUM(CASE WHEN pp.status = 1 THEN pp.stock_quantity ELSE 0 END), 0)
            THEN 'STOCK_MISMATCH'
            ELSE 'OK'
        END as stock_status,
        CASE
            WHEN p.total_sold != COALESCE(SUM(CASE WHEN pp.status = 1 THEN pp.sold_count ELSE 0 END), 0)
            THEN 'SOLD_MISMATCH'
            ELSE 'OK'
        END as sold_status
    FROM products p
    LEFT JOIN product_packages pp ON p.id = pp.product_id
    GROUP BY p.id, p.name, p.total_stock, p.total_sold
    HAVING stock_status = 'STOCK_MISMATCH' OR sold_status = 'SOLD_MISMATCH'
    ORDER BY p.id;
END//

-- 18. UTILITY - Sửa lỗi tính nhất quán dữ liệu
DROP PROCEDURE IF EXISTS FixProductPackageConsistency//
CREATE PROCEDURE FixProductPackageConsistency()
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_fixed_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Cập nhật lại total_stock và total_sold cho tất cả products
    UPDATE products p
    SET total_stock = (
        SELECT COALESCE(SUM(stock_quantity), 0)
        FROM product_packages pp
        WHERE pp.product_id = p.id AND pp.status = 1
    ),
    total_sold = (
        SELECT COALESCE(SUM(sold_count), 0)
        FROM product_packages pp
        WHERE pp.product_id = p.id AND pp.status = 1
    );

    SET v_fixed_count = ROW_COUNT();

    COMMIT;
    SELECT v_fixed_count as fixed_products_count, 'Đã sửa lỗi tính nhất quán dữ liệu' as message;
END//

-- =============================
-- STORED PROCEDURES CHO PACKAGE REVIEWS
-- =============================

-- 19. Tạo đánh giá cho package
DROP PROCEDURE IF EXISTS CreatePackageReview//
CREATE PROCEDURE CreatePackageReview(
    IN p_package_id INT,
    IN p_user_id INT,
    IN p_rating TINYINT,
    IN p_review_text TEXT
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_product_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra package có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM product_packages WHERE id = p_package_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Package không tồn tại';
    END IF;

    -- Kiểm tra rating hợp lệ
    IF p_rating < 1 OR p_rating > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rating phải từ 1 đến 5';
    END IF;

    -- Kiểm tra user đã đánh giá package này chưa
    IF EXISTS(SELECT 1 FROM product_reviews WHERE package_id = p_package_id AND user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bạn đã đánh giá package này rồi';
    END IF;

    -- Lấy product_id để trả về
    SELECT product_id INTO v_product_id FROM product_packages WHERE id = p_package_id;

    -- Thêm đánh giá
    INSERT INTO product_reviews (package_id, user_id, rating, review_text)
    VALUES (p_package_id, p_user_id, p_rating, p_review_text);

    COMMIT;
    SELECT LAST_INSERT_ID() as review_id, p_package_id as package_id, v_product_id as product_id, 'Tạo đánh giá thành công' as message;
END//

-- 20. Lấy đánh giá của một package
DROP PROCEDURE IF EXISTS GetPackageReviews//
CREATE PROCEDURE GetPackageReviews(
    IN p_package_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    DECLARE v_limit INT DEFAULT 20;
    DECLARE v_offset INT DEFAULT 0;

    -- Gán giá trị cho LIMIT và OFFSET
    IF p_limit IS NOT NULL THEN
        SET v_limit = p_limit;
    END IF;

    IF p_offset IS NOT NULL THEN
        SET v_offset = p_offset;
    END IF;

    SELECT pr.id,
           pr.package_id,
           pr.user_id,
           pr.rating,
           pr.review_text,
           pr.created_at,
           u.username,
           u.full_name,
           -- Thông tin package
           pp.name as package_name,
           pp.price as package_price,
           -- Thông tin product
           p.id as product_id,
           p.name as product_name
    FROM product_reviews pr
    LEFT JOIN users u ON pr.user_id = u.id
    JOIN product_packages pp ON pr.package_id = pp.id
    JOIN products p ON pp.product_id = p.id
    WHERE pr.package_id = p_package_id
    ORDER BY pr.created_at DESC
    LIMIT v_limit OFFSET v_offset;
END//

-- 21. Thống kê đánh giá của package
DROP PROCEDURE IF EXISTS GetPackageReviewStats//
CREATE PROCEDURE GetPackageReviewStats(
    IN p_package_id INT
)
BEGIN
    SELECT
        p_package_id as package_id,
        pp.name as package_name,
        pp.price as package_price,
        pr.product_id,
        pr.product_name,
        pr.total_reviews,
        pr.avg_rating,
        pr.rating_1_count,
        pr.rating_2_count,
        pr.rating_3_count,
        pr.rating_4_count,
        pr.rating_5_count,
        -- Phần trăm từng loại rating
        ROUND((pr.rating_5_count * 100.0 / pr.total_reviews), 2) as rating_5_percent,
        ROUND((pr.rating_4_count * 100.0 / pr.total_reviews), 2) as rating_4_percent,
        ROUND((pr.rating_3_count * 100.0 / pr.total_reviews), 2) as rating_3_percent,
        ROUND((pr.rating_2_count * 100.0 / pr.total_reviews), 2) as rating_2_percent,
        ROUND((pr.rating_1_count * 100.0 / pr.total_reviews), 2) as rating_1_percent
    FROM product_packages pp
    JOIN products p ON pp.product_id = p.id
    LEFT JOIN (
        SELECT
            package_id,
            p.id as product_id,
            p.name as product_name,
            COUNT(*) as total_reviews,
            AVG(rating) as avg_rating,
            SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as rating_1_count,
            SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as rating_2_count,
            SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as rating_3_count,
            SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as rating_4_count,
            SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as rating_5_count
        FROM product_reviews r
        JOIN product_packages pp ON r.package_id = pp.id
        JOIN products p ON pp.product_id = p.id
        WHERE r.package_id = p_package_id
        GROUP BY package_id, p.id, p.name
    ) pr ON pp.id = pr.package_id
    WHERE pp.id = p_package_id;
END//

-- 22. Lấy tổng hợp đánh giá của tất cả packages trong một product
DROP PROCEDURE IF EXISTS GetProductReviewsSummary//
CREATE PROCEDURE GetProductReviewsSummary(
    IN p_product_id INT
)
BEGIN
    -- Thống kê tổng hợp của product (từ tất cả packages)
    SELECT
        p.id as product_id,
        p.name as product_name,
        p.slug as product_slug,
        COUNT(pr.id) as total_reviews,
        AVG(pr.rating) as avg_rating,
        MIN(pr.rating) as min_rating,
        MAX(pr.rating) as max_rating,
        SUM(CASE WHEN pr.rating = 1 THEN 1 ELSE 0 END) as rating_1_count,
        SUM(CASE WHEN pr.rating = 2 THEN 1 ELSE 0 END) as rating_2_count,
        SUM(CASE WHEN pr.rating = 3 THEN 1 ELSE 0 END) as rating_3_count,
        SUM(CASE WHEN pr.rating = 4 THEN 1 ELSE 0 END) as rating_4_count,
        SUM(CASE WHEN pr.rating = 5 THEN 1 ELSE 0 END) as rating_5_count
    FROM products p
    LEFT JOIN product_packages pp ON p.id = pp.product_id
    LEFT JOIN product_reviews pr ON pp.id = pr.package_id
    WHERE p.id = p_product_id
    GROUP BY p.id, p.name, p.slug;

    -- Chi tiết đánh giá từng package
    SELECT
        pp.id as package_id,
        pp.name as package_name,
        pp.price as package_price,
        pp.package_type,
        COUNT(pr.id) as package_reviews,
        AVG(pr.rating) as package_avg_rating,
        SUM(CASE WHEN pr.rating = 1 THEN 1 ELSE 0 END) as rating_1_count,
        SUM(CASE WHEN pr.rating = 2 THEN 1 ELSE 0 END) as rating_2_count,
        SUM(CASE WHEN pr.rating = 3 THEN 1 ELSE 0 END) as rating_3_count,
        SUM(CASE WHEN pr.rating = 4 THEN 1 ELSE 0 END) as rating_4_count,
        SUM(CASE WHEN pr.rating = 5 THEN 1 ELSE 0 END) as rating_5_count
    FROM product_packages pp
    LEFT JOIN product_reviews pr ON pp.id = pr.package_id
    WHERE pp.product_id = p_product_id
    GROUP BY pp.id, pp.name, pp.price, pp.package_type
    ORDER BY pp.price ASC;
END//

-- 23. Cập nhật đánh giá package
DROP PROCEDURE IF EXISTS UpdatePackageReview//
CREATE PROCEDURE UpdatePackageReview(
    IN p_review_id INT,
    IN p_rating TINYINT,
    IN p_review_text TEXT
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_user_id INT;
    DECLARE v_package_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra review có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM product_reviews WHERE id = p_review_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đánh giá không tồn tại';
    END IF;

    -- Kiểm tra rating hợp lệ
    IF p_rating IS NOT NULL AND (p_rating < 1 OR p_rating > 5) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rating phải từ 1 đến 5';
    END IF;

    -- Lấy thông tin để trả về
    SELECT user_id, package_id INTO v_user_id, v_package_id
    FROM product_reviews WHERE id = p_review_id;

    -- Cập nhật đánh giá
    UPDATE product_reviews
    SET rating = IFNULL(p_rating, rating),
        review_text = IFNULL(p_review_text, review_text)
    WHERE id = p_review_id;

    COMMIT;
    SELECT p_review_id as review_id, v_package_id as package_id, v_user_id as user_id, 'Cập nhật đánh giá thành công' as message;
END//

-- 24. Xóa đánh giá package
DROP PROCEDURE IF EXISTS DeletePackageReview//
CREATE PROCEDURE DeletePackageReview(
    IN p_review_id INT,
    IN p_user_id INT -- Để đảm bảo chỉ user tạo review mới được xóa
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_package_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra review có tồn tại và thuộc về user không
    IF NOT EXISTS(SELECT 1 FROM product_reviews WHERE id = p_review_id AND user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Đánh giá không tồn tại hoặc bạn không có quyền xóa';
    END IF;

    -- Lấy package_id để trả về
    SELECT package_id INTO v_package_id FROM product_reviews WHERE id = p_review_id;

    -- Xóa đánh giá
    DELETE FROM product_reviews WHERE id = p_review_id;

    COMMIT;
    SELECT p_review_id as review_id, v_package_id as package_id, 'Xóa đánh giá thành công' as message;
END//

-- =============================
-- STORED PROCEDURES CHO QUẢN LÝ VAT SETTINGS
-- =============================

-- 25. Lấy VAT rate hiện tại
DROP PROCEDURE IF EXISTS GetVatSettings//
CREATE PROCEDURE GetVatSettings()
BEGIN
    SELECT id, package_type, vat_rate, description, is_active, created_at, updated_at
    FROM vat_settings 
    ORDER BY package_type;
END//

-- 26. Cập nhật VAT rate
DROP PROCEDURE IF EXISTS UpdateVatRate//
CREATE PROCEDURE UpdateVatRate(
    IN p_package_type VARCHAR(10),
    IN p_vat_rate DECIMAL(4,3),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra VAT rate hợp lệ (0.001 đến 0.999 = 0.1% đến 99.9%)
    IF p_vat_rate < 0.001 OR p_vat_rate > 0.999 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VAT rate phải từ 0.001 đến 0.999';
    END IF;

    -- Cập nhật hoặc thêm mới VAT setting
    INSERT INTO vat_settings (package_type, vat_rate, description, is_active)
    VALUES (p_package_type, p_vat_rate, p_description, 1)
    ON DUPLICATE KEY UPDATE
        vat_rate = p_vat_rate,
        description = IFNULL(p_description, description),
        updated_at = CURRENT_TIMESTAMP;

    COMMIT;
    SELECT p_package_type as package_type, p_vat_rate as vat_rate, 'Cập nhật VAT rate thành công' as message;
END//

-- 27. Kích hoạt/vô hiệu hóa VAT setting
DROP PROCEDURE IF EXISTS ToggleVatSetting//
CREATE PROCEDURE ToggleVatSetting(
    IN p_package_type VARCHAR(10),
    IN p_is_active TINYINT(1)
)
BEGIN
    DECLARE v_error_msg VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_msg = MESSAGE_TEXT;
            ROLLBACK;
            RESIGNAL SET MESSAGE_TEXT = v_error_msg;
        END;

    START TRANSACTION;

    -- Kiểm tra VAT setting có tồn tại không
    IF NOT EXISTS(SELECT 1 FROM vat_settings WHERE package_type = p_package_type) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VAT setting không tồn tại';
    END IF;

    -- Cập nhật trạng thái
    UPDATE vat_settings 
    SET is_active = p_is_active,
        updated_at = CURRENT_TIMESTAMP
    WHERE package_type = p_package_type;

    COMMIT;
    SELECT p_package_type as package_type, p_is_active as is_active, 'Cập nhật trạng thái VAT thành công' as message;
END//

DELIMITER ;

