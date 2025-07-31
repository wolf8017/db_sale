-- =============================
-- FILE TEST CÁC STORED PROCEDURES
-- =============================
-- File này chứa các lệnh CALL để test tất cả stored procedures
-- Chạy file này sau khi đã tạo database và insert dữ liệu mẫu

USE db_sale;

-- =============================
-- CÁCH SỬ DỤNG CÁC PROCEDURES
-- =============================

/*
Cú pháp chung:
CALL TenProcedure(param1, param2, param3, ...);

Các loại parameters:
- IN: Tham số đầu vào
- OUT: Tham số đầu ra (dùng biến @variable)
- INOUT: Tham số vừa vào vừa ra

Ví dụ với OUT parameter:
CALL GetUserStats(1, @total_orders, @total_spent);
SELECT @total_orders, @total_spent;
*/

-- =============================
-- TEST USER AUTHENTICATION PROCEDURES
-- =============================

-- 1. Đăng ký user mới
-- CALL RegisterUser(username, email, password, full_name, phone, gender)
CALL RegisterUser(
    'john_doe',                     -- username
    'john.doe@example.com',         -- email
    'SecurePassword123',            -- password
    'John Doe',                     -- full_name
    '0901234567',                   -- phone
    'Nam'                           -- gender
);

-- 2. Đăng nhập user
-- CALL LoginUser(username_or_email, password)
CALL LoginUser(
    'john_doe',                     -- username_or_email
    'SecurePassword123'             -- password
);

-- 3. Đăng nhập với Google
-- CALL GoogleLogin(google_id, email, full_name, avatar_url)
CALL GoogleLogin(
    'google_user_id_123456',        -- google_id
    'jane.smith@gmail.com',         -- email
    'Jane Smith',                   -- full_name
    'https://lh3.googleusercontent.com/a/avatar.jpg' -- avatar_url
);

-- 4. Cập nhật profile user
-- CALL UpdateUserProfile(user_id, full_name, phone, gender, city, district, ward, address, avatar)
CALL UpdateUserProfile(
    1,                              -- user_id
    'John Doe Updated',             -- full_name
    '0901234568',                   -- phone
    'Nam',                          -- gender
    'Hồ Chí Minh',                  -- city
    'Quận 1',                       -- district
    'Phường Bến Nghé',              -- ward
    '123 Nguyễn Huệ, Quận 1, TP.HCM', -- address
    '/uploads/avatars/user1.jpg'    -- avatar
);

-- 5. Đổi mật khẩu user
-- CALL ChangeUserPassword(user_id, old_password, new_password)
CALL ChangeUserPassword(
    1,                              -- user_id
    'SecurePassword123',            -- old_password
    'NewSecurePassword456'          -- new_password
);

-- 6. Reset login attempts (unlock user)
-- CALL ResetLoginAttempts(username_or_email)
CALL ResetLoginAttempts('john_doe');

-- 7. Thay đổi trạng thái user
-- CALL ChangeUserStatus(user_id, new_status, admin_id, reason)
CALL ChangeUserStatus(
    1,                              -- user_id
    'suspended',                    -- new_status
    2,                              -- admin_id
    'Vi phạm quy định cộng đồng'    -- reason
);

-- 8. Soft delete user
-- CALL SoftDeleteUser(user_id, admin_id, reason)
CALL SoftDeleteUser(
    1,                              -- user_id
    2,                              -- admin_id
    'Yêu cầu xóa tài khoản từ user' -- reason
);

-- =============================
-- TEST ADMIN VALIDATION FUNCTIONS
-- =============================

-- 1. Kiểm tra user có phải admin không (enhanced với full validation)
SELECT IsUserAdmin(101) as is_admin_101;       -- 1 nếu admin101 là admin active không bị lock
SELECT IsUserAdmin(203) as is_admin_203;       -- 0 nếu user203 là customer

-- 2. Kiểm tra quyền cụ thể
SELECT HasUserPermission(101, 'manage_products') as can_manage_products_101;    -- 1 nếu admin có quyền
SELECT HasUserPermission(102, 'manage_products') as can_manage_products_102;    -- 0/1 tùy staff permissions

