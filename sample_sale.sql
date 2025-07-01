-- Site settings cơ bản
INSERT INTO site_settings (setting_key, setting_value, setting_type, description, group_name)
VALUES ('site_name', 'Divine Shop', 'text', 'Tên website', 'general'),
       ('site_tagline', 'Shop thẻ nạp và dịch vụ số uy tín', 'text', 'Slogan website', 'general'),
       ('site_logo', '/images/logo.png', 'file', 'Logo website', 'general'),
       ('site_favicon', '/images/favicon.ico', 'file', 'Favicon', 'general'),
       ('contact_phone', '1900-xxxx', 'text', 'Số điện thoại hỗ trợ', 'contact'),
       ('contact_email', 'support@divineshop.vn', 'text', 'Email hỗ trợ', 'contact'),
       ('contact_address', 'Hà Nội, Việt Nam', 'text', 'Địa chỉ', 'contact'),
       ('header_announcement', 'Miễn phí vận chuyển cho đơn hàng trên 500K - Hỗ trợ 24/7', 'text', 'Thông báo header',
        'promotions'),
       ('homepage_title', 'Divine Shop - Thẻ nạp và Dịch vụ số uy tín', 'text', 'Title trang chủ', 'seo'),
       ('homepage_description',
        'Mua thẻ nạp game, Steam Wallet, Google Gemini Advanced với giá tốt nhất. Giao dịch nhanh chóng, bảo mật tuyệt đối.',
        'text', 'Description trang chủ', 'seo');

-- Navigation menu
INSERT INTO navigation_menus (name, slug, url, icon, parent_id, position, display_order, status)
VALUES ('Trang chủ', 'home', '/', 'fas fa-home', NULL, 'header', 1, 1),
       ('Sản phẩm', 'products', '/products', 'fas fa-box', NULL, 'header', 2, 1),
       ('Thẻ nạp Game', 'game-cards', '/game-cards', 'fas fa-gamepad', 2, 'header', 1, 1),
       ('Steam Wallet', 'steam-wallet', '/steam-wallet', 'fab fa-steam', 2, 'header', 2, 1),
       ('Dịch vụ AI', 'ai-services', '/ai-services', 'fas fa-robot', 2, 'header', 3, 1),
       ('Tin tức', 'news', '/news', 'fas fa-newspaper', NULL, 'header', 3, 1),
       ('Hướng dẫn', 'guides', '/guides', 'fas fa-book', NULL, 'header', 4, 1),
       ('Hỗ trợ', 'support', '/support', 'fas fa-headset', NULL, 'header', 5, 1),
       ('Liên hệ', 'contact', '/contact', 'fas fa-phone', NULL, 'header', 6, 1);

-- Banner positions
INSERT INTO banner_positions (code, name, description, max_banners, recommended_width, recommended_height, layout_type)
VALUES ('homepage_hero', 'Trang chủ - Banner chính', 'Banner carousel chính trên trang chủ', 5, 1920, 600, 'carousel'),
       ('homepage_secondary', 'Trang chủ - Banner phụ', 'Banner nhỏ bên dưới hero', 3, 400, 300, 'grid'),
       ('sidebar_banner', 'Thanh bên', 'Banner hiển thị ở thanh bên', 2, 300, 400, 'single'),
       ('footer_banner', 'Footer', 'Banner ở cuối trang', 1, 1200, 150, 'single');

-- Hero sliders
INSERT INTO hero_sliders (title, subtitle, description, image_desktop, image_mobile, image_alt, button_text, button_url,
                          display_order, animation_type, status)
VALUES ('Steam Wallet Giá Tốt Nhất', 'Khuyến mãi lên đến 20%',
        'Mua thẻ nạp Steam Wallet chính hãng với giá ưu đãi nhất thị trường. Giao dịch tự động 24/7, nhận mã ngay lập tức.',
        '/images/sliders/steam-hero.jpg', '/images/sliders/steam-hero-mobile.jpg', 'Steam Wallet khuyến mãi 20%',
        'Mua ngay', '/steam-wallet', 1, 'fade', 1),
       ('Google Gemini Advanced', 'AI Thông Minh Nhất',
        'Trải nghiệm sức mạnh AI với Google Gemini Advanced. Công nghệ tương lai trong tầm tay bạn.',
        '/images/sliders/gemini-hero.jpg', '/images/sliders/gemini-hero-mobile.jpg', 'Google Gemini Advanced AI',
        'Khám phá ngay', '/google-gemini-advanced', 2, 'slide', 1),
       ('Ưu Đãi Đặc Biệt', 'Giảm giá 50% cho thành viên mới',
        'Đăng ký ngay để nhận voucher giảm giá đặc biệt cho lần mua hàng đầu tiên. Cơ hội có hạn!',
        '/images/sliders/special-offer.jpg', '/images/sliders/special-offer-mobile.jpg',
        'Ưu đãi đặc biệt cho thành viên mới', 'Đăng ký ngay', '/register', 3, 'zoom', 1);

