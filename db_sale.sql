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
    id                    INT PRIMARY KEY AUTO_INCREMENT,                                                               -- Unique user ID, auto-incremented
    username              VARCHAR(100) NOT NULL UNIQUE,                                                                 -- Username, required and unique
    password              VARCHAR(255) NOT NULL,                                                                        -- Password (hashed), required
    email                 VARCHAR(255) NOT NULL UNIQUE,                                                                 -- Email, required and unique

    -- Phân quyền
    role                  ENUM ('customer', 'admin', 'staff')    DEFAULT 'customer',
    permissions           JSON,

    -- Xác thực 2 bước
    two_factor_enabled    TINYINT(1)                             DEFAULT 0,                                             -- 0: Disabled, 1: Enabled
    two_factor_secret     VARCHAR(32),                                                                                  -- Secret key for 2FA (if enabled)

    -- Optional profile fields
    full_name             VARCHAR(255),                                                                                 -- Full name (optional)
    phone                 VARCHAR(20),                                                                                  -- Phone number (optional)
    gender                ENUM ('Nam', 'Nữ', 'Khác')             DEFAULT 'Khác',                                        -- Gender (optional, default 'Khác')
    avatar                VARCHAR(500),                                                                                 -- Avatar image URL (optional)
    address               TEXT,                                                                                         -- Address (optional)
    city                  VARCHAR(100),                                                                                 -- City (optional)
    district              VARCHAR(100),                                                                                 -- District (optional)
    ward                  VARCHAR(100),                                                                                 -- Ward (optional)
    postal_code           VARCHAR(20),                                                                                  -- Postal code (optional)

    -- Account balance and payment tracking
    balance               DECIMAL(15, 2)                         DEFAULT 0 COMMENT 'Current account balance',
    total_spent           DECIMAL(15, 2)                         DEFAULT 0 COMMENT 'Total amount paid by user',

    -- Timestamps
    created_at            TIMESTAMP                              DEFAULT CURRENT_TIMESTAMP,                             -- Record creation time
    updated_at            TIMESTAMP                              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    deleted_at            TIMESTAMP    NULL,                                                                            -- Soft delete timestamp (NULL if not deleted)


    -- Trạng thái
    status                ENUM ('active', 'suspended', 'banned') DEFAULT 'active',
    email_verified        TINYINT(1)                             DEFAULT 0 COMMENT '0: Chưa xác minh, 1: Đã xác minh',  -- Email verification status (0: Not verified, 1: Verified

    -- Tracking cơ bản
    last_login_at         TIMESTAMP    NULL,                                                                            -- Last login timestamp
    registration_ip       VARCHAR(45),                                                                                  -- IP address at registration
    failed_login_attempts INT                                    DEFAULT 0,                                             -- Number of failed login attempts
    locked_until          TIMESTAMP    NULL,

    -- Referral đơn giản
    referral_code         VARCHAR(20) UNIQUE,                                                                           -- Unique referral code for user
    referred_by           INT,                                                                                          -- User ID of the referrer (NULL if not referred by anyone) COMMENT 'ID của người giới thiệu (NULL nếu không có)'

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
        SET NEW.status = 'suspended';
    END IF;
END$$
DELIMITER ;

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
    vat_rate          DECIMAL(4, 3)  NOT NULL DEFAULT 0.01 COMMENT 'Tỷ lệ VAT áp dụng cho gói này (0.01 = 1%, 0.05 = 5%)',
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
    vat_rate        DECIMAL(4, 3)  NOT NULL,                           -- Tỷ lệ VAT áp dụng (0.01: hàng hóa, 0.05: dịch vụ)
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
--  - vat_rate: 0.01 cho hàng hóa (bán key/tài khoản), 0.05 cho dịch vụ (cho thuê tài khoản)
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

    -- Xác định VAT rate
    SET v_vat_rate = IF(v_package_type = 'sale', 0.01, 0.05);

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

call CreateInvoiceForOrder(2); -- Thay 1 bằng ID đơn hàng thực tế để tạo hóa đơn