-- 3. Session validation (comprehensive check for API)
SELECT ValidateUserSession(101, TRUE, 'manage_products') as session_check_admin;
-- Returns: {"valid": true, "error": null, "user_info": {...}, "timestamp": "..."}

SELECT ValidateUserSession(203, TRUE, 'manage_products') as session_check_customer;
-- Returns: {"valid": false, "error": "Access denied: Admin privileges required", ...}

-- 4. Quick auth check (for performance-critical operations)  
SELECT QuickAuthCheck(101, 'admin') as quick_admin_101;     -- 1 nếu là admin
SELECT QuickAuthCheck(203, 'any') as quick_any_203;         -- 1 nếu là user hợp lệ

-- 5. Lấy thông tin user cho logging
SELECT GetUserInfo(101) as admin_info_101;     -- JSON với thông tin đầy đủ
SELECT GetUserInfo(203) as customer_info_203;

-- =============================
-- TEST PRODUCT CATEGORY PROCEDURES
-- =============================

-- 9. Tạo category mới
-- CALL CreateProductCategory(name, slug, description, image_url, parent_id, display_order, status)
CALL CreateProductCategory(
    'Dịch vụ AI Premium',           -- name
    'ai-premium-services',          -- slug
    'Các dịch vụ AI cao cấp như ChatGPT Plus, Claude Pro', -- description
    '/images/categories/ai-premium.jpg', -- image_url
    NULL,                           -- parent_id (category gốc)
    10,                             -- display_order
    1                               -- status (active)
);

-- 10. Lấy thông tin category theo ID
-- CALL GetProductCategoryById(category_id)
CALL GetProductCategoryById(1);

-- 11. Lấy danh sách categories
-- CALL GetProductCategories(parent_id, status, limit_count, offset_count)
CALL GetProductCategories(
    NULL,   -- parent_id (NULL = tất cả)
    1,      -- status (1 = active)
    10,     -- limit
    0       -- offset
);

-- 12. Lấy categories với phân trang
-- CALL GetProductCategoriesPaginated(parent_id, status, page_size, page_number)
CALL GetProductCategoriesPaginated(
    NULL,   -- parent_id
    1,      -- status
    5,      -- page_size
    1       -- page_number
);

-- 13. Cập nhật category
-- CALL UpdateProductCategory(category_id, name, slug, description, image_url, parent_id, display_order, status)
CALL UpdateProductCategory(
    1,                              -- category_id
    'Steam Wallet & Game Cards',    -- name
    'steam-wallet-game-cards',      -- slug
    'Thẻ nạp Steam và các game cards khác', -- description
    '/images/categories/steam-updated.jpg', -- image_url
    NULL,                           -- parent_id
    1,                              -- display_order
    1                               -- status
);

-- 14. Soft delete category
-- CALL SoftDeleteProductCategory(category_id, admin_id, reason)
CALL SoftDeleteProductCategory(
    5,                              -- category_id
    2,                              -- admin_id
    'Category không còn sử dụng'    -- reason
);

-- 15. Hard delete category
-- CALL HardDeleteProductCategory(category_id, admin_id, reason)
CALL HardDeleteProductCategory(
    5,                              -- category_id
    2,                              -- admin_id
    'Danh mục không còn sử dụng và cần xóa vĩnh viễn'
);

-- 16. Lấy cây danh mục (hierarchical)
-- CALL GetCategoryTree(parent_id, max_depth)
CALL GetCategoryTree(
    NULL,   -- parent_id (NULL = từ root)
    3       -- max_depth (độ sâu tối đa)
);

-- 17. Lấy cây danh mục con của một category
CALL GetCategoryTree(
    1,      -- parent_id (lấy con của category 1)
    2       -- max_depth
);

-- 18. Cập nhật thứ tự hiển thị categories
-- CALL UpdateCategoryDisplayOrder(categories_json)
CALL UpdateCategoryDisplayOrder(
    '[
        {"id": 1, "display_order": 1},
        {"id": 2, "display_order": 2},
        {"id": 3, "display_order": 3},
        {"id": 4, "display_order": 4}
    ]'
);