-- Featured sections
INSERT INTO featured_sections (section_key, title, subtitle, description, layout_type, max_items, view_all_url,
                               display_order, status)
VALUES ('featured_categories', 'Danh Mục Nổi Bật', 'Khám phá các sản phẩm hàng đầu',
        'Những danh mục sản phẩm được yêu thích nhất tại Divine Shop', 'grid', 6, '/categories', 1, 1),
       ('bestseller_products', 'Sản Phẩm Bán Chạy', 'Những sản phẩm được tin dùng nhất',
        'Top sản phẩm có doanh số cao nhất trong tháng', 'carousel', 8, '/products?sort=bestseller', 2, 1),
       ('new_products', 'Sản Phẩm Mới', 'Cập nhật những sản phẩm mới nhất',
        'Những sản phẩm vừa được thêm vào Divine Shop', 'grid', 8, '/products?sort=newest', 3, 1),
       ('featured_news', 'Tin Tức & Hướng Dẫn', 'Cập nhật thông tin mới nhất',
        'Tin tức, hướng dẫn và mẹo hay từ Divine Shop', 'grid', 4, '/news', 4, 1);

-- Featured items (static content)
INSERT INTO featured_items (section_id, title, subtitle, description, image_url, link_url, badge_text, badge_color,
                            display_order, status)
VALUES (1, 'Steam Wallet', 'Thẻ nạp Steam', 'Mua game và nội dung trên Steam', '/images/categories/steam.jpg',
        '/steam-wallet', 'HOT', '#ff4757', 1, 1),
       (1, 'Google Services', 'Dịch vụ Google', 'Gemini Advanced, YouTube Premium, Drive',
        '/images/categories/google.jpg', '/google-services', 'NEW', '#2ed573', 2, 1),
       (1, 'Game Mobile', 'Thẻ nạp game mobile', 'Free Fire, PUBG, Liên Quân Mobile',
        '/images/categories/mobile-games.jpg', '/mobile-games', NULL, NULL, 3, 1),
       (1, 'Netflix & Spotify', 'Streaming Services', 'Giải trí không giới hạn', '/images/categories/streaming.jpg',
        '/streaming', 'SALE', '#ffa726', 4, 1);

-- Homepage stats
INSERT INTO homepage_stats (stat_key, stat_value, stat_label, stat_description, icon, display_order, is_animated,
                            status)
VALUES ('total_customers', '100,000+', 'Khách hàng tin tưởng', 'Số lượng khách hàng đã sử dụng dịch vụ', 'fas fa-users',
        1, 1, 1),
       ('total_orders', '500,000+', 'Đơn hàng thành công', 'Tổng số giao dịch đã hoàn thành', 'fas fa-shopping-cart', 2,
        1, 1),
       ('total_products', '1,000+', 'Sản phẩm đa dạng', 'Số lượng sản phẩm và dịch vụ', 'fas fa-box', 3, 1, 1),
       ('years_experience', '5+', 'Năm kinh nghiệm', 'Thời gian hoạt động trong ngành', 'fas fa-award', 4, 1, 1);

-- Testimonials
INSERT INTO testimonials (customer_name, customer_avatar, customer_title, rating, content, is_featured, display_order,
                          status)
VALUES ('Nguyễn Văn A', '/images/avatars/user1.jpg', 'Game thủ', 5,
        'Divine Shop là nơi tôi luôn tin tưởng mua thẻ Steam. Giao dịch nhanh, giá tốt, hỗ trợ 24/7 rất tuyệt vời!', 1,
        1, 1),
       ('Trần Thị B', '/images/avatars/user2.jpg', 'Nhân viên IT', 5,
        'Đã mua Gemini Advanced ở đây nhiều lần. Kích hoạt ngay lập tức, không có vấn đề gì. Rất đáng tin cậy!', 1, 2,
        1),
       ('Lê Minh C', '/images/avatars/user3.jpg', 'Streamer', 5,
        'Chất lượng dịch vụ xuất sắc, giá cả hợp lý. Divine Shop đã trở thành lựa chọn số 1 của tôi cho mọi nhu cầu mua thẻ nạp.',
        1, 3, 1);

