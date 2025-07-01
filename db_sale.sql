/*DROP DATABASE IF EXISTS db_sale;
CREATE DATABASE db_sale DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;*/
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

-- Bảng menu điều hướng
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

-- Bảng cấu hình website
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

-- Bảng slider/carousel trang chủ
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

-- Bảng các section nổi bật
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

-- Bảng items trong featured sections (dữ liệu tĩnh)
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
-- Bảng liên kết featured sections với content
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

-- Bảng vị trí banner
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

-- Bảng banners
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

-- Bảng danh mục bài viết
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

-- Bảng bài viết
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

-- Bảng testimonials/đánh giá khách hàng
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

-- Bảng thống kê hiển thị trang chủ
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

-- Bảng footer sections
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

-- Bảng footer links
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

-- Bảng social media
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

-- Bảng notification bar (thanh thông báo)
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

-- Bảng popups
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

-- Bảng trust badges/chứng nhận
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

-- Bảng newsletter subscribers
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

-- Bảng contact messages
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

-- View cho active banners theo vị trí
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

-- View cho featured content
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

-- Procedure lấy toàn bộ dữ liệu trang chủ
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

-- Procedure lấy dữ liệu footer
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

-- Procedure lấy navigation menu
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
-- Create users table for website accounts
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

DROP TRIGGER IF EXISTS trg_suspend_user_after_failed_logins;

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

-- Bảng danh mục sản phẩm
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

-- View cho danh mục sản phẩm
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

-- Bảng tags/nhãn sản phẩm
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

-- Bảng sản phẩm mẹ
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

-- Bảng gói sản phẩm con
DROP TABLE IF EXISTS product_packages;
CREATE TABLE product_packages
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    product_id     INT            NOT NULL,
    name           VARCHAR(255)   NOT NULL,
    description    TEXT,
    price          DECIMAL(15, 2) NOT NULL,
    old_price      DECIMAL(15, 2),
    duration_days  INT,
    percent_off    DECIMAL(5, 2) GENERATED ALWAYS AS (
        IF(old_price IS NOT NULL AND old_price > 0 AND price < old_price, 100 * (old_price - price) / old_price, 0)
        ) STORED,
    stock_quantity INT        DEFAULT 0 COMMENT 'Số lượng tồn kho còn lại',
    sold_count     INT        DEFAULT 0 COMMENT 'Số lượng đã bán',
    details        TEXT COMMENT 'Thông tin chi tiết về gói sản phẩm',
    note           TEXT COMMENT 'Lưu ý riêng cho từng gói sản phẩm',
    status         TINYINT(1) DEFAULT 1, -- 1: active, 0: inactive
    created_at     TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_name (name),
    INDEX idx_status (status),
    INDEX idx_price (price),
    INDEX idx_percent_off (percent_off)
);

-- Bảng voucher/mã giảm giá
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

-- Bảng liên kết voucher với sản phẩm/gói sản phẩm cụ thể
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

-- Chưa chạy từ đây

-- Bảng thuộc tính động cho sản phẩm
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

-- Bảng đánh giá sản phẩm
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

-- Bảng FAQ sản phẩm
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

-- Bảng tài liệu/hướng dẫn sản phẩm
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

-- Bảng sản phẩm liên quan/gợi ý mua kèm
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

-- Bảng liên kết tag với từng gói sản phẩm (package)
DROP TABLE IF EXISTS product_tag_map;
CREATE TABLE product_tag_map
(
    package_id INT NOT NULL,
    tag_id     INT NOT NULL,
    PRIMARY KEY (package_id, tag_id),
    FOREIGN KEY (package_id) REFERENCES product_packages (id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES product_tags (id) ON DELETE CASCADE
);

-- ======================
-- BẢNG QUẢN LÝ ĐƠN HÀNG
-- ======================

-- Xóa bảng orders nếu đã tồn tại (tránh lỗi khi chạy lại file)
DROP TABLE IF EXISTS orders;

-- Bảng orders: Lưu thông tin tổng quan đơn hàng digital
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

-- Xóa bảng order_items nếu đã tồn tại (tránh lỗi khi chạy lại file)
DROP TABLE IF EXISTS order_items;

-- Bảng order_items: Lưu chi tiết từng sản phẩm/gói trong đơn
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

-- Xóa bảng payment_transactions nếu đã tồn tại (tránh lỗi khi chạy lại file)
DROP TABLE IF EXISTS payment_transactions;

-- Bảng payment_transactions: Lưu các giao dịch thanh toán cho đơn hàng
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

-- Xóa bảng order_status_logs nếu đã tồn tại
DROP TABLE IF EXISTS order_status_logs;

-- Bảng order_status_logs: Lưu lịch sử thay đổi trạng thái đơn hàng
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

-- Xóa bảng order_vouchers nếu đã tồn tại (tránh lỗi khi chạy lại file)
DROP TABLE IF EXISTS order_vouchers;

-- Bảng order_vouchers: Lưu voucher đã áp dụng cho đơn hàng
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
-- TRIGGER TỰ ĐỘNG SINH ORDER_CODE CHO ĐƠN HÀNG
-- Format: yyMMdd + 7 ký tự ngẫu nhiên (A-Z, 0-9)
-- Ví dụ: 250606S7CUJ4A
-- Đảm bảo order_code là duy nhất nhờ UNIQUE constraint
-- Xác suất trùng lặp cực thấp, phù hợp cho hệ thống < 1000 đơn/ngày
-- Nếu trùng sẽ báo lỗi duplicate key (rất hiếm gặp)

-- Xóa trigger sinh order_code nếu đã tồn tại (tránh lỗi khi chạy lại file)
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

-- Xóa bảng cart_items nếu đã tồn tại
DROP TABLE IF EXISTS cart_items;

-- Bảng cart_items: Lưu chi tiết sản phẩm/gói trong giỏ hàng
CREATE TABLE cart_items (
    id            INT PRIMARY KEY AUTO_INCREMENT,               -- Khóa chính
    cart_id       INT NOT NULL,                                 -- FK cart_sessions
    package_id    INT NOT NULL,                                 -- FK product_packages
    quantity      INT NOT NULL DEFAULT 1,                       -- Số lượng
    added_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,          -- Thời gian thêm vào giỏ
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Thời gian cập nhật
    FOREIGN KEY (cart_id) REFERENCES cart_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES product_packages(id)
);