-- =============================
-- TEST PRODUCT & PACKAGE PROCEDURES
-- =============================

-- 19. Tạo sản phẩm với nhiều packages cùng lúc (mối quan hệ 1-N)
-- CALL CreateProductWithPackages(product_name, product_slug, category_id, product_description, product_image_url, product_status, packages_json)
CALL CreateProductWithPackages(
    'Tài khoản Netflix Premium',                    -- product_name
    'netflix-premium',                              -- product_slug
    1,                                              -- category_id
    'Tài khoản Netflix Premium chất lượng cao',    -- product_description
    '/images/netflix.jpg',                          -- product_image_url
    1,                                              -- product_status
    '[
        {
            "name": "Netflix Premium 1 tháng",
            "description": "Gói 1 tháng xem không giới hạn",
            "price": 180000,
            "old_price": 200000,
            "stock_quantity": 100,
            "package_type": "rental"
        },
        {
            "name": "Netflix Premium 3 tháng",
            "description": "Gói 3 tháng tiết kiệm hơn",
            "price": 500000,
            "old_price": 600000,
            "stock_quantity": 50,
            "package_type": "rental"
        },
        {
            "name": "Netflix Premium 6 tháng",
            "description": "Gói 6 tháng giá tốt nhất",
            "price": 900000,
            "old_price": 1200000,
            "stock_quantity": 30,
            "package_type": "rental"
        }
    ]'                                              -- packages_json (1 product -> N packages)
);

-- 20. Lấy thông tin product với tất cả packages (mối quan hệ 1-N)
-- CALL GetProductWithPackages(product_id)
CALL GetProductWithPackages(1);

-- 21. Tạo package đơn lẻ cho product đã có sẵn
-- CALL CreatePackage(product_id, name, description, price, old_price, duration_days, stock_quantity, package_type, details, note, max_cart_quantity, status, admin_id)
CALL CreatePackage(
    1,                              -- product_id (đã có sẵn)
    'Netflix Premium 12 tháng',     -- name
    'Gói 12 tháng siêu tiết kiệm',  -- description
    1500000,                        -- price
    2000000,                        -- old_price
    365,                            -- duration_days
    20,                             -- stock_quantity
    'rental',                       -- package_type
    'Gói 12 tháng Netflix Premium với đầy đủ tính năng 4K HDR', -- details
    'Chỉ áp dụng cho tài khoản mới', -- note
    1,                              -- max_cart_quantity
    1,                              -- status
    101                             -- admin_id (sẽ check quyền + auto log)
);

-- 22. Tạo package không có admin_id (backward compatible)
CALL CreatePackage(
    1,                              -- product_id
    'Netflix Premium 1 tuần',       -- name
    'Gói dùng thử 1 tuần',         -- description
    50000,                          -- price
    NULL,                           -- old_price
    7,                              -- duration_days
    100,                            -- stock_quantity
    'rental',                       -- package_type
    'Gói dùng thử ngắn hạn',       -- details
    NULL,                           -- note
    0,                              -- max_cart_quantity
    1,                              -- status
    NULL                            -- admin_id (NULL = không check admin, không log)
);

-- 23. Cập nhật 1 package cụ thể
-- CALL UpdatePackage(package_id, name, description, price, old_price, stock_quantity, package_type, status)
CALL UpdatePackage(
    1,                              -- package_id
    'Netflix Premium 1 tháng VIP',  -- name
    'Gói 1 tháng với chất lượng 4K', -- description
    190000,                         -- price
    220000,                         -- old_price
    80,                             -- stock_quantity
    'rental',                       -- package_type
    1                               -- status
);

-- 24. Xóa package (soft delete)
-- CALL DeletePackage(package_id, soft_delete)
CALL DeletePackage(2, TRUE);        -- package_id=2, soft_delete=TRUE

-- 25. Xóa package (hard delete)
CALL DeletePackage(3, FALSE);       -- package_id=3, soft_delete=FALSE