-- Trust badges
INSERT INTO trust_badges (name, description, image_url, image_alt, badge_type, display_order, status)
VALUES ('SSL Secure', 'Bảo mật SSL 256-bit', '/images/badges/ssl-secure.png', 'SSL Secure Certificate', 'security', 1,
        1),
       ('Visa Payment', 'Thanh toán Visa an toàn', '/images/badges/visa.png', 'Visa Payment Accepted', 'payment', 2, 1),
       ('Mastercard Payment', 'Thanh toán Mastercard', '/images/badges/mastercard.png', 'Mastercard Payment Accepted',
        'payment', 3, 1),
       ('Verified Business', 'Doanh nghiệp đã xác minh', '/images/badges/verified-business.png',
        'Verified Business Certificate', 'certificate', 4, 1);

-- Footer sections
INSERT INTO footer_sections (section_title, section_type, column_position, display_order, status)
VALUES ('Về Divine Shop', 'links', 1, 1, 1),
       ('Sản phẩm', 'links', 2, 1, 1),
       ('Hỗ trợ khách hàng', 'links', 3, 1, 1),
       ('Thông tin liên hệ', 'contact', 4, 1, 1);

-- Footer links
INSERT INTO footer_links (section_id, title, url, display_order, status)
VALUES (1, 'Giới thiệu', '/about', 1, 1),
       (1, 'Điều khoản sử dụng', '/terms', 2, 1),
       (1, 'Chính sách bảo mật', '/privacy', 3, 1),
       (1, 'Chính sách hoàn tiền', '/refund-policy', 4, 1),
       (2, 'Thẻ nạp Game', '/game-cards', 3, 1),
       (2, 'Tất cả sản phẩm', '/products', 4, 1),
       (3, 'Hướng dẫn mua hàng', '/guide/how-to-buy', 1, 1),
       (3, 'Câu hỏi thường gặp', '/faq', 2, 1),
       (3, 'Liên hệ hỗ trợ', '/contact', 3, 1),
       (3, 'Kiểm tra đơn hàng', '/order-status', 4, 1);

-- Social media
INSERT INTO social_media (platform, platform_name, url, icon, color, follower_count, display_order, status)
VALUES ('facebook', 'Facebook', 'https://facebook.com/divineshop', 'fab fa-facebook-f', '#1877f2', '50K+', 1, 1),
       ('youtube', 'YouTube', 'https://youtube.com/divineshop', 'fab fa-youtube', '#ff0000', '20K+', 2, 1),
       ('telegram', 'Telegram', 'https://t.me/divineshop', 'fab fa-telegram', '#0088cc', '30K+', 3, 1),
       ('discord', 'Discord', 'https://discord.gg/divineshop', 'fab fa-discord', '#5865f2', '15K+', 4, 1);

-- Article categories
INSERT INTO article_categories (name, slug, description, display_order, status)
VALUES ('Hướng dẫn', 'huong-dan', 'Các bài hướng dẫn sử dụng sản phẩm và dịch vụ', 1, 1),
       ('Tin tức', 'tin-tuc', 'Tin tức và cập nhật mới nhất', 2, 1),
       ('Khuyến mãi', 'khuyen-mai', 'Thông tin về các chương trình khuyến mãi', 3, 1),
       ('Review', 'review', 'Đánh giá và so sánh sản phẩm', 4, 1);

-- Sample articles
INSERT INTO articles (category_id, title, slug, excerpt, content, featured_image, author_name, published_at,
                      is_featured, featured_order, status)
VALUES (1, 'Hướng dẫn mua Steam Wallet tại Divine Shop', 'huong-dan-mua-steam-wallet',
        'Hướng dẫn chi tiết cách mua và sử dụng thẻ Steam Wallet tại Divine Shop một cách đơn giản và an toàn.',
        'Nội dung chi tiết về cách mua Steam Wallet...', '/images/articles/steam-guide.jpg', 'Admin', NOW(), 1, 1, 1),
       (1, 'Cách kích hoạt Google Gemini Advanced', 'cach-kich-hoat-google-gemini-advanced',
        'Hướng dẫn từng bước cách kích hoạt và sử dụng Google Gemini Advanced hiệu quả nhất.',
        'Nội dung hướng dẫn kích hoạt Gemini Advanced...', '/images/articles/gemini-guide.jpg', 'Admin', NOW(), 1, 2,
        1),
       (2, 'Steam Summer Sale 2024 - Cơ hội mua game giá rẻ', 'steam-summer-sale-2024',
        'Tổng hợp những thông tin cần biết về Steam Summer Sale 2024 và cách tận dụng tối đa sự kiện này.',
        'Chi tiết về Steam Summer Sale...', '/images/articles/steam-sale.jpg', 'Admin', NOW(), 1, 3, 1),
       (3, 'Khuyến mãi tháng 6 - Giảm giá lên đến 30%', 'khuyen-mai-thang-6',
        'Chương trình khuyến mãi đặc biệt trong tháng 6 với nhiều ưu đãi hấp dẫn.',
        'Chi tiết chương trình khuyến mãi...', '/images/articles/promotion-june.jpg', 'Admin', NOW(), 1, 4, 1);

