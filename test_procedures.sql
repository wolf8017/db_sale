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

-- 21. Cập nhật 1 package cụ thể
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

-- 22. Xóa package (soft delete)
-- CALL DeletePackage(package_id, soft_delete)
CALL DeletePackage(2, TRUE);        -- package_id=2, soft_delete=TRUE

-- 23. Xóa package (hard delete)
CALL DeletePackage(3, FALSE);       -- package_id=3, soft_delete=FALSE

-- 24. Thống kê chi tiết products-packages
-- CALL GetProductPackageStats(category_id, package_type)
CALL GetProductPackageStats(1, NULL);  -- category_id=1, all package_types
CALL GetProductPackageStats(NULL, 'rental');  -- all categories, rental type only
CALL GetProductPackageStats(NULL, NULL);      -- all categories, all types

-- 25. Kiểm tra tính nhất quán dữ liệu
-- CALL ValidateProductPackageConsistency()
CALL ValidateProductPackageConsistency();

-- 26. Sửa lỗi tính nhất quán dữ liệu
-- CALL FixProductPackageConsistency()
CALL FixProductPackageConsistency();

-- 27. Tạo sản phẩm đơn giản
-- CALL CreateProduct(name, slug, category_id, description, image_url, status)
CALL CreateProduct(
    'Steam Wallet $50',             -- name
    'steam-wallet-50',              -- slug
    1,                              -- category_id
    'Thẻ nạp Steam Wallet $50 USD', -- description
    '/images/steam-50.jpg',         -- image_url
    1                               -- status
);

-- 28. Lấy thông tin product theo ID
-- CALL GetProductById(product_id)
CALL GetProductById(1);

-- 29. Lấy danh sách products
-- CALL GetProducts(category_id, status, sort_by, sort_direction, limit_count, offset_count)
CALL GetProducts(
    NULL,       -- category_id (tất cả)
    1,          -- status (active)
    'created_at', -- sort_by
    'DESC',     -- sort_direction
    10,         -- limit
    0           -- offset
);

-- 30. Cập nhật product
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

-- 31. Soft delete product
-- CALL SoftDeleteProduct(product_id, admin_id, reason)
CALL SoftDeleteProduct(
    1,                              -- product_id
    2,                              -- admin_id
    'Sản phẩm tạm thời ngừng bán'   -- reason
);

-- 32. Hard delete product
-- CALL HardDeleteProduct(product_id, admin_id, reason)
CALL HardDeleteProduct(
    5,                              -- product_id
    2,                              -- admin_id
    'Sản phẩm vi phạm chính sách, cần xóa vĩnh viễn'
);

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