-- 26. Thống kê chi tiết products-packages
-- CALL GetProductPackageStats(category_id, package_type)
CALL GetProductPackageStats(1, NULL);  -- category_id=1, all package_types
CALL GetProductPackageStats(NULL, 'rental');  -- all categories, rental type only
CALL GetProductPackageStats(NULL, NULL);      -- all categories, all types

-- 27. Kiểm tra tính nhất quán dữ liệu
-- CALL ValidateProductPackageConsistency()
CALL ValidateProductPackageConsistency();

-- 28. Sửa lỗi tính nhất quán dữ liệu
-- CALL FixProductPackageConsistency()
CALL FixProductPackageConsistency();

-- 29. Tạo sản phẩm đơn giản
-- CALL CreateProduct(name, slug, category_id, description, image_url, status)
CALL CreateProduct(
    'Steam Wallet $50',             -- name
    'steam-wallet-50',              -- slug
    1,                              -- category_id
    'Thẻ nạp Steam Wallet $50 USD', -- description
    '/images/steam-50.jpg',         -- image_url
    1                               -- status
);

-- 30. Lấy thông tin product theo ID
-- CALL GetProductById(product_id)
CALL GetProductById(1);

-- 31. Lấy danh sách products
-- CALL GetProducts(category_id, status, sort_by, sort_direction, limit_count, offset_count)
CALL GetProducts(
    NULL,       -- category_id (tất cả)
    1,          -- status (active)
    'created_at', -- sort_by
    'DESC',     -- sort_direction
    10,         -- limit
    0           -- offset
);

-- 32. Cập nhật product
-- CALL UpdateProduct(product_id, name, slug, category_id, description, image_url, status)
CALL UpdateProduct(
    1,                              -- product_id
    'Steam Wallet Updated',         -- name
    'steam-wallet-updated',         -- slug
    1,                              -- category_id
    'Thẻ nạp Steam Wallet cập nhật', -- description
    '/images/steam-updated.jpg',    -- image_url
    1                               -- status
);

-- 33. Soft delete product (với admin validation & logging)
-- CALL SoftDeleteProduct(product_id, admin_id, reason)
CALL SoftDeleteProduct(
    1,                              -- product_id
    101,                            -- admin_id (sẽ check quyền + auto log)
    'Sản phẩm tạm thời ngừng bán'   -- reason
);

-- 34. Hard delete product
-- CALL HardDeleteProduct(product_id, admin_id, reason)
CALL HardDeleteProduct(
    5,                              -- product_id
    101,                            -- admin_id
    'Sản phẩm vi phạm chính sách, cần xóa vĩnh viễn'
);

-- =============================
-- TEST PRODUCT LOGS SYSTEM
-- =============================

-- 33. Log sự kiện product thủ công
-- CALL LogProductEvent(product_id, event_type, event_description, old_data, new_data, user_id, user_type, ip_address, user_agent, severity_level, tags, additional_data)
CALL LogProductEvent(
    1,                              -- product_id
    'product_created',              -- event_type
    'Tạo sản phẩm mới: Microsoft Office 365', -- event_description
    NULL,                           -- old_data (không có vì là tạo mới)
    '{"name": "Microsoft Office 365", "category_id": 1, "status": 1}', -- new_data
    101,                            -- user_id (admin)
    'admin',                        -- user_type
    '192.168.1.100',               -- ip_address
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', -- user_agent
    'medium',                       -- severity_level
    '["product", "creation", "microsoft"]', -- tags
    '{"source": "admin_panel", "session_id": "sess_123456"}' -- additional_data
);

-- 34. Log sự kiện package
-- CALL LogPackageEvent(package_id, event_type, event_description, old_data, new_data, user_id, user_type, ip_address, user_agent, severity_level, tags, additional_data)
CALL LogPackageEvent(
    1,                              -- package_id
    'price_changed',                -- event_type
    'Thay đổi giá từ 1,200,000 VND xuống 1,000,000 VND', -- event_description
    '{"price": 1200000, "old_price": null}', -- old_data
    '{"price": 1000000, "old_price": 1200000}', -- new_data
    101,                            -- user_id
    'admin',                        -- user_type
    '192.168.1.100',               -- ip_address
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'high',                         -- severity_level (giá thì quan trọng)
    '["package", "price", "discount"]',
    '{"reason": "promotion_campaign", "campaign_id": "SALE2024"}'
);