-- Notification bar
INSERT INTO notification_bars (message, message_type, background_color, text_color, button_text, button_url,
                               is_dismissible, position, status)
VALUES ('🎉 Khuyến mãi đặc biệt: Giảm 20% cho tất cả thẻ Steam Wallet! Áp dụng đến hết tháng này.', 'promotion',
        '#ff4757', '#ffffff', 'Mua ngay', '/steam-wallet', 1, 'top', 1);

-- Sample popup
INSERT INTO popups (title, content, popup_type, trigger_type, trigger_value, image_url, primary_button_text,
                    primary_button_url, primary_button_action, secondary_button_text, secondary_button_action, position,
                    display_frequency, status)
VALUES ('Chào mừng đến với Divine Shop!',
        'Đăng ký ngay để nhận voucher giảm giá 10% cho lần mua hàng đầu tiên của bạn.', 'newsletter', 'time', 3,
        '/images/popups/welcome.jpg', 'Nhận voucher', '/register', 'redirect', 'Để sau', 'close', 'center',
        'once_per_day', 1);


-- Dữ liệu mẫu cho bảng users
INSERT INTO users (username, password, email, role, permissions, two_factor_enabled, two_factor_secret,
                   full_name, phone, gender, avatar, address, city, district, ward, postal_code,
                   balance, total_spent, created_at, updated_at, deleted_at, email_verified,
                   last_login_at, registration_ip, failed_login_attempts, locked_until,
                   referral_code, referred_by)
VALUES ('customer01', SHA2('customer01password', 256), 'customer01@email.com', 'customer', NULL, 0, NULL,
        'Nguyen Van A', '0901234567', 'Nam', '/avatars/user1.jpg', '123 Main St', 'Hanoi', 'Ba Dinh', 'Phuc Xa',
        '100000',
        500000, 1500000, NOW(), NOW(), NULL, 1, NOW(), '192.168.1.10', 0, NULL, 'REFCUST01', NULL),

       ('admin01', SHA2('admin01password', 256), 'admin01@email.com', 'admin', '{
         "manage_users": true
       }', 1, '2FASECRETKEY123',
        'Tran Thi B', '0912345678', 'Nữ', '/avatars/admin1.jpg', '456 Admin Rd', 'HCM', 'District 1', 'Ben Nghe',
        '700000',
        0, 0, NOW(), NOW(), NULL, 1, NOW(), '192.168.1.11', 0, NULL, 'REFADMIN01', NULL),

       ('staff01', SHA2('staff01password', 256), 'staff01@email.com', 'staff', '{
         "manage_orders": true
       }', 0, NULL,
        'Le Minh C', NULL, 'Khác', NULL, NULL, NULL, NULL, NULL, NULL,
        10000, 50000, NOW(), NOW(), NULL, 0, NULL, '192.168.1.12', 0, NULL, 'REFSTAFF01', 1),

       ('customer02', SHA2('customer02password', 256), 'customer02@email.com', 'customer', NULL, 0, NULL,
        'Pham Van D', '0987654321', 'Nam', NULL, '789 Customer Ave', 'Da Nang', NULL, NULL, '550000',
        0, 200000, NOW(), NOW(), NULL, 0, NULL, '192.168.1.13', 0, NULL, 'REFCUST02', 1);


-- Dữ liệu mẫu cho bảng product_categories
INSERT INTO product_categories (name,
                                slug,
                                parent_id,
                                description,
                                image_url,
                                icon,
                                display_order,
                                is_featured,
                                show_on_homepage,
                                meta_title,
                                meta_description,
                                status)