-- 35. Log nhanh cho các thao tác đơn giản
-- CALL QuickLogProductAction(product_id, action, description, user_id, user_type, severity)
CALL QuickLogProductAction(
    1,                              -- product_id
    'product_viewed',               -- action
    'Admin xem chi tiết sản phẩm từ dashboard', -- description
    101,                            -- user_id
    'admin',                        -- user_type
    'low'                           -- severity
);

CALL QuickLogProductAction(
    1,                              -- product_id
    'favorite_added',               -- action
    'Khách hàng thêm vào danh sách yêu thích', -- description
    203,                            -- user_id
    'customer',                     -- user_type
    'low'                           -- severity
);

-- 36. Lấy logs theo Product
-- CALL GetProductLogs(product_id, limit, offset, event_type, severity_level, start_date, end_date)
CALL GetProductLogs(1, 20, 0, NULL, NULL, NULL, NULL);

-- 37. Lấy logs theo Package
-- CALL GetPackageLogs(package_id, limit, offset, event_type, severity_level, start_date, end_date)
CALL GetPackageLogs(1, 20, 0, NULL, NULL, NULL, NULL);

-- 38. Lấy logs có mức độ quan trọng cao
CALL GetProductLogs(1, 10, 0, NULL, 'high', NULL, NULL);

-- 39. Lấy logs về thay đổi giá
CALL GetProductLogs(1, 10, 0, 'price_changed', NULL, NULL, NULL);

-- 40. Thống kê logs
-- CALL GetLogStatistics(product_id, package_id, start_date, end_date)
CALL GetLogStatistics(1, NULL, '2024-01-01', '2024-12-31');
CALL GetLogStatistics(NULL, 1, '2024-01-01', '2024-12-31');

-- 41. Test admin validation với user không có quyền (sẽ báo lỗi)
-- CALL SoftDeleteProduct(1, 203, 'Customer trying to delete');
-- → Error: 'Người dùng không có quyền admin hoặc không tồn tại'

-- 42. Test với admin không có quyền manage_products (sẽ báo lỗi nếu staff không có permission)
-- CALL SoftDeleteProduct(1, 102, 'Staff without permission');
-- → Error: 'Không có quyền quản lý sản phẩm'

-- 43. Tạo product với admin validation
-- CALL CreateProduct(name, slug, category_id, description, image_url, status, admin_id)
CALL CreateProduct(
    'Adobe Photoshop 2024',        -- name
    'adobe-photoshop-2024',        -- slug
    2,                              -- category_id
    'Phần mềm chỉnh sửa ảnh chuyên nghiệp', -- description
    'https://example.com/ps2024.jpg', -- image_url
    1,                              -- status
    101                             -- admin_id (required - sẽ check quyền + auto log)
);

-- 44. Tạo product không có admin_id (backward compatible - không check, không log)
CALL CreateProduct(
    'Free Product',                 -- name
    'free-product',                 -- slug
    1,                              -- category_id
    'Sản phẩm miễn phí',           -- description
    NULL,                           -- image_url
    1,                              -- status
    NULL                            -- admin_id (NULL = không check admin, không log)
);

-- =============================
-- TEST LOGS ANALYTICS & MONITORING
-- =============================

-- 45. Truy vấn logs trực tiếp với các filter khác nhau

-- Xem 10 logs gần nhất
SELECT 
    id, product_id, package_id, event_type, event_description,
    user_type, severity_level, created_at
FROM product_logs 
ORDER BY created_at DESC 
LIMIT 10;

-- Đếm số lượng logs theo loại sự kiện
SELECT 
    event_type, 
    COUNT(*) as count,
    COUNT(DISTINCT product_id) as unique_products,
    COUNT(DISTINCT package_id) as unique_packages
FROM product_logs 
GROUP BY event_type 
ORDER BY count DESC;

-- Xem logs có mức độ critical
SELECT 
    id, product_id, package_id, event_type, event_description,
    user_id, created_at, old_data, new_data