VALUES
-- Danh mục gốc
('Thẻ Game', 'the-game', NULL, 'Thẻ nạp game các loại', '/images/categories/game-cards.jpg', 'fas fa-gamepad', 1, 1, 1,
 'Thẻ Game - Mua thẻ nạp game giá rẻ, uy tín',
 'Mua thẻ nạp game giá rẻ, uy tín tại Divine Shop. Hỗ trợ nhiều loại thẻ game phổ biến.', 1),

('Steam', 'steam', NULL, 'Thẻ Steam Wallet và các sản phẩm Steam', '/images/categories/steam.jpg', 'fab fa-steam', 2, 1,
 1,
 'Steam Wallet - Mua thẻ Steam giá rẻ',
 'Mua thẻ Steam Wallet chính hãng với giá tốt nhất. Giao dịch nhanh chóng, bảo mật tuyệt đối.', 1),

('Dịch vụ Google', 'google-services', NULL, 'Các dịch vụ của Google', '/images/categories/google.jpg', 'fab fa-google',
 3, 1, 1,
 'Dịch vụ Google - Gemini Advanced, YouTube Premium',
 'Mua các dịch vụ Google như Gemini Advanced, YouTube Premium với giá tốt nhất.', 1),

('Dịch vụ Streaming', 'streaming-services', NULL, 'Các dịch vụ streaming phim, nhạc',
 '/images/categories/streaming.jpg', 'fas fa-film', 4, 1, 1,
 'Dịch vụ Streaming - Netflix, Spotify Premium',
 'Mua các dịch vụ streaming như Netflix, Spotify Premium với giá tốt nhất.', 1),

-- Danh mục con của Thẻ Game
('Game Mobile', 'game-mobile', 1, 'Thẻ nạp game mobile', '/images/categories/mobile-games.jpg', 'fas fa-mobile-alt', 1,
 0, 0,
 'Thẻ Game Mobile - Free Fire, PUBG Mobile, Liên Quân Mobile',
 'Mua thẻ nạp game mobile giá rẻ: Free Fire, PUBG Mobile, Liên Quân Mobile và nhiều game khác.', 1),

('Game PC', 'game-pc', 1, 'Thẻ nạp game PC', '/images/categories/pc-games.jpg', 'fas fa-desktop', 2, 0, 0,
 'Thẻ Game PC - Garena, VNG, VTC', 'Mua thẻ nạp game PC giá rẻ: Garena, VNG, VTC và nhiều nhà phát hành khác.', 1),

-- Danh mục con của Steam
('Steam Wallet', 'steam-wallet', 2, 'Thẻ nạp Steam Wallet', '/images/categories/steam-wallet.jpg', 'fab fa-steam', 1, 0,
 0,
 'Steam Wallet - Mua thẻ nạp Steam giá rẻ',
 'Mua thẻ Steam Wallet chính hãng với giá tốt nhất. Giao dịch nhanh chóng, bảo mật tuyệt đối.', 1),

('Steam Gift Card', 'steam-gift-card', 2, 'Thẻ quà tặng Steam', '/images/categories/steam-gift.jpg', 'fas fa-gift', 2,
 0, 0,
 'Steam Gift Card - Thẻ quà tặng Steam', 'Mua thẻ quà tặng Steam với giá tốt nhất. Tặng bạn bè, người thân dễ dàng.',
 1),

-- Danh mục con của Dịch vụ Google
('Google Gemini', 'google-gemini', 3, 'Dịch vụ Google Gemini', '/images/categories/gemini.jpg', 'fas fa-robot', 1, 0, 0,
 'Google Gemini Advanced - AI thông minh nhất',
 'Mua Google Gemini Advanced với giá tốt nhất. Trải nghiệm sức mạnh AI tiên tiến.', 1),

('YouTube Premium', 'youtube-premium', 3, 'YouTube Premium', '/images/categories/youtube-premium.jpg', 'fab fa-youtube',
 2, 0, 0,
 'YouTube Premium - Xem video không quảng cáo',
 'Mua YouTube Premium với giá tốt nhất. Xem video không quảng cáo, tải video offline.', 1),

-- Danh mục con của Dịch vụ Streaming
('Netflix', 'netflix', 4, 'Netflix Premium', '/images/categories/netflix.jpg', 'fas fa-tv', 1, 0, 0,
 'Netflix Premium - Xem phim không giới hạn',
 'Mua Netflix Premium với giá tốt nhất. Xem phim không giới hạn, chất lượng cao.', 1),

('Spotify', 'spotify', 4, 'Spotify Premium', '/images/categories/spotify.jpg', 'fab fa-spotify', 2, 0, 0,
 'Spotify Premium - Nghe nhạc không quảng cáo',
 'Mua Spotify Premium với giá tốt nhất. Nghe nhạc không quảng cáo, tải nhạc offline.', 1);