FROM product_logs 
WHERE severity_level = 'critical'
ORDER BY created_at DESC;

-- Top 10 sản phẩm có nhiều hoạt động nhất
SELECT 
    p.name as product_name,
    COUNT(pl.id) as total_activities,
    COUNT(CASE WHEN pl.event_type LIKE '%delete%' THEN 1 END) as delete_actions,
    COUNT(CASE WHEN pl.event_type LIKE '%update%' THEN 1 END) as update_actions,
    COUNT(CASE WHEN pl.event_type LIKE '%create%' THEN 1 END) as create_actions,
    MAX(pl.created_at) as last_activity
FROM products p
LEFT JOIN product_logs pl ON p.id = pl.product_id
GROUP BY p.id, p.name
ORDER BY total_activities DESC
LIMIT 10;

-- Admin nào thao tác nhiều nhất
SELECT 
    u.username,
    COUNT(pl.id) as total_actions,
    COUNT(DISTINCT pl.product_id) as unique_products_affected,
    MIN(pl.created_at) as first_action,
    MAX(pl.created_at) as last_action
FROM users u
JOIN product_logs pl ON u.id = pl.user_id
WHERE pl.user_type = 'admin'
GROUP BY u.id, u.username
ORDER BY total_actions DESC;

-- Hoạt động theo giờ trong ngày (để phát hiện pattern)
SELECT 
    HOUR(created_at) as hour_of_day,
    COUNT(*) as activity_count,
    COUNT(CASE WHEN severity_level = 'high' THEN 1 END) as high_severity_count
FROM product_logs
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY HOUR(created_at)
ORDER BY hour_of_day;

-- =============================
-- TEST LOGS CLEANUP PROCEDURES
-- =============================

-- 46. Xem sẽ xóa bao nhiều logs cũ hơn 90 ngày (dry run)
-- CALL CleanupOldLogs(days_to_keep, severity_to_keep, dry_run)
CALL CleanupOldLogs(90, 'critical', TRUE);

-- 47. Thực sự xóa logs cũ hơn 90 ngày, nhưng giữ lại logs critical
-- CALL CleanupOldLogs(90, 'critical', FALSE);

-- 33. Lấy sản phẩm theo category (không bao gồm subcategories)
-- CALL GetProductsByCategory(category_id, include_subcategories, limit_count, offset_count)
CALL GetProductsByCategory(
    1,      -- category_id
    FALSE,  -- include_subcategories
    20,     -- limit
    0       -- offset
);

-- 34. Lấy sản phẩm theo category (bao gồm cả subcategories)
CALL GetProductsByCategory(
    1,      -- category_id
    TRUE,   -- include_subcategories
    20,     -- limit
    0       -- offset
);

-- 35. Đếm số lượng products
-- CALL CountProducts(category_id, status)
CALL CountProducts(
    NULL,   -- category_id (tất cả)
    1       -- status (active)
);

-- =============================
-- TEST PACKAGE REVIEW PROCEDURES
-- =============================

-- 36. Tạo đánh giá cho package
-- CALL CreatePackageReview(package_id, user_id, rating, review_text)
CALL CreatePackageReview(
    1,                              -- package_id
    101,                            -- user_id
    5,                              -- rating (1-5 sao)
    'Gói Netflix 1 tháng rất tốt, chất lượng 4K, không lag. Rất hài lòng!'
);

-- 37. Lấy đánh giá của package với phân trang
-- CALL GetPackageReviews(package_id, limit_count, offset_count)
CALL GetPackageReviews(
    1,      -- package_id
    10,     -- limit
    0       -- offset
);

-- 38. Thống kê đánh giá chi tiết của package
-- CALL GetPackageReviewStats(package_id)
CALL GetPackageReviewStats(1);      -- package_id=1

-- 39. Tổng hợp đánh giá của tất cả packages trong product
-- CALL GetProductReviewsSummary(product_id)
CALL GetProductReviewsSummary(1);   -- product_id=1

-- 40. Cập nhật đánh giá
-- CALL UpdatePackageReview(review_id, rating, review_text)
CALL UpdatePackageReview(
    1,                              -- review_id
    4,                              -- rating mới
    'Cập nhật: Gói tốt nhưng đôi khi hơi chậm vào giờ cao điểm'
);

-- 41. Xóa đánh giá (chỉ user tạo mới được xóa)
-- CALL DeletePackageReview(review_id, user_id)
CALL DeletePackageReview(
    1,      -- review_id
    101     -- user_id (phải trùng với user tạo review)
);

-- =============================
-- TEST INVOICE PROCEDURES
-- =============================

-- 42. Tạo hóa đơn cho đơn hàng đã hoàn thành
-- CALL CreateInvoiceForOrder(order_id)
CALL CreateInvoiceForOrder(1);      -- order_id=1

-- =============================
-- TEST VAT MANAGEMENT PROCEDURES
-- =============================

-- 43. Xem cấu hình VAT hiện tại
-- CALL GetVatSettings()
CALL GetVatSettings();

-- 44. Cập nhật VAT rate cho loại 'sale' (hàng hóa)
-- CALL UpdateVatRate(package_type, vat_rate, description)
CALL UpdateVatRate(
    'sale',                         -- package_type
    0.008,                          -- vat_rate (0.8%)
    'VAT mới cho hàng hóa - giảm từ 1% xuống 0.8%'  -- description
);

-- 45. Cập nhật VAT rate cho loại 'rental' (dịch vụ)
CALL UpdateVatRate(
    'rental',                       -- package_type
    0.08,                           -- vat_rate (8%)
    'VAT mới cho dịch vụ - tăng từ 5% lên 8%'  -- description
);

-- 46. Vô hiệu hóa VAT setting tạm thời
-- CALL ToggleVatSetting(package_type, is_active)
CALL ToggleVatSetting(
    'sale',                         -- package_type
    0                               -- is_active (0 = inactive)
);

-- 47. Kích hoạt lại VAT setting
CALL ToggleVatSetting(
    'sale',                         -- package_type
    1                               -- is_active (1 = active)
);

-- =============================
-- TEST PROCEDURES VỚI OUTPUT PARAMETERS
-- =============================

/*
Một số procedures có OUT parameters, cần dùng biến để nhận kết quả:

-- Ví dụ với procedure có OUT parameter:
CALL GetUserStatistics(1, @total_orders, @total_amount, @avg_order_value);
SELECT @total_orders as total_orders, @total_amount as total_amount, @avg_order_value as avg_order_value;

-- Ví dụ với procedure trả về status:
CALL ProcessOrder(1, @result_code, @message);
SELECT @result_code as result_code, @message as message;
*/

-- =============================
-- TEST CATEGORY LOGGING & ADMIN VALIDATION PROCEDURES
-- =============================

-- 48. Test Category Admin Validation Functions
SELECT 'Testing Category Admin Functions' as test_section;

-- Test IsUserAdmin function
SELECT IsUserAdmin(1) as is_admin_user_1, IsUserAdmin(999) as is_admin_nonexistent;

-- Test HasUserPermission function for categories
SELECT HasUserPermission(1, 'manage_categories') as has_category_permission;

-- 49. Test CreateProductCategory with admin validation
SELECT 'Testing CreateProductCategory with Admin Validation' as test_name;

-- Tạo danh mục với admin validation
CALL CreateProductCategory(
    'Electronics', 'electronics', NULL, 'Thiết bị điện tử', 
    '/images/electronics.jpg', 'fa-laptop', 1, 1, 1,
    'Electronics | Shop', 'Thiết bị điện tử chất lượng cao', 'electronics, technology',
    1, 1
);

-- Tạo danh mục con
CALL CreateProductCategory(
    'Smartphones', 'smartphones', 1, 'Điện thoại thông minh', 
    '/images/phones.jpg', 'fa-mobile', 1, 1, 0,
    'Smartphones | Electronics', 'Điện thoại di động thông minh', 'phone, mobile, smartphone',
    1, 1
);

-- 50. Test UpdateProductCategory with admin validation
SELECT 'Testing UpdateProductCategory with Admin Validation' as test_name;