-- =============================
-- DỮ LIỆU MẪU CHO SẢN PHẨM MỚI (products & product_packages)
-- =============================

-- Bảng products (sản phẩm mẹ)
INSERT INTO products (id, name, slug, category_id, description, image_url, status, total_stock, total_sold, created_at, updated_at)
VALUES
(1, 'ChatGPT (OpenAI)', 'chatgpt-openai', 1, 'Tài khoản ChatGPT (OpenAI) dùng cho học tập, làm việc, nghiên cứu AI, chatbot, v.v.', '/images/products/chatgpt-openai.jpg', 1, 400, 230, NOW(), NOW()),
(2, 'Google Gemini Advanced', 'google-gemini-advanced', 3, 'Tài khoản Google Gemini Advanced AI, trải nghiệm sức mạnh AI mới nhất.', '/images/products/google-gemini.jpg', 1, 150, 80, NOW(), NOW()),
(3, 'Spotify Premium', 'spotify-premium', 4, 'Tài khoản Spotify Premium nghe nhạc không quảng cáo, tải nhạc offline.', '/images/products/spotify.jpg', 1, 150, 80, NOW(), NOW()),
(4, 'Red Dead Redemption 2', 'red-dead-redemption-2', 7, 'Game phiêu lưu hành động thế giới mở đình đám trên Steam.', '/images/products/rdr2.jpg', 1, 150, 80, NOW(), NOW()),
(5, 'Duolingo Super', 'duolingo-super', 5, 'Tài khoản Duolingo Super học ngoại ngữ không quảng cáo.', '/images/products/duolingo.jpg', 1, 150, 80, NOW(), NOW()),
(6, 'Netflix Premium', 'netflix-premium', 11, 'Tài khoản Netflix Premium xem phim chất lượng cao, không giới hạn.', '/images/products/netflix.jpg', 1, 150, 80, NOW(), NOW());