-- Cập nhật danh mục với admin validation
CALL UpdateProductCategory(
    1, 'Consumer Electronics', 'consumer-electronics', NULL, 
    'Thiết bị điện tử tiêu dùng cao cấp', '/images/consumer-electronics.jpg', 
    'fa-tv', 2, 1, 1, 'Consumer Electronics | Shop', 
    'Thiết bị điện tử tiêu dùng chất lượng', 'electronics, consumer, technology',
    1, 1
);

-- 51. Test Category Logging System
SELECT 'Testing Category Logging System' as test_name;

-- Test LogCategoryEvent procedure
CALL LogCategoryEvent(
    1, 'category_featured_changed',
    'Admin user thay đổi trạng thái featured của danh mục Electronics',
    JSON_OBJECT('is_featured', 0),
    JSON_OBJECT('is_featured', 1),
    1, 'admin', NULL, NULL, 'medium',
    '["category", "featured", "admin_action"]',
    JSON_OBJECT('action', 'toggle_featured', 'previous_value', 0, 'new_value', 1)
);

-- 52. Test GetCategoryLogs
SELECT 'Testing GetCategoryLogs' as test_name;

-- Lấy logs theo category
CALL GetCategoryLogs(1, 10, 0, NULL, NULL, NULL, NULL);

-- Lấy logs theo event type cụ thể
CALL GetCategoryLogs(1, 5, 0, 'category_created', NULL, NULL, NULL);

-- 53. Test SoftDeleteProductCategory with admin validation and logging
SELECT 'Testing SoftDeleteProductCategory with Admin Validation' as test_name;

-- Xóa mềm danh mục con trước (không có products)
CALL SoftDeleteProductCategory(2, 1, 'Danh mục không còn phù hợp với strategy mới');

-- 54. Test Enhanced Category Analytics
SELECT 'Testing Category Analytics from Logs' as test_name;

-- Thống kê category events
SELECT 
    pc.name as category_name,
    pl.event_type,
    COUNT(*) as event_count,
    MIN(pl.created_at) as first_event,
    MAX(pl.created_at) as last_event
FROM product_categories pc
LEFT JOIN product_logs pl ON pc.id = pl.category_id
WHERE pl.category_id IS NOT NULL
GROUP BY pc.id, pc.name, pl.event_type
ORDER BY event_count DESC;

-- Admin activity trên categories
SELECT 
    u.username,
    COUNT(pl.id) as category_actions,
    COUNT(DISTINCT pl.category_id) as unique_categories_affected,
    GROUP_CONCAT(DISTINCT pl.event_type) as action_types
FROM users u
JOIN product_logs pl ON u.id = pl.user_id
WHERE pl.category_id IS NOT NULL AND pl.user_type = 'admin'
GROUP BY u.id, u.username
ORDER BY category_actions DESC;

-- Category logs severity distribution
SELECT 
    severity_level,
    COUNT(*) as log_count,
    COUNT(DISTINCT category_id) as categories_affected
FROM product_logs 
WHERE category_id IS NOT NULL
GROUP BY severity_level
ORDER BY log_count DESC;

-- 55. Test Category Tree after operations
SELECT 'Testing Category Tree After Operations' as test_name;

-- Xem cây danh mục sau các thao tác
CALL GetCategoryTree(NULL, 1);

-- Lấy danh mục còn active
CALL GetProductCategories(NULL, 1, NULL, NULL);

-- =============================
-- GHI CHÚ QUAN TRỌNG
-- =============================

/*
1. Chạy các test này theo thứ tự để tránh lỗi foreign key
2. Một số procedures cần dữ liệu mẫu đã tồn tại (chạy sample_sale.sql trước)
3. Procedures có OUT parameters cần dùng biến @variable để nhận kết quả
4. Kiểm tra kết quả bằng SELECT sau mỗi CALL để đảm bảo procedure hoạt động đúng
5. Một số procedures có validation, có thể fail nếu dữ liệu không hợp lệ

Thứ tự chạy file:
1. db_sale.sql (tạo database + procedures)
2. sample_sale.sql (insert dữ liệu mẫu)
3. test_procedures.sql (file này - test procedures)
*/