-- Bảng product_packages (gói sản phẩm con)
INSERT INTO product_packages (id, product_id, name, description, price, old_price, duration_days, stock_quantity, sold_count, details, note, status, created_at, updated_at)
VALUES
-- ChatGPT (id=1)
(1, 1, 'TK Free', 'Tài khoản ChatGPT miễn phí, dùng cơ bản.', 0, NULL, NULL, 100, 50, 'Sử dụng ChatGPT miễn phí, giới hạn tính năng, không hỗ trợ GPT-4.', 'Không hỗ trợ truy cập API.', 1, NOW(), NOW()),
(2, 1, 'Nâng cấp ChatGPT Plus', 'Nâng cấp tài khoản ChatGPT lên Plus, sử dụng GPT-4, tốc độ nhanh hơn.', 500000, 600000, 30, 200, 120, 'Truy cập GPT-4, tốc độ ưu tiên, hỗ trợ plugin, phù hợp cho người dùng chuyên nghiệp.', 'Chỉ áp dụng cho tài khoản chưa từng nâng cấp.', 1, NOW(), NOW()),
(3, 1, 'TK ChatGPT Plus 2 tháng', 'Tài khoản ChatGPT Plus sử dụng 2 tháng.', 900000, 1000000, 60, 100, 60, 'Tài khoản ChatGPT Plus sử dụng liên tục 2 tháng, đầy đủ tính năng cao cấp.', 'Không hoàn tiền sau khi giao dịch thành công.', 1, NOW(), NOW()),
-- Google Gemini Advanced (id=2)
(4, 2, 'Google Gemini Advanced 1 tháng', 'Tài khoản Google Gemini Advanced dùng 1 tháng.', 300000, 350000, 30, 100, 50, 'Truy cập Google Gemini Advanced AI, sử dụng không giới hạn trong 1 tháng.', 'Liên hệ CSKH nếu gặp lỗi kích hoạt.', 1, NOW(), NOW()),
(5, 2, 'Google Gemini Advanced 3 tháng', 'Tài khoản Google Gemini Advanced dùng 3 tháng.', 800000, 900000, 90, 50, 30, 'Sử dụng Google Gemini Advanced AI liên tục 3 tháng, hỗ trợ đầy đủ tính năng.', 'Không hoàn tiền sau khi giao dịch thành công.', 1, NOW(), NOW()),
-- Spotify Premium (id=3)
(6, 3, 'Spotify Premium 1 tháng', 'Tài khoản Spotify Premium dùng 1 tháng.', 65000, 80000, 30, 100, 50, 'Nghe nhạc không quảng cáo, tải nhạc offline, chất lượng cao trong 1 tháng.', 'Không tự động gia hạn, cần mua lại khi hết hạn.', 1, NOW(), NOW()),
(7, 3, 'Spotify Premium 12 tháng', 'Tài khoản Spotify Premium dùng 12 tháng.', 700000, 900000, 365, 50, 30, 'Sử dụng Spotify Premium liên tục 12 tháng, tiết kiệm chi phí, đầy đủ quyền lợi.', 'Không hoàn tiền sau khi giao dịch thành công.', 1, NOW(), NOW()),
-- Red Dead Redemption 2 (id=4)
(8, 4, 'RDR2 Steam Key', 'Mã kích hoạt Red Dead Redemption 2 bản quyền Steam.', 1200000, 1500000, NULL, 100, 50, 'Steam Key bản quyền, chơi online và offline, nhận key ngay sau thanh toán.', 'Key chỉ dùng được 1 lần, không hoàn lại.', 1, NOW(), NOW()),
(9, 4, 'RDR2 Ultimate Edition', 'Red Dead Redemption 2 Ultimate Edition (Steam)', 1800000, 2200000, NULL, 50, 30, 'Ultimate Edition bao gồm toàn bộ DLC, vật phẩm đặc biệt, trải nghiệm đầy đủ nhất.', 'Key chỉ dùng được 1 lần, không hoàn lại.', 1, NOW(), NOW()),
-- Duolingo Super (id=5)
(10, 5, 'Duolingo Super 1 năm', 'Tài khoản Duolingo Super sử dụng 1 năm, không quảng cáo.', 900000, 1200000, 365, 100, 50, 'Học ngoại ngữ không quảng cáo, truy cập tính năng Super, sử dụng 1 năm.', 'Không hoàn tiền sau khi giao dịch thành công.', 1, NOW(), NOW()),
(11, 5, 'Duolingo Super 6 tháng', 'Tài khoản Duolingo Super sử dụng 6 tháng.', 500000, 700000, 180, 50, 30, 'Tài khoản Duolingo Super sử dụng 6 tháng, hỗ trợ học offline, không quảng cáo.', 'Không hoàn tiền sau khi giao dịch thành công.', 1, NOW(), NOW()),
-- Netflix Premium (id=6)
(12, 6, 'Netflix Premium 1 tháng', 'Tài khoản Netflix Premium dùng 1 tháng, xem trên 4 thiết bị.', 70000, 120000, 30, 100, 50, 'Xem phim chất lượng 4K, không giới hạn, sử dụng trên 4 thiết bị cùng lúc trong 1 tháng.', 'Lưu ý:\n1. Đọc kỹ phần Thông tin sản phẩm trước khi mua để được bảo hành.\n2. Lưu ý chỉ sử dụng đúng user mang tên mình và không được đổi pass trong quá trình sử dụng.\n3. Hạn sử dụng của sản phẩm KHÔNG cộng dồn khi mua số lượng nhiều sản phẩm. Tài khoản có hạn 1 ngày.\n4. Sản phẩm này phù hợp với những khách hàng chỉ xem một bộ phim, hoặc xem trong một ngày nghỉ, không thường xuyên sử dụng. Nên chỉ cần bỏ ra chi phí cho 1 ngày, mà không cần trả chi phí cả tháng chỉ để dùng một vài lần.\n5. Hệ thống có thể sẽ thay đổi mật khẩu của bạn vì lý do bảo mật.', 1, NOW(), NOW()),
(13, 6, 'Netflix Premium 12 tháng', 'Tài khoản Netflix Premium dùng 12 tháng, chất lượng 4K.', 800000, 1200000, 365, 50, 30, 'Tài khoản Netflix Premium sử dụng 12 tháng, xem phim 4K, tiết kiệm chi phí.', 'Không hoàn tiền sau khi giao dịch thành công.', 1, NOW(), NOW());

-- product_tags (danh sách các tag mẫu)
INSERT INTO product_tags (name, slug)
VALUES 
('action', 'action'),
('adventure', 'adventure'),
('steam', 'steam'),
('học tập', 'hoc-tap'),
('app', 'app'),
('giải trí', 'giai-tri');

-- product_tag_map
INSERT INTO product_tag_map (package_id, tag_id)
VALUES 
(8, 1), -- RDR2 Steam Key: action
(8, 2), -- RDR2 Steam Key: adventure
(8, 3), -- RDR2 Steam Key: steam
(10, 4), -- Duolingo Super 1 năm: học tập
(10, 5), -- Duolingo Super 1 năm: app
(6, 6), -- Spotify Premium 1 tháng: giải trí
(6, 5); -- Spotify Premium 1 tháng: app

-- product_attributes
INSERT INTO product_attributes (package_id, attr_name, attr_value)
VALUES
(8, 'Nhà phát triển', 'Rockstar Games'),
(8, 'Thể loại', 'Hành động, Phiêu lưu'),
(8, 'Nền tảng', 'PC (Steam)'),
(8, 'Ngôn ngữ', 'Tiếng Anh, Tiếng Việt'),
(8, 'Chế độ chơi', 'Singleplayer, Online'),
(10, 'Nhà phát triển', 'Duolingo'),
(10, 'Thời hạn', '1 năm'),
(10, 'Tính năng', 'Không quảng cáo, Học offline'),
(10, 'Nền tảng', 'Web, App, Mobile'),
(12, 'Nhà phát triển', 'Netflix'),
(12, 'Thời hạn', '1 tháng/12 tháng'),
(12, 'Chất lượng phim', 'HD/UHD 4K'),
(12, 'Số thiết bị', '4'),
(12, 'Nền tảng', 'Web, App, Smart TV');

-- product_reviews
INSERT INTO product_reviews (package_id, user_id, rating, review_text, created_at)
VALUES
(1, 1, 5, 'ChatGPT rất hữu ích cho công việc và học tập của tôi.', NOW()),
(4, 2, 5, 'Google Gemini Advanced AI mạnh mẽ, trả lời nhanh.', NOW()),
(6, 3, 4, 'Spotify Premium nghe nhạc chất lượng cao, không quảng cáo.', NOW()),
(8, 1, 5, 'Red Dead Redemption 2 là game thế giới mở tuyệt vời!', NOW()),
(10, 2, 4, 'Duolingo Super giúp tôi học ngoại ngữ hiệu quả hơn.', NOW()),
(12, 3, 5, 'Netflix Premium xem phim 4K cực nét, nhiều phim hay.', NOW());

-- product_documents
INSERT INTO product_documents (package_id, doc_name, doc_url, doc_type)
VALUES
(1, 'Hướng dẫn sử dụng ChatGPT', '/docs/chatgpt-hdsd.pdf', 'pdf'),
(4, 'Hướng dẫn kích hoạt Gemini Advanced', '/docs/gemini-activate.pdf', 'pdf'),
(6, 'Câu hỏi thường gặp Spotify', '/docs/spotify-faq.pdf', 'pdf'),
(8, 'Hướng dẫn cài đặt RDR2', '/docs/rdr2-setup.pdf', 'pdf'),
(10, 'Hướng dẫn sử dụng Duolingo', '/docs/duolingo-guide.pdf', 'pdf'),
(12, 'Hướng dẫn sử dụng Netflix', '/docs/netflix-guide.pdf', 'pdf');

-- product_related
INSERT INTO product_related (package_id, related_package_id, relation_type)
VALUES
(1, 4, 'related'),
(4, 1, 'related'),
(6, 12, 'cross-sell'),
(12, 6, 'cross-sell'),
(8, 1, 'upsell'),
(10, 6, 'related');

-- product_faqs (FAQ cho từng gói sản phẩm)
INSERT INTO product_faqs (package_id, question, answer, display_order)
VALUES
(1, 'Tài khoản ChatGPT Free có dùng được GPT-4 không?', 'Không, ChatGPT Free chỉ dùng được GPT-3.5, muốn dùng GPT-4 cần nâng cấp Plus.', 1),
(2, 'ChatGPT Plus có hỗ trợ plugin không?', 'Có, ChatGPT Plus hỗ trợ plugin và truy cập web.', 1),
(4, 'Google Gemini Advanced có giới hạn số lượt sử dụng không?', 'Không, bạn có thể sử dụng không giới hạn trong thời gian gói còn hiệu lực.', 1),
(6, 'Spotify Premium 1 tháng có tự động gia hạn không?', 'Không, gói này không tự động gia hạn, bạn cần mua lại khi hết hạn.', 1),
(8, 'RDR2 Steam Key có chơi được online không?', 'Có, key bản quyền chơi được cả online và offline.', 1),
(10, 'Duolingo Super có học offline được không?', 'Có, bạn có thể tải bài học về học offline.', 1),
(12, 'Netflix Premium 1 tháng có xem được trên nhiều thiết bị không?', 'Có, bạn có thể xem trên tối đa 4 thiết bị cùng lúc.', 1